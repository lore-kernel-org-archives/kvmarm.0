Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795080625;
	b=VkNhCFUaE/VNjRRSs86XqbVI+eGt1ZbTakrcYf/B9R3tsDwMY+69cxylZJTrGT1gFNUL
	 cdPKcU1CfV2q4uwzp4Aq/oqctcsFHqadHOM7+k33pnr1eUFnsTCo7O52nIMPaGVAt7qFi
	 6iqICdHkDGLO7LTkkEbws6ZiRFKJvdvKGgrexmx2vV2QNiclCoFhQs8nc54py6oV37x6G
	 G0CXs0M1t3WL4G+UFb9HZFN8gEbHYdGbK4PQ/LlrOicH6RZPvtBS6l7DdmbLhjG3E87m0
	 ioe4KqIQn5/BDIhxAIfLwPjQnaskJ04Qzz607XsIa07+f/WcZqfvhmHRGXd9yEnbK1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795080625;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Sh9sgfMT4KaJYws8o3fTy/YeNndwD4UKnNx2fS4QIfw=;
	b=vMpwtdAc2gD6RR35urLWj4rJqaD36LAe+jFyrTWOJyTu7yGScz1dwZdpDRkf2Wg7G/9C
	 AQu3GS+tBtt6jOi/9DaTd08YAuYELfVaJ3dmAqAAnTq0WwQfsWbh7pfwY8BowSjhMMckx
	 pINqOalObUWPrcFZnj0/RCHBG+zjmyT7qtJuhbP7DBTvMJxo1ZagLILvmrfW+bWre/xU3
	 HItC5PgZrrcXgnAqFdoqg1I4aAM1HI4GGXsYcpGbAmKwiKh83E6YnW8LTgKDOHuhUfAT9
	 A2fdZqbyuPzoUu6Or5y/yHgthpAyQxrby1uUvNLbPzTS70CfVV97uvvGUqoaUckOJcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SItWVVXi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDACC606A32C;
	Thu, 19 Nov 2026 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SItWVVXi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4F41F000C5;
	Thu, 19 Nov 2026 09:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795080625;
	bh=Sh9sgfMT4KaJYws8o3fTy/YeNndwD4UKnNx2fS4QIfw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SItWVVXieInsqkKlXXJ3hmGH+1WTB8Ez5xtrnlOUvZaOg2OvB67KhCSc7xaPkQuCQ
	 jhyyZFxWee4+bEiRjpaROJbuNPUVV+mShqi9D9S7WtsW9qFyo6xZSwj3v5fQyDwu5B
	 TUs6NLyxFTAgyuoyi5eGJ5n7+V1MtOHV0lS3op8LqTVQ7ec+xvgRjCH4IZNhVGFVby
	 dt35BkEXtk/vAteTLZA4/BMjr1T9ZwnWxh1KzwduslvsJ6t2SVrBM578ReVAuFp2P4
	 ud8RpLTQsGsA8bgNHIy2tlgRubad0ehcqey+J5qrTvahYqik1jynxRIECUpP7Gu4d/
	 SlVJxszObgsnw==
Message-ID: <sashiko-outbox-222837@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/5] arm64: tlb: Add tlbi workaround for
 FUJITSU-MONAKA Erratum E#030001
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tomohiro Misono" <misono.tomohiro@fujitsu.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261119-monaka-fix-for-upstream-v3-2-057df4d2ca3c@fujitsu.com>
References: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
 <20261119-monaka-fix-for-upstream-v3-2-057df4d2ca3c@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 09:30:24 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] KVM: arm64: pvm_calc_id_reg() exposes FEAT_TLBIRANGE on
  FUJITSU-MONAKA
- [Low] KVM: arm64: __kvm_read_sanitised_id_reg() elevates
  ID_AA64ISAR0_EL1.TLB to OS
--

commit 913abeb45fc613951715127a954e31a80a0e00cf
Author: Tomohiro Misono <misono.tomohiro@fujitsu.com>

arm64: tlb: Add tlbi workaround for FUJITSU-MONAKA Erratum E#030001

This commit adds a workaround for FUJITSU-MONAKA Erratum E#030001 by
disabling ARM64_HAS_TLB_RANGE on the host and downgrading
ID_AA64ISAR0_EL1.TLB to OS for KVM guests.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c7d91138a6d49..2e8965b7702e1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1949,6 +1949,14 @@ static u64 __kvm_read_sanitised_id_reg(const struc=
t kvm_vcpu *vcpu,
>  	case SYS_ID_AA64PFR2_EL1:
>  		val =3D sanitise_id_aa64pfr2_el1(vcpu, val);
>  		break;
> +	case SYS_ID_AA64ISAR0_EL1:
> +		if (cpus_have_final_cap(ARM64_WORKAROUND_FUJITSU_030001)) {
> +			/* disable TLBI range operatoins on guest */
> +			val &=3D ~ID_AA64ISAR0_EL1_TLB_MASK;
> +			val |=3D SYS_FIELD_PREP(ID_AA64ISAR0_EL1, TLB,
> +				ID_AA64ISAR0_EL1_TLB_OS);
> +		}
> +		break;
>  	case SYS_ID_AA64ISAR1_EL1:
>  		if (!vcpu_has_ptrauth(vcpu))
>  			val &=3D ~(ID_AA64ISAR1_EL1_APA |

[Severity: Medium]
Does this leave FEAT_TLBIRANGE exposed to protected VMs under pKVM?

has_tlb_range() disables ARM64_HAS_TLB_RANGE on the host without modifying
the sanitised feature register value returned by
read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1).  For protected VMs
(kvm_arm.mode=3Dprotected), guest ID registers do not go through
__kvm_read_sanitised_id_reg(): kvm_hyp_init_symbols() copies
read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1) into id_aa64isar0_el1_sys_val,
and kvm_init_pvm_id_regs() -> pvm_calc_id_reg() returns
id_aa64isar0_el1_sys_val unchanged for SYS_ID_AA64ISAR0_EL1.  A protected
guest on FUJITSU-MONAKA will still observe ID_AA64ISAR0_EL1.TLB =3D=3D RANG=
E and
issue the affected RVA[L]E1* and RVAA[L]E1* instructions, leaving stale TLB
entries when invalidating an affected 512MB mapping.

[Severity: Low]
Can overwriting ID_AA64ISAR0_EL1.TLB with ID_AA64ISAR0_EL1_TLB_OS elevate
the field from NI (0) to OS (1)?

If an L1 KVM host on FUJITSU-MONAKA had ID_AA64ISAR0_EL1.TLB downgraded to
NI by its L0 VMM, setting ID_AA64ISAR0_EL1_TLB_OS unconditionally advertises
FEAT_TLBIOS to L2 guests when the host does not have it, causing L0 to
inject an UNDEFINED exception on outer-shareable TLBI instructions.  Using
ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64ISAR0_EL1, TLB, OS) would clamp the
field with min() instead of elevating it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-monaka-fix=
-for-upstream-v3-0-057df4d2ca3c@fujitsu.com?part=3D2
