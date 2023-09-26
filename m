Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11674998F
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 23:40:13 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d8153284d6eso15405929276.3
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771612; x=1696376412; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5wBvgde8NqXXedlUolMxmuLFm0wZFB1ciTVf7h91dh0=;
        b=oCQmYBW9tw1c4N94N59a3dkXUYN99DSfNwDu8VuSYZSa3sB2d2dfHN3iiTScwLhhEG
         FZAi3JrF6eiIoA4OMSkXXGozzfwVJa0HH896qFpyzI5KQDoZmkUZghyKY5PsyYjaRHc/
         H77nQPNTPeUtg4HoUtgtwyeZRqLH72FZ9qjsQLZQeOxaIZlFo9VEnw1/Hwdqya34RJP5
         417ZNc/ObCZ+X3U6BRAgexyQMVe2WgmT6+kVQAIQVqeA56VRXm4EIZV+HsG+tYo8SHdv
         9H1GrBE+i6nwFLEmjiYoJwrigN1t/5KQKY67/QNFjzhX3K6Rt6oB5nj1ERAklhy2n2BA
         SuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771612; x=1696376412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5wBvgde8NqXXedlUolMxmuLFm0wZFB1ciTVf7h91dh0=;
        b=Xv4EVt0Npgy1ERTTcC3i7p0z0wkOjv/3s7dgJEnf/yYKGRURMNIaM1vYz9Mmph2Z5d
         VxnbCSkhlWEsyaLPsEw8eQYkkW9R8JiiKCdVbCBtqx8mexyfYFsTVgeW+BdoV0wovmqW
         l0qliLJkREgIGmaQDlOIpCMR6YT4E7Aje1ms9N+sLao6ly3pOD7momXZT/h9CX06LdK4
         zuML76nL1uRcpIm8fQPRW8/c3mGA8gNTdKha8r7ormk2G1Cb9LSj5ilSJZA3iuGaw76j
         3GBjBCcNH9mGRSMsNzHk1NoTPKC7oysvmiMa8x1sjJDOGscGRIuRIiFgR9+nsKvkWPcU
         GYmw==
X-Gm-Message-State: AOJu0YxKyur3TTy0I2aDRxJxL0pCSAkkiOxAxOhrDrXEoFLsIvO9374w
	CZ8loXNITpP6MPoNjcpfyCb0DGp9Fa4q
X-Google-Smtp-Source: AGHT+IGQ/Bhiz9+l+ftp30n3Q3sAQclow99O2nr45tC++G2Qcf6D0tuF4DRExCh4Bp6rFs3g73lmp3qip+2k
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1682:b0:d81:78ec:c403 with SMTP
 id bx2-20020a056902168200b00d8178ecc403mr4790ybb.12.1695771612735; Tue, 26
 Sep 2023 16:40:12 -0700 (PDT)
Date: Tue, 26 Sep 2023 23:39:58 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-2-rananta@google.com>
Subject: [PATCH v6 01/11] KVM: arm64: PMU: Introduce helpers to set the
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

Introduce new helper functions to set the guest's PMU
(kvm->arch.arm_pmu) either to a default probed instance or to a
caller requested one, and use it when the guest's PMU needs to
be set. These helpers will make it easier for the following
patches to modify the relevant code.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 50 +++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6b066e04dc5df..fb9817bdfeb57 100644
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
2.42.0.582.g8ccd20d70d-goog

