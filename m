Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC33C2D0A8
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 16:02:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 684C420797
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 16:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 684C420797
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=Huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0BA54B3D8;
	Fri,  4 Sep 2020 12:02:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vJ6nVu6+JVNk; Fri,  4 Sep 2020 12:02:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1B74B3A0;
	Fri,  4 Sep 2020 12:02:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BC5C4B290
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 12:02:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DAnbee3sCNzP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 12:02:13 -0400 (EDT)
Received: from huawei.com (lhrrgout.huawei.com [185.176.76.210])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 633FF4B20B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 12:02:13 -0400 (EDT)
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.107])
 by Forcepoint Email with ESMTP id CFC6A44256D8BD91718B;
 Fri,  4 Sep 2020 17:02:10 +0100 (IST)
Received: from localhost (10.52.125.29) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 4 Sep 2020
 17:02:10 +0100
Date: Fri, 4 Sep 2020 17:00:36 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 22/23] KVM: arm64: Add a rVIC/rVID in-kernel implementation
Message-ID: <20200904170036.00003bda@Huawei.com>
In-Reply-To: <20200903152610.1078827-23-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-23-maz@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
X-Originating-IP: [10.52.125.29]
X-ClientProxiedBy: lhreml743-chm.china.huawei.com (10.201.108.193) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, 3 Sep 2020 16:26:09 +0100
Marc Zyngier <maz@kernel.org> wrote:

> The rVIC (reduced Virtual Interrupt Controller), and its rVID
> (reduced Virtual Interrupt Distributor) companion are the two
> parts of a PV interrupt controller architecture, aiming at supporting
> VMs with minimal interrupt requirements.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

A few trivial things from a first read through.

> ---
>  arch/arm64/include/asm/kvm_host.h |    7 +-
>  arch/arm64/include/asm/kvm_irq.h  |    2 +
>  arch/arm64/include/uapi/asm/kvm.h |    9 +
>  arch/arm64/kvm/Makefile           |    2 +-
>  arch/arm64/kvm/arm.c              |    3 +
>  arch/arm64/kvm/hypercalls.c       |    7 +
>  arch/arm64/kvm/rvic-cpu.c         | 1073 +++++++++++++++++++++++++++++
>  include/kvm/arm_rvic.h            |   41 ++
>  include/linux/irqchip/irq-rvic.h  |    4 +
>  include/uapi/linux/kvm.h          |    2 +
>  10 files changed, 1148 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/kvm/rvic-cpu.c
>  create mode 100644 include/kvm/arm_rvic.h
> 

...

> diff --git a/arch/arm64/kvm/rvic-cpu.c b/arch/arm64/kvm/rvic-cpu.c
> new file mode 100644
> index 000000000000..5fb200c637d9
> --- /dev/null
> +++ b/arch/arm64/kvm/rvic-cpu.c

...

> +
> +static int rvic_inject_irq(struct kvm *kvm, unsigned int cpu,
> +			   unsigned int intid, bool level, void *owner)
> +{
> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, cpu);
> +	struct rvic *rvic;
> +
> +	if (unlikely(!vcpu))
> +		return -EINVAL;
> +
> +	rvic = kvm_vcpu_to_rvic(vcpu);
> +	if (unlikely(intid >= rvic->nr_total))
> +		return -EINVAL;
> +
> +	/* Ignore interrupt owner for now */
> +	rvic_vcpu_inject_irq(vcpu, intid, level);

For consistency blank line?

> +	return 0;
> +}
> +

...

> +
> +static int rvic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
> +			      struct kvm *kvm, int irq_source_id,
> +			      int level, bool line_status)
> +{
> +	/* Abuse the userspace interface to perform the routing*/

Space before */

> +	return rvic_inject_userspace_irq(kvm, KVM_ARM_IRQ_TYPE_SPI, 0,
> +					 e->irqchip.pin, level);
> +}
> +

...

