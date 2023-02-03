Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489C210E6
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 04:05:44 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id a9-20020a25af09000000b0083fa6f15c2fso3736133ybh.16
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 20:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ipr4xhXjsZ3xlHgWCFzXNIu5kTM+BU4HEjtM53FIJC8=;
        b=c/d6PHNBqDvTeLHEKZO2QuLxxu4Dw58XcVsbS9TqYVD79JfHoLbKk5m+MlHoePbKvZ
         m+RiHImDM2atdcUtTq5p/p8ZKHwuJd0SnifljBbJaRr/xGiJOzWYhvkowagdjqZtMJRa
         ykLSRR6cNJ0zBMjRG6h6BR3ebZrbrlzZXuPZQ7TfzIPwZ8L7qTHTiolQAWapRGHaiNUj
         FAsvVziElhXi20ioCU8YNcHjKZwgyMOFIcWFZxuG9F/C/plHhQM317I3Zd0F09qlUS+d
         kGva4rNxavCSAw189iTIgHWJ6FmmRcmyhko0spN052hlBYOUey3NTCi7JFmr/nGCwkCP
         QCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ipr4xhXjsZ3xlHgWCFzXNIu5kTM+BU4HEjtM53FIJC8=;
        b=UDZd7TdwLV92L+iQ9132siAIig+X7iihCi4XKAymM7SMDPzgXFF+CC3D0THIZNyp6y
         doH9GBhgildzXHrpW03S8qVmk/IMyYKh5LZu2XU16S6K2fjOVE9k1Ucg74xrbODi9k5f
         xsOkw0unmNgG/1Rhhn5oaZrtZONL62I+8FWOiK1DuTf+AeGjAAgu1dLo6lgb1GRyiDIx
         miP1OBA6AjXoBMTDlYgr6x9zofDWKBiPNwWWQRv9xSRStnbkIkpDaH8coxhoPyCkkvUC
         gqeLQpjz1oBkFKQL+vEFn9EDW9bvSp5WMWd6WWXDgDtmaFSkeqIKFhuMzrcSNfA8kEki
         JdVA==
X-Gm-Message-State: AO0yUKVL1rNPYPo6PgbdOuaxnY2vsws3bNiRAZh+SqvP3HrqMkuaUfzE
	iko0111jw85eB//j5y/2vlX8H/9KoAs=
X-Google-Smtp-Source: AK7set9hXHYpsfeEyNZjmKuwBd86TPK7rc/HyFmmnFFTRFa6jkP13qBYeAs3sOwd8+uNbKkJ6PM4+ACIplY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:af02:0:b0:4d7:50a4:630d with SMTP id
 n2-20020a81af02000000b004d750a4630dmr1108788ywh.518.1675397143239; Thu, 02
 Feb 2023 20:05:43 -0800 (PST)
Date: Thu,  2 Feb 2023 20:02:29 -0800
In-Reply-To: <20230203040242.1792453-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230203040242.1792453-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203040242.1792453-2-reijiw@google.com>
Subject: [PATCH v3 01/14] KVM: arm64: PMU: Introduce a helper to set the
 guest's PMU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Shaoqin@google.com, Huang@google.com, 
	shahuang@redhat.com, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a new helper function to set the guest's PMU
(kvm->arch.arm_pmu), and use it when the guest's PMU needs
to be set. This helper will make it easier for the following
patches to modify the relevant code.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..f2a89f414297 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -867,6 +867,21 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->lock);
+
+	if (!arm_pmu) {
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
@@ -886,7 +901,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
-			kvm->arch.arm_pmu = arm_pmu;
+			WARN_ON_ONCE(kvm_arm_set_vm_pmu(kvm, arm_pmu));
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
 			break;
@@ -911,10 +926,11 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	mutex_lock(&kvm->lock);
 	if (!kvm->arch.arm_pmu) {
 		/* No PMU set, get the default one */
-		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
-		if (!kvm->arch.arm_pmu) {
+		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
+
+		if (ret) {
 			mutex_unlock(&kvm->lock);
-			return -ENODEV;
+			return ret;
 		}
 	}
 	mutex_unlock(&kvm->lock);
-- 
2.39.1.519.gcb327c4b5f-goog

