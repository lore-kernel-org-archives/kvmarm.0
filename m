Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794859463;
	b=GtPwAKu0BSQIdhTbNc7pxbb4v1h+CKd6V0mfXeX96MCfoRPRfnZTvgvkDEbnpkHGbPlG
	 CkStsOpwJ0gyBqsvC1w1zUq17leby+PoEtP5uaMIEWq2UyYooB0QxhVqkZcoTMgq0z08y
	 LHeHZnG2V7JK5bPKzNEgMouqVvW+hhJxnGQpXq7OOMzO5UJSe8jFMI4qnf3C4hoYc+SV6
	 Qd0IVkNpds4vecikjx3e68TbjE2XpnUouHWYOkzou1qi+TVRBN7ijN32V3bww+ZnwOA2V
	 Ymf4AMgftCLXNfHx3mZNAaD6cuRL4akfwLsQUex6raiFsSc8GT87wOjgqlJjcGKPhEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859463;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=nMypBwJnR0vpA1cBr9OnEsaSU+Ny4MYTCLPv64i3c3A=;
	b=ihApThiqaEVqO2AaMT60Ea9WiVQhQHYglQc69lEyA81mCxN0Gyjief9D68hE9O1IXuQ+
	 gXMlx01wzv2YofvLMYdOAq3ddKvLAENwKqK1/tBLy1eFbtt4Q1vyq0REcTdNgYGMWdcpF
	 WJCH5m+OtEXhAEjLLS2JB+3IwRtlJuXGIZGyhOQW9F9QZfD0a3KSnVOtza++kl/907da7
	 AhtYw9+0UL7G2bD/lElk+zk6YFmxnLVkVSDpaeW9gqRyVhWxLqfOm+M4XnwPsxfGCWmkp
	 lUhBrrVbkRJK2QzpuLm76ldbHVJ32CapfCM3JWYp2qcWDDt084h3Ph2rjEnF+qxXvqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bDr4Mdi7;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE906606A89D
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 20:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE906606A89D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bDr4Mdi7
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-54dbbf252cdso4833860b6e.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 12:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794859462; x=1795464262; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nMypBwJnR0vpA1cBr9OnEsaSU+Ny4MYTCLPv64i3c3A=;
        b=bDr4Mdi7O7X/wgfAvb8OX58i1f5PQn6A72yT5pxYWGCAJNU5wGPI9Yo2bL3w3i9Dqu
         DgJqA+ZJ7H+QvmmdH8fj0vClyiowiTl7sl1jriHWTalIULtURpkucjXN3Asgr38I/3QE
         2kIhCi9E4J4m2T+HfchgYYuNCjn5RiixwH0yyOwZYzoZ0JYVr/abPl53E0aOqR0Txi6q
         DtVvr31fQ14NgtE9FpPGgRDund1cTVc+4v+Nb/RScXiSSOMU63L5fZ1HCBXTJYE2Ew76
         rudaxQ0N0/92X4GWV64F8J3J5BPJU7x30hqUZgxbx8/kS53hIOkYbjGqdFf8LY/lCFfv
         hegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859462; x=1795464262;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nMypBwJnR0vpA1cBr9OnEsaSU+Ny4MYTCLPv64i3c3A=;
        b=H7enE17kx5BU+OoleM8KHHWO6kRl4yzjE5gsJSalHA7Qc2Ah/tuKuo+j+9ClcMZUAi
         7iFRWy6sM+vEgMrTY2Qagarg/LuxaAP22zz8vY0uhcbMCgJ3HtACrIgSbsHhlwHsfdnQ
         ArG276eG+aWUbUFstNOUJAV2pqo90zDzzM4gMHJZQadKPx6Wf5lFjHjU1CXvhngzTWXL
         bZxaC1Ot2clNqgkZPJCAvb6H1QHLTUOzz97Wk8e9dwqtSt3VTlLSSvaD5EGKwzFTtyGJ
         Cqzp3PrHXs5SSEz0jYIwnH/wqmOytEwBRO+fcCsEEgISSaWUlKej4VErQ0KhwiGppTi8
         QHYA==
X-Forwarded-Encrypted: i=1; AL+hErGcFwr7/m40rq29apqJ7JaC/w9hG+a75qdXPntwGBfsiImLh8WNf7nKrOnBqDqGZxEIq9ZG128=@lists.linux.dev
X-Gm-Message-State: APuU4Z9H/2fLvVozT472erqeucwliOqz+wbW4ph5YdMNVepaMHACt6FV
	DS+HA2tpaQkLh8ISQZTh8SjQBvOtjtusQBy+0lTY3wtad07+mhnbQ7sRnyHVKDSoONcMCC6XL/K
	z9yGkIiOW4GTilASOio0ucJ7GMw==
