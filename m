Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6954825D2
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933185; cv=none; b=TDUV4itfOjnMj9zd6i2HbIfjFG7ho4Jm7gxn0S/ysDJgWhRDylzx+Y8rm10BmTWoJJwXp6hj6lbVgJykburdYbNtg5j9wCqOgtcxM2xI3nnxLd50Bhi15HyxnylWeVH+AQRH5Hw1LnDU6r9jwztWpzYBoQIuL0tB14uMLOuBk1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933185; c=relaxed/simple;
	bh=3XYUFgji9nVqCwEl6GgtsqIlXAKMxrV/IeiQMZIC5tw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA9W5eIkGdIf+LoA0jVL6gqgyMlCAE98QCLB584aF8H43Si+zLrWmdkD/uT/TXQ+MHuJhAhpwVZKHaqhkurojiaP+Aj2wKC3AL+FfQaCkQpa9AsOo8+r0LoNrt332nyYY1mxMImALoBjwDmZXpYt+gSjXuwknW9GD1Zd7SOe7EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=STM2fH8f; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="STM2fH8f"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4aae3149so1691398d50.2
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933181; x=1790537981; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=66Y5T7Wms+Rut8jGl61fd80OXI19XsyhOKciHeEXim0=;
        b=STM2fH8faR0qK5VZ243ENAgj4q/Br8xpcLCVar+UD3OmGmjEim5uQOQ1WtyXiJqbBY
         KCUwkW/PuZktpQnbYI8tplVcg7ck2cM82jqUwvkJAiGaJxR1Nvq8nzp0ZIRw7CvrHnYc
         JV8hYtK2Rua6ZzlXEbDEtWkJ46gfGWny2OXfskM6++Ummm44MbJ05G832MWJigdOXP9k
         jdpMqM6Rv0PDUhNnkombaAC9YW5IeSxhR5FXZMkwvOFTTHwiO9NgTM3akeZQVP8/eKaY
         Ryks9qpImn5aDKSfWCGV4sQ2T8WVwKDd1JNfdwQrYHbZISGzaxa6OMxfaMpBUlcgQMQ1
         nPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933181; x=1790537981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=66Y5T7Wms+Rut8jGl61fd80OXI19XsyhOKciHeEXim0=;
        b=zgue2pWAt/E0QyGQ35yaRotDEOGy14AxbNite7QdtUIgiLy25lUb97S7Qm3he4lfdf
         3glEAnT4G9WtlaUR/zQicAonbnaaszRwh5ptUy7gC9O7fowaa14J+/8r/grNhKglLAvk
         Jju4RrcEV9mfGRieKrkYFLdoSQot6J312AIT4uHkoa7rimOKMbRWGtpwSANTcPiD8EoF
         +5PcT5u0vy/B+56khrUujwofFoPFa5aeeRFupBDBX3j9klNtaS4RAc30k4aDuUcwJ0fH
         IoE4joTQF7ndRZCuwYbUE1Tk2mZ5sd4cTcnvRrPENBb06WG4OGLEbj8W3voLP1yjiik0
         lyiw==
X-Forwarded-Encrypted: i=1; AKwUvBw5QkbcP8K9snfgtvlMiQQfm6c1FB0sjHxyT8QsuoDmlquN2/zPIUlY747K8tcYmsWIVNHTApc=@lists.linux.dev
X-Gm-Message-State: AFuF++lv9IgaWHPlGSDqwL4X6fgmDW1jlXkIowPfIxbbtt6j52KOJQI9
	MLwd6etQgMhfL+MrJxiaAOIHchYW/8YJdZ3/5a8x4Kj3pISnHob0uqm7ciB6p6cjvSs=
