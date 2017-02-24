From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH 00/13] arm64/kvm: use common sysreg definitions
Date: Fri, 24 Feb 2017 12:16:27 +0000
Message-ID: <20170224121626.GC417@leverpostej>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
 <20170224101650.GE1409@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C990D40DDD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 07:15:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NgE97rOlY+VP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Feb 2017 07:15:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F7BB40DDB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Feb 2017 07:15:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170224101650.GE1409@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 24, 2017 at 11:16:50AM +0100, Christoffer Dall wrote:
> Hi Mark,
> 
> On Tue, Jan 31, 2017 at 06:05:38PM +0000, Mark Rutland wrote:
> > Whenever we add new functionality involving new system registers, we need to
> > add sys_reg() definitions so that we can access the registers regardless of
> > whether the toolchain can assemble them. At the same time, we have to add
> > duplicate definitions of the register encodings to KVM's sysreg tables, so that
> > we can handle any configurable traps. This redundancy is unfortunate, and
> > defining the encodings directly in the sysreg tables can make those tables
> > difficult to read.
> > 
> > This series attempts to address both of these issues by allowing us to use
> > common sys_reg() mnemonics in <asm/sysreg.h> to initialise KVM's sysreg tables.
> > To that end, this series tries to make <asm/sysreg.h> the canonical location
> > for common sysreg encodings.

> I did not do a full in-depth review, but I really like this overall
> change and the changes to KVM look great to me.

Cool; I'll respin+repost this once rc1's out.

I'll have to prepare a prize for whoever's willing to verify the
encodings. ;)

Thanks,
Mark.
