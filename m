Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31B2C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 19:21:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542AE4BB47;
	Thu, 24 Feb 2022 14:21:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VZoecrKb8MjD; Thu, 24 Feb 2022 14:21:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D9504BB64;
	Thu, 24 Feb 2022 14:21:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AAB44BB48
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 14:21:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e9A-l6iIKFQ7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 14:21:55 -0500 (EST)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
 [209.85.166.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05F974BB47
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 14:21:54 -0500 (EST)
Received: by mail-il1-f180.google.com with SMTP id f2so2561012ilq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dlxbBhjVxgATP0KM5oNG0LzdCfA40MUHrDIe/INdi68=;
 b=NYOdpm1bR56HSGohn/sRm5A66fRUWCpyofnOGctj1Y7ae7i9UeuP70P/+ILbsYGshn
 g4CwQLakXJ7vlyBMwxLrvT6z/s1hnpRc/M+qijG4uaLuozRkQ7rglS5G25Lb7vEEW3fx
 79iYlHvvkRS2gTK0O3vXFMqYmF1B8mjqRa9jETuLcu4PalAreDBoVpmPKOZ59Jb7VSWr
 xyxFkKFJ3nUb/YTG8zk8spMQvhsp4Iiz3Sp6WdQoYEpuypYRa23kod5z0BrhLeH5pBG7
 bYHrKwcQ6CwTqdOo19gGMZNyZeTd7zVuSXiIdG5lSR5k/TCUKojup/YE6KCIhw4tVyVR
 4x3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dlxbBhjVxgATP0KM5oNG0LzdCfA40MUHrDIe/INdi68=;
 b=5GhcDebgfYK+jpngp1/785lvcEqvPqKyz6ZpsRcQe9FSzjVgbzMejNP1rXxC7FmreT
 RDYxoQFdUy/fE14VYYbArqLGLU/qkH8NKDj8Q4AwLHHoEG8c3wU8SYt7WdcVdce3Kx1g
 Pz7z+FLkVnyc5esOyMjdQg4qyrnfepDAEuLv1qLEqUqiWH6x8ziN8rtD5UP9J+h58Nt7
 wHSku6SKc9Fim6d70KwtuRxeQR3Jsb0ZgqueaTdHf9bfpALO6afBmu6hKQkPOaLgGm+M
 jDKvKBlV8GoiAVf9r+KduDFnLzGiwn7gjf4QKWDUhnIu50/cbv/EDAde/yA6LGxYoV0I
 MjAQ==
X-Gm-Message-State: AOAM53120j/WHdHkvbHnZ/FB6A4LYFcWB2IA5RsL+AtF89zqKgN9Z3OZ
 2mtcqVnnRW4DEE0ADccUpIaOzQ==
X-Google-Smtp-Source: ABdhPJwn7IgJZMEfgRQOCW+UbgVEsAFzikAr2Dh30XA4U2P9oW3FIDdVTPHHiCobPFdhZhWNF/zmHg==
X-Received: by 2002:a05:6e02:1bc5:b0:2c2:7bc9:8e8f with SMTP id
 x5-20020a056e021bc500b002c27bc98e8fmr3548686ilv.5.1645730514046; 
 Thu, 24 Feb 2022 11:21:54 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 k10-20020a6b7e4a000000b00640a8142cbdsm289173ioq.49.2022.02.24.11.21.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Feb 2022 11:21:53 -0800 (PST)
Date: Thu, 24 Feb 2022 19:21:50 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 03/19] KVM: arm64: Reject invalid addresses for CPU_ON
 PSCI call
Message-ID: <YhfaztgV0GHzyh24@google.com>
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-4-oupton@google.com>
 <87zgmg30qu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zgmg30qu.wl-maz@kernel.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Hi Marc,

On Thu, Feb 24, 2022 at 12:30:49PM +0000, Marc Zyngier wrote:
> On Wed, 23 Feb 2022 04:18:28 +0000,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > DEN0022D.b 5.6.2 "Caller responsibilities" states that a PSCI
> > implementation may return INVALID_ADDRESS for the CPU_ON call if the
> > provided entry address is known to be invalid. There is an additional
> > caveat to this rule. Prior to PSCI v1.0, the INVALID_PARAMETERS error
> > is returned instead. Check the guest's PSCI version and return the
> > appropriate error if the IPA is invalid.
> > 
> > Reported-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/psci.c | 24 ++++++++++++++++++++++--
> >  1 file changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index a0c10c11f40e..de1cf554929d 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -12,6 +12,7 @@
> >  
> >  #include <asm/cputype.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_mmu.h>
> >  
> >  #include <kvm/arm_psci.h>
> >  #include <kvm/arm_hypercalls.h>
> > @@ -70,12 +71,31 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	struct vcpu_reset_state *reset_state;
> >  	struct kvm *kvm = source_vcpu->kvm;
> >  	struct kvm_vcpu *vcpu = NULL;
> > -	unsigned long cpu_id;
> > +	unsigned long cpu_id, entry_addr;
> >  
> >  	cpu_id = smccc_get_arg1(source_vcpu);
> >  	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
> >  		return PSCI_RET_INVALID_PARAMS;
> >  
> > +	/*
> > +	 * Basic sanity check: ensure the requested entry address actually
> > +	 * exists within the guest's address space.
> > +	 */
> > +	entry_addr = smccc_get_arg2(source_vcpu);
> > +	if (!kvm_ipa_valid(kvm, entry_addr)) {
> > +
> > +		/*
> > +		 * Before PSCI v1.0, the INVALID_PARAMETERS error is returned
> > +		 * instead of INVALID_ADDRESS.
> > +		 *
> > +		 * For more details, see ARM DEN0022D.b 5.6 "CPU_ON".
> > +		 */
> > +		if (kvm_psci_version(source_vcpu) < KVM_ARM_PSCI_1_0)
> > +			return PSCI_RET_INVALID_PARAMS;
> > +		else
> > +			return PSCI_RET_INVALID_ADDRESS;
> > +	}
> > +
> 
> If you're concerned with this, should you also check for the PC
> alignment, or the presence of a memslot covering the address you are
> branching to?  Le latter is particularly hard to implement reliably.

Andrew, Reiji and I had a conversation regarding exactly this on the
last run of this series, and concluded that checking against the IPA is
probably the best KVM can do [1]. That said, alignment is also an easy
thing to check.

> So far, my position has been that the guest is free to shoot itself in
> the foot if that's what it wants to do, and that babysitting it was a
> waste of useful bits! ;-)
>

Agreed -- there are plenty of spectacular/hilarious ways in which the
guest can mess up :-)

> Or have you identified something that makes it a requirement to handle
> this case (and possibly others)  in the hypervisor?

It is a lot easier to tell a guest that their software is broken if they
get an error back from the hypercall, whereas a vCPU off in the weeds
might need to be looked at before concluding there's a guest issue.


[1]: http://lore.kernel.org/r/20211005190153.dc2befzcisvznxq5@gator.home

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
