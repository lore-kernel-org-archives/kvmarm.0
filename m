Return-Path: <SRS0=Hq6c=2H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F5BC43603
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:24:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B9D121582
	for <kvmarm@archiver.kernel.org>; Tue, 17 Dec 2019 22:24:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SFKqZK/h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B9D121582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D526E4A800;
	Tue, 17 Dec 2019 17:24:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5POWU-IPMgda; Tue, 17 Dec 2019 17:24:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B87ED4A500;
	Tue, 17 Dec 2019 17:24:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8E264A4AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:24:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MduL4iLWLBpC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Dec 2019 17:24:53 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 733EB4A418
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 17:24:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576621493;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Xu0GsxfGKpwtsXvGwdOyh0k7RpXc8dRb7e9p2lxb8fE=;
 b=SFKqZK/hh7DTYLLfxcMcSf80THoDv96J9aVPyfBkS3JoD/sUKBh4J+xiMbzD3os8+LNq9Z
 RSxXI/WLCfL7U/uluJJcRfUrLSWifrHtpJYascQWwxUbXxNXPyd5L95p9+kVVyZ0Kbr59/
 9CMNlYjUXYGGoldvOkyenlJR7r4dYng=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-WI5fOrNqPha_30XuFhOQ8w-1; Tue, 17 Dec 2019 17:24:49 -0500
Received: by mail-qt1-f198.google.com with SMTP id 69so160690qtb.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Dec 2019 14:24:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=n1zc/BAvLiuzmjBuBeyM8c5OGj4eP3sDEL7oyAZ0h/8=;
 b=QHZsqgHAYM0gbsrN71gMftKYRmG4kvvInnXRWdvSkMXPb05J0RyMVX7h3o9Lk0getH
 wYq4p8Hl1zsgvfJkJs0AWz4MP+TrMSdNf3mXKMpbTCUQhYHxdJlJL1yqxFarJ3WcNmNL
 11ZYVxkUTZv3TiVrMJHrZ3U75EOj2ojc0VFQOHIWTRQ3EVKD59TUQQlWojcM772bbe4c
 v9izNrPMrr0Sr92uzU39hlWcd5hvIEaHWXQi3PQwADDaQPybkFDVFn0a6l+oRQWDTZfN
 1BAkm1V2LoTbXewX/iXANNbegwniDp6SCs4CZ7x2xiQMy5ot9hA3xrr6vcsFl1gEYHJu
 uh+g==
X-Gm-Message-State: APjAAAUj9f7e2nn2bgVV+rUDxLfjl+vXJAQGnaR0+e60FvKCqcetw7Ro
 LGV2bsQEDOTdyvxRj6X6Q2QATwj/kgtYie+plh+1iVbKaA3JyZba0BWNA6FbYmbED4sp/Xh81Ci
 qtRQgX18wZOk3OyhEq/Qhn+gA
X-Received: by 2002:ac8:3177:: with SMTP id h52mr248055qtb.264.1576621488933; 
 Tue, 17 Dec 2019 14:24:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxa9aGwr5mHm2Cm0VxXNZlZXqTAo8dq2kd9eCG/gVR+l9nUybMoSUNtPMwlIhbLMlDgqBEiTQ==
X-Received: by 2002:ac8:3177:: with SMTP id h52mr248020qtb.264.1576621488653; 
 Tue, 17 Dec 2019 14:24:48 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
 by smtp.gmail.com with ESMTPSA id c84sm7565689qkg.78.2019.12.17.14.24.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 Dec 2019 14:24:47 -0800 (PST)
Date: Tue, 17 Dec 2019 17:24:46 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 07/19] KVM: Explicitly free allocated-but-unused dirty
 bitmap
Message-ID: <20191217222446.GK7258@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-8-sean.j.christopherson@intel.com>
MIME-Version: 1.0
In-Reply-To: <20191217204041.10815-8-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: WI5fOrNqPha_30XuFhOQ8w-1
X-Mimecast-Spam-Score: 0
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Tue, Dec 17, 2019 at 12:40:29PM -0800, Sean Christopherson wrote:
> Explicitly free an allocated-but-unused dirty bitmap instead of relying
> on kvm_free_memslot() if an error occurs in __kvm_set_memory_region().
> There is no longer a need to abuse kvm_free_memslot() to free arch
> specific resources as arch specific code is now called only after the
> common flow is guaranteed to succeed.  Arch code can still fail, but
> it's responsible for its own cleanup in that case.
> 
> Eliminating the error path's abuse of kvm_free_memslot() paves the way
> for simplifying kvm_free_memslot(), i.e. dropping its @dont param.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d403e93e3028..6b2261a9e139 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1096,7 +1096,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  
>  	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
>  	if (!slots)
> -		goto out_free;
> +		goto out_bitmap;
>  	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
>  
>  	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> @@ -1144,8 +1144,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
>  		slots = install_new_memslots(kvm, as_id, slots);
>  	kvfree(slots);
> -out_free:
> -	kvm_free_memslot(kvm, &new, &old);
> +out_bitmap:
> +	if (new.dirty_bitmap && !old.dirty_bitmap)
> +		kvm_destroy_dirty_bitmap(&new);

What if both the old and new have KVM_MEM_LOG_DIRTY_PAGES set?
kvm_free_memslot() did cover that but I see that you explicitly
dropped it.  Could I ask why?  Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
