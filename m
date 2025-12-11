Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA6F29A9C3
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765464725; cv=pass; b=jwwvMsWt0yBWqhyCoimGxo1s1neI3yXjIEe/PO5+1SRxBmHrOM4Tiwtxgdd5EkEoG1FsEC26eblGyD5DU1TM2CM88ajw8/NYELnrKhj96pU8svdB8UuZhZkWSDq2B+lGlfH/JrqX6IrSuGnIcM7Bb3ILAzUEXfNsaz+CKXAoZlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765464725; c=relaxed/simple;
	bh=wAMwNSRawWZ1QoE1+8GigGIznpCapxk6QfzLASpXrww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NY8GJlIyH15OTPXWQjVtfYnsyqpV7C8y0irTfPbmmPjfe28UFtvgg+ryfQqMVfdDx5h44Jgr2YYQ35ZHfKuoqE39RZaW7rkytiXf61phmHa2bsbstCX7i60bfgxIFtewkr9pvzjRKCUMbP5UPk1gX+nicTQMVSdqs7T517hIORw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=THAe+DzL; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="THAe+DzL"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ed67a143c5so557681cf.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 06:52:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765464722; cv=none;
        d=google.com; s=arc-20240605;
        b=J2bSyWyXXlZIsIMzopf9YMakba/KkrJq7pvGLbtPmUtsqNVX4vEoQxZZll9H+xhJKb
         stomnV/21pliVRr0fF8/HfoQ9G90rs38lJ7BZV3mwTjJqEsWLWrwaWhUpXf+PQdbOgFM
         TSsVCky7BfEezUTTmsFi1kmNSAHQ5DBMuC/mmAFeHeLH9ySQ4cfOyF8q9B3GClFwhISU
         XD3rCNgd2Jj4kUTh9w8XqonnTG/AliV5MTtN5vpVvf+pPJUVUJZJo9CU6giJeqOgqDJU
         ChxI/DtfaMUTwUuPXrj6tlwe82XFIADcbAbpTKLuqaijS4se/OyElSElGtlEyuxYhW9r
         3Hbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yWMX1jyjXeIgNw1WZzMJikLtB4FVJ9nrhVzaVMwg74Q=;
        fh=NG/nEuPEgoaPuGimMFCytjJ02a7zmffXXGabTKRy8/o=;
        b=GF6PJtp6msXBa/9vqMJQtgGl24Ov521AbuePvZ5LVVhD7o2+qtfvo/0U6lqpw4nWjF
         +983YQY3a7F0lkYBuslS9XUOn6Gp+9qJUnYOrt2dn4sUEmCsyFzg5DZidoUvI7V2W4O6
         kq8Prl3oRk2ajYaXgpKs0785kwCF5PLbDaeWiHqJpMkjWMQ1HPBFKcjXHiS+f6PlBTgG
         ZgfYNuKJLj/FrJmFDo0m35FopF0nV2ignbR0/PrP2n/27ZhbANgtys+NL0klCLU0Waq8
         lgCLxU66gjDCAoWhEYsQ//nTu/sJ7abe1CeVmvB38ZhVGumKs2IgU3UectsCGWLTwlFg
         CKOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765464722; x=1766069522; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yWMX1jyjXeIgNw1WZzMJikLtB4FVJ9nrhVzaVMwg74Q=;
        b=THAe+DzL8QFpKNukhuNZtEGhsrQmAP+lmPJU0QAyzotBmH3iHRgWfUJiIZn+eiH6M2
         KarYibSkNILhoqXqWh+0OcjYyqa+80e2PjYcQtry7ALBXBfwcxeIhTfo/sINhWwq0hUp
         BpPUKNPFwA0kRPLJckUvUrW27TfCWkIgkBfKWcMUvk4Hy9smQK4kokwx6PCNI4iUViPz
         R8IbG3W2gnaR/GylTWms4HiARGpTJt5CAHcoDvhjaTlDPGpl7eNwYHswZw0mREsaecea
         blrcNV+9N6NpfwE7blNGErVeHtCxh1KYN7NtF4F6pKU6/O7nYIBY1w2dekYhqwUH4ofg
         YUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765464722; x=1766069522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yWMX1jyjXeIgNw1WZzMJikLtB4FVJ9nrhVzaVMwg74Q=;
        b=hcyos3kFbDkC1K8HR97n6pJSzptluxFLRuqFQvV9FmX4BHkPG9gyT27a5MzkmF6RjD
         aTU+NNs5DqcUUqq3boYA7osJIrYyKQz5QoJdbbtwe+ZOLPbN5tQetWggQVsIklX9xEId
         NLp3Fgxkx3W4Xx3CkFzfNiA8PWJRBfgRAMUrDwY+lLb81aB1wqPgubWoChRqefahu0Mx
         SPoCST7XIIBCLatIqAzY1HXRDK9b+uZy6z16hoL0PdOOEcWdHGCLnBUiTl1UJ7obEUFS
         jI5v5YDkRRQZI6E7c1ZcKcUy26/Y/AQZ8uHoBIACM+ysLuv6hEqKt9bs4sjI+mneMmF9
         3bFg==
