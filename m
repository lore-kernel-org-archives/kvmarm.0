Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891C4C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 19 Dec 2021 12:12:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C7B34B2D9;
	Sun, 19 Dec 2021 07:12:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TMeTiQdBU-Wd; Sun, 19 Dec 2021 07:12:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B82274B2F9;
	Sun, 19 Dec 2021 07:12:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C31B4B2BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 11:43:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M2rvkkbJEd29 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 11:43:49 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20D5F4B292
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 11:43:49 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6C7D2B82969;
 Fri, 17 Dec 2021 16:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02971C36AE7;
 Fri, 17 Dec 2021 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639759426;
 bh=xkjazaXf9e0HqFX4MjQxPv2BOTPj/MpAXhlPTHttWyk=;
 h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
 b=YTyCfVjTbg8mkVA2Tl/PRClrCiLA5+/UCpd2WHbEicmlSu1k3xM+dYHodKxffl8b1
 oLAiR6feNwRR4jQoVGH/HJ8fMd5Kq1xMf4rm7gvYH1W7xCCFaaNU8NlGU/rUbBfaIE
 UjAd8hWR1dkLvYeB3mHyP96fW28SU3ai4apASxn63KF/33o/jJN1XtpLoXy1F8m4C4
 BRE9Dgxkf9WqlnBX6gvB9+qFh5atzLePTsxhNhwzgGfqduKE+hzHHS8iVr2ZQ3fy7p
 diHCHPtH7Cdw1rxSh7MA7FvwC34TyKXEoZ2fCr6rB74jgDrY4xQEKd4DxnT2c2Wy+H
 fZ5rTE4xchqqw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
 id AFDCB5C0610; Fri, 17 Dec 2021 08:43:45 -0800 (PST)
Date: Fri, 17 Dec 2021 08:43:45 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Message-ID: <20211217164345.GT641268@paulmck-ThinkPad-P17-Gen-1>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
 <20211217160749.GS641268@paulmck-ThinkPad-P17-Gen-1>
 <27231550b5600072da918aa41c07404dea13590e.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <27231550b5600072da918aa41c07404dea13590e.camel@redhat.com>
X-Mailman-Approved-At: Sun, 19 Dec 2021 07:12:12 -0500
Cc: maz <maz@kernel.org>, frederic <frederic@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Dec 17, 2021 at 05:20:21PM +0100, Nicolas Saenz Julienne wrote:
> Hi Paul,
> 
> On Fri, 2021-12-17 at 08:07 -0800, Paul E. McKenney wrote:
> > On Fri, Dec 17, 2021 at 04:54:22PM +0100, Paolo Bonzini wrote:
> > > On 12/17/21 15:38, Mark Rutland wrote:
> > > > For example kvm_guest_enter_irqoff() calls guest_enter_irq_off() which calls
> > > > vtime_account_guest_enter(), but kvm_guest_exit_irqoff() doesn't call
> > > > guest_exit_irq_off() and the call to vtime_account_guest_exit() is open-coded
> > > > elsewhere. Also, guest_enter_irq_off() conditionally calls
> > > > rcu_virt_note_context_switch(), but I can't immediately spot anything on the
> > > > exit side that corresponded with that, which looks suspicious.
> > > 
> > > rcu_note_context_switch() is a point-in-time notification; it's not strictly
> > > necessary, but it may improve performance a bit by avoiding unnecessary IPIs
> > > from the RCU subsystem.
> > > 
> > > There's no benefit from doing it when you're back from the guest, because at
> > > that point the CPU is just running normal kernel code.
> > 
> > Do scheduling-clock interrupts from guest mode have the "user" parameter
> > set?  If so, that would keep RCU happy.
> 
> Are you referring to the user_mode() check in irqentry_enter()? If so I don't
> think it'll help, arm64 doesn't use that function. It directly calls
> enter_from_{user,kernel}_mode() through its custom entry/exit routines.

I am talking about rcu_sched_clock_irq(), which is called from
update_process_times(), which is called from various places depending
on .config.  These call sites pass in either user_mode(regs) or
user_mode(get_irq_regs()).

Huh.  Maybe I should be looking into using user_mode(get_irq_regs())
in other places within RCU.  Except that I bet the possibility of RCU
being invoked from NMI handlers makes this a bit tricky.

							Thanx, Paul
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
