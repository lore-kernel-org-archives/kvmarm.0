From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 0/5] Support userspace irqchip with arch timers
Date: Thu, 6 Apr 2017 18:31:59 +0100
Message-ID: <a41d1e18-dea7-5cfa-5783-09f02d9ce194@arm.com>
References: <20170405092815.22503-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 740F140B40
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 13:29:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n3meIseDwLQr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Apr 2017 13:29:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED52340A86
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 13:29:46 -0400 (EDT)
In-Reply-To: <20170405092815.22503-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Pekka Enberg <penberg@iki.fi>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/04/17 10:28, Christoffer Dall wrote:
> This series is the second version of the rework of the patches to support
> architected timers with a userspace irqchip sent by Alexander Graf [1].
> 
> We first cleanup some of the timer code to make it easier to understand
> what is being done in the later patches, and then define the ABI,
> implement timers support, implement PMU support, and finally advertise
> the features.
> 
> These patches are based on the recent work from Jintack to support the
> physical timer in addition to the virtual timer.  This series including
> its dependencies can be found here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git irqs-to-user-v3
> 
> I tested this using Alex's QEMU patch with his fixes for SMP applied.  This
> seems to be rock-solid.  The temporary-not-for-upstream-but-for-testing patch
> can be found here (force-pushed and rebased since v2):
> 
> https://git.linaro.org/people/christoffer.dall/qemu-arm.git no-kvm-irqchip
> 
> I also tested it on 32-bit and it looks good there as well.
> 
> Changes since v2:
>  - Actually push the right content to the kernel branch, sorry.
>  - Rebased on kvmarm/queue as of this morning (v4.11-rc1+ stuff)
>  - Changed IOCTL numbers as needed
> 
> Changes since v1:
>  - Rework the ABI to support devices in general as opposed to just
>    timers
>  - Support the PMU in addition to timers
>  - Also support the physical timer (rebased on Jintack's work)
>  - Updated some comments where I noticed things were out of date.
> 
> Several changes have been made compared to v7 of the original single
> patch, including:
>  - Rewording ABI documentation to be more in line with the ARM
>    architecture
>  - Add an explicit check for needing to notify userspace of a level
>    change instead of propagating the value
>  - Changes to commenting throughout to more accurately describe the
>    architecture concepts we try to maintain
>  - Reword of functions, for example from sync to update when the date
>    only flows one direction
> 
> [1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2016-September/021867.html
> [2]: git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next

The couple of nits I mentioned notwithstanding, for the whole series:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
