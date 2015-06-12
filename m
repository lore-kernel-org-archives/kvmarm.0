From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 0/2] arm64: KVM: Use instruction patching for GIC world
 switch
Date: Fri, 12 Jun 2015 15:12:55 +0100
Message-ID: <20150612141254.GI29305@e104818-lin.cambridge.arm.com>
References: <1434107197-4919-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D41B54EA2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jun 2015 10:02:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dax0+Le8yVIT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jun 2015 10:02:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00D4954E4D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jun 2015 10:02:34 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1434107197-4919-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 12, 2015 at 12:06:35PM +0100, Marc Zyngier wrote:
> The current way we deal with the GIC world switch on arm64 is a bit
> convoluted. As we have two possible backends, we rely on a couple of
> indirections set at boot time. These indirection never change, so it
> would make more sense to directly patch in a branch to the right
> function.
> 
> To do this, we introduce a new CPU feature that detect the presence of
> a GICv3 CPU interface. When detected, we patch branches to the GICv3
> save/restore functions that otherwise point to the GICv2 backend.
> 
> Tested on both GICv2 (Juno, Seattle) and GICv3 (FVP Base model).
> 
> These patches have been on the various lists for quite a while as part
> of a series dealing with instruction patching. Now that the
> prerequisite are queued for 4.2, it would make sense for these to be
> merged alongside.
> 
> Catalin, would you mind taking them through the arm64 tree?
> 
> Marc Zyngier (2):
>   arm64: alternative: Introduce feature for GICv3 CPU interface
>   arm64: KVM: Switch vgic save/restore to alternative_insn

Applied. Thanks.

-- 
Catalin
