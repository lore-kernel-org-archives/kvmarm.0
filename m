From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 08/13] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Tue, 16 Jan 2018 10:05:12 +0000
Message-ID: <d070e8ad-f331-a08b-ccd6-ee13916a7798@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-9-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180115193906.30053-9-james.morse@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Xie XiuQi <xiexiuqi@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/18 19:39, James Morse wrote:
> Prior to v8.2's RAS Extensions, the HCR_EL2.VSE 'virtual SError' feature
> generated an SError with an implementation defined ESR_EL1.ISS, because we
> had no mechanism to specify the ESR value.
> 
> On Juno this generates an all-zero ESR, the most significant bit 'ISV'
> is clear indicating the remainder of the ISS field is invalid.
> 
> With the RAS Extensions we have a mechanism to specify this value, and the
> most significant bit has a new meaning: 'IDS - Implementation Defined
> Syndrome'. An all-zero SError ESR now means: 'RAS error: Uncategorized'
> instead of 'no valid ISS'.
> 
> Add KVM support for the VSESR_EL2 register to specify an ESR value when
> HCR_EL2.VSE generates a virtual SError. Change kvm_inject_vabt() to
> specify an implementation-defined value.
> 
> We only need to restore the VSESR_EL2 value when HCR_EL2.VSE is set, KVM
> save/restores this bit during __{,de}activate_traps() and hardware clears the
> bit once the guest has consumed the virtual-SError.
> 
> Future patches may add an API (or KVM CAP) to pend a virtual SError with
> a specified ESR.
> 
> Cc: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> Changes since v4:
>  * Fixed an uncatagorized typo
> 
>  arch/arm64/include/asm/kvm_emulate.h |  5 +++++
>  arch/arm64/include/asm/kvm_host.h    |  3 +++
>  arch/arm64/include/asm/sysreg.h      |  1 +
>  arch/arm64/kvm/hyp/switch.c          |  3 +++
>  arch/arm64/kvm/inject_fault.c        | 13 ++++++++++++-
>  5 files changed, 24 insertions(+), 1 deletion(-)

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
