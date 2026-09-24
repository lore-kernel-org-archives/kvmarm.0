Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D324BEE5E;
	Thu, 24 Sep 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272363; cv=none; b=oxemcJOy2U8nVu2ePg5CSmPICHWqyMGXaY2vhNaMZQ2YXCD69Xb0P3I/lqh23BN+lAmfzRbbDNK+Qh2+xtETQAF9bNgNpoHYAJhxQZXRD0euMohU3ZqeGjEnHPH2AnVXe4UJC+cbxRcKZv3Io56DP3QTOM7LWUCo2dwHHDyDobY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272363; c=relaxed/simple;
	bh=hziZAaE+V5xDAQSScAc0eAj/3VxlC53isvRBrxFNM/4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V9oML7JXbOC7RTjC0OZ0tcSQOuNlSLl+VQ1j2NbdrqSgWJCzb0ti3DvwgSuekfTxFzTAS10SIq7c62HOHJkwoX+/q0rgCJWWT1gxfXxv0LkpptTWjOGJu2/goL0tmuIa9aGRNJyDB0QIrxuEmHY+MXE30P72uhoinYMw+4hOB9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1/4Sp/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1/4Sp/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3F21F000FF;
	Thu, 24 Sep 2026 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272362;
	bh=hziZAaE+V5xDAQSScAc0eAj/3VxlC53isvRBrxFNM/4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L1/4Sp/B0UhnZsLFMLRWfcTmPJTrFmzJe2eBov53jTVq8CoLd2WEHUGkXjqfEfrnZ
	 vqZrnBgpoXygGnpvZvWreQKGJQkkrQXygZvPMNDHLJj9lMQsmdrrqRLuZUCnOB7zth
	 rfronG6gRtCInPy1RaLRk8mmgBMRP6V8Y99HeXhFvH3UMbgIsRb3glT0n43lnvSf8b
	 PJMfKJXh02EJnRor/0SSBVJLz5Vv3RLaZW/pt9IZmGlgDkLIs1Joyurl9A2jXfLpqz
	 +96KqWwN1sdAgq8RhTbWnRGucjqtZq1mc57aeFQLBaBxMzr04KZOcxTXBl2hPBEK8L
	 AcZS2H6Dy6x+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 09/22] KVM: arm64: Set up FGT for Partitioned PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260924172928.2110956-10-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-10-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:52:41 +0000
Message-Id: <20260924175241.ED3F21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> In order to gain the best performance benefit from partitioning the
> PMU, utilize fine grain traps (FEAT_FGT and FEAT_FGT2) to avoid
> trapping common PMU register accesses by the guest to remove that
> overhead.
>=20
> Untrapped:
> - PMCR_EL0
> - PMUSERENR_EL0
> - PMSELR_EL0
> - PMCCNTR_EL0
> - PMCNTEN_EL0
> - PMINTEN_EL1
> - PMEVCNTRn_EL0
>=20
> These are safe to untrap because writing MDCR_EL2.HPMN as this series
> [ ... ]
>=20
> PMCEIDn and PMMIR remain trapped because they can leak information
> specific to the host hardware implementation.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D9

