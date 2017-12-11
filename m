From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 26/36] KVM: arm64: Defer saving/restoring system
 registers to vcpu load/put on VHE
Date: Mon, 11 Dec 2017 13:20:03 +0000
Message-ID: <c45eaebe-57a1-7737-c515-111d497dd06e@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-27-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-27-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> Some system registers do not affect the host kernel's execution and can
> therefore be loaded when we are about to run a VCPU and we don't have to
> restore the host state to the hardware before the time when we are
> actually about to return to userspace or schedule out the VCPU thread.
> 
> The EL1 system registers and the userspace state registers, which only
> affect EL0 execution, do not affect the host kernel's execution.
> 
> The 32-bit system registers are not used by a VHE host kernel and
> therefore don't need to be saved/restored on every entry/exit to/from
> the guest, but can be deferred to vcpu_load and vcpu_put, respectively.

Note that they are not used by the !VHE host kernel either, and I
believe they could be deferred too, although that would imply a round
trip to HYP to save/restore them. We already have such a hook there when
configuring ICH_VMCR_EL2, so we may not need much of a new infrastructure.

What do you think?

	M.
-- 
Jazz is not dead. It just smells funny...
