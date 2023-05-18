Received: from out-15.mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2698B3D380
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 18:21:33 +0000 (UTC)
Date: Thu, 18 May 2023 18:21:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684434091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5OYmB43hcujhd+POPB99B3MkQxF2RjuMgAQ0zzAvw74=;
	b=rNNLBOGPh+RDYucfDHtSlhrZocBRV6IZfjmpnzMOyezzIoVhDUzmgW2O6M8IRzws3/Yz6N
	R/wSIYEkCyaCLXCN+TUB9Umz9I1zH1sFYUEEul48zzN0UnS2JItQ7m/5+yERvdHzdVYacT
	JKlgwxqV8liZJPSqXzx44PtPt4pZhSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Fix a circular locking issue
Message-ID: <ZGZsqNZXsq+a+eFA@linux.dev>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
 <20230518100914.2837292-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518100914.2837292-2-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Thu, May 18, 2023 at 11:09:15AM +0100, Jean-Philippe Brucker wrote:
> Lockdep reports a circular lock dependency between the srcu and the
> config_lock:
> 
> [  262.179917] -> #1 (&kvm->srcu){.+.+}-{0:0}:
> [  262.182010]        __synchronize_srcu+0xb0/0x224
> [  262.183422]        synchronize_srcu_expedited+0x24/0x34
> [  262.184554]        kvm_io_bus_register_dev+0x324/0x50c
> [  262.185650]        vgic_register_redist_iodev+0x254/0x398
> [  262.186740]        vgic_v3_set_redist_base+0x3b0/0x724
> [  262.188087]        kvm_vgic_addr+0x364/0x600
> [  262.189189]        vgic_set_common_attr+0x90/0x544
> [  262.190278]        vgic_v3_set_attr+0x74/0x9c
> [  262.191432]        kvm_device_ioctl+0x2a0/0x4e4
> [  262.192515]        __arm64_sys_ioctl+0x7ac/0x1ba8
> [  262.193612]        invoke_syscall.constprop.0+0x70/0x1e0
> [  262.195006]        do_el0_svc+0xe4/0x2d4
> [  262.195929]        el0_svc+0x44/0x8c
> [  262.196917]        el0t_64_sync_handler+0xf4/0x120
> [  262.198238]        el0t_64_sync+0x190/0x194
> [  262.199224]
> [  262.199224] -> #0 (&kvm->arch.config_lock){+.+.}-{3:3}:
> [  262.201094]        __lock_acquire+0x2b70/0x626c
> [  262.202245]        lock_acquire+0x454/0x778
> [  262.203132]        __mutex_lock+0x190/0x8b4
> [  262.204023]        mutex_lock_nested+0x24/0x30
> [  262.205100]        vgic_mmio_write_v3_misc+0x5c/0x2a0
> [  262.206178]        dispatch_mmio_write+0xd8/0x258
> [  262.207498]        __kvm_io_bus_write+0x1e0/0x350
> [  262.208582]        kvm_io_bus_write+0xe0/0x1cc
> [  262.209653]        io_mem_abort+0x2ac/0x6d8
> [  262.210569]        kvm_handle_guest_abort+0x9b8/0x1f88
> [  262.211937]        handle_exit+0xc4/0x39c
> [  262.212971]        kvm_arch_vcpu_ioctl_run+0x90c/0x1c04
> [  262.214154]        kvm_vcpu_ioctl+0x450/0x12f8
> [  262.215233]        __arm64_sys_ioctl+0x7ac/0x1ba8
> [  262.216402]        invoke_syscall.constprop.0+0x70/0x1e0
> [  262.217774]        do_el0_svc+0xe4/0x2d4
> [  262.218758]        el0_svc+0x44/0x8c
> [  262.219941]        el0t_64_sync_handler+0xf4/0x120
> [  262.221110]        el0t_64_sync+0x190/0x194
> 
> Note that the current report, which can be triggered by the vgic_irq
> kselftest, is a triple chain that includes slots_lock, but after
> inverting the slots_lock/config_lock dependency, the actual problem
> reported above remains.
> 
> In several places, the vgic code calls kvm_io_bus_register_dev(), which
> synchronizes the srcu, while holding config_lock (#1). And the MMIO
> handler takes the config_lock while holding the srcu read lock (#0).
> 
> Break dependency #1, by registering the distributor and redistributors
> without holding config_lock. The ITS also uses kvm_io_bus_register_dev()
> but already relies on slots_lock to serialize calls.
> 
> The distributor iodev is created on the first KVM_RUN call. Multiple
> threads will race for vgic initialization, and only the first one will
> see !vgic_ready() under the lock. To serialize those threads, rely on
> slots_lock rather than config_lock.
> 
> Redistributors are created earlier, through KVM_DEV_ARM_VGIC_GRP_ADDR
> ioctls and vCPU creation. Similarly, serialize the iodev creation with
> slots_lock, and the rest with config_lock.
> 
> Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Marc, can you squash this in when you apply the series? Get a compiler
warning since 'ret' is now unused.

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index ce3d17463c6b..ff558c05e990 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1096,7 +1096,6 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type type)
 {
 	struct vgic_io_device *io_device = &kvm->arch.vgic.dist_iodev;
-	int ret = 0;
 	unsigned int len;
 
 	switch (type) {

-- 
Thanks,
Oliver
