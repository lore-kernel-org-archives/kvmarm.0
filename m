Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B031476CD3
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933108; cv=none; b=Y52cv+4vkpMGg7GKJ00lsoga0v33zwiMAM6dxvG3zb8BrlpibTdlGP41kVu3Yq4Fct1YB0ymw6DjmAFgvk6VjDuToZnGR6mfbnseqgVVqfPaIgmwwMhFEkPto7nunGM1iGuv+nLwZaRHApBDl/6qO3GM5FNd/sIoD9VxpssSbtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933108; c=relaxed/simple;
	bh=Mx5CubcfB4sMZYCm46TzbufBdOimSDN1Nrpp7LlbNFg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIkig98zATwpuigArpd0saljCzjIUGN0jdyUDiioX2u/RzrkTVwpoeEZxwPC15S0IXvoXN1aBBZbKW/buNTWeSYu344BK3jIVm/L5QXOCDXDJGwvVS3oje/IhrerHjm4pfqvzmnxn2OTqfbast1fo3pEdRH02CidbchYjcDYBZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=FN8Jotf2; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="FN8Jotf2"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab22370so1639562d50.3
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933105; x=1790537905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K5j5l9GIwIcGWU8WT7f8DcBXaOCqBMTT8VcXmZE9caw=;
        b=FN8Jotf2DdsHGNeYYnPku4wCjtUz5DYQYqaQ0KgI5Eb0Abokfsk6OGy6Nkl0ExV3rX
         i7zut9jEI+HdKdGFGkDzFNW4urbbuY80/Wfw31CCKMQSmygnzqi59fyUcrGFQJBFORee
         9pkfe0w3weQ7kiOGJ6hVpUKs9j2YjhhrU+ORY7nuSkywL7TVq/PHC4uHw1pR53QD9qU8
         0bUAU1aX6TdLZYJeUD0juRP8pJXilx+3HDbdNT1ghLDbYXK1cJy1WMgK71kT48YznE2g
         a1BKi5dX0ws39FOGm+GpYSjwRZztWMkZ/tt1OZ4yPFIw9ag69Zp/4mMN+6lBAtW7A4xK
         pXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933105; x=1790537905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=K5j5l9GIwIcGWU8WT7f8DcBXaOCqBMTT8VcXmZE9caw=;
        b=nhUXcHMnl/FFWkDr7EN3ltKTlt2n1gKqYS3zyFYFW/h4x92GzFwlt4RAcnkO4eNgO6
         RFyjpgpktpiDIMiN0dJnaP33YyWkti9XCy9KLs1XlvFsy8kdG2LOTHDE1Gphb3fi5N1w
         SXAuO71pN+NU9xUp3gil+JoTMCsuXTxGnAUDdr8I3+TG91CUXnHKKSO5koIq85X9c4yk
         vXXIkQ9+WmBFlPGFB3Y4q8/+CwBOiNHoju1GYfLEfibrctpCV4vr1lsrkXKhB0A0ETLv
         ynMunBwkLZ7AgvsxVX1cKZjzJq+zI1ACmy/muGb4ZqqjvN+LtGk0f1Cc1LPqIX7M2/LT
         Ep/A==
X-Forwarded-Encrypted: i=1; AKwUvBxk2tvv3eSjTZYGSNnQ83lD9/Vdz0wjnjrpHLKLfWH6U+KjyTUaLshT6BpOErP/4sHjuUOckXk=@lists.linux.dev
X-Gm-Message-State: AFuF++mVDRx2SPMWBKrJWFSt1+17fjqI1jYJ+GIvIwNzutNOIBDYbKlc
	2B/OaVt+rIf0CihMx5SY7MHo8Ee1Z1SBavtNT4KUVvt3NCkf97Cekl8ZAf1SruBJuAo=
X-Gm-Gg: AYBFou1tKjb694fGVYCI5w2YZ0W+cJMD7KBP6BcZWwpeVyXppWMQXznlSfeae1HRF+m
	TNdgvzuWCMbEvYf2K1VeHrw/NLg4ue2nNOMHuXTeXmuLjArO47VqyVoVrnWJkqNp+cdxRN2lazY
	96AQCoj4OsCsrvEjJV0FuDV4t0OR2Ea9wEme05+9pcpaYCDzZBjPnebWTbZZhOTFre5NfgDAzJZ
	npKCvTAbqClCTcQw6QnTfxMw6ifG0nIoBlwh2nuH2nZ9ugFiaAnwR3KG5qCphnZitDfCQ7h6g+W
	zBraFVZAn0ybc028qnGbwPfH4IYzualA0L7MvxZJYcm5knK/LXv/fGbuQlGz6joL+ntMCBm7Urd
	SbCLrOHpV2sU0E+bYBt9AjzDEZXYuF9EkTuuYnO+v2YSxTkzoqJ+qQxw9TK5GDdTTpwzDdc3OTG
	+wkHHvlh0EQi+mieYewfdOG8B9s8Mp4KzHv4XNyciaL8gDAkXRxgQpdEIWPseI3h3wJoEe8Cdct
	tElfNKMHpInjuiH1aA2JEpDoEOsuZJixFtlWu45sTa7heEq2vNwvfaC9+0w6c6kLlIDkgqGyXoi
	I+GF1yzPBiJJnDndqFE=
