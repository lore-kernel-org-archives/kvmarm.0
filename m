Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2F96FA7
	for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 06:16:24 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bb3a35ba742so3557034276.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 23:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686377783; x=1688969783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yRFpiF9EW1xpDdddok4DKuKkCXcjFgH6nNPKa16z1Tg=;
        b=v85qEb5h7erEV0vhQyB+Gi9zMu8mK1PwATuaa4UYvMQlHpiTl5aYYGPTGKVLzxNyJ1
         s0aXRiu7I6K8vz9Vcw2KIiG+VcvSfR3imgnH8gfmeqbt8d9Ubg9ut0tgfN4dct+DafI4
         FzY6T7hYX0d1i0q7DDMWnJsnTy9731J3qEexOmihzJVCvHq36GuKp8r8ai15VkdJRq1t
         VS0DwYsrPqtOqTaSAqdz1sl0fdHzpzFEEdMoy8sIXgcGeqim8rf5WEC5aMWTAepcp8dn
         wZQeFF4CG0zk7363WR2hAEhSrpXL8o0j5xLhPfmBsygnY0C9VjVNFpmS7djf9kuJVvBS
         +GAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686377783; x=1688969783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yRFpiF9EW1xpDdddok4DKuKkCXcjFgH6nNPKa16z1Tg=;
        b=RWn05KynuWPP9d85tN33cWOzPtAn+XD0b5nmYCTBqPNMmi6+9alyEr3e7VoIjuNpnW
         doMN6KglZ86+mP4CRSRLdJpnall7uBpZ4z6TYSRs3TB8LP5V0WxgOOik22Zu+L+eDDdZ
         KIxNNkkjnwZAoEqcHuUHNu7Xicqyzqe4XI/d4h7/+SEkz4PLin5VX26b96H84ManDYDU
         /rvhbsBuYJE/QjyuuCWCbdtQgmlZfkNhervxnSNWk1xU+K3/pzLCmHaNF46C5W8Gc2a9
         gxBBFcDH2p7+m22GfJJjDVrg2O0uz1L51cU4vP2u4ddlqe1H/WE20daH2fzBsGioRTkj
         lUzA==
X-Gm-Message-State: AC+VfDzUfvdtHoRf13dOK+Vy4CMAi2ojS3GaILBpd5iZyXZQ7GC42SKR
	+7yRLh26nCK/v5s+L80RK0Db0efNszk=
X-Google-Smtp-Source: ACHHUZ5PHGV4oelgCpab9bxHiQhiMBK4E/MkgJr0Ll1vuL3QAsfBaqeaprxSa0xFu5L+88zqObG0H4XDUv4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1085:b0:bac:f582:ef18 with SMTP id
 v5-20020a056902108500b00bacf582ef18mr1834265ybu.5.1686377783371; Fri, 09 Jun
 2023 23:16:23 -0700 (PDT)
Date: Fri,  9 Jun 2023 23:15:20 -0700
In-Reply-To: <20230610061520.3026530-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230610061520.3026530-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230610061520.3026530-3-reijiw@google.com>
Subject: [PATCH 2/2] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Disallow userspace from configuring vPMU for guests on systems
where the PMUVer is not uniform across all PEs.
KVM has not been advertising PMUv3 to the guests with vPMU on
such systems anyway, and such systems would be extremely
uncommon and unlikely to even use KVM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/pmu-emul.c |  3 ---
 include/kvm/arm_pmu.h     | 10 ++++++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..21901fbd6e4d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1960,6 +1960,7 @@ static int __init init_subsystems(void)
 		goto out;
 
 	kvm_register_perf_callbacks(NULL);
+	kvm_arm_set_support_pmu_v3();
 
 out:
 	if (err)
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5d2903f52a5f..45b84cf22026 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -684,9 +684,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
-	if (list_is_singular(&arm_pmus))
-		static_branch_enable(&kvm_arm_pmu_available);
-
 out_unlock:
 	mutex_unlock(&arm_pmus_lock);
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index eef17de966da..af1fe2b53fbb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -105,6 +105,14 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
+static inline void kvm_arm_set_support_pmu_v3(void)
+{
+	u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
+
+	if (pmu_v3_is_supported(pmuver))
+		static_branch_enable(&kvm_arm_pmu_available);
+}
+
 #else
 struct kvm_pmu {
 };
@@ -114,6 +122,8 @@ static inline bool kvm_arm_support_pmu_v3(void)
 	return false;
 }
 
+static inline void kvm_arm_set_support_pmu_v3(void) {};
+
 #define kvm_arm_pmu_irq_initialized(v)	(false)
 static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					    u64 select_idx)
-- 
2.41.0.162.gfafddb0af9-goog