X-Gm-Gg: AYBFou0rEIH1q6kbJFgsZyHE1ZxOrW6QrdupIZtIa2PcufH6Gx3yPCosN3Cd+jRfvTS
	rBo4fmwsOMgPN075/a1vQ20sc6ZI7JHUutkmI0Vin0GUqpYeY5+QGJdalHAHY9WDioKEY++NHGp
	XSUGZnC7rwURICGlI8pqBhRu/Lryx4GG2rsr7DL7uNSzgXbXNJpyt2D04pYmaNkoAVK3TtfcnrV
	PwlcoRc6IkoIGG+RbrjPE/WJzS38vIKVPZdVVQ+85hoW34lResZNZTEivNfGiUacXheWOApFHUM
	VT/1R5E/dG5xmoWc4X7ZDaEBx30Eb4EHWi8SYafLbFXKFIZpNlx9qkBjbnIA/8JCvbUZcHo+Nfa
	HKVC/y3GpemjaxKVy9cg8pke3T3uj8G+SN6Q2LAENjxWO8Ovyu/ZUcoHpQGVvGpxgDKVAsOxbYI
	DLX7US4ATlpf3CiGLt79lN/rzoa6gBPU0ed3Fu4nHh9Q3Yjil/5sw314UQWi/4xpcezAePwR90h
	HffrwoJjIGWHB/+AYHwWzwX8z1+E/WQX37vtOVsaaUk+WGvgN7qX0nkXiD4TCVmvaaaJmztkGSc
	brZdd5363J5ulK2651fzsPIqY2sEBg==
X-Received: by 2002:a05:690e:dc6:b0:671:70d5:da4 with SMTP id 956f58d0204a3-6717fe6d2dfmr2619153d50.98.1789933181050;
        Sun, 20 Sep 2026 12:39:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6729910a52dsm2551781d50.16.2026.09.20.12.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:40 -0700 (PDT)
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
Subject: [RFC PATCH 28/46] KVM: caretaker: Add Caretaker control block and architecture ops headers
Date: Sun, 20 Sep 2026 15:36:32 -0400
Message-ID: <20260920193650.3373435-29-pasha.tatashin@soleen.com>
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

Define struct kvm_caretaker_cb, struct kvm_caretaker_ops, and
KVM_CAP_CARETAKER documentation for OrphanVM on-core execution.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/virt/kvm/api.rst |  16 ++
 include/linux/kho/abi/kvm.h    | 112 ++++++++++-
 include/linux/kvm_caretaker.h  | 341 +++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h       |  10 +
 include/uapi/linux/kvm.h       |   1 +
 5 files changed, 479 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kvm_caretaker.h

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e0430cc750c9..a5c7a48617c3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9600,6 +9600,22 @@ take care to differentiate between these cases.
 The presence of this capability indicates that the nested KVM guest can
 start in ESA mode.
 
+8.48 KVM_CAP_CARETAKER
+----------------------
+
+:Architectures: x86, arm64
+
+This capability, if ``KVM_CHECK_EXTENSION`` returns a non-zero value,
+indicates that the host kernel supports Caretaker on-core guest execution
+across kexec-based host live updates.
+
+When both a vCPU file descriptor and its backing physical CPU's preservation
+file descriptor (``/sys/devices/system/cpu/cpuX/preserve``) are preserved in a
+Live Update Orchestrator (LUO) session, KVM schedules the vCPU to continue
+executing on-core within the preserved Caretaker environment throughout the
+host kexec transition, rather than pausing vCPU execution until the incoming
+kernel re-attaches.
+
 9. Known KVM API problems
 =========================
 
diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
index 166a0a2f13c8..85fafb786747 100644
--- a/include/linux/kho/abi/kvm.h
+++ b/include/linux/kho/abi/kvm.h
@@ -30,10 +30,12 @@
 
 /**
  * struct kvm_luo_ser - Main serialization structure for a KVM VM.
- * @type:         The type of VM.
+ * @type:       The type of VM.
+ * @kho_folios: Preservation pointer to VM-wide KHO-preserved folios.
  */
 struct kvm_luo_ser {
 	u64 type;
+	DECLARE_KHOSER_PTR(kho_folios, struct kvm_kho_folios_ser *);
 } __packed;
 
 /* The compatibility string for KVM VM file handler */
@@ -47,18 +49,126 @@ enum kvm_vcpu_luo_flags {
 	KVM_VCPU_LUO_FLAG_CARETAKER = BIT(0),
 };
 
