Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B5E4AB1D4;
	Thu, 24 Sep 2026 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271535; cv=none; b=fIHtvAK6PAFN+iNTAPkH3mon7t91tMjcF92IIMwF1TxgE4HgGDWgbrMk0JzXEHqVUcCSuevgCZQwqResAI+fhM9ZD7XUzCSkuJymSg8UBFcDjX92zttt7KtkHP/hzXiJCTJvS8zyVE9yJTP06RiMrvEPgm6/BtUYyHLIpBS7vYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271535; c=relaxed/simple;
	bh=AJ1IM46fShG3a5boN7K9E/3Z1mO8MbqGWQ+JAsu+Pgs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SEBIMkhXL4qsPNaE0Bemrnb+25xwAZYuQDV1pfcnGVhnxQRD+iHLmYfmlJqx2VqWYd4gqMDdV/ytMirm8etXup9ZjP3iUva9aSLdSIdNwxhj0k1cIujsV/aBKhl6b20PwlO6D+u3cmxW+z/bdkTRtoSF7Y8tyC8S8ErfDGmR5uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMzY4XbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMzY4XbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2F81F000FF;
	Thu, 24 Sep 2026 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271533;
	bh=lAVL74Np4Z7h8Tk0g5UAfg8fbQXBKZVTqq7AWxhuyyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jMzY4XbD2VKZBoQ6aOons7R0FnNADC0VzGZE1aCos+XqD7jVetoeKKHdStNX2oNjZ
	 vqtkCt01VbjuLC/APQDKCKlQ2cHgoVLJCMvXRk3ucLHPMmRMlYS1llbTaWcCUPVprA
	 HehKfDoQbzt2LsWpbDAtwjSV/NdLArI7mhHEulExUGr5g8QGTfvXzbsZZ5wyZbFrY3
	 HJCh47ZGfuU0V604QW/S23mNLCTO/Pdsgw/v+hL6lua/cd68+2Q55WNp9xgj4osVwC
	 9+dVKMcPhqtaGIvMKICO8naLwoa+KLC8Ii1N+6Mk7a50J3W5siL1KPHBIXzN5ZqO6R
	 S1w/NrZlSp6Xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 02/22] KVM: arm64: Reorganize PMU includes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260924172928.2110956-3-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-3-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:38:52 +0000
Message-Id: <20260924173853.3D2F81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> From: Marc Zyngier <maz@kernel.org>
>=20
> Including *all* of asm/kvm_host.h in asm/arm_pmuv3.h is a bad idea
> because that is much more than arm_pmuv3.h logically needs and creates
> a circular dependency that makes it easy to introduce compiler errors
> when editing this code.
>=20
> asm/kvm_host.h includes kvm/arm_pmu.h includes perf/arm_pmuv3.h
> includes asm/arm_pmuv3.h includes asm/kvm_host.h
>=20
> Reorganize the PMU includes to be more sane. In particular:
>=20
> - Remove the circular dependency by removing the kvm_host.h include
>   from asm/arm_pmuv3.h since 99% of it isn't needed.
>=20
> - Move the remaining tiny bit of KVM/PMU interface from kvm_host.h
>   into arm_pmu.h
>=20
> - Conditionally on ARM64, include the more targeted arm_pmu.h directly
>   in the arm_pmuv3.c driver.
>=20
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D2

