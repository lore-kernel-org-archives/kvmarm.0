Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61449C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 17:19:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5F18610FC
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 17:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D5F18610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ECA94B1DC;
	Thu, 28 Oct 2021 13:19:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rneKcaJ5-O-8; Thu, 28 Oct 2021 13:19:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BD34B172;
	Thu, 28 Oct 2021 13:19:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49F984B0DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 13:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g1-91eTIim-F for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 13:19:40 -0400 (EDT)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9AFF94B0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 13:19:40 -0400 (EDT)
Received: by mail-pj1-f53.google.com with SMTP id
 lx5-20020a17090b4b0500b001a262880e99so5286339pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 10:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=q4iJG3ZW7obL4DMmrtDt5ktj041PvD+dEvmTQN+uKyY=;
 b=mnkWkJlsD3Efv+dhabg9XRW3VcAMBFLrAWU0a5kq4aSl4p3OkuIs64Ri3PE1R6G45W
 WWX1srIjeyGp7bl0JwXP4EsqbWo0C7Rq7LlpprSwJJDhP6Z9C4BlGZ6pF0W6uFPVwJd6
 newuZGIp7fi3S1LWbDnukcAYyKzMEUnwUDvBD8yhO2TaY/ppfXW+LzQN7N/3ahTyR+Xa
 EoqLzmvlkN3t1dBGcUsabuqlQMThWwYqrYkPzmYbFq4TCGSH1FBWF6bLFrKhvfl+wIkg
 myDgbOosQ39NTrE5GkyLOk3F2ofMqkvjX3mEfa4Ds01sxY6mlbwLLtW+SYgm0DJ0rLj4
 pK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=q4iJG3ZW7obL4DMmrtDt5ktj041PvD+dEvmTQN+uKyY=;
 b=2wQwcZ8XPKsBkBZV9GzzfrDQaXGNtVHPQLJbIqsFFkEKHORoMwVLvWzCB3yDSRGU9Q
 44r2YiPG5peVR0N2oD3yQFTuuolid6mVLDsDH2cEv8PblyngoXjHIxbbSvNI14vaxqJc
 SQ5/XjaaWpci28LhPn2BwTsJSb0lkU1FgQ1aGmk/jJhMTWsgC4jVaLq/+pNPc6OfxF8s
 8SHgMQ/inJ0vsFgLtSLOHaKcCxfrLJzrPjROC8ChpingGs1gFUZCLdAq4T3xUR90EC/B
 DE+vysjHUA4W7w4r7AddACgP00GJW4lEZvMy1wk6LgZ7DqcvpoBObW0q7xSgFQCIZgPx
 58nA==
X-Gm-Message-State: AOAM530QcpzqyPghOzXYqvDkv6KeZZ6Ql7cgEnoRmdBZi4gIzvuH/AZo
 VzY9bZRytSZyIiJbq8cqKLdJiQ==
X-Google-Smtp-Source: ABdhPJybd062Z7dZdlv5Ua0y9WgXsZDlcpD/ngOKZtR+XtlO0zPIxbocuXwUccJIVKZ7ltOnF8e4MQ==
X-Received: by 2002:a17:90a:b105:: with SMTP id
 z5mr5854314pjq.181.1635441579540; 
 Thu, 28 Oct 2021 10:19:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id d24sm3945465pfn.62.2021.10.28.10.19.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Oct 2021 10:19:38 -0700 (PDT)
Date: Thu, 28 Oct 2021 17:19:34 +0000
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 28/43] KVM: VMX: Remove vCPU from PI wakeup list
 before updating PID.NV
Message-ID: <YXrbpvHG7YD0MNO2@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-29-seanjc@google.com>
 <558e7e4c36e649709837079a25c2f56fc5609fbe.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <558e7e4c36e649709837079a25c2f56fc5609fbe.camel@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Remove the vCPU from the wakeup list before updating the notification
