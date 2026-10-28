Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793185676;
	b=ATLFlJSu6cjeSQxZdn78w7br0xqNYq5qRYfxHrLBYbYpfoOwTb8txgiUqYJacRWTnQls
	 m8KNIGBQBmPXcsd0q3bXAZ0vW4CP5mcxKkHj3t8H4GnL8hlY0XMuBNYAZmXHMVwZ58JmL
	 ++nvSEyCK8MJa0D1CNm5ZbE9FXMSYwn3Vym6DdqhfIezAuAHM76+6UWbDY3Eflno5vbcT
	 dDpgLiAV/a/sD6asyfVXSOsOXixL64seioCTi31X0m8YlLlbux/LSO6/lcC2DZYX8ETcL
	 UQFjehxTAZ5HwHTZEpjlShRJgA1JStAeERZfVpjVGdv0SIzc4kjQfvpmFk1ANUMUhZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793185676;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tNuGjVpCCpWRRwNm7lQ2uEnHwZpiJtdBe9DMgOWbUgg=;
	b=iYWTzzcrEOWo4kCzoBsnYXVA/X8JfihGK6JK4jMX+Dhj9iFjTecEZB91zdN3Xxki3M9E
	 NbbL8lnTSWYXelp0JHz7fSNJMNsb26XsGwBqKMVVU2Lul/QOze/HJDKB/KGcCQ8/0NBMU
	 SVl8Ugzo4733H2OSILkD9boZLzkRoz5OURhtaTpmAxQnKj29r4PHXiktOKTJygJllNV7e
	 BTIISE1QSG4KNBZdTdUDTf8csPol0MOJ9nc/wk/fEhAoIratgYX2u0tp/O6yLh5M2Q1ur
	 gTVF33vtlxt5F2oZYdw1saI3m40aO4hTMHR7Ff9kmEqIzHMwCorDMLEECNu64vtk+WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rz79ZAkk;
	arc=none smtp.remote-ip=91.218.175.119
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5F7606A31C
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 11:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D5F7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rz79ZAkk
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=jRMgEeT/ywsGUFgWQfUZIBCXSXNOChhJpeoxPBa3hhY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793185673; v=1; x=1793790473;
 b=rz79ZAkkMbgk9B/hhr/yUdNzCFX4ogETGJH4cJw6do7vaQxu2wtJnBEuOFPrqlRxc2VRAQsr
 or7kdl4DISmotSL4+CilDOfFUYMoc50dm/i9GiEt73pg8STuvGGrWje4B2+crrpvN0RypLnoCTU
 mPi4QfbYcoI0BSQVS/2slAPA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1e1179175c352474;
	Wed, 28 Oct 2026 11:07:53 +0000
X-Mizu-Trace-ID: 1e1179175c352474
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	Oculytic <oculytic@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 2/3] KVM: arm64: Pass the PMU events to the hyp vCPU of non-protected guests
Date: Wed, 28 Oct 2026 11:07:38 +0000
Message-ID: <20261028110739.2366566-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028110739.2366566-1-fuad.tabba@linux.dev>
References: <20261028110739.2366566-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Before every run, the host records in vcpu->arch.pmu.events which perf
counters to disable and enable around guest entry, and
__pmu_switch_to_guest() applies them at EL2. Since commit be66e67f1750
("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()"),
protected mode runs the hyp vCPU instead, and flush_hyp_vcpu() never
copies the events into it. So the counters backing a non-protected
guest's PMU are never enabled, and every counter the guest reads stays
at 0, the cycle counter included. The host's counters that exclude
guests keep counting the guest as well.

Copy the events into the hyp vCPU of a non-protected guest on every run.
The events only exist with CONFIG_HW_PERF_EVENTS, so the copy is built
under it. Like mdcr_el2, they're host-controlled and never reach a
protected guest.

Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Link: https://lore.kernel.org/all/20240305184840.636212-2-oliver.upton@linux.dev/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
[Fuad: non-protected copy only, tested on the hyp vCPU, under
 CONFIG_HW_PERF_EVENTS, new message]
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d715aa942577e..28a292deecb64 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -690,6 +690,16 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 		host_vcpu->arch.external_debug_state = hyp_vcpu->vcpu.arch.external_debug_state;
 }
 
+#ifdef CONFIG_HW_PERF_EVENTS
+static void flush_pmu_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		hyp_vcpu->vcpu.arch.pmu.events = hyp_vcpu->host_vcpu->arch.pmu.events;
+}
+#else
+static void flush_pmu_state(struct pkvm_hyp_vcpu *hyp_vcpu) {}
+#endif
+
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
@@ -698,6 +708,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	fpsimd_sve_flush();
 	flush_debug_state(hyp_vcpu);
+	flush_pmu_state(hyp_vcpu);
 
 	/*
 	 * If we deal with a non-protected guest and the state is potentially
-- 
2.47.3

