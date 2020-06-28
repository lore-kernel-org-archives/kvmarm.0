Return-Path: <SRS0=lsm8=AJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93BAC433E1
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jun 2020 15:05:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73909206F1
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jun 2020 15:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HyxZEMdm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73909206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C5A84B16B;
	Sun, 28 Jun 2020 11:05:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7uh+XyJgoqD2; Sun, 28 Jun 2020 11:05:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 081DE4B1E7;
	Sun, 28 Jun 2020 11:05:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB6864B1AD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jun 2020 11:05:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id edvbbn80PcmW for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Jun 2020 11:05:30 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C32584B1BD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jun 2020 11:05:30 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id o8so13055215wmh.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jun 2020 08:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=YHUnlNTYL8kuwF/dn9zQBQSu72vzEY0j8LWMkkY+iTA=;
 b=HyxZEMdmMjenhtVIcvxQthheSRFco077pY8WtkXUY41J9AOZbJXSuE7IWO+rGrLB3Z
 2B4EDaaZWBGHR3fmBcY2w5N2lmYbjL6MnsSHEZybnXkfLY//RYJOlnoQ64WkkzFYABm2
 RfchE1b7rOOqM/tOboxQk510JiBuersjrMsxMZKtN9d+pCxIIwwcIg4UU9Sjsq84QO9I
 2AcuB8wK9Rtz/sJfzMqB6Kr970cB1wsX8pDy2nzV+xDpaRLlOz8gdRgCmyJeCCg1Wf8w
 TFR0AJ/G9fj2qjKC7GOo6mL2V9O956bzPNEN0tsM4p1Ss132mk7BlOJcshNczi2YlEP5
 vQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=YHUnlNTYL8kuwF/dn9zQBQSu72vzEY0j8LWMkkY+iTA=;
 b=fxQG2+r6+fX1GaOWBmQu8ILs130dkGbzVHL463E6Nhvr2jW5b7BjSPdeqGgiQye83/
 EMpmA90M2GjL1XWdskD9vUEjE7dHBUTMAXBr6vVloZt5Fm+MRR3AI4AxqAiv95pgI8jL
 8+tIeX6eCm2VvKcmpV9nRMPaGqhhubnUXOUrv+oUlk7pm5iHeTmzBjkNjYVPMfkD8fNu
 3gkNd5qco/L1C4vLypm24rTtgO1GDr0O1I6VhHB6DhHTss83XVtUG4Rkvgg+cQWFwZq1
 +zxtBHhUgH4xFxL+htEINTScs/oBRbTSWHzVj838nLtUPHEQAry0CEfDe0bb12uMq2hm
 t9Zw==
X-Gm-Message-State: AOAM532rLSMlRrKKpPx0F9GIPwojNgAYQQUf7EwhBBTklojHtug31e38
 WBV7JR2fId2GeaCUOBZJNXRO8w==
X-Google-Smtp-Source: ABdhPJyeMSzzQ8V3207HGWeldbYr7eNX75C2WX5LkGOOqwTYusGay/wVePdb66wcQXkRCO8Gn2IlsQ==
X-Received: by 2002:a05:600c:2253:: with SMTP id
 a19mr12253529wmm.136.1593356729962; 
 Sun, 28 Jun 2020 08:05:29 -0700 (PDT)
Received: from moi-limbo-9350.home
 (host86-139-146-71.range86-139.btcentralplus.com. [86.139.146.71])
 by smtp.gmail.com with ESMTPSA id n5sm21309350wmi.34.2020.06.28.08.05.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 28 Jun 2020 08:05:29 -0700 (PDT)
From: Beata Michalska <beata.michalska@linaro.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v8 1/2] target/arm: kvm: Handle DABT with no valid ISS
Date: Sun, 28 Jun 2020 16:04:58 +0100
Message-Id: <20200628150459.18566-2-beata.michalska@linaro.org>
In-Reply-To: <20200628150459.18566-1-beata.michalska@linaro.org>
References: <20200628150459.18566-1-beata.michalska@linaro.org>
Cc: qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On ARMv7 & ARMv8 some load/store instructions might trigger a data abort
exception with no valid ISS info to be decoded. The lack of decode info
makes it at least tricky to emulate those instruction which is one of the
(many) reasons why KVM will not even try to do so.

Add support for handling those by requesting KVM to inject external
dabt into the quest.

Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
---
 target/arm/kvm.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index eef3bbd..2dd8a9a 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -39,6 +39,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
 
 static bool cap_has_mp_state;
 static bool cap_has_inject_serror_esr;
+static bool cap_has_inject_ext_dabt;
 
 static ARMHostCPUFeatures arm_host_cpu_features;
 
@@ -245,6 +246,16 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         ret = -EINVAL;
     }
 
+    if (kvm_check_extension(s, KVM_CAP_ARM_NISV_TO_USER)) {
+        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_NISV_TO_USER, 0)) {
+            error_report("Failed to enable KVM_CAP_ARM_NISV_TO_USER cap");
+        } else {
+            /* Set status for supporting the external dabt injection */
+            cap_has_inject_ext_dabt = kvm_check_extension(s,
+                                    KVM_CAP_ARM_INJECT_EXT_DABT);
+        }
+    }
+
     return ret;
 }
 
@@ -810,6 +821,45 @@ void kvm_arm_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
+/**
+ * kvm_arm_handle_dabt_nisv:
+ * @cs: CPUState
+ * @esr_iss: ISS encoding (limited) for the exception from Data Abort
+ *           ISV bit set to '0b0' -> no valid instruction syndrome
+ * @fault_ipa: faulting address for the synchronous data abort
+ *
+ * Returns: 0 if the exception has been handled, < 0 otherwise
+ */
+static int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
+                             uint64_t fault_ipa)
+{
+    /*
+     * Request KVM to inject the external data abort into the guest
+     */
+    if (cap_has_inject_ext_dabt) {
+        struct kvm_vcpu_events events = { };
+        /*
+         * The external data abort event will be handled immediately by KVM
+         * using the address fault that triggered the exit on given VCPU.
+         * Requesting injection of the external data abort does not rely
+         * on any other VCPU state. Therefore, in this particular case, the VCPU
+         * synchronization can be exceptionally skipped.
+         */
+        events.exception.ext_dabt_pending = 1;
+        /*
+         * KVM_CAP_ARM_INJECT_EXT_DABT implies KVM_CAP_VCPU_EVENTS
+         */
+        return kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events);
+
+    } else {
+        error_report("Data abort exception triggered by guest memory access "
+                     "at physical address: 0x"  TARGET_FMT_lx,
+                     (target_ulong)fault_ipa);
+        error_printf("KVM unable to emulate faulting instruction.\n");
+    }
+    return -1;
+}
+
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
 {
     int ret = 0;
@@ -820,7 +870,12 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
             ret = EXCP_DEBUG;
         } /* otherwise return to guest */
         break;
-    default:
+    case KVM_EXIT_ARM_NISV:
+        /* External DABT with no valid iss to decode */
+        ret = kvm_arm_handle_dabt_nisv(cs, run->arm_nisv.esr_iss,
+                                       run->arm_nisv.fault_ipa);
+        break;
+     default:
         qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
                       __func__, run->exit_reason);
         break;
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
