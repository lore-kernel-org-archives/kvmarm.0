Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB59A23
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 03:16:07 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id r17-20020a258291000000b008ee1c76c25dso3570934ybk.11
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 19:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hdq7XuQlIHPZE8pEPY3tLAAyJhRpgi42DVvI6D6fk3s=;
        b=olC4sly3/BCcNo299QFE6SXvV3g1wqVFUyVd0+8jO9Hz+c+XRPNbcos5NTEKH3hY/R
         jfuycnUuQWdEbOb5vp8hZcuI6GgGI1csCoVVklgaUsyPjklgOJsSaNyrhgKH1/VKpzK+
         DEbm1g4/DWJK4TW/Eh5bcI6KwZzSjgu0qXrAlSd0ywkqwa3K1g1Z1Xg8ejeFhlI8X0ft
         PSqzgUEdb4r24scbLQiArayCSitWzKiUJUoS1d70rdvllcCjnqRUP+QgxJEutdunjA+C
         MRKdYitr/BDl6m6mcox9XP9p0gA1+a1PtClTHXxPnS8X4eygpDmpWl6uof8xHFyxNtkP
         UG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hdq7XuQlIHPZE8pEPY3tLAAyJhRpgi42DVvI6D6fk3s=;
        b=MgyozMiSaBi8HnsYbtws/UOjw8XvNHODNRTvjSIHspQdy47OhXxr1ZhmWpGozLG9Ss
         xxt3+7oqBgkYSjr6LRMdgHgmw2xJR+iB+P6hPWwqrmSq403Uf26yqdZJOR2CGxLbo44Y
         qxgaRbeRkfOS7/VVlwl4LIUkJAhrGRIMk1mfL7Vj8lzgElPE7zMMfSP4iz2lSt0J0QES
         mJ9Av3U1UHZSs6F8jCgGS/t8xmi1X+bZhMOGGJ9rrSVUT1nj8hSrnuDLrwRZAjJZ3cc3
         SpDZZRtEl5b+o6bTDJklJcFnvr6k9tFTGN/3QfVRH62vM8srEtawXDPs5yObmQrN0+3s
         5i/g==
X-Gm-Message-State: AO0yUKVhpQFCnbT3MPTMWFPHp0t7z0lTB7L/NPQtNtSfuIOQ0nHDs6UJ
	doGB/Q90NU4S4maN3/fZczgxpOrKgtU=
X-Google-Smtp-Source: AK7set9MyQkoUEk7Igu3MmgDiS0MvOBHtDAybXqTLmWHi6ARX9UQnTFnvNsgayrwWqtVeJ8XRvgwFvDqePE=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:bf48:0:b0:506:7242:1c7b with SMTP id
 s8-20020a81bf48000000b0050672421c7bmr2250183ywk.494.1676085366884; Fri, 10
 Feb 2023 19:16:06 -0800 (PST)
Date: Fri, 10 Feb 2023 19:14:53 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-2-reijiw@google.com>
Subject: [PATCH v4 01/14] KVM: arm64: PMU: Introduce a helper to set the
 guest's PMU
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Reiji Watanabe <reijiw@google.com>
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
2.39.1.581.gbfd45094c4-goog

