Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86B947607A
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933102; cv=none; b=DdpAKIvBR1uYSqXap2kksOBIffYOSavIVTiPbVW8Ej+B1vFSLgum+R4H2zLYnrGnB+0b3bknTVAAhRGIw6CovaEkqqShN9Kd+PbD5DYBkKQ0kvaqpP43LaRoTxvopXgLsphvoZYKfTIlCGgZX8fUYx0ZYOV46s4F7hU2wmw/xQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933102; c=relaxed/simple;
	bh=nfGmU6zeFYw1CG0Soj4UXKCYORpOEZJIuUPO2yNR1NI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRNYhyS8ioBdzcAZ9chl0r9VaB1Gz14j2CHgDu//CeihL/YbcoQq3ereUB2GBPU2ipfRNm/PHal550aHvk71hR1aIcPvVXxUESgQJ2vw42J02O5Y/4bnd4rgfYrSxSK3FnUJldQW+QHB+qNbJYKTPmZ5Bvtxv+Sfbof67rHG3OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=jqelzSql; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="jqelzSql"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43db0c17so19945417b3.3
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933099; x=1790537899; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WJieeIgM+cp8bkpFe8Ny3KapR5wdIQZOgEecLTuA7iY=;
        b=jqelzSql4eUVDpKozgygIaX5zQBRfWk2LcOplClW3w5CgUKacW0P6hQaT2m8LkormX
         R5ye2YtBQbU6d9ONnRZytM+Hq3rmvx3iqw5Qb5mHS4sZspUaL44VJ+Ori2MOQbIxL+eM
         DcAnO9YUqyPczbc5qEmb2RmfIRLPeuTn1APcuOwTFEKSVlvd38qvr+7DPXFmZptrZsk1
         GKQXm8DjWUT3H+b7qYn1wY/W+XRgV5OdkdYDJJAkr7f4SEKHa7FEJX1aJfdciNGAJF0B
         80tTx5KntQbhYBB9wPbeDVf4hp4Jx1B4+TUyxqn/m3NcRWSuqNd2L95Q1CTkSQwd2ofg
         EqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933099; x=1790537899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=WJieeIgM+cp8bkpFe8Ny3KapR5wdIQZOgEecLTuA7iY=;
        b=b8ZUEmWNCD8TOQFEHJmr+P89oSLX5WzebH9IVg5ilM/qXd/vyda021n7ib7yI8q9M3
         q7vYG6zxKa+ETWrsr0wnsaSPe1r9hCs9EZ8CBrU8qNk+nAqbdnqYPwJ2pXaq/y1uq2cV
         TZgtg4luosk2dU4PCXu5nWFMiLl5Aiq4s504zLR4Nq5FMLltwZSn+kZZmz+l0O05PxGQ
         6c5+iwoab0Bb6c4hs32cCLemjc/h3GiNLsc/A5hYnnKWTA0e4tyeq6kKfOI+uJ26h4+E
         TeBH+4YIvwcaDN1Vl8DRJVAsBfE1oRWEEYlqVk09mu5dkMX4Z9yzkfzuQkvGgwc+aMth
         0u5g==
X-Forwarded-Encrypted: i=1; AKwUvByZFyibIfZeEXqhAOv9zyVtXR+YQGMo/mUQhX7/5HnJGQCqBbTHJOZRGzhWwgYaU7c/lU/IPks=@lists.linux.dev
X-Gm-Message-State: AFuF++n+c2yq8ft+2zC+cYOvcAq8gTR7h+m40urpVqOwRbIn3nZHOgjh
	MLaDILPqig6oFYtWpv5yPN1p+d6GrL9nBM04JGtml/pupWAlOc7spcnN36mXR4RI8gs=
