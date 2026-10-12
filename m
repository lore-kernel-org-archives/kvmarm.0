Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E0144AB95
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 08:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791794869; cv=none; b=P4l+bq3kWFqFLbZGZnk4k9fxY6Gs1TxaJ/LEmldyJ3xlpMXy1kyp2PupX03yXsMd5k8URqnMJNkufe7/Ns7/2D3uEn4BSXGHipr1IwrgTP3h+Gy8nESOVNwwxLbUWzXr/0QSkaL2QohyEYs+d6dhk5fcitEVcEwK86hDX/YzTvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791794869; c=relaxed/simple;
	bh=SEZ6etcTUGf9RNiXMMSRKfIgUoYwJmmBOcXlKCaLB1c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XEmpJ/zg+mkOU4BT/vn5/euauRjfmufkIA1ooHp23+Dw7ipoOmGrHO4JYi4NTE3GeRvcEwUIZOD/0plILFzFLgSmGvD977RCEZK6i8hxXAbsvyw83Ehc+/hqKIz0yc3bOr9geMDBSwBKouEuDlXTgPpOnLSaPjyk/2yRKTCC174=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LifUpA1O; arc=none smtp.client-ip=91.218.175.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LifUpA1O"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=SEZ6etcTUGf9RNiXMMSRKfIgUoYwJmmBOcXlKCaLB1c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791794866; v=1; x=1792399666;
 b=LifUpA1OiIiDsoTE2x+/KfBOlpw5lBYJmid7KmgnX26wU7RSeNLTCIwLjTY3ssOWJWLi1PBX
 u35Uy39rnR0B6wIACwpoR99Q/bFmB+dCdWDXXN3/YZ0JoJU+rz0uVM1bm2ch7364Yazc9LiOyeI
 fQdoCSbveYyVF2dbY2DrY7oQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ea7dd119e4327306;
	Mon, 12 Oct 2026 08:47:46 +0000
X-Mizu-Trace-ID: ea7dd119e4327306
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v1] KVM: arm64: vgic-v4: Don't forward an LPI with no target vCPU
Date: Mon, 12 Oct 2026 09:47:43 +0100
Message-Id: <20261012084743.2228612-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM keeps one vgic_irq per LPI. The MAPTI that creates it sets its
target vCPU from that MAPTI's collection, and a later MAPTI of the same
LPI leaves the target alone. Mapping one LPI from two events is
UNPREDICTABLE (IHI 0069H.b, 5.2.10), but nothing stops a guest doing
it. If the first MAPTI names a collection the guest never maps and the
second a mapped one, the LPI translates through the second event with
a NULL target vCPU.

When the VMM routes an assigned device's MSI to that event on a host
with GICv4 enabled, kvm_vgic_v4_set_forwarding() takes the vPE from the
NULL target vCPU and the host oopses:

  Unable to handle kernel paging request at virtual address 0000000000001980
  [...]
  Call trace:
   its_build_vmapti_cmd (drivers/irqchip/irq-gic-v3-its.c:943) (P)
   its_irq_set_vcpu_affinity (drivers/irqchip/irq-gic-v3-its.c:1380)
   irq_set_vcpu_affinity (kernel/irq/manage.c:670)
   its_map_vlpi (drivers/irqchip/irq-gic-v4.c:326)
   kvm_vgic_v4_set_forwarding (arch/arm64/kvm/vgic/vgic-v4.c:485)
   kvm_arch_irq_bypass_add_producer (arch/arm64/kvm/arm.c:2977)
   irq_bypass_register_consumer (virt/lib/irqbypass.c:44)
   kvm_irqfd (arch/arm64/kvm/../../../virt/kvm/eventfd.c:496)
   kvm_vm_ioctl (arch/arm64/kvm/../../../virt/kvm/kvm_main.c:5270)

Leave such an LPI to the software path, which copes with a NULL target,
as kvm_vgic_v4_set_forwarding() already does when the MSI doesn't
translate.

Fixes: 196b136498b35 ("KVM: arm/arm64: GICv4: Wire mapping/unmapping of VLPIs in VFIO irq bypass")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
Tested on QEMU, which emulates the GICv4 ITS, with a local reproducer
that sets up the two MAPTIs and forwards a vfio-pci MSI to the LPI. It
oopses without the fix and passes with it. Not tested on GICv4 hardware.

Based on v7.3-rc3.

 arch/arm64/kvm/vgic/vgic-v4.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ed236f083f0d7..545e55317c863 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -466,6 +466,13 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	if (irq->hw)
 		goto out_unlock_irq;
 
+	/*
+	 * Silently exit if the LPI has no target vCPU, as one mapped by
+	 * multiple ITEs (UNPREDICTABLE) can have.
+	 */
+	if (!irq->target_vcpu)
+		goto out_unlock_irq;
+
 	/*
 	 * Emit the mapping request. If it fails, the ITS probably
 	 * isn't v4 compatible, so let's silently bail out. Holding

base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

