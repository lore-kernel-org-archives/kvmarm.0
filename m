Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46352C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 05:20:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 858C649EF0;
	Fri, 18 Mar 2022 01:20:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eg10hMbvPurH; Fri, 18 Mar 2022 01:20:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BD4049F35;
	Fri, 18 Mar 2022 01:20:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6349D49ECB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 01:20:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R8gokeHhN7wY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 01:19:59 -0400 (EDT)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A23C49EC2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 01:19:59 -0400 (EDT)
Received: by mail-pf1-f169.google.com with SMTP id s42so8676465pfg.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 22:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :references:from:in-reply-to:content-transfer-encoding;
 bh=vjwmQ3LT6/MkM+MWL06sDoV0rE+62vRkuXuZNHEGmFU=;
 b=mHQKT60iyniva73gouIOenNIHLub2xIvh+8EdLLsaXtCdjXEgCfQrIYyHtHSycjfRg
 wptHBKzGOPMl7woR/FcYF79fj3jxK7w/n2R+udkl/QV+d+PX4WbQIWBiyc84XrWja5GJ
 Dwu02jG+5sHm/SdCKKI7/F0Ymhvz8g1W+BAC9P8x5TI8RSDDN+R1E27eYwrDkdxH5w/H
 h9nNby/UTuXbz4rjFthmMGzMWR40/kNow6uFBHmrNZSi+1PyRqgG+acO2rjBWTUKfNUr
 fkd54cgyjL0DKhRUuy2JGSA75IEoYIs5BxiZrTY0rcVzKLeBwulGGvhdo7Dp1KVgBzMj
 doNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to
 :content-transfer-encoding;
 bh=vjwmQ3LT6/MkM+MWL06sDoV0rE+62vRkuXuZNHEGmFU=;
 b=nQh7EQzEln4RkORREhbi4dky0wqNLrZiAEV9f2762c1iIJAidRJM0HG4Gb9wH9MO3k
 ++NdO1Qiqklgmzzso4xvNKBdtS/CVNNFuHhePxPfZhUJgJlRh9z8RTSoxE+AKhz9+ix/
 TrqVDDiPom3T+xRSFennDlO3QDsjStjN3PIRpLtAnhTsLY5/BfK/5S3oYAGaDQERKM/L
 Htrq0R4hI968hChhffHz2sBqzAm8xPNNC1Q/f+oGQAKv1Xyvo4ITosGjUDZnoh0YJrEn
 pC4yjybjxxw1V54f6eaBRpFmjYjtj2JqDT61tXjkEwpWWIQk1kot0Nodm/P8jzhne4OO
 sfLw==
X-Gm-Message-State: AOAM533k6Eah6PFhQNhIWQBujVt/3KAUBnpcRzedd6KetcglCk9gpPbH
 WAC620J9NktHCtR5CnInrjqasw4txBkcT+CQ
X-Google-Smtp-Source: ABdhPJxamSUJqhC8eJyQ1Eb0PcmI1KtDN5hr3RNTdm9ta4m/H65UtCPnuVxhMmomnEdD0w1ybZ1bTg==
X-Received: by 2002:a63:dd54:0:b0:382:2fb1:13cf with SMTP id
 g20-20020a63dd54000000b003822fb113cfmr714217pgj.72.1647580798076; 
 Thu, 17 Mar 2022 22:19:58 -0700 (PDT)
Received: from [192.168.86.237]
 (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
 by smtp.gmail.com with ESMTPSA id
 ng12-20020a17090b1a8c00b001bfc847b555sm11386072pjb.46.2022.03.17.22.19.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 17 Mar 2022 22:19:57 -0700 (PDT)
Message-ID: <0ce1011b-6e77-f00c-6d19-5b5394e0d0c2@google.com>
Date: Thu, 17 Mar 2022 22:19:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v5 08/38] KVM: arm64: Unlock memslots after stage 2
 tables are freed
Content-Language: en-US
To: Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-9-alexandru.elisei@arm.com>
From: Reiji Watanabe <reijiw@google.com>
In-Reply-To: <20211117153842.302159-9-alexandru.elisei@arm.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alex,

On 11/17/21 7:38 AM, Alexandru Elisei wrote:
> Unpin the backing pages mapped at stage 2 after the stage 2 translation
> tables are destroyed.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cd6f1bc7842d..072e2aba371f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1627,11 +1627,19 @@ int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags)
>   	return ret;
>   }
>   
> -static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
> +static void __unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   {
>   	bool writable = memslot->arch.flags & KVM_MEMSLOT_LOCK_WRITE;
>   	unsigned long npages = memslot->npages;
>   
> +	unpin_memslot_pages(memslot, writable);
> +	account_locked_vm(current->mm, npages, false);
> +
> +	memslot->arch.flags &= ~KVM_MEMSLOT_LOCK_MASK;
> +}
> +
> +static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
> +{
>   	/*
>   	 * MMU maintenace operations aren't performed on an unlocked memslot.
>   	 * Unmap it from stage 2 so the abort handler performs the necessary
> @@ -1640,10 +1648,7 @@ static void unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   	if (kvm_mmu_has_pending_ops(kvm))
>   		kvm_arch_flush_shadow_memslot(kvm, memslot);
>   
> -	unpin_memslot_pages(memslot, writable);
> -	account_locked_vm(current->mm, npages, false);
> -
> -	memslot->arch.flags &= ~KVM_MEMSLOT_LOCK_MASK;
> +	__unlock_memslot(kvm, memslot);
>   }
>   
>   int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags)
> @@ -1951,7 +1956,15 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>   
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
> +	struct kvm_memory_slot *memslot;
> +
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +
> +	kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
> +		if (!memslot_is_locked(memslot))
> +			continue;
> +		__unlock_memslot(kvm, memslot);
> +	}
>   }

Perhaps it might be useful to manage the number of locked memslots ?
(can be used in the fix for kvm_mmu_unlock_memslot in the patch-7 as well)
                                                  
Thanks,
Reiji


>   
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
