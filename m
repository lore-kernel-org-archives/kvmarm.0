Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789F027280A
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136537; cv=none; b=gAzY/Pnjio/kZSY3Gp+Q01Mdjs/lNBkiIJNeSZZC+/Qow2Pk7eCWsOu5oVXG13MSjCLUxKxUPZMe9zT7KOe69CgRLNok8GEW+hEGz5dLx18YUhPwyKpiNmZksCMO1ba/jcntp8zfPS1KQPDJ+ZtOtNWZLC0RUpCBmufrmP/37c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136537; c=relaxed/simple;
	bh=5YeKvbzkYv1cKWZ4IAauRzWAggmxhXp5N6n3ll2Xilo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuLY5Cy4x+qVn40p/boNTDAYN+vebC9t7sIjof4HIQACEmc9h2imkZI5EfNWFCTwNhMJr4jtMA3EhZhTf/SjqINLWemoTWSvi0ckEv277gcQR7//KLyUw3TPbVTu5RY0i7JPVJ1a1ZKRxTfypoG3dOUJHgMBRtdnD8pGTBrFs+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A09A1BF3;
	Fri, 14 Nov 2025 08:08:47 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E11C53F5A1;
	Fri, 14 Nov 2025 08:08:52 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 32/35] KVM: Add KVM_EXIT_RLIMIT exit_reason
Date: Fri, 14 Nov 2025 16:07:13 +0000
Message-ID: <20251114160717.163230-33-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Arm CPUs can optionally implement a feature called Statistical Profiling
Extension (SPE). When this feature is in use, a record is created at
certain intervals, with information about the operation that the CPU was
executing when the record was created. This record is then written to a
buffer in memory.

The buffer where records are written is defined by virtual addresses (a
base and a limit). The translation from a buffer virtual address to a
physical address is performed using the CPU's translation tables. If the
Statistical Profiling Unit (SPU) encounters a fault on the CPU's stage 2
during the translation process, profiling stops and the fault is reported
to the CPU asynchronously, via an **interrupt**, not a (synchronous)
exception, like with CPU MMU faults.

The interrupt is delivered to the CPU asynchronously, and operations
executed by the CPU after the SPU asserts the interrupt and before the
CPU receives the interrupt are not sampled by the SPU. This leads to
different sampling profiles between baremetal and a virtual machine when
the same code is executed.

The solution is to pre-fault the memory representing the buffer and pin
it in the host so it doesn't get unmapped from stage 2. Furthermore, the
host memory representing the guest's translation tables for the buffer
virtual addresses must also be pinned, to avoid faults on translation
table walks. The stage 1 tables that map the buffer are programmed by
the guest, and this makes it impossible for KVM to know beforehand how
many levels and how many pages it needs to pin; KVM has this information
only after walking the guest's stage 1 tables, when the running guest
enables the buffer.

Memory pinned by KVM for the buffer must be subject to the RLIMIT_MEMLOCK
limit.  Add a new KVM_RUN exit code for KVM to let userspace know when the
limit has been exceeded, and by how much. Userspace can then decide if they
want to (or can) further increase the limit.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/api.rst | 13 +++++++++++++
 include/uapi/linux/kvm.h       |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 10e0733297ac..2276c4590948 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7318,6 +7318,19 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_RLIMIT */
+		struct {
+			__u64 excess;
+			__u8 rlimit_id;
+		} rlimit;
+
+If the exit_reason is KVM_EXIT_RLIMIT, the VCPU has exceeded a system resource
+limit.  The 'rlimit_id' is set to the resource limit ID (see man 2 getrlimit),
+and the 'excess' field is set to the amount by which the limit was exceeded.
+The unit of measurement is the unit of measurement associated with the resource
+limit.
 
 .. _cap_enable:
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 11e5dbde331b..f27679266197 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
+#define KVM_EXIT_RLIMIT           41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -473,6 +474,11 @@ struct kvm_run {
 				} setup_event_notify;
 			};
 		} tdx;
+		/* KVM_EXIT_RLIMIT */
+		struct {
+			__u64 excess;
+			__u8 rlimit_id;
+		} rlimit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.51.2

