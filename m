Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DAEC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 17:06:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E273F610D2
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 17:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E273F610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 613244B099;
	Thu, 28 Oct 2021 13:06:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yvWACmoNPLK9; Thu, 28 Oct 2021 13:06:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD144B1C7;
	Thu, 28 Oct 2021 13:06:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0B94B099
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 13:06:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z28yybeTMn15 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 13:06:49 -0400 (EDT)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C6354B08D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 13:06:49 -0400 (EDT)
Received: by mail-pg1-f182.google.com with SMTP id s136so7023019pgs.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 10:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5FMOUmei9Yd20y1XWjfcdbxiSsU6/CKiTZiNSpEJsLk=;
 b=goNQkkMJXpMPhPYFdVULDytrjQcoVu2lfwn3WuXA8ZOWfVU/JBHyZvLlEiPgcloYqE
 Jhz0+bgiXe/YWIVtHqD9uWlRDISXdiszKG8C5B2x8qq+87xgln6oUfJqk8Pl2O4vpYUv
 aElTLuihNiGwbXbMGeTzi+TT9xRVMesWVtGd6b3dr0Gyg3Ld7XrPFh8WgKV/HqWCqye6
 IN651B4/j+icyywyqYjZAUlmNgSWr91NVE2zYdE4jrE7wi4kHo7ce24TfGAFy44uEg6R
 fWLCdqwL2dJ2VgUcEM+jrTRcLtG9T2m9NM5+w4j3OENqjzp/2Dbrk6u9v0EBK753yfNN
 PvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5FMOUmei9Yd20y1XWjfcdbxiSsU6/CKiTZiNSpEJsLk=;
 b=Trmh3w98/84Hlhgxj+90NobgaG7f6ptPUmQ/GU6LutbJ23P9aedg6rqM85YmXhIrpu
 j/EP5Q3G4ohN4Rn+5RAf/Ig3UCiWSpoxbduDxo1wMfy/vVwPQn/omUjKvQ7riwLXhmkS
 b6iwCJBqufkuebboo0khTedvGtKonEnLT/c5AMmCFJUlsyeqFJlml8vwwS0+KyfzKBll
 KoWbKeUX9UosKi0dqeVj5VPTJOGZCU5URdgphz93ki8wf0M0XpyRnLTEUh3Cbr9w4s+J
 +Gi3xnfPROM0S7LyF/FdHC0lX9ZV1Fw6MmcIpOfU/ccQAWwsKNPZzM40JXopf/FLvW6t
 wzVA==
X-Gm-Message-State: AOAM530qfHHr0MT0ay/krIc18VBifJyjqeZL1b6zEFZmvErPL9wtadOA
 u6d+bacPoxfAK6iDvUW4MJhWCg==
X-Google-Smtp-Source: ABdhPJyOg/bEAU+pflh7d3tXCNJNzQxKlLT5ImT9mzjP0dgOLJ0BibjbqbqYNusqXsDTdRjlGBu6iw==
X-Received: by 2002:a05:6a00:181a:b0:47c:1057:52e with SMTP id
 y26-20020a056a00181a00b0047c1057052emr5549485pfa.76.1635440808097; 
 Thu, 28 Oct 2021 10:06:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id y19sm4044516pfn.23.2021.10.28.10.06.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Oct 2021 10:06:47 -0700 (PDT)
Date: Thu, 28 Oct 2021 17:06:43 +0000
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in
 guest mode
Message-ID: <YXrYo9mtueDT0bnu@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-36-seanjc@google.com>
 <b2ba4c4e6a9083f3fa0b9af4504f9f54e72ca24c.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b2ba4c4e6a9083f3fa0b9af4504f9f54e72ca24c.camel@redhat.com>
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
> > Signal the AVIC doorbell iff the vCPU is running in the guest.  If the vCPU
> > is not IN_GUEST_MODE, it's guaranteed to pick up any pending IRQs on the
> > next VMRUN, which unconditionally processes the vIRR.
> > 
> > Add comments to document the logic.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 208c5c71e827..cbf02e7e20d0 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -674,7 +674,12 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >  	kvm_lapic_set_irr(vec, vcpu->arch.apic);
> >  	smp_mb__after_atomic();
> >  
> > -	if (avic_vcpu_is_running(vcpu)) {
> > +	/*
> > +	 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
> > +	 * is in the guest.  If the vCPU is not in the guest, hardware will
> > +	 * automatically process AVIC interrupts at VMRUN.
> > +	 */
> > +	if (vcpu->mode == IN_GUEST_MODE) {
> >  		int cpu = READ_ONCE(vcpu->cpu);
> >  
> >  		/*
> > @@ -687,8 +692,13 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >  		if (cpu != get_cpu())
> >  			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
> >  		put_cpu();
> > -	} else
> > +	} else {
> > +		/*
> > +		 * Wake the vCPU if it was blocking.  KVM will then detect the
> > +		 * pending IRQ when checking if the vCPU has a wake event.
> > +		 */
> >  		kvm_vcpu_wake_up(vcpu);
> > +	}
> >  
> >  	return 0;
> >  }
> 
> It makes sense indeed to avoid ringing the doorbell when the vCPU is not in
> the guest mode.
> 
> I do wonder if we want to call kvm_vcpu_wake_up always otherwise, as the vCPU
> might be just outside of the guest mode and not scheduled out. I don't know
> how expensive is kvm_vcpu_wake_up in this case.

IIUC, you're asking if we should do something like:

	if (vcpu->mode == IN_GUEST_MODE) {
		<signal doorbell>
	} else if (!is_vcpu_loaded(vcpu)) {
		kvm_vcpu_wake_up();
	}

The answer is that kvm_vcpu_wake_up(), which is effectively rcuwait_wake_up(),
is very cheap except for specific configurations that may or may not be valid for
production[*].  Practically speaking, is_vcpu_loaded() doesn't exist and should
never exist because it's inherently racy.  The closest we have would be

	else if (vcpu != kvm_get_running_vcpu()) {
		kvm_vcpu_wake_up();
	}

but that's extremely unlikely to be a net win because getting the current vCPU
requires atomics to disable/re-enable preemption, especially if rcuwait_wake_up()
is modified to avoid the rcu lock/unlock.

TL;DR: rcuwait_wake_up() is cheap, and if it's too expensive, a better optimization
would be to make it less expensive.

[*] https://lkml.kernel.org/r/20211020110638.797389-1-pbonzini@redhat.com
 
> Before this patch, the avic_vcpu_is_running would only be false when the vCPU
> is scheduled out (e.g when vcpu_put was done on it)
> 
> Best regards,
> 	Maxim Levitsky
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
