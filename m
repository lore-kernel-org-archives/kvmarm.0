From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v5 21/21] KVM: ARM64: Add a new kvm ARM PMU device
Date: Mon, 07 Dec 2015 22:37:57 +0800
Message-ID: <566599C5.4030400@linaro.org>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
 <1449123091-20252-22-git-send-email-zhaoshenglong@huawei.com>
 <56659029.7040102@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B6B49692
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 09:36:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0XcjudAPKx23 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 09:36:23 -0500 (EST)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com
 [209.85.220.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 264B0412E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 09:36:22 -0500 (EST)
Received: by pacwq6 with SMTP id wq6so48597099pac.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2015 06:38:09 -0800 (PST)
In-Reply-To: <56659029.7040102@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/7 21:56, Marc Zyngier wrote:
>> +static int kvm_arm_pmu_set_attr(struct kvm_device *dev,
>> >+				struct kvm_device_attr *attr)
>> >+{
>> >+	switch (attr->group) {
>> >+	case KVM_DEV_ARM_PMU_GRP_IRQ: {
>> >+		int __user *uaddr = (int __user *)(long)attr->addr;
>> >+		int reg;
>> >+
>> >+		if (get_user(reg, uaddr))
>> >+			return -EFAULT;
>> >+
>> >+		if (reg < VGIC_NR_SGIS || reg >= VGIC_NR_PRIVATE_IRQS)
>> >+			return -EINVAL;
>> >+
>> >+		return kvm_arm_pmu_set_irq(dev->kvm, reg);
> What prevents the IRQ to be changed while the VM is already running?
> This should probably be a one-shot thing (change it once, be denied
> other changes).

So add a helper like vgic_initialized to check whether vPMU is initialized?

Thanks,
-- 
Shannon
