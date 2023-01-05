Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AF4C3DA7D
	for <kvmarm@archiver.kernel.org>; Thu,  5 Jan 2023 15:42:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41E0A4B3F9;
	Thu,  5 Jan 2023 10:42:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UiCkCGyV2xNZ; Thu,  5 Jan 2023 10:42:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A4B24B643;
	Thu,  5 Jan 2023 10:42:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 220544B3F9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Jan 2023 10:42:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GuveN-tAVpM5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Jan 2023 10:42:33 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E09384B3DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Jan 2023 10:42:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9CF76B81B2F;
 Thu,  5 Jan 2023 15:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9863C433EF;
 Thu,  5 Jan 2023 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672933350;
 bh=rYLLvAR7qCxC2NW9cBbIijuxkUi6aKDT/oIR1nZIP0M=;
 h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
 b=cg04Q+e7do/v/m0+12IJZWJ5GKocxU/KF12DQzObMGjVXX9zK8O0gph4aU/xSBjNx
 XweZrbr+bDOZ1UG0T7I6sw0qsJi5rwZe8j+Zd0tlid4bfLI3vjiF++Ol4qCdw4NWbN
 JnR23TehDqtluNXjLUXseVhVlzICw8Md/oc+7Ek7lvMHjB+6ohWp+/+uL/XyziPQ5E
 IE2vCl5thcdTljW5u1t+90Dzbl2rnmNqxevHP2wxY8xYjiFoLTSNmL3XgLIdCkFLvt
 F5NETytG4OcOyo7+Pqr3JA++hk4k1tw9L5iexaPMj1IGLTbgGh6JH2DHgAsPH7p+Fe
 bKIZ4rIMH4xRQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
 id 81DA35C029A; Thu,  5 Jan 2023 07:42:29 -0800 (PST)
Date: Thu, 5 Jan 2023 07:42:29 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH rcu 02/27] arch/arm64/kvm: Remove "select SRCU"
Message-ID: <20230105154229.GU4028633@paulmck-ThinkPad-P17-Gen-1>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-2-paulmck@kernel.org>
 <86mt6x724m.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86mt6x724m.wl-maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@meta.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
 rcu@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: paulmck@kernel.org
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

On Thu, Jan 05, 2023 at 09:38:01AM +0000, Marc Zyngier wrote:
> On Thu, 05 Jan 2023 00:37:48 +0000,
> "Paul E. McKenney" <paulmck@kernel.org> wrote:
> > 
> > Now that the SRCU Kconfig option is unconditionally selected, there is
> > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > Kconfig statements.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: <linux-arm-kernel@lists.infradead.org>
> > Cc: <kvmarm@lists.linux.dev>
> > Cc: <kvmarm@lists.cs.columbia.edu>
> > ---
> >  arch/arm64/kvm/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 05da3c8f7e88f..312f0e9869111 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -28,7 +28,6 @@ menuconfig KVM
> >  	select KVM_MMIO
> >  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >  	select KVM_XFER_TO_GUEST_WORK
> > -	select SRCU
> >  	select KVM_VFIO
> >  	select HAVE_KVM_EVENTFD
> >  	select HAVE_KVM_IRQFD
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Thank you, Marc!  I will apply this on my next rebase.

							Thanx, Paul

> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
