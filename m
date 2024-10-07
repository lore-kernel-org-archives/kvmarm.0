Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E47618DF96
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728340764; cv=none; b=YtEn8Sf7b3scPq26iLQ0CGUcqU7F76anN+cYX+AKbGn2X3dZSqjWCjqmSAs52xitHJg2Rm4vql5ReBI33RGEoVE8dtH3TtEzL8kUgtE4w8NL6pjjVJ9CcKdsJdXnhicODChfIuynNHDpgxTMATlymcHvB95gj2qrBP23BC/qpD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728340764; c=relaxed/simple;
	bh=RgJCYdMYLPTDVb4bwceiaJIeBPbZ4Kb9CfWyytVc1Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sAkXlUI9fWkwkUXpiZ9AfrtpgZ/SyK3FH1zOSaUi1ZOSrz3QcLsIDRyEWXeTbBKOtY4jr8zdzfvIpv8MAqSPSwBhoiw/Uz8cqvAYgnCcIaIEXKXtwjP89v6zilwXdDhTTNh1y9s6xoSZZ10HnP2De3+RVN+cpvHnUt0TAllYRqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J1QyvKSC; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J1QyvKSC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728340759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fOYzIP/IiUF6enYhvf2NXdMbpcmvnkI+ke0RQYJOp5o=;
	b=J1QyvKSC0kB/FhrFKdFXKxLJFSe6wSgbALCbLvybpzRR3P098Q9DqvS+1ZUDZyA5GOZNnu
	HkeJC7vnaYb4JTt0JrYpWioWgC/vyzkWmqMaL+dors3TnEWrUYiaw7wBlYYXYmv1IKxiH2
	0h7QOO+jxoXczyQRCaeD4LinS1pN+Ww=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH] KVM: arm64: Unregister redistributor for failed vCPU creation
Date: Mon,  7 Oct 2024 22:39:09 +0000
Message-ID: <20241007223909.2157336-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Alex reports that syzkaller has managed to trigger a use-after-free when
tearing down a VM:

  BUG: KASAN: slab-use-after-free in kvm_put_kvm+0x300/0xe68 virt/kvm/kvm_main.c:5769
  Read of size 8 at addr ffffff801c6890d0 by task syz.3.2219/10758

  CPU: 3 UID: 0 PID: 10758 Comm: syz.3.2219 Not tainted 6.11.0-rc6-dirty #64
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   dump_backtrace+0x17c/0x1a8 arch/arm64/kernel/stacktrace.c:317
   show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
   __dump_stack lib/dump_stack.c:93 [inline]
   dump_stack_lvl+0x94/0xc0 lib/dump_stack.c:119
   print_report+0x144/0x7a4 mm/kasan/report.c:377
   kasan_report+0xcc/0x128 mm/kasan/report.c:601
   __asan_report_load8_noabort+0x20/0x2c mm/kasan/report_generic.c:381
   kvm_put_kvm+0x300/0xe68 virt/kvm/kvm_main.c:5769
   kvm_vm_release+0x4c/0x60 virt/kvm/kvm_main.c:1409
   __fput+0x198/0x71c fs/file_table.c:422
   ____fput+0x20/0x30 fs/file_table.c:450
   task_work_run+0x1cc/0x23c kernel/task_work.c:228
   do_notify_resume+0x144/0x1a0 include/linux/resume_user_mode.h:50
   el0_svc+0x64/0x68 arch/arm64/kernel/entry-common.c:169
   el0t_64_sync_handler+0x90/0xfc arch/arm64/kernel/entry-common.c:730
   el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

Upon closer inspection, it appears that we do not properly tear down the
MMIO registration for a vCPU that fails creation late in the game, e.g.
a vCPU w/ the same ID already exists in the VM.

It is important to consider the context of commit that introduced this bug
by moving the unregistration out of __kvm_vgic_vcpu_destroy(). That
change correctly sought to avoid an srcu v. config_lock inversion by
breaking up the vCPU teardown into two parts, one guarded by the
config_lock.

Fix the use-after-free while avoiding lock inversion by adding a
special-cased unregistration to __kvm_vgic_vcpu_destroy(). This is safe
because failed vCPUs are torn down outside of the config_lock.

Cc: stable@vger.kernel.org
Fixes: f616506754d3 ("KVM: arm64: vgic: Don't hold config_lock while unregistering redistributors")
Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index e7c53e8af3d1..57aedf7b2b76 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -417,8 +417,28 @@ static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kfree(vgic_cpu->private_irqs);
 	vgic_cpu->private_irqs = NULL;
 
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		/*
+		 * If this vCPU is being destroyed because of a failed creation
+		 * then unregister the redistributor to avoid leaving behind a
+		 * dangling pointer to the vCPU struct.
+		 *
+		 * vCPUs that have been successfully created (i.e. added to
+		 * kvm->vcpu_array) get unregistered in kvm_vgic_destroy(), as
+		 * this function gets called while holding kvm->arch.config_lock
+		 * in the VM teardown path and would otherwise introduce a lock
+		 * inversion w.r.t. kvm->srcu.
+		 *
+		 * vCPUs that failed creation are torn down outside of the
+		 * kvm->arch.config_lock and do not get unregistered in
+		 * kvm_vgic_destroy(), meaning it is both safe and necessary to
+		 * do so here.
+		 */
+		if (kvm_get_vcpu_by_id(vcpu->kvm, vcpu->vcpu_id) != vcpu)
+			vgic_unregister_redist_iodev(vcpu);
+
 		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	}
 }
 
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.47.0.rc0.187.ge670bccf7e-goog

