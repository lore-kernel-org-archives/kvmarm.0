Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB47C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 17:16:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE015610C8
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 17:16:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EE015610C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FC134B126;
	Thu, 28 Oct 2021 13:16:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TOnQB1I30FuT; Thu, 28 Oct 2021 13:16:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4A864B1FB;
	Thu, 28 Oct 2021 13:16:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D53E4B164
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 11:46:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EWyUia9GTbWJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 11:46:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E81E74B1A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 11:46:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635435968;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=F4tMjT47BZ3DwbmAEWq81W0GAGbuRTe5m3IotIof8YU=;
 b=gWFysqyj8zZtvoJR4obbTaw2QCpBs1sFglKd5SqxwmReJJoY/iZDzGDsc3ki9ei8QvaGkX
 iRCimidQsaRYmyaK0poCzMZ0Sz/fX7HOun2bQ44tJrFSHX9Ab+Vr+zE9Sxy6XQ9FPCl1Gi
 2a80P0wHJbWhY0WDaMWZawtfkAsVk9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-HPiuQd71NyeJUfJbOWNqdw-1; Thu, 28 Oct 2021 11:46:07 -0400
X-MC-Unique: HPiuQd71NyeJUfJbOWNqdw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F02CB19251A0;
 Thu, 28 Oct 2021 15:46:02 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9106C5DA61;
 Thu, 28 Oct 2021 15:45:15 +0000 (UTC)
Message-ID: <06ed37a510347fdc7c6f7ce46fd98ce5b9ff7554.camel@redhat.com>
Subject: Re: [PATCH v2 32/43] KVM: VMX: Move preemption timer <=> hrtimer
 dance to common x86
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Oct 2021 18:45:14 +0300
In-Reply-To: <20211009021236.4122790-33-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-33-seanjc@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mailman-Approved-At: Thu, 28 Oct 2021 13:15:59 -0400
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
> Handle the switch to/from the hypervisor/software timer when a vCPU is
> blocking in common x86 instead of in VMX.  Even though VMX is the only
> user of a hypervisor timer, the logic and all functions involved are
> generic x86 (unless future CPUs do something completely different and
> implement a hypervisor timer that runs regardless of mode).
> 
> Handling the switch in common x86 will allow for the elimination of the
> pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
> timer if and only if it was in use (without additional params).  Add a
> comment explaining why the switch cannot be deferred to kvm_sched_out()
> or kvm_vcpu_block().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |  6 +-----
>  arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b3bb2031a7ac..a24f19874716 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7464,16 +7464,12 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>  
>  static int vmx_pre_block(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_lapic_hv_timer_in_use(vcpu))
> -		kvm_lapic_switch_to_sw_timer(vcpu);
> -
>  	return 0;
>  }
>  
>  static void vmx_post_block(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_x86_ops.set_hv_timer)
> -		kvm_lapic_switch_to_hv_timer(vcpu);
> +
>  }
>  
>  static void vmx_setup_mce(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0219acfd9cf..909e932a7ae7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9896,8 +9896,21 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  {
> +	bool hv_timer;
> +
>  	if (!kvm_arch_vcpu_runnable(vcpu) &&
>  	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
> +		/*
> +		 * Switch to the software timer before halt-polling/blocking as
> +		 * the guest's timer may be a break event for the vCPU, and the
> +		 * hypervisor timer runs only when the CPU is in guest mode.
> +		 * Switch before halt-polling so that KVM recognizes an expired
> +		 * timer before blocking.
> +		 */

I didn't knew about this until now but it all makes sense. The comment is very good.

> +		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
> +		if (hv_timer)
> +			kvm_lapic_switch_to_sw_timer(vcpu);
> +
>  		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>  		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
>  			kvm_vcpu_halt(vcpu);
> @@ -9905,6 +9918,9 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  			kvm_vcpu_block(vcpu);
>  		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>  
> +		if (hv_timer)
> +			kvm_lapic_switch_to_hv_timer(vcpu);
> +
>  		if (kvm_x86_ops.post_block)
>  			static_call(kvm_x86_post_block)(vcpu);
>  
> @@ -10136,6 +10152,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  			r = -EINTR;
>  			goto out;
>  		}
> +		/*
> +		 * It should be impossible for the hypervisor timer to be in
> +		 * use before KVM has ever run the vCPU.
> +		 */
> +		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
>  		kvm_vcpu_block(vcpu);
>  		if (kvm_apic_accept_events(vcpu) < 0) {
>  			r = 0;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
