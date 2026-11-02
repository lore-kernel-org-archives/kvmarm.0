Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.29
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624549;
	b=4n/lV7zydQCO7kYckkAeVnDeBWf+nYCH+68sGc1zT6tociOGQrNiCW1GIYvHL3ePsWap
	 CJxweCwuaJWgl3LTfFfw6PcrE53hOgGLrXnvYWlREZdP6mQWPS0bu+fTE8DERaxFeFkof
	 ZLIzM9Ie41xVcrgEKBlKfZ1DGncJ7R3r7B1xCVGr4nGAsFHEcCjb3sRW3THcjuWa4aoiX
	 7BmUBH9XpyDHTUFdwNIkpW3gDD35tQYS5OJzNaTxEhpj9hRHcwGnSbXemnQcgTT7subrG
	 a0M4VZcvyT2vosR0eqZYGFDKXQJsQkq0g4QxnDC7QqkwPhFxUrLR701EtcU6yhKVyZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624549;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Ob2YpJ6DvqQqtRvmVndUHCxQyv7MOV+OCz3VkeMaY1s=;
	b=0pKLqKWzyEgll8je9tDbfdZeeJTP8Rjz3uR8al8FOI1Qg2RZs5BwIR+zPvPrRpFSQdz2
	 GUjZmPJWFgKj/la+yR/WBTeu4IKT156JBOUsb5+mx0lOmuXWvYppZQXqpu9+VJyeXNjKx
	 E3J/UwgKDyk3MdccBwDAkIvkJ5GyI8BXGt1jbCTlSIa7UjSvV88nZQbgtX/2X/g9kTYMT
	 xP66Nr9+4IrZWtEa/nVmRhAYS5bbOybQl2YC37zVJk4KhQ2ClafQaucoRVQBpNxEpwEdw
	 j/SscSVVmk+s9Yw7ekf3GS2ZPbZQfuNxNgLlimTSdeV3R2FkGSYjqUwzkCZPjdypKEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mwFz1z0b;
	arc=none smtp.remote-ip=91.218.175.29
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6678606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:02:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6678606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mwFz1z0b
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9L3/FXfEuZ3Ty9IWCHK5iCSCvWUfnN955X3I6gW+G5I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624546; v=1; x=1794229346;
 b=mwFz1z0b8bqFOz5IgazJMHclo2vWh+MxT+Wf44+ks6XE3NPJTPkJNMu54k5ialLh+011XjB0
 yWN1FSjt6MutL/fAXXvQqc0QScnn8JRwO0W+qGGjSUHrMKvrtv/afm4GmYpihV4upP9jIVTDxBo
 pHRrQx5wwaa+XTUR2P65vUs4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8990d72a4c340073;
	Mon, 02 Nov 2026 13:02:25 +0000
X-Mizu-Trace-ID: 8990d72a4c340073
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/13] KVM: arm64: Emulate the ITS command queue
Date: Mon,  2 Nov 2026 13:01:29 +0000
Message-ID: <20261102130133.3684226-10-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Ene <sebastianene@google.com>

The ITS writes to the memory its commands point to, so a host that
queues commands freely can aim those writes at the hypervisor or a
protected guest.

Register each ITS's control frame with the hypervisor, which takes
ownership of it at initialisation, so that every host access to it traps
once the host is deprivileged. GITS_TRANSLATER is in the next frame,
which stays host-mapped. Each ITS takes one of the eight region slots,
so KVM doesn't initialise in protected mode with more than eight ITSes.
Inside the stop_machine() callback that deprivileges the host, the
hypervisor reads GITS_CBASER, GITS_CWRITER and GITS_CREADR itself, takes
the queue and pins the driver's copy. If that fails, no CPU is
deprivileged and KVM_CREATE_VM fails with -ENODEV.