> > vector in the posted interrupt post-block helper.  There is no need to
> > wake the current vCPU as it is by definition not blocking.  Practically
> > speaking this is a nop as it only shaves a few meager cycles in the
> > unlikely case that the vCPU was migrated and the previous pCPU gets a
> > wakeup IRQ right before PID.NV is updated.  The real motivation is to
> > allow for more readable code in the future, when post-block is merged
> > with vmx_vcpu_pi_load(), at which point removal from the list will be
> > conditional on the old notification vector.
> > 
> > Opportunistically add comments to document why KVM has a per-CPU spinlock
> > that, at first glance, appears to be taken only on the owning CPU.
> > Explicitly call out that the spinlock must be taken with IRQs disabled, a
> > detail that was "lost" when KVM switched from spin_lock_irqsave() to
> > spin_lock(), with IRQs disabled for the entirety of the relevant path.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/posted_intr.c | 49 +++++++++++++++++++++++-----------
> >  1 file changed, 33 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 2b2206339174..901b7a5f7777 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -10,10 +10,22 @@
> >  #include "vmx.h"
> >  
> >  /*
> > - * We maintain a per-CPU linked-list of vCPU, so in wakeup_handler() we
> > - * can find which vCPU should be waken up.
> > + * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
> Nit: While at it, it would be nice to rename this to pi_wakeup_hanlder() so
> that it can be more easilly found.

Ah, good catch.

> > + * when a WAKEUP_VECTOR interrupted is posted.  vCPUs are added to the list when
> > + * the vCPU is scheduled out and is blocking (e.g. in HLT) with IRQs enabled.
> s/interrupted/interrupt ?
> 
> Isn't that comment incorrect? As I see, the PI hardware is setup to use the WAKEUP_VECTOR
> when vcpu blocks (in pi_pre_block) and then that vcpu is added to the list.
> The pi_wakeup_hanlder just goes over the list and wakes up all vcpus on the lsit.

Doh, yes.  This patch is predicting the future.  The comment becomes correct as of 

  KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load

but as of this patch the "scheduled out" piece doesn't hold true.
 
> > + * The vCPUs posted interrupt descriptor is updated at the same time to set its
> > + * notification vector to WAKEUP_VECTOR, so that posted interrupt from devices
> > + * wake the target vCPUs.  vCPUs are removed from the list and the notification
> > + * vector is reset when the vCPU is scheduled in.
> >   */
> >  static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
> Also while at it, why not to rename this to 'blocked_vcpu_list'?
> to explain that this is list of blocked vcpus. Its a per-cpu variable
> so 'on_cpu' suffix isn't needed IMHO.

As you noted, addressed in a future patch.

> > +/*
> > + * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
> > + * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
> > + * ->sched_in() path will need to take the vCPU off the list of the _previous_
> > + * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
> > + * occur if a wakeup IRQ arrives and attempts to acquire the lock.
> > + */
> >  static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
> >  
> >  static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
> > @@ -101,23 +113,28 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
> >  	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
> >  	     "Wakeup handler not enabled while the vCPU was blocking");
> >  
> > -	dest = cpu_physical_id(vcpu->cpu);
> > -	if (!x2apic_mode)
> > -		dest = (dest << 8) & 0xFF00;
> > -
> > -	do {
> > -		old.control = new.control = READ_ONCE(pi_desc->control);
> > -
> > -		new.ndst = dest;
> > -
> > -		/* set 'NV' to 'notification vector' */
> > -		new.nv = POSTED_INTR_VECTOR;
> > -	} while (cmpxchg64(&pi_desc->control, old.control,
> > -			   new.control) != old.control);
> > -
> > +	/*
> > +	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
> > +	 * will not be the same as the current pCPU if the task was migrated.
> > +	 */
> >  	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> >  	list_del(&vcpu->blocked_vcpu_list);
> >  	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> > +
> > +	dest = cpu_physical_id(vcpu->cpu);
> > +	if (!x2apic_mode)
> > +		dest = (dest << 8) & 0xFF00;
> It would be nice to have a function for this, this appears in this file twice.
> Maybe there is a function already somewhere?

The second instance does go away by the aforementioned:

  KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load

I'm inclined to say we don't want a helper because there should only ever be one
path that changes PI.ndst.  But a comment would definitely help to explain the
difference between xAPIC and x2APIC IDs.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
