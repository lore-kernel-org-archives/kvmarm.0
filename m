From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Factor out vgic_attr_regs_access
 functionality
Date: Tue, 16 Aug 2016 18:06:33 +0200
Message-ID: <20160816160633.7jft4xir5hs3bavj@kamzik.localdomain>
References: <20160816151034.16930-1-christoffer.dall@linaro.org>
 <20160816151034.16930-2-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9FF441267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 11:59:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c2Ajn8s5YblW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 11:59:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39DB3411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 11:59:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160816151034.16930-2-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 16, 2016 at 05:10:33PM +0200, Christoffer Dall wrote:
> As we are about to deal with multiple data types and situations where
> the vgic should not be initialized when doing userspace accesses on the
> register attributes, factor out the functionality of
> vgic_attr_regs_access into smaller bits which can be reused by a new
> function later.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 102 ++++++++++++++++++++++++++----------
>  1 file changed, 75 insertions(+), 27 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 1813f93..22d7ab3 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -233,6 +233,69 @@ int kvm_register_vgic_device(unsigned long type)
>  	return ret;
>  }
>  
> +struct vgic_reg_attr {
> +	struct kvm_vcpu *vcpu;
> +	gpa_t addr;
> +};
> +
> +static int parse_vgic_v2_attr(struct kvm_device *dev,
> +			      struct kvm_device_attr *attr,
> +			      struct vgic_reg_attr *reg_attr)
> +{
> +	int cpuid;
> +
> +	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
> +		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> +
> +	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
> +		return -EINVAL;
> +
> +	reg_attr->vcpu = kvm_get_vcpu(dev->kvm, cpuid);
> +	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +
> +	return 0;
> +}
> +
> +/* unlocks vcpus from @vcpu_lock_idx and smaller */
> +static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> +{
> +	struct kvm_vcpu *tmp_vcpu;
> +
> +	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> +		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> +		mutex_unlock(&tmp_vcpu->mutex);
> +	}
> +}
> +
> +/* unlocks vcpus from @vcpu_lock_idx and smaller */

incorrect comment here (copy+pasted from above)

> +static void unlock_all_vcpus(struct kvm *kvm)
> +{
> +	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> +}
> +
> +
> +/* Returns true if all vcpus were locked, false otherwise */
> +static bool lock_all_vcpus(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *tmp_vcpu;
> +	int c;
> +
> +	/*
> +	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
> +	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
> +	 * that no other VCPUs are run and fiddle with the vgic state while we
> +	 * access it.
> +	 */
> +	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> +		if (!mutex_trylock(&tmp_vcpu->mutex)) {
> +			unlock_vcpus(kvm, c - 1);
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
>  /** vgic_attr_regs_access: allows user space to read/write VGIC registers
>   *
>   * @dev: kvm device handle
> @@ -245,15 +308,17 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
>  				 struct kvm_device_attr *attr,
>  				 u32 *reg, bool is_write)
>  {
> +	struct vgic_reg_attr reg_attr;
>  	gpa_t addr;
> -	int cpuid, ret, c;
> -	struct kvm_vcpu *vcpu, *tmp_vcpu;
> -	int vcpu_lock_idx = -1;
> +	struct kvm_vcpu *vcpu;
> +	int ret;
>  
> -	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
> -		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> -	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
> -	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +	ret = parse_vgic_v2_attr(dev, attr, &reg_attr);
> +	if (ret)
> +		return ret;
> +
> +	vcpu = reg_attr.vcpu;
> +	addr = reg_attr.addr;
>  
>  	mutex_lock(&dev->kvm->lock);
>  
> @@ -261,24 +326,11 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
>  	if (ret)
>  		goto out;
>  
> -	if (cpuid >= atomic_read(&dev->kvm->online_vcpus)) {
> -		ret = -EINVAL;
> +	if (!lock_all_vcpus(dev->kvm)) {
> +		ret = -EBUSY;
>  		goto out;
>  	}
>  
> -	/*
> -	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
> -	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
> -	 * that no other VCPUs are run and fiddle with the vgic state while we
> -	 * access it.
> -	 */
> -	ret = -EBUSY;
> -	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm) {
> -		if (!mutex_trylock(&tmp_vcpu->mutex))
> -			goto out;
> -		vcpu_lock_idx = c;
> -	}
> -
>  	switch (attr->group) {
>  	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
>  		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
> @@ -291,12 +343,8 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
>  		break;
>  	}
>  
> +	unlock_all_vcpus(dev->kvm);
>  out:
> -	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> -		tmp_vcpu = kvm_get_vcpu(dev->kvm, vcpu_lock_idx);
> -		mutex_unlock(&tmp_vcpu->mutex);
> -	}
> -
>  	mutex_unlock(&dev->kvm->lock);
>  	return ret;
>  }
> -- 
> 2.9.0
>

Otherwise the refactoring looks good to me.

drew 
