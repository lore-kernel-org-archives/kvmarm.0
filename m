Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF02C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 19:04:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADADC4B226;
	Mon, 21 Feb 2022 14:04:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3hsXB8NziZib; Mon, 21 Feb 2022 14:04:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6926E4B0FB;
	Mon, 21 Feb 2022 14:04:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F9954B0FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 14:04:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ZXIgMY7m64M for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 14:04:40 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F87C40B41
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 14:04:40 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D9609B8110A;
 Mon, 21 Feb 2022 19:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CF7C340E9;
 Mon, 21 Feb 2022 19:04:34 +0000 (UTC)
Date: Mon, 21 Feb 2022 19:04:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: [PATCH v11 10/40] arm64/sme: Basic enumeration support
Message-ID: <YhPiPwilGYsd663m@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-11-broonie@kernel.org>
 <YhOihgeVRTztfDqv@arm.com> <20220221160706.GK2692478@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220221160706.GK2692478@arm.com>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

On Mon, Feb 21, 2022 at 04:07:06PM +0000, Szabolcs Nagy wrote:
> The 02/21/2022 14:32, Catalin Marinas wrote:
> > On Mon, Feb 07, 2022 at 03:20:39PM +0000, Mark Brown wrote:
> > > diff --git a/Documentation/arm64/elf_hwcaps.rst b/Documentation/arm64/elf_hwcaps.rst
> > > index b72ff17d600a..5626cf208000 100644
> > > --- a/Documentation/arm64/elf_hwcaps.rst
> > > +++ b/Documentation/arm64/elf_hwcaps.rst
> > > @@ -259,6 +259,39 @@ HWCAP2_RPRES
> > >  
> > >      Functionality implied by ID_AA64ISAR2_EL1.RPRES == 0b0001.
> > >  
> > > +HWCAP2_SME
> > > +
> > > +    Functionality implied by ID_AA64PFR1_EL1.SME == 0b0001, as described
> > > +    by Documentation/arm64/sme.rst.
> > > +
> > > +HWCAP2_SME_I16I64
> > > +
> > > +    Functionality implied by ID_AA64SMFR0_EL1.I16I64 == 0b1111.
> > > +
> > > +HWCAP2_SME_F64F64
> > > +
> > > +    Functionality implied by ID_AA64SMFR0_EL1.F64F64 == 0b1.
> > > +
> > > +HWCAP2_SME_I8I32
> > > +
> > > +    Functionality implied by ID_AA64SMFR0_EL1.I8I32 == 0b1111.
> > > +
> > > +HWCAP2_SME_F16F32
> > > +
> > > +    Functionality implied by ID_AA64SMFR0_EL1.F16F32 == 0b1.
> > > +
> > > +HWCAP2_SME_B16F32
> > > +
> > > +    Functionality implied by ID_AA64SMFR0_EL1.B16F32 == 0b1.
> > > +
> > > +HWCAP2_SME_F32F32
> > > +
> > > +    Functionality implied by ID_AA64SMFR0_EL1.F32F32 == 0b1.
> > > +
> > > +HWCAP2_SME_FA64
> > > +
> > > +    Functionality implied by ID_AA64SMFR0_EL1.FA64 == 0b1.
> > 
> > More of a question for the libc people: should we drop the fine-grained
> > HWCAP corresponding to the new ID_AA64SMFR0_EL1 register (only keep
> > HWCAP2_SME) and get the user space to use the MRS emulation? Would any
> > ifunc resolver be affected?
> 
> good question.
> 
> within glibc HWCAP2_SME is enough (to decide if we need to
> deal with additional register state and the lazy ZA save
> scheme) but i guess user code that actually uses sme would
> need the details (including in ifunc resolvers in principle).
> 
> since we have mrs, there is no strict need for hwcaps.
> if ifunc resolvers using this info are not widespread then
> the mrs emulation overhead is acceptable, but i suspect
> hwcaps are nicer to use.

I presume the ifunc resolvers only run once, so the overhead won't be
noticed. Anyway, happy to keep the new HWCAP2 if they are useful.

> do we have a plan after hwcap2 bits run out? :)

HWCAP3 or we free up the top 32-bit in both HWCAP and HWCAP2 ranges. We
did not extend into those upper bits because of the ILP32 discussions at
the time.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
