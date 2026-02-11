Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033142E7185
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823867; cv=none; b=S4m8Cu8Qgp2s3CT5Wxn0bOlFfuCZobNSFVUTDzYi4MdSQ1iwYWwjoAPd/AL2yXuhqpfNYIDbzJ331wB5fDR/jxeIgOh+HYgkezTU/J4Dct5iK0NNqlDl/1YGGPzh/pNLMWq4CsyRXGTjLE+9fF9KWrR4gpfLtfGW1eOrg0nAbVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823867; c=relaxed/simple;
	bh=OLUplhZRE4AQJfM2IG+CREOYzwKW/P8zAEDGcgUfHmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=n/w6Nicy8XNuFOhDtZ6LNBNG5A5TYm3M/UsZfC58jpPo7SeqV3RGCyI0UbUfWVjkKTdGRAWg2y8u7WWN1tgNv5rqPyaEjyP5D1X+Rj0b2uJBxbCQ77UdiqNUEvQ/QG3AvXwaPAMQOAbBQbJQzREmMaAEfEcWKVMbRCapq1qZz0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A+AZNi9i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A+AZNi9i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770823865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KgZLxYej2+Jm/2mAtMCoJI/wRP+Se5cFtNVR14mJ03o=;
	b=A+AZNi9iEp8Ej/3qny/MxrVmSfBOqPZk5nGCLQ3jl5vcxLCr/Kjo3oLUpfGSy+YF9N1+vH
	lAjVBo1b8stjJbCBQLAR1eDpXIAAjLzjw6Qfk9jUxDZv/a4HPq8Mm554dycc4LHIjF9gGY
	uWBdX0upKhhhh2FBwzmbqtbo36MBwOQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-2RWKXSinMSGko1tm8kgt3Q-1; Wed, 11 Feb 2026 10:31:03 -0500
X-MC-Unique: 2RWKXSinMSGko1tm8kgt3Q-1
X-Mimecast-MFC-AGG-ID: 2RWKXSinMSGko1tm8kgt3Q_1770823862
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-482eec44485so15599205e9.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 07:31:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823862; x=1771428662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KgZLxYej2+Jm/2mAtMCoJI/wRP+Se5cFtNVR14mJ03o=;
        b=bAF7ru5I7rNL5h1idW89a4nkecOHfEkozSNgbd4csLSelS7SXk+tCu1nNnn8iiRIIQ
         1WaAzYktGjEZ0RjjzB+Zh1QODolFl8r6crq0pG2yphE7zOnSg8t+jGlKu3aeo6+eYUuk
         bmVVPESQ4mK8fKwjHklvOziSf+x4NGAfsgSy/mAgvtC3EkluF7f6fnxYDAwFWBxGJptD
         8wzy8v+Zk68cvnD1jXV7v8bZbsXIXKfIZSJs/BEoba7f8oEh0j5y2nw1gtEYQyydIjnk
         YshfGeKr0f7Y4WfUjueqTNpKGPsODo0HMehmIvOappROKp1/fm49gqA6qLrlYHodtCs7
         aJWw==
X-Forwarded-Encrypted: i=1; AJvYcCXTqbC+M8pYNYGtgci8FfG1UwDpvJgGbL0PUSvQHX1EYazkV8GzN0J2oSsV3mH2bP2Gco4PzdA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqUQWIoKk9VJZ7GG7+XYIQzejWHhhDzijE4kfeUDsLC6DiQKKu
	iJEofgY4hy5AeuS4YmZUrnUUEWzfnAEAYHPRHWbpOZikG+hH5gR5zjSP5fOamadctBZZhu+yD6I
	ldgToSmwNJU1ckPBXdpJc37fupP0GxsV8yN0n2iAqw7Lwps5Join+Xqotog==
X-Gm-Gg: AZuq6aJnKfL8FW61D5NRit8wYaiLoyR78PjeW76dAduxfYimqXrQ0IovEKbhPS5SNcn
	BQD+aB5V2JlUgF5U06kzr9oCYjmio2fm6KKnEzWMMKEkyDppK7ig+H96i14W7tj8IdGdgrIv7Ss
	S+lSKxTWYO4K119zAQRWxqXiSkLtCfHf0J6eVdomreetK21zdVTxcXxuGjvI6w0pH01LmjFBVsf
	+B111br2eFvuZWUnZj9+1YGyB8cyGxMYfbN6G8piEi0oJXxjJZ/vGRFNF1r6sYLSw8NBppyR+fJ
	4heOhR0g6xIITl7kzFMqBNzEscnKs5SXpow9xKkhNf1iskCAMp8DLTUTDT9gzfYwLzM1du4gyFv
	UwOxV8EG7xyOcmw7BVe3m2Ozqgr2mG37QVhdFkaS6LD/qV32xIakiIbS37MkcyOgzdP9e7ZxxUz
	Y23ONOkNcy
