Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3E63BB104
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 14:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785076616; cv=none; b=RxA5TomhiwxWyeFxZZYmidkJx1bAPTamF+1n1M6N7OuiqQw1cXe/ivrZFzLENPRiMfsDnk0EzwbwdwMOHJCaLOedQ9dNafpru20darW07fx+HYZVMYb0d0tc0UQxJg28TFGwAnAMvTxtiOT14P6PW3K2dVtwUbuWDpAHwtrthg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785076616; c=relaxed/simple;
	bh=OZ9aPsXg3sKPUupGpV9fYRg+YD59rdzoiice8BCvLMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IewKAtQ/XMa7SlJivvBdF3WrKi1+MM5Drh6oMwXIdILVcIAAPLT7PVsVvc4TJTl6lBZvOKBfBeKKooYTnR2COUxURCVBvXMNnNIT4OUjSwnjNfFIfuthRsc/DiPC/mYTvgh81q7Xq0rpyZmpmGnwWvJct1WD8vpZwsQTCd5L6GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=heo54cw0; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="heo54cw0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785076613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cEqg7VunlhEslY2F0JLU+TRpHug+45n+kFx2sgOCJbc=;
	b=heo54cw00rT64OTcdLCe8bpGs3jOk1lTBVRHrEeruaTF09tvCqWiHoioNmuxn7sTbZMIL6
	bB5VmIayT2VfE06XJZHz+8TcH31QNuQzAe09fRA8T2WNaFua6C9C2kZph2ulMyW0uz0X8q
	pPJKhC9XlJ3mAHu0YmoAdpCoHM7LeZc=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tabba@google.com
Subject: [PATCH 2/2] KVM: arm64: selftests: Add a userspace watchpoint test
Date: Sun, 26 Jul 2026 15:36:43 +0100
Message-Id: <20260726143643.303456-3-fuad.tabba@linux.dev>
In-Reply-To: <20260726143643.303456-1-fuad.tabba@linux.dev>
References: <20260726143643.303456-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

debug-exceptions covers guest self-hosted debug and userspace
single-step, but not a userspace (KVM_GUESTDBG_USE_HW) watchpoint,
whose KVM_EXIT_DEBUG reports the accessed address in debug.arch.far.
Add a test that installs a host-directed write watchpoint and checks
that the reported address matches the accessed variable.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/arm64/debug-exceptions.c    | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
index 3eb4b1b6682dc..7dc5f0b4f6adf 100644
--- a/tools/testing/selftests/kvm/arm64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
@@ -527,6 +527,46 @@ void test_single_step_from_userspace(int test_cnt)
 	kvm_vm_free(vm);
 }
 
+static void guest_code_wp(void)
+{
+	write_data = 'x';
+	GUEST_DONE();
+}
+
+/*
+ * A userspace hardware watchpoint (KVM_GUESTDBG_USE_HW) must fire and report
+ * the accessed address in debug.arch.far, exercising the watchpoint exit path.
+ */
+static void test_watchpoint_from_userspace(void)
+{
+	struct kvm_guest_debug debug = {};
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_wp);
+	run = vcpu->run;
+
+	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW;
+	debug.arch.dbg_wcr[0] = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR |
+				DBGWCR_EL1 | DBGWCR_E;
+	/*
+	 * BAS = 0xff (LEN8) requires a doubleword-aligned DBGWVR; FAR still
+	 * reports the exact accessed byte.
+	 */
+	debug.arch.dbg_wvr[0] = PC(write_data) & ~7UL;
+	vcpu_guest_debug_set(vcpu, &debug);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG,
+		    "Expected KVM_EXIT_DEBUG, got %u", run->exit_reason);
+	TEST_ASSERT((u64)run->debug.arch.far == PC(write_data),
+		    "Watchpoint FAR 0x%lx != accessed address 0x%lx",
+		    (u64)run->debug.arch.far, PC(write_data));
+
+	kvm_vm_free(vm);
+}
+
 /*
  * Run debug testing using the various breakpoint#, watchpoint# and
  * context-aware breakpoint# with the given ID_AA64DFR0_EL1 configuration.
@@ -600,6 +640,7 @@ int main(int argc, char *argv[])
 
 	test_guest_debug_exceptions_all(aa64dfr0);
 	test_single_step_from_userspace(ss_iteration);
+	test_watchpoint_from_userspace();
 
 	return 0;
 }
-- 
2.39.5

