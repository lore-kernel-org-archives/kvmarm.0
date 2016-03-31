From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm64: KVM: Register CPU notifiers when the kernel
 runs at HYP
Date: Thu, 31 Mar 2016 09:15:15 +0100
Message-ID: <56FCDC93.3070304@arm.com>
References: <1459359184-15601-1-git-send-email-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 684E840FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 04:14:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nsQvyCNkZOPC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2016 04:14:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC1640F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 04:14:14 -0400 (EDT)
In-Reply-To: <1459359184-15601-1-git-send-email-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/03/16 18:33, James Morse wrote:
> When the kernel is running at EL2, it doesn't need init_hyp_mode() to
> configure page tables for HYP. This function also registers the CPU
> hotplug and lower power notifiers that cause HYP to be re-initialised
> after the CPU has been reset.
> 
> To avoid losing the register state that controls stage2 translation, move
> the registering of these notifiers into init_subsystems(), and add a
> is_kernel_in_hyp_mode() path to each callback.
> 
> Fixes: 1e947bad0b6 ("arm64: KVM: Skip HYP setup when already running in HYP")
> Signed-off-by: James Morse <james.morse@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
