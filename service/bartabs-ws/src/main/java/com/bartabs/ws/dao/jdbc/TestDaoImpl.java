package com.bartabs.ws.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.bartabs.ws.dao.TestDao;
import com.bartabs.ws.model.Shop;

@Repository
public class TestDaoImpl implements TestDao {

	@Autowired
	NamedParameterJdbcTemplate template;

	@Override
	public Shop getData() {
		final String sql = "SELECT name FROM bartabs.test where objectid = :objectId";

		final MapSqlParameterSource params = new MapSqlParameterSource();
		params.addValue("objectId", "1");
		return template.queryForObject(sql, params, new RowMapper<Shop>() {

			@Override
			public Shop mapRow(ResultSet rs, int arg1) throws SQLException {
				final Shop shop = new Shop();
				shop.setName(rs.getString("name"));

				return shop;
			}

		});
	}

}
