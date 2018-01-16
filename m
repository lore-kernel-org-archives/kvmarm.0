From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 07/13] KVM: arm/arm64: mask/unmask daif around VHE
 guests
Date: Tue, 16 Jan 2018 10:01:28 +0000
Message-ID: <2dddb720-de25-91d5-fe4d-f5d4758e98b8@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-8-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2632749DED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:56:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3eu5VaiXHXGD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 04:56:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33A7049DE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 04:56:31 -0500 (EST)
In-Reply-To: <20180115193906.30053-8-james.morse@arm.com>
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
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
