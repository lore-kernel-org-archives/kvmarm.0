Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961F4C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 15:07:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0FEFC60EFF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 15:07:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0FEFC60EFF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84A984B159;
	Wed, 27 Oct 2021 11:07:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VZIOo+vCnOEg; Wed, 27 Oct 2021 11:07:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7234B175;
	Wed, 27 Oct 2021 11:07:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DF3C4B168
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 11:07:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dBoK0ao8Uo3z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 11:07:03 -0400 (EDT)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E858D4B15C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 11:07:02 -0400 (EDT)
Received: by mail-pf1-f179.google.com with SMTP id m26so3014631pff.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 08:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=O5lEF3hXOuOGQ36jWeA5WrZK+395dTI4kUNN+CFJhtE=;
 b=GJjlg8jJfw+Bt9Zd0zP4mtqcSM31wSFBYCetU17CHbzQQW4kiFtHDgsZBVvEH8887p
 yw/Js4mEDuANgaxd1QymvaNpmXbEvaNRm2HNB868WPSRynugBhM6LN65l++VZht0g2X0
 XFMEItNS+WJlFOOOZlwyo5ghqOI0eoYdx8EfG7dg89d25ghzdUn9Jr0jTft3rzInpzui
 t+nhlFj3SyV2ez0xA0qiaGWyaH3JZAU5KHIJMn2b+NEmBeF/xDfhUhjIDnEt41PMETob
 dNlEs4TAu5VbQ+MRxeaG1Cc4kLdotzXGkh/U5A20JnxHgI8kyVG06UiAaMfvZtmJbPiD
 c4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=O5lEF3hXOuOGQ36jWeA5WrZK+395dTI4kUNN+CFJhtE=;
 b=ZvzDkO5F6rAPnqssubrOz1BgZsrjcwUSgNBveHqiPwinLdb8Vkopta45AgS6YGvTug
 +fepe05D/UjgQQQYXmaJtJms0Xa8nnLEHyAmDLF30kNBxTAhD271h2kq3ZL3xOcnth7n
 Xt+ZwuTZeSQiUpkr8z33MzgLbq+iGH0Wcaup0XZHocrDwB/+AuB8N+tMwUOyVblyTijP
 oRU+DAclvmNKF7qtcvwnkTA/flnh/W3XBofUG/dR7XPowzCQD0cARDSCeTbmn9N9Gp+9
 5YMr8xZF5j41K+i++mj6xb5fDTNC/Yv1tDBpsVRprPV02hqlnRmjoeLryUyp1Gy5suGi
 06lw==
X-Gm-Message-State: AOAM532XCIDlQDcFfm0cxdsxrW+iR3howX1/Z3ynbJ4GAB5x3QXNVwBK
 kPJMk7wZTmCavBMJe3teJYA3Cw==
X-Google-Smtp-Source: ABdhPJyFiG0oaOa31Ni2mfE2COsoLS8wTaHHbwW9HjhwNmX9PoY62hBCx/P2f3tKT436xIXd6QXjiA==
X-Received: by 2002:a05:6a00:15c9:b0:44c:a998:b50d with SMTP id
 o9-20020a056a0015c900b0044ca998b50dmr33155514pfu.49.1635347221673; 
 Wed, 27 Oct 2021 08:07:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id x15sm310904pfp.30.2021.10.27.08.07.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Oct 2021 08:07:00 -0700 (PDT)
Date: Wed, 27 Oct 2021 15:06:57 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 35/43] KVM: SVM: Signal AVIC doorbell iff vCPU is in
 guest mode
Message-ID: <YXlrEWmBohaDXmqL@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-36-seanjc@google.com>
 <0333be2a-76d8-657a-6c82-3bb5c9ff2e3b@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0333be2a-76d8-657a-6c82-3bb5c9ff2e3b@redhat.com>
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
> > +	 */
> > +	if (vcpu->mode == IN_GUEST_MODE) {
> >   		int cpu = READ_ONCE(vcpu->cpu);
> >   		/*
> > @@ -687,8 +692,13 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >   		if (cpu != get_cpu())
> >   			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
> >   		put_cpu();
> > -	} else
> > +	} else {
> > +		/*
> > +		 * Wake the vCPU if it was blocking.  KVM will then detect the
> > +		 * pending IRQ when checking if the vCPU has a wake event.
> > +		 */
> >   		kvm_vcpu_wake_up(vcpu);
> > +	}
> 
> Does this still need to check the "running" flag?  That should be a strict
> superset of vcpu->mode == IN_GUEST_MODE.

No.  Signalling the doorbell when "running" is set but the vCPU is not in the
guest is just an expensive nop.  So even if KVM were to rework its handling of
"running" to set the flag immediately before VMRUN and clear it immediately after,
keying off IN_GUEST_MODE and not "running" would not be wrong, just sub-optimal.

I doubt KVM will ever make the "running" flag super precise, because keeping the
flag set when the vCPU is loaded avoids VM-Exits on other vCPUs due to undelivered
IPIs.  But the flip side is that it means the flag has terrible granularity, and
is arguably inaccurate when viewed from a software perspective.  Anyways, if the
treatment of "running" were ever changed, then this code should also be changed
to essentially revert this commit since vcpu->mode would then be redundant.

And IMO, it makes sense to intentionally separate KVM's delivery of interrupts
from hardware's delivery of interrupts.  I.e. use the same core rules as
kvm_vcpu_kick() for when to send interrupts and when to wake for the AVIC.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
