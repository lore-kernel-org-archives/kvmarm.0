Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248331A5A8
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 21:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sgPq+mp7"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a818c1d2c7so19058137b3.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 14:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838058; x=1698442858; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fRZJl825jTe4bNk4e/h0EcnYD7OOEsJ4orW3IfNwdD4=;
        b=sgPq+mp7InSg9VtNve4T2g3k8d97PhAcaIwjriwEuQc89+xciwa0ZsRPcg0xhfwseL
         lkBPSgeuhFmMU/PakvEeiqi8183gV3U4h2ppu3sM8dWF5Ey8NM8BoXzRM1m4btN5skVI
         dyD4Q2UYKhXXGY7sdlmezJXh4wbas13NdwwqAvTcmQTm8dEh3XyXyK6dLnnC8q6hJAAt
         EC3rnrXUigdtkcLJl57XA2UhJudd/dzKykYp4kIqVxXv6NktuP0ra23KqdNt3F4yjAPh
         Y2Yl05brvoikB2EP9gD6aycfTP3uCffjuXJH3nS88Ss1r59hBp7cRFhnvh5cbAKEwU/t
         NBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838058; x=1698442858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fRZJl825jTe4bNk4e/h0EcnYD7OOEsJ4orW3IfNwdD4=;
        b=RpqRQF4MDGEShax4OoV14SzyaXFiRNt94FbVo4u99rnPwc9JkKwRDThqehpT4Gq7ed
         9K+VMt/ZuslhkWFqbDsbM3QDQKp0U01anwsYChoE19xRxbgiuxGgJzwj0wgWEdQyuKDq
         WAJoVDmUwulm8SIXn53+k/V2Wy8UR2IeKbJSbn+plICj2m2wpliN9v9/HeUv7B2NW1U7
         7Tl8l0ZE/aenxuMEU5oTt9G2qG7nGrARKyMqXSsQoMgrqcUQvltMFQ0+Xp4Q+L5hlHeR
         o0s2B0j2Rry3WFE0z/vIm8pUosFufCJl40TVcl9SMKgnndbn1T0S49AJH5lenCF2SQ89
         vlsQ==
X-Gm-Message-State: AOJu0Yxu1YwKsc0ZqSd0SIU2+MbL1H9yXh6J5u/2tBJndG5SylR/Kuaj
	ba3XvE+9vRtFK/pssEdkOQ6exGK3I31Y
X-Google-Smtp-Source: AGHT+IHe1u7IUea+IlhDVSmNzeHVDsOIIsOYR3rNgYKN/Y9aeMFrZpa/CBGN7KTEhg1GR5frubeMf8zmtcdy
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a0d:dd10:0:b0:577:619e:d3c9 with SMTP id
 g16-20020a0ddd10000000b00577619ed3c9mr76387ywe.10.1697838058021; Fri, 20 Oct
 2023 14:40:58 -0700 (PDT)
Date: Fri, 20 Oct 2023 21:40:41 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-2-rananta@google.com>
Subject: [PATCH v8 01/13] KVM: arm64: PMU: Introduce helpers to set the
 guest's PMU
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

Introduce new helper functions to set the guest's PMU
(kvm->arch.arm_pmu) either to a default probed instance or to a
caller requested one, and use it when the guest's PMU needs to
be set. These helpers will make it easier for the following
patches to modify the relevant code.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/pmu-emul.c | 50 +++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3afb281ed8d2c..eb5dcb12dafe9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -874,6 +874,36 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	kvm->arch.arm_pmu = arm_pmu;
+}
+
+/**
+ * kvm_arm_set_default_pmu - No PMU set, get the default one.
+ * @kvm: The kvm pointer
+ *
+ * The observant among you will notice that the supported_cpus
+ * mask does not get updated for the default PMU even though it
+ * is quite possible the selected instance supports only a
+ * subset of cores in the system. This is intentional, and
+ * upholds the preexisting behavior on heterogeneous systems
+ * where vCPUs can be scheduled on any core but the guest
+ * counters could stop working.
+ */
+static int kvm_arm_set_default_pmu(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
+
+	if (!arm_pmu)
+		return -ENODEV;
+
+	kvm_arm_set_pmu(kvm, arm_pmu);
+	return 0;
+}
+
 static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -893,7 +923,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
-			kvm->arch.arm_pmu = arm_pmu;
+			kvm_arm_set_pmu(kvm, arm_pmu);
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
 			break;
@@ -917,20 +947,10 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return -EBUSY;
 
 	if (!kvm->arch.arm_pmu) {
-		/*
-		 * No PMU set, get the default one.
-		 *
-		 * The observant among you will notice that the supported_cpus
-		 * mask does not get updated for the default PMU even though it
-		 * is quite possible the selected instance supports only a
-		 * subset of cores in the system. This is intentional, and
-		 * upholds the preexisting behavior on heterogeneous systems
-		 * where vCPUs can be scheduled on any core but the guest
-		 * counters could stop working.
-		 */
-		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
-		if (!kvm->arch.arm_pmu)
-			return -ENODEV;
+		int ret = kvm_arm_set_default_pmu(kvm);
+
+		if (ret)
+			return ret;
 	}
 
 	switch (attr->attr) {
-- 
2.42.0.655.g421f12c284-goog