X-Received: by 2002:a05:600c:c16d:b0:480:4a90:1b00 with SMTP id 5b1f17b1804b1-4832021605bmr226049965e9.20.1770823861890;
        Wed, 11 Feb 2026 07:31:01 -0800 (PST)
X-Received: by 2002:a05:600c:c16d:b0:480:4a90:1b00 with SMTP id 5b1f17b1804b1-4832021605bmr226049465e9.20.1770823861415;
        Wed, 11 Feb 2026 07:31:01 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d34657sm6448511f8f.6.2026.02.11.07.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:31:00 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v5 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Wed, 11 Feb 2026 16:30:32 +0100
Message-ID: <20260211153032.19327-3-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260211153032.19327-1-sebott@redhat.com>
References: <20260211153032.19327-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zuQLiz4ApjW0crFJWYv0YFErnCskTWzzjPaDb0wSgtM_1770823862
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Provide a kvm specific vcpu property to override the default
(as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 docs/system/arm/cpu-features.rst | 11 ++++++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm.c                 | 65 +++++++++++++++++++++++++++++++-
 3 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 37d5dfd15b..50b106f2eb 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -204,6 +204,17 @@ the list of KVM VCPU features and their descriptions.
   the guest scheduler behavior and/or be exposed to the guest
   userspace.
 
+``kvm-psci-version``
+  Set the Power State Coordination Interface (PSCI) firmware ABI version
+  that KVM provides to the guest. By default KVM will use the newest
+  version that it knows about (which is PSCI v1.3 in Linux v6.13).
+
+  You only need to set this if you want to be able to migrate this
+  VM to a host machine running an older kernel that does not
+  recognize the PSCI version that this host's kernel defaults to.
+
+  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.
+
 TCG VCPU Features
 =================
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index e146f7e6c4..d3cfd444e8 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1036,6 +1036,12 @@ struct ArchCPU {
     bool kvm_vtime_dirty;
     uint64_t kvm_vtime;
 
+    /*
+     * Intermediate value used during property parsing.
+     * Once finalized, the value should be read from psci_version.
+     */
+    uint32_t kvm_prop_psci_version;
+
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ded582e0da..6d13cb4f3c 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -485,6 +485,46 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
     ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
 }
 
+typedef struct PSCIVersion {
+    uint32_t number;
+    const char *str;
+} PSCIVersion;
+
+static const PSCIVersion psci_versions[] = {
+    { QEMU_PSCI_VERSION_0_1, "0.1" },
+    { QEMU_PSCI_VERSION_0_2, "0.2" },
+    { QEMU_PSCI_VERSION_1_0, "1.0" },
+    { QEMU_PSCI_VERSION_1_1, "1.1" },
+    { QEMU_PSCI_VERSION_1_2, "1.2" },
+    { QEMU_PSCI_VERSION_1_3, "1.3" },
+};
+
+static char *kvm_get_psci_version(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    for (int i = 0; i < ARRAY_SIZE(psci_versions); i++) {
+        if (psci_versions[i].number == cpu->psci_version)
+            return g_strdup(psci_versions[i].str);
+    }
+
+    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
+}
+
+static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    for (int i = 0; i < ARRAY_SIZE(psci_versions); i++) {
+        if (!strcmp(value, psci_versions[i].str)) {
+            cpu->kvm_prop_psci_version = psci_versions[i].number;
+            return;
+        }
+    }
+
+    error_setg(errp, "Invalid PSCI version.");
+}
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -506,6 +546,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
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
@@ -1976,7 +2022,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (cpu->kvm_prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+        /*
+         * Versions >= v0.2 are backward compatible with v0.2
+         * omit the feature flag for v0.1 .
+         */
         cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
@@ -2015,6 +2066,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->kvm_prop_psci_version) {
+        psciver = cpu->kvm_prop_psci_version;
+        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
+        if (ret) {
+            error_report("KVM in this kernel does not support PSCI version %d.%d",
+                         (int) PSCI_VERSION_MAJOR(psciver),
+                         (int) PSCI_VERSION_MINOR(psciver));
+            error_printf("Consider setting the kvm-psci-version property on the "
+                         "migration source.\n");
+            return ret;
+        }
+    }
     /*
      * KVM reports the exact PSCI version it is implementing via a
      * special sysreg. If it is present, use its contents to determine
-- 
2.52.0