On a GITS_CWRITER write, the hypervisor reads each new command once from
the driver's copy of the queue, checks it and copies it into the
hardware queue. A rejected command aborts the host's store, after the
commands before it have been forwarded. For now that's a vLPI command or
an unknown encoding, neither of which the driver queues.

An access without a valid syndrome aborts. Otherwise, reads go to the
hardware. Writes abort, except to GITS_CWRITER, to GITS_BASER<n> until
the next patch, and to GITS_CTLR and GITS_CBASER, which the driver
writes on suspend and resume. A GITS_CBASER write goes through only with
the ITS disabled and quiescent, and the hypervisor writes back the value
it read at setup. An enable aborts unless GITS_CBASER holds that value.
It's dropped rather than aborted while the ITS isn't quiescent (IHI
0069H.b 12.19.4), as the driver writes one from a syscore callback when
a quiesce times out, and an abort there would take the host down.

The takeover takes cpus_read_lock() before the driver's prepare, as
drivers take dev_alloc_lock through the MSI layer with it held.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Co-developed-by: Bartłomiej Grzesik <bgrzesik@google.com>
Signed-off-by: Bartłomiej Grzesik <bgrzesik@google.com>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v2 (v2 patches 04, 06, 10, 11 and 13, merged):
    - The takeover runs in the stop_machine() callback that
      deprivileges the host, while every CPU is still privileged (was
      after the stage-2 install)
    - A failed takeover deprivileges no CPU, and KVM_CREATE_VM then
      returns -ENODEV
    - The hypervisor reads GITS_CBASER, GITS_CWRITER and GITS_CREADR
      itself, rather than taking the host's queue and length
    - Every rejected access aborts, a rejected command once the commands
      before it are forwarded (v2 dropped it and skipped the
      instruction)
    - Commands are forwarded and never rolled back: the completion poll,
      the -EIO/-EBUSY split and the rollback are gone (sashiko)
    - The vLPI commands and unknown encodings are rejected (were
      forwarded)
    - A write to a register the emulation doesn't handle aborts, where
      v2 forwarded it (sashiko)
    - Accesses are decoded by offset and size, where v2's handlers
      ignored the offset within a register (sashiko)
    - A GITS_CBASER write stores the value read at setup, whole, where
      v2 let the host's cacheability and shareability through (sashiko)
    - A GITS_CBASER write while the ITS is enabled or not quiescent
      aborts, and one that goes through resets the hypervisor's side of
      the queue
    - An enable aborts unless GITS_CBASER still holds the value read at
      setup
    - GITS_CWRITER's offset is bounded by the queue size, and a write
      that would overrun GITS_CREADR aborts
    - Every forwarded command is cleaned to PoC, where v2's test for it
      ignored inner cacheability (sashiko)
    - The trap handler, from v2 patch 03, calls the ITS emulation
      directly (was a per-region callback)
    - The written value is masked to the access size, and a read is
      sign-extended per ESR_EL2.SSE and sized per SF (sashiko)
    - The trap path tests num_protected_reg first and no longer calls
      addr_is_memory(), and FAR_TO_FIPA_OFFSET() replaces v2's FAR_MASK
    - KVM registers each ITS from the driver's its_pkvm_iter_its(), at
      KVM init (was a DT walk)

 arch/arm64/include/asm/kvm_asm.h              |   2 +
 arch/arm64/include/asm/kvm_hcall.h            |   2 +
 arch/arm64/include/asm/kvm_pkvm.h             |   4 +
 arch/arm64/kvm/arm.c                          |   4 +
 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h |  16 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   8 +
 arch/arm64/kvm/hyp/nvhe/its_emulate.c         | 311 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  65 ++++
 arch/arm64/kvm/pkvm.c                         |  98 +++++-
 10 files changed, 510 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/its_emulate.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index abda476e023de..339850e2702d0 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -122,6 +122,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_sync_state,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	/* Called with kvm_protected_mode_initialized on, before __pkvm_prot_finalize. */
