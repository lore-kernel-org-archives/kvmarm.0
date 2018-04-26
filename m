From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/3] arm64/kvm spectre-v1 fixes
Date: Thu, 26 Apr 2018 11:37:54 +0100
Message-ID: <b6523cf2-09bb-f461-86b5-d6a6663bf912@arm.com>
References: <20180425161342.38133-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFCB649F8B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Apr 2018 06:28:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hW+BprG+cMvk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Apr 2018 06:28:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A83640478
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Apr 2018 06:28:31 -0400 (EDT)
In-Reply-To: <20180425161342.38133-1-mark.rutland@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, cdall@kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 25/04/18 17:13, Mark Rutland wrote:
> These patches fix arm64-specific potential spectre-v1 gadgets found by
> smatch when run over v4.17-rc2.
> 
> I'm still building up my smatch database, so it's possible that there are
> further gadgets to be found.
> 
> For the moment I've ignored issues which appear to be cross-architecture.
> 
> Thanks,
> Mark.
> 
> Mark Rutland (3):
>   arm64: fix possible spectre-v1 in ptrace_hbp_get_event()
>   KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_get_irq()
>   KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_mmio_read_apr()
> 
>  arch/arm64/kernel/ptrace.c       | 14 ++++++++++----
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  5 +++++
>  virt/kvm/arm/vgic/vgic.c         | 14 ++++++++++----
>  3 files changed, 25 insertions(+), 8 deletions(-)
> 

For the KVM patches:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
