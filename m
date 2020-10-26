Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9753FC4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:19:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEF5F22263
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 13:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfacPaOY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEF5F22263
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A3204B4E2;
	Mon, 26 Oct 2020 09:19:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VbVlRCV0Gp2l; Mon, 26 Oct 2020 09:19:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34B974B4EE;
	Mon, 26 Oct 2020 09:19:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A3CE4B4E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:19:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xMiLFf57zWlH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 09:19:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C19174B481
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 09:19:21 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 584A422263;
 Mon, 26 Oct 2020 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603718360;
 bh=BcTmLpM72aN5rRNqD0LO5+HZPNLFaK3Os41pMHM6pjA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=bfacPaOYLsf6FvKADlPAhFckRlcSeSLhLbNZizdOs6UC1MBpwYcmByFrG6RllU/+P
 W1U2BHzwpTliN+BmBROtcAk2dKvv4h8FTcrLBsDjXk4ofn6amOUx8btKqhC/Qvv7Xz
 M82s3pB0stQ5PxHOhai/reou+zcpTrSt+oJoYUq0=
Date: Mon, 26 Oct 2020 13:19:16 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 2/2] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Message-ID: <20201026131915.GB24349@willie-the-truck>
References: <20200924134853.2696503-1-robh@kernel.org>
 <20200924134853.2696503-2-robh@kernel.org>
 <CAL_JsqL02nHO=Mk7HJeBVr69AZ449wb5PpsNuaW3+SYP4HQn8g@mail.gmail.com>
 <84a0a7cbc28ddb5a9e421f666cb8fbb1@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <84a0a7cbc28ddb5a9e421f666cb8fbb1@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Rob Herring <robh@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Oct 21, 2020 at 11:05:10AM +0100, Marc Zyngier wrote:
> On 2020-10-20 15:40, Rob Herring wrote:
> > On Thu, Sep 24, 2020 at 8:48 AM Rob Herring <robh@kernel.org> wrote:
> > > 
> > > On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device
> > > load
> > > and a store exclusive or PAR_EL1 read can cause a deadlock.
> > > 
> > > The workaround requires a DMB SY before and after a PAR_EL1 register
> > > read. In addition, it's possible an interrupt (doing a device read) or
> > > KVM guest exit could be taken between the DMB and PAR read, so we
> > > also need a DMB before returning from interrupt and before returning
> > > to
> > > a guest.
> > > 
> > > A deadlock is still possible with the workaround as KVM guests must
> > > also
> > > have the workaround. IOW, a malicious guest can deadlock an affected
> > > systems.
> > > 
> > > This workaround also depends on a firmware counterpart to enable the
> > > h/w
> > > to insert DMB SY after load and store exclusive instructions. See the
> > > errata document SDEN-1152370 v10 [1] for more information.
> > > 
> > > [1] https://static.docs.arm.com/101992/0010/Arm_Cortex_A77_MP074_Software_Developer_Errata_Notice_v10.pdf
> > > 
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: James Morse <james.morse@arm.com>
> > > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> > > Cc: kvmarm@lists.cs.columbia.edu
> > > Signed-off-by: Rob Herring <robh@kernel.org>
> > > ---
> > > v6:
> > > - Do dmb on kernel_exit rather than disabling interrupts around PAR
> > > read
> > > v5:
> > > - Rebase on v5.9-rc3
> > > - Disable interrupts around PAR reads
> > > - Add DMB on return to guest
> > > 
> > > v4:
> > > - Move read_sysreg_par out of KVM code to sysreg.h to share
> > > - Also use read_sysreg_par in fault.c and kvm/sys_regs.c
> > > - Use alternative f/w for dmbs around PAR read
> > > - Use cpus_have_final_cap instead of cpus_have_const_cap
> > > - Add note about speculation of PAR read
> > > 
> > > v3:
> > > - Add dmbs around PAR reads in KVM code
> > > - Clean-up 'work-around' and 'errata'
> > > 
> > > v2:
> > > - Don't disable KVM, just print warning
> > > ---
> > >  Documentation/arm64/silicon-errata.rst     |  2 ++
> > >  arch/arm64/Kconfig                         | 20 ++++++++++++++++++++
> > >  arch/arm64/include/asm/cpucaps.h           |  3 ++-
> > >  arch/arm64/include/asm/sysreg.h            |  9 +++++++++
> > >  arch/arm64/kernel/cpu_errata.c             | 10 ++++++++++
> > >  arch/arm64/kernel/entry.S                  |  3 +++
> > >  arch/arm64/kvm/arm.c                       |  3 ++-
> > >  arch/arm64/kvm/hyp/include/hyp/switch.h    | 21 +++++++++++++--------
> > >  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  2 +-
> > >  arch/arm64/kvm/hyp/nvhe/switch.c           |  2 +-
> > >  arch/arm64/kvm/hyp/vhe/switch.c            |  2 +-
> > >  arch/arm64/kvm/sys_regs.c                  |  2 +-
> > >  arch/arm64/mm/fault.c                      |  2 +-
> > >  13 files changed, 66 insertions(+), 15 deletions(-)
> > 
> > Marc, Can I get an ack for KVM on this? Will is waiting for one before
> > applying.
> 
> Here you go:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Cheers, Marc.

Rob -- can you repost this based on -rc1 please?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
