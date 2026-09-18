Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED79B3A5453
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 08:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720425; cv=none; b=iib6rIlyUVswAOTSBC5fUAPilc0I+6vP7G63Drzn5tgnmaLGzuB9z6BjQg6TsAyQyjaiN0bDANJrAJv0A3kEZK3CiMVRH1svLfWxO2mg8JN3YSeJYID6A/ptEw722gzcL9hUgBaJlDOpokky+Olr4nDp4xPLsgfjFX7KyDn4wQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720425; c=relaxed/simple;
	bh=T9YKqTTutWagLABWP+gtWS4ig4+Bau4DVZs3YOch0v4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FvW7zuyg4Av7UDoQr7Ylu4I1qsUSuarX6XncGmZHETZ3g5lU+OHNHz3DIBwliGxS8DKS+fUu2KfIAx6xNdmUm4V0gUQp0DqRG7gIzDwIvCqmrnMPyQ6fFn0gVrWB+1s3pX/X4dKfZJ/ASxl+4JN9/s4QN21MXmr2fuoU538f+bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzFa9P2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzFa9P2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884541F000FF;
	Fri, 18 Sep 2026 08:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789720423;
	bh=97h56jdCHBhjTkM/7B7CO6yARgE5mfyDITnUZWWvhrc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FzFa9P2FKOeDefsp14U4JOhvdRENNdPkkdhenMc092mBaJEQH9ox5d5jGEogA4GQP
	 1GpVpRbkm5JuNwhpa1LRgDTKZmvgrfyHQuBCpnPQyRsLEeHqm/AGqlehhBdmPySiAC
	 pDWn0yHNUGcSTvn1AVuWLuOQaoo8iGFlEImFAmV7G536UcbxnjoOIKvVWvuGk5ch5k
	 FI5BtHZEmuX7RhSw2dUW2b1DbgWMS0l0DNEsDhw4QhicBTMqZcbVWcGqEKhUthF+L5
	 EPHdNnWVY5vRgVO87SA4p8CB1WMI6x1vWuMzoRnbXxqeiI6fCCvhRNI9sJ+xb1BQRo
	 pZxFioZr7HKdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Add VGIC v3 batch register access
 implementation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yize Wang" <wangyize7@huawei.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260918081930.4014735-3-wangyize7@huawei.com>
References: <20260918081930.4014735-1-wangyize7@huawei.com>
 <20260918081930.4014735-3-wangyize7@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 08:33:43 +0000
Message-Id: <20260918083343.884541F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] kvm: arm64: vgic: allow userspace to bypass VGIC locks via KVM=
_DEV_ARM_VGIC_ATTR_FLAG_LOCKED
- [High] kvm: arm64: vgic: user memory access under VM locks in batch acces=
s enables deadlock
- [Medium] kvm: arm64: vgic: un-ratelimited pr_err in batch access allows u=
serspace log flooding
- [Medium] kvm: arm64: vgic: batch access fails to return first error or co=
py results to userspace
--

commit 4bb3fc1e279eb19b2c3ca453e47c56bcab743a11
Author: Yize Wang <wangyize7@huawei.com>

KVM: arm64: Add VGIC v3 batch register access implementation

