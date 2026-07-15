Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685FB38A711;
	Wed, 15 Jul 2026 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125815; cv=none; b=eGtnV4uLnw8A+FbiQe75298Qb+PFUQ6MZ1HwaDIXl5faY8OUMHLq8WsUVYbTsYOPLD4yDNmDaNgop8nQ4bjjZS6loceVbdIa+OswvgpAe12EuOv9vKje/CONxXiifuj1Kgk27yy8WsaqRByeA/DGSBK6oKzAuWdCApXk4w9yI+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125815; c=relaxed/simple;
	bh=GmiIXYY2KDIHLf9GKLUGeavkGI3LBc/BAUOdJieuNSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGuqJe4C2ec8NDga4ea6dMEd2IEoKiVXiM8uUqV/fXOO05/cnNuohzsUirgjCqqHp2DKKozSA8TCfi5pV6+2XQcOGGBcq6DV2lSKF5Av9fn61VWvLfx0pkrJ3eKcxEtuXUizuDA0a+P0W+rXfoQIFVeYLgztRm5e8++cunXv0xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ej9Nt0Au; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ej9Nt0Au"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B94B1153B;
	Wed, 15 Jul 2026 07:30:08 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9C253F7B4;
	Wed, 15 Jul 2026 07:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125813; bh=GmiIXYY2KDIHLf9GKLUGeavkGI3LBc/BAUOdJieuNSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ej9Nt0Au/MgcpK06xGTjv5/RznheqR5PCD/iE70xUs9CPUboo6NoA63FtHm5cs7xx
	 VvFh2MyC0b1q7E9/kJD9Ppbq78uG2Uhv4y+b04/GiMxUAcaASgK7oYQh8H1MDLUV76
	 IrNK7nmtP4apC8ruVA1E3Ox75in3Fk190f71maCo=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v15 16/37] KVM: arm64: CCA: Handle realm MMIO emulation
Date: Wed, 15 Jul 2026 15:28:18 +0100
Message-ID: <20260715142841.80544-17-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142841.80544-1-steven.price@arm.com>
References: <20260715142841.80544-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MMIO emulation for a realm cannot be done directly with the VM's
registers as they are protected from the host. However, for emulatable
data aborts, the RMM uses GPRS[0] to provide the read/written value.
We can transfer this from/to the equivalent VCPU's register entry and
then depend on the generic MMIO handling code in KVM.

For a MMIO read, the value is placed in the shared RecExit structure
during kvm_handle_mmio_return() rather than in the VCPU's register
entry.

Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v7:
 * New comment for rec_exit_sync_dabt() explaining the call to
   vcpu_set_reg().
Changes since v5:
 * Inject SEA to the guest is an emulatable MMIO access triggers a data
   abort.
 * kvm_handle_mmio_return() - disable kvm_incr_pc() for a REC (as the PC
   isn't under the host's control) and move the REC_ENTER_EMULATED_MMIO
   flag setting to this location (as that tells the RMM to skip the
   instruction).
---
 arch/arm64/kvm/inject_fault.c |  4 +++-
 arch/arm64/kvm/mmio.c         | 16 ++++++++++++----
 arch/arm64/kvm/rmi-exit.c     | 15 +++++++++++++++
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 89982bd3345f..6492397b73d7 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -228,7 +228,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
 
 static void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 {
-	if (vcpu_el1_is_32bit(vcpu))
+	if (unlikely(vcpu_is_rec(vcpu)))
+		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
+	else if (vcpu_el1_is_32bit(vcpu))
 		inject_abt32(vcpu, iabt, addr);
 	else
 		inject_abt64(vcpu, iabt, addr);
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index e2285ed8c91d..a8c125205695 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <linux/arm-smccc-rmi.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
@@ -138,14 +139,21 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
 			       &data);
 		data = vcpu_data_host_to_guest(vcpu, data, len);
-		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
+
+		if (vcpu_is_rec(vcpu))
+			vcpu->arch.rec.run->enter.gprs[0] = data;
+		else
+			vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
 	}
 
 	/*
 	 * The MMIO instruction is emulated and should not be re-executed
 	 * in the guest.
 	 */
-	kvm_incr_pc(vcpu);
+	if (vcpu_is_rec(vcpu))
+		vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_EMULATED_MMIO;
+	else
+		kvm_incr_pc(vcpu);
 
 	return 1;
 }
@@ -167,14 +175,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	 * No valid syndrome? Ask userspace for help if it has
 	 * volunteered to do so, and bail out otherwise.
 	 *
-	 * In the protected VM case, there isn't much userspace can do
+	 * In the protected/realm VM case, there isn't much userspace can do
 	 * though, so directly deliver an exception to the guest.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
 		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), esr,
 				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
-		if (vcpu_is_protected(vcpu))
+		if (vcpu_is_protected(vcpu) || vcpu_is_rec(vcpu))
 			return kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
index 973250563d7b..c668cbfa971a 100644
--- a/arch/arm64/kvm/rmi-exit.c
+++ b/arch/arm64/kvm/rmi-exit.c
@@ -23,6 +23,21 @@ static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
 
 static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
 {
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	/*
+	 * In the case of a write, copy over gprs[0] to the target GPR,
+	 * preparing to handle MMIO write fault. The content to be written has
+	 * been saved to gprs[0] by the RMM (even if another register was used
+	 * by the guest). In the case of normal memory access this is redundant
+	 * (the guest will replay the instruction), but the overhead is
+	 * minimal.
+	 */
+	if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu)) {
+		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
+			     rec->run->exit.gprs[0]);
+	}
+
 	return kvm_handle_guest_abort(vcpu);
 }
 
-- 
2.43.0

