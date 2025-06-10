Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C25B231858
	for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749568630; cv=none; b=abveauTM7xtoO+GChnMgwYj9Igy/4DzR8kP+zS19TGCxQxXaruiNxOwb1vTjc8C97aneMoawFT7roFASOPj3pEW0gI04E39RIMGSuwKhIOcjOlp4H/WGPytupf0+jyzyONEm5+QLdxkP1U6brlnTUnE+Rhdgiuicmqyi6Y6mLJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749568630; c=relaxed/simple;
	bh=3k9H6tDd0FAkOA34R3ugDwOkj/t5PT9g7vuX/Z/H8yA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qzxO3DxKlenmdxE8BA+8r4i0eVAv4rhrRA1K/Pr0GdD/clmbnIHGv5DbRO//uplj3augp2zOKbSFncCMHHYBSz7ZRYqeDd3QqvigvhhyHSQwF1c1RTd2Hb0OSdpyj5Ln8RZsfBryDpRkALkiRkUVVLHg0lLu8xOPx2/wYGo3V98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfvUDJHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfvUDJHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D316C4CEED;
	Tue, 10 Jun 2025 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749568629;
	bh=3k9H6tDd0FAkOA34R3ugDwOkj/t5PT9g7vuX/Z/H8yA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jfvUDJHtVNoRBKoZb8HzgtwRekwXzTqDxNPegXHoOlF/RIx+l64oi0xxAuakT7s3V
	 Q/RplRXuoEFMfnEcniKlWjPIRRnMDW7hv1um8KA6wHAGIwVpTKtlac9ZTnPjQG0Zy1
	 Mzm+qxNffACkP60DvQ4HGPR2u4j53dmnD1N12vDTTsPAQbTIoeNAjuPdMVCgSkIfJT
	 efePapflDdhqL8yP7OmhqRtms2MbMsr423xqeFMxzM2oqVFVRAHNCnsUzCW7M0Q0mM
	 y3gT6GUhj0qzx986kG/TETO8SbbPw8lPECBV6U13acR8RHLAuVto2Q0bJUX5FU9SFi
	 3qpQEq3MmUdOw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: nvhe: Fix build failure with gcc
In-Reply-To: <20250610151132.1758206-1-aneesh.kumar@kernel.org>
References: <20250610151132.1758206-1-aneesh.kumar@kernel.org>
Date: Tue, 10 Jun 2025 20:47:01 +0530
Message-ID: <yq5a4iwnlj82.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:

> Address a build failure encountered with aarch64-linux-gnu-gcc version
> 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04)
>
> /usr/bin/aarch64-linux-gnu-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__clock_mult_uint128':
> /linux/work/arch/arm64/kvm/hyp/nvhe/clock.c:27:(.hyp.text+0x120d8): undefined reference to `__kvm_nvhe___lshrti3'
> /linux/work/arch/arm64/kvm/hyp/nvhe/clock.c:27:(.hyp.text+0x120d8): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `__kvm_nvhe___lshrti3'
>
> Similar to commit 9bfe7553fadb ("arm64: Implement __lshrti3 library function"),
> this change use the added helper.
>

This is with the pkvm tracefs patches found here https://lore.kernel.org/all/20250516134031.661124-3-vdonnefort@google.com


>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Joey Gouly <joey.gouly@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
>
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index a76522d63c3e..3dd2c780bbfc 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -17,7 +17,7 @@ ccflags-y += -fno-stack-protector	\
>  hostprogs := gen-hyprel
>  HOST_EXTRACFLAGS += -I$(objtree)/include
>  
> -lib-objs := clear_page.o copy_page.o memcpy.o memset.o
> +lib-objs := clear_page.o copy_page.o memcpy.o memset.o tishift.o
>  lib-objs := $(addprefix ../../../lib/, $(lib-objs))
>  
>  CFLAGS_switch.nvhe.o += -Wno-override-init
> -- 
> 2.43.0