+	__KVM_HOST_SMCCC_FUNC___pkvm_its_emulate_setup,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
 };
diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index 5f77a8aa29635..0748232c387ec 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -254,5 +254,7 @@ DECLARE_KVM_HOST_HCALL0(void, __pkvm_vcpu_put)
 DECLARE_KVM_HOST_HCALL0(void, __pkvm_vcpu_sync_state)
 DECLARE_KVM_HOST_HCALL(void, __pkvm_tlb_flush_vmid,
 	pkvm_handle_t, handle)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_its_emulate_setup,
+	phys_addr_t, its_base, phys_addr_t, desc_pa, size_t, desc_size)
 
 #endif /* __ARM64_KVM_HCALL_H__ */
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 4695c35b31e1a..e1203b06ec7b3 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -24,11 +24,15 @@ struct pkvm_protected_reg {
 	u64			pfn;
 	u64			nr_pages;
 	void __iomem		*hyp_va;
+	/* The ITS's state once it is taken. */
+	void			*priv;
 };
 
 extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
 extern unsigned int kvm_nvhe_sym(num_protected_reg);
 
+int pkvm_register_its_regions(void);
+
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 157bf4b812020..789f6ca13ae12 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3128,6 +3128,10 @@ static int __init init_hyp_mode(void)
 		if (err)
 			goto out_err;
 
+		err = pkvm_register_its_regions();
+		if (err)
+			goto out_err;
+
 		err = kvm_hyp_init_protection(hyp_va_bits);
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
diff --git a/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h b/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
new file mode 100644
index 0000000000000..0b0d4aa25a5b7
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/its_emulate.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 Google LLC
+ * Author: Sebastian Ene <sebastianene@google.com>
+ */
+#ifndef __ARM64_KVM_NVHE_ITS_EMULATE_H__
+#define __ARM64_KVM_NVHE_ITS_EMULATE_H__
+
+#include <asm/kvm_pkvm.h>
+
+int pkvm_its_emulate_setup(phys_addr_t its_base, phys_addr_t desc_pa,
+			   size_t desc_size);
+bool pkvm_its_emulate_handler(struct pkvm_protected_reg *region, u64 offset,
+			      bool write, u64 *val, u8 size);
+
+#endif /* __ARM64_KVM_NVHE_ITS_EMULATE_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 56a7e2c05f73a..2c50940849782 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o alloc.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
+	 its_emulate.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
 hyp-obj-y += ../../../kernel/smccc-call.o
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 179d7c8277b88..5efaa32037a5b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -22,6 +22,7 @@
 
 #include <nvhe/alloc.h>
 #include <nvhe/ffa.h>
+#include <nvhe/its_emulate.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
@@ -1169,6 +1170,12 @@ DEFINE_KVM_HOST_HCALL(void, __pkvm_tlb_flush_vmid,
 	put_pkvm_hyp_vm(hyp_vm);
 }
 
