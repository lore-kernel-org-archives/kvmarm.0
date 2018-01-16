From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 11/13] KVM: arm64: Handle RAS SErrors from EL1 on guest
 exit
Date: Tue, 16 Jan 2018 09:29:48 +0000
Message-ID: <ecd3e942-6a53-3337-9701-d6a18824e4ca@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-12-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 665D049DC4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:24:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zjQzLIfyd709 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 04:24:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2335C49DC5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:24:51 -0500 (EST)
In-Reply-To: <20180115193906.30053-12-james.morse@arm.com>
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
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/18 19:39, James Morse wrote:
> We expect to have firmware-first handling of RAS SErrors, with errors
> notified via an APEI method. For systems without firmware-first, add
> some minimal handling to KVM.
> 
> There are two ways KVM can take an SError due to a guest, either may be a
> RAS error: we exit the guest due to an SError routed to EL2 by HCR_EL2.AMO,
> or we take an SError from EL2 when we unmask PSTATE.A from __guest_exit.
> 
> For SError that interrupt a guest and are routed to EL2 the existing
> behaviour is to inject an impdef SError into the guest.
> 
> Add code to handle RAS SError based on the ESR. For uncontained and
> uncategorized errors arm64_is_fatal_ras_serror() will panic(), these
> errors compromise the host too. All other error types are contained:
> For the fatal errors the vCPU can't make progress, so we inject a virtual
> SError. We ignore contained errors where we can make progress as if
> we're lucky, we may not hit them again.
> 
> If only some of the CPUs support RAS the guest will see the cpufeature
> sanitised version of the id registers, but we may still take RAS SError
> on this CPU. Move the SError handling out of handle_exit() into a new
> handler that runs before we can be preempted. This allows us to use
> this_cpu_has_cap(), via arm64_is_ras_serror().
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> Changes since v4:
>  * Moved SError handling into handle_exit_early(). This will need to move
>    earlier, into an SError-masked region once we support kernel-first.
>    (hence the vauge name)
>  * Dropped Marc & Christoffer's Reviewed-by due to handle_exit_early().
> 
>  arch/arm/include/asm/kvm_host.h   |  3 +++
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/handle_exit.c      | 18 +++++++++++++++++-
>  virt/kvm/arm/arm.c                |  3 +++
>  4 files changed, 25 insertions(+), 1 deletion(-)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
