Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22934330672
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 11:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771588629; cv=none; b=PFLttmNgzWLBYf1elsiNFXixDwvM0LtT6iduu+ZVmUO/+Mym7UY/4mlXgCyLDQNmwrea31kv1qywy2OQUzD5kN1kE4Lxi1PlNyKsJpEUcuHiEiE82lWbGSZlUXRZ7tI8cnfX2cHWo6/BUfoFwggPoCmEd12DXCYg93aoySO983I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771588629; c=relaxed/simple;
	bh=wPn94aNFuQtf5GjTIoanu6qrzEgiYA0QRcQ0gBQnMbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=oP9jt4QndI5TScehHHp/GTDPyCalnthCYumw88KBhgU6jDUsGbulKCpM1vBeCUjU4xg1oHuj/yConXV+oiapzjzaXzrqt0gjG+1SrPW/HkFzggixMnT2bNYGLZy6TEmOk7Aum13a+qOh6A/nmzqQ6fCqioSm5Q79HtRxlcPyGTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P2oJ6KyZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2oJ6KyZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771588627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pemrUBU8/rbjL9/zoZ7MkscMiByl7zJxATlK5nEq+x0=;
	b=P2oJ6KyZAJGvUDqeSqQC2OmjOdh4U20/o3OFs6FV3X2y0WHEC0b7o7WaSOxeM19BOsT7eE
	3S2S8GBv4/9xESr/ceIQD5dSJHDHkQoGGrOgwkKsjP+7nd/7mc17ONHqJVQtgz/Yw4/d/l
	LObUjaU9rijaUttdh6cf2SakHgc+bk4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-WWIWVKVHOFOwwyz3rTpXXA-1; Fri, 20 Feb 2026 06:57:04 -0500
X-MC-Unique: WWIWVKVHOFOwwyz3rTpXXA-1
X-Mimecast-MFC-AGG-ID: WWIWVKVHOFOwwyz3rTpXXA_1771588623
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4836ff58111so25136475e9.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 03:57:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771588623; x=1772193423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pemrUBU8/rbjL9/zoZ7MkscMiByl7zJxATlK5nEq+x0=;
        b=SvicsUpgmqp4IXi/XeREjf8ozLpagLFtDiwkhJuVDn4Lxi9nRhS90WgqaUBzIQN4Bj
         eZK5SBNLsxITX0p60a8bOZkv0oqIGtJcciOVJgANNUUYeqScmUWHYw8avaqHNWh22tAs
         BqUig2fuKoOQXPeBCdNKLFF6SJprKPNr9R62F0o8UWFSYGaL68QSekzJOSxiQOBNFqCx
         eq/yvxy3bjRRf51sBnZK12Dbrw6l6bpChswaGCgc4LiI9pRAEKVbwensV0AOQJJgdySM
         Hg2kcmHve3i7BI2njscxp5p+eCBZve2RUlPETAaNazjw01KBYo9dhzgUT/rnaMWoHpS2
         uQyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUx5rLBR6+ACW59VDwl8Lsfjz2Fp1R3K81s4QBCAzHkS72gssWrN/lTWwFtIm5GEBuM2xMevQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJj4d8aPJWNvkt1L7sFi7vvRkaW1X2Ggj8v/LPlAykld/rqGV0
	NPHbPATd09q7yWCC3w4x21t8XoxYBpPLj0GoBhGIMONpX8LjaGX+gqphws4nroKQIWMrUBnzm0Y
	Mw3Z2vum4mcZd9SDNmUbOB30Ic5yGoEtV2AJfg15BFydKY79MJe2+pfpPqQ==
