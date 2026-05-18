Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEC53A1A55
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 05:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779082140; cv=none; b=pIsx3RGUAJW2KsrIgtkSBBeVAYxV/ezAw9BVngmlE+3FB4Z40jrkXwNvMgx/orfEzpekhhQFhuXwWtlYG3Y4EOivucUBwv5nvsdF8CtS97e6WYNlkeptnksQGujeQ9cPLBTm7luZLT8HlDesWTUqFJMS6dKTzJzH5qmne5ucWCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779082140; c=relaxed/simple;
	bh=FK2K66MCI7resBsXnsOn2I85kP9MbXda+1D4Mx3OmQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KbkYgTpfMmV+q1DH8dcs/uM++xPF3L9D0Qix7/DK3/UrNVFUadZjaYGLSdQrGsL1Lzw7eogGFB5ieV6p8Sq91PBEu6au3Jj5gkHSwDRcQf+eKc1ukPaCHrLBXU5yZtVUGwTw50x34KTv4j3i7+mzg0upLVc2hHTzkylhAEFOFgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KnQsjtxH; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KnQsjtxH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779082130; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=Yi0yqBmj4Fj5pS8XdrreLBwJA8eRheXQa5NGK+5zq7M=;
	b=KnQsjtxH282HsluHszysBYdpGHXO/FHD7J0k59/4V4l4ubTfX+MFJ7eSTsU3mV+TWzQW8sj9KHvSC0Hbz+ZFGWdZun2sl5qo7fGDRSYhE3wNQt4FMYamgGhSDBKlGURb0V/n6L8MHlb2dXml+kGL5rRHkHL/5L/7fEKQdxTCt3o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X33jdht_1779082129;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X33jdht_1779082129 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 13:28:49 +0800
Date: Mon, 18 May 2026 13:28:48 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic: free private_irqs when init fails
 after allocation
Message-ID: <rkjsbismtxb6lijsju7o3udrltqfmydafybfvngodf3rsigg3f@hahisxrsjc4x>
References: <20260517181331.367676-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517181331.367676-1-michael.bommarito@gmail.com>

On Sun, May 17, 2026 at 02:13:31PM +0800, Michael Bommarito wrote:
> Companion to commit 250f25367b58 ("KVM: arm64: Tear down vGIC on failed
> vCPU creation"), which added the missing kvm_vgic_vcpu_destroy() call
> to the kvm_share_hyp() failure path in kvm_arch_vcpu_create().  The
> kvm_vgic_vcpu_init() failure path immediately above it has the same
> shape and still needs the same cleanup.
>
> If kvm_vgic_vcpu_init() allocates per-vCPU private IRQs via
> vgic_allocate_private_irqs_locked() and then vgic_register_redist_iodev()
> fails (for example when kvm_io_bus_register_dev() runs out of MMIO-bus
> slots, or vgic_v3_check_base() rejects the configuration), the function
> returns the error without freeing the private-IRQ allocation.
>
> The caller kvm_arch_vcpu_create() returns this error directly, and
> kvm_vm_ioctl_create_vcpu() jumps to vcpu_free_run_page on
> kvm_arch_vcpu_create() failure, which does not invoke
> kvm_arch_vcpu_destroy().  The vCPU struct is then released via
> kmem_cache_free(kvm_vcpu_cache, ...), dropping the only reference to
> the leaked allocation.
>
> The comment block above __kvm_vgic_vcpu_destroy() explicitly anticipates
> this case ("vCPUs that failed creation are torn down outside of the
> kvm->arch.config_lock ... it is both safe and necessary to do so
> here"), but the caller never actually invokes the destroy primitive on
> the kvm_vgic_vcpu_init() error path.  Call it now, mirroring the shape
> of the kvm_share_hyp() cleanup added by 250f25367b58.
>
> Per-failure leak is VGIC_NR_PRIVATE_IRQS * sizeof(struct vgic_irq),
> roughly 3.8 KiB rounded up to 4 KiB by the kmalloc-cg-4k slab.  On
> systems whose /dev/kvm policy lets unprivileged users open the device
> this is reachable to any local user; reach is policy-dependent and
> varies by distro and packager.
>
> Confirmed with kmemleak on v7.1-rc1+: 50 failed KVM_CREATE_VCPU
> attempts (run with the per-VM MMIO bus pre-filled to NR_IOBUS_DEVS so
> vgic_register_redist_iodev() returns -ENOSPC) leave 49 unreferenced
> 4096-byte blocks whose allocation backtrace is
>
>   __kmalloc_noprof+0x390/0x4d0
>   vgic_allocate_private_irqs_locked+0x68/0x1c8
>   kvm_vgic_vcpu_init+0x78/0xd8
>
> With this patch applied to the same tree, kmemleak reports zero
> unreferenced objects under the identical workload.
>
> Cc: stable@vger.kernel.org
> Cc: Will Deacon <will@kernel.org>
> Assisted-by: Claude:claude-opus-4-7
>
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> ---
>  arch/arm64/kvm/arm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 176cbe8baad30..5d5e2f81b9c94 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -554,8 +554,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	kvm_destroy_mpidr_data(vcpu->kvm);
>
>  	err = kvm_vgic_vcpu_init(vcpu);
Hi Michael,
> -	if (err)
> +	if (err) {
> +		kvm_vgic_vcpu_destroy(vcpu);

This LGTM.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  		return err;
> +	}
>
>  	err = kvm_share_hyp(vcpu, vcpu + 1);
>  	if (err)
> --
> 2.53.0
>
