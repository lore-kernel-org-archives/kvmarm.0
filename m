Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF461C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:08:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5373D6108E
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 22:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5373D6108E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C71394B15A;
	Wed,  1 Sep 2021 18:08:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e5DY-1gPMsJN; Wed,  1 Sep 2021 18:08:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E37D04B0B4;
	Wed,  1 Sep 2021 18:08:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F37AB4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:08:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8L908CnOjy+v for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 18:08:33 -0400 (EDT)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
 [209.85.166.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB9CE4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 18:08:32 -0400 (EDT)
Received: by mail-il1-f181.google.com with SMTP id l10so819602ilh.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 15:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tPUheJaZHBcw4vca9HyUxGYJolSn/dkPnRtCmems3Kk=;
 b=XBRkHtg5GUG48wrLz+RUhRTD7Q7TWZFMtYe69RP+BmyRwImiVD2LD83lEVcJTo+HE0
 XMDBWHB3Il+/uvFYFRnBOOgEb6KO9VTDo0rKZrTe7FxM87LjoQDRcjyqYNkIwOHOHD/X
 fYaWNizVlQ+kn5Pdxs0gShGtRFvReUizq5VH+bWHy5E4rowruiih+MC8iU/NbUriSMMh
 C2fpPAwih/gSvxg8n/52V7XpcyPrrm8yu6hDs7WSD1jJ0Q2eZCZJGUMl5yafDxyIjfSd
 FoZzcMXOAtCRsUfvWIF6gohZFSLO1o8TVvFiKnL/HBNmiZWmiiFjjvMgaaS+gubMIlf+
 LUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tPUheJaZHBcw4vca9HyUxGYJolSn/dkPnRtCmems3Kk=;
 b=bYQxf+/ETELogRwZgOvOHsGV0OwUeE8Mwlo1fnug/gSUADaRaytrLrvPGgBDy7kfh+
 4KYf7ipcVRMH9QSHhhvE6zpQOkjSukzJX5N1sFx8sXkOP91S8f9GQAqjRi4bsaDn0fL2
 w1T341cs9M2NTZJmdV361yLdXOY1v1LeUhPLwmk14hptl1e7v4hnE6yjlTp0PZjjnA9m
 dIKownMJHe4bS+efxvHj0aWNdgzyY1lCoXC+ZAccC/knrSTd8wjhoHCsm0Ztvu9DtI3o
 h4f4mC9wmsWJCv7oheVr+i4JRYPWCVDJaCRgdmplNvj8ydvbWzPop0YC8MU6asA04FYx
 Vuxg==
X-Gm-Message-State: AOAM5315S72xg+2hrKqE9SRiMn9EA+q+tft/p795PBxehfvwBNVjgAMF
 olGHQBRobaVjymb+cz/l9jWI2A==
X-Google-Smtp-Source: ABdhPJy7j9n5AI8PSx1LUhSYg41KM1gcaY+NB3v8gxt4nUeuUOMHYoY6GxgdiPT9WZl4I3pv1HmPuQ==
X-Received: by 2002:a92:870b:: with SMTP id m11mr1143869ild.132.1630534112153; 
 Wed, 01 Sep 2021 15:08:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id p15sm490025ilc.12.2021.09.01.15.08.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 15:08:31 -0700 (PDT)
Date: Wed, 1 Sep 2021 22:08:28 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <YS/53N7LdJOgdzNu@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
 <YS/wfBTnCJWn05Kn@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YS/wfBTnCJWn05Kn@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 01, 2021 at 09:28:28PM +0000, Oliver Upton wrote:
> On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> > For register names that are unsupported by the assembler or the ones
> > without architectural names, add the macros write_sysreg_s and
> > read_sysreg_s to support them.
> > 
> > The functionality is derived from kvm-unit-tests and kernel's
> > arch/arm64/include/asm/sysreg.h.
> > 
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> 
> Would it be possible to just include <asm/sysreg.h>? See
> tools/arch/arm64/include/asm/sysreg.h

Geez, sorry for the noise. I mistakenly searched from the root of my
repository, not the tools/ directory.

In any case, you could perhaps just drop the kernel header there just to
use the exact same source for kernel and selftest.

Thanks,
Oliver

> > ---
> >  .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index 3cbaf5c1e26b..082cc97ad8d3 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -118,6 +118,67 @@ void vm_install_exception_handler(struct kvm_vm *vm,
> >  void vm_install_sync_handler(struct kvm_vm *vm,
> >  		int vector, int ec, handler_fn handler);
> >  
> > +/*
> > + * ARMv8 ARM reserves the following encoding for system registers:
> > + * (Ref: ARMv8 ARM, Section: "System instruction class encoding overview",
> > + *  C5.2, version:ARM DDI 0487A.f)
> > + *	[20-19] : Op0
> > + *	[18-16] : Op1
> > + *	[15-12] : CRn
> > + *	[11-8]  : CRm
> > + *	[7-5]   : Op2
> > + */
> > +#define Op0_shift	19
> > +#define Op0_mask	0x3
> > +#define Op1_shift	16
> > +#define Op1_mask	0x7
> > +#define CRn_shift	12
> > +#define CRn_mask	0xf
> > +#define CRm_shift	8
> > +#define CRm_mask	0xf
> > +#define Op2_shift	5
> > +#define Op2_mask	0x7
> > +
> > +/*
> > + * When accessed from guests, the ARM64_SYS_REG() doesn't work since it
> > + * generates a different encoding for additional KVM processing, and is
> > + * only suitable for userspace to access the register via ioctls.
> > + * Hence, define a 'pure' sys_reg() here to generate the encodings as per spec.
> > + */
> > +#define sys_reg(op0, op1, crn, crm, op2) \
> > +	(((op0) << Op0_shift) | ((op1) << Op1_shift) | \
> > +	 ((crn) << CRn_shift) | ((crm) << CRm_shift) | \
> > +	 ((op2) << Op2_shift))
> > +
> > +asm(
> > +"	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
> > +"	.equ	.L__reg_num_x\\num, \\num\n"
> > +"	.endr\n"
> > +"	.equ	.L__reg_num_xzr, 31\n"
> > +"\n"
> > +"	.macro	mrs_s, rt, sreg\n"
> > +"	.inst	0xd5200000|(\\sreg)|(.L__reg_num_\\rt)\n"
> > +"	.endm\n"
> > +"\n"
> > +"	.macro	msr_s, sreg, rt\n"
> > +"	.inst	0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
> > +"	.endm\n"
> > +);
> > +
> > +/*
> > + * read_sysreg_s() and write_sysreg_s()'s 'reg' has to be encoded via sys_reg()
> > + */
> > +#define read_sysreg_s(reg) ({						\
> > +	u64 __val;							\
> > +	asm volatile("mrs_s %0, "__stringify(reg) : "=r" (__val));	\
> > +	__val;								\
> > +})
> > +
> > +#define write_sysreg_s(reg, val) do {					\
> > +	u64 __val = (u64)val;						\
> > +	asm volatile("msr_s "__stringify(reg) ", %x0" : : "rZ" (__val));\
> > +} while (0)
> > +
> >  #define write_sysreg(reg, val)						  \
> >  ({									  \
> >  	u64 __val = (u64)(val);						  \
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
