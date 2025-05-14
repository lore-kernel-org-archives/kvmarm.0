Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEBA293B6B
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 19:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250532; cv=none; b=K52Lx17qAWzr9aQR4o/tjUZlGsSG35vy4A/iGizCgTxphNZzMYhGGZ4I3MPAJflfhQsuJi1n/z5zw6wlS/dRMMdGLsEduvS0hT6gNfERKeanq/8l2xnTML4B7NiKLa5S0s7pTwSuG9+m4aNxI3ExehvKrivDVa79p37Yrh3mQvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250532; c=relaxed/simple;
	bh=YOzE7iJKn1cKrVnHeYmsANZJwRedYEE2+tWwGO6R4Sg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u25OI+y5QmPaxQryLt8IUt/8GoVbGFhE/rOdkhM6BAwHoG01kPEWIWQWrT78qvlLOM8yNpz7C1ian10rvgTKJ0UuHFRowQyrgtg88rxjX9kC2668lNVNOGoXrNqDQtt7zkx7mooodT8U2WMIyuXft7UHVV15AvZktU+a8hDq1m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ht/mMlvJ; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ht/mMlvJ"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-85b3a6c37e2so17013139f.0
        for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 12:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747250530; x=1747855330; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s3CSQ6PBMOqGVYj+xqhMBfKnGOIDEpoWfmf6grdNY9M=;
        b=Ht/mMlvJGWNjUonjQuLGAMlDYLq2sV7xUD4pThoS467vRHqWD7PVDcBteqoQza5BKc
         Xrh4MrXX+bLUu5X6yV4jvtagnn3Ut9e8FBmdcmfi1D1xbC3+k/wjalLMH21zKw3CZy+R
         i/Hdqw03LgAVU4ui20foEH3Uoo7zdsC6s8TDXkb4G13jqJbHtUS9xCXMNeNdUH+5kmov
         13spGbkNTEDj9w1qqc6NplqdYMT/1QExPDGD8WC5GKQSDyQAyaiYF0uTu3oaaf3OiAtQ
         3GqovmLiGDTh8uzTOwo/tMQsFbgBnaGmnivn/Q97aNA94IE+nh1xQIQjLhS/xj87zOjP
         EEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747250530; x=1747855330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s3CSQ6PBMOqGVYj+xqhMBfKnGOIDEpoWfmf6grdNY9M=;
        b=jCV2lVKo2vd3ldGO/LdM2gsTh+xwh/AWsBZjzaanyp7X97poO9J/bkaaDGs4JKeB9O
         /9YDd2/ldesdTLCmYNU4q3jkgbO7E1SmiH1vInBCCyEaz7W/0fSosgH0My1h/qFxQeF8
         IecnojhisduLLSLFv/BeOePapRT3nHmvbuZ5Fy31dJzqLSYQBStoG7hpfSB+Gzwi+QQF
         nqswrEP041iUm/UlbbvbnuUUH/9MXVx//OASChdMt1eOpQyVkXpjQDSzDXwnjqu0H6Tu
         P9X+b93oxx7Sw4PBG29NJ0NrScc0J1gL7cyaeYA9nsM1QM50+T8dd9KDVukU8we19CK8
         XdhQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0ABfZX5vBklP9swIdth3BSMiSZNUV3Hj+TmlFW/hmyNYHTRetoTC137MH7GcazRtGZraAkpc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2VDOImBI1JEtp/WFbcAivBLrOHo6hXqLaG7+r5o/EhvOqQp2W
	19QmbC83QJ/H6dXsllvJIHwuFz1wLPcy/XeF3lH2aL2mW+GzBzWN1V0e4/1YZwlBS43o1spgdJQ
	+R/U79g==
X-Google-Smtp-Source: AGHT+IGg18AnCuBF63uwtJjiLbr7/IX5pN6tnMFQzW8sojexBjp+3ynRNR8yhYl88WVyZs8zmM6M9UEXqLY6
X-Received: from ilbby14.prod.google.com ([2002:a05:6e02:260e:b0:3d8:1a1e:8c05])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:36c8:b0:85b:3791:b2ed
 with SMTP id ca18e2360f4ac-86a08ded21cmr611062639f.8.1747250528149; Wed, 14
 May 2025 12:22:08 -0700 (PDT)
Date: Wed, 14 May 2025 19:21:59 +0000
In-Reply-To: <20250514192159.1751538-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250514192159.1751538-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250514192159.1751538-4-rananta@google.com>
Subject: [PATCH 3/3] KVM: selftests: Extend vgic_init to test GICv4 config attr
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend the arm64 vgic_init test to check KVM_DEV_ARM_VGIC_CONFIG_GICV4
attribute. This includes testing the interface with various
configurations when KVM has vGICv4 enabled (kvm-arm.vgic_v4_enable=1
cmdline) and disabled.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index b3b5fb0ff0a9..adcfaf461b2b 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -675,6 +675,63 @@ static void test_v3_its_region(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_v3_vgicv4_config(void)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	uint8_t gicv4_config;
+	struct vm_gic v;
+	int ret;
+
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	if (__kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+					KVM_DEV_ARM_VGIC_CONFIG_GICV4))
+		return;
+
+	kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+
+	if (gicv4_config == KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE) {
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE;
+		ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+		TEST_ASSERT(ret && errno == ENXIO,
+			"vGICv4 allowed to be disabled even though it's unavailable");
+
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE;
+		ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+		TEST_ASSERT(ret && errno == ENXIO,
+			"vGICv4 allowed to be enabled even though it's unavailable");
+	} else { /* kvm-arm.vgic_v4_enable=1 */
+		TEST_ASSERT(gicv4_config == KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE,
+				"Expected vGICv4 to be enabled by default");
+
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE;
+		kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE;
+		kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE + 1;
+		ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+		TEST_ASSERT(ret && errno == EINVAL,
+			"vGICv4 allowed to be configured with unknown value");
+
+		kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+					KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+		gicv4_config = KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE;
+		ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			KVM_DEV_ARM_VGIC_CONFIG_GICV4, &gicv4_config);
+		TEST_ASSERT(ret && errno == EBUSY,
+			"Changing vGICv4 config allowed after vGIC initialization");
+	}
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -730,6 +787,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
 		test_v3_its_region();
+		test_v3_vgicv4_config();
 	}
 }
 
-- 
2.49.0.1101.gccaa498523-goog

