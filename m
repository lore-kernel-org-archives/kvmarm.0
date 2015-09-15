From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [Qemu-devel] [PATCH RFC 2/4] arm64: kvm: enable trapping of read
 access to regs in TID3 group
Date: Tue, 15 Sep 2015 15:51:46 +0800
Message-ID: <55F7CE12.3060606@linaro.org>
References: <1441787914-3191-1-git-send-email-tushar.jagad@linaro.org>
 <1441787914-3191-3-git-send-email-tushar.jagad@linaro.org>
 <55F79D5D.4080103@huawei.com> <20150915071804.GA4622@pnqlab044.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05E2540FA7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 03:51:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TNfx1AgCWEhp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2015 03:51:03 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B324B40FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 03:51:03 -0400 (EDT)
Received: by wicgb1 with SMTP id gb1so15911593wic.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 00:51:58 -0700 (PDT)
In-Reply-To: <20150915071804.GA4622@pnqlab044.amcc.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tushar Jagad <tushar.jagad@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: marc.zyngier@arm.com, patches@apm.com, qemu-devel@nongnu.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/9/15 15:18, Tushar Jagad wrote:
> 
> Hi Shannon,
> 
> On Tue, Sep 15, 2015 at 12:23:57PM +0800, Shannon Zhao wrote:
>>
>>
>> On 2015/9/9 16:38, Tushar Jagad wrote:
>>> This patch modifies the HCR_GUEST_FLAGS to enable trapping of
>>> non secure read to registers under the HCR_EL2.TID3 group to EL2.
>>>
>>> We emulate the accesses to capability registers which list the number of
>>> breakpoints, watchpoints, etc. These values are provided by the user when
>>> starting the VM. The emulated values are constructed at runtime from the
>>> trap handler.
>>>
>>> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
>>> ---
>>>  Documentation/virtual/kvm/api.txt |    8 +
>>>  arch/arm/kvm/arm.c                |   50 ++++-
>>>  arch/arm64/include/asm/kvm_arm.h  |    2 +-
>>>  arch/arm64/include/asm/kvm_asm.h  |   38 +++-
>>>  arch/arm64/include/asm/kvm_host.h |    4 +-
>>>  arch/arm64/include/uapi/asm/kvm.h |    7 +
>>>  arch/arm64/kvm/sys_regs.c         |  443 +++++++++++++++++++++++++++++++++----
>>>  7 files changed, 503 insertions(+), 49 deletions(-)
>>>
>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>>> index a7926a9..b06c104 100644
>>> --- a/Documentation/virtual/kvm/api.txt
>>> +++ b/Documentation/virtual/kvm/api.txt
>>> @@ -2561,6 +2561,14 @@ Possible features:
>>>  	  Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
>>>  	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
>>>  	  Depends on KVM_CAP_ARM_PSCI_0_2.
>>> +	- KVM_ARM_VCPU_NUM_BPTS: Number of supported h/w breakpoints
>>> +	  This is a 4-bit value which defines number of hardware
>>> +	  breakpoints supported on guest. If this is not sepecified or
>>> +	  set to zero then the guest sees the value as is from the host.
>>> +	- KVM_ARM_VCPU_NUM_WPTS: Number of supported h/w watchpoints
>>> +	  This is a 4-bit value which defines number of hardware
>>> +	  watchpoints supported on guest. If this is not sepecified or
>>> +	  set to zero then the guest sees the value as is from the host.
>>>
>>>
>>>  4.83 KVM_ARM_PREFERRED_TARGET
>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>> index bc738d2..8907d37 100644
>>> --- a/arch/arm/kvm/arm.c
>>> +++ b/arch/arm/kvm/arm.c
>>> @@ -696,6 +696,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>>>  			       const struct kvm_vcpu_init *init)
>>>  {
>>>  	unsigned int i;
>>> +	u64 aa64dfr;
>>> +
>>>  	int phys_target = kvm_target_cpu();
>>>
>>>  	if (init->target != phys_target)
>>> @@ -708,6 +710,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>>>  	if (vcpu->arch.target != -1 && vcpu->arch.target != init->target)
>>>  		return -EINVAL;
>>>
>>> +	asm volatile("mrs %0, ID_AA64DFR0_EL1\n" : "=r" (aa64dfr));
>>> +
>>>  	/* -ENOENT for unknown features, -EINVAL for invalid combinations. */
>>>  	for (i = 0; i < sizeof(init->features) * 8; i++) {
>>>  		bool set = (init->features[i / 32] & (1 << (i % 32)));
>>> @@ -715,6 +719,50 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>>>  		if (set && i >= KVM_VCPU_MAX_FEATURES)
>>>  			return -ENOENT;
>>>
>>> +		if (i == KVM_ARM_VCPU_NUM_BPTS) {
>>> +			int h_bpts;
>>> +			int g_bpts;
>>> +
>>> +			h_bpts = ((aa64dfr >> 12) & 0xf) + 1;
>>> +			g_bpts = (init->features[KVM_ARM_VCPU_BPTS_FEATURES_IDX] &
>>> +					KVM_ARM_VCPU_BPTS_MASK) >> KVM_ARM_VCPU_NUM_BPTS;
>>> +
>>> +			/*
>>> +			 * We ensure that the host can support the requested
>>> +			 * number of hardware breakpoints.
>>> +			 */
>>> +			if (g_bpts > h_bpts)
>>> +				return -EINVAL;
>>> +
>> This may not work. Assuming that the number of source host hardware
>> breakpoints is 15 and userspace set the g_bpts to 15 as well, it's ok to
>> create VM on the source host. But if the number of destination host
>> hardware breakpoints is lees than 15 (e.g. 8), this will return -EINVAL
>> and fail to create VM on the destination host and migrate failed.
>>
>> (P.S. I'm considering the guest PMU for cross-cpu type, so I have look
>> at this patch)
> 
> We basically want to avoid migrating a guest to a host which lacks the
> necessary support in the hardware. Thus consider a case where in there are
> different platforms (with different CPU implementation capabilities) in a
> cluster ie. few platforms support 2 h/w breakpoints/watchpoints, some platforms
> support 4 h/w breakpoints/watchpoints, etc. In this case the least common
> denominator of these implementation details should be considered before
> starting a vm. So in the given scenario we will configure all vm's to have 2
> h/w breakpoints/watchpoints which will avoid crashing of guest post migration.
> 

Oh, I see. Using the minimum number of all the hardware bpts/wpts.

> For now these patches consider h/w breakpoint and h/w watchpoints but need to
> expand to include PMU support.

Yeah, I think about how to do it. It could use the same way you do, i.e.
using cpu features to allow userspace to set the number of PMU counters
and store it at vcpu->arch.pmcs. Then when resetting vcpus, sync the
vcpu->arch.pmcs to the emulated register bits PMCR_EL0.N in the
reset_pmcr and if the vcpu->arch.pmcs == 0, use the host value.

What do you think about this?

You can have a look at the guest PMU patchset from [1]
"[PATCH v2 04/22] KVM: ARM64: Add reset and access handlers for PMCR_EL0
register"

[1]https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016393.html

-- 
Shannon
