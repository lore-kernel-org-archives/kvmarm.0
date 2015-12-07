From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero
 register transfers
Date: Mon, 7 Dec 2015 16:25:59 -0600
Message-ID: <20151207222559.GI4402@hawk.localdomain>
References: <cover.1449230499.git.p.fedin@samsung.com>
 <20151205003334.GB3117@hawk.localdomain>
 <013501d130d4$635722f0$2a0568d0$@samsung.com>
 <20151207215811.GH4402@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D6B341252
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 17:24:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id byxgsL5yopwq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 17:24:17 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 050CE409A2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 17:24:16 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20151207215811.GH4402@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 07, 2015 at 03:58:11PM -0600, Andrew Jones wrote:
> On Mon, Dec 07, 2015 at 12:48:12PM +0300, Pavel Fedin wrote:
> >  Hello!
> > 
> > > FYI, I tried writing test cases for this issue with kvm-unit-tests. The
> > > issue didn't reproduce for me. It's quite possible my test cases are
> > > flawed
> > 
> >  Indeed they are, a very little thing fell through again... :)
> >  It's not just SP, it's SP_EL0. And you never initialize it to anything because your code always runs in kernel mode, so it's just
> > zero, so you get your zero.
> >  But if you add a little thing in the beginning of your main():
> > 
> > asm volatile("msr sp_el0, %0" : : "r" (0xDEADC0DE0BADC0DE));
> 
> Ah! Thanks for this. The mmio test does now fail for me too. The sysreg
> test still doesn't fail for me (even though I'm doing the above on the
> vcpu I use for that too). Maybe there's something weird with which reg
> I'm using, and whether or not my attempt to get trapping enabled on it
> is working the way I expected. I'll play with it some more.
>

Must be the trapping thing. I switched to dbgbvr0_el1, which has
trapping enabled on it until it's touched, and was able the reproduce
the xzr issue it.

drew
