Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B64645F5B
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XhevatI2"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59f7d109926so77468927b3.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Oct 2023 16:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892950; x=1697497750; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NiBpW9pAzYjkcsGf2tpIHcI9bB/NEZB+QU7M3fwotPk=;
        b=XhevatI2nijjGqz8m5O0AvV05VMBq6bOtqx/erIjrTxNWv3dTndRwPs0pMrfgF2BLV
         eTa2yTkK/qk8ObAGtbU8+ctfuP189xqZ5JYjhnF+doWvHTuJkyRrPfQiqERErAmw2CBu
         DZUAENum0D8tmcJBB8ZE12efqdbG1Z5geeHKuQrwVnt6haElm0z1FFZDBskmx/GrMGLU
         zt2u9ZKCSFggoUREjmNgkrNZ2p9OrmOVp9rVRt3zwAXu3A3B+ibDaKsN6NMu4GUpqPb1
         y2lbl5j1lZVsfKsa5vHhGP2mEAoSpo61X+5sXXeYhcIemA8N+dZcHWv9VBfNhPTNM/Rz
         Hvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892950; x=1697497750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NiBpW9pAzYjkcsGf2tpIHcI9bB/NEZB+QU7M3fwotPk=;
        b=sHzs9hxYwGHP66gTgSCIZiZww0kT162CUH127X9hzL7or1VjWsfzMXNYJiatlhXFWU
         +rq5EusG52/03suIxW24P34KZ6f7jqpbEEtMAqDhZq3xslDYyygypnuhpe5Ec3UOREof
         YN+tucSDKdoyfNvKGEOKRyxACfLhhJk107SMIiB7npQweFaNo0lqzBUySWxy3bRnwUC1
         JfsJLJrVtvhGnGIYR0rdGjloZCok7pf2xxziUgHdzvwRzgFPKH4unMwouNlDfr+qqNxO
         RVA7E+mT5BfPpxHhxz4spdnbVxIadjrgv/mxUx+ov02fcEH04eWQdm7eJK1Fta6wkwuY
         TcyA==
X-Gm-Message-State: AOJu0YyUyzveosS7TsqhOWh/Mjc1H2JN4AJ1aP3fP7ypP41pzG11gS5E
	M17PxrIkkioB8l1n4kLCyKmdCNwOCBmb
X-Google-Smtp-Source: AGHT+IGhUbm0HO7NhAypaQMYBLq6ihENbJzVhn6yFKRW07/auTo8tnu6zuo6xvHt4/x6EbTnXbNJa84X0oC+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:ce89:0:b0:d91:c4e8:bfdd with SMTP id
 x131-20020a25ce89000000b00d91c4e8bfddmr219902ybe.1.1696892950277; Mon, 09 Oct
 2023 16:09:10 -0700 (PDT)
Date: Mon,  9 Oct 2023 23:08:52 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-7-rananta@google.com>
Subject: [PATCH v7 06/12] KVM: arm64: PMU: Add a helper to read the number of counters
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

Add a helper, kvm_arm_get_num_counters(), to read the number
of counters from the arm_pmu associated to the VM. Make the
function global as upcoming patches will be interested to
know the value while setting the PMCR.N of the guest from
userspace.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 17 +++++++++++++++++
 include/kvm/arm_pmu.h     |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a161d6266a5c..84aa8efd9163 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -873,6 +873,23 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+/**
+ * kvm_arm_get_num_counters - Get the number of general-purpose PMU counters.
+ * @kvm: The kvm pointer
+ */
+int kvm_arm_get_num_counters(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/*
+	 * The arm_pmu->num_events considers the cycle counter as well.
+	 * Ignore that and return only the general-purpose counters.
+	 */
+	return arm_pmu->num_events - 1;
+}
+
 static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index cd980d78b86b..672f3e9d7eea 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -102,6 +102,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
+int kvm_arm_get_num_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 #else
@@ -181,6 +182,11 @@ static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
 	return -ENODEV;
 }
 
+static inline int kvm_arm_get_num_counters(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.42.0.609.gbb76f46606-goog

