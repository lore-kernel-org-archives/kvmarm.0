Received: from mta0.migadu.com (out-127.mta0.migadu.com [91.218.175.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C2145198E
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 07:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455868; cv=none; b=S6pmPGai4YuYjjA7s4L8K76WWD+UEaPVvG+wwAbh7zDBdeCvQvh4OPO1UiuhF9xR7hywFYt8beJIeK3tlUO8I11V3UOtQbPG/YOdkFM6ynJZOUYTxODd64aotw7lNTfbNfA4pE6EKpXbZHWYDSFbHCudemAIkkdZWFA8MQ5JqHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455868; c=relaxed/simple;
	bh=TxjB2nuw/omS0r1HuiWJ8ceXglPNuUd+88Xw3+fRY0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cbJmdM/OM6P92/IVlI00G2SRhPInazwCxGY4dNPkj+bQDVrI/TpdyEAV6C4eeDRU1EutzXGY2vE0y2rKdEWnlQkcSGZHGzfoWhCdg1XobECozrTbb5APYTC03eQ6C8mpf0x9z1RURWJVX38f6+bQRD1obiO2QRPAYM4Tt+toeO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RfYBmcS7; arc=none smtp.client-ip=91.218.175.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RfYBmcS7"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=TxjB2nuw/omS0r1HuiWJ8ceXglPNuUd+88Xw3+fRY0o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455864; v=1; x=1790060664;
 b=RfYBmcS79BbKA5YbpkzRHGNMsCdzXRD1HEpL6hdNfl/pGiDHfUrufUgaKXXUPH/IHYRiBT23
 Iwz3Kn12AcPNbXgE1yV2U/XRabVttCjM3d7gNYu+FqlFKxra+ZQ9ca17ZnyJup/oUvuH3mDdPBQ
 Ode+nbxhx5VGh0EOwRXLWuoA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d9900a21abb41ef0;
	Tue, 15 Sep 2026 07:04:24 +0000
X-Mizu-Trace-ID: d9900a21abb41ef0
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
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v2 2/2] KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM
Date: Tue, 15 Sep 2026 08:04:18 +0100
Message-Id: <20260915070418.3209779-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915070418.3209779-1-fuad.tabba@linux.dev>
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Under pKVM, a page the host shares with EL2 is mapped at EL2 only while
it's pinned, and the host vCPU is pinned at its first KVM_RUN.
KVM_SET_VCPU_EVENTS with ext_dabt_pending reaches __kvm_adjust_pc() at
EL2 before that, and dereferencing the unmapped host vCPU panics the
hypervisor. Any process holding /dev/kvm on a pKVM host can trigger it.

Pin the host vCPU around the adjustment when no hyp vCPU is loaded for
it. A loaded hyp vCPU implies it's pinned. A pin fails only for memory
the host never shared, and the request is then dropped like any other
bad host pointer.

Fixes: efa1368ba9f4b ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626adb..4cb7347db2514 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -542,8 +542,25 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *host_vcpu;
 
-	__kvm_adjust_pc(kern_hyp_va(vcpu));
+	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
+	if (host_vcpu) {
+		__kvm_adjust_pc(host_vcpu);
+		return;
+	}
+
+	/*
+	 * With no hyp vCPU loaded for it, the host vCPU may be unpinned,
+	 * and so unmapped at EL2: its first run pins it.
+	 */
+	host_vcpu = kern_hyp_va(vcpu);
+	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
+		return;
+
+	__kvm_adjust_pc(host_vcpu);
+	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
 }
 
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
-- 
2.39.5

