Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34059C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Feb 2022 12:09:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 955A14B086;
	Tue, 22 Feb 2022 07:09:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NYS5j8CxvVbv; Tue, 22 Feb 2022 07:09:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E07904B08B;
	Tue, 22 Feb 2022 07:09:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87B584B092
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 07:09:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7hHLUj2wLE-f for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 07:09:45 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E90940BDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 07:09:45 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 190DE60EFD;
 Tue, 22 Feb 2022 12:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39F0C340E8;
 Tue, 22 Feb 2022 12:09:40 +0000 (UTC)
Date: Tue, 22 Feb 2022 12:09:37 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 10/40] arm64/sme: Basic enumeration support
Message-ID: <YhTSgWRfEcn7ZVg1@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-11-broonie@kernel.org>
 <YhOihgeVRTztfDqv@arm.com> <YhOpL54V9RAthj24@sirena.org.uk>
 <YhPnCx+Rajjverjc@arm.com> <YhQb6r0mVSYDHowo@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YhQb6r0mVSYDHowo@sirena.org.uk>
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

On Mon, Feb 21, 2022 at 11:10:34PM +0000, Mark Brown wrote:
> On Mon, Feb 21, 2022 at 07:24:59PM +0000, Catalin Marinas wrote:
> > On Mon, Feb 21, 2022 at 03:01:03PM +0000, Mark Brown wrote:
> > > We do run the kernel in streaming mode - entering the kernel through a
> > > syscall or preemption will not change the streaming mode state, and we
> > > need to be in streaming mode in order to save or restore the register
> > > state for streaming mode.  In particular we need FA64 enabled for EL1 in
> > > order to context switch FFR when in streaming mode, without it we'll
> > > generate an exception when we execute the rdffr or wrffr.  We don't do
> > > any real floating point work in streaming mode but we absolutely need to
> > > run in streaming mode and only exit streaming mode when restoring a
> > > context where it is disabled, when using floating point in the kernel or
> > > when idling the CPU.
> 
> > So, IIUC, for Linux it is mandatory that FEAT_SME_FA64 is supported,
> > otherwise we won't be able to enable SME. Does the architecture say
> 
> The feature is not mandatory and we do not require it for Linux.  It is
> expected that many implementations will choose to not support FA64.
> 
> The only impact it has on the kernel is that if it's present then we
> need to enable it for each EL and then context switch FFR in streaming
> mode, the code is there to do that conditionally already.

OK, I get it. So FFR is only present if FA64 is supported.

> This is actually a bit awkward for not disabling streaming mode when we
> do a syscall since the disabled instructions include the FPSMID mov
> vector, vector instruction which we currently use to zero the high bits
> of the Z registers.  That issue goes away if the optimisations I've got
> for relaxed flushing of the non-shared SVE state that we discussed in
> relation to syscall-abi get merged, though it'd still be there if we add
> a sysctl to force flushing.  This is a solvable problem though, even if
> we have to use a less efficient sequence to flush in streaming mode.

I guess the simplest is to just disable streaming mode on syscall. The C
library would mark the syscall wrappers as not streaming compatible, so
whoever is calling them might disable SM anyway.

So I think your original proposal in the ABI doc is fine (I just need
the libc people to confirm ;)).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
