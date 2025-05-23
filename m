Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CF07E1
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 19:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748029665; cv=none; b=Cx1GcDQK1fcNzTWMFx6jinsbAegpnXeu3oCE2sua4SiDep2DLaFVyxNIen7UbRTteH/o9V0eVWghGLaFDV+FTWf9ydhYkePi1Y2USUnZxBIz88KtubiOzqePCDQzZQbDr6C+77Em9JZTWFd2SXATvJ9NsxEo7AKWG7Y5oP5HO7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748029665; c=relaxed/simple;
	bh=4ipXB5M6idw62//r/n1O6zui6ivVAPQInsu/IkBbXhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EH/jP5jBobIRMfwybsXtLqRp5ofWnxtO4drKq8owdJCfrjhBeUjQHK4sDNfyOFGAw/hTqaQ3li2LZmYt5LaDgER/XxtC7dndImwPnT7wVcYd2MxvDAgCBk69XXtxtCUwxuY+zSDVGJQD+LWX8t4kw9mgXpbB85l8fUU9o/8gb5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rzEAmXDt; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rzEAmXDt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748029660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bN16+M7jk7c5xmAYUKwZFG/+5KXfGFeKYxfftQtgkic=;
	b=rzEAmXDtP4MRKUGzvWNdzDqTeuXRlUk6X9UehpUyLhEtK7OZQL49KryjEzbDu/ZrJ4gyiV
	QUPiSuQJQwpbiglE10eKVCNhB5SYwgrFvhcvjlSmLqh2GF+raeP3m1E2yAAW8HBFWuyF+z
	YDBSAVt+bAltsWGmiwq5BUyG2qH5Hv0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 5/5] KVM: arm64: vgic-init: Plug vCPU vs. VGIC creation race
Date: Fri, 23 May 2025 12:47:22 -0700
Message-Id: <20250523194722.4066715-6-oliver.upton@linux.dev>
In-Reply-To: <20250523194722.4066715-1-oliver.upton@linux.dev>
References: <20250523194722.4066715-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

syzkaller has found another ugly race in the VGIC, this time dealing
with VGIC creation. Since kvm_vgic_create() doesn't sufficiently protect
against in-flight vCPU creations, it is possible to get a vCPU into the
kernel w/ an in-kernel VGIC but no allocation of private IRQs:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000d20
  Mem abort info:
    ESR = 0x0000000096000046
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x06: level 2 translation fault
  Data abort info:
    ISV = 0, ISS = 0x00000046, ISS2 = 0x00000000
    CM = 0, WnR = 1, TnD = 0, TagAccess = 0
    GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  user pgtable: 4k pages, 48-bit VAs, pgdp=0000000103e4f000
  [0000000000000d20] pgd=0800000102e1c403, p4d=0800000102e1c403, pud=0800000101146403, pmd=0000000000000000
  Internal error: Oops: 0000000096000046 [#1] PREEMPT SMP
  CPU: 9 UID: 0 PID: 246 Comm: test Not tainted 6.14.0-rc6-00097-g0c90821f5db8 #16
  Hardware name: linux,dummy-virt (DT)
  pstate: 814020c5 (Nzcv daIF +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : _raw_spin_lock_irqsave+0x34/0x8c
  lr : kvm_vgic_set_owner+0x54/0xa4
  sp : ffff80008086ba20
  x29: ffff80008086ba20 x28: ffff0000c19b5640 x27: 0000000000000000
  x26: 0000000000000000 x25: ffff0000c4879bd0 x24: 000000000000001e
  x23: 0000000000000000 x22: 0000000000000000 x21: ffff0000c487af80
  x20: ffff0000c487af18 x19: 0000000000000000 x18: 0000001afadd5a8b
  x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000001
  x14: ffff0000c19b56c0 x13: 0030c9adf9d9889e x12: ffffc263710e1908
  x11: 0000001afb0d74f2 x10: e0966b840b373664 x9 : ec806bf7d6a57cd5
  x8 : ffff80008086b980 x7 : 0000000000000001 x6 : 0000000000000001
  x5 : 0000000080800054 x4 : 4ec4ec4ec4ec4ec5 x3 : 0000000000000000
  x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000d20
  Call trace:
   _raw_spin_lock_irqsave+0x34/0x8c (P)
   kvm_vgic_set_owner+0x54/0xa4
   kvm_timer_enable+0xf4/0x274
   kvm_arch_vcpu_run_pid_change+0xe0/0x380
   kvm_vcpu_ioctl+0x93c/0x9e0
   __arm64_sys_ioctl+0xb4/0xec
   invoke_syscall+0x48/0x110
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x30/0xd0
   el0t_64_sync_handler+0x10c/0x138
   el0t_64_sync+0x198/0x19c
   Code: b9000841 d503201f 52800001 52800022 (88e17c02)
   ---[ end trace 0000000000000000 ]---

Plug the race by explicitly checking for an in-progress vCPU creation
and failing kvm_vgic_create() when that's the case. Add some comments to
document all the things kvm_vgic_create() is trying to guard against
too.

Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1f33e71c2a73..0611a1c2ce8e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -84,15 +84,40 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		!kvm_vgic_global_state.can_emulate_gicv2)
 		return -ENODEV;
 
-	/* Must be held to avoid race with vCPU creation */
+	/*
+	 * Ensure mutual exclusion with vCPU creation and any vCPU ioctls by:
+	 *
+	 *  - Holding kvm->lock to prevent KVM_CREATE_VCPU from reaching
+	 *    kvm_arch_vcpu_precreate() and ensuring created_vcpus is stable.
+	 *    This alone is insufficient, as kvm_vm_ioctl_create_vcpu() drops
+	 *    the kvm->lock before completing the vCPU creation.
+	 */
 	lockdep_assert_held(&kvm->lock);
 
+	/*
+	 *  - Acquiring the vCPU mutex for every *online* vCPU to prevent
+	 *    concurrent vCPU ioctls for vCPUs already visible to userspace.
+	 */
 	ret = -EBUSY;
 	if (!lock_all_vcpus(kvm))
 		return ret;
 
+	/*
+	 *  - Taking the config_lock which protects VGIC data structures such
+	 *    as the per-vCPU arrays of private IRQs (SGIs, PPIs).
+	 */
 	mutex_lock(&kvm->arch.config_lock);
 
+	/*
+	 * - Bailing on the entire thing if a vCPU is in the middle of creation,
+	 *   dropped the kvm->lock, but hasn't reached kvm_arch_vcpu_create().
+	 *
+	 * The whole combination of this guarantees that no vCPU can get into
+	 * KVM with a VGIC configuration inconsistent with the VM's VGIC.
+	 */
+	if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus))
+		goto out_unlock;
+
 	if (irqchip_in_kernel(kvm)) {
 		ret = -EEXIST;
 		goto out_unlock;
-- 
2.39.5