X-Received: by 2002:a05:690c:a695:b0:873:5ddf:d85a with SMTP id 00721157ae682-897346e4bd2mr18960687b3.37.1789933105074;
        Sun, 20 Sep 2026 12:38:25 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a47af7bfbsm18835137b3.33.2026.09.20.12.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:24 -0700 (PDT)
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
Subject: [RFC PATCH 15/46] cpu_preserve: Add physical CPU preservation lifecycle and build rules
Date: Sun, 20 Sep 2026 15:36:19 -0400
Message-ID: <20260920193650.3373435-16-pasha.tatashin@soleen.com>
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

Implement physical CPU preservation lifecycle management, stack allocation,
and build rules with -mbranch-protection=none and -fno-stack-protector.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/cpu.c                     |   2 +
 kernel/liveupdate/Kconfig        |  35 +++
 kernel/liveupdate/Makefile       |   3 +
 kernel/liveupdate/cpu_preserve.c | 359 +++++++++++++++++++++++++++++++
 4 files changed, 399 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b3c8553d7bd6..8637b5e7f2de 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -14,6 +14,7 @@
 #include <linux/sched/smt.h>
 #include <linux/unistd.h>
 #include <linux/cpu.h>
+#include <linux/cpu_preserve.h>
 #include <linux/oom.h>
 #include <linux/rcupdate.h>
 #include <linux/delay.h>
@@ -349,6 +350,7 @@ static inline void cpuhp_ap_update_sync_state(enum cpuhp_sync_state state) { }
 void cpuhp_ap_report_dead(void)
 {
 	cpuhp_ap_update_sync_state(SYNC_STATE_DEAD);
+	cpu_preserved_report_dead();
 }
 
 void __weak arch_cpuhp_cleanup_dead_cpu(unsigned int cpu) { }
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 2490f9a9b838..52c5fd7a620b 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -101,4 +101,39 @@ config LIVEUPDATE_GUEST_MEMFD
 
 	  If unsure, say N.
 
+config ARCH_SUPPORTS_LIVEUPDATE_CPU
+	bool
+
+config LIVEUPDATE_CPU
+	bool "Live update support for preserved CPUs"
+	depends on LIVEUPDATE
+	depends on ARCH_SUPPORTS_LIVEUPDATE_CPU
+	depends on HOTPLUG_CPU
+	default LIVEUPDATE
+	help
+	  Enable live update support for physical CPU preservation.
+
+	  This feature allows physical CPU cores to be preserved across
+	  kexec-based live updates without undergoing a hardware reset or
+	  full kernel offline/online cycle.
+
+	  When a core is preserved, it is isolated from host scheduling and
+	  parked in a dedicated execution loop within preserved memory pages.
+	  Its execution context, state, and necessary page tables are handed
+	  over across the kexec transition using the KHO
+	  framework. The incoming kernel detects preserved cores during early
+	  boot and avoids bringing them up during smp_init(), keeping them
+	  isolated and running their assigned workloads.
+
+	  This capability is a core building block for live-updating virtual
+	  machine hosts (e.g. Caretaker/OrphanVM) without pausing or
+	  disrupting running guest workloads, and can also speed up kernel
+	  live updates by skipping CPU re-initialization.
+
+	  Preservation lifecycle is managed from userspace via LUO sessions
+	  associated with /sys/devices/system/cpu/cpu<N>/preserve file
+	  descriptors, and monitored via sysfs.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index d9f469462556..486f7854bb75 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CFLAGS_cpu_preserve.o += $(call cc-option,-mbranch-protection=none) -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
+
 luo-y :=								\
 		kho_block.o						\
 		luo_core.o						\
@@ -11,3 +13,4 @@ obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
+obj-$(CONFIG_LIVEUPDATE_CPU)		+= cpu_preserve.o
diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
index e19208670c3e..c5fd3a07ccb5 100644
--- a/kernel/liveupdate/cpu_preserve.c
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -247,3 +247,362 @@ static phys_addr_t cpu_preserved_get_data_pa(void)
 	return cpu_preserved_data_pages ? page_to_phys(cpu_preserved_data_pages) : 0;
 }
 
