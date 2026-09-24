Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793024C9DE3;
	Thu, 24 Sep 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272543; cv=none; b=IjsIaQQx2zCVefPrOHSkAjBvArUZS8gecqc1UD8LWpfcnararePNjLQ9VR3A23IzvQqQ+41qPPHy5CFq5rV52b7UbFSdOykziTSdo+cE4Ik9A2Aie1j6l9XMeouHplc6llFJmZZ3qjbWMundktjl4aPPIlPuk6H04LYVjsieH5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272543; c=relaxed/simple;
	bh=Y2l+QZUd/ILd1+XPNBP8VWSbIRcfrrQYwG8LePynD0s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XlhH7lYfHiwTtzotD27LtdD/MdBt1LlylIUZScZy7H4P/TkQLshQMvrI01hPV2M6mVsh1OKLyy7fskBZKTkFteHdQVZUQxTAOIoogE/KsANG7kTCDlhyIUVwHZcZtb8s93lSIE/UKk+g6Opr6bFTnHVHClQu4uQ05E+2z0IJq0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4M2UJWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4M2UJWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86AD1F00893;
	Thu, 24 Sep 2026 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272542;
	bh=TaFY3iMy+wOQ10OknoYxsm4WyA/g3fbdGQeu2oS76CQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M4M2UJWHWDMxnii7EytqJ1gRmCGhADO/3iuywaVAMClpi/T2R6Zme9l92JkG9WbNw
	 tYtV+8PMw7xdjF1E0z0S/GCsORav19inpas/eZbVi6LKCGkrwzDp2MVKPaV/AY/R8m
	 UVpvVRO8eo06HWvv0Q7KpotMsU7EAEBnKnNifVv0xxAY0eLXqTV5SzsDEQmwzdPTYB
	 5RcC2mzBiNv83SAypWo9M6lBAWGyzLA+y+ks3+DdpVWSH9IaVZ6Yz/RTTO64fCTyrB
	 WJChMCke6Px9Tb0eDTIpsIZzKNRHsS2r2f1I/Os/z9K6X4OpG9mBpZI+p6+7D42veB
	 SFif/rI/wnHUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 22/22] KVM: arm64: selftests: Add test case for
 Partitioned PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260924172928.2110956-23-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-23-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:55:41 +0000
Message-Id: <20260924175541.D86AD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] selftests: code and commit message mismatch for enum pmu_impl
--

commit 46faadbd8c25e77d7c2d05f65dc67de455edf047
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: selftests: Add test case for Partitioned PMU

This commit extends the vpmu_counter_access test to run against both the
emulated vPMU and Partitioned PMU. It introduces a new enum to represent
the implementation type and skips out-of-bounds counter access exception
tests when partitioned.

> Introduce enum vpmu_impl (EMULATED_VPMU vs. PARTITIONED_VPMU) and thread
> it through the test setup helpers to configure

[Severity: Low]
This isn't a bug in the code, but there is a mismatch between the commit
message and the actual enum definition. The commit message states it
introduces enum vpmu_impl with values EMULATED_VPMU and PARTITIONED_VPMU.

> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/to=
ols/testing/selftests/kvm/arm64/vpmu_counter_access.c
> index 22223395969e0..811f8156cea3c 100644
> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> @@ -25,12 +25,27 @@
>  /* The cycle counter bit position that's common among the PMU registers =
*/
>  #define ARMV8_PMU_CYCLE_IDX		31
> =20
> +enum pmu_impl {
> +	EMULATED,
> +	PARTITIONED
> +};

[Severity: Low]
Could the commit message be updated to match the actual enum pmu_impl and
its values used here in vpmu_counter_access.c?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D22
