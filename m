Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BD0C433FE
	for <kvmarm@archiver.kernel.org>; Sun, 19 Dec 2021 12:12:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF7824B256;
	Sun, 19 Dec 2021 07:12:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KjSvPjSG7Bla; Sun, 19 Dec 2021 07:12:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A2404B2E1;
	Sun, 19 Dec 2021 07:12:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3A5E4B22C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 12:12:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3cW3HD09k94Y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 12:12:19 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D34704B215
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 12:12:19 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1AA4E6233D;
 Fri, 17 Dec 2021 17:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBFBC36AE8;
 Fri, 17 Dec 2021 17:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639761138;
 bh=GszWHJciD4A9dmjPuqqtxIzn00kkF1IyT82H2olfyAs=;
 h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
 b=l5F0/VkgWEw7v+6AVHA6qKqnuv6Njco2SyHTYRm2ktw1PiXRMTIOXaF3OruEAfwfG
 Q11TLUzu00BsrNCypmPnlGP1E8vSkmNk6Z2a4gOiL79yp/ln2uctxYs09ZOMduwvoj
 zumRYIah+RTf4YOPiaj+Vw77EI3MFWmqjF7V8ly661rGyL8bAePJgLiYrxPlTb+X0N
 1110S1gUS2JxaFa7Dms14KhpoYM5TvE/rfI4VrEJOMYPwmWVLyPrfNfa/dp7g5I6ta
 7MCu5o9uvofccWM2EFiGNqkxCu7YgJe0mQkHpNESVMNrMIUB92x6h0fxnafooQnWxZ
 trS62QDxSzrbw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
 id 16B465C0610; Fri, 17 Dec 2021 09:12:18 -0800 (PST)
Date: Fri, 17 Dec 2021 09:12:18 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Message-ID: <20211217171218.GV641268@paulmck-ThinkPad-P17-Gen-1>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
 <20211217160749.GS641268@paulmck-ThinkPad-P17-Gen-1>
 <f3d6095a-70aa-3da0-08a6-3caff2638809@redhat.com>
 <20211217164535.GU641268@paulmck-ThinkPad-P17-Gen-1>
 <4c369ca2-2ad0-4a02-90e9-2d82df6c289d@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4c369ca2-2ad0-4a02-90e9-2d82df6c289d@redhat.com>
X-Mailman-Approved-At: Sun, 19 Dec 2021 07:12:12 -0500
Cc: maz <maz@kernel.org>, frederic <frederic@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
 rcu <rcu@vger.kernel.org>, Nicolas Saenz Julienne <nsaenzju@redhat.com>,
 Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Fri, Dec 17, 2021 at 06:02:23PM +0100, Paolo Bonzini wrote:
> On 12/17/21 17:45, Paul E. McKenney wrote:
> > On Fri, Dec 17, 2021 at 05:34:04PM +0100, Paolo Bonzini wrote:
> > > On 12/17/21 17:07, Paul E. McKenney wrote:
> > > > > rcu_note_context_switch() is a point-in-time notification; it's not strictly
> > > > > necessary, but it may improve performance a bit by avoiding unnecessary IPIs
> > > > > from the RCU subsystem.
> > > > > 
> > > > > There's no benefit from doing it when you're back from the guest, because at
> > > > > that point the CPU is just running normal kernel code.
> > > > 
> > > > Do scheduling-clock interrupts from guest mode have the "user" parameter
> > > > set?  If so, that would keep RCU happy.
> > > 
> > > No, thread is in supervisor mode.  But after every interrupt (timer tick or
> > > anything), one of three things can happen:
> > > 
> > > * KVM will go around the execution loop and invoke rcu_note_context_switch()
> > > again
> > > 
> > > * or KVM will go back to user space
> > 
> > Here "user space" is a user process as opposed to a guest OS?
> 
> Yes, that code runs from ioctl(KVM_RUN) and the ioctl will return to the
> calling process.

Intriguing.  A user process within the guest OS or a user process outside
of any guest OS, that is, within the host?

							Thanx, Paul

> Paolo
> 
> > > * or the thread will be preempted
> > > 
> > > and either will keep RCU happy as far as I understand.
> > 
> > Regardless of the answer to my question above, yes, these will keep
> > RCU happy.  ;-)
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
