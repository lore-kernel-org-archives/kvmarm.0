Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EB2214223
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829970; cv=none; b=EJRK9O+grAwaJmydjugA6s5kbMdWVEIu8ymVr3SacgxhOPcUNPLr/7eLEF2c0mt9qEMA+sSAnMbGuuBsE2fu/fyRpyPbZoylnzFgbXftU8RUTWx+Y+CNdctmMkfmWKlUHezDI8p6R4rPGlQt2QSEosYX24w9fsg2nfxm1IL4cvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829970; c=relaxed/simple;
	bh=eXRtX/UUgQvo3bBh+4EiHeDAuA119SvPlV2LgJLgsjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rBWT0vCBCUQZUaXsMXIPxT/WD3KYP8mCUQZpQ4BOKXEvK+EtMvSmv0rtxMS9PKZyIXo3TU8LUB1uMWFB8d04c7KJ+s8q+vjUfCDvWHCy1hnvOrYD7HpmngPJZWHge2OzP8qEWOVAt57X8pdj+KMHsDYzCuLXxBQYw9klzIlDrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0nHxl7k6; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0nHxl7k6"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-73838f64415so1637657a34.3
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 08:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829966; x=1750434766; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1K2XaU3tNN3z0G/Brd+aKIcwvKoH6QYgKOpK8mTmcUQ=;
        b=0nHxl7k6FoyniSH/08QJoj1MHot11y5zp+ZmpjEpYOM6/ou3DzUpVLfX3q9E6FmzLQ
         hKTi/9jgfhq/uwmhxWVKn3Hr401h4Leg6APuUZ/kqqhttA3vjRu7uMQxFKlnlQlShCre
         sllJhhjIz1QN7sU2bu8FM7LngXVz6sl5EZJ+lOJEjOQkQB3WfuaNkXzbu9C0b4wRkofw
         ebOCU6wHhcxfWj2c88rXUuE0jzYtxY3bOlMN7/h44HmzUUXnUr+q9xCYWZb1o34F/U8F
         plppDg1yKb4p5bko+HHX2k6QMvNIt5g+sGnYGSJ/+F8XROp3c9CJDLW/3OJQKBXXrU1r
         1Oqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829966; x=1750434766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1K2XaU3tNN3z0G/Brd+aKIcwvKoH6QYgKOpK8mTmcUQ=;
        b=lkKZWMn6LXKpYM0okGzLGrHaINacte620hj8tR2CgVO6kgHVDZV/pV1RDDmadfVRhv
         J5YyFhJ9qg+dYORUZWvCwJI3487BaJeEn9IhnXwcH2qQQCFI0mt0WSQ8kUlKRwDoUT3w
         +0gYNKqME9sRg+aieWv0h3tIRzRVhsn60lUGBPN0uy27xPaTyvxuMDIVUNhw7hqZKoWx
         iKBuxt8qrQvl1hBP1pFDRgfXGmnxfi+iKs0ZST7Yn7gFpWfQ84j3BbwB8Tb1mT2rGYbB
         rldv0FtBI0gde1X7F8JmVH4C8DrwLmOh2xpVO4PDNNwNV2sjdUdKwuTsTN1ZHXGXlew5
         5PXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFmOCfsN6VwmzDLJoK+lbQXg3U+Cc1Uv61waxYDnE84zQMgG+HDE3JTd+OvoxHRV16iJSmiGc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwH4iKwH8upZvTC+BI+Y8IBlCVwS9nDJ5QymWu/Qq2QgkSybx38
	Tlsvi0kThAZipnpQc1Jpr10jicSUXdi6H+eDzvef62OoUggMCgm6IfiMjRrhvWs3V8ZKtrhmmFb
	CrGisQirKeA==
X-Google-Smtp-Source: AGHT+IHFbGJBseK+0NlITWxhqlLkXWlDYICLQM+zu92+pohfxizATwmXWeCDlmWgZ4GDVI5eahezZ/DYLRTe
X-Received: from otbbu4.prod.google.com ([2002:a05:6830:d04:b0:72b:8185:e90e])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6830:210d:b0:72b:9d5e:9456
 with SMTP id 46e09a7af769-73a36367352mr186163a34.13.1749829966723; Fri, 13
 Jun 2025 08:52:46 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:38 +0000
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-5-rananta@google.com>
Subject: [PATCH v3 4/4] KVM: arm64: selftests: Add test for nASSGIcap attribute
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend vgic_init to test the nASSGIcap attribute, asserting that it is
configurable (within reason) prior to initializing the VGIC.
Additionally, check that userspace cannot set the attribute after the
VGIC has been initialized.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index b3b5fb0ff0a9..aaecba432dbc 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -675,6 +675,46 @@ static void test_v3_its_region(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_v3_nassgicap(void)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic vm;
+	__u8 nassgicap;
+	int ret;
+
+	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	TEST_REQUIRE(!__kvm_has_device_attr(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+					    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap));
+
+	kvm_device_attr_get(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+			    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+	if (!nassgicap) {
+		nassgicap = true;
+		ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+					    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+		TEST_ASSERT(ret && errno == EINVAL,
+			    "Enabled nASSGIcap even though it's unavailable");
+	} else {
+		nassgicap = false;
+		kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+				    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+
+		nassgicap = true;
+		kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+				    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+	}
+
+	kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	ret = __kvm_device_attr_set(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_FEATURES,
+				    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap, &nassgicap);
+	TEST_ASSERT(ret && errno == EBUSY,
+		    "Configured nASSGIcap after initializing the VGIC");
+
+	vm_gic_destroy(&vm);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -730,6 +770,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_last_bit_single_rdist();
 		test_v3_redist_ipa_range_check_at_vcpu_run();
 		test_v3_its_region();
+		test_v3_nassgicap();
 	}
 }
 
-- 
2.50.0.rc2.692.g299adb8693-goog

