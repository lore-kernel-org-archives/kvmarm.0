Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BD9C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:04:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B2F561040
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 16:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B2F561040
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA13B4A19A;
	Wed, 27 Oct 2021 12:04:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QzTsKO4-cc+5; Wed, 27 Oct 2021 12:04:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C059A4B092;
	Wed, 27 Oct 2021 12:04:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A47434A193
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 12:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tZe2xHgQVPGL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 12:04:45 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D08F406E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 12:04:45 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id n11so2329611plf.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 09:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dcpH/p742iSNJ4bZTW0zt1TGCcBsOCFOjXwA1nHOArQ=;
 b=Tm86IoMHOyj+zpaOtCSE4VFzqAdP+9ruKNcRadlOsFvChh7ill13kZR5jWD9NHE65h
 64jvZDMu9kIVfatwV9NqtMoLtCasfA5hteZXUvebb1KfemQP+3PqYeGQAgGx9M3p7bU8
 qNPAFnYhitn+E30o4EXNDe5pTB+zWAuxmiSCE4KEPuXZlCuroSJybkJylXO0PsvVFrn8
 WHatzxWVbSvDonjRBU4GlRNXf74WN3TzY8Vqi6OJ+Ctj4jxWd/Ui1c+kFiATf0mtE0jn
 ZZyVyj8OcnNeewioZwWE0jsQa9pZSUdW+6oR7be9c4lXCDaENvCYDfdnIza70+cJL6Io
 dmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dcpH/p742iSNJ4bZTW0zt1TGCcBsOCFOjXwA1nHOArQ=;
 b=Ygyu5qJ1qH3zlyfTLKRzOT0/CbckBv0NMWAo/DbXJ48eDQkn2/WvTZMDawS5PpbH1t
 9yRWen+8nj9QpFMnoIhGDJULTlZhEs5L88dcTxfNG+5dFMQ0eb8Fsw7ZFpfVvgrhpw7R
 WpQF5JNomcZkzm0KrZIgG/rd4CvbFv2b5sgaCmYcR/j6fo9JSWXAYjkydj3bIyF0C9NH
 Oyp/KsBQepivKRt9FHs+V1WGDXN1hpxqwQMqZ393NRPshVmlcmOmtRTY5rgJmCKpzvZA
 EiznkBbyYPISVejlcFdud+oPnTQs+ZoYEatLzRp3Ul1ZiCKkwTZXBimOpO5pz3rGkMYu
 APMQ==
X-Gm-Message-State: AOAM531Wl3Vdod9F8hfMu8MQwnS7asBUoHiECmDTsqcHa61MZQq5xIPA
 EghGfdTd8rEBa4z8Fu7tr5+NtA==
X-Google-Smtp-Source: ABdhPJywTswkNFY7FXvXu6HG//R1t5yx+yTwPulg5ieqikJtUBQKOiC63rBPbvuvCOKHk/yZoLtKWg==
X-Received: by 2002:a17:90b:1b46:: with SMTP id
 nv6mr6766883pjb.162.1635350684192; 
 Wed, 27 Oct 2021 09:04:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id z15sm242123pga.16.2021.10.27.09.04.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Oct 2021 09:04:43 -0700 (PDT)
Date: Wed, 27 Oct 2021 16:04:40 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 39/43] KVM: VMX: Don't do full kick when triggering
 posted interrupt "fails"
Message-ID: <YXl4mK7CyUBnPaQV@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-40-seanjc@google.com>
 <335822ac-b98b-1eec-4911-34e4d0e99907@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <335822ac-b98b-1eec-4911-34e4d0e99907@redhat.com>
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

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 09/10/21 04:12, Sean Christopherson wrote:
> > +		/*
> > +		 * The smp_wmb() in kvm_make_request() pairs with the smp_mb_*()
> > +		 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU
> > +		 * is guaranteed to see the event request if triggering a posted
> > +		 * interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
> 
> This explanation doesn't make much sense to me.  This is just the usual
> request/kick pattern explained in Documentation/virt/kvm/vcpu-requests.rst;
> except that we don't bother with a "kick" out of guest mode because the
> entry always goes through kvm_check_request (in the nVMX case) or
> sync_pir_to_irr (if non-nested) and completes the delivery itself.
> 
> In other word, it is a similar idea as patch 43/43.
> 
> What this smp_wmb() pair with, is the smp_mb__after_atomic in
> kvm_check_request(KVM_REQ_EVENT, vcpu).

I don't think that's correct.  There is no kvm_check_request() in the relevant path.
kvm_vcpu_exit_request() uses kvm_request_pending(), which is just a READ_ONCE()
without a barrier.  The smp_mb__after_atomic ensures that any assets that were
modified prior to making the request are seen by the vCPU handling the request.
It does not provide any guarantees for a different vCPU/task making a request
and checking vcpu->mode versus the target vCPU setting vcpu->mode and checking
for a pending request.

> Setting the interrupt in the PIR orders before kvm_make_request in this
> thread, and orders after kvm_make_request in the vCPU thread.
>
> Here, instead:
> 
> > +	/*
> > +	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
> > +	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
> > +	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
> > +	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
> > +	 */
> >  	if (vcpu != kvm_get_running_vcpu() &&
> >  	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> > -		kvm_vcpu_kick(vcpu);
> > +		kvm_vcpu_wake_up(vcpu);
> 
> it pairs with the smp_mb__after_atomic in vmx_sync_pir_to_irr().  As
> explained again in vcpu-requests.rst, the ON bit has the same function as
> vcpu->request in the previous case.

Same as above, I don't think that's correct.  The smp_mb__after_atomic() ensures
that there's no race between the IOMMU writing vIRR and setting ON, and KVM
clearing ON and processing the vIRR.

pi_test_on() is not an atomic operation, and there's no memory barrier if ON=0.
It's the same behavior as kvm_check_request(), but again the ordering with respect
to vcpu->mode isn't being handled by PID.ON/kvm_check_request().

AIUI, this is the barrier that's paired with the PI barriers.  This is even called
out in (2).

	vcpu->mode = IN_GUEST_MODE;

	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);

	/*
	 * 1) We should set ->mode before checking ->requests.  Please see
	 * the comment in kvm_vcpu_exiting_guest_mode().
	 *
	 * 2) For APICv, we should set ->mode before checking PID.ON. This
	 * pairs with the memory barrier implicit in pi_test_and_set_on
	 * (see vmx_deliver_posted_interrupt).
	 *
	 * 3) This also orders the write to mode from any reads to the page
	 * tables done while the VCPU is running.  Please see the comment
	 * in kvm_flush_remote_tlbs.
	 */
	smp_mb__after_srcu_read_unlock();
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
