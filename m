Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E0BC4320E
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 23:06:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D228860FC0
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 23:06:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D228860FC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF344B192;
	Wed,  1 Sep 2021 19:06:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pKPCeeLKb2cE; Wed,  1 Sep 2021 19:06:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7264B172;
	Wed,  1 Sep 2021 19:06:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 290954B0B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 19:06:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5zdYYv2QGFX3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 19:06:15 -0400 (EDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1229F4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 19:06:15 -0400 (EDT)
Received: by mail-io1-f51.google.com with SMTP id z1so97789ioh.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 16:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KZ/5nel7V3JYltMvpEGkr0qAe2nUa6A5gCoohICIk1U=;
 b=ptTWVvIXnmKoEScR5wfbDVKBiHVdPwwVrptmuTuhJVbPYOxgcbRhxrfw8HKuPWeWxF
 nE1Jc0HnWlbabWnNwP7yZlr0GuVrHwf8F5YgUdJYMrBXg6sNRyfEO6goIAh36ZaNvDy9
 t8w2ap9acGNdJ3gPs8pZV8nWo5w7/w2FdyH+o7CuMi2JTCECj46yq+ycnYW0NY4fa7+d
 n17yv+xB5YCMuypPSsWfX8TYQC6LxhZfyCpuGd+EA5KNvVZpquWBkdZ1ClEnNw2gmfkF
 u/4KAtFf1oaq9WehcZSh1IFg9Jcgki6aPFOvI1zvoAzbZh0ZALQpNkkC+QhRh5j8Lu59
 r+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KZ/5nel7V3JYltMvpEGkr0qAe2nUa6A5gCoohICIk1U=;
 b=lq2rxrWoU3+nZF7nWPue89nAbPBJdZUsx+n/gG+mIpG3r7ChQmLb+6s2UreXS73DPV
 6v45ZrcIuo6yBF4kHYZKuFJvUjBhpaMuBdDKs364RKqF1mtfBxX0W7utL2cSB4VW7Kds
 La+fTvwv1kzNTy5V+6tRyPtvknQOGfPwXir2AKS/9hLAFD6EonakzJ9mhHhRh8lIGlD7
 Y9QDslwNadUED5uy1qzdOwfHnu9Eq9K2rojsf+9a3P22zAR6OpHx2T5jdbOf0YSSteTS
 ylQ3x+hoEWsFPcpBkE8g3o/OvnxE1XG2ztlqa07uiBQGhagDMlX4oD539uP4s2ix/EyV
 xGWQ==
X-Gm-Message-State: AOAM531ih6gX1bEsM4EdvoQ1ncafxCDzqQ4rmMzmnVGkGClmRHnxHaA0
 1yosauZfs+zpTZy6Z9Mlqd+vng==
X-Google-Smtp-Source: ABdhPJxEM4N294HdnpgByMmrM0QXbQJiuXDih9pT6LyofjozajJsW+u0iFTBg48WKw74Eb71BROBPQ==
X-Received: by 2002:a5e:db06:: with SMTP id q6mr230560iop.24.1630537574234;
 Wed, 01 Sep 2021 16:06:14 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id l15sm538950ilt.45.2021.09.01.16.06.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 16:06:13 -0700 (PDT)
Date: Wed, 1 Sep 2021 23:06:10 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <YTAHYrQslkY12715@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
 <YS/wfBTnCJWn05Kn@google.com> <YS/53N7LdJOgdzNu@google.com>
 <CAJHc60xU3XvmkBHoB8ihyjy6k4RJ9dhqt31ytHDGjd5xsaJjFA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJHc60xU3XvmkBHoB8ihyjy6k4RJ9dhqt31ytHDGjd5xsaJjFA@mail.gmail.com>
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

On Wed, Sep 01, 2021 at 03:48:40PM -0700, Raghavendra Rao Ananta wrote:
> On Wed, Sep 1, 2021 at 3:08 PM Oliver Upton <oupton@google.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 09:28:28PM +0000, Oliver Upton wrote:
> > > On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> > > > For register names that are unsupported by the assembler or the ones
> > > > without architectural names, add the macros write_sysreg_s and
> > > > read_sysreg_s to support them.
> > > >
> > > > The functionality is derived from kvm-unit-tests and kernel's
> > > > arch/arm64/include/asm/sysreg.h.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > >
> > > Would it be possible to just include <asm/sysreg.h>? See
> > > tools/arch/arm64/include/asm/sysreg.h
> >
> > Geez, sorry for the noise. I mistakenly searched from the root of my
> > repository, not the tools/ directory.
> >
> No worries :)
> 
> > In any case, you could perhaps just drop the kernel header there just to
> > use the exact same source for kernel and selftest.
> >
> You mean just copy/paste the entire header? There's a lot of stuff in
> there which we
> don't need it (yet).