X-Gm-Gg: AYBFou38KhaGzU9DuHJHF1t4vDn9klJ9cbXFJpxZu3+TXFSGSYf5+AFYZx4wKI2eOTN
	dKUBNFKBH5EZgnN1sELscMRAYr0G4TCKl1227LYYAxKiYc7qtuH+vWVpDjM2xxAvXXy6JujS6T7
	C0OOzsISJsRwad2C2JovyD7a520yrugZ1vnxagUn0kSk1/HOlQGqHtKeCUEo5MBnufi2cpZBJBj
	cE/O0zJJ4Ved+UXl22rp5stteWKNVq+tAZRZRC20xfdVuApF4eVTcgb7pFKPlmHMScGJ2oKcC/S
	SXFTZpjcGdTUjmUfhSxgbW0WvUwO4M3w0kRzkyqOK/9xNXy7k4bJ7gPr62F6XjlRGFbVnuBjoUh
	2COXIgiDAeQEuTQMtUjqipgXTSndM09MAIeKO1s9FEsZ7jlwjE89MPOMPWjff9ug019LeRX1ArO
	VgV9IsvPC5jOoc4r3aPcayasJGcrEHMoZkiAIw7zlZ78eEAeEq66cRxJVHPkZcdHaffi6Poq1A/
	c7x1kvDYhbJ7IlFOlOL1GCLghjXtd+FJWZI5A/WJaEebO2osqyNI4OrYH0RXGgyoxwelfGzwAbD
	cqKWWga3HD7GDRtIdZDpDfNGeG5eSg==
X-Received: by 2002:a05:690c:ec4:b0:873:5c6b:a2fb with SMTP id 00721157ae682-897363672acmr24218447b3.41.1789933098791;
        Sun, 20 Sep 2026 12:38:18 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a415208bfsm19238877b3.3.2026.09.20.12.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:18 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 14/46] cpu_preserve: Add core physical CPU preservation state and park loop
Date: Sun, 20 Sep 2026 15:36:18 -0400
Message-ID: <20260920193650.3373435-15-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the physical CPU preservation state tracking, cache maintenance
wrappers, and standalone park execution loop in
kernel/liveupdate/cpu_preserve.c.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/cpu_preserve.c | 249 +++++++++++++++++++++++++++++++
 1 file changed, 249 insertions(+)
 create mode 100644 kernel/liveupdate/cpu_preserve.c

diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
new file mode 100644
index 000000000000..e19208670c3e
--- /dev/null
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: Preserved CPU Subsystem
+ *
+ * Live Update allows updating the host kernel while preserving the state of
+ * hardware resources across the transition. While memfd-based memory
+ * preservation is supported via LUO and PCI device preservation is handled
+ * by VFIO and IOMMU, physical CPU cores represent another fundamental class
+ * of hardware resource that requires preservation.
+ *
+ * A primary motivation is preserving virtual machine (VM) workloads across
+ * host kernel updates without pausing the guest. By separating a physical
+ * core from standard host scheduling and keeping it active across the kexec
+ * reboot, guest vCPUs or dedicated bare-metal tasks can continue
+ * uninterrupted execution on-core.
+ *
+ * This subsystem provides the generic, hypervisor-agnostic foundation for
+ * physical CPU preservation.
+ *
+ * Lifecycle
+ * =========
+ *
+ * CPU lifecycle state progression::
+ *
+ *     +-------------------------------------------------------------+
+ *     |                          ONLINE                             |
+ *     |               (Normal host task scheduling)                 |
+ *     +-------------------------------------------------------------+
+ *                                    |
+ *                                    | preserve (via LUO fd)
+ *                                    v
+ *     +-------------------------------------------------------------+
+ *     |                     PRESERVED_PARKED                        |
+ *     |          (Removed from scheduler, loops in park)            |
+ *     +-------------------------------------------------------------+
+ *                                    |
+ *                                    | [Live Update: kexec]
+ *                                    v
+ *     +-------------------------------------------------------------+
+ *     |                     INCOMING PRESERVED                      |
+ *     |         (Parked on-core, skipped in secondary boot)         |
+ *     |       (State restored upon session retrieve; stays running) |
+ *     +-------------------------------------------------------------+
+ *                                    |
+ *                                    | unpreserve / finish (via LUO session)
+ *                                    v
+ *     +-------------------------------------------------------------+
+ *     |                          OFFLINE                            |
+ *     |            (Park loop exited, architecturally idle)         |
+ *     +-------------------------------------------------------------+
+ *                                    |
+ *                                    | automatic add_cpu()
+ *                                    v
+ *     +-------------------------------------------------------------+
+ *     |                          ONLINE                             |
+ *     |                (Rejoined host scheduling)                   |
+ *     +-------------------------------------------------------------+
+ *
+ * File Descriptor Binding
+ * =======================
+ *
+ * 1. **Sysfs control file:** Each hotpluggable CPU exports a read-only sysfs
+ *    attribute at ``/sys/devices/system/cpu/cpu<N>/preserve``. The file
+ *    descriptor of this file handles the lifecycle of the preserved CPU.
+ *
+ * 2. **Preservation via LUO:** Userspace opens this file and registers the fd
+ *    with LUO. Preserving the file offlines the core from host scheduling,
+ *    migrates its interrupts and tasks, and transitions the CPU from online
+ *    into the parked state (cpu_preserved_park()). Preservation integrates with
+ *    the On-Core framework (oncore_session_add_cpu()).
+ *
+ * 3. **KHO and memory preservation:** The parking loop, dedicated preserved
+ *    CPU stacks, runtime execution buffers outside Scratch memory, and
+ *    preserved CPU state reside in memory preserved across kexec via KHO.
+ *
+ * 4. **Incoming boot:** During early boot, the incoming kernel restores the
+ *    preserved CPU mask from the KHO FLB before secondary SMP bringup and
+ *    skips bringing preserved cores online, maintaining isolation.
+ *
+ * 5. **Retrieval and unpreservation:** When userspace retrieves the session in
+ *    the incoming kernel, it receives the open ``preserve`` file descriptor.
+ *    Retrieving the session reconnects the descriptors and restores on-core session
+ *    state while keeping the core running. Finalizing the session (``finish``)
+ *    or closing the fd unpreserves the CPU, signaling the core to exit the
+ *    parking loop and automatically restoring it online via add_cpu().
+ *
+ * Architecture Requirements
+ * =========================
+ *
+ * In addition to CPU hotplug (``CONFIG_HOTPLUG_CPU``), an architecture
+ * selecting ``ARCH_SUPPORTS_LIVEUPDATE_CPU`` must provide:
+ *
+ * - **Linker script:** Include ``CPU_PRESERVED_TEXT`` in
+ *   ``arch/<arch>/kernel/vmlinux.lds.S`` within the executable text section.
+ *
+ * - **Preserved text section:** Functions executed by a parked core or during
+ *   live update transitions must be annotated with ``__cpu_preserved_text`` so
+ *   their instructions reside in the KHO-preserved ``.text.cpu_preserved``
+ *   section. These are the ``arch_cpu_preserved_*()`` hooks documented in
+ *   ``include/linux/cpu_preserve.h``.
+ *
+ * - **Address-space mapping hooks:** arch_cpu_preserved_as_map(),
+ *   arch_cpu_preserved_as_flush_tlb(), and
+ *   arch_cpu_preserved_set_transition_as() populate and manage isolated page
+ *   tables built by the core layer using cpu_preserved_as_alloc_page().
+ *
+ * - **Buffer relocation hook:** arch_cpu_preserved_setup_buffer() relocates
+ *   preserved text and data sections outside KHO Scratch memory so the
+ *   incoming kernel can unpack safely.
+ *
+ * - **CPU hotplug and stop-IPI isolation:** Exclude preserved CPUs from stop
+ *   signals (NMI or stop IPIs in the machine reboot and crash paths), and
+ *   avoid tearing down local interrupt controllers (LAPIC, GIC CPU interface)
+ *   during CPU disable when the core is being preserved.
+ *
+ * Isolated Address Space
+ * ======================
+ *
+ * A preserved core does not run on the kernel's own page tables. Before it is
+ * handed over, the core layer builds a transition page table
+ * (cpu_preserved_as_create()) containing only what on-core execution needs,
+ * so that a core still running a workload cannot touch memory the new kernel
+ * has taken ownership of:
+ *
+ * - Preserved text and read-only data, ``PAGE_KERNEL_ROX``
+ *   (``__cpu_preserved_text``) -- park loops, world-switch routines, ops
+ *   vector tables, and exception stubs;
+ * - Preserved writable globals, ``PAGE_KERNEL`` NX
+ *   (``__cpu_preserved_data``) -- state machines, session descriptors,
+ *   per-CPU control blocks, and the preserved-CPU masks;
+ * - The per-CPU dedicated preserved stack, ``PAGE_KERNEL`` NX;
+ * - The KHO-preserved workload state pages, ``PAGE_KERNEL`` NX;
+ * - Hardware control MMIO, ``PAGE_KERNEL_IO``, only where the interrupt
+ *   controller still requires it (e.g., GICv3 in system-register mode needs
+ *   none).
+ *
+ * Deliberately absent: the linear direct map, all user address ranges, the
+ * kernel heap, vmalloc, modules, and BPF JIT. Guest memory is not mapped
+ * either -- it is reached through stage-2 translation.
+ *
+ * On arm64 these mappings are built with trans_pgd_map_range(), on x86 with
+ * the identity-map helpers in ``arch/x86/mm/ident_map.c``. Custom workload
+ * address spaces can also be created and adopted across kexec via
+ * cpu_preserved_as_adopt().
+ *
+ * Workload Integration
+ * ====================
+ *
+ * Physical cores preserved across live update execute payloads managed by the
+ * On-Core execution framework. CPU preservation integrates directly with On-Core
+ * session lifecycle:
+ *
+ * - On-Core assigns jobs to preserved cores via cpu_preserved_attach_workload().
+ * - When a CPU file is preserved or unpreserved, oncore_session_add_cpu() and
+ *   oncore_session_remove_cpu() update the session CPU bitmap.
+ * - At kexec handover, oncore_session_get_ser() serializes the session state into
+ *   the preserved CPU file descriptor, and oncore_session_restore() reconstructs
+ *   the session in the incoming kernel.
+ */
+
+#define pr_fmt(fmt) "cpu_preserve: " fmt
+
+#include <linux/cpu.h>
+#include <linux/cpu_preserve.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/device/bus.h>
+#include <linux/kexec.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/cpu.h>
+#include <linux/kho_block.h>
+#include <linux/liveupdate.h>
+#include <linux/mm.h>
+#include <linux/objtool.h>
+#include <linux/reboot.h>
+
+#include <asm/sections.h>
+
+/**
+ * struct cpu_preserved_pcpu - Per-CPU host runtime state for CPU preservation
+ * @stack_pa: Physical address of the preserved stack for this CPU.
+ * @pgd_pa: Page table root PA for the preserved CPU context.
+ * @entry_fn: Workload callback function executed repeatedly on the physical
+ *            core while parked in cpu_preserved_park().
+ * @entry_data: Opaque argument passed to @entry_fn.
+ *
+ * Tracks host runtime state for a preserved physical core. Allocated locally
+ * in host memory; not preserved across kexec handover.
+ */
+struct cpu_preserved_pcpu {
+	phys_addr_t stack_pa;
+	phys_addr_t pgd_pa;
+	void (*entry_fn)(void *data) ____cacheline_aligned;
+	void *entry_data;
+};
+
+/*
+ * struct cpu_preserved_state - Host-side preserved CPU state (incoming or outgoing)
+ * @mask: Mask of preserved CPUs.
+ * @pcpus: Host runtime state array.
+ * @pcpus_ser: Per-CPU mailbox array in preserved memory.
+ */
+struct cpu_preserved_state {
+	cpumask_t mask;
+	struct cpu_preserved_pcpu *pcpus;
+	struct cpu_preserved_pcpu_ser *pcpus_ser;
+};
+
+static DEFINE_MUTEX(cpu_preserved_lock);
+static struct cpu_preserved_state cpu_preserved_incoming;
+static struct cpu_preserved_state cpu_preserved_outgoing;
+static cpumask_t cpu_preserved_mask __cpu_preserved_data;
+static struct cpu_preserved_pcpu_ser *cpu_preserved_pcpus_va __cpu_preserved_data;
+static struct cpu_preserved_pcpu *cpu_preserved_host_pcpus_va __cpu_preserved_data;
+static struct cpu_preserved_global_ser *cpu_preserved_global_ser;
+
+static struct page *cpu_preserved_text_pages;
+static unsigned int cpu_preserved_text_order;
+static struct page *cpu_preserved_data_pages;
+static unsigned int cpu_preserved_data_order;
+static bool cpu_preserved_runtime_preserved;
+
+/*
+ * Address spaces are mapped into under @cpu_preserved_as_map_lock and
+ * enumerated under @cpu_preserved_as_list_lock.  cpu_preserved_map_range()
+ * holds the list lock across the map lock; nothing takes them the other way
+ * round.
+ */
+static DEFINE_MUTEX(cpu_preserved_as_list_lock);
+static DEFINE_MUTEX(cpu_preserved_as_map_lock);
+static LIST_HEAD(cpu_preserved_as_list);
+static struct cpu_preserved_as *cpu_preserved_transition_as;
+
+static phys_addr_t cpu_preserved_get_text_pa(void)
+{
+	return cpu_preserved_text_pages ? page_to_phys(cpu_preserved_text_pages) : 0;
+}
+
+static phys_addr_t cpu_preserved_get_data_pa(void)
+{
+	return cpu_preserved_data_pages ? page_to_phys(cpu_preserved_data_pages) : 0;
+}
+
-- 
2.55.0.1082.g2b9226bbc0-goog