X-Gm-Gg: AZuq6aK3upHGd6ox7a9oYOny+ZB2gmDbzG+Pp9RKtwWuwGDSOMrY5pgVkTKblzclviW
	h6SqG5YNSrlsLMINM7GFJV8F1jlSLE6ku45A4yZ0Jbj7PACujF9Frx2DF4TDnNfQ2HaVchm479v
	z4rM/SQ9wEedA302qEYXyZ15M8QANTjyY52FbdR5RX2zvMtQ4IgeHS136X/ZRrItRqF36D2EYmA
	AJk7GMHMMbKxrlg54tQ7Ihe8rNJsZkuIhmrLFEXbS/T3dTnkNhQpX4sjzssvXASMYrdYDShdRvF
	OwsSo9VuNAKvx5BJNOjrSxDoj0edEt+mO/DrrF16Q/2sGQswcLbeip1+SdGmUicNKwS/A6CwAcr
	QSglZZbQvnf39QH/6MEtwwYvRtmDS8j4va6O+PX+cF+FNYjpXcTTBh/YEfUuoGbG9LWHB4m0XCc
	XE9IqWt2ig
X-Received: by 2002:a05:600c:a087:b0:483:71f7:2794 with SMTP id 5b1f17b1804b1-48398a54b94mr145228665e9.15.1771588622597;
        Fri, 20 Feb 2026 03:57:02 -0800 (PST)
X-Received: by 2002:a05:600c:a087:b0:483:71f7:2794 with SMTP id 5b1f17b1804b1-48398a54b94mr145228175e9.15.1771588622099;
        Fri, 20 Feb 2026 03:57:02 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316c2aasm66102295e9.0.2026.02.20.03.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 03:57:01 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: peter.maydell@linaro.org,
	qemu-devel@nongnu.org
Cc: eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	qemu-arm@nongnu.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v6 1/1] target/arm/kvm: add kvm-psci-version vcpu property
Date: Fri, 20 Feb 2026 12:56:56 +0100
Message-ID: <20260220115656.4831-2-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260220115656.4831-1-sebott@redhat.com>
References: <20260220115656.4831-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qDiff3GQugwirxn0DDZh5bY9ALvaFX5dyXj0cVqZnGQ_1771588623
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
 docs/system/arm/cpu-features.rst | 11 ++++++++
 target/arm/cpu.c                 |  8 +++++-
 target/arm/kvm.c                 | 48 ++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 3db1f19401..ce19ae6a04 100644
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
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 10f8280eef..60f391651d 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1144,7 +1144,13 @@ static void arm_cpu_initfn(Object *obj)
      * picky DTB consumer will also provide a helpful error message.
      */
     cpu->dtb_compatible = "qemu,unknown";
-    cpu->psci_version = QEMU_PSCI_VERSION_0_1; /* By default assume PSCI v0.1 */
+    if (!kvm_enabled()) {
+        /* By default KVM will use the newest PSCI version that it knows about.
+         * This can be changed using the kvm-psci-version property.
+         * For others assume PSCI v0.1 by default.
+         */
+        cpu->psci_version = QEMU_PSCI_VERSION_0_1;
+    }
     cpu->kvm_target = QEMU_KVM_ARM_TARGET_NONE;
 
     if (tcg_enabled() || hvf_enabled()) {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ded582e0da..5453460965 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -485,6 +485,28 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
     ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
 }
 
+static char *kvm_get_psci_version(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    return g_strdup_printf("%d.%d",
+                           (int) PSCI_VERSION_MAJOR(cpu->psci_version),
+                           (int) PSCI_VERSION_MINOR(cpu->psci_version));
+}
+
+static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint16_t maj, min;
+
+    if (sscanf(value, "%hd.%hd", &maj, &min) != 2) {
+        error_setg(errp, "Invalid PSCI version.");
+        return;
+    }
+
+    cpu->psci_version = PSCI_VERSION(maj, min);
+}
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -506,6 +528,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
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
@@ -1976,8 +2004,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
-        cpu->psci_version = QEMU_PSCI_VERSION_0_2;
+    if (cpu->psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+        /*
+         * Versions >= v0.2 are backward compatible with v0.2
+         * omit the feature flag for v0.1 .
+         */
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
     if (!arm_feature(env, ARM_FEATURE_AARCH64)) {
@@ -2015,6 +2047,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->psci_version) {
+        psciver = cpu->psci_version;
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