Right. It's mostly register definitions, which I don't think is too high
of an overhead. Don't know where others stand, but I would prefer a
header that is equivalent between kernel & selftests over a concise
header.

--
Thanks,
Oliver

> > Thanks,
> > Oliver
> >
> > > > ---
> > > >  .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
> > > >  1 file changed, 61 insertions(+)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > index 3cbaf5c1e26b..082cc97ad8d3 100644
> > > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > @@ -118,6 +118,67 @@ void vm_install_exception_handler(struct kvm_vm *vm,
> > > >  void vm_install_sync_handler(struct kvm_vm *vm,
> > > >             int vector, int ec, handler_fn handler);
> > > >
> > > > +/*
> > > > + * ARMv8 ARM reserves the following encoding for system registers:
> > > > + * (Ref: ARMv8 ARM, Section: "System instruction class encoding overview",
> > > > + *  C5.2, version:ARM DDI 0487A.f)
> > > > + * [20-19] : Op0
> > > > + * [18-16] : Op1
> > > > + * [15-12] : CRn
> > > > + * [11-8]  : CRm
> > > > + * [7-5]   : Op2
> > > > + */
> > > > +#define Op0_shift  19
> > > > +#define Op0_mask   0x3
> > > > +#define Op1_shift  16
> > > > +#define Op1_mask   0x7
> > > > +#define CRn_shift  12
> > > > +#define CRn_mask   0xf
> > > > +#define CRm_shift  8
> > > > +#define CRm_mask   0xf
> > > > +#define Op2_shift  5
> > > > +#define Op2_mask   0x7
> > > > +
> > > > +/*
> > > > + * When accessed from guests, the ARM64_SYS_REG() doesn't work since it
> > > > + * generates a different encoding for additional KVM processing, and is
> > > > + * only suitable for userspace to access the register via ioctls.
> > > > + * Hence, define a 'pure' sys_reg() here to generate the encodings as per spec.
> > > > + */
> > > > +#define sys_reg(op0, op1, crn, crm, op2) \
> > > > +   (((op0) << Op0_shift) | ((op1) << Op1_shift) | \
> > > > +    ((crn) << CRn_shift) | ((crm) << CRm_shift) | \
> > > > +    ((op2) << Op2_shift))
> > > > +
> > > > +asm(
> > > > +"  .irp    num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
> > > > +"  .equ    .L__reg_num_x\\num, \\num\n"
> > > > +"  .endr\n"
> > > > +"  .equ    .L__reg_num_xzr, 31\n"
> > > > +"\n"
> > > > +"  .macro  mrs_s, rt, sreg\n"
> > > > +"  .inst   0xd5200000|(\\sreg)|(.L__reg_num_\\rt)\n"
> > > > +"  .endm\n"
> > > > +"\n"
> > > > +"  .macro  msr_s, sreg, rt\n"
> > > > +"  .inst   0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
> > > > +"  .endm\n"
> > > > +);
> > > > +
> > > > +/*
> > > > + * read_sysreg_s() and write_sysreg_s()'s 'reg' has to be encoded via sys_reg()
> > > > + */
> > > > +#define read_sysreg_s(reg) ({                                              \
> > > > +   u64 __val;                                                      \
> > > > +   asm volatile("mrs_s %0, "__stringify(reg) : "=r" (__val));      \
> > > > +   __val;                                                          \
> > > > +})
> > > > +
> > > > +#define write_sysreg_s(reg, val) do {                                      \
> > > > +   u64 __val = (u64)val;                                           \
> > > > +   asm volatile("msr_s "__stringify(reg) ", %x0" : : "rZ" (__val));\
> > > > +} while (0)
> > > > +
> > > >  #define write_sysreg(reg, val)                                               \
> > > >  ({                                                                   \
> > > >     u64 __val = (u64)(val);                                           \
> > > > --
> > > > 2.33.0.153.gba50c8fa24-goog
> > > >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
