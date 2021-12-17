Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7758AC4332F
	for <kvmarm@archiver.kernel.org>; Sun, 19 Dec 2021 12:12:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF8B04B2DA;
	Sun, 19 Dec 2021 07:12:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jiDpg1ZzxZr5; Sun, 19 Dec 2021 07:12:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 896974B2F3;
	Sun, 19 Dec 2021 07:12:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 373474B364
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 11:07:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IsG+PmumQ1nV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 11:07:51 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E44D4B32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 11:07:51 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B124E62287;
 Fri, 17 Dec 2021 16:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AF3C36AE7;
 Fri, 17 Dec 2021 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639757270;
 bh=CLb/vJNslUVn2r+sZTAnMRXCOXn59toIUCwh/IkwYQc=;
 h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
 b=CauBV+W9fQqYJLQzdeFA0ISzNJpiTCqIKyxongSwUvHWWkmV6ZD9Fz7RP0oQ0HBqY
 cMixjLYJ6SzKCdfisxaElhQrLY9OTob7qk2q5CMOldEHODGQRb++uLrqE0Bsij7oBd
 Sny8bv8CbPIc1qIylGoq0z+KgoMCXO916kbjwDU5VgipqhhmbDonLjrNwKYZE6mMiC
 lrSvid8A7axsjUwi7wLgvumi7Q6GMMEUZBFoGZlR79akUsGpEWTFlDlE/IhWSFfO7g
 A47nTjy8S6M8YD1L3F8xNYUTLIkoH/EtFPc5eoqGUzNIr1k3C/wOEm8glNIEVob0i2
 U/5/faGEZFJqA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
 id D3C9F5C0610; Fri, 17 Dec 2021 08:07:49 -0800 (PST)
Date: Fri, 17 Dec 2021 08:07:49 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Message-ID: <20211217160749.GS641268@paulmck-ThinkPad-P17-Gen-1>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
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

On Fri, Dec 17, 2021 at 04:54:22PM +0100, Paolo Bonzini wrote:
> On 12/17/21 15:38, Mark Rutland wrote:
> > For example kvm_guest_enter_irqoff() calls guest_enter_irq_off() which calls
> > vtime_account_guest_enter(), but kvm_guest_exit_irqoff() doesn't call
> > guest_exit_irq_off() and the call to vtime_account_guest_exit() is open-coded
> > elsewhere. Also, guest_enter_irq_off() conditionally calls
> > rcu_virt_note_context_switch(), but I can't immediately spot anything on the
> > exit side that corresponded with that, which looks suspicious.
> 
> rcu_note_context_switch() is a point-in-time notification; it's not strictly
> necessary, but it may improve performance a bit by avoiding unnecessary IPIs
> from the RCU subsystem.
> 
> There's no benefit from doing it when you're back from the guest, because at
> that point the CPU is just running normal kernel code.

Do scheduling-clock interrupts from guest mode have the "user" parameter
set?  If so, that would keep RCU happy.

							Thanx, Paul
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
