Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034190;
	b=mQuA/ATiNt7nmdC5CFQ265yFY0zDMpi7DfhfCvIG74/wB+vMKgWuVO40XrmOJnjqlNZt
	 Cs9/d+eJ+a/+MtsrWUeqRvd2AeyGXZo6getvsW8+bpgepc7ek6PfkoxUQmwURJoRRA5xT
	 IQwk7OxOzveWAWwmy0Kk33bhPL0XzPAaflwDzWoWs4Z3+hD9zprMJjPbFCCEmKKoqc2ya
	 hOhEYcoaSMG/E2aqbDxa5fxK7rc7aslwPjlDjM1LQvcQVQhlyOQXZfvwqaIvvPw0e8WM9
	 He92ScwHMnacvVXCrJgIfjWca6IoyWhfmk/VPJiF1gYo6KPUNjXQ7Xfc80hzKtrsNNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=7xlWmwrLiTN9oWrbWWc4bJ9ER2WNpvMfBsQ0dHA4HLk=;
	b=tprmYotC2u5ibb2l1VKsaUuG0g1S3lKRVxT9xg0Ms+ZzJE2rMeEsPTOdf06l76+PsIG3
	 ZV0cTLfqaruAIuq4U5ehH6DM59jVUVYZTkGxuw0Kofl/MAjAtmybV96DoveA0W86PIooo
	 UzRXEZzG6HPCKhku9amoSgFbm/ygFZZRhhkmnCUAdM8/zzQP+JD5XW3h8kg2DGqZqVlyD
	 jw+w0hOIbPQqVqvqCnna5Y1p8teEyeXQdapcQ/IJf/kDEcEm00TarNU7AJGZJSQCmnoUM
	 NTBWTt2Ahcf6JoP89CHF80h+FG1KcrkWcyuPltsnimNWROVY9pg34h1JpgU2c0mEavA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="XByHi/Zp";
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6F860A380F
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 20:36:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF6F860A380F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XByHi/Zp
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-540537f959fso1524168b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 12:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795034189; x=1795638989; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7xlWmwrLiTN9oWrbWWc4bJ9ER2WNpvMfBsQ0dHA4HLk=;
        b=XByHi/ZpYOlQYstgEvJmraLTRMwMsC3hPMf4bch31lvu4iaim/lHsJCmIYQgesJOAM
         9ISn7E9jsSvA9nYhz48Y+OfKox2ld8EkwKBg1hHTWc6cSPROp5nj1pnXOHcEDnnHdnt2
         xIT+FNXsBlFXVdOke07euY27HJNhQvIidguLEIu2yCvLWYiJmUzGF0/dggj76MsnjMPP
         LO6h5L9f4KsPbzTR+koMf1IvPNwteFMmXpLj/J/wAbsj6A8jKSzhRBMXHjH8W5pO+MGv
         qNBoon0woY3RpQkZRDytPg6mHwIwOMMJ3rUDri43eCdvvuzyAtFofI11+tR8K/CA4RVi
         U+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795034189; x=1795638989;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7xlWmwrLiTN9oWrbWWc4bJ9ER2WNpvMfBsQ0dHA4HLk=;
        b=AbIkwBee8KpwVAyU1GAYQLJRDkvo7wYRUqgyzEWTEePjqzvSGZAeMErYYzx0VFa5kV
         y2PlIb0ohsgxb7udBy7br3YuaOa7QKkFkfzQKhd/nLoFuzNtEXNAkbKUW0KdwIElZJeE
         3n1Z3VxDbXoTnaxUhOaLXMEtaRjnsYz/S3ln0epvJAzYjssLuhWWIojXsV5i/9Y4CoZe
         uJPmlSvLIeKKgiF/T3FprOIZIx5fM/3tNB0/sjGPj5qWNy7YHFw7dl5z6vaQnbPdZ7Hp
         P1hY0zmI6ZWCj0zQv5IFf+8PfzHxeDN7bFx89lL9cAunwzDy58Mtha3396wfdZ4ZL+L2
         kkxA==
X-Forwarded-Encrypted: i=1; AL+hErEQbo7JerjMb4o5mE8XhtdDVSjswxqQgXck5X8dwSK9eQIz6amj0tIM/K8EnN4l7G9EzxdFOa8=@lists.linux.dev
X-Gm-Message-State: APuU4Z8O66jJEgdBrZcHo01qwU0deTgpZgepFzpDas1ir8GLQow12eNr
	g/wak/W9qJwGdca0/bcgw00sG6RHhy7+Gcu1od7zNpw0H5LTiWJunzbHhQWOb51FH02XyUrbqJ/
	j35NnAxXNkeoCo5BPaFIkPYnAnw==
X-Received: from iobn34-n2.prod.google.com ([2002:a05:6602:c6e2:20b0:9c4:bd6e:a838])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1927:b0:4af:5d69:1cb4 with SMTP id 5614622812f47-5773cd2176emr4714167b6e.15.1795034188500;
 Wed, 18 Nov 2026 12:36:28 -0800 (PST)
Date: Wed, 18 Nov 2026 20:36:25 +0000
In-Reply-To: <20261118203625.743428-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261118203625.743428-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118203625.743428-3-coltonlewis@google.com>
Subject: [PATCH v3 2/2] KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0 when
 E2H0 is NI_NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

In a VHE-only EL2 guest (KVM_ARM_VCPU_HAS_EL2 without
KVM_ARM_VCPU_HAS_EL2_E2H0), KVM advertises ID_AA64MMFR4_EL1.E2H0 as
NI_NV1, making HCR_EL2.E2H RES1 and HCR_EL2.NV1 RES0.

Extend hello_el2 to attempt clearing HCR_EL2.E2H and setting HCR_EL2.NV1
from userspace via KVM_SET_ONE_REG, verifying that HCR_EL2.E2H remains
RES1 and HCR_EL2.NV1 is masked to RES0. Add a comment explaining why the
check is performed from userspace rather than inside the guest.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/arm64/hello_el2.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/hello_el2.c b/tools/testing/selftests/kvm/arm64/hello_el2.c
index bbe6862c6ab16..3bd3596f5fb1e 100644
--- a/tools/testing/selftests/kvm/arm64/hello_el2.c
+++ b/tools/testing/selftests/kvm/arm64/hello_el2.c
@@ -45,6 +45,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
+	u64 hcr;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
 
@@ -66,6 +67,20 @@ int main(void)
 		TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
 	}
 
+	/*
+	 * Verify RES0/RES1 enforcement from userspace rather than inside
+	 * the guest. From the guest's perspective RESx bits may be
+	 * stateful (reading back as written) even though their value is
+	 * ignored, whereas KVM_SET_ONE_REG applies the effective masks
+	 * directly.
+	 */
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

