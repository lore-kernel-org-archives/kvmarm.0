Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0140346FB3
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 06:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789368706; cv=none; b=Uqbm/5k9e6F3ZmQCE+9kyqn9BpviBVxMlHVg6mxBeje6Xgj7Xh+f3+GgLqZdzE9vNBBXJheeM01c8FmVdtnObdmkAID6GhPXMoMOzy4IrG+KHsNHIRzwE0JKZ4lkUVoOld3Lznva8GsH2C3Zhjq5MtxRVd8dBteL1PPJ7l/7u2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789368706; c=relaxed/simple;
	bh=ImB4OSlH78bkgJyJTPE0uJYasv+aHz+ywNLGej5cQLA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EqSI3cHHJdgLtJHMp0u2WHdRXYWT3BxhT+RMAq41qVtZrHeKOL0K8Hp+uInXLor1PDqqB2qo4jxalFJB17H2v2DUGjCe4Ycwu7SEbx5vhnbMq2RlN20Eat7VConyiBtMHHkq5OOcjVS6vZVFpzANBgbJZ2v+TT6NvAg+UqgitRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I63itf2T; arc=none smtp.client-ip=91.218.175.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I63itf2T"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ImB4OSlH78bkgJyJTPE0uJYasv+aHz+ywNLGej5cQLA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789368702; v=1; x=1789973502;
 b=I63itf2TpHXHRYOL2bejHPSgIL4TyoUH7G9DZFd1ndDP78CzQxq6NIhI6beWg9OY6Q1adCB7
 tdmfuETZll7DBwqMEEJ/OTFZMK0/faMYyFpSs/D+eDOG69L618k4zYrRNyfG15kVdgVYze0oCY2
 aUVvq14una7IyZX5hAJmorI0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9d38ec8ca3f71a61;
	Mon, 14 Sep 2026 06:51:42 +0000
X-Mizu-Trace-ID: 9d38ec8ca3f71a61
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH] KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM
Date: Mon, 14 Sep 2026 07:51:36 +0100
Message-Id: <20260914065136.3418404-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Under pKVM, a page the host shares with EL2 is mapped at EL2 only while
it's pinned, and the host vCPU and its VM are pinned at the vCPU's
first KVM_RUN. KVM_SET_VCPU_EVENTS with ext_dabt_pending reaches
__kvm_adjust_pc() at EL2 before that, and dereferencing the unmapped
host vCPU panics the hypervisor. Any process holding /dev/kvm on a
pKVM host can trigger it.

Pin the host vCPU around the adjustment when no hyp vCPU is loaded for
it, and its VM too, for the MTE flag the exception entry reads. A
loaded hyp vCPU implies both are pinned. A pin fails only for memory
the host never shared, and the request is then dropped like any other
bad host pointer.

Fixes: efa1368ba9f4b ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626adb..e41b4c181eb62 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -539,11 +539,39 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+/*
+ * With no hyp vCPU loaded for it, the host vCPU and its VM may be unpinned,
+ * and so unmapped at EL2: both are pinned from the vCPU's first run, and
+ * KVM_SET_VCPU_EVENTS can reach here before that.
+ */
+static void adjust_pc_unloaded(struct kvm_vcpu *host_vcpu)
+{
+	struct kvm *host_kvm;
+
+	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
+		return;
+
+	/* The exception entry reads the VM's MTE flag. */
+	host_kvm = kern_hyp_va(host_vcpu->kvm);
+	if (!hyp_pin_shared_mem(host_kvm, host_kvm + 1)) {
+		__kvm_adjust_pc(host_vcpu);
+		hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
+	}
+
+	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *host_vcpu;
 
-	__kvm_adjust_pc(kern_hyp_va(vcpu));
+	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
+	if (host_vcpu)
+		__kvm_adjust_pc(host_vcpu);
+	else
+		adjust_pc_unloaded(kern_hyp_va(vcpu));
 }
 
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)

base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

