From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 05/21] KVM: ARM64: Add reset and access handlers for
 PMSELR register
Date: Tue, 01 Dec 2015 08:49:51 +0000
Message-ID: <565D5F2F.1020709@arm.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-6-git-send-email-zhaoshenglong@huawei.com> <20151130175600.0ce835cd@arm.com> <565CFD2F.8010902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <565CFD2F.8010902@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/15 01:51, Shannon Zhao wrote:
> Hi Marc,
> 
> On 2015/12/1 1:56, Marc Zyngier wrote:
>> Same remark here as the one I made earlier. I'm pretty sure we don't
>> call any CP15 reset because they are all shared with their 64bit
>> counterparts. The same thing goes for the whole series.
> Ok, I see. But within the 64bit reset function, it needs to update the
> 32bit register value, right? Since when accessing these 32bit registers,
> it uses the offset c9_PMXXXX.

It shouldn't,  because the 64bit and 32bit share the same storage. From
your own patch:

+/* Performance Monitors*/
+#define c9_PMCR		(PMCR_EL0 * 2)
+#define c9_PMOVSSET	(PMOVSSET_EL0 * 2)
+#define c9_PMOVSCLR	(PMOVSCLR_EL0 * 2)
+#define c9_PMCCNTR	(PMCCNTR_EL0 * 2)
+#define c9_PMSELR	(PMSELR_EL0 * 2)
+#define c9_PMCEID0	(PMCEID0_EL0 * 2)
+#define c9_PMCEID1	(PMCEID1_EL0 * 2)
+#define c9_PMXEVCNTR	(PMXEVCNTR_EL0 * 2)
+#define c9_PMXEVTYPER	(PMXEVTYPER_EL0 * 2)
+#define c9_PMCNTENSET	(PMCNTENSET_EL0 * 2)
+#define c9_PMCNTENCLR	(PMCNTENCLR_EL0 * 2)
+#define c9_PMINTENSET	(PMINTENSET_EL1 * 2)
+#define c9_PMINTENCLR	(PMINTENCLR_EL1 * 2)
+#define c9_PMUSERENR	(PMUSERENR_EL0 * 2)
+#define c9_PMSWINC	(PMSWINC_EL0 * 2)

These are indexes in the copro array:

struct kvm_cpu_context {
	struct kvm_regs	gp_regs;
	union {
		u64 sys_regs[NR_SYS_REGS];
		u32 copro[NR_COPRO_REGS];
	};
};

which is in a union with the sys_reg array. So anything that affects one
affects the other because:
- there is only one state in the physical CPU, no matter which mode
you're in,
- the guest EL1 is either 32bit or 64bit, and never changes over time.

Hope this helps,

	M.
-- 
Jazz is not dead. It just smells funny...
