From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 05/21] KVM: ARM64: Add reset and access handlers for
 PMSELR register
Date: Tue, 1 Dec 2015 20:46:29 +0800
Message-ID: <565D96A5.3000401@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-6-git-send-email-zhaoshenglong@huawei.com>
 <20151130175600.0ce835cd@arm.com> <565CFD2F.8010902@huawei.com>
 <565D5F2F.1020709@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <565D5F2F.1020709@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: wei@redhat.com, kvm@vger.kernel.org, shannon.zhao@linaro.org, will.deacon@arm.com, peter.huangpeng@huawei.com, linux-arm-kernel@lists.infradead.org, alex.bennee@linaro.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, cov@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/1 16:49, Marc Zyngier wrote:
> On 01/12/15 01:51, Shannon Zhao wrote:
>> Hi Marc,
>>
>> On 2015/12/1 1:56, Marc Zyngier wrote:
>>> Same remark here as the one I made earlier. I'm pretty sure we don't
>>> call any CP15 reset because they are all shared with their 64bit
>>> counterparts. The same thing goes for the whole series.
>> Ok, I see. But within the 64bit reset function, it needs to update the
>> 32bit register value, right? Since when accessing these 32bit registers,
>> it uses the offset c9_PMXXXX.
> 
> It shouldn't,  because the 64bit and 32bit share the same storage. From
> your own patch:
> 
> +/* Performance Monitors*/
> +#define c9_PMCR		(PMCR_EL0 * 2)
> +#define c9_PMOVSSET	(PMOVSSET_EL0 * 2)
> +#define c9_PMOVSCLR	(PMOVSCLR_EL0 * 2)
> +#define c9_PMCCNTR	(PMCCNTR_EL0 * 2)
> +#define c9_PMSELR	(PMSELR_EL0 * 2)
> +#define c9_PMCEID0	(PMCEID0_EL0 * 2)
> +#define c9_PMCEID1	(PMCEID1_EL0 * 2)
> +#define c9_PMXEVCNTR	(PMXEVCNTR_EL0 * 2)
> +#define c9_PMXEVTYPER	(PMXEVTYPER_EL0 * 2)
> +#define c9_PMCNTENSET	(PMCNTENSET_EL0 * 2)
> +#define c9_PMCNTENCLR	(PMCNTENCLR_EL0 * 2)
> +#define c9_PMINTENSET	(PMINTENSET_EL1 * 2)
> +#define c9_PMINTENCLR	(PMINTENCLR_EL1 * 2)
> +#define c9_PMUSERENR	(PMUSERENR_EL0 * 2)
> +#define c9_PMSWINC	(PMSWINC_EL0 * 2)
> 
> These are indexes in the copro array:
> 
> struct kvm_cpu_context {
> 	struct kvm_regs	gp_regs;
> 	union {
> 		u64 sys_regs[NR_SYS_REGS];
> 		u32 copro[NR_COPRO_REGS];
> 	};
> };
> 
> which is in a union with the sys_reg array. So anything that affects one
> affects the other because:
> - there is only one state in the physical CPU, no matter which mode
> you're in,
> - the guest EL1 is either 32bit or 64bit, and never changes over time.
> 
> Hope this helps,
> 
Ok, I see. Thanks for the explanation. :)

-- 
Shannon
