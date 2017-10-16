From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 00/10] arm/arm64: KVM: limit icache invalidation to
 prefetch aborts
Date: Mon, 16 Oct 2017 22:59:16 +0200
Message-ID: <20171016205916.GP1845@lvm>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF57849D1C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 16:58:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o04+X5H6WHM1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 16:58:23 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74E7740638
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 16:58:23 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id b189so6368075wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 13:59:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171009152032.27804-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 09, 2017 at 04:20:22PM +0100, Marc Zyngier wrote:
> It was recently reported that on a VM restore, we seem to spend a
> disproportionate amount of time invalidation the icache. This is
> partially due to some HW behaviour, but also because we're being a bit
> dumb and are invalidating the icache for every page we map at S2, even
> if that on a data access.
> 
> The slightly better way of doing this is to mark the pages XN at S2,
> and wait for the the guest to execute something in that page, at which
> point we perform the invalidation. As it is likely that there is a lot
> less instruction than data, we win (or so we hope).
> 
> We also take this opportunity to drop the extra dcache clean to the
> PoU which is pretty useless, as we already clean all the way to the
> PoC...
> 
> Running a bare metal test that touches 1GB of memory (using a 4kB
> stride) leads to the following results on Seattle:
> 
> 4.13:
> do_fault_read.bin:       0.565885992 seconds time elapsed
> do_fault_write.bin:       0.738296337 seconds time elapsed
> do_fault_read_write.bin:       1.241812231 seconds time elapsed
> 
> 4.14-rc3+patches:
> do_fault_read.bin:       0.244961803 seconds time elapsed
> do_fault_write.bin:       0.422740092 seconds time elapsed
> do_fault_read_write.bin:       0.643402470 seconds time elapsed
> 
> We're almost halving the time of something that more or less looks
> like a restore operation. Some larger systems will show much bigger
> benefits as they become less impacted by the icache invalidation
> (which is broadcast in the inner shareable domain).
> 
> I've also given it a test run on both Cubietruck and Jetson-TK1.
> 
> Tests are archived here:
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvm-ws-tests.git/
> 
> I'd value some additional test results on HW I don't have access to.
> 

What would also be interesting is some insight into how big the hit then
is on first execution, but that should in no way gate merging these
patches.

Thanks,
-Christoffer
