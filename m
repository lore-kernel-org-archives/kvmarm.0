Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70DFC41514
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 11:48:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7738A233A0
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 11:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7738A233A0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE11D4A5B7;
	Thu, 22 Aug 2019 07:48:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UgIWipbXq1PI; Thu, 22 Aug 2019 07:48:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 971314A5C0;
	Thu, 22 Aug 2019 07:48:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC434A59E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 07:48:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gYoIs1p6zBKl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 07:48:43 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B2D84A593
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 07:48:43 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id E3D4ACC6F3D6B9BD062D;
 Thu, 22 Aug 2019 19:48:39 +0800 (CST)
Received: from localhost (10.202.226.61) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 19:48:38 +0800
Date: Thu, 22 Aug 2019 12:48:25 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 07/10] KVM: arm64: Provide a PV_TIME device to user
 space
Message-ID: <20190822124825.000009f1@huawei.com>
In-Reply-To: <87bc2a01-8cf5-5161-45f8-00384775cf3a@arm.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-8-steven.price@arm.com>
 <20190822115722.00005aa7@huawei.com>
 <87bc2a01-8cf5-5161-45f8-00384775cf3a@arm.com>
Organization: Huawei
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
X-Originating-IP: [10.202.226.61]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Thu, 22 Aug 2019 12:11:55 +0100
Steven Price <steven.price@arm.com> wrote:

> On 22/08/2019 11:57, Jonathan Cameron wrote:
> > On Wed, 21 Aug 2019 16:36:53 +0100
> > Steven Price <steven.price@arm.com> wrote:
> >   
> >> Allow user space to inform the KVM host where in the physical memory
> >> map the paravirtualized time structures should be located.
> >>
> >> A device is created which provides the base address of an array of
> >> Stolen Time (ST) structures, one for each VCPU. There must be (64 *
> >> total number of VCPUs) bytes of memory available at this location.
> >>
> >> The address is given in terms of the physical address visible to
> >> the guest and must be page aligned. The guest will discover the address
> >> via a hypercall.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>  
> > 
> > Hi Steven,
> > 
> > One general question inline.  I'm not particularly familiar with this area
> > of the kernel, so maybe I'm missing something obvious, but having
> > .destroy free the kvm_device which wasn't created in .create seems
> > 'unusual'. 
> > 
> > Otherwise, FWIW looks good to me.
> > 
> > Jonathan
> >   
> [...]
> >> +static void kvm_arm_pvtime_destroy(struct kvm_device *dev)
> >> +{
> >> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
> >> +
> >> +	pvtime->st_base = GPA_INVALID;
> >> +	kfree(dev);  
> > 
> > Nothing to do with your patch as such... All users do the same.
> > 
> > This seems miss balanced. Why do we need to free the device by hand
> > when we didn't create it in the create function?  I appreciate
> > the comments say this is needed, but as far as I can see every
> > single callback does kfree(dev) at the end which seems an
> > odd thing to do.  
> 
> Yes I think this is odd too - indeed when I initially wrote this I
> missed off the kfree() call and had to track down the memory leak.
> 
> When I looked into potentially tiding this up I found some other
> oddities, e.g. "kvm-xive" (arch/powerpc/kvm/book3s_xive.c) doesn't have
> a destroy callback. But I can't see anything in the common code which
> deals with that case. So I decided to just "go with the flow" at the
> moment, since I don't understand how some of these existing devices work
> (perhaps they are already broken?).

It has a release however and kvm_device_release also removes the
device from the list that would then be cleared by kvm_destroy_devices.

kvm_device_release is a release callback for the file operations so it
'might' be called in all paths.

Fun though, in kvm_ioctl_create_device the error handling for
the anon_inode_getfd calls ops->destroy without checking it exists.
Boom.

Possibly never happens in reality but looks like a bug to me.

Jonathan


> 
> Steve
> 
> >> +}
> >> +
> >> +static int kvm_arm_pvtime_set_attr(struct kvm_device *dev,
> >> +				   struct kvm_device_attr *attr)
> >> +{
> >> +	struct kvm *kvm = dev->kvm;
> >> +	struct kvm_arch_pvtime *pvtime = &kvm->arch.pvtime;
> >> +	u64 __user *user = (u64 __user *)attr->addr;
> >> +	struct kvm_dev_arm_st_region region;
> >> +
> >> +	switch (attr->group) {
> >> +	case KVM_DEV_ARM_PV_TIME_REGION:
> >> +		if (copy_from_user(&region, user, sizeof(region)))
> >> +			return -EFAULT;
> >> +		if (region.gpa & ~PAGE_MASK)
> >> +			return -EINVAL;
> >> +		if (region.size & ~PAGE_MASK)
> >> +			return -EINVAL;
> >> +		switch (attr->attr) {
> >> +		case KVM_DEV_ARM_PV_TIME_ST:
> >> +			if (pvtime->st_base != GPA_INVALID)
> >> +				return -EEXIST;
> >> +			pvtime->st_base = region.gpa;
> >> +			pvtime->st_size = region.size;
> >> +			return 0;
> >> +		}
> >> +		break;
> >> +	}
> >> +	return -ENXIO;
> >> +}
> >> +
> >> +static int kvm_arm_pvtime_get_attr(struct kvm_device *dev,
> >> +				   struct kvm_device_attr *attr)
> >> +{
> >> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
> >> +	u64 __user *user = (u64 __user *)attr->addr;
> >> +	struct kvm_dev_arm_st_region region;
> >> +
> >> +	switch (attr->group) {
> >> +	case KVM_DEV_ARM_PV_TIME_REGION:
> >> +		switch (attr->attr) {
> >> +		case KVM_DEV_ARM_PV_TIME_ST:
> >> +			region.gpa = pvtime->st_base;
> >> +			region.size = pvtime->st_size;
> >> +			if (copy_to_user(user, &region, sizeof(region)))
> >> +				return -EFAULT;
> >> +			return 0;
> >> +		}
> >> +		break;
> >> +	}
> >> +	return -ENXIO;
> >> +}
> >> +
> >> +static int kvm_arm_pvtime_has_attr(struct kvm_device *dev,
> >> +				   struct kvm_device_attr *attr)
> >> +{
> >> +	switch (attr->group) {
> >> +	case KVM_DEV_ARM_PV_TIME_REGION:
> >> +		switch (attr->attr) {
> >> +		case KVM_DEV_ARM_PV_TIME_ST:
> >> +			return 0;
> >> +		}
> >> +		break;
> >> +	}
> >> +	return -ENXIO;
> >> +}
> >> +
> >> +static const struct kvm_device_ops pvtime_ops = {
> >> +	"Arm PV time",
> >> +	.create = kvm_arm_pvtime_create,
> >> +	.destroy = kvm_arm_pvtime_destroy,
> >> +	.set_attr = kvm_arm_pvtime_set_attr,
> >> +	.get_attr = kvm_arm_pvtime_get_attr,
> >> +	.has_attr = kvm_arm_pvtime_has_attr
> >> +};
> >> +
> >> +void kvm_pvtime_init(void)
> >> +{
> >> +	kvm_register_device_ops(&pvtime_ops, KVM_DEV_TYPE_ARM_PV_TIME);
> >> +}  
> > 
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >   
> 


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
