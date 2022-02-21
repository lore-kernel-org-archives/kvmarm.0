Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C78C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 19:25:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF8A49F17;
	Mon, 21 Feb 2022 14:25:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4-tButWjU57B; Mon, 21 Feb 2022 14:25:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E55C4B131;
	Mon, 21 Feb 2022 14:25:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7CEF4B102
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 14:25:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 93qwJqtIFKpY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 14:25:08 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 553A14B131
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 14:25:08 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 94CADB816F9;
 Mon, 21 Feb 2022 19:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FC6C340F1;
 Mon, 21 Feb 2022 19:25:02 +0000 (UTC)
Date: Mon, 21 Feb 2022 19:24:59 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 10/40] arm64/sme: Basic enumeration support
Message-ID: <YhPnCx+Rajjverjc@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-11-broonie@kernel.org>
 <YhOihgeVRTztfDqv@arm.com> <YhOpL54V9RAthj24@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YhOpL54V9RAthj24@sirena.org.uk>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
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

On Mon, Feb 21, 2022 at 03:01:03PM +0000, Mark Brown wrote:
> On Mon, Feb 21, 2022 at 02:32:38PM +0000, Catalin Marinas wrote:
> > On Mon, Feb 07, 2022 at 03:20:39PM +0000, Mark Brown wrote:
> > > +/*
> > > + * This must be called after sme_kernel_enable(), we rely on the
> > > + * feature table being sorted to ensure this.
> > > + */
> > > +void fa64_kernel_enable(const struct arm64_cpu_capabilities *__always_unused p)
> > > +{
> > > +	/* Allow use of FA64 */
> > > +	write_sysreg_s(read_sysreg_s(SYS_SMCR_EL1) | SMCR_ELx_FA64_MASK,
> > > +		       SYS_SMCR_EL1);
> > > +}
> > > +
> > > +#endif /* CONFIG_ARM64_SVE */
> 
> > I think instead of worrying about the order, we could check the
> > sanitised register value in sme_kernel_enable() and set the FA64 bit.
> 
> There's going to be a ordering/clarity issue whatever way round we do it
> - the FA64 feature bit is in a different feature register to the main
> SME feature bitfield and it's not as abundantly clear as might be ideal 
> that it will have been sanitised when we're getting callbacks for the
> main SME feature, there's an awful lot of sharp edges with this code.
> Having things this way round felt more idiomatic to me.

You may want to add a comment in the cpu_feature[] array that it should
be placed after SME.

> > Also to me 'fa64_kernel_enable' somehow implies that the kernel cares
> > about FA64 for itself but AFAICT we never run the kernel in streaming
> > mode.
> 
> We do run the kernel in streaming mode - entering the kernel through a
> syscall or preemption will not change the streaming mode state, and we
> need to be in streaming mode in order to save or restore the register
> state for streaming mode.  In particular we need FA64 enabled for EL1 in
> order to context switch FFR when in streaming mode, without it we'll
> generate an exception when we execute the rdffr or wrffr.  We don't do
> any real floating point work in streaming mode but we absolutely need to
> run in streaming mode and only exit streaming mode when restoring a
> context where it is disabled, when using floating point in the kernel or
> when idling the CPU.

So, IIUC, for Linux it is mandatory that FEAT_SME_FA64 is supported,
otherwise we won't be able to enable SME. Does the architecture say
this feature as optional? Which A64 instructions are not available if
FA64 is disabled? I hope it's only the SVE ones but I thought we can
still do load/store of the state even with FA64 disabled.

Anyway, if we can't even context switch without FA64 while in streaming
mode, I think we should move the check in the main SME .matches function
and enable it in sme_kernel_enable(), no need for an additional feature.

I think we should also update booting.rst to require that the FA64 is
enabled at EL2 and EL3.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
