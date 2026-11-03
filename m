Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722989;
	b=Q3/2wQkcoqRc+kWWAElNKtLadomJbcWqa5yITQObzMtadBUsyEeeGL6rzvELKT96maq1
	 grXuwKVg4YiKTTucIz+XbsJLfJHmmvmyhr9BiYvt/576SoX8CsKFH1+V3xPqZEt2Gjpor
	 NknlmE2PnAm+B1m3/lzPH4Fck12CV31Mu/l6akgae5ZkQjQS3N/YQmifUtq/mFL52ILLS
	 JcLh+exyo2MXomVqnqlnKBB03q4GpIt8t/CaROZRhISFGZJJv1gVyWS1XZPwD5HaodOCG
	 KczsDt+8E0ImUwXuFHXb/vuVlwig0FAv/5cX9iRuFtwjLfSpy2iEOKlMs2WRIs/R4gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722989;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=BCIqCJTJI3CEPROs9512EusTir8+qkAL3Ppxq3Gysy4=;
	b=0VEATYhgtOc9cXVUjJKCdIdCCBAdZTDP8cSXc0dDe4XtH8nsHKIAYwnk0d3cIUyVqhcy
	 xRG+FPJYXi38rjQtPFwSyRy0ZOwVrNv5o7wgeUNxI3R11C/VqziIckiZJ7sEgzbwW9R3i
	 tDuifuybYPXBzpGQBDzWDBvD/6wBZVtyxINXgaj2sV2hk/WwgOMVJGeRGvfb2XqrXxsw7
	 9zADj8rM04wa9bXhZwbP1ZFbXgCCEBI5FHDs6D8LHt7wu5nIsAlFvBdXU+xMBbeE7xb9A
	 icLj5lticX6S3ecJ+TsDxIvvdBoEn3HpyWhelg+oxPVErHFp8ky0nzU781Pdq4n46SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UkEBvGBh;
	arc=none smtp.remote-ip=95.215.58.117
Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579F5606A32E
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 16:23:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 579F5606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UkEBvGBh
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XEdFqC6h97QFZvtiPpW+UzaHuigGpaYAlhVfXdg2ZzM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793722986; v=1; x=1794327786;
 b=UkEBvGBhggSjwcDRF8HYK0bAfMfWdYsxtkOIUbkSagSeu0l4ZDgti0RkbWow51aYi1uIZ/A2
 7yyjKyviVp5X1/Pkv8FTZ32a+xDE9aqKVI8IR/Rt2R/JhIyVul4f6EfJsH5ck68GTpmz1cRL7nG
 94R5vk64CzI9ui3EjMeedYyw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 26807285cc271a4a;
	Tue, 03 Nov 2026 16:23:06 +0000
X-Mizu-Trace-ID: 26807285cc271a4a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so8646e87.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 08:23:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwMIiBAqSWHqJdN6GG65AE0uXoQjkEymsV0AIQckjSA22bo3o902M2j02TxmGwyh0ER0tvtg0s=@lists.linux.dev
X-Gm-Message-State: APuU4Z8C3g9diRBbwB6xoF9TROuw1cy17J1th+SpxByl3QvZ6vga77tX
	nzurMgjObGfLGUetPwkudVPh0ypS5M//mupoSIXoVaXNTHa1engLajMPWzNNsTE5a80QRxmpRhR
	8tIboX1McqYQDo/S1a5sOTuD0y9wD2lEdjJScF3Qp
X-Received: by 2002:a05:6512:12cf:b0:5bf:c9c6:ae92 with SMTP id
 2adb3069b0e04-5bff0544d8fmr146220e87.7.1793722985169; Tue, 03 Nov 2026
 08:23:05 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
 <20261103084742.1302597-4-fuad.tabba@linux.dev> <29e7d214-b7b0-403a-a40f-dbc5b6951e22@arm.com>
 <b191c40e-8e2b-4c1a-8604-d75cb47bd194@arm.com>
In-Reply-To: <b191c40e-8e2b-4c1a-8604-d75cb47bd194@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 16:22:28 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyFRxuvi+jRvSgNRaPNan2SO3nO3aDivCarvKDaUHRarg@mail.gmail.com>
X-Gm-Features: AclHuK-bljgFCCFARu7bxbrTGuz_ajmvxtmJjvK8SX6B4thjgg1guu6VgoopCi0
Message-ID: <CA+EHjTyFRxuvi+jRvSgNRaPNan2SO3nO3aDivCarvKDaUHRarg@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Move stage-2 teardown into kvm_vm_s2_ops
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 03 Nov 2026 10:33:15 +0000, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> > Someone beat you on this (well almost) ;-)

:D

> > https://lore.kernel.org/all/4304d0c7-2220-4add-9c71-e6dc6b4fbc11@arm.com

realm_stage2_destroy() in your sketch doesn't use the range it's
given, so it should fit this hook, which only takes the pgt.

[...]
> >> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> >> index 10b425a0141be..9df3c80a5acd1 100644
> >> --- a/arch/arm64/kvm/mmu.c
> >> +++ b/arch/arm64/kvm/mmu.c
> >> @@ -1029,17 +1029,16 @@ static void stage2_destroy_range(struct
> >> kvm_pgtable *pgt, phys_addr_t addr,
> >>       } while (addr = next, addr != end);
> >>   }
> >> -static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
> >> +static void kvm_vm_stage2_destroy(struct kvm_pgtable *pgt)
> >>   {
> >> -    unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
> >> +    stage2_destroy_range(pgt, 0, kvm_phys_size(pgt->mmu));
>
> Also, now that stage2_destroy_range is only called for normal KVM,
> could we fold that in here ?

Ack.

[...]
> >> @@ -1126,7 +1125,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct
> >> kvm_s2_mmu *mmu, unsigned long t
> >>       return 0;
> >>   out_destroy_pgtable:
> >> -    kvm_stage2_destroy(pgt);
> >> +    kvm->arch.vm_s2_ops->vm_stage2_destroy(pgt);
> >
> > minor nit: should we retain the kvm_stage2_destroy() to dispatch the
> > callback ?

I'll keep it in v2.

> >
> > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks!

Cheers,
/fuad
