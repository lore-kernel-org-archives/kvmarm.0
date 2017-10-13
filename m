From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 07/13] firmware: arm_sdei: Add driver for Software
 Delegated Exceptions
Date: Fri, 13 Oct 2017 16:49:14 +0100
Message-ID: <20171013154914.ktxecc6zobh7fmr6@armageddon.cambridge.arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
 <20170922182614.27885-8-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FD749D3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 11:48:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZQZtgHKe3d8g for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Oct 2017 11:48:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0388649D39
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 11:48:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170922182614.27885-8-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 22, 2017 at 07:26:08PM +0100, James Morse wrote:
> The Software Delegated Exception Interface (SDEI) is an ARM standard
> for registering callbacks from the platform firmware into the OS.
> This is typically used to implement firmware notifications (such as
> firmware-first RAS) or promote an IRQ that has been promoted to a
> firmware-assisted NMI.
> 
> Add the code for detecting the SDEI version and the framework for
> registering and unregistering events. Subsequent patches will add the
> arch-specific backend code and the necessary power management hooks.
> 
> Only shared events are supported, power management, private events and
> discovery for ACPI systems will be added by later patches.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> Changes since v2:
>  * Copy the priority into the structure the arch asm handler gets. This
>    is used for VMAP stacks where we can't know if a critical event interrupted
>    a normal priority event, thus they need separate stacks.
> 
> Changes since v1:
>  * Changed entry point to unsigned long, if we support non-vhe systems this
>    won't be a valid pointer
>  * Made invoke_sdei_fn() pass the only register we are interested in, instead
>    of the whole arm_smccc_res
>  * Made all the locking WARN_ON()s lockdep_assert_held()s.
>  * Moved more messages from 'err' to 'warn'.
>  * Made IS_SDEI_CALL() not depend on whether the config option is selected.
>  * Made 'event failed' messages rate limited.
> 
>  drivers/firmware/Kconfig    |   7 +
>  drivers/firmware/Makefile   |   1 +
>  drivers/firmware/arm_sdei.c | 616 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/sdei.h        | 100 +++++++
>  include/uapi/linux/sdei.h   |  91 +++++++
>  5 files changed, 815 insertions(+)
>  create mode 100644 drivers/firmware/arm_sdei.c
>  create mode 100644 include/linux/sdei.h
>  create mode 100644 include/uapi/linux/sdei.h

I haven't reviewed this patch (yet...). However, I think it's worth
adding a MAINTAINERS entry with your name on it (unless you really want
to distance yourself from this code once merged ;)).

Thanks.

-- 
Catalin
