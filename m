From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/5] arm64: Patching branches for fun and profit
Date: Thu, 26 Mar 2015 22:04:52 +0000
Message-ID: <20150326220452.GB23836@arm.com>
References: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0596C49DBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 17:57:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wv+YB56dFKGG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 17:57:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53D7349DBE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 17:57:54 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Andre Przywara <Andre.Przywara@arm.com>, Dave P Martin <Dave.Martin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 19, 2015 at 01:59:31PM +0000, Marc Zyngier wrote:
> The current alternative instruction framework is not kind to branches,
> potentially leading to all kind of hacks in the code that uses
> alternatives. This series expands it to deal with immediate branches
> (for a start), and applies it to the VGIC world switch.
> 
> Patch #1 adds the required infrastructure to extract the immediate
> from an instruction.
> 
> Patch #2 allows the use of an immediate b or bl instruction as an
> alternative, computing the target branch as the instruction is being
> patched in.
> 
> Patch #3 defines a feature framework that works exactly like the CPU
> errata infrastructure (and shares a lot with it).
> 
> Patch #4 adds detection of the system register GICv3 CPU interface.
> 
> Patch #5 enables dynamic patching of the KVM code.
> 
> This has been tested with GICv3 on a FastModel.

Modulo my one minor comment:

  Acked-by: Will Deacon <will.deacon@arm.com>

for the series.

Will
