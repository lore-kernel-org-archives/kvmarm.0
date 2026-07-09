Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC722AEF5
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 22:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637127; cv=none; b=tTcuKFDhahGspxMNRq62p8wbJlXA3qDpG5ekP00lClblINlLwJQIvBdakVuwbXO7WB6+blp+mDzy4YLLy/2YtqMk3o1iVAVhve2nrJye6HYvabUJ1jHm1JwC9Q43tBhct89T6sgafcyyhpZY7uoYDFbFiuCBvzA+dv4iAuz13qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637127; c=relaxed/simple;
	bh=Dj9I/mL2b7DwpeIIdZBg5UiWucxKKTkcZx3SZR0fd9Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HMuQ3DWb6h2L86jClbQuyIP4fXoJ95HMGHUt5Jipd17x8A93p11yzZsgAWfmL2in1M3JjghbCUNSmFE17IX8XUdfVvU//CVOKrnhvSXiejakrv3uxYlAFOT3rkQO7dvJ4jSlWW6YMBJYbI35SK/C3jJJtgBDz8td9u/Ldl1TlfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5uIMXVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5uIMXVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704591F00A3D;
	Thu,  9 Jul 2026 22:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783637125;
	bh=uxYnzBzHniiv4n9cTDorYaB0u/2a6m3hqanBNEGuK5A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f5uIMXVJPEbowdZSCPjtXb7K33qtYXHEgGVkw4T713dLMK1TPJCTDB5OAhxfas4HP
	 I7jBORtTDGGFM2iZ4em2x5VDnvLLpOoh6+S1zm1LAh649N/zhAox1y86RTapJo5Knl
	 JhlNq4gOmmZLabGN+Q0r25caTgFb937QKqADGQ/yv9lTDpDfJg3moToBqDrSm61ryJ
	 v9LZLpOLR78J+1GQF764W3aKIT4lilpoZZSLNKUpFsGtMKLJwjlZP/lnSMvzsMnL2/
	 I0pGvmdoJhM0Y4UEKUKIuM/aoDq1qtbmdZOWSZHAQox91iUW8YyIiPFD1xG98B2CVG
	 0CQs8NJxlUb3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6 v3 2/6] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is negative
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260709223604.12934-3-coltonlewis@google.com>
References: <20260709223604.12934-1-coltonlewis@google.com>
 <20260709223604.12934-3-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 22:45:24 +0000
Message-Id: <20260709224525.704591F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The check for ID_AA64MMFR4_EL1.E2H0 < 0 is fundamentally broken be=
cause it tests a zeroed bit, rendering the new VHE-only boot path completel=
y unreachable.
--

--- Patch [2]: [PATCH 6.6 v3 2/6] arm64: Treat HCR_EL2.E2H as RES1 when ID_=
AA64MMFR4_EL1.E2H0 is negative ---
commit e7cc4eff9449a99298c29ed34077323ad01efaea
Author: Marc Zyngier <maz@kernel.org>

arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative

This commit updates the init_el2 boot path to check ID_AA64MMFR4_EL1.E2H0
before evaluating HCR_EL2.E2H. It aims to support compliant CPUs that
advertise VHE-only mode with a negative E2H0 value, avoiding a boot path
that erroneously attempts to clear HCR_EL2.E2H.

Link: https://lore.kernel.org/r/20240122181344.258974-8-maz@kernel.org

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 6517bf2644a08..e32c8dd0b17a7 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -589,25 +589,32 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
>  	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
> =20
>  	/*
> -	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1,
> -	 * making it impossible to start in nVHE mode. Is that
> -	 * compliant with the architecture? Absolutely not!
> +	 * Compliant CPUs advertise their VHE-onlyness with
> +	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
> +	 * RES1 in that case.
> +	 *
> +	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
> +	 * don't advertise it (they predate this relaxation).
>  	 */
> +	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
> +	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
> +	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - =
1), 1f

[Severity: High]
Since ubfx in init_el2 extracts the field and places it at the bottom of x0
while zeroing the upper bits, will this tbnz instruction always fail?

It appears tbnz is testing the original bit position (SHIFT + WIDTH - 1)
rather than the new most significant bit position of the extracted field
(WIDTH - 1). Because ubfx zeroes out the original bit position, testing it
here in arch/arm64/kernel/head.S would unconditionally fall through.

Does this mean the new VHE-only boot path remains completely unreachable on
compliant hardware where ID_AA64MMFR4_EL1.E2H0 is negative?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709223604.1293=
4-1-coltonlewis@google.com?part=3D2
