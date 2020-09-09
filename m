Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A7AC433E2
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 23:06:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F236A21D92
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 23:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OylkBU69"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F236A21D92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61CD64B3B4;
	Wed,  9 Sep 2020 19:06:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6irs98vWEuJm; Wed,  9 Sep 2020 19:06:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12E1C4B358;
	Wed,  9 Sep 2020 19:06:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD04F4B34F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 19:06:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZ6Tx3GbZlld for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 19:06:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B9BD4B345
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 19:06:41 -0400 (EDT)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com
 [209.85.167.177])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6319C21D94
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 23:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599692800;
 bh=e4ObHx53TshJuNw+x6ABTNcL79UDdm3SKoa26EKEcr4=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=OylkBU69KC2ObOw3Y2f/qWESvm721PISifaUxMZ8tadfm1xs7ig5tnQ2mWUbFTrJR
 WUenHIR/CT+Z5RDequpCWaofBnCDBeVaSyv9sIjrXO5mhzNFyQkBNkxBeH2Y2EG53d
 6xeNWu+C/y05EL34FDCVRfMvfmDf9jOqYZ5/rkyQ=
Received: by mail-oi1-f177.google.com with SMTP id x19so4104865oix.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2020 16:06:40 -0700 (PDT)
X-Gm-Message-State: AOAM533fUW+rNH3PXLXkql924Aekx/hGCnQR7Vr9LB7NmeXAVWIwMvF2
 NcX5XGqf3tlilntjfA6efE6IQYMup/deUXqEZA==
X-Google-Smtp-Source: ABdhPJyCTgHBrqd0NXE8Ds/y2GNDv68P5YNPu7qcquPL2kNDhQSf3Yr4vlMrqCN0geHRZB2j/iesbSou1/AXekuDxVs=
X-Received: by 2002:aca:fc07:: with SMTP id a7mr2118270oii.106.1599692799649; 
 Wed, 09 Sep 2020 16:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200803193127.3012242-1-robh@kernel.org>
 <20200803193127.3012242-4-robh@kernel.org>
 <20200821120659.GB6823@gaia> <20200821121209.GB20833@willie-the-truck>
 <20200821122633.GC6823@gaia> <8c641833ff20d5a35981c456d4fe1d5a@kernel.org>
 <20200821140525.GD6823@gaia> <4bc5ca546826da4682ec3b126052daea@kernel.org>
 <20200821175116.GE6823@gaia>
