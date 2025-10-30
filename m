Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1DD2E091B
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843558; cv=none; b=DuNZ7dON+Rf5sXqVQsgB7IVhNUfqs1tto2LieeqI97Oz8bXy0G5aTJCpwUz4YU2eqUz2+IGV1+f5QuZZ5gq3+RhHCVxX70K78r4KqSyBy3yN7aoZ6Q3pSd/PO50jezLtzENKvsYwZ71vGgKQjjoKj61FmMNDyeIh4aFLFU4nGd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843558; c=relaxed/simple;
	bh=yxg5JtWcJU3AQI+LcX9lc7Atq1+nQtMZD0d/LAMglMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=qh3UXkUPdURlXi9tsd+np54wN1McsW8yuuh7nVMLjAevd3SGOKeSiPBF/tWUtzphpFslu8BdEwCUZl3iSfdh+P2uLicLqc0HlvqG0P/k4AH8NbkMoE4i4W1n6WyjIM7df/OsaeVguDUHW05eeQgNiABCxz8Uqi94gQUlNGSht1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WSU+HVtZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WSU+HVtZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761843555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4ko4KBU7aEgwSx+DTL8x/7Jpcfxyw8R2e/RIc9ttX4=;
	b=WSU+HVtZRQp1yMNfNFq0Xgak33SPf2CiUUEt/H1mQLHETu1PKlW51CSdS3q3NxRaWnJw0q
	c/UBRZ9UBftG/H1uGsz01TGeEd2nZef7Q3zt5NtJfTpXDxdEaJJvfgwkE1o53SF6m9XFI6
	/Z2QxEIk5biRX6dz1mjjNqTZRMEEmCQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-UCuIfX8vNjSaBe-3F9PUAw-1; Thu, 30 Oct 2025 12:59:14 -0400
X-MC-Unique: UCuIfX8vNjSaBe-3F9PUAw-1
X-Mimecast-MFC-AGG-ID: UCuIfX8vNjSaBe-3F9PUAw_1761843553
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4298da9effcso1271704f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 09:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843553; x=1762448353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y4ko4KBU7aEgwSx+DTL8x/7Jpcfxyw8R2e/RIc9ttX4=;
        b=WFtUj7bEzM/tJ6eEXevCv3XjCreWOgs8vCSsTKgGeNAMtAqqr4KkOWaNn2yem2nAZh
         NtkKa/A3qNcaBRytTxun73RKeOtyXH6TzwIarEna6kjkU0UWOHSt/7N1//lHr/qXBMVW
         ns/zvDeTCL2R8ERgUOoe723mbSpXBm1gknoi2UCY+4WdcDZbto6EDJLDaB4vD7UxL5RY
         Bdpd4yR3UMILnQ4OUykgbKm88LFvW705aoXmGTF61sv+B10vsLAic3pKt5DA4OD5AqZ0
         JUmo+yJOgaMVHIzuN4aNzmMmqp/eTCIPKdeqTyeZ+G3gyO+Lu0oVt1Wgfv8UZOpeJwiz
         /cLg==
X-Forwarded-Encrypted: i=1; AJvYcCXU2fzUw8LIf+BRnBrFkIy5KoPp/lcMy2Oj2miLJ3MZxnD4fTpa8/ixu9P5Z7FzGS0PGY3JdAU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlSGKpX4yeY3C5FpAX0fQDVP/BGX5RZY98M+mj1gn8vCT3nP9I
	VqoAfLgGCeBxQkeD6fbWenoUczraK4DfabQfKHeSkRZ5SJLhZouqyevVAugJyi4bwu0AOAgg37R
	Zz5+9iY8CRsXU8V+8J78ai20oJx2opu3QFGWkkn4S3ZyPITgFmuxQJeNLtA==
X-Gm-Gg: ASbGnctV0WwaRIAy7VNXGVJZVRAlg/HgH9tSx03Pv65l+ScMuiUcaTCHQBf4NA2Iumv
	Z9FEvz0Uy2mVo5qqBCgUEApQjtAWjDlpxOKsuyjI7jamvW7RrQqKj7PySCmK6PV9e9ZCLbkgr7g
	YPliF5HUJR/6JfvRUHXqKFowFsyXtjPRSatlMwGH8Oj829oFvZ1JxaFiwXzDlmeJRwnXGE0ELo9
	VSKAUx3Pn3bpCrNzMv5PjyghmhAcggNVDEzG18/hsiHgYDIweryJxz3EIZ1Fv0yyQRXYg9Oo+WA
	EfUg39BtRGql1w9qf855lOJ0diRMGIprBxghYlDYqX15r6ZsiyhSphCvFTMqNUC8y/5ofYm+aeE
	DL1ZVVgB75Qm/u6yEI5rtPG1Lw9HLcapyNO/+uK2TbASIwqMA+KBZOmWMepb6krg=
