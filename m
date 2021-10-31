Return-Path: <SRS0=q2PC=PU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7B9C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 21:40:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36507610FC
	for <kvmarm@archiver.kernel.org>; Mon,  1 Nov 2021 21:40:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 36507610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABEE24B26A;
	Mon,  1 Nov 2021 17:40:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZikjCgAwHZGE; Mon,  1 Nov 2021 17:40:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 912A84B241;
	Mon,  1 Nov 2021 17:40:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 168434B1AF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 10:51:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id agsjR+2aBpZI for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 Oct 2021 10:51:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B7F44B1A2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 Oct 2021 10:51:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635691877;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JWkqObtzatE8ZqTA7P0n9xOaXL3kRPYh9u09IqRGd+c=;
 b=YbfpCla095LLS2kGegcZiwxuYq9j+Z+VmuOqAnI8Mptjn005Re/0HVZKW3aNEr70O8U8cZ
 qKIUvMxna6Y9wQRlXOzzjGvft+QuJrhLwpLuxvA4RkJDlbjz4kMmMAuZj1hxupfKC8KpcP
 XDNFVySxYhX+kzotQgxq7XXiDbOtweE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-hgIuyZhQNzuaYxdMVVu2jQ-1; Sun, 31 Oct 2021 10:51:14 -0400
X-MC-Unique: hgIuyZhQNzuaYxdMVVu2jQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C08418D6A25;
 Sun, 31 Oct 2021 14:51:10 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 885E65F4E9;
 Sun, 31 Oct 2021 14:50:40 +0000 (UTC)
Message-ID: <ca017e53bfa81d96dc534e395ff35b6899607fd8.camel@redhat.com>
Subject: Re: [PATCH v2 36/43] KVM: SVM: Don't bother checking for "running"
 AVIC when kicking for IPIs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 31 Oct 2021 16:50:39 +0200
In-Reply-To: <20211009021236.4122790-37-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-37-seanjc@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mailman-Approved-At: Mon, 01 Nov 2021 17:40:12 -0400
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
> Drop the avic_vcpu_is_running() check when waking vCPUs in response to a
> VM-Exit due to incomplete IPI delivery.  The check isn't wrong per se, but
> it's not 100% accurate in the sense that it doesn't guarantee that the vCPU
> was one of the vCPUs that didn't receive the IPI.
> 
> The check isn't required for correctness as blocking == !running in this
> context.
> 
> From a performance perspective, waking a live task is not expensive as the
> only moderately costly operation is a locked operation to temporarily
> disable preemption.  And if that is indeed a performance issue,
> kvm_vcpu_is_blocking() would be a better check than poking into the AVIC.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 15 +++++++++------
>  arch/x86/kvm/svm/svm.h  | 11 -----------
>  2 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index cbf02e7e20d0..b43b05610ade 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -295,13 +295,16 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  	struct kvm_vcpu *vcpu;
>  	int i;
>  
> +	/*
> +	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
> +	 * event.  There's no need to signal doorbells, as hardware has handled
> +	 * vCPUs that were in guest at the time of the IPI, and vCPUs that have
> +	 * since entered the guest will have processed pending IRQs at VMRUN.
> +	 */
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		bool m = kvm_apic_match_dest(vcpu, source,
> -					     icrl & APIC_SHORT_MASK,
> -					     GET_APIC_DEST_FIELD(icrh),
> -					     icrl & APIC_DEST_MASK);
> -
> -		if (m && !avic_vcpu_is_running(vcpu))
> +		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> +					GET_APIC_DEST_FIELD(icrh),
> +					icrl & APIC_DEST_MASK))
>  			kvm_vcpu_wake_up(vcpu);
>  	}
>  }
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0d7bbe548ac3..7f5b01bbee29 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -509,17 +509,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>  
>  #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
>  
> -static inline bool (struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	u64 *entry = svm->avic_physical_id_cache;
> -
> -	if (!entry)
> -		return false;
> -
> -	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
> -}
> -
>  int avic_ga_log_notifier(u32 ga_tag);
>  void avic_vm_destroy(struct kvm *kvm);
>  int avic_vm_init(struct kvm *kvm);


I guess this makes sense to do, to get rid of the avic_vcpu_is_running.
As you explained in previous patch, waking up a live task isn't that expensive,
so let it be.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