In-Reply-To: <20200821175116.GE6823@gaia>
From: Rob Herring <robh@kernel.org>
Date: Wed, 9 Sep 2020 17:06:28 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJ-s6gkJm=Hh7Rc4LBp0QN0czzb0FC=U=DtKhqKWb7xjA@mail.gmail.com>
Message-ID: <CAL_JsqJ-s6gkJm=Hh7Rc4LBp0QN0czzb0FC=U=DtKhqKWb7xjA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Fri, Aug 21, 2020 at 11:51 AM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> On Fri, Aug 21, 2020 at 06:02:39PM +0100, Marc Zyngier wrote:
> > On 2020-08-21 15:05, Catalin Marinas wrote:
> > > On Fri, Aug 21, 2020 at 01:45:40PM +0100, Marc Zyngier wrote:
> > > > On 2020-08-21 13:26, Catalin Marinas wrote:
> > > > > On Fri, Aug 21, 2020 at 01:12:10PM +0100, Will Deacon wrote:
> > > > > > On Fri, Aug 21, 2020 at 01:07:00PM +0100, Catalin Marinas wrote:
> > > > > > > On Mon, Aug 03, 2020 at 01:31:27PM -0600, Rob Herring wrote:
> > > > > > > > @@ -979,6 +980,14 @@
> > > > > > > >           write_sysreg(__scs_new, sysreg);                        \
> > > > > > > >  } while (0)
> > > > > > > >
> > > > > > > > +#define read_sysreg_par() ({                                             \
> > > > > > > > + u64 par;                                                        \
> > > > > > > > + asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));    \
> > > > > > > > + par = read_sysreg(par_el1);                                     \
> > > > > > > > + asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));    \
> > > > > > > > + par;                                                            \
> > > > > > > > +})
> > > > > > >
> > > > > > > I was about to queue this up but one more point to clarify: can we get
> > > > > > > an interrupt at either side of the PAR_EL1 read and the handler do a
> > > > > > > device read, triggering the erratum? Do we need a DMB at exception
> > > > > > > entry/return?
> > > > > >
> > > > > > Disabling irqs around the PAR access would be simpler, I think
> > > > > > (assuming
> > > > > > this is needed).
> > > > >
> > > > > This wouldn't work if it interrupts a guest.
> > > >
> > > > If we take an interrupt either side of the PAR_EL1 read and that we
> > > > fully exit, the saving of PAR_EL1 on the way out solves the problem.
> > > >
> > > > If we don't fully exit, but instead reenter the guest immediately
> > > > (fixup_guest_exit() returns true), we'd need a DMB at that point,
> > > > at least because of the GICv2 proxying code which performs device
> > > > accesses on the guest's behalf.
> > >
> > > If you are ok with the diff below, I can fold it in:
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > index ca88ea416176..8770cf7ccd42 100644
> > > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > @@ -420,7 +420,7 @@ static inline bool fixup_guest_exit(struct
> > > kvm_vcpu *vcpu, u64 *exit_code)
> > >     if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
> > >         kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
> > >         handle_tx2_tvm(vcpu))
> > > -           return true;
> > > +           goto guest;
> > >
> > >     /*
> > >      * We trap the first access to the FP/SIMD to save the host context
> > > @@ -430,13 +430,13 @@ static inline bool fixup_guest_exit(struct
> > > kvm_vcpu *vcpu, u64 *exit_code)
> > >      * Similarly for trapped SVE accesses.
> > >      */
> > >     if (__hyp_handle_fpsimd(vcpu))
> > > -           return true;
> > > +           goto guest;
> > >
> > >     if (__hyp_handle_ptrauth(vcpu))
> > > -           return true;
> > > +           goto guest;
> > >
> > >     if (!__populate_fault_info(vcpu))
> > > -           return true;
> > > +           goto guest;
> > >
> > >     if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
> > >             bool valid;
> > > @@ -451,7 +451,7 @@ static inline bool fixup_guest_exit(struct
> > > kvm_vcpu *vcpu, u64 *exit_code)
> > >                     int ret = __vgic_v2_perform_cpuif_access(vcpu);
> > >
> > >                     if (ret == 1)
> > > -                           return true;
> > > +                           goto guest;
> > >
> > >                     /* Promote an illegal access to an SError.*/
> > >                     if (ret == -1)
> > > @@ -467,12 +467,17 @@ static inline bool fixup_guest_exit(struct
> > > kvm_vcpu *vcpu, u64 *exit_code)
> > >             int ret = __vgic_v3_perform_cpuif_access(vcpu);
> > >
> > >             if (ret == 1)
> > > -                   return true;
> > > +                   goto guest;
> > >     }
> > >
> > >  exit:
> > >     /* Return to the host kernel and handle the exit */
> > >     return false;
> > > +
> > > +guest:
> > > +   /* Re-enter the guest */
> > > +   asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));
> > > +   return true;
> > >  }
> > >
> > >  static inline bool __needs_ssbd_off(struct kvm_vcpu *vcpu)
> >
> > Looks good to me!
>
> Thanks Marc. Since it needs the local_irq_save() around the PAR_EL1
> access in read_sysreg_par(), I'll wait for Rob to update the patches.
> Rob also asked the hardware guys for clarification on this scenario, so
> let's see what they reply.

According to the h/w folks, an interrupt after the PAR read is not an
issue, but an interrupt doing a device read between the 1st DMB and
the PAR read would be an issue. So v5 coming your way.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