X-Received: by 2002:a05:600c:871a:b0:476:a25f:6a4d with SMTP id 5b1f17b1804b1-477305a6daamr3525415e9.1.1761843552949;
        Thu, 30 Oct 2025 09:59:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtxStmlfeeaS5Y8HP2+7UT81SENobqh4RvvVYY+Oiqs7Zmi4aE+qYv9gWYq8tm8LCZq3ZUGA==
X-Received: by 2002:a05:600c:871a:b0:476:a25f:6a4d with SMTP id 5b1f17b1804b1-477305a6daamr3525165e9.1.1761843552439;
        Thu, 30 Oct 2025 09:59:12 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289e7cf5sm51104085e9.14.2025.10.30.09.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:59:12 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v2 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Thu, 30 Oct 2025 17:59:05 +0100
Message-ID: <20251030165905.73295-3-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251030165905.73295-1-sebott@redhat.com>
References: <20251030165905.73295-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6aMExzL1RnLhCl2sxUfTmBMHmM_CwL7PIPpBdeN8CDc_1761843553
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Provide a kvm specific vcpu property to override the default
(as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 ++++
 target/arm/kvm.c                 | 60 +++++++++++++++++++++++++++++++-
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 37d5dfd15b..1d32ce0fee 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
   the guest scheduler behavior and/or be exposed to the guest
   userspace.
 
+``kvm-psci-version``
+  Override the default (as of kernel v6.13 that would be PSCI v1.3)
+  PSCI version emulated by the kernel. Current valid values are:
+  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
+
 TCG VCPU Features
 =================
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 39f2b2e54d..c2032070b7 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -981,6 +981,12 @@ struct ArchCPU {
      */
     uint32_t psci_version;
 
+    /*
+     * Intermediate value used during property parsing.
+     * Once finalized, the value should be read from psci_version.
+     */
+    uint32_t prop_psci_version;
+
     /* Current power state, access guarded by BQL */
     ARMPSCIState power_state;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0d57081e69..c53b307b76 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
     ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
 }
 
+struct psci_version {
+    uint32_t number;
+    const char *str;
+};
+
+static const struct psci_version psci_versions[] = {
+    { QEMU_PSCI_VERSION_0_1, "0.1" },
+    { QEMU_PSCI_VERSION_0_2, "0.2" },
+    { QEMU_PSCI_VERSION_1_0, "1.0" },
+    { QEMU_PSCI_VERSION_1_1, "1.1" },
+    { QEMU_PSCI_VERSION_1_2, "1.2" },
+    { QEMU_PSCI_VERSION_1_3, "1.3" },
+    { -1, NULL },
+};
+
+static char *kvm_get_psci_version(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const struct psci_version *ver;
+
+    for (ver = psci_versions; ver->number != -1; ver++) {
+        if (ver->number == cpu->prop_psci_version)
+            return g_strdup(ver->str);
+    }
+
+    g_assert_not_reached();
+}
+
+static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const struct psci_version *ver;
+
+    for (ver = psci_versions; ver->number != -1; ver++) {
+        if (!strcmp(value, ver->str)) {
+            cpu->prop_psci_version = ver->number;
+            return;
+        }
+    }
+
+    error_setg(errp, "Invalid PSCI-version value");
+}
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
                              kvm_steal_time_set);
     object_property_set_description(obj, "kvm-steal-time",
                                     "Set off to disable KVM steal time.");
+
+    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
+                            kvm_set_psci_version);
+    object_property_set_description(obj, "kvm-psci-version",
+                                    "Set PSCI version. "
+                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");
 }
 
 bool kvm_arm_pmu_supported(void)
@@ -1959,7 +2008,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
         cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
@@ -1998,6 +2048,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->prop_psci_version) {
+        psciver = cpu->prop_psci_version;
+        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
+        if (ret) {
+            error_report("PSCI version %"PRIx64" is not supported by KVM", psciver);
+            return ret;
+        }
+    }
     /*
      * KVM reports the exact PSCI version it is implementing via a
      * special sysreg. If it is present, use its contents to determine
-- 
2.42.0

