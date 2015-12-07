From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 21/21] KVM: ARM64: Add a new kvm ARM PMU device
Date: Mon, 07 Dec 2015 15:06:20 +0000
Message-ID: <5665A06C.7060001@arm.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
 <1449123091-20252-22-git-send-email-zhaoshenglong@huawei.com>
 <56659029.7040102@arm.com> <566599C5.4030400@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 365E841390
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 10:04:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dPs+HX2osAp6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 10:04:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F2BB410D7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 10:04:36 -0500 (EST)
In-Reply-To: <566599C5.4030400@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <shannon.zhao@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/15 14:37, Shannon Zhao wrote:
> 
> 
> On 2015/12/7 21:56, Marc Zyngier wrote:
>>> +static int kvm_arm_pmu_set_attr(struct kvm_device *dev,
>>>> +				struct kvm_device_attr *attr)
>>>> +{
>>>> +	switch (attr->group) {
>>>> +	case KVM_DEV_ARM_PMU_GRP_IRQ: {
>>>> +		int __user *uaddr = (int __user *)(long)attr->addr;
>>>> +		int reg;
>>>> +
>>>> +		if (get_user(reg, uaddr))
>>>> +			return -EFAULT;
>>>> +
>>>> +		if (reg < VGIC_NR_SGIS || reg >= VGIC_NR_PRIVATE_IRQS)
>>>> +			return -EINVAL;
>>>> +
>>>> +		return kvm_arm_pmu_set_irq(dev->kvm, reg);
>> What prevents the IRQ to be changed while the VM is already running?
>> This should probably be a one-shot thing (change it once, be denied
>> other changes).
> 
> So add a helper like vgic_initialized to check whether vPMU is initialized?

Something like that, yes.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
