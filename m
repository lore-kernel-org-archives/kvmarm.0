From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 10/13] KVM: arm64: Save ESR_EL2 on guest SError
Date: Tue, 16 Jan 2018 09:41:02 +0000
Message-ID: <ca2deb53-e995-0a58-61d4-e45faa6ec9f1@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-11-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C9949DED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:36:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RDoHShbS6dLR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 04:36:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60DB749DE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:36:05 -0500 (EST)
In-Reply-To: <20180115193906.30053-11-james.morse@arm.com>
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
> When we exit a guest due to an SError the vcpu fault info isn't updated
> with the ESR. Today this is only done for traps.
> 
> The v8.2 RAS Extensions define ISS values for SError. Update the vcpu's
> fault_info with the ESR on SError so that handle_exit() can determine
> if this was a RAS SError and decode its severity.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> Changes since v4:
>  * Switched to Marc's exit_code != irq version
> 
> (Christoffer gave Reviewed-by for v2, which I missed (sorry), the patch
>  has changed since then..)
> 
>  arch/arm64/kvm/hyp/switch.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
