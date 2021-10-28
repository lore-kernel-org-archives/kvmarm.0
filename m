Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3254C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85DA361056
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 14:09:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 85DA361056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 351504B1AA;
	Thu, 28 Oct 2021 10:09:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JUFj82kJRFKp; Thu, 28 Oct 2021 10:09:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 781B34B1F3;
	Thu, 28 Oct 2021 10:09:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 330FB4B156
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 08:53:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aFyO2hsLHb1L for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 08:53:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B854B153
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 08:53:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635425616;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AzVqjh+2Lud5A9V6SBUfySTC7Jdhp9VKIE8pHEMoxEM=;
 b=Haw4meDnnZiRNqepWdJFiqTa/PAiOvLV38FWXEXwIlArT5exwBdzbYcE1nm/SYMwkwnJbn
 Ruv4+XnNWlHbMrY2qYwYy/lyn4TIq6WxuxbJqteBHV67OKIFlK7nuqtNeEApmcAEeQ2k7W
 m/EJaZj3ddTXLnSZSkrsgaZt9w5ABmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-ldzfqrMaMG-LB-zAjma-Rg-1; Thu, 28 Oct 2021 08:53:33 -0400
X-MC-Unique: ldzfqrMaMG-LB-zAjma-Rg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1F24802682;
 Thu, 28 Oct 2021 12:53:28 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 03E025DA61;
 Thu, 28 Oct 2021 12:53:12 +0000 (UTC)
Message-ID: <558e7e4c36e649709837079a25c2f56fc5609fbe.camel@redhat.com>
Subject: Re: [PATCH v2 28/43] KVM: VMX: Remove vCPU from PI wakeup list
 before updating PID.NV
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Paul Mackerras <paulus@ozlabs.org>, Anup
 Patel <anup.patel@wdc.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 28 Oct 2021 15:53:11 +0300
In-Reply-To: <20211009021236.4122790-29-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-29-seanjc@google.com>
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mailman-Approved-At: Thu, 28 Oct 2021 10:09:13 -0400
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
> Remove the vCPU from the wakeup list before updating the notification
> vector in the posted interrupt post-block helper.  There is no need to
> wake the current vCPU as it is by definition not blocking.  Practically
> speaking this is a nop as it only shaves a few meager cycles in the
> unlikely case that the vCPU was migrated and the previous pCPU gets a
> wakeup IRQ right before PID.NV is updated.  The real motivation is to
> allow for more readable code in the future, when post-block is merged
> with vmx_vcpu_pi_load(), at which point removal from the list will be
> conditional on the old notification vector.
> 
> Opportunistically add comments to document why KVM has a per-CPU spinlock
> that, at first glance, appears to be taken only on the owning CPU.
> Explicitly call out that the spinlock must be taken with IRQs disabled, a
> detail that was "lost" when KVM switched from spin_lock_irqsave() to
> spin_lock(), with IRQs disabled for the entirety of the relevant path.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 49 +++++++++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 2b2206339174..901b7a5f7777 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -10,10 +10,22 @@
>  #include "vmx.h"
>  
>  /*
> - * We maintain a per-CPU linked-list of vCPU, so in wakeup_handler() we
> - * can find which vCPU should be waken up.
> + * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
Nit: While at it, it would be nice to rename this to pi_wakeup_hanlder() so that it can be more easilly
found.


> + * when a WAKEUP_VECTOR interrupted is posted.  vCPUs are added to the list when
> + * the vCPU is scheduled out and is blocking (e.g. in HLT) with IRQs enabled.
s/interrupted/interrupt ?

Isn't that comment incorrect? As I see, the PI hardware is setup to use the WAKEUP_VECTOR
when vcpu blocks (in pi_pre_block) and then that vcpu is added to the list.
The pi_wakeup_hanlder just goes over the list and wakes up all vcpus on the lsit.


> + * The vCPUs posted interrupt descriptor is updated at the same time to set its
> + * notification vector to WAKEUP_VECTOR, so that posted interrupt from devices
> + * wake the target vCPUs.  vCPUs are removed from the list and the notification
> + * vector is reset when the vCPU is scheduled in.
>   */
>  static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
Also while at it, why not to rename this to 'blocked_vcpu_list'?
to explain that this is list of blocked vcpus. Its a per-cpu variable
so 'on_cpu' suffix isn't needed IMHO.

> +/*
> + * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
> + * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
> + * ->sched_in() path will need to take the vCPU off the list of the _previous_
> + * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
> + * occur if a wakeup IRQ arrives and attempts to acquire the lock.
> + */
>  static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
>  
>  static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
> @@ -101,23 +113,28 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
>  	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
>  	     "Wakeup handler not enabled while the vCPU was blocking");
>  
> -	dest = cpu_physical_id(vcpu->cpu);
> -	if (!x2apic_mode)
> -		dest = (dest << 8) & 0xFF00;
> -
> -	do {
> -		old.control = new.control = READ_ONCE(pi_desc->control);
> -
> -		new.ndst = dest;
> -
> -		/* set 'NV' to 'notification vector' */
> -		new.nv = POSTED_INTR_VECTOR;
> -	} while (cmpxchg64(&pi_desc->control, old.control,
> -			   new.control) != old.control);
> -
> +	/*
> +	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
> +	 * will not be the same as the current pCPU if the task was migrated.
> +	 */
>  	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
>  	list_del(&vcpu->blocked_vcpu_list);
>  	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> +
> +	dest = cpu_physical_id(vcpu->cpu);
> +	if (!x2apic_mode)
> +		dest = (dest << 8) & 0xFF00;
It would be nice to have a function for this, this appears in this file twice.
Maybe there is a function already somewhere?


> +
> +	do {
> +		old.control = new.control = READ_ONCE(pi_desc->control);
> +
> +		new.ndst = dest;
> +
> +		/* set 'NV' to 'notification vector' */
> +		new.nv = POSTED_INTR_VECTOR;
> +	} while (cmpxchg64(&pi_desc->control, old.control,
> +			   new.control) != old.control);
> +
>  	vcpu->pre_pcpu = -1;
>  }
>  

Best regards,
	Maxim Levitsky


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
