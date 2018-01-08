From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 07/13] KVM: arm/arm64: mask/unmask daif around VHE
 guests
Date: Mon, 08 Jan 2018 16:26:51 +0000
Message-ID: <5A539BCB.8060509@arm.com>
References: <20171215155101.23505-1-james.morse@arm.com>
 <20171215155101.23505-8-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A61B49DDF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 11:24:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wIgUc1CC5LPQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jan 2018 11:24:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF6B249D27
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 11:24:27 -0500 (EST)
In-Reply-To: <20171215155101.23505-8-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 15/12/17 15:50, James Morse wrote:
> Non-VHE systems take an exception to EL2 in order to world-switch into the
> guest. When returning from the guest KVM implicitly restores the DAIF
> flags when it returns to the kernel at EL1.
> 
> With VHE none of this exception-level jumping happens, so KVMs
> world-switch code is exposed to the host kernel's DAIF values, and KVM
> spills the guest-exit DAIF values back into the host kernel.
> On entry to a guest we have Debug and SError exceptions unmasked, KVM
> has switched VBAR but isn't prepared to handle these. On guest exit
> Debug exceptions are left disabled once we return to the host and will
> stay this way until we enter user space.
> 
> Add a helper to mask/unmask DAIF around VHE guests. The unmask can only
> happen after the hosts VBAR value has been synchronised by the isb in
> __vhe_hyp_call (via kvm_call_hyp()). Masking could be as late as
> setting KVMs VBAR value, but is kept here for symmetry.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> This isn't backportable because of the 'daif' helpers, I will produce a
> backport once its merged.
> 
> Changes since v4:
>  * Added empty declarations for 32bit. (how did I miss that?)

v4 of this patch had a Reviewed-by Christoffer, which I didn't pick up as I then
went on to confuse everyone...

https://patchwork.kernel.org/patch/10017467/

(Sorry Christoffer!)


Thanks,

James
