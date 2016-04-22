From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH] arm64: Fix EL1/EL2 early init inconsistencies with VHE
Date: Fri, 22 Apr 2016 09:54:12 +0100
Message-ID: <20160422085411.GA2998@e104818-lin.cambridge.arm.com>
References: <1461002246-25314-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 742B349B86
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2016 04:52:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vxCiynt-2Y3r for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2016 04:52:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF4C249B7F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2016 04:52:11 -0400 (EDT)
Content-Disposition: inline
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
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 18, 2016 at 06:57:26PM +0100, Dave P Martin wrote:
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

I queued this for 4.6 (with Marc's ack). Thanks.

-- 
Catalin