+/**
+ * enum kvm_caretaker_pcpu - Special Caretaker physical CPU identifiers
+ * @KVM_CARETAKER_INVALID_PCPU: Unassigned physical CPU identifier.
+ */
+enum kvm_caretaker_pcpu {
+	KVM_CARETAKER_INVALID_PCPU = U32_MAX,
+};
+
+/**
+ * enum kvm_caretaker_state - Caretaker vCPU execution state machine
+ * @KVM_CARETAKER_PAUSED:   Initial state upon preservation and between
+ *                          oncore_sched time-sharing quantums (or when parked
+ *                          after an unhandled VM exit).  Live architectural
+ *                          state is fully serialized in @arch_state.
+ * @KVM_CARETAKER_RUNNING:  Actively executing a time-sharing quantum on the
+ *                          preserved physical CPU.  Hardware registers and
+ *                          VMCS/VMCB/EL2 state are live on silicon; @arch_state
+ *                          in memory is stale until the quantum exits.
+ * @KVM_CARETAKER_STOPPING: Host requested reclaim while in
+ *                          %KVM_CARETAKER_RUNNING and sent a physical IPI kick.
+ *                          Caretaker will exit guest mode, serialize live
+ *                          hardware state into @arch_state, and transition to
+ *                          %KVM_CARETAKER_STOPPED.
+ * @KVM_CARETAKER_STOPPED:  Terminal state.  Caretaker execution has permanently
+ *                          ceased and @arch_state is valid in memory.  Reached
+ *                          either directly via host cmpxchg from
+ *                          %KVM_CARETAKER_PAUSED, or by the preserved CPU from
+ *                          %KVM_CARETAKER_STOPPING after serialization completes.
+ *
+ * State transitions are coordinated locklessly via atomic cmpxchg(&cb->state):
+ *   - Each scheduler quantum on the preserved CPU transitions
+ *     %KVM_CARETAKER_PAUSED -> %KVM_CARETAKER_RUNNING on entry and
+ *     %KVM_CARETAKER_RUNNING -> %KVM_CARETAKER_PAUSED after serializing guest
+ *     state on quantum exit.
+ *   - When host KVM reclaims the vCPU (kvm_caretaker_wait_for_attach()):
+ *     1. If @cb->state is %KVM_CARETAKER_PAUSED, host atomically transitions it
+ *        to %KVM_CARETAKER_STOPPED in 0 ns; if the preserved CPU later attempts
+ *        to start a quantum, its cmpxchg(%KVM_CARETAKER_PAUSED ->
+ *        %KVM_CARETAKER_RUNNING) fails and it immediately exits.
+ *     2. If @cb->state is %KVM_CARETAKER_RUNNING, host atomically transitions
+ *        it to %KVM_CARETAKER_STOPPING, sends an IPI to preempt guest mode, and
+ *        spins until the preserved CPU finishes detach_serialize() and stores
+ *        %KVM_CARETAKER_STOPPED.
+ */
+enum kvm_caretaker_state {
+	KVM_CARETAKER_PAUSED = 0,
+	KVM_CARETAKER_RUNNING = 1,
+	KVM_CARETAKER_STOPPING = 2,
+	KVM_CARETAKER_STOPPED = 3,
+};
+
+/**
+ * struct kvm_caretaker_telemetry_ser - Serialized Caretaker execution telemetry
+ * @total_runs: Total guest entry attempts across Caretaker quantums.
+ * @total_exits: Total VM exits decoded during Caretaker execution.
+ * @stall_count: Number of times Caretaker exited due to stall or error.
+ * @last_exit_reason: Raw architecture exit reason of most recent VM exit.
+ * @last_exit_rip: Guest instruction pointer at most recent VM exit.
+ * @stall_exit_reason: Raw architecture exit reason or error at stall.
+ * @stall_exit_rip: Guest instruction pointer at stall.
+ */
+struct kvm_caretaker_telemetry_ser {
+	u64 total_runs;
+	u64 total_exits;
+	u64 stall_count;
+	u64 last_exit_reason;
+	u64 last_exit_rip;
+	u64 stall_exit_reason;
+	u64 stall_exit_rip;
+} __packed;
+
+/**
+ * struct kvm_kho_folios_ser - Serialized list of KHO-preserved folios for a VM
+ * @nr_folios: Number of physical folio addresses in @folios_pa.
+ * @folios_pa: Physical addresses of folios preserved via kho_preserve_folio().
+ */
+struct kvm_kho_folios_ser {
+	u64 nr_folios;
+	u64 folios_pa[];
+} __packed;
+
+/**
+ * struct kvm_caretaker_cb_ser - KVM Caretaker Control Block
+ * @state:     Current Caretaker execution state (enum kvm_caretaker_state).
+ * @pcpu_id:   Physical CPU ID where this vCPU runs while in Caretaker.
+ * @vcpu_id:   Guest vCPU identifier.
+ * @reserved:  Must be zero.
+ * @telemetry: Preservation pointer to Caretaker execution telemetry.
+ *
+ * Coordinates vCPU execution state across hypervisor detachment,
+ * live update, and Caretaker CPU preservation.
+ */
+struct kvm_caretaker_cb_ser {
+	u32 state;
+	u32 pcpu_id;
+	u32 vcpu_id;
+	u32 reserved;
+	DECLARE_KHOSER_PTR(telemetry, struct kvm_caretaker_telemetry_ser *);
+} __packed;
+
 /**
  * struct kvm_vcpu_ser - Main serialization structure for a KVM vCPU.
  * @vcpu_id:    The ID of the virtual CPU.
  * @flags:      Flags for vCPU preservation.
  * @vm_token:   Token of the associated KVM VM instance.
  * @arch_state: Preservation pointer to vCPU architectural state.
+ * @cb:         Preservation pointer to Caretaker Control Block.
+ *
+ * Cross-kexec invariant: the incoming kernel may only dereference structures
+ * declared in include/linux/kho/abi/ headers.  When @flags includes
+ * %KVM_VCPU_LUO_FLAG_CARETAKER, the preserved Caretaker text writes live guest
+ * state into @arch_state at detach time before transitioning @cb to
+ * %KVM_CARETAKER_STOPPED; the incoming kernel reads only @cb and @arch_state.
  */
 struct kvm_vcpu_ser {
 	u32 vcpu_id;
 	u32 flags;
 	u64 vm_token;
 	DECLARE_KHOSER_PTR(arch_state, struct kvm_vcpu_arch_ser *);
+	DECLARE_KHOSER_PTR(cb, struct kvm_caretaker_cb_ser *);
 } __packed;
 
 /* The compatibility string for KVM vCPU file handler */
