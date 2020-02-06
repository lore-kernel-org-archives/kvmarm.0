Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1781C35247
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 20:02:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56EA82465D
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 20:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Im1C1pY0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56EA82465D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938044A541;
	Thu,  6 Feb 2020 15:02:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n+n2okBuWvPu; Thu,  6 Feb 2020 15:02:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71C1B4A524;
	Thu,  6 Feb 2020 15:02:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8801A4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 15:02:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GjvwNkUMT67M for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 15:02:07 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80A1C4A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 15:02:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581019327;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9XkBxwvCFKcvnGkMekt7sgnZTCs1povbWkxbmREBl2Q=;
 b=Im1C1pY03e31ol7b1xJQxBgCiFegkkOLHWoS/1hdhDKOOs0KXUsDefYAqY8I87gf1ZQO1l
 yQo2wgp2SSlORf2He9LbaLLK9LrgwMgCgS1IFyV2tn34wUvEnoUQS4tIu70bxmlyr1dUHd
 5o1le7YE9EWtHmNpPnXGWTITy9azKtI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-tYV4k9XsNASDRioDuPbvcA-1; Thu, 06 Feb 2020 15:02:05 -0500
Received: by mail-qk1-f200.google.com with SMTP id q2so4352317qkq.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 12:02:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/yqizwNchM67CZ4udbXR6GdfQrlh05oiSzFTK/80D3I=;
 b=oQpYSkD8WJORD8E34Q9IH6BpImmVJQBEhXNZ7mOHIFOT/Pw6kZwWtiVH3cXiImV+eo
 HZbI2HixjJ5Icice1oD1jjtlqqzSHshO7ml9grtot6ys8p8zebSalcyRtWqHDNgw6Arc
 H0SyLKS8QSgxnXG+hKdRRL1mCzMM0Ib+5A/M5vnOA0C1ivDDLrSm4uPAPPnHyXSUT3AE
 7wKVEcwZGFY6hOHr9PSPz67CKxp/P+Ges+txKXOEULiXfSeTjCpkXXxxsUYUqjF/D4nW
 gXPUScwQ9t0ahf6W14ANHnCTPWlCXL83LYGo0f6c33HE2MkDPIVmqOAi9A1nqtoDOf1p
 qXRg==
X-Gm-Message-State: APjAAAVV2xGBVbpgyt8BPA03d1wmF20Ps/3IBc2HtR9tLWlbMwwlRc5s
 urwjxHM0qwMYn/e+i5tbDMaMUZEpbp0uQl6Rgu+mtB7XZ13oyp2IeYLHMMOtn3Kvzfuh/x9R6E0
 06c3psIamg3vy8EqhidBjvnIo
X-Received: by 2002:ac8:19b6:: with SMTP id u51mr4287216qtj.319.1581019324651; 
 Thu, 06 Feb 2020 12:02:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzOujc3lNLMWX/FRlR8tea+183dvvLwpGv6w6oIURj933aU7qyXuyTi9CIJeDyrMsTLUQvKYA==
X-Received: by 2002:ac8:19b6:: with SMTP id u51mr4287163qtj.319.1581019324320; 
 Thu, 06 Feb 2020 12:02:04 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id k50sm163595qtc.90.2020.02.06.12.02.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 12:02:03 -0800 (PST)
Date: Thu, 6 Feb 2020 15:02:00 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200206200200.GC700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-16-sean.j.christopherson@intel.com>
X-MC-Unique: tYV4k9XsNASDRioDuPbvcA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Tue, Jan 21, 2020 at 02:31:53PM -0800, Sean Christopherson wrote:

[...]

> -int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *log)
> +void kvm_arch_dirty_log_tlb_flush(struct kvm *kvm,
> +				  struct kvm_memory_slot *memslot)

If it's to flush TLB for a memslot, shall we remove the "dirty_log" in
the name of the function, because it has nothing to do with dirty
logging any more?  And...

>  {
> -	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
> -	bool flush = false;
> -	int r;
> -
> -	mutex_lock(&kvm->slots_lock);
> -
> -	r = kvm_clear_dirty_log_protect(kvm, log, &flush);
> -
> -	if (flush) {
> -		slots = kvm_memslots(kvm);
> -		memslot = id_to_memslot(slots, log->slot);
> -
> -		/* Let implementation handle TLB/GVA invalidation */
> -		kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> -	}
> -
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
> +	/* Let implementation handle TLB/GVA invalidation */
> +	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);

... This may not directly related to the current patch, but I'm
confused on why MIPS cannot use kvm_flush_remote_tlbs() to flush TLBs.
I know nothing about MIPS code, but IIUC here flush_shadow_memslot()
is a heavier operation that will also invalidate the shadow pages.
Seems to be an overkill here when we only changed write permission of
the PTEs?  I tried to check the first occurance (2a31b9db15353) but I
didn't find out any clue of it so far.

But that matters to this patch because if MIPS can use
kvm_flush_remote_tlbs(), then we probably don't need this
arch-specific hook any more and we can directly call
kvm_flush_remote_tlbs() after sync dirty log when flush==true.

>  }
>  
>  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 97ce6c4f7b48..0adaf4791a6d 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -799,6 +799,11 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
>  	return vcpu->kvm->arch.kvm_ops->check_requests(vcpu);
>  }
>  
> +void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)

Since at it, maybe we can start to use __weak attribute for new hooks
especially when it's empty for most archs?

E.g., define:

void __weak kvm_arch_sync_dirty_log(...) {}

In the common code, then only define it again in arch that has
non-empty implementation of this method?

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
