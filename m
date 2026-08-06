Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D1432B112;
	Thu,  6 Aug 2026 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786034641; cv=none; b=K36Lkj7dcrQ09HgC/waOJb/gb8/hWDNv4kIdrYYQqd6jIEvLwUhvh6dGNvdR+v3wpBUBmcLlYkx40rwoYUfrU5gqybbqYVAVnXRMDi3iCDEMFSs7JRoywDe8Kt77FZIk8NxSlSI5r9jw1qCehMxt88WZDtYFeUbpbDapny9IiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786034641; c=relaxed/simple;
	bh=aL0qqyKUNKdGc6TPf8W+C7QKQOLgzctVYQJnrsCKsDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLHvEQrNln1AMvZJnal2zeGj9xLGScQFj66UEqp8PNBj4qYTkVEYIO8mXtoiq3t3N4t/IXHWcDTUS90YFiZU19K8ov5VjcEijTKBTpIgf4PGC3Ws6f7Gz2b3yKnlciNv4da/Z6Y2IhFuoEw+PQMiBmk7o3MmWF5cW7G+KXhxZ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Szzky8jc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Szzky8jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD031F000E9;
	Thu,  6 Aug 2026 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786034638;
	bh=rRvspEA69QHTSmFYmJ7xI62Dl0Wi2xgTu6YIPBhnfcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Szzky8jcw6zFtAhLVPaVLAFuxxMZPofv3ZGZHH6bnr8pOqBmbRr6bMCTxhYp6mg5G
	 ojDbMzfV2D6J0nvHm9En3hkR5u59YBCSl9mx2OdJhOpoY8/0YnfOxDc+yzAWSZif6V
	 w0zed+Qh1K1XNkvtxBRqVCL7ufwW9oeso1n5TI3tPGZ9wmXPLFCMCmTQ09ljfZ2afL
	 haLU/lSCzB8FJBLjJgwBZvyhVLrCLEGVVOXjQ9piec6RM9S1JK/ocTD/MTpgJzbsoA
	 VFbziWqiSfGXC6OntgIfm4kXDBsRJL2QZ19UZ88H7Ek9+x3d81iyU04Amp01+Z1P9l
	 vDQioT9n+NlXA==
Date: Thu, 6 Aug 2026 17:43:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <90cf17cb-94da-4863-bded-825ea6136186@sirena.org.uk>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-3-fd8c40f5ad88@kernel.org>
 <enhoyivbkdaacgyazubgfzftt34xjemtrybvgpuqvr4czjtbhm@7qvrce5lmdyw>
 <6d63905e-8c6e-4c88-b60b-d34ab1401783@sirena.org.uk>
 <rduid57zbypxwiujgfez67walqgqkekhyktkbibtiqcjh5buge@jqqcu52yl5nc>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TefLr2w+5MtGYR7H"
Content-Disposition: inline
In-Reply-To: <rduid57zbypxwiujgfez67walqgqkekhyktkbibtiqcjh5buge@jqqcu52yl5nc>
X-Cookie: Brain fried -- Core dumped


--TefLr2w+5MtGYR7H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 06, 2026 at 02:51:55PM +0800, Yao Yuan wrote:

> Sure. let me try delete more next time.
> I delete some but decide to leave the whole context switch
> diffs to help other guys to see the realted changes when
> read my comment.

Yeah, it's a judgment call about how much to keep, it needs to be enough
to understand the reply but not so much it's hard to understand.  Can be
tricky to pick a good balance.

Thanks for the reviews!

--TefLr2w+5MtGYR7H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmp0uccACgkQJNaLcl1U
h9DVqwf/VH28WuzeeJLJf1g6ppvyuztxnQY2s2uGFVmG4bMNROwZmFsKbAGiiGfw
6rz2VLfqIIK+9OG5UXugJeEy5r9S81sU+d4bGV75GyclY32saJttAWlt7H9Fp/FA
WQIk2/8kSzABeWEmFM6y71bzUycaHT9H9M15O2syMXCJbh5wOd862g1pckqgn1dG
1W2uYvNY7tmo1JAAaXl/5AmOofXusCUefjOSjwh7M06IGsZUNOdTdJTIBpwB2TAT
7myhFyhpUjG263JQPJbgHtzreEu2UN5Jhs97EiL7hDKq1xCPEyBfLQj/fK0yi1f0
aS/WlG/ApWEqLXGvDBoXcIfhtqdq3w==
=QtoY
-----END PGP SIGNATURE-----

--TefLr2w+5MtGYR7H--
