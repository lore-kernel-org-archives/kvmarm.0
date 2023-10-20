Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020FC2FE09
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EL5P3bwC"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-6ce0c99f117so1715024a34.2
        for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 14:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838063; x=1698442863; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UZTHdI73LjJ+tdCxtrSBfoEJbDPL8Ytb4Ns2eCXo9P0=;
        b=EL5P3bwCbDpykRAS+/1KdlLUpKAOXrRpAS5ILlwxOGIBiXBkOyh7rR4R+1Y4osDvBu
         vr7c95PC/JvC+BXHYLf7shAo0+ppKbXcjS2AlMSjpSWBE60OS/d3I+MvFAg06U1vrAuG
         AGtTG+ZPwycaD1v4hXQBhdjkrRv3gqhnVevPaLrP559D5RAweSLDRFTKvSLSR2Fdokqt
         kVwezJkaRwLOr6zJWJLDDzvZsSaxq06QeWUmIp6EyK5w2B2wjyBMLZ8BXBlMzAqT9ztr
         rsccyONuhK5Twqa3ESTAkJ3BEAYUik3QL+IQL830ZKkldEWccLGib3FJT0zl0H8xtPlW
         c22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838063; x=1698442863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UZTHdI73LjJ+tdCxtrSBfoEJbDPL8Ytb4Ns2eCXo9P0=;
        b=cuMmToKKpwPLZT+Jx0vHDpMtTWtO3gEvOlhnJw7v46XLcUlHmhPxyhHZKQtXE8qvA1
         LC3JQ8ZrSYF+NwPX4LPzuCw8choTGFLR84gCAOrvjSQTVYmnUIb0AGc28Q31NPkljykJ
         Ma4WzgpFJtgpuHQLeGNkBVrMeGkND0zygwytHMU7ijighdnMopXe2wKIUcy6R+kEr2XC
         TfFeb8OZveLTrobygIpPaeX4gZ8A+FqFZZxggA6yG6gvAOJhBmWgC70rvuZDVoj6qPsN
         hXIxnpgBCWDTvy4kgX5PlY/6kmxYknYhdS0Y2q60PUoFG3Mlaq7a9L+N5RqAAlHPlYTh
         /ldg==
X-Gm-Message-State: AOJu0YyYJ8M/Z6cKetPU/ItaIinrlKaPjhq15zofymVuTpRsbhiz4TFP
	/1Tztj43kw3qj2T6vCxZPuep5rMwaLHX
X-Google-Smtp-Source: AGHT+IGmQUtWN2yXPx1W8N9ywV18/lF8tjnlx7PJ7Cm9muwl3a03ohwjxnNV0mAYCF4av1euZ/wFeeKf4Clv
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6830:33c2:b0:6b9:182b:cebc with SMTP
 id q2-20020a05683033c200b006b9182bcebcmr795333ott.7.1697838063058; Fri, 20
 Oct 2023 14:41:03 -0700 (PDT)
Date: Fri, 20 Oct 2023 21:40:46 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-7-rananta@google.com>
Subject: [PATCH v8 06/13] KVM: arm64: Sanitize PM{C,I}NTEN{SET,CLR},
 PMOVS{SET,CLR} before first run
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

For unimplemented counters, the registers PM{C,I}NTEN{SET,CLR}
and PMOVS{SET,CLR} are expected to have the corresponding bits RAZ.
Hence to ensure correct KVM's PMU emulation, mask out the bits in
these registers for these unimplemented counters before the first
vCPU run.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c      |  2 +-
 arch/arm64/kvm/pmu-emul.c | 11 +++++++++++
 include/kvm/arm_pmu.h     |  2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e3074a9e23a8b..3c0bb80483fb1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -857,7 +857,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
-			kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
+			kvm_vcpu_handle_request_reload_pmu(vcpu);
 
 		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
 			kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 9e24581206c24..31e4933293b76 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -788,6 +788,17 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	return val & mask;
 }
 
+void kvm_vcpu_handle_request_reload_pmu(struct kvm_vcpu *vcpu)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
+
+	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
+	__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= mask;
+	__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= mask;
+}
+
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_vcpu_has_pmu(vcpu))
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 2e90f38090e6d..567dc288a5ddb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -63,6 +63,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
+void kvm_vcpu_handle_request_reload_pmu(struct kvm_vcpu *vcpu);
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,
@@ -142,6 +143,7 @@ static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
 						  u64 data, u64 select_idx) {}
+static inline void vm_vcpu_handle_request_reload_pmu(struct kvm_vcpu *vcpu) {}
 static inline int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
 					  struct kvm_device_attr *attr)
 {
-- 
2.42.0.655.g421f12c284-goog

