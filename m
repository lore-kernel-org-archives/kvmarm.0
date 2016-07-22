From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: kvm: set cpsr before spsr on fault injection
Date: Fri, 22 Jul 2016 16:37:35 +0100
Message-ID: <57923DBF.90003@arm.com>
References: <1469198326-27345-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469198326-27345-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/07/16 15:38, Andrew Jones wrote:
> We need to set cpsr before determining the spsr bank, as the bank
> depends on the target exception level of the injection, not the
> current mode of the vcpu. Normally this is one in the same (EL1),
> but not when we manage to trap an EL0 fault. It still doesn't really
> matter for the 64-bit EL0 case though, as vcpu_spsr() unconditionally
> uses the EL1 bank for that. However the 32-bit EL0 case gets fun, as
> that path will lead to the BUG() in vcpu_spsr32()
> 
> This patch fixes the assignment order and also modifies some white
> space in order to better group pairs of lines that have strict order.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Ouch. Nice catch. Can you find what's the earliest release this would
cleanly apply to? Definitely deserves a CC stable.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
