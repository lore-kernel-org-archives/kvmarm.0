From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.PAN on entry to EL2
Date: Thu, 1 Sep 2016 15:55:29 +0100
Message-ID: <57C84161.3030607@arm.com>
References: <1472740143-40061-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD63F40FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 10:47:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xFO1Rqgecafj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 10:47:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03E33409A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 10:47:21 -0400 (EDT)
In-Reply-To: <1472740143-40061-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/09/16 15:29, Vladimir Murzin wrote:
> SCTLR_EL2.SPAN bit controls what happens with the PSTATE.PAN bit on an
> exception. However, this bit has no effect on the PSTATE.PAN when
> HCR_EL2.E2H or HCR_EL2.TGE is unset. Thus when VHE is used and
> exception taken from a guest PSTATE.PAN bit left unchanged and we
> continue with a value guest has set.
> 
> To address that always reset PSTATE.PAN on entry from EL1.
> 
> Fixes: 1f364c8c48a0 ("arm64: VHE: Add support for running Linux in EL2 mode")
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Reviewed-by: James Morse <james.morse@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
