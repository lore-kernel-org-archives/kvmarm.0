Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C3F4E8E1B;
	Thu,  3 Sep 2026 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451920; cv=none; b=Slw/5V8SXC6/h//YsB9u6+TszgAqbZM1tCxJgIrEkfkHxpPxUzWbi3aJLzEjcbBUfT+nNBcr85C/XMEGQh1n9SHpxYAbCYHe0d83nuY8lw1v2X30zAFwCFtIadvIYudGZjjSi5WHBPI4eJNctVSjDwjjGJnqiVuZZ73M03J60vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451920; c=relaxed/simple;
	bh=vqMFZFhow6jXDENGJXxgVUChw0QZjWjZsyWD6uflWjM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NQ5BlV2iyn6nEyU8YB+T/d/5LOjUla3ZvVjRugTiIzo1GYZs895oHAQtSg+E5uGHmAMr9usMGXfeFVYoijhnAXHjiAkLlLR7VpoaSGZQV6ImR9bcotUQv/3isaZh6i1TM7E9i4lcFhuthyJ0yV/P66XKFz4vVpJlNRLs3kOfdyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=geRzCph/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="geRzCph/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CC01F00A3D;
	Thu,  3 Sep 2026 16:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451919;
	bh=vqMFZFhow6jXDENGJXxgVUChw0QZjWjZsyWD6uflWjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=geRzCph/a7+KwvC5+GdLTmQEZHh4svP6R7eIWxShRnRwDhGI9KCwWHbxZLs/3s1eZ
	 TSaSZFmR1eLe1wXjkIZclImgezZMfHb1aJ9p18RKPLkZI0MW09thzNEfbu3J7z0AMj
	 Li7zGqW+7T3twIX73bxrJRsRP9WxsNOs8rX+c3l0G/WAzXYSKrQ8Ruy7lq8L1ZpLov
	 BpRrWeleYkXHAz4+qfYt8+TMTcChGvaUV8mnjADObroL/CkrldrrmSvbses5kxxCHt
	 ZpBpRp332B4L2TMUaXB6hrACpPNb3Z0zqpvRCaB1j9MNGYSGGTDykHUKSXqQPwlqno
	 sd4crSjrO2IEA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 04/28] perf: arm_spe_pmu: Move struct arm_spe_pmu
 to a separate header file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260903160623.315525-5-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-5-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:11:58 +0000
Message-Id: <20260903161158.E1CC01F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> KVM will soon want to make use of struct arm_spe_pmu, move it to a separa=
te
> header where it will be easily accessible.
>=20
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D4

