Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68C7C3F68F
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 22:12:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 679E7217BA
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 22:12:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VmWWVF1N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 679E7217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E79E4A535;
	Thu,  6 Feb 2020 17:12:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cz2Tb+Hm93Fg; Thu,  6 Feb 2020 17:12:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AF7B4A51F;
	Thu,  6 Feb 2020 17:12:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22EF74A4E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 17:12:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uOb-mJ7VVSUc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 17:12:20 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F400B4A3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 17:12:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581027139;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=T0SUNgpYtoHVF7GzbI2ilrdt5y3ZW30rTkougLKR8CM=;
 b=VmWWVF1NDDfvjII8B7Jc/lqvVyE96ZLbqJDLjCOCHYC7eKhLgHvhs814jp5pZOn0MokwgS
 Xg2SO0HN9zXkKhLx42K6o+C/4+4SA1Eahuaop9gJUSH5GIvw091DoajglCGoXNaXS9LNcz
 upCMJXVql/ktGgSNFLhhkgFvqoKwVUI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-qI37AdVJNLen0faxOsVTCA-1; Thu, 06 Feb 2020 17:12:15 -0500
Received: by mail-qv1-f69.google.com with SMTP id d7so4624901qvq.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 14:12:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xnxqE/nCX2EzFDbA9kwFrPUv5TZytfq4VJeA0RRzpMU=;
 b=pWvYIpQD2CS67pUtVuRa/DwMSL+pem1dCwYJz0BddJo5bO5hmRpUeL0/a7tVjBu83a
 1D820cvkaz9y1Hai6D7dBYo6L04iee3M1IpRjC+O/v61bfFKtVxlak0nR/wFTu0GAfuF
 1bUlVKP/unMjE8BMd+hEgGNT4/BIqA0CImSV3AZtiM/sOhciX3I7aIu60Ri+4k2RlIoS
 uti/GTiZwNNgnjifdIDZW6lG2TQAlkcTDU5HXmFHMvmGnP99wTQnfmtLMgataSp6B4y4
 qKySPlo51WobFAS9ZtRUPemw0sHJ42N06VRA149/Shi2U7XlK+RJ2SlMeLqNQrDiVsmg
 kf7g==
X-Gm-Message-State: APjAAAXsPq/FQ48X5LMLfYFHhqJvqG0/874tf2ALUmw+DfZ2ifH4LRE0
 0orEYKZX6ToN/TReNT6MAjMbHsXN7kiqZ+CkOPoyy789jMJrOKLlXgAFx+CIqx/7Kl6MLxss+tB
 H5A5TE1XU6qU9Z//w+17PKILE
X-Received: by 2002:ac8:1c1d:: with SMTP id a29mr4676788qtk.183.1581027135114; 
 Thu, 06 Feb 2020 14:12:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqw/2cyK6F4lh5rp4dz7WvwTupqk8fbtvVzQEcyTi4bd7WqahSqSpQi7XlP32hR4RTgKgW30Yg==
X-Received: by 2002:ac8:1c1d:: with SMTP id a29mr4676750qtk.183.1581027134836; 
 Thu, 06 Feb 2020 14:12:14 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id w1sm357608qtk.31.2020.02.06.14.12.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Feb 2020 14:12:14 -0800 (PST)
Date: Thu, 6 Feb 2020 17:12:08 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20200206221208.GI700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20200121223157.15263-19-sean.j.christopherson@intel.com>
X-MC-Unique: qI37AdVJNLen0faxOsVTCA-1
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

On Tue, Jan 21, 2020 at 02:31:56PM -0800, Sean Christopherson wrote:
> Now that the memslot logic doesn't assume memslots are always non-NULL,
> dynamically size the array of memslots instead of unconditionally
> allocating memory for the maximum number of memslots.
> 
> Note, because a to-be-deleted memslot must first be invalidated, the
> array size cannot be immediately reduced when deleting a memslot.
> However, consecutive deletions will realize the memory savings, i.e.
> a second deletion will trim the entry.
> 
> Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> Tested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  include/linux/kvm_host.h |  2 +-
>  virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++++---
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 60ddfdb69378..8bb6fb127387 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -431,11 +431,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>   */
>  struct kvm_memslots {
>  	u64 generation;
> -	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
>  	/* The mapping table from slot id to the index in memslots[]. */
>  	short id_to_index[KVM_MEM_SLOTS_NUM];
>  	atomic_t lru_slot;
>  	int used_slots;
> +	struct kvm_memory_slot memslots[];

This patch is tested so I believe this works, however normally I need
to do similar thing with [0] otherwise gcc might complaint.  Is there
any trick behind to make this work?  Or is that because of different
gcc versions?

>  };
>  
>  struct kvm {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9b614cf2ca20..ed392ce64e59 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -565,7 +565,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
>  		return NULL;
>  
>  	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> -		slots->id_to_index[i] = slots->memslots[i].id = -1;
> +		slots->id_to_index[i] = -1;
>  
>  	return slots;
>  }
> @@ -1077,6 +1077,32 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	return old_memslots;
>  }
>  
> +/*
> + * Note, at a minimum, the current number of used slots must be allocated, even
> + * when deleting a memslot, as we need a complete duplicate of the memslots for
> + * use when invalidating a memslot prior to deleting/moving the memslot.
> + */
> +static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
> +					     enum kvm_mr_change change)
> +{
> +	struct kvm_memslots *slots;
> +	size_t old_size, new_size;
> +
> +	old_size = sizeof(struct kvm_memslots) +
> +		   (sizeof(struct kvm_memory_slot) * old->used_slots);
> +
> +	if (change == KVM_MR_CREATE)
> +		new_size = old_size + sizeof(struct kvm_memory_slot);
> +	else
> +		new_size = old_size;
> +
> +	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
> +	if (likely(slots))
> +		memcpy(slots, old, old_size);

(Maybe directly copy into it?)

> +
> +	return slots;
> +}
> +
>  static int kvm_set_memslot(struct kvm *kvm,
>  			   const struct kvm_userspace_memory_region *mem,
>  			   struct kvm_memory_slot *old,
> @@ -1087,10 +1113,9 @@ static int kvm_set_memslot(struct kvm *kvm,
>  	struct kvm_memslots *slots;
>  	int r;
>  
> -	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> +	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
>  	if (!slots)
>  		return -ENOMEM;
> -	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
>  
>  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>  		/*
> -- 
> 2.24.1
> 

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