> +
> +/* Device management */
> +static int rvic_device_create(struct kvm_device *dev, u32 type)
> +{
> +	struct kvm *kvm = dev->kvm;
> +	struct kvm_vcpu *vcpu;
> +	int i, ret;

It's personal preference, but I'd avoid the fiddly
ret handling in the good path. (up to you though!)

ret = 0;
> +
> +	if (irqchip_in_kernel(kvm))
> +		return -EEXIST;
> +
> +	ret = -EBUSY;
> +	if (!lock_all_vcpus(kvm))
> +		return ret;
	if (!lock_all_vcpus(kvm))
		return -EBUSY;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (vcpu->arch.has_run_once) {
			ret = -EBUSY;
> +			goto out_unlock;
		}
> +	}
> +
> +	ret = 0;
> +
> +	/*
> +	 * The good thing about not having any HW is that you don't
> +	 * get the limitations of the HW...
> +	 */
> +	kvm->arch.max_vcpus		= KVM_MAX_VCPUS;
> +	kvm->arch.irqchip_type		= IRQCHIP_RVIC;
> +	kvm->arch.irqchip_flow		= rvic_irqchip_flow;
> +	kvm->arch.irqchip_data		= NULL;
> +
> +out_unlock:
> +	unlock_all_vcpus(kvm);
> +	return ret;
> +}
> +
> +static void rvic_device_destroy(struct kvm_device *dev)
> +{
> +	kfree(dev->kvm->arch.irqchip_data);
> +	kfree(dev);
> +}
> +
> +static int rvic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
> +{
> +	struct rvic_vm_data *data;
> +	struct kvm_vcpu *vcpu;
> +	u32 __user *uaddr, val;
> +	u16 trusted, total;
> +	int i, ret = -ENXIO;
> +
> +	mutex_lock(&dev->kvm->lock);
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_RVIC_GRP_NR_IRQS:
> +		if (attr->attr)
> +			break;
> +
> +		if (dev->kvm->arch.irqchip_data) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +
> +		uaddr = (u32 __user *)(uintptr_t)attr->addr;
> +		if (get_user(val, uaddr)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		trusted = FIELD_GET(KVM_DEV_ARM_RVIC_GRP_NR_TRUSTED_MASK, val);
> +		total   = FIELD_GET(KVM_DEV_ARM_RVIC_GRP_NR_TOTAL_MASK, val);
> +		if (total < trusted || trusted < 32 || total < 64 ||
> +		    trusted % 32 || total % 32 || total > 2048) {

As I read the spec, we need at least 32 untrusted. (R0058) 
This condition seems to allow that if trusted = 64 and untrusted = 0


> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		data = kzalloc(struct_size(data, rvid_map, (total - trusted)),
> +			       GFP_KERNEL);
> +		if (!data) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		data->nr_trusted = trusted;
> +		data->nr_total = total;
> +		spin_lock_init(&data->lock);
> +		/* Default to no mapping */
> +		for (i = 0; i < (total - trusted); i++) {
> +			/*
> +			 * an intid < nr_trusted is invalid as the
> +			 * result of a translation through the rvid,
> +			 * hence the input in unmapped.
> +			 */
> +			data->rvid_map[i].target_vcpu = 0;
> +			data->rvid_map[i].intid = 0;
> +		}
> +
> +		dev->kvm->arch.irqchip_data = data;
> +
> +		ret = 0;
> +		break;
> +
> +	case KVM_DEV_ARM_RVIC_GRP_INIT:
> +		if (attr->attr)
> +			break;
> +
> +		if (!dev->kvm->arch.irqchip_data)
> +			break;
> +
> +		ret = 0;
> +
> +		/* Init the rvic on any already created vcpu */
> +		kvm_for_each_vcpu(i, vcpu, dev->kvm) {
> +			ret = rvic_vcpu_init(vcpu);
> +			if (ret)
> +				break;
> +		}
> +
> +		if (!ret)
> +			ret = rvic_setup_default_irq_routing(dev->kvm);
> +		if (!ret)
> +			dev->kvm->arch.irqchip_finalized = true;

Personally I'd prefer the more idiomatic 

		if (ret)
			break;

		ret =...
		if (ret)
			break;
		dev->kvm->arch.....

> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	mutex_unlock(&dev->kvm->lock);
> +
> +	return ret;
> +}
> +

...

> +static int rvic_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
> +{
> +	int ret = -ENXIO;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_RVIC_GRP_NR_IRQS:
> +	case KVM_DEV_ARM_RVIC_GRP_INIT:
> +		if (attr->attr)
> +			break;
> +		ret = 0;

Trivial:
Early returns?  Bit shorter and easier to read?

> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct kvm_device_ops rvic_dev_ops = {
> +	.name		= "kvm-arm-rvic",
> +	.create		= rvic_device_create,
> +	.destroy	= rvic_device_destroy,
> +	.set_attr	= rvic_set_attr,
> +	.get_attr	= rvic_get_attr,
> +	.has_attr	= rvic_has_attr,
> +};
> +
> +int kvm_register_rvic_device(void)
> +{
> +	return kvm_register_device_ops(&rvic_dev_ops, KVM_DEV_TYPE_ARM_RVIC);
> +}



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
