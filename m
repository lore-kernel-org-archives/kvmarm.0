Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60393803E8
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271425; cv=none; b=Kq/eGCMsMuZ+v2TBYCoI+9SWtUrz4+E9YmXA+ngrPtLit9PvpVEduhajSDUi7baXvMpSWKTZhnwN8JqAGRRtz8hOJyL3EHTgAbUhEfe+kj7T1fkrfiHuBDarhc8N8d138QyOoBhxdW+9XCM8ym/cNGfgBmsD19Y23V9FyfZvteg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271425; c=relaxed/simple;
	bh=Xa6Kq1v4hXNOqZBVImzJqeYJPb/TLqmgh6LUUUVzTz0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qws/LUnhsvH35+7vSuy5DTAYGYnKFK8s9jKf8HgxavMxUEI0vTkQT0H7zO88UQbTHScqY2JFOiIjsVCRrvM5+pC78emUjKqS3NFcWLnOaj3iXXUBpJP+vp9KHPCgrkKH64DLYGGyfGO9/y9OWkewAtSN7wsmMuNfsshsLi+KD80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kAkv1oal; arc=none smtp.client-ip=91.218.175.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kAkv1oal"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Xa6Kq1v4hXNOqZBVImzJqeYJPb/TLqmgh6LUUUVzTz0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788271421; v=1; x=1788876221;
 b=kAkv1oalOozkUy+YKVq7fbszCcBvNpxgzII7f0ummXHgRLgCU/wzRRT4Ts7jHnH7sF+h5qX2
 0D7FULNR3aqpdi8xWPXvIK0YfkMoDdHIhO1iwJPwYaiuPx7QBolqS4jMMxjj+82znqT4HdRGnxy
 e7rYw8JSMvEahAucqLXya4ts=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3bdfeb0c7760ac87;
	Tue, 01 Sep 2026 14:03:41 +0000
X-Mizu-Trace-ID: 3bdfeb0c7760ac87
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v4 02/11] KVM: arm64: nVHE: Share the stacktrace per-CPU declarations with EL2
Date: Tue,  1 Sep 2026 15:03:17 +0100
Message-Id: <20260901140326.3812068-3-fuad.tabba@linux.dev>
In-Reply-To: <20260901140326.3812068-1-fuad.tabba@linux.dev>
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The declarations for overflow_stack, kvm_stacktrace_info and
pkvm_stacktrace are only visible to the host (the first two sit in the
host-only section of stacktrace/nvhe.h, the last is private to
kvm/stacktrace.c), so the definitions in nvhe/stacktrace.c compile
with no declaration in sight and sparse suggests making them static.
DECLARE_KVM_NVHE_PER_CPU() resolves to the right symbol name on both
sides of the build: move the declarations where both can see them and
include the header from the EL2 side unconditionally.

No functional change intended.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 10 ++++++++--
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     |  3 +--
 arch/arm64/kvm/stacktrace.c              |  3 ---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 171f9edef49fc..a631a577cbe5d 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -37,6 +37,14 @@ static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
 	state->pc = pc;
 }
 
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
+
+#ifdef CONFIG_PKVM_STACKTRACE
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
+			 pkvm_stacktrace);
+#endif
+
 #ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * Conventional (non-protected) nVHE HYP stack unwinder
@@ -45,8 +53,6 @@ static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
  * (by the host in EL1).
  */
 
-DECLARE_KVM_NVHE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
-DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
 DECLARE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
 
 void kvm_nvhe_dump_backtrace(unsigned long hyp_offset);
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 7c832d60d22bb..11fadbebbf1d6 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -8,6 +8,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/memory.h>
 #include <asm/percpu.h>
+#include <asm/stacktrace/nvhe.h>
 
 DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 	__aligned(16);
@@ -35,8 +36,6 @@ static void hyp_prepare_backtrace(unsigned long fp, unsigned long pc)
 }
 
 #ifdef CONFIG_PKVM_STACKTRACE
-#include <asm/stacktrace/nvhe.h>
-
 DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
 
 static struct stack_info stackinfo_get_overflow(void)
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 9724c320126b7..69377195e18b7 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -198,9 +198,6 @@ static void hyp_dump_backtrace(unsigned long hyp_offset)
 }
 
 #ifdef CONFIG_PKVM_STACKTRACE
-DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
-			 pkvm_stacktrace);
-
 /*
  * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
  *
-- 
2.39.5

