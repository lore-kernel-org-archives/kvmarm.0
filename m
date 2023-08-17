Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D4ADDC7
	for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 00:30:34 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d62858b0914so805579276.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 17:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232233; x=1692837033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p5AVWhdLdq92AtHjXfrvRAhqFYTQ8rzt+av6leDSxig=;
        b=6YSihL71lWgouUO/mSZlnJIqsVWU0t8EUJZUcY4kpRinwQnibsi30lL19o/067zYqx
         NP3jhndiF60n0Hj7ZHPVrE/7S6vfaPGr8n4XtBQmVhPyskYQ+2JZgpgh/3hxEMxpEglK
         74bfyyR3COJxLz2Gkvif2unrCFKewmHAK3PaH0RC3PSbEa0SOp+i9OHlD4rECrAIYtzv
         s0IclNp5A0l6tJKtos3y5WPxudsHLorXzWZK/8nGLvLeuZGo9/l5urm3KxsssJJS6TaH
         Q81hdlsGdxVvjcpaWM2aJZ0wqTipFqk3uHbNSQOgi41yCCBadFvM4TQV8KOfVH7BhFcY
         VLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232233; x=1692837033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p5AVWhdLdq92AtHjXfrvRAhqFYTQ8rzt+av6leDSxig=;
        b=cpb6B/ZSxlxdTQ5vmpuiW36JSHW5uP2ozgrKPpyEEqoOxLc2l4IsWbANLV3vp4XYe0
         8gZSj6cBR7rJkBlppqTHLYbBDrHDqQGbKhnRzBFtnGyAet4nbCotOfVo/3BuPfwzSqlv
         s1D8g6sk9UhPdXtATs5e/67ZiqKfdqpPGYp3LsuYLXIRI4jdAR872zAzLEvBJDunM5dA
         RevKQd85o/F+vd1fK5HruFWg5ker5I2jjKUROUJnqmp3Kt+8tK1I3VkgmV0tKYabb8+N
         iNbIEuoQzfbVYoF5rDRIJSnWPcaB1AmkbgahyScL9dbcWq2C8nSHyUOsMgbAS9VI0ct9
         5Jaw==
X-Gm-Message-State: AOJu0YzXELox4FI1v9hYSNKqHHHojI4PiNBZiG1vVbmKCbGchdZwO/09
	44yZBUeBaNqULeMRawhUQeFbPGNz4PjH
X-Google-Smtp-Source: AGHT+IElcJgd6OEK6WsLtSqwCDbHFpQVk1NVpVhp/ioqgJwLe1DFcFjqYIWtYwJz7x3wfLN8H7uF9sToSnuG
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a25:76c2:0:b0:ca3:3341:6315 with SMTP id
 r185-20020a2576c2000000b00ca333416315mr25049ybc.0.1692232233287; Wed, 16 Aug
 2023 17:30:33 -0700 (PDT)
Date: Thu, 17 Aug 2023 00:30:18 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-2-rananta@google.com>
Subject: [PATCH v5 01/12] KVM: arm64: PMU: Introduce a helper to set the
 guest's PMU
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

Introduce a new helper function to set the guest's PMU
(kvm->arch.arm_pmu), and use it when the guest's PMU needs
to be set. This helper will make it easier for the following
patches to modify the relevant code.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 52 +++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5606509724787..0ffd1efa90c07 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -865,6 +865,32 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (!arm_pmu) {
+		/*
+		 * No PMU set, get the default one.
+		 *
+		 * The observant among you will notice that the supported_cpus
+		 * mask does not get updated for the default PMU even though it
+		 * is quite possible the selected instance supports only a
+		 * subset of cores in the system. This is intentional, and
+		 * upholds the preexisting behavior on heterogeneous systems
+		 * where vCPUs can be scheduled on any core but the guest
+		 * counters could stop working.
+		 */
+		arm_pmu = kvm_pmu_probe_armpmu();
+		if (!arm_pmu)
+			return -ENODEV;
+	}
+
+	kvm->arch.arm_pmu = arm_pmu;
+
+	return 0;
+}
+
 static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -884,9 +910,13 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
-			kvm->arch.arm_pmu = arm_pmu;
+			ret = kvm_arm_set_vm_pmu(kvm, arm_pmu);
+			if (ret) {
+				WARN_ON(ret);
+				break;
+			}
+
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
-			ret = 0;
 			break;
 		}
 	}
@@ -908,20 +938,10 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
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
+		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
+
+		if (ret)
+			return ret;
 	}
 
 	switch (attr->attr) {
-- 
2.41.0.694.ge786442a9b-goog

