From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/3] arm64/kvm spectre-v1 fixes
Date: Thu, 26 Apr 2018 16:58:03 +0100
Message-ID: <20180426155803.GA898@arm.com>
References: <20180425161342.38133-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D02D740332
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Apr 2018 11:48:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HsHqYrzJSir1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Apr 2018 11:48:17 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A01402D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Apr 2018 11:48:17 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180425161342.38133-1-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, cdall@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 25, 2018 at 05:13:39PM +0100, Mark Rutland wrote:
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

Thanks, I'll pick these up as fixes with Christoffer and Marc's acks on the
kvm parts.

Will
