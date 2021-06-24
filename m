Return-Path: <SRS0=0p1Y=LS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765EBC48BDF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 08:57:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E44E2613E3
	for <kvmarm@archiver.kernel.org>; Thu, 24 Jun 2021 08:57:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E44E2613E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DD404B1E6;
	Thu, 24 Jun 2021 04:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uU6jYC7D2Pc3; Thu, 24 Jun 2021 04:57:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35F1F4B210;
	Thu, 24 Jun 2021 04:57:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 603D44B1F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 04:43:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UulyZu598CkE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jun 2021 04:43:07 -0400 (EDT)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 438C44B1F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 04:43:07 -0400 (EDT)
Received: by mail-pl1-f177.google.com with SMTP id v12so2577252plo.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jun 2021 01:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:subject:to:cc:references:in-reply-to:mime-version
 :message-id:content-transfer-encoding;
 bh=yhvFMq52QAZ9Grg2JNZMftQHgs3RA/23cRzSXZS17k0=;
 b=gAOPVlMk/C7twisLQPwKCNWWewikvdh3rxAsE3ZtniqnTTajI/NMXYxiFGdNgFsAb5
 HygkoSZIJ35Gv0csn5ROrHrh88J/UJu+eQftLB0ieYLqxUsTshCjLCXS6gCtoawRaivr
 09ywa3Xbj5hpxhL9dwXklJBlZskMpYTiquDzecxyLb9cNgD5q6A07FqSvRwXDFm8rCjX
 BNwM+/+ntQwzLzmsj9QUq7rwCh6LY1EpIQpDwzEMVK8zxcfbTYEjGD1dfARZQBO2ATzQ
 bXhbvn6/C4gpLxmOLhsNYYF/nPrsfEvzkHwVbcZduLr1uAs8pjNAgfhm1dhPRaqpCZmK
 qi+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
 :mime-version:message-id:content-transfer-encoding;
 bh=yhvFMq52QAZ9Grg2JNZMftQHgs3RA/23cRzSXZS17k0=;
 b=ocaVt7Sb8gUaJxazoLqj1HEhddfEL2pt1PE3eF3aDVFso75uvPcqFZPC/ipL3pmHLp
 Aw2mwsGk7ZhYqWNagwTjQvx/5odnURiY2CnQXlkLQZMxCBQXMDSMzNmzvphlPC4NMBvq
 zO8hBFtiBCd3Z6br+JSkbHzyxMmbFple+v1jhVeoQrDUjrm3zRRU4fbOaU8uWtIBn3cN
 AKjsJRYEjFxkpR5AyvhnlSQZCGzaXveT1xyBLbE8FBUzIFaYMVDkjHYBUXd1GMnZh9sc
 ITY4Aip5PXD2SJUjYTn8W+FUaBo5S/H//B5Zz4oVBE5QJQDDhzDeE9VugGTQTzMalVeQ
 VkRg==
X-Gm-Message-State: AOAM530SyqbdcFgrygDg1eiA8ANj5x4/tTTODbyHBNnIs2/Gx7m0PV1B
 /3B+fFNKigL4F4XvBNbwVX0=
X-Google-Smtp-Source: ABdhPJxPYtDJj0lFNs0Ok5TeYJmivmtsbDnnr/kiA2/ldwDSYWrbmF8IsiSMPIQHeLM0imoUnt26JQ==
X-Received: by 2002:a17:90b:793:: with SMTP id
 l19mr14007232pjz.111.1624524186360; 
 Thu, 24 Jun 2021 01:43:06 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
 by smtp.gmail.com with ESMTPSA id 23sm1841779pjw.28.2021.06.24.01.43.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Jun 2021 01:43:06 -0700 (PDT)
Date: Thu, 24 Jun 2021 18:43:00 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/6] KVM: x86/mmu: release audited pfns
To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Huacai Chen
 <chenhuacai@kernel.org>, Marc Zyngier <maz@kernel.org>, Paul Mackerras
 <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>, David Stevens
 <stevensd@chromium.org>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang
 <zhi.a.wang@intel.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-2-stevensd@google.com>
In-Reply-To: <20210624035749.4054934-2-stevensd@google.com>
MIME-Version: 1.0
Message-Id: <1624524156.04etgk7zmz.astroid@bobo.none>
X-Mailman-Approved-At: Thu, 24 Jun 2021 04:57:25 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 kvm-ppc@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linux-mips@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
> From: David Stevens <stevensd@chromium.org>

Changelog? This looks like a bug, should it have a Fixes: tag?

Thanks,
Nick

> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu_audit.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
> index cedc17b2f60e..97ff184084b4 100644
> --- a/arch/x86/kvm/mmu/mmu_audit.c
> +++ b/arch/x86/kvm/mmu/mmu_audit.c
> @@ -121,6 +121,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
>  		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
>  			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
>  			     hpa, *sptep);
> +
> +	kvm_release_pfn_clean(pfn);
>  }
>  
>  static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
> -- 
> 2.32.0.93.g670b81a890-goog
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