X-Received: from ioo28-n1.prod.google.com ([2002:a05:6602:865c:10b0:9c7:7732:c3c1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2383:b0:568:e5e:8058 with SMTP id 5614622812f47-56e6378f81fmr10829049b6e.19.1794859461431;
 Mon, 16 Nov 2026 12:04:21 -0800 (PST)
Date: Mon, 16 Nov 2026 20:04:18 +0000
In-Reply-To: <20261116200418.3535619-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261116200418.3535619-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261116200418.3535619-3-coltonlewis@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0 when
 E2H0 is NI_NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

In a VHE-only EL2 guest (KVM_ARM_VCPU_HAS_EL2 without
KVM_ARM_VCPU_HAS_EL2_E2H0), KVM advertises ID_AA64MMFR4_EL1.E2H0 as
NI_NV1, making HCR_EL2.E2H RES1 and HCR_EL2.NV1 RES0.

Extend hello_el2 to attempt clearing HCR_EL2.E2H and setting HCR_EL2.NV1
both from guest EL2 (across a trapped ID register exit) and from
userspace via KVM_SET_ONE_REG, verifying that HCR_EL2.E2H remains RES1
and HCR_EL2.NV1 is masked to RES0.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/arm64/hello_el2.c | 34 ++++++++++++++++---
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/hello_el2.c b/tools/testing/selftests/kvm/arm64/hello_el2.c
index bbe6862c6ab16..46b0f63e199f0 100644
--- a/tools/testing/selftests/kvm/arm64/hello_el2.c
+++ b/tools/testing/selftests/kvm/arm64/hello_el2.c
@@ -13,13 +13,29 @@
 
 static void guest_code(void)
 {
-	u64 mmfr0 = read_sysreg_s(SYS_ID_AA64MMFR0_EL1);
-	u64 mmfr1 = read_sysreg_s(SYS_ID_AA64MMFR1_EL1);
-	u64 mmfr4 = read_sysreg_s(SYS_ID_AA64MMFR4_EL1);
-	u8 e2h0 = SYS_FIELD_GET(ID_AA64MMFR4_EL1, E2H0, mmfr4);
+	u64 mmfr0, mmfr1, mmfr4, hcr;
+	u8 e2h0;
 
 	GUEST_ASSERT_EQ(get_current_el(), 2);
-	GUEST_ASSERT(read_sysreg(hcr_el2) & HCR_EL2_E2H);
+
+	hcr = read_sysreg(hcr_el2);
+	GUEST_ASSERT(hcr & HCR_EL2_E2H);
+
+	/*
+	 * Attempt to clear HCR_EL2.E2H (RES1) and set HCR_EL2.NV1 (RES0).
+	 * KVM sanitises VNCR-backed HCR_EL2 across exits such as the
+	 * trapped ID register reads below.
+	 */
+	write_sysreg((hcr & ~HCR_EL2_E2H) | HCR_EL2_NV1, hcr_el2);
+
+	mmfr0 = read_sysreg_s(SYS_ID_AA64MMFR0_EL1);
+	mmfr1 = read_sysreg_s(SYS_ID_AA64MMFR1_EL1);
+	mmfr4 = read_sysreg_s(SYS_ID_AA64MMFR4_EL1);
+	e2h0 = SYS_FIELD_GET(ID_AA64MMFR4_EL1, E2H0, mmfr4);
+
+	hcr = read_sysreg(hcr_el2);
+	GUEST_ASSERT(hcr & HCR_EL2_E2H);
+	GUEST_ASSERT(!(hcr & HCR_EL2_NV1));
 	GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64MMFR1_EL1, VH, mmfr1),
 			ID_AA64MMFR1_EL1_VH_IMP);
 
@@ -45,6 +61,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
+	u64 hcr;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
 
@@ -66,6 +83,13 @@ int main(void)
 		TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
 	}
 
+	hcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
+		     (hcr & ~HCR_EL2_E2H) | HCR_EL2_NV1);
+	hcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
+	TEST_ASSERT(hcr & HCR_EL2_E2H, "HCR_EL2.E2H should be RES1");
+	TEST_ASSERT(!(hcr & HCR_EL2_NV1), "HCR_EL2.NV1 should be RES0");
+
 	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.56.1.750.gf70dc682cf-goog

