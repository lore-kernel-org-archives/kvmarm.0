Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF3E1EC011
	for <kvmarm@lists.linux.dev>; Fri, 31 Jan 2025 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738362602; cv=none; b=G5jwqfzLbDZI7iUy7GlQk2RvYIn1QHiOilg48lHJDJ6hobjcmQrk7MM0G3KTHISlo39kLOHvx6xDW3PfsEc+Jf1OTtSMy1N2TBzfIIZrT/O0b1kUZAkLDo6+lWXr5+RnKSBPpQLHHsmP0gYvVAXzb7pHsKJcWTJ/Qk6dsTBf25g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738362602; c=relaxed/simple;
	bh=vIsnZFkAZNQUX4M5k5+wwEUbMz3BxSQEYDQ5PUr41rw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h/JsXMzAw1WCECb3HrDVdJAK/p349mVJmTftLmuvmyzj+h6kshppz7dfFXqPYY2+iyCPSioM8oFJBGivnBlPZst0sg8CWfMpZ15Eo5J1zyRyHlHz49EXe6xERK8mvTW6Qj3oPcDKtWr+jw8cum7eRxXOqb2wJjv7f1RqRbxC/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rDPK8Pme; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rDPK8Pme"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738362597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TFYkLpq0/bvCrqY/t5fvUaOC/8WopcK28OFnqaHgl3c=;
	b=rDPK8PmeVux+Jus7fEZCvhcyIpakWo77Wc0HmrYzvth41DcYZdI5mTo83b4dax7SjIXcJE
	m8wMhrHLI2UoUpyraulmIyQ2IHkLpmzgjNSlPmgvk8I/OQvwSZoNCeBYf0axVFb9SAA7Ih
	B8KmIaHzfUnquRcqmocYSV0xvkUrSvY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH] KVM: arm64: Flush/sync debug state in protected mode
Date: Fri, 31 Jan 2025 22:29:24 +0000
Message-ID: <20250131222922.1548780-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The recent changes to debug state management broke self-hosted debug for
guests when running in protected mode, since both the debug owner and
the debug state itself aren't shared with the hyp's view of the vcpu.

Fix it by flushing/syncing the relevant bits with the hyp vcpu.

Fixes: beb470d96cec ("KVM: arm64: Use debug_owner to track if debug regs need save/restore")
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/kvmarm/5f62740f-a065-42d9-9f56-8fb648b9c63f@sirena.org.uk/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5c134520e180..6e12c070832f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -91,11 +91,34 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 }
 
+static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+	hyp_vcpu->vcpu.arch.debug_owner = host_vcpu->arch.debug_owner;
+
+	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
+		hyp_vcpu->vcpu.arch.vcpu_debug_state = host_vcpu->arch.vcpu_debug_state;
+	else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu))
+		hyp_vcpu->vcpu.arch.external_debug_state = host_vcpu->arch.external_debug_state;
+}
+
+static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
+		host_vcpu->arch.vcpu_debug_state = hyp_vcpu->vcpu.arch.vcpu_debug_state;
+	else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu))
+		host_vcpu->arch.external_debug_state = hyp_vcpu->vcpu.arch.external_debug_state;
+}
+
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
 	fpsimd_sve_flush();
+	flush_debug_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
@@ -123,6 +146,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	unsigned int i;
 
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
+	sync_debug_state(hyp_vcpu);
 
 	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
 

base-commit: 9bcbb6104a344d3526e185ee1e7b985509914e90
-- 
2.48.1.362.g079036d154-goog

