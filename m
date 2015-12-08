From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v5 03/21] KVM: ARM64: Add offset defines for PMU registers
Date: Tue, 8 Dec 2015 16:09:26 +0800
Message-ID: <56669036.9090606@huawei.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com> <1449123091-20252-4-git-send-email-zhaoshenglong@huawei.com> <56659276.6060403@arm.com> <5665984F.30102@linaro.org> <56659DD8.6050109@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56659DD8.6050109@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 2015/12/7 22:55, Marc Zyngier wrote:
> On 07/12/15 14:31, Shannon Zhao wrote:
>> > 
>> > 
>> > On 2015/12/7 22:06, Marc Zyngier wrote:
>>> >> On 03/12/15 06:11, Shannon Zhao wrote:
>>>> >>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>> >>>
>>>> >>> We are about to trap and emulate acccesses to each PMU register
>>> >>
>>> >> s/acccesses/accesses/
>>> >>
>>>> >>> individually. This adds the context offsets for the AArch64 PMU
>>>> >>> registers and their AArch32 counterparts.
>>>> >>>
>>>> >>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>> >>> ---
>>>> >>>   arch/arm64/include/asm/kvm_asm.h | 55 ++++++++++++++++++++++++++++++++++++----
>>>> >>>   1 file changed, 50 insertions(+), 5 deletions(-)
>>>> >>>
>>>> >>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>>>> >>> index 5e37710..4f804c1 100644
>>>> >>> --- a/arch/arm64/include/asm/kvm_asm.h
>>>> >>> +++ b/arch/arm64/include/asm/kvm_asm.h
>>>> >>> @@ -48,12 +48,34 @@
>>>> >>>   #define MDSCR_EL1	22	/* Monitor Debug System Control Register */
>>>> >>>   #define MDCCINT_EL1	23	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>>>> >>>
>>> >>
>>> >> Coming back to this patch, it gives a clear view of where you have state
>>> >> duplication.
>>> >>
>>>> >>> +/* Performance Monitors Registers */
>>>> >>> +#define PMCR_EL0	24	/* Control Register */
>>>> >>> +#define PMOVSSET_EL0	25	/* Overflow Flag Status Set Register */
>>>> >>> +#define PMOVSCLR_EL0	26	/* Overflow Flag Status Clear Register */
>>> >>
>>> >> This should only be a single state. You don't even have to represent it
>>> >> in the sysreg array, to be honest.
>>> >>

Re-think about this. Since there are different operates to SET/CLR
registers, maybe it should keep both of them while only storing the
state in one of them.

To SET:
	vcpu_sys_reg(vcpu, r->reg) |= val;
To CLR:
	vcpu_sys_reg(vcpu, r->reg) &= ~val;

Or keep one of them and within the access handler, according to the
operates encoding value to judge whether it's SET or CLR.

-- 
Shannon