diff --git a/include/linux/kvm_caretaker.h b/include/linux/kvm_caretaker.h
new file mode 100644
index 000000000000..3e89738d7fdf
--- /dev/null
+++ b/include/linux/kvm_caretaker.h
@@ -0,0 +1,341 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Header for common KVM Caretaker framework across architectures.
+ */
+#ifndef __LINUX_KVM_CARETAKER_H
+#define __LINUX_KVM_CARETAKER_H
+
+#include <linux/types.h>
+#include <linux/kho/abi/kvm.h>
+
+struct kvm_vcpu;
+struct kvm_vcpu_ser;
+struct liveupdate_session;
+
+/**
+ * enum kvm_caretaker_exit_type - Normalized cross-architecture VM exit classification
+ * @KVM_CARETAKER_EXIT_UNKNOWN:       Unclassified exit; treated as unhandled stall.
+ * @KVM_CARETAKER_EXIT_IDLE:          Guest idle instruction (HLT, PAUSE, WFI, WFE).
+ * @KVM_CARETAKER_EXIT_CONSOLE:       Early console port I/O or MMIO access.
+ * @KVM_CARETAKER_EXIT_PREEMPT_TIMER: Hardware quantum preemption timer expired.
+ * @KVM_CARETAKER_EXIT_CROSS_VCPU:    Cross-vCPU notification or IPI (e.g., SGI).
+ * @KVM_CARETAKER_EXIT_INSN_STEP:     Instruction emulated by decode; advance RIP/PC.
+ * @KVM_CARETAKER_EXIT_ARCH:          Architecture-specific exit routed to @handle_arch_exit.
+ * @KVM_CARETAKER_EXIT_UNHANDLED:     Exit requiring full KVM/VMM; stalls the vCPU.
+ */
+enum kvm_caretaker_exit_type {
+	KVM_CARETAKER_EXIT_UNKNOWN = 0,
+	KVM_CARETAKER_EXIT_IDLE,
+	KVM_CARETAKER_EXIT_CONSOLE,
+	KVM_CARETAKER_EXIT_PREEMPT_TIMER,
+	KVM_CARETAKER_EXIT_CROSS_VCPU,
+	KVM_CARETAKER_EXIT_INSN_STEP,
+	KVM_CARETAKER_EXIT_ARCH,
+	KVM_CARETAKER_EXIT_UNHANDLED,
+};
+
+/**
+ * struct kvm_caretaker_exit - Normalized cross-architecture VM exit representation
+ * @type:       Normalized exit classification (&enum kvm_caretaker_exit_type).
+ * @rip:        Guest instruction pointer (RIP on x86, PC on arm64) at exit.
+ * @insn_len:   Length in bytes of the trapping instruction.
+ * @raw_reason: Raw hardware exit code (VMX exit reason, SVM exit code, or ESR_EL2).
+ * @mmio_io:    Decoded port I/O or MMIO access parameters.
+ * @msr:        Decoded x86 MSR read/write parameters.
+ * @sgi:        Decoded arm64 GICv3 Software Generated Interrupt parameters.
+ */
+struct kvm_caretaker_exit {
+	enum kvm_caretaker_exit_type type;
+	u64 rip;
+	u32 insn_len;
+	u64 raw_reason;
+	union {
+		struct {
+			u64 addr;
+			u64 val;
+			u64 *val_ptr;
+			u32 size;
+			bool is_write;
+			bool is_mmio;
+		} mmio_io;
+		struct {
+			u32 msr;
+			u64 val;
+			bool is_write;
+		} msr;
+		struct {
+			u32 sgi_id;
+			u64 target_mask;
+		} sgi;
+	};
+};
+
+struct kvm_caretaker_vcpu;
+
+/**
+ * struct kvm_caretaker_ops - Architecture operations vector for Caretaker vCPU execution
+ * @enter_guest:      Perform low-level hardware guest entry (VMLAUNCH/VMRESUME,
+ *                    VMRUN, or EL2 ERET). Returns 0 on guest exit, or non-zero
+ *                    on entry failure.
+ * @decode_exit:      Read hardware exit registers and populate @exit.
+ * @handle_arch_exit: Emulate an architecture-specific exit (@exit). Returns
+ *                    %true if handled (and updates @exit->rip if needed), or
+ *                    %false to stall the vCPU until the incoming kernel attaches.
+ * @advance_rip:      Write updated @next_rip back into hardware guest state.
+ * @arm_timer:        Program hardware preemption timer to fire at @deadline_ticks
+ *                    (or disarm if @deadline_ticks is 0).
+ * @disarm_timer:     Disarm the hardware preemption timer after leaving the loop.
+ * @pre_run:          Optional per-quantum setup hook invoked before guest entry.
+ * @post_run:         Optional per-quantum teardown hook invoked after leaving
+ *                    the guest loop.
+ */
+struct kvm_caretaker_ops {
+	int (*enter_guest)(void *vcpu_data);
+	void (*decode_exit)(void *vcpu_data, struct kvm_caretaker_exit *exit);
+	bool (*handle_arch_exit)(void *vcpu_data, struct kvm_caretaker_exit *exit);
+	void (*advance_rip)(void *vcpu_data, u64 next_rip);
+	void (*arm_timer)(void *vcpu_data, u64 deadline_ticks);
+	void (*disarm_timer)(void *vcpu_data);
+	void (*pre_run)(void *vcpu_data);
+	void (*post_run)(void *vcpu_data);
+};
+
+/**
+ * struct kvm_caretaker_vcpu - Common per-vCPU Caretaker runtime descriptor
+ * @cb:        Pointer to KHO-preserved Caretaker control block (&struct kvm_caretaker_cb_ser).
+ * @ops:       Architecture operations vector (&struct kvm_caretaker_ops).
+ * @arch_data: Architecture-specific runtime context passed to @ops callbacks.
+ */
+struct kvm_caretaker_vcpu {
+	struct kvm_caretaker_cb_ser *cb;
+	const struct kvm_caretaker_ops *ops;
+	void *arch_data;
+};
+
+struct kvm_kho_folios_ser *kvm_kho_folios_alloc(unsigned int max_folios);
+void kvm_kho_folios_unpreserve(struct kvm_kho_folios_ser *folios);
+void kvm_kho_folios_finish(struct kvm_kho_folios_ser *folios);
+
+#ifdef CONFIG_KVM_CARETAKER
+
+#include <linux/cpu_preserve.h>
+#include <linux/oncore.h>
+
+#define __caretaker_text __cpu_preserved_text
+#define __caretaker_data __cpu_preserved_data
+
+struct dentry;
+struct oncore_session;
+
+/**
+ * struct kvm_vcpu_caretaker - Host-side Caretaker state embedded in struct kvm_vcpu
+ * @cb:             Pointer to the KHO-preserved Caretaker control block while
+ *                  preserved, or %NULL when executing normally under KVM.
+ * @job:            On-Core scheduler job handle for this vCPU, or %NULL.
+ * @last_telemetry: Snapshot of @cb->telemetry captured upon re-attachment.
+ */
+struct kvm_vcpu_caretaker {
+	struct kvm_caretaker_cb_ser		*cb;
+	struct oncore_job			*job;
+	struct kvm_caretaker_telemetry_ser	last_telemetry;
+};
+
+/**
+ * kvm_caretaker_is_stopped - Check whether a Caretaker control block is stopped
+ * @cb: Caretaker control block (may be %NULL).
+ *
+ * Return: %true if @cb is %NULL or in state %KVM_CARETAKER_STOPPED, %false otherwise.
+ */
+static inline bool kvm_caretaker_is_stopped(const struct kvm_caretaker_cb_ser *cb)
+{
+	return !cb || smp_load_acquire(&cb->state) == KVM_CARETAKER_STOPPED;
+}
+
+/**
+ * kvm_caretaker_pause - Transition a Caretaker control block to PAUSED state
+ * @cb: Caretaker control block.
+ *
+ * Publishes %KVM_CARETAKER_PAUSED with release semantics so a preserved CPU
+ * can claim the vCPU for on-core execution.
+ */
+static inline void kvm_caretaker_pause(struct kvm_caretaker_cb_ser *cb)
+{
+	/* Pairs with smp_load_acquire() in caretaker loop */
+	smp_store_release(&cb->state, KVM_CARETAKER_PAUSED);
+}
+
+/**
+ * kvm_caretaker_stop - Transition a Caretaker control block to STOPPED state
+ * @cb: Caretaker control block.
+ *
+ * Publishes %KVM_CARETAKER_STOPPED with release semantics once the vCPU has
+ * detached from Caretaker execution.
+ */
+static inline void kvm_caretaker_stop(struct kvm_caretaker_cb_ser *cb)
+{
+	/* Pairs with smp_load_acquire() in caretaker loop */
+	smp_store_release(&cb->state, KVM_CARETAKER_STOPPED);
+}
+
+bool kvm_caretaker_vcpu_is_attached(struct kvm_vcpu *vcpu);
+void kvm_caretaker_init_common_vcpu(struct kvm_caretaker_vcpu *cvcpu,
+				    struct kvm_caretaker_cb_ser *cb,
+				    struct kvm_vcpu *vcpu,
+				    void *runtime_va,
+				    size_t runtime_size,
+				    const struct kvm_caretaker_ops *ops,
+				    void *arch_data);
+bool kvm_caretaker_should_exit(struct kvm_caretaker_vcpu *cvcpu);
+enum oncore_exit_reason
+kvm_caretaker_vcpu_run(struct kvm_caretaker_vcpu *cvcpu, u64 deadline_ticks);
+int kvm_caretaker_wait_for_attach(struct kvm_caretaker_cb_ser *cb, int pcpu);
+void kvm_caretaker_post_attach_vcpu(struct kvm_vcpu *vcpu);
+
+/**
+ * kvm_arch_vcpu_caretaker_run - Architecture entry point for Caretaker vCPU run
+ * @data:           Pointer to KHO-preserved Caretaker control block
+ *                  (&struct kvm_caretaker_cb_ser) embedded in the architecture
+ *                  runtime page.
+ * @deadline_ticks: Hardware counter deadline (TSC on x86, CNTPCT on arm64) at
+ *                  which the current scheduling quantum expires, or 0 if
+ *                  unbounded.
+ *
+ * Invoked by the On-Core scheduler loop on a preserved physical CPU during the
+ * kexec handover window.  Atomically transitions the vCPU from
+ * %KVM_CARETAKER_PAUSED to %KVM_CARETAKER_RUNNING, switches to Caretaker host
+ * state and isolated page tables, invokes kvm_caretaker_vcpu_run(), and
+ * serializes updated guest registers back to KHO memory upon exit.
+ *
+ * Context: Runs in __cpu_preserved_text with local interrupts disabled.
+ * Return: &enum oncore_exit_reason indicating why the vCPU yielded the core.
+ */
+enum oncore_exit_reason
+kvm_arch_vcpu_caretaker_run(void *data, u64 deadline_ticks);
+
+/**
+ * kvm_arch_vcpu_luo_pre_retrieve_caretaker - Signal Caretaker vCPU to stop and serialize
+ * @vcpu: Incoming or cancelled-handover KVM vCPU structure.
+ * @ser:  Serialized KHO vCPU metadata.
+ *
+ * Signals the preserved physical CPU executing this vCPU in Caretaker to exit
+ * guest mode, serialize live guest hardware state into @ser->arch_state, and
+ * transition to %KVM_CARETAKER_STOPPED.  Must run before
+ * kvm_arch_vcpu_luo_retrieve() reads @ser->arch_state.
+ */
+void kvm_arch_vcpu_luo_pre_retrieve_caretaker(struct kvm_vcpu *vcpu,
+					      struct kvm_vcpu_ser *ser);
+
+/**
+ * kvm_arch_vcpu_luo_attach_caretaker - Complete architecture vCPU attachment after retrieve
+ * @vcpu: Incoming kernel vCPU structure being restored.
+ * @ser:  Serialized KHO vCPU metadata containing the Caretaker control block PA.
+ *
+ * Runs after kvm_arch_vcpu_luo_retrieve() has restored @ser->arch_state into
+ * @vcpu; synchronizes architecture-specific hardware state (VMCS/VMCB/VGIC and
+ * emulated UART/timer state) from the preserved Caretaker page and completes
+ * attachment via kvm_caretaker_post_attach_vcpu().
+ */
+void kvm_arch_vcpu_luo_attach_caretaker(struct kvm_vcpu *vcpu,
+					struct kvm_vcpu_ser *ser);
+
+int kvm_caretaker_vcpu_pre_preserve(struct kvm_vcpu *vcpu,
+				    struct liveupdate_session *session,
+				    struct kvm_vcpu_ser *ser);
+int kvm_caretaker_vcpu_post_preserve(struct kvm_vcpu *vcpu,
+				     struct liveupdate_session *session,
+				     struct kvm_vcpu_ser *ser,
+				     int arch_err);
+void kvm_caretaker_vcpu_pre_retrieve(struct kvm_vcpu *vcpu,
+				     struct kvm_vcpu_ser *ser);
+void kvm_caretaker_vcpu_retrieve(struct kvm_vcpu *vcpu,
+				 struct kvm_vcpu_ser *ser);
+void kvm_caretaker_vcpu_unpreserve(struct kvm_vcpu *vcpu,
+				   struct liveupdate_session *session,
+				   struct kvm_vcpu_ser *ser);
+void kvm_caretaker_vcpu_finish(struct kvm_vcpu *vcpu,
+			       struct liveupdate_session *session,
+			       struct kvm_vcpu_ser *ser);
+
+#else /* !CONFIG_KVM_CARETAKER */
+
+#define __caretaker_text
+#define __caretaker_data
+
+static inline bool kvm_caretaker_is_stopped(const struct kvm_caretaker_cb_ser *cb)
+{
+	return true;
+}
+
+static inline void kvm_caretaker_pause(struct kvm_caretaker_cb_ser *cb) {}
+
+static inline void kvm_caretaker_stop(struct kvm_caretaker_cb_ser *cb) {}
+
+static inline bool kvm_caretaker_vcpu_is_attached(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
+
+static inline void kvm_caretaker_vm_pre_retrieve(void) {}
+
+static inline int kvm_caretaker_vcpu_pre_preserve(struct kvm_vcpu *vcpu,
+						  struct liveupdate_session *session,
+						  struct kvm_vcpu_ser *ser)
+{
+	return 0;
+}
+
+static inline int kvm_caretaker_vcpu_post_preserve(struct kvm_vcpu *vcpu,
+						   struct liveupdate_session *session,
+						   struct kvm_vcpu_ser *ser,
+						   int arch_err)
+{
+	return arch_err;
+}
+
+static inline void kvm_caretaker_init_common_vcpu(struct kvm_caretaker_vcpu *cvcpu,
+						  struct kvm_caretaker_cb_ser *cb,
+						 struct kvm_vcpu *vcpu,
+						 void *runtime_va,
+						 size_t runtime_size,
+						 const struct kvm_caretaker_ops *ops,
+						 void *arch_data) {}
+
+static inline bool kvm_caretaker_should_exit(struct kvm_caretaker_vcpu *cvcpu)
+{
+	return true;
+}
+
+static inline int kvm_caretaker_wait_for_attach(struct kvm_caretaker_cb_ser *cb, int pcpu,
+						void (*arch_kick)(int pcpu))
+{
+	return 0;
+}
+
+static inline void kvm_caretaker_post_attach_vcpu(struct kvm_vcpu *vcpu) {}
+
+static inline void kvm_arch_vcpu_luo_pre_retrieve_caretaker(struct kvm_vcpu *vcpu,
+							    struct kvm_vcpu_ser *ser) {}
+
+static inline void kvm_arch_vcpu_luo_attach_caretaker(struct kvm_vcpu *vcpu,
+						      struct kvm_vcpu_ser *ser) {}
+
+static inline void kvm_caretaker_vcpu_pre_retrieve(struct kvm_vcpu *vcpu,
+						   struct kvm_vcpu_ser *ser) {}
+
+static inline void kvm_caretaker_vcpu_retrieve(struct kvm_vcpu *vcpu,
+					       struct kvm_vcpu_ser *ser) {}
+
+static inline void kvm_caretaker_vcpu_unpreserve(struct kvm_vcpu *vcpu,
+						 struct liveupdate_session *session,
+						 struct kvm_vcpu_ser *ser) {}
+
+static inline void kvm_caretaker_vcpu_finish(struct kvm_vcpu *vcpu,
+					     struct liveupdate_session *session,
+					     struct kvm_vcpu_ser *ser) {}
+
+#endif /* CONFIG_KVM_CARETAKER */
+
+#endif /* __LINUX_KVM_CARETAKER_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 643b941286c2..aca3c41346fb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -44,6 +44,7 @@
 
 #include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
+#include <linux/kvm_caretaker.h>
 
 #ifndef KVM_MAX_VCPU_IDS
 #define KVM_MAX_VCPU_IDS KVM_MAX_VCPUS
@@ -398,6 +399,9 @@ struct kvm_vcpu {
 	 */
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
+#ifdef CONFIG_KVM_CARETAKER
+	struct kvm_vcpu_caretaker caretaker;
+#endif
 };
 
 /*
@@ -887,6 +891,12 @@ struct kvm {
 	 * RCU (e.g. via get_file_active() to prevent ABA races).
 	 */
 	struct file __rcu *vm_file;
+#endif
+#ifdef CONFIG_LIVEUPDATE
+	struct kvm_kho_folios_ser *kho_folios;
+#endif
+#ifdef CONFIG_KVM_CARETAKER
+	void *caretaker_vm;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b1754050681..1042cff30fef 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1000,6 +1000,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PPC_COMPAT_CAPS 250
 #define KVM_CAP_ARM_PMU_V3_STRICT 251
 #define KVM_CAP_VCPU_PRESERVE 252
+#define KVM_CAP_CARETAKER 253
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.55.0.1082.g2b9226bbc0-goog

