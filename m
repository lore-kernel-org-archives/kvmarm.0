Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBEBC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 11:29:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A33D32074D
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 11:29:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jic+duIi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A33D32074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F0164B244;
	Fri, 29 May 2020 07:29:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nzF9NZOCrQZP; Fri, 29 May 2020 07:29:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 298DA4B256;
	Fri, 29 May 2020 07:29:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6A164B248
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 07:29:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MNQuoD796ag for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 07:29:02 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A61D74B241
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 07:29:02 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id u26so6604572wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 04:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=w+6NOaFlFls8D3nC9x1kOlTsYMd9p22EFlaMUHLZshs=;
 b=jic+duIigQwwbK4619IzvSh0AiA4B4QQuCTNSUVJqvRrkTMqxUsjgsjVq3+sNaiBns
 Nsoua4KhSuyAv52cF03WJU1gJySRhKXrZ3pAA6foREVs/8YeqpX7CF3sYuBNMWcv5Xo/
 5mshbrqUubhrADQMkWLp6rQ8i5nGxiF7yFsSDf5FwJyXKhYrSoQF7mUeSXaHAXuE56NJ
 q1BRLnys3aLaXrTIWH75KAdjGO1z5ZEhO7RCgsPyYr+mjRDFAsPo9RTTdPHvIr0soln0
 U+BgwnPPPHGAIm1bBh5ZRCuquSei+fOodIf5HEvamQTB4zC0RdJfgLqyzft4j+t1FuOz
 61xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=w+6NOaFlFls8D3nC9x1kOlTsYMd9p22EFlaMUHLZshs=;
 b=X//M6uKTPe7Ue//l8KEIKt4iCiwVtr4zn+GiPNaWEI9epfVAZUxhkl+gMfCuzLtnki
 M2e7Vg9C3Tzg2OGpoisakrbsYXP5IbDIcvkyAqczvMqhMDw6LlFFY/dh9FALHLqvSJqW
 vTuPWA7zCzqzg/Ki3Ntu6maLtP88LM3CU+nG2uxsk3siQY266lLtBthcrLu9L7Y0XTBs
 hGNmMB5dqv832xpLEGmPATtVuFeIiAQNu28gkBb+53IlEtM8PDlli3NHU7RHFSRS+f7P
 ceBKcjXDR5GMrTyCm42P9HzdAJ1wn6jBfXdPij0jda9YqtD/650nTWlUBWKSjjsEjz7f
 xBjQ==
X-Gm-Message-State: AOAM531ciY+GvCzhrFwwcfRN55SF/UKFaa+Tc8HvZ1qg8guTyr/f6RNZ
 ilOW5g2v9vD8eoh89NvOOFVmWxGt5eTiaQ==
X-Google-Smtp-Source: ABdhPJyubJqDbMs+wipORBgijIIIt2sWn3Mm075mQ3uI7kGXwETWgXmwBPJ/cggXokP5CeZDDAn22Q==
X-Received: by 2002:a1c:df57:: with SMTP id w84mr8657607wmg.52.1590751741702; 
 Fri, 29 May 2020 04:29:01 -0700 (PDT)
Received: from moi-limbo-9350.home
 (host86-151-121-39.range86-151.btcentralplus.com. [86.151.121.39])
 by smtp.gmail.com with ESMTPSA id h188sm6449053wmh.2.2020.05.29.04.29.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 29 May 2020 04:29:01 -0700 (PDT)
From: Beata Michalska <beata.michalska@linaro.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v5 1/2] target/arm: kvm: Handle DABT with no valid ISS
Date: Fri, 29 May 2020 12:27:56 +0100
Message-Id: <20200529112757.32235-2-beata.michalska@linaro.org>
In-Reply-To: <20200529112757.32235-1-beata.michalska@linaro.org>
References: <20200529112757.32235-1-beata.michalska@linaro.org>
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
 target/arm/cpu.h     |  2 ++
 target/arm/kvm.c     | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 target/arm/kvm_arm.h | 11 +++++++++
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 677584e..3702f21 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -570,6 +570,8 @@ typedef struct CPUARMState {
         uint64_t esr;
     } serror;
 
+    uint8_t ext_dabt_pending; /* Request for injecting ext DABT */
+
     /* State of our input IRQ/FIQ/VIRQ/VFIQ lines */
     uint32_t irq_line_state;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 4bdbe6d..bf84224 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -39,6 +39,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
 
 static bool cap_has_mp_state;
 static bool cap_has_inject_serror_esr;
+static bool cap_has_inject_ext_dabt;
 
 static ARMHostCPUFeatures arm_host_cpu_features;
 
@@ -244,6 +245,16 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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
 
@@ -703,9 +714,16 @@ int kvm_put_vcpu_events(ARMCPU *cpu)
         events.exception.serror_esr = env->serror.esr;
     }
 
+    if (cap_has_inject_ext_dabt) {
+        events.exception.ext_dabt_pending = env->ext_dabt_pending;
+    }
+
     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_VCPU_EVENTS, &events);
     if (ret) {
         error_report("failed to put vcpu events");
+    } else {
+        /* Clear instantly if the call was successful */
+        env->ext_dabt_pending = 0;
     }
 
     return ret;
@@ -819,7 +837,12 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
@@ -955,3 +978,42 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
 {
     return (data - 32) & 0xffff;
 }
+
+int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
+                             uint64_t fault_ipa)
+{
+    ARMCPU *cpu = ARM_CPU(cs);
+    CPUARMState *env = &cpu->env;
+
+   /*
+    * ISS [23:14] is invalid so there is a limited info
+    * on what has just happened so the only *useful* thing that can
+    * be retrieved from ISS is WnR & DFSC (though in some cases WnR
+    * might be less of a value as well)
+    */
+
+    /*
+     * Request KVM to inject the external data abort into the guest
+     * by setting a pending exception on the affected vcpu.
+     */
+    if (cap_has_inject_ext_dabt) {
+        /* Set pending exception */
+        env->ext_dabt_pending = 1;
+        /*
+         * Even though at this point, the vcpu regs are out of sync,
+         * directly calling the KVM_SET_VCPU_EVENTS ioctl without
+         * explicitly synchronizing those, is enough and it also avoids
+         * overwriting changes done by KVM.
+         * The vcpu is not being marked as 'dirty' as all the changes
+         * needed to inject the abort are being handled by KVM only
+         * and there is no need for syncing either way
+         */
+        return kvm_put_vcpu_events(cpu);
+    } else {
+        error_report("Data abort exception triggered by guest memory access "
+                     "at physical address: 0x"  TARGET_FMT_lx,
+                     (target_ulong)fault_ipa);
+        error_printf("KVM unable to emulate faulting instruction.\n");
+        return -1;
+    }
+}
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 48bf5e1..e939e51 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -453,6 +453,17 @@ struct kvm_guest_debug_arch;
 void kvm_arm_copy_hw_debug_data(struct kvm_guest_debug_arch *ptr);
 
 /**
+ * kvm_arm_handle_dabt_nisv:
+ * @cs: CPUState
+ * @esr_iss: ISS encoding (limited) for the exception from Data Abort
+ *           ISV bit set to '0b0' -> no valid instruction syndrome
+ * @fault_ipa: faulting address for the synch data abort
+ *
+ * Returns: 0 if the exception has been handled, < 0 otherwise
+ */
+int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
+                            uint64_t fault_ipa);
+/**
  * its_class_name:
  *
  * Return the ITS class name to use depending on whether KVM acceleration
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
