Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E87C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:50:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 92DD1610C7
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:49:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 92DD1610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 211A14B1A2;
	Wed, 27 Oct 2021 12:49:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5hD7NNWKfjhe; Wed, 27 Oct 2021 12:49:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D63334B1A3;
	Wed, 27 Oct 2021 12:49:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 356C84B121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 09:41:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tE6IAAR6NWxb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 09:41:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E82F64A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 09:41:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635342063;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/no10Aa/zZ1ucVFb2s+gZiK3uB9pJ6W+0T89aCEE3wg=;
 b=RmBfWDu3pVpLjIC1L1s4KhAomSyoAjv2zH3pjoDSN+CU0IyqADAcmAajIBkxSec5+uPi+a
 drKZFAe7T60vGxEBrG/UycPuoq5xl5yJvcT19tcSSNia2PD2YAsPf6wfHn9EwePnqPl7QL
 WASAb4FumbVOKWkr/YAcxs8f/f9obgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-SCIw7oS_OWK-BwM7oLJx0w-1; Wed, 27 Oct 2021 09:40:58 -0400
X-MC-Unique: SCIw7oS_OWK-BwM7oLJx0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F7711966320;
 Wed, 27 Oct 2021 13:40:54 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 4809F5DF35;
 Wed, 27 Oct 2021 13:40:41 +0000 (UTC)
Message-ID: <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Oct 2021 16:40:40 +0300
In-Reply-To: <20211009021236.4122790-12-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mailman-Approved-At: Wed, 27 Oct 2021 12:49:56 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Invoke the arch hooks for block+unblock if and only if KVM actually
> attempts to block the vCPU.  The only non-nop implementation is on x86,
> specifically SVM's AVIC, and there is no need to put the AVIC prior to
> halt-polling as KVM x86's kvm_vcpu_has_events() will scour the full vIRR
> to find pending IRQs regardless of whether the AVIC is loaded/"running".
> 
> The primary motivation is to allow future cleanup to split out "block"
> from "halt", but this is also likely a small performance boost on x86 SVM
> when halt-polling is successful.
> 
> Adjust the post-block path to update "cur" after unblocking, i.e. include
> AVIC load time in halt_wait_ns and halt_wait_hist, so that the behavior
> is consistent.  Moving just the pre-block arch hook would result in only
> the AVIC put latency being included in the halt_wait stats.  There is no
> obvious evidence that one way or the other is correct, so just ensure KVM
> is consistent.
> 
> Note, x86 has two separate paths for handling APICv with respect to vCPU
> blocking.  VMX uses hooks in x86's vcpu_block(), while SVM uses the arch
> hooks in kvm_vcpu_block().  Prior to this path, the two paths were more
> or less functionally identical.  That is very much not the case after
> this patch, as the hooks used by VMX _must_ fire before halt-polling.
> x86's entire mess will be cleaned up in future patches.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f90b3ed05628..227f6bbe0716 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3235,8 +3235,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	bool waited = false;
>  	u64 block_ns;
>  
> -	kvm_arch_vcpu_blocking(vcpu);
> -
>  	start = cur = poll_end = ktime_get();
>  	if (do_halt_poll) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
> @@ -3253,6 +3251,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		} while (kvm_vcpu_can_poll(cur, stop));
>  	}
>  
> +	kvm_arch_vcpu_blocking(vcpu);
>  
>  	prepare_to_rcuwait(wait);
>  	for (;;) {
> @@ -3265,6 +3264,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		schedule();
>  	}
>  	finish_rcuwait(wait);
> +
> +	kvm_arch_vcpu_unblocking(vcpu);
> +
>  	cur = ktime_get();
>  	if (waited) {
>  		vcpu->stat.generic.halt_wait_ns +=
> @@ -3273,7 +3275,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  				ktime_to_ns(cur) - ktime_to_ns(poll_end));
>  	}
>  out:
> -	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
>  	/*

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
