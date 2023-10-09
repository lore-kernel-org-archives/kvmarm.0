Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F14736B07
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 23:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rpoR/V1F"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d8153284d6eso6762965276.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Oct 2023 16:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892944; x=1697497744; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lbiCPM17L0Ezy9RJ+4AjTcOJhsmWUq480xf6KhudPI8=;
        b=rpoR/V1FsS3fk9oHsGxj3wFWd6hilJ0KUdTQra/MzwXwiEfoaGK2pUOX5OsMYAR3Pi
         SqgGSyNXWRYWIJfNtJUuFTA0AlmVKEmY6fKAoICad7C1kZL0rgCZ3Snnyuvdg7UL30Pl
         4Dkk6/6ExJ3pTgVymVzeaER5aBxc9vrmOD3ywvBiDpv6WOmOTwyoTkG90rCT+qoZOqn+
         6Jvf/D4J/P6mDj8SkTbEdQra55A2VYJLh6lvv9b6a/grF3Y783bu54Cc9EYKx3sRMbC4
         5rg2xDf88kDnlFTk9UqP4tVx6ZXaOr/0QplviaAwhEl6ly+xFbNvlWzd81AulAJgTb1l
         FQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892944; x=1697497744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lbiCPM17L0Ezy9RJ+4AjTcOJhsmWUq480xf6KhudPI8=;
        b=aWHJdMivj7p8sz+X6KRk7WexvH9M1W22J4o6osbAvEYY3Dv37mJ7o1sruSNiiu3arh
         O9VzlXcwUZt3I/eWmaSzqN8lWZp8ZeRTbtK5fNB20cVJXwugTzTG6mL5mOGJjU10vbe1
         inbanWZlO/mh3f3eC3BqnfZKJn5CgsOv75ejUScTtZh58kTiwbx5Zlz309ZdB3C/0jTe
         igckLc/a0Et8j4jWCvlc7O9rxDOI62glJOBc0Js1Tc0kl21X9r7hKupgnCvMIPVLAQpU
         fjAQLg7xOmGq+SReKQmIYUFCSNV9bBVBVxfl0EmOdcIc9rVSUy2Mp8NVmfKochz/X3DH
         h4BA==
X-Gm-Message-State: AOJu0YzoMvyqvG7FgrQlg/wmFdZ72jpqD5bnMma3HN2O/pT1s47GU2Gl
	r4RSjgGj+32QEPEQOWjDI6yo/ugsm4+w
X-Google-Smtp-Source: AGHT+IGS+qeXuoYzERBdhx/297ZX7D3f4cLKnn2F32lgBAnmC7aVQekkaeRf5AdGPo5boRZQt5zgvgDdd+ff
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:42d6:0:b0:d9a:4db7:63e1 with SMTP id
 p205-20020a2542d6000000b00d9a4db763e1mr15924yba.12.1696892944315; Mon, 09 Oct
 2023 16:09:04 -0700 (PDT)
Date: Mon,  9 Oct 2023 23:08:47 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-2-rananta@google.com>
Subject: [PATCH v7 01/12] KVM: arm64: PMU: Introduce helpers to set the
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
index 3afb281ed8d2..eb5dcb12dafe 100644
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
2.42.0.609.gbb76f46606-goog