+DEFINE_KVM_HOST_HCALL(int, __pkvm_its_emulate_setup,
+	phys_addr_t, its_base, phys_addr_t, desc_pa, size_t, desc_size)
+{
+	return pkvm_its_emulate_setup(its_base, desc_pa, desc_size);
+}
+
 DEFINE_KVM_HOST_HCALL(void, __kvm_flush_cpu_context,
 	struct kvm_s2_mmu __kern *, mmu)
 {
@@ -1603,6 +1610,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_vcpu_sync_state),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__pkvm_its_emulate_setup),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
new file mode 100644
index 0000000000000..b0181cb3fe9ba
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Emulation of the host's accesses to a GICv3 ITS in protected KVM.
+ *
+ * Copyright (C) 2026 Google LLC
+ * Author: Sebastian Ene <sebastianene@google.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/io.h>
+#include <linux/irqchip/arm-gic-v3.h>
+
+#include <asm/kvm_pkvm.h>
+
+#include <nvhe/its_emulate.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/memory.h>
+#include <nvhe/spinlock.h>
+
+#define GITS_CWRITER_OFFSET	GENMASK_ULL(19, 5)
+#define GITS_CWRITER_RETRY	BIT_ULL(0)
+#define GITS_CREADR_OFFSET	GENMASK_ULL(19, 5)
+#define GITS_CBASER_SIZE	GENMASK_ULL(7, 0)
+
+/* Per-ITS state, in the pages the host donated at setup. */
+struct its_priv {
+	hyp_spinlock_t		lock;
+	void __iomem		*base;
+	u64			cbaser;
+
+	/* cmdq_hw is hyp-owned; cmdq_copy is the host's copy, pinned. */
+	void			*cmdq_hw;
+	void			*cmdq_copy;
+	u32			cmdq_size;
+
+	/* The next slot to forward, at the offset last written to GITS_CWRITER. */
+	u32			cmd_offset;
+
+	/* The GITS_CREADR offset last read. */
+	u32			hw_creadr;
+};
+
+static int its_pin_host_pages(phys_addr_t pa, u64 nr_pages)
+{
+	void *va = hyp_phys_to_virt(pa);
+	u64 pfn = PHYS_PFN(pa), i;
+	int ret;
+
+	for (i = 0; i < nr_pages; i++) {
+		ret = __pkvm_host_share_hyp(pfn + i);
+		if (ret)
+			return ret;
+	}
+
+	return hyp_pin_shared_mem(va, va + (nr_pages << PAGE_SHIFT));
+}
+
+static bool its_process_cmd(struct its_priv *its, struct its_cmd_block *cmd)
+{
+	switch (its_cmd_get_command(cmd->raw_cmd)) {
+	case GITS_CMD_MAPD:
+	case GITS_CMD_MAPC:
+	case GITS_CMD_MAPTI:
+	case GITS_CMD_MAPI:
+	case GITS_CMD_MOVI:
+	case GITS_CMD_DISCARD:
+	case GITS_CMD_INV:
+	case GITS_CMD_MOVALL:
+	case GITS_CMD_INVALL:
+	case GITS_CMD_INT:
+	case GITS_CMD_CLEAR:
+	case GITS_CMD_SYNC:
+		return true;
+	default:
+		/* The vLPI commands and anything unknown. */
+		return false;
+	}
+}
+
+static u64 its_read_creadr(struct its_priv *its)
+{
+	u64 creadr = readq_relaxed(its->base + GITS_CREADR);
+	u32 offset = creadr & GITS_CREADR_OFFSET;
+
+	its->hw_creadr = offset;
+
+	return creadr;
+}
+
+/* Returns false on a rejected command, after forwarding the ones before it. */
+static bool its_cwriter_write(struct its_priv *its, u64 val)
+{
+	u32 new = val & GITS_CWRITER_OFFSET;
+	struct its_cmd_block cmd;
+	bool rejected = false;
+	unsigned int i;
+	u64 *slot;
+
+	if (new >= its->cmdq_size)
+		return false;
+
+	its_read_creadr(its);
+
+	/* The queue is full 32 bytes behind GITS_CREADR (IHI 0069H.b 5.2.8): reject an overrun. */
+	if ((its->cmd_offset + its->cmdq_size - its->hw_creadr) % its->cmdq_size +
+	    (new + its->cmdq_size - its->cmd_offset) % its->cmdq_size >
+	    its->cmdq_size - sizeof(cmd))
+		return false;
+
+	/*
+	 * A value below cmd_offset wraps around the queue, for the ITS too. The
+	 * driver writes one only as the 0 after a GITS_CBASER write, which has
+	 * already reset cmd_offset to 0.
+	 */
+	while (its->cmd_offset != new) {
+		/* The host can change its copy: read the command once. */
+		slot = its->cmdq_copy + its->cmd_offset;
+		for (i = 0; i < ARRAY_SIZE(cmd.raw_cmd); i++)
+			cmd.raw_cmd[i] = READ_ONCE(slot[i]);
+		if (!its_process_cmd(its, &cmd)) {
+			rejected = true;
+			break;
+		}
+
+		memcpy(its->cmdq_hw + its->cmd_offset, &cmd, sizeof(cmd));
+		/*
+		 * Whatever GITS_CBASER says: it can read shareable on an ITS the
+		 * driver treats as non-coherent (ITS_FLAGS_CMDQ_NEEDS_FLUSHING).
+		 */
+		gic_flush_dcache_to_poc(its->cmdq_hw + its->cmd_offset, sizeof(cmd));
+		its->cmd_offset = (its->cmd_offset + sizeof(cmd)) % its->cmdq_size;
+	}
+
+	/* Retry has no effect unless the hardware stalled on a command error. */
+	dsb(ishst);
+	writeq_relaxed(its->cmd_offset | (val & GITS_CWRITER_RETRY), its->base + GITS_CWRITER);
+	return !rejected;
+}
+
+/* A reset clears GITS_CBASER.Valid, and an enable with it clear is UNPREDICTABLE. */
+static bool its_bases_intact(struct its_priv *its)
+{
+	return readq_relaxed(its->base + GITS_CBASER) == its->cbaser;
+}
+
+static bool its_ctlr_write(struct its_priv *its, u64 val)
+{
+	u32 ctlr = readl_relaxed(its->base + GITS_CTLR);
+
+	if ((val & GITS_CTLR_ENABLE) && !(ctlr & GITS_CTLR_ENABLE)) {
+		/*
+		 * Enabling while not Quiescent is UNPREDICTABLE. Dropped, not
+		 * rejected: the driver writes it when a quiesce times out on suspend.
+		 */
+		if (!(ctlr & GITS_CTLR_QUIESCENT))
+			return true;
+		if (!its_bases_intact(its))
+			return false;
+	}
+
+	writel_relaxed(val, its->base + GITS_CTLR);
+	return true;
+}
+
+/* GITS_CBASER and GITS_BASER<n> are UNPREDICTABLE to write otherwise. */
+static bool its_disabled_quiescent(struct its_priv *its)
+{
+	u32 ctlr = readl_relaxed(its->base + GITS_CTLR);
+
+	return !(ctlr & GITS_CTLR_ENABLE) && (ctlr & GITS_CTLR_QUIESCENT);
+}
+
+static bool its_cbaser_write(struct its_priv *its)
+{
+	if (!its_disabled_quiescent(its))
+		return false;
+
+	writeq_relaxed(its->cbaser, its->base + GITS_CBASER);
+
+	/* The write reset GITS_CREADR to 0; nothing queued before it completes. */
+	its->cmd_offset = 0;
+	its->hw_creadr = 0;
+	writeq_relaxed(0, its->base + GITS_CWRITER);
+	return true;
+}
+
+static bool its_emulate(struct its_priv *its, u64 offset, bool write, u64 *val, u8 size)
+{
+	if (write) {
+		switch (offset) {
+		case GITS_CTLR:
+			return size == sizeof(u32) && its_ctlr_write(its, *val);
+		case GITS_CBASER:
+			return size == sizeof(u64) && its_cbaser_write(its);
+		case GITS_CWRITER:
+			/* The driver writes the low word; the high word is RES0. */
+			return its_cwriter_write(its, *val);
+		case GITS_BASER ... GITS_BASER + (GITS_BASER_NR_REGS - 1) * sizeof(u64):
+			if (size != sizeof(u64))
+				return false;
+			writeq_relaxed(*val, its->base + offset);
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	*val = size == sizeof(u64) ? readq_relaxed(its->base + offset) :
+				     readl_relaxed(its->base + offset);
+	return true;
+}
+
+bool pkvm_its_emulate_handler(struct pkvm_protected_reg *region, u64 offset,
+			      bool write, u64 *val, u8 size)
+{
+	struct its_priv *its = region->priv;
+	bool ret;
+
+	if (size < sizeof(u32) || !IS_ALIGNED(offset, size))
+		return false;
+
+	hyp_spin_lock(&its->lock);
+	ret = its_emulate(its, offset, write, val, size);
+	hyp_spin_unlock(&its->lock);
+
+	return ret;
+}
+
+static struct pkvm_protected_reg *its_find_region(phys_addr_t its_base)
+{
+	int i;
+
+	for (i = 0; i < num_protected_reg; i++) {
+		if (PFN_PHYS(pkvm_protected_regs[i].pfn) == its_base)
+			return &pkvm_protected_regs[i];
+	}
+
+	return NULL;
+}
+
+static int its_take_cmdq(struct its_priv *its, phys_addr_t copy_pa)
+{
+	phys_addr_t hw_pa = GITS_CBASER_ADDRESS(its->cbaser);
+	size_t size = SZ_4K * (FIELD_GET(GITS_CBASER_SIZE, its->cbaser) + 1);
+	u32 cwriter = readq_relaxed(its->base + GITS_CWRITER) & GITS_CWRITER_OFFSET;
+	u32 creadr = readq_relaxed(its->base + GITS_CREADR) & GITS_CREADR_OFFSET;
+	u64 nr_pages = size >> PAGE_SHIFT;
+	int ret;
+
+	ret = __pkvm_host_donate_hyp(PHYS_PFN(hw_pa), nr_pages);
+	if (ret)
+		return ret;
+
+	ret = its_pin_host_pages(copy_pa, nr_pages);
+	if (ret)
+		return ret;
+
+	its->cmdq_hw = hyp_phys_to_virt(hw_pa);
+	its->cmdq_copy = hyp_phys_to_virt(copy_pa);
+	its->cmdq_size = size;
+	its->cmd_offset = cwriter;
+	its->hw_creadr = creadr;
+	return 0;
+}
+
+int pkvm_its_emulate_setup(phys_addr_t its_base, phys_addr_t desc_pa,
+			   size_t desc_size)
+{
+	u64 desc_pages = desc_size >> PAGE_SHIFT;
+	struct pkvm_protected_reg *region;
+	struct its_pkvm_desc *desc;
+	struct its_priv *its;
+	u64 priv_pages;
+	int ret;
+
+	region = its_find_region(its_base);
+	if (!region)
+		return -ENODEV;
+	if (region->priv)
+		return -EBUSY;
+
+	/*
+	 * Called once per ITS by the still-privileged host, so its arguments and
+	 * the registers it programmed are trusted. No unwind on failure: the host
+	 * is then never deprivileged.
+	 */
+	ret = __pkvm_host_donate_hyp(PHYS_PFN(desc_pa), desc_pages);
+	if (ret)
+		return ret;
+	desc = hyp_phys_to_virt(desc_pa);
+
+	priv_pages = desc->priv_pages;
+	ret = __pkvm_host_donate_hyp(PHYS_PFN(desc->priv_pa), priv_pages);
+	if (ret)
+		return ret;
+	its = hyp_phys_to_virt(desc->priv_pa);
+	memset(its, 0, priv_pages * PAGE_SIZE);
+
+	hyp_spin_lock_init(&its->lock);
+	its->base = region->hyp_va;
+	its->cbaser = readq_relaxed(its->base + GITS_CBASER);
+
+	ret = its_take_cmdq(its, desc->cmdq_copy_pa);
+	if (ret)
+		return ret;
+
+	WARN_ON(__pkvm_hyp_donate_host(PHYS_PFN(desc_pa), desc_pages));
+	/* Published by stop_machine()'s exit: no host CPU traps until then. */
+	region->priv = its;
+	return 0;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8d45f45d30e6a..4730f628b9497 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -13,10 +13,12 @@
 #include <asm/kvm_pkvm.h>
 #include <asm/stage2_pgtable.h>
 
+#include <hyp/adjust_pc.h>
 #include <hyp/fault.h>
 
 #include <nvhe/arm-smccc.h>
 #include <nvhe/gfp.h>
+#include <nvhe/its_emulate.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -779,6 +781,65 @@ static void host_inject_mem_abort(struct kvm_cpu_context *host_ctxt)
 	inject_host_exception(esr);
 }
 
+static struct pkvm_protected_reg *find_protected_reg(u64 addr, u8 size)
+{
+	struct pkvm_protected_reg *region;
+	u64 start, end;
+	int i;
+
+	for (i = 0; i < num_protected_reg; i++) {
+		region = &pkvm_protected_regs[i];
+		start = PFN_PHYS(region->pfn);
+		end = start + PFN_PHYS(region->nr_pages);
+
+		if (addr >= start && addr + size <= end)
+			return region;
+	}
+
+	return NULL;
+}
+
+/*
+ * Returns false when the access cannot be emulated or the emulation rejects it;
+ * the caller's host stage-2 path then injects the abort.
+ */
+static bool handle_host_mmio_trap(struct kvm_cpu_context *host_ctxt, u64 esr,
+				  u64 addr)
+{
+	struct pkvm_protected_reg *region;
+	u64 val = 0;
+	u8 size, rt;
+	bool write;
+
+	/* No syndrome, no emulation. */
+	if (ESR_ELx_EC(esr) != ESR_ELx_EC_DABT_LOW || !(esr & ESR_ELx_ISV))
+		return false;
+
+	size = BIT(FIELD_GET(ESR_ELx_SAS, esr));
+	region = find_protected_reg(addr, size);
+	if (!region)
+		return false;
+
+	rt = FIELD_GET(ESR_ELx_SRT_MASK, esr);
+	write = esr & ESR_ELx_WNR;
+	if (write && rt != 31)
+		val = host_ctxt->regs.regs[rt] & GENMASK_ULL(size * 8 - 1, 0);
+
+	if (!pkvm_its_emulate_handler(region, addr - PFN_PHYS(region->pfn), write, &val, size))
+		return false;
+
+	if (!write && rt != 31) {
+		if ((esr & ESR_ELx_SSE) && size < sizeof(u64))
+			val = sign_extend64(val, size * 8 - 1);
+		if (!(esr & ESR_ELx_SF))
+			val = lower_32_bits(val);
+		host_ctxt->regs.regs[rt] = val;
+	}
+
+	kvm_skip_host_instr();
+	return true;
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -801,6 +862,10 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
+	if (num_protected_reg &&
+	    handle_host_mmio_trap(host_ctxt, esr, addr | FAR_TO_FIPA_OFFSET(fault.far_el2)))
+		return;
+
 	switch (host_stage2_idmap(addr)) {
 	case -EPERM:
 		host_inject_mem_abort(host_ctxt);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 16dfb249b4961..3293e3c7353b8 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -6,6 +6,7 @@
 
 #include <linux/init.h>
 #include <linux/interval_tree_generic.h>
+#include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kmemleak.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
@@ -43,6 +44,53 @@ static int __init register_memblock_regions(void)
 	return 0;
 }
 
+static int __init pkvm_register_its_region(phys_addr_t its_base)
+{
+	unsigned int idx = kvm_nvhe_sym(num_protected_reg);
+	struct pkvm_protected_reg *region;
+
+	if (idx >= PKVM_PROTECTED_REGS_NUM) {
+		kvm_err("ITS@%pa: no protected region slot left\n", &its_base);
+		return -ENOSPC;
+	}
+
+	/*
+	 * The control frame only: GITS_TRANSLATER stays host-mapped in the next
+	 * frame, as devices raise MSIs through it.
+	 */
+	region = &kvm_nvhe_sym(pkvm_protected_regs)[idx];
+	region->pfn = PHYS_PFN(its_base);
+	region->nr_pages = PFN_DOWN(GITS_TRANSLATER);
+	kvm_nvhe_sym(num_protected_reg) = idx + 1;
+
+	return 0;
+}
+
+int __init pkvm_register_its_regions(void)
+{
+	int ret;
+
+	ret = its_pkvm_iter_its(pkvm_register_its_region);
+	if (ret)
+		kvm_err("Failed to register the ITS regions with hyp: %d\n", ret);
+
+	return ret;
+}
+
+/* Called by the driver with every CPU parked: no allocation here. */
+static int __init pkvm_init_its_emulation(phys_addr_t its_base,
+					  struct its_pkvm_desc *desc,
+					  size_t desc_size)
+{
+	int ret;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_its_emulate_setup, its_base, virt_to_phys(desc), desc_size);
+	if (ret)
+		kvm_err("ITS@%pa: emulation setup failed: %d\n", &its_base, ret);
+
+	return ret;
+}
+
 void __init kvm_hyp_reserve(void)
 {
 	u64 hyp_mem_pages = 0;
@@ -299,6 +347,10 @@ int pkvm_init_host_vm(struct kvm *kvm)
 {
 	int ret;
 
+	/* The ITS takeover failed, so the hypervisor never finalised. */
+	if (!is_pkvm_initialized())
+		return -ENODEV;
+
 	/* Reserve the VM in hyp and obtain a hyp handle for the VM. */
 	ret = kvm_call_hyp_nvhe(__pkvm_reserve_vm);
 	if (ret < 0)
@@ -313,19 +365,61 @@ int pkvm_init_host_vm(struct kvm *kvm)
 	return 0;
 }
 
+struct pkvm_its_takeover {
+	int	ret;
+	bool	done;
+};
+
 static int __init __pkvm_drop_host_privileges(void *arg)
 {
+	struct pkvm_its_takeover *takeover = arg;
+
+	if (smp_processor_id() == cpumask_first(cpu_online_mask)) {
+		takeover->ret = its_pkvm_setup_commit(pkvm_init_its_emulation);
+		/* Publishes ret to the CPUs spinning below. */
+		smp_store_release(&takeover->done, true);
+	}
+
+	/* Pairs with the release above: ret is read after done. */
+	while (!smp_load_acquire(&takeover->done))
+		cpu_relax();
+
+	/* No CPU is deprivileged unless the hypervisor took every ITS. */
+	if (takeover->ret)
+		return 0;
+
 	return WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)) ? -EINVAL : 0;
 }
 
 static int __init pkvm_drop_host_privileges(void)
 {
+	struct pkvm_its_takeover takeover = {};
+	int ret;
+
+	/* Drivers take dev_alloc_lock, through the MSI layer, with it held. */
+	cpus_read_lock();
+	ret = its_pkvm_setup_prepare();
+	if (ret)
+		goto out;
+
 	/*
 	 * Flip the static key upfront as that may no longer be possible
 	 * once the host stage 2 is installed.
 	 */
-	static_branch_enable(&kvm_protected_mode_initialized);
-	return stop_machine(__pkvm_drop_host_privileges, NULL, cpu_online_mask);
+	static_branch_enable_cpuslocked(&kvm_protected_mode_initialized);
+	ret = stop_machine_cpuslocked(__pkvm_drop_host_privileges, &takeover, cpu_online_mask);
+	if (takeover.ret) {
+		/* No stage 2 was installed: back to before finalisation, no VMs. */
+		static_branch_disable_cpuslocked(&kvm_protected_mode_initialized);
+		ret = takeover.ret;
+	}
+out:
+	its_pkvm_setup_finish();
+	cpus_read_unlock();
+	if (ret && !is_pkvm_initialized())
+		pr_err("pKVM: ITS takeover failed (%d): host not deprivileged, VMs refused\n", ret);
+
+	return ret;
 }
 
 static void __init pkvm_selftests(void)
-- 
2.47.3

