From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] arm64: Fix EL1/EL2 early init inconsistencies with VHE
Date: Thu, 21 Apr 2016 15:02:02 +0100
Message-ID: <5718DD5A.2050800@arm.com>
References: <1461002246-25314-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C74A449B3F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 10:00:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AFycUybxJcLX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2016 10:00:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8274849B36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2016 10:00:02 -0400 (EDT)
In-Reply-To: <1461002246-25314-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 18/04/16 18:57, Dave Martin wrote:
> When using the Virtualisation Host Extensions, EL1 is not used in
> the host and requires no separate configuration.
> 
> In addition, with VHE enabled, non-hyp-specific EL2 configuration
> that does not need to be done early will be done anyway in
> __cpu_setup via the _EL1 system register aliases.  In particular,
> the layout and definition of CPTR_EL2 are changed by enabling VHE
> so that they resemble CPACR_EL1, so existing code to initialise
> CPTR_EL2 becomes architecturally wrong in this case.
> 
> This patch simply skips the affected initialisation code in the
> non-VHE case.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
> 
> Note -- not tested yet, and I'm still unclear on whether this is the
> correct architectural approach...

This looks correct to me. Given that we're not leaving EL2, there is no
reason to do things earlier than they are done at EL1, and this fixes an
obvious bug on CPTR_EL2 access.

I've given it a go on a VHE model, and it ran just fine, so:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