X-Gm-Message-State: AOJu0Yx0Zu59AvQ81apKvDrT3On67WlS6BZj8WZwewcLCwUYIIDIC8zo
	yBR5WMRZ27CZmmkXmvxGQy7SmFJiD/xTNPV4uUfX42arS3wGgho/CxrUyIf7q/LgTXM8ro52AQ1
	g3607w09dBagLP+SpXlbu6Xf1jj5cC2rYuSjM0h0rBgZtRFaYRXWNfXmo
X-Gm-Gg: AY/fxX4Ke9KNKnJp51+jnNqIozLUdoU8WkoQdhMYh7iAWH2Qg+amzvA5fqYg22BIp/8
	hS/OPlnrzuKXFQOyrGo8U81xNfCBNApfHdCE0xCDCDp/kOHqhmW9CCve+GOp8CXbPo8P20cyWLm
	s19rifsLlkSdvh5PFJy6KQwaCDLrzdZ+I5QlcaioxuePjTN46wZ9jshaOTOPnDNMK04Anbk8P9S
	fxcSXntAtloG2b2kL3AAOHafC56ZuduGXzeqH57UjXaHi9HoO3xpR14rkDTQDGqlkJQ/ZgZ
X-Google-Smtp-Source: AGHT+IFQKP5fapGPHx5ImO6c09xm7GohUJLdBZ1CUTPePaNGb2mNfszOTXSYC0I42sptlzmkcKe68l3xaix/F5ByaNg=
X-Received: by 2002:a05:622a:1995:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4f1bed26845mr9697741cf.1.1765464722271; Thu, 11 Dec 2025
 06:52:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-7-maz@kernel.org>
In-Reply-To: <20251210173024.561160-7-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 14:51:25 +0000
X-Gm-Features: AQt7F2o1Eo4xEzZ0xMgWpr24G9qnYMnYlv-SMNtZ7eV3yobp_YNt8tudLckw7Mw
Message-ID: <CA+EHjTwi3S-BVYQWf6_TAyd4fi18Ng3G3HkxKh2MB8PrE_32Uw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> Now that we potentially have two bits to deal with when setting
> execution permissions, make sure we correctly handle them when both
> when building the page tables and when reading back from them.
>
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

/fuad

> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 12 +++---------
>  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++++++++++---
>  2 files changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index be68b89692065..095e6b73740a6 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -87,15 +87,9 @@ typedef u64 kvm_pte_t;
>
>  #define KVM_PTE_LEAF_ATTR_HI_SW                GENMASK(58, 55)
>
> -#define __KVM_PTE_LEAF_ATTR_HI_S1_XN   BIT(54)
> -#define __KVM_PTE_LEAF_ATTR_HI_S1_UXN  BIT(54)
> -#define __KVM_PTE_LEAF_ATTR_HI_S1_PXN  BIT(53)
> -
> -#define KVM_PTE_LEAF_ATTR_HI_S1_XN                                     \
> -       ({ cpus_have_final_cap(ARM64_KVM_HVHE) ?                        \
> -                       (__KVM_PTE_LEAF_ATTR_HI_S1_UXN |                \
> -                        __KVM_PTE_LEAF_ATTR_HI_S1_PXN) :               \
> -                       __KVM_PTE_LEAF_ATTR_HI_S1_XN; })
> +#define KVM_PTE_LEAF_ATTR_HI_S1_XN     BIT(54)
> +#define KVM_PTE_LEAF_ATTR_HI_S1_UXN    BIT(54)
> +#define KVM_PTE_LEAF_ATTR_HI_S1_PXN    BIT(53)
>
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN     GENMASK(54, 53)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index e0bd6a0172729..97c0835d25590 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -342,6 +342,9 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>         if (!(prot & KVM_PGTABLE_PROT_R))
>                 return -EINVAL;
>
> +       if (!cpus_have_final_cap(ARM64_KVM_HVHE))
> +               prot &= ~KVM_PGTABLE_PROT_UX;
> +
>         if (prot & KVM_PGTABLE_PROT_X) {
>                 if (prot & KVM_PGTABLE_PROT_W)
>                         return -EINVAL;
> @@ -351,8 +354,16 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>
>                 if (system_supports_bti_kernel())
>                         attr |= KVM_PTE_LEAF_ATTR_HI_S1_GP;
> +       }
> +
> +       if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
> +               if (!(prot & KVM_PGTABLE_PROT_PX))
> +                       attr |= KVM_PTE_LEAF_ATTR_HI_S1_PXN;
> +               if (!(prot & KVM_PGTABLE_PROT_UX))
> +                       attr |= KVM_PTE_LEAF_ATTR_HI_S1_UXN;
>         } else {
> -               attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
> +               if (!(prot & KVM_PGTABLE_PROT_PX))
> +                       attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
>         }
>
>         attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
> @@ -373,8 +384,15 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
>         if (!kvm_pte_valid(pte))
>                 return prot;
>
> -       if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
> -               prot |= KVM_PGTABLE_PROT_X;
> +       if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
> +               if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_PXN))
> +                       prot |= KVM_PGTABLE_PROT_PX;
> +               if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_UXN))
> +                       prot |= KVM_PGTABLE_PROT_UX;
> +       } else {
> +               if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
> +                       prot |= KVM_PGTABLE_PROT_PX;
> +       }
>
>         ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S1_AP, pte);
>         if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RO)
> --
> 2.47.3
>
