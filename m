Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2769D4EE872;
	Thu,  3 Sep 2026 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454227; cv=none; b=BcouRvB1EMUZMnmkj70+b9uy5tKcu5vyXVUEGRXuZ1FKVmlxymuNXNnU2fDXTMASF04Oj7um1mr+KhBOko3THNk2vrw88I/IKA05g/ywdanB0MtenYfLDOK4zNYap/zgYJpT2QAq308dq+EMlKqnjKvCaFV+s+5p3Q3asI21jEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454227; c=relaxed/simple;
	bh=F4iZVS6D2gd2z15r43lWksE4Vt4lg5qGl3HF4LkTc8o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XfJ1xBETZsvOznoFJXLAXzrkdWzJCfsXSfmFLHvSz/QyDSkLOyoRssC88o+qxaA8R2ED95lZKWj2DiFVv7PqT9OHEpiSb1ORao75BTVk260wCA+Jkk1Zy4/pmA0DtChepNqFqKrTgK1EPn8GUAUhj1Uehz0/gA8wFweLg814Wz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RoNxt153; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RoNxt153"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8290F1F000E9;
	Thu,  3 Sep 2026 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788454225;
	bh=RucA1tkaxJH9WuoWLyiQd9FcfFTxNNoXlZn61Ec9uAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RoNxt153/88VSWl4TlG7qdU4zZaC3SLAJEtFsYBww69ZI9yMgyhrZUrNXKwbYdaaf
	 BNfmEmH8u0GsGyRlC68WKk8/m2aMh9vTBED86FaRCZgL2RkIuLojlsOtBzx8XEwuc9
	 BacOQE8gB3gV0qP670RvHMQ3FPdiYBlltskU/DF+AjdTVEZhPjA9+XIYxowycHs9q6
	 JkuH9FPLHjpv+72ViswQJLHq/iXYi7D7PBSoRsC564tB5DjtJkxwciy4AEtHcDJf8r
	 AIVWaAZV1W317zsUNn09hA9JqBqtvVA+lo4rJfWwJtWt82i3VvJ5NaGYIEj5klhHiS
	 UOet/Y+EZLcew==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 22/28] arm64: errata: Disable SPE in KVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260903160623.315525-23-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-23-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:50:25 +0000
Message-Id: <20260903165025.8290F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> When stage 1 is enabled and buffer virtual address VA is mapped as
> read-only, and hardware dirty bit management is disabled at stage 1 and
> stage 2, if stage 2 is enabled, SPE might write to address VA instead of
> generating a fault.
>=20
> This doesn't affect the SPE driver when running on baremetal, since the
> memory is mapped at stage 1 with write permissions.
>=20
> KVM does not use hardware dirty bit management and this erratum allows a
> guest to write to read-only memory as long as that address is mapped at
> stage 2.
>=20
> Since KVM allows userspace to use SPE on heterogenous systems, where there
> might be different SPE instances, tie the workaround to a particular SPE
> instance and do not allow userspace to use that instance when it is
> [ ... ]
>   https://support.arm.com/documentation/SDEN-2055130/18-0
> * ARM Cortex-X4 (MP161), SDEN v13, erratum 3022725
>   https://support.arm.com/documentation/109148/13-0
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D22