+static void cpu_preserved_sync_global_ser(void)
+{
+	struct cpu_preserved_global_ser *ser = cpu_preserved_global_ser;
+
+	if (!ser)
+		return;
+
+	bitmap_to_arr64(ser->cpu_preserved_bitmap,
+			cpumask_bits(&cpu_preserved_mask), nr_cpu_ids);
+	if (cpu_preserved_text_pages) {
+		ser->text_runtime_pa = page_to_phys(cpu_preserved_text_pages);
+		ser->text_runtime_size =
+			(1UL << cpu_preserved_text_order) * PAGE_SIZE;
+	}
+	if (cpu_preserved_data_pages) {
+		ser->data_runtime_pa = page_to_phys(cpu_preserved_data_pages);
+		ser->data_runtime_size =
+			(1UL << cpu_preserved_data_order) * PAGE_SIZE;
+	}
+	KHOSER_STORE_PTR(ser->pcpus_runtime, cpu_preserved_outgoing.pcpus_ser);
+	cpu_preserved_clean_sz(ser,
+			       struct_size(ser, cpu_preserved_bitmap, ser->nr_cpu_words));
+}
+
+static void cpu_preserved_free_kho(void *va, bool is_incoming)
+{
+	if (!va)
+		return;
+
+	if (is_incoming)
+		kho_restore_free(va);
+	else
+		kho_unpreserve_free(va);
+}
+
+static void cpu_preserved_free_stack(phys_addr_t stack_pa, bool is_incoming)
+{
+	if (stack_pa)
+		cpu_preserved_free_kho(phys_to_virt(stack_pa), is_incoming);
+}
+
+static void cpu_preserved_state_cleanup(struct cpu_preserved_state *st,
+					bool is_incoming)
+{
+	if (!cpumask_empty(&st->mask))
+		return;
+
+	cpu_preserved_free_kho(st->pcpus_ser, is_incoming);
+	st->pcpus_ser = NULL;
+	kfree(st->pcpus);
+	st->pcpus = NULL;
+}
+
+/*
+ * Drop @cpu out of the preserved state, free its preserved stack, and
+ * republish the globals a parked core may still be reading.  The caller holds
+ * cpu_preserved_lock and has already made the core leave the park loop.
+ */
+static void __cpu_unpreserve_locked(unsigned int cpu)
+{
+	struct cpu_preserved_state *incoming = &cpu_preserved_incoming;
+	struct cpu_preserved_state *outgoing = &cpu_preserved_outgoing;
+	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
+	struct cpu_preserved_pcpu *pcpu = cpu_preserved_get_pcpu(cpu);
+	bool is_incoming = cpu_preserved_is_incoming(cpu);
+	phys_addr_t stack_pa = 0;
+
+	lockdep_assert_held(&cpu_preserved_lock);
+
+	cpumask_clear_cpu(cpu, &outgoing->mask);
+	cpumask_clear_cpu(cpu, &incoming->mask);
+	cpumask_clear_cpu(cpu, &cpu_preserved_mask);
+	cpu_preserved_clean(&cpu_preserved_mask);
+	set_cpu_present(cpu, true);
+
+	if (ser)
+		WRITE_ONCE(ser->workload, 0);
+
+	if (pcpu) {
+		stack_pa = pcpu->stack_pa;
+		memset(pcpu, 0, sizeof(*pcpu));
+	}
+
+	cpu_preserved_free_stack(stack_pa, is_incoming);
+
+	/* @pcpu and @ser point into these arrays: do not touch past this point. */
+	cpu_preserved_state_cleanup(outgoing, false);
+	cpu_preserved_state_cleanup(incoming, true);
+
+	if (cpumask_empty(&cpu_preserved_mask)) {
+		WRITE_ONCE(cpu_preserved_pcpus_va, NULL);
+		WRITE_ONCE(cpu_preserved_host_pcpus_va, NULL);
+		cpu_preserved_clean(&cpu_preserved_pcpus_va);
+		cpu_preserved_clean(&cpu_preserved_host_pcpus_va);
+	}
+
+	cpu_preserved_sync_global_ser();
+}
+
+/**
+ * cpu_unpreserve - Unpreserve a physical CPU and restore it to online state
+ * @cpu: Logical CPU identifier.
+ *
+ * Signals the CPU to exit the parking loop, cleans up preserved stack memory,
+ * and restores the core to host scheduling via standard add_cpu().
+ */
+static void cpu_unpreserve(unsigned int cpu)
+{
+	int ret;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		if (!cpu_is_preserved(cpu))
+			return;
+
+		cpu_signal_exit(cpu);
+		arch_cpu_preserved_kick(cpu);
+	}
+
+	/*
+	 * cpu_wait_dead() busy-polls for up to 20 seconds.  Do not hold
+	 * cpu_preserved_lock across it: the poll only reads pcpu->state, which
+	 * stays valid for as long as the CPU is preserved, and holding the lock
+	 * here would stall every other preservation operation and every sysfs
+	 * reader for the entire window.
+	 */
+	if (cpu_wait_dead(cpu))
+		return;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		if (!cpu_is_preserved(cpu))
+			return;
+
+		__cpu_unpreserve_locked(cpu);
+	}
+
+	ret = add_cpu(cpu);
+	if (ret < 0)
+		pr_err("Failed to bring unpreserved cpu %u back online: %d\n",
+		       cpu, ret);
+}
+
+/*
+ * FLB Ops for Preserved CPUs
+ */
+static int cpu_preserved_flb_preserve(struct liveupdate_flb_op_args *argp)
+{
+	unsigned int nr_words = BITS_TO_U64(nr_cpu_ids);
+	struct cpu_preserved_global_ser *ser;
+	size_t ser_sz;
+	int ret;
+
+	ret = cpu_preserved_init_runtime_buffer();
+	if (ret)
+		return ret;
+
+	ser_sz = struct_size(ser, cpu_preserved_bitmap, nr_words);
+
+	mutex_lock(&cpu_preserved_lock);
+	ser = kho_alloc_preserve(ser_sz);
+	if (IS_ERR(ser)) {
+		mutex_unlock(&cpu_preserved_lock);
+		return PTR_ERR(ser);
+	}
+
+	memset(ser, 0, ser_sz);
+	ser->nr_cpu_words = nr_words;
+	cpu_preserved_global_ser = ser;
+	cpu_preserved_sync_global_ser();
+	mutex_unlock(&cpu_preserved_lock);
+
+	argp->data = virt_to_phys(ser);
+	argp->obj = ser;
+	return 0;
+}
+
+static void cpu_preserved_flb_unpreserve(struct liveupdate_flb_op_args *argp)
+{
+	struct cpu_preserved_global_ser *ser;
+
+	if (!argp->data)
+		return;
+
+	ser = phys_to_virt(argp->data);
+	mutex_lock(&cpu_preserved_lock);
+	cpu_preserved_global_ser = NULL;
+	mutex_unlock(&cpu_preserved_lock);
+
+	cpu_preserved_unpreserve_runtime_buffer();
+	kho_unpreserve_free(ser);
+}
+
+static int cpu_preserved_flb_retrieve(struct liveupdate_flb_op_args *argp)
+{
+	struct cpu_preserved_global_ser *ser;
+	struct cpu_preserved_pcpu_ser *pcpus;
+	u64 nr_bits;
+	int cpu;
+
+	if (!argp->data)
+		return -EINVAL;
+
+	ser = phys_to_virt(argp->data);
+	arch_cpu_preserved_early_init();
+
+	/*
+	 * The outgoing kernel may have been built with a larger NR_CPUS.  Any
+	 * preserved CPU we cannot represent would be silently forgotten and
+	 * left spinning in its park loop forever, so refuse the handover
+	 * instead.
+	 */
+	nr_bits = (u64)ser->nr_cpu_words * BITS_PER_TYPE(u64);
+	if (nr_bits > nr_cpu_ids &&
+	    find_next_bit((const unsigned long *)ser->cpu_preserved_bitmap,
+			  nr_bits, nr_cpu_ids) < nr_bits) {
+		pr_err("preserved CPU above nr_cpu_ids=%u in handover data\n",
+		       nr_cpu_ids);
+		return -ERANGE;
+	}
+
+	mutex_lock(&cpu_preserved_lock);
+	bitmap_from_arr64(cpumask_bits(&cpu_preserved_mask),
+			  ser->cpu_preserved_bitmap, min_t(u64, nr_bits, nr_cpu_ids));
+	cpumask_copy(&cpu_preserved_incoming.mask, &cpu_preserved_mask);
+	pcpus = KHOSER_LOAD_PTR(ser->pcpus_runtime);
+
+	if (pcpus) {
+		cpu_preserved_incoming.pcpus_ser = pcpus;
+		WRITE_ONCE(cpu_preserved_pcpus_va, pcpus);
+		cpu_preserved_clean(&cpu_preserved_pcpus_va);
+	}
+	cpu_preserved_clean(&cpu_preserved_mask);
+	for_each_cpu(cpu, &cpu_preserved_mask)
+		set_cpu_present(cpu, false);
+	mutex_unlock(&cpu_preserved_lock);
+
+	argp->obj = ser;
+	return 0;
+}
+
+static void cpu_preserved_flb_finish(struct liveupdate_flb_op_args *argp)
+{
+	struct cpu_preserved_global_ser *ser;
+
+	if (!argp->obj)
+		return;
+
+	ser = argp->obj;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		if (cpu_preserved_incoming.pcpus_ser) {
+			kho_restore_free(cpu_preserved_incoming.pcpus_ser);
+			cpu_preserved_incoming.pcpus_ser = NULL;
+		}
+		kfree(cpu_preserved_incoming.pcpus);
+		cpu_preserved_incoming.pcpus = NULL;
+	}
+
+	if (ser->text_runtime_pa && ser->text_runtime_size) {
+		unsigned long nr_pages = ser->text_runtime_size >> PAGE_SHIFT;
+		struct page *page = kho_restore_pages(ser->text_runtime_pa, nr_pages);
+
+		if (page) {
+			for (unsigned long i = 0; i < nr_pages; i++)
+				__free_page(page + i);
+		}
+	}
+
+	if (ser->data_runtime_pa && ser->data_runtime_size) {
+		unsigned long nr_pages = ser->data_runtime_size >> PAGE_SHIFT;
+		struct page *page = kho_restore_pages(ser->data_runtime_pa, nr_pages);
+
+		if (page) {
+			for (unsigned long i = 0; i < nr_pages; i++)
+				__free_page(page + i);
+		}
+	}
+
+	kho_restore_free(ser);
+}
+
+static const struct liveupdate_flb_ops cpu_preserved_flb_ops = {
+	.preserve   = cpu_preserved_flb_preserve,
+	.unpreserve = cpu_preserved_flb_unpreserve,
+	.retrieve   = cpu_preserved_flb_retrieve,
+	.finish     = cpu_preserved_flb_finish,
+	.owner      = THIS_MODULE,
+};
+
+static struct liveupdate_flb cpu_preserved_flb = {
+	.ops        = &cpu_preserved_flb_ops,
+	.compatible = CPU_PRESERVED_LUO_FLB_COMPATIBLE,
+};
+
+static int cpu_preserve_reboot_notify(struct notifier_block *nb,
+				      unsigned long action, void *data)
+{
+	int cpu;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		for_each_cpu(cpu, &cpu_preserved_mask) {
+			/*
+			 * If this CPU is not being preserved across an outgoing
+			 * live update, signal it to exit the park loop and
+			 * offline it.
+			 */
+			if (kexec_in_progress && liveupdate_enabled() &&
+			    !cpu_preserved_is_incoming(cpu))
+				continue;
+
+			cpu_signal_exit(cpu);
+			arch_cpu_preserved_kick(cpu);
+			if (cpu_wait_dead(cpu))
+				continue;
+
+			__cpu_unpreserve_locked(cpu);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpu_preserve_reboot_nb = {
+	.notifier_call = cpu_preserve_reboot_notify,
+	.priority = 0,
+};
+
+/**
+ * cpu_preserve_early_init - Early boot registration & retrieval of CPUs
+ *
+ * Registers the preserved CPU file handler and FLB with LUO, retrieves incoming
+ * preserved CPU state prior to secondary SMP bringup, and registers the reboot
+ * notifier.
+ *
+ * Return: 0 on success, or negative error code on failure.
+ */
+static int __init cpu_preserve_early_init(void)
+{
+	void *obj;
+	int err;
+
+	if (!liveupdate_enabled())
+		cpumask_clear(&cpu_preserved_mask);
+	cpumask_clear(&cpu_preserved_outgoing.mask);
+	cpumask_clear(&cpu_preserved_incoming.mask);
+	cpu_preserved_outgoing.pcpus = NULL;
+	cpu_preserved_outgoing.pcpus_ser = NULL;
+	cpu_preserved_incoming.pcpus = NULL;
+	cpu_preserved_incoming.pcpus_ser = NULL;
+	cpu_preserved_global_ser = NULL;
+
+	/* Retrieve incoming preserved CPUs before secondary CPU bringup */
+	if (liveupdate_enabled())
+		liveupdate_flb_get_incoming(&cpu_preserved_flb, &obj);
+
+	register_reboot_notifier(&cpu_preserve_reboot_nb);
+
+	return 0;
+}
+early_initcall(cpu_preserve_early_init);
-- 
2.55.0.1082.g2b9226bbc0-goog

