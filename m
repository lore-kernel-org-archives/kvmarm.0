Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ECB28C2C8
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 23:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748646404; cv=none; b=WLf4g92Na3IWEQ2ql8iS0OdrjBs3V/wjY0nuQ2JUjc86HhG3qQ0n6xuZI8yz49GkSidyCotilG7vA41ovQXtonQoj2EOh6q0bjQL8sNA7HL8c1xhUpvwfmKR5/0d3SX4vG01M+7S6d4qeM2dMaWR415P2DH6vUmcfM/o4zvNZkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748646404; c=relaxed/simple;
	bh=OPv8a2sTnYU34NsbBsQCNiGkigIfjMJzJhilLcmsEl4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BP1RwEYloeG4FzTqAddk3NGgMtgmsO+n5n84wPGfOMMVBjCpSXTN+96MILUsLbXCcpSlukH1ZuGGnjaXCfRBLCOLpcY+EHG91PeEr4wb2v5AlvmQVG0uk/plu6731RA1Z4yEbmiIOu+XYiK8im4LzA+ZUgKYDlkCoM76AwME8Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hukurWYY; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hukurWYY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748646397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=873/ITE1UNmhWlicumSZjEv1ETdDBohwp9fJ0fraMpQ=;
	b=hukurWYYflMFNRBCZXXxXKikk0FpiiXMAzb1hZSJqI/HlXp4+eP0agngXGe28GcDpRJB4J
	BFfGas34A+/BsVwvDXW0zaPa8o9p4g6OZSZ0IlVrOTKrz6prBc0Il/JJYOz5+nMcpSu6Vp
	+j5WacF14r2yojfvRWWUW/5V5NrNL3k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/4] KVM: arm64: nv: Ensure Address size faults affect correct ESR
Date: Fri, 30 May 2025 16:06:21 -0700
Message-Id: <20250530230623.650888-3-oliver.upton@linux.dev>
In-Reply-To: <20250530230623.650888-1-oliver.upton@linux.dev>
References: <20250530230623.650888-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

For historical reasons, Address size faults are first injected into the
guest as an SEA and ESR_EL1 is subsequently modified to reflect the
correct FSC. Of course, when dealing with a vEL2 this should poke
ESR_EL2.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 3e61fa0a721b..d45424e3e0ff 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -177,6 +177,8 @@ int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned long addr, esr;
+	int esr_elx;
+
 
 	addr  = kvm_vcpu_get_fault_ipa(vcpu);
 	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
@@ -194,9 +196,14 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
 		return;
 
-	esr = vcpu_read_sys_reg(vcpu, ESR_EL1);
+	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC)))
+		esr_elx = ESR_EL2;
+	else
+		esr_elx = ESR_EL1;
+
+	esr = vcpu_read_sys_reg(vcpu, esr_elx);
 	esr &= ~GENMASK_ULL(5, 0);
-	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+	vcpu_write_sys_reg(vcpu, esr, esr_elx);
 }
 
 /**
-- 
2.39.5

