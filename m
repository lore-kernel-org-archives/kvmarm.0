From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 02/12] KVM: arm/arm64: Factor out hypercall handling from
 PSCI code
Date: Mon, 3 Dec 2018 17:02:25 +0100
Message-ID: <20181203160225.4vhoe4slwyyx2mlw@kamzik.brq.redhat.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181128144527.44710-3-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5FE64A2BA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 11:02:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oi-ISh75WPP5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 11:02:30 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F18D74A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 11:02:29 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181128144527.44710-3-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 28, 2018 at 02:45:17PM +0000, Steven Price wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> We currently intertwine the KVM PSCI implementation with the general
> dispatch of hypercall handling, which makes perfect sense because PSCI
> is the only category of hypercalls we support.
> 
> However, as we are about to support additional hypercalls, factor out
> this functionality into a separate hypercall handler file.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [steven.price@arm.com: rebased]
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm/kvm/Makefile        |  2 +-
>  arch/arm/kvm/handle_exit.c   |  2 +-
>  arch/arm64/kvm/Makefile      |  1 +
>  arch/arm64/kvm/handle_exit.c |  4 +-
>  include/kvm/arm_hypercalls.h | 43 ++++++++++++++++++++
>  include/kvm/arm_psci.h       |  2 +-
>  virt/kvm/arm/hypercalls.c    | 51 ++++++++++++++++++++++++
>  virt/kvm/arm/psci.c          | 76 +-----------------------------------
>  8 files changed, 102 insertions(+), 79 deletions(-)
>  create mode 100644 include/kvm/arm_hypercalls.h
>  create mode 100644 virt/kvm/arm/hypercalls.c
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
