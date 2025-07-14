Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F2727A914
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533992; cv=none; b=F1NGKJxbwJhkKyyI8NE7XoIWrQFxUf24Tc6r9B88l6CeVUN7J5V6v6Zf/tOngUcNSXsKby1mr3pf5bgvhBz+bATELeOa6zeXXPd4pvidRyoE/0XQmlxP2XNGoj0rkESZ57CcCadwZ/GtAHbDTug29jr6mwsO+SOH2/0GdpVZ4QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533992; c=relaxed/simple;
	bh=XicCoLbThtlYTD62aDg8ni1reIMr7qH1gveTP/e6XR4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H7CzxF1n3RFmW6/KhpRknOzQnQ8KG1UqaNqVmvg577gT91zkERfWZkCJJQ+En66y/PtjrHA84Vh5OXEu1FxfLcF13MwZt+s0RTFK6PBtz+ARDOq7gHKszQK2q7D+iBTab3yj6ya3P6k1BmiAr6RI9Q31IXLAQXtxgdQRYU7Bftw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0gP2Z97P; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0gP2Z97P"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-87313ccba79so952628239f.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533988; x=1753138788; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sXnlk8Oj50kBtPmAQ5IhbS6eNdNw6B/15jx/cysRtNw=;
        b=0gP2Z97PSYi2oSYbIkdfv4WZ6F9/csJ0bkYrLqkodKMssf7n+Lm55bMJf5130HQQEe
         hS0NPvhfJQI1o2i+N0gt+2aZhrZK7sIABJse4YL4usV66+qMM1UbsyKFS6x5SVM8uDlp
         0U5xGCamh/V0FvCxwBI0LCJj/yzbPPuTnA9OhaFJVCUI5JRprUiGjOBN2GWVaGCIZw6+
         1BSfgpN9v9vgbqxQdZMyeCqZF88PeUNSd2mx4Af8kYR2qUbm5iiziqa9yi5iVt0/ne0y
         LyWxcHWH0t41WkcVefqklqHpW2eAF6QqxVLOwxX7lKstpuIrb/aQUpH5Q1M+hHv6LYgY
         OlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533988; x=1753138788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sXnlk8Oj50kBtPmAQ5IhbS6eNdNw6B/15jx/cysRtNw=;
        b=CyEovpgmnvejxUGvKX0vlvz1Qw38iAjTaUNJJArsEA+DpahqUn5dQj9csR0OMvxP7P
         2cR/92FRzot27izMkoojNpLcGo5PJMLouHtz2tb9EUe4W/PZEDDAX/eNckY693F/V4xg
         JGkddrUjZy8rBL1NQC+/C7F9mp+yoZtSJOcqqLBKsy6Zkoz0q4RpbpdQ3siW4/WpD36S
         AJ2GVgOEEb3vxJfDkKf6V8w8WiIlWY1nh9GgLK1XGckZahGeIITptjePVZev38PrdSIe
         oeGbh3bb5cSJS7p5CbwSG7sowrXZz+oSE3tvHLGEBMFZbJ8scvvAH8r7NkYD0L+YmdQO
         MNlw==
X-Forwarded-Encrypted: i=1; AJvYcCUfp79AxwPZkF3edMYHJaGbmc/NIa7PC8nWhpyI/5+B23cruq9IOApuy2juISd4D7k0nOBky/A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxq02i8jQ9ixkq0vGsCKyx4HH0p6x9kIZIERQ0Gm57oiAGq6Nar
	6d22O0BpUGlqMiplnHNWCUay6WAm0cdwM97dirJ+wm2iZPVy+JF7mNO6ZbuOf8JPIDr3RBdWRwL
	xOJuLmTX2WMEdO/Q8oTFWr6IpYg==
X-Google-Smtp-Source: AGHT+IE357sOrApLJCq1WzFbQdDxZmtg7XTkGgz6+RXD/fX/V+IYmhdKT8OJFTHuEVtH1u9P9MhFxUvuEWSnRycsww==
X-Received: from iola12.prod.google.com ([2002:a5d:980c:0:b0:86c:f382:ca95])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:27c1:b0:86d:1218:de96 with SMTP id ca18e2360f4ac-8797886bf8fmr1673529039f.12.1752533987975;
 Mon, 14 Jul 2025 15:59:47 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:11 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-18-coltonlewis@google.com>
Subject: [PATCH v4 17/23] KVM: arm64: Enforce PMU event filter at vcpu_load()
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load. If the event is filtered, exclude counting at
all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 16b01320ca77..e21fdd274c2e 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -195,6 +195,47 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 	return hpmn;
 }
 
+/**
+ * kvm_pmu_apply_event_filter()
+ * @vcpu: Pointer to vcpu struct
+ *
+ * To uphold the guarantee of the KVM PMU event filter, we must ensure
+ * no counter counts if the event is filtered. Accomplish this by
+ * filtering all exception levels if the event is filtered.
+ */
+static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	u64 evtyper_set = kvm_pmu_evtyper_mask(vcpu->kvm)
+		& ~kvm_pmu_event_mask(vcpu->kvm)
+		& ~ARMV8_PMU_INCLUDE_EL2;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+	u8 i;
+	u64 val;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+
+		if (vcpu->kvm->arch.pmu_filter &&
+		    !test_bit(val, vcpu->kvm->arch.pmu_filter)) {
+			val |= evtyper_set;
+			val &= ~evtyper_clr;
+		}
+
+		write_pmevtypern(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, vcpu->kvm->arch.pmu_filter)) {
+		val |= evtyper_set;
+		val &= ~evtyper_clr;
+	}
+
+	write_pmccfiltr(val);
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -217,6 +258,8 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_pmu_use_fgt(vcpu))
 		return;
 
+	kvm_pmu_apply_event_filter(vcpu);
+
 	for (i = 0; i < pmu->hpmn_max; i++) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
 		write_pmevcntrn(i, val);
-- 
2.50.0.727.gbf7dc18ff4-goog

