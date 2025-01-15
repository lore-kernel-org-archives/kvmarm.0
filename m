Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8244B2459D5;
	Wed, 15 Jan 2025 13:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736946025; cv=none; b=j9GgIEjBoU3/Df3RlwlFcykAaCqtFxlEZG7n1B9gA75z5xoUtGemSzAFomDBYuVR9A+F1m/enAkgL2/gt3BgIviiNcRd+Nttmjh+3cjobpGl0cQrsDA82Vx8eKWysVOaOL3xqUZo3AH1sTFQq//wpktna2B4t7w+0oJE/00ELQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736946025; c=relaxed/simple;
	bh=U0bl6y0YBn/kdTJqiabz3QWmzU2o1jrN/faqMQfvqdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qJXwDbI6v6lKmAQm49t4X9rxp96zfi/fo3adAZalqYzurtvFaaFMuQYHmhHmcUQ5wKTtCh4C7IQMxq5QHyUkC0h0HTtBikB0LizOW6F8N5V9lI9WfmUIabAgx1UUWLKL5y0HESQlVVd/RbB1+29zYR/VrGJu3fhwXrtp5IjUz7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJZ7K9rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJZ7K9rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11807C4CEDF;
	Wed, 15 Jan 2025 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736946025;
	bh=U0bl6y0YBn/kdTJqiabz3QWmzU2o1jrN/faqMQfvqdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QJZ7K9rknsXfd/r00PhA3uD9zyHTyHpUiyumyM5Qz0IXdyH7kux5pU0elQmREeoL2
	 iH/jZ2lMokG6eTZzJ3d5co7HIiBBEdMF+yW2K4zxnnWih9M/dY7Dzz0xGd9OOOQ582
	 g4D2OcbUoiPlwW51z+31BAyM5V8k04g5WmKdhlRcHhNoaRDQwEfMf/sD2RfwGqKcaX
	 P83ahgQs4u+7KQWZFrzu0q5wdhiGinhqpnpeJLIwpvYENXvPzHvXw2mas4H6TBO6ML
	 gwznKmT67Vipxys3QGrAy87h6xI3r5BhgPrQVUn75oF+VuU8p7A+O43JsY+4D5H0Tc
	 7bHnxb3Dcs8GQ==
Date: Wed, 15 Jan 2025 13:00:18 +0000
From: Mark Brown <broonie@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: Rob Herring <robh@kernel.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, oliver.upton@linux.dev,
	suzuki.poulose@arm.com, coresight@lists.linaro.org,
	James Clark <james.clark@arm.com>, Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>, James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/10] arm64/sysreg: Add a comment that the sysreg
 file should be sorted
Message-ID: <3b0afabc-49a7-47cb-84bc-5d1017693be3@sirena.org.uk>
References: <20250107113252.260631-1-james.clark@linaro.org>
 <20250107113252.260631-5-james.clark@linaro.org>
 <87frloqjso.wl-maz@kernel.org>
 <760969b6-18b7-42ac-9524-2f1f845b3703@linaro.org>
 <86jzaywtea.wl-maz@kernel.org>
 <CAL_JsqJFgunOVqpXnj+0HQ_HYbbVrtjCTJ25KzJHhjay-0i5tQ@mail.gmail.com>
 <b4082b98-e234-4825-9935-971a630f438b@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FA7VJeg3rZaKM37v"
Content-Disposition: inline
In-Reply-To: <b4082b98-e234-4825-9935-971a630f438b@linaro.org>
X-Cookie: Phasers locked on target, Captain.


--FA7VJeg3rZaKM37v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2025 at 10:43:07AM +0000, James Clark wrote:

> Actually I updated gen-sysreg.awk to fail the build if it's not sorted, was
> just about to post it. I don't know if a build failure or a warning is
> preferred but I can do either.

A build failure is probably safer, people are more likely to notice it
and warnings from things that aren't the compiler can get a bit shaky
with tooling sometimes.

--FA7VJeg3rZaKM37v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeHsWEACgkQJNaLcl1U
h9AKiAf/T0593rB+5OtpW6l8XdCx2oJ9KJOa4vmhVmJ7ULEl4UHP7PW3IhIt74dD
l1ALeGJsqbZN0F5ZuqCMZnIghZuEyp5MmiRTGI8BCvXwCUsXC53xzPJJrE675KvF
eb3HGQ7ZWEGIX8IqRqfJGwKwULLn3lxwCIg8ZHNoo93XyhzakKDfdA8Gn+0EoTye
cdLFS5VYYEWyAXgmzWxwOMORUCC5EA9Zi5K7AhL5tRf3g7j291NsZyEb0BiKg6pM
H+r6FCSi4SyjIQrqnczzEgUdW/yeiYIvWP07nPElK1qE3tOfOiQ5NncFaWPoPpml
LK1E81LY1CQXLzJXJL/JnDNvGkBDMA==
=a7cL
-----END PGP SIGNATURE-----

--FA7VJeg3rZaKM37v--