This commit adds vgic_v3_batch_access() to allow userspace to read or write
multiple VGIC registers in a single system call. It introduces a new flag
KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED to prevent repeated locking and unlocking
during these batch accesses.

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -566,14 +566,21 @@ static int vgic_v3_attr_regs_access(struct kvm_devi=
ce *dev,
>  			return -EFAULT;
>  	}
> =20
> -	mutex_lock(&dev->kvm->lock);
> +	/* If the caller has not indicated that it already holds the necessary =
locks
> +	 * (e.g., via KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED), we must acquire the V=
M lock
> +	 * and pause all VCPUs to ensure consistent access to VGIC state. This =
prevents
> +	 * race conditions with concurrent interrupt injection or VCPU executio=
n.
> +	 */
> +	if (attr->flags !=3D KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED) {
> +		mutex_lock(&dev->kvm->lock);

[Severity: Critical]
Can userspace bypass the VGIC data structure locks by setting this flag
directly?

If a userspace process invokes KVM_SET_DEVICE_ATTR or KVM_GET_DEVICE_ATTR
with attr->flags explicitly set to KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED,
vgic_v3_attr_regs_access() will skip acquiring kvm->lock,
kvm->arch.config_lock, and all VCPU mutexes.

Could this allow concurrent modifications to internal VGIC state, leading
to race conditions or use-after-free regressions?

[ ... ]

> +/* vgic_v3_batch_access - Batch access to VGIC registers
> + *
> + * @dev: The VGIC device
> + * @attr: The device attribute containing the batch entries
> + * @is_write: True for write, false for read
> + *
> + * This function allows userspace to read or write multiple VGIC registe=
rs
> + * in a single system call, reducing overhead during live migration.
> + *
> + * Returns: 0 on success, or the first error encountered.
> + * Individual entry errors are stored in entries[i].error.
> + */
> +static int vgic_v3_batch_access(struct kvm_device *dev,
> +				struct kvm_device_attr *attr, bool is_write)
> +{
[ ... ]
> +	mutex_lock(&dev->kvm->lock);
> +	if (kvm_trylock_all_vcpus(dev->kvm)) {
> +		mutex_unlock(&dev->kvm->lock);
> +		kvfree(entries);
> +		return -EBUSY;
> +	}
> +	mutex_lock(&dev->kvm->arch.config_lock);
> +
> +	/* Process each entry in the batch */
> +	for (i =3D 0; i < count; i++) {
> +		int err;
> +
> +		sub_attr.group =3D entries[i].group;
> +		sub_attr.attr =3D entries[i].attr;
> +		sub_attr.addr =3D (unsigned long)uentries +
> +			i * sizeof(struct kvm_dev_arm_vgic_batch_entry) +
> +			offsetof(struct kvm_dev_arm_vgic_batch_entry, val);
> +
> +		/* Set flag to indicate that locks are already held.
> +		 * This prevents vgic_v3_attr_regs_access from acquiring locks again,
> +		 * avoiding deadlock and overhead.
> +		 */
> +		sub_attr.flags =3D KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED;
> +
> +		err =3D vgic_v3_attr_regs_access(dev, &sub_attr, is_write);

[Severity: High]
Does executing a user memory access while holding VM locks introduce a
deadlock regression?

Here sub_attr.addr is assigned a userspace address (uentries), which is
then passed into vgic_v3_attr_regs_access(). Inside
vgic_v3_attr_regs_access(), this address is accessed using put_user()
or get_user():

    if (!ret && uaccess && !is_write) {
        u32 __user *uaddr =3D (u32 __user *)(unsigned long)attr->addr;
        ret =3D put_user(val, uaddr);
    }

Since the batch caller holds kvm->lock, kvm->arch.config_lock, and all
vcpu->mutexes, could an untrusted userspace process point uentries to
userfaultfd-managed memory and intentionally stall the page fault? This
would keep all global VM and VCPU locks held indefinitely, hanging the VM.

> +
> +		if (err) {
> +			pr_err("group %d attr %lld get err %d\n",
> +				sub_attr.group, sub_attr.attr, err);

[Severity: Medium]
Is there a risk of userspace flooding the host kernel log buffer here?

This is an unconditional pr_err() driven by user-supplied inputs. Since
there is no rate limiting and the loop does not abort on error, a batch of
up to 4096 invalid VGIC attribute entries could spam dmesg and degrade
host performance.

> +			ret =3D err;
> +		}
> +	}
> +
> +	mutex_unlock(&dev->kvm->arch.config_lock);
> +	kvm_unlock_all_vcpus(dev->kvm);
> +	mutex_unlock(&dev->kvm->lock);
> +
> +	kvfree(entries);
> +	return ret;
> +}

[Severity: Medium]
Does this code fail to return the first error or copy the results back to
userspace?

The function header indicates it should return the first error and store
individual errors in entries[i].error. However, the loop overwrites ret
with the most recent error instead of returning immediately.

Furthermore, the entries array is freed here without being copied back to
user memory, meaning userspace has no way to determine which register
access actually failed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918081930.4014=
735-1-wangyize7@huawei.com?part=3D2
