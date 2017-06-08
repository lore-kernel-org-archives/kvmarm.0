From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvmtool PATCH v10 00/15] kvmtool: arm: ITS emulation and GSI
 routing support
Date: Thu, 08 Jun 2017 10:11:42 +0100
Message-ID: <87wp8mj12p.fsf@arm.com>
References: <20170425143932.17235-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E04AD40BC5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 05:07:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7rJqL2L+zdCU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 05:07:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D12C740430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 05:07:37 -0400 (EDT)
In-Reply-To: <20170425143932.17235-1-andre.przywara@arm.com> (Andre Przywara's
 message of "Tue, 25 Apr 2017 15:39:17 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 25 2017 at  3:39:17 pm BST, Andre Przywara <andre.przywara@arm.com> wrote:
> Hi,
>
> another update to the ITS emulation series for kvmtool.
> This addresses the comments Marc and Jean-Philippe had on the last
> version (thanks for that!): I moved the DevID feature detection to avoid
> static variables, rewrote the error path on creating IRQ routes and
> extended the MMIO reservation to cover the ITS doorbell page as well.
> Not sure if that's the right way to do, though.
> Also we now ignore writes to the PBA region, which is what the spec
> somewhat recommends.
> -------------------------------------------
>
> This series teaches kvmtool how to support KVM's ITS emulation. Also
> (as this is somewhat related and has been co-developed) it enables GSI
> routing for ARM/ARM64, which allows IRQFDs to be used, for instance
> to use vhost_net. At the moment this is dependent on the guest
> using the ITS emulation, but GICv2M support may be added at a later time.
>
> The first six patches are generic fixes and refactoring to pave the
> road for the rest of the patches. Most importantly patch 3/15 pulls
> the GSI routing code from x86 into generic code.
> Patch 7 updates the Linux headers to pull the new ITS and 32-bit
> GICv3 definitions in. This allows us to enable GICv3 emulation for 32-bit
> ARM and also get rid of some placeholder lines in patch 8.
> The following four patches add ITS emulation support. They reserve and
> register the required ITS register frame and populate a DT node with
> the necessary data. Also the patches add the required device ID to the
> KVM_SIGNAL_MSI ioctl.
> Patches 13 and 14 enable IRQ GSI routing for ARM/ARM64.
> This is needed to use IRQFDs, which is a prerequisite for vhost
> functionality, for instance. The code sets up the (dummy) SPI
> routing table and adds the device ID to the routing entry.
> The last patch finally enables the guest ITS support by extending the
> existing --irqchip= parameter to allow "--irqchip=gicv3-its".
>
> These patches make use of the KVM kernel functionality merged into
> 4.8-rc: both Eric's IRQ routing series and the ITS emulation.
> It can also be found in my kvmtool git repository [1].

[...]

Apologies for having dropped the ball on this series. Apart from the
Linux include import which should be that of 4.11, this looks good to
me. For the whole series:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
