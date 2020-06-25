Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B01C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 22:04:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87E2220672
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 22:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aHuGizhF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87E2220672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 327974B195;
	Thu, 25 Jun 2020 18:04:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vCg9H3yi-Ln5; Thu, 25 Jun 2020 18:04:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07CE34B19C;
	Thu, 25 Jun 2020 18:04:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F534B195
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 18:04:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SUuS6nxcZVGb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 18:04:38 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03E494B16E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 18:04:37 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id h5so7453134wrc.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 15:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=xqBewfs0yRv9zowM52KWK7aVpkH8u64GAFft74ama6k=;
 b=aHuGizhFNXvtoOoOQkhV6AY8qTFn6eHcgpzse6Ey3DG4fVDY4YHsUhbRNJDLGMUG4G
 Jz1jOZEfCL3OmxRG/jbiRZlQGJ8rqoGfCQR/REdsdHzhW48Y6QGpXesRCZQvK8SxPDXb
 1jwpNlvba2smvhXI5ELEjVCadeLLvt1UTAwSrLe3TVkT9If0Q/7YM1vgkyZt/qb2JN++
 dVQXZnE8f0flPgJt/p4VtlWnkhtilQQ+mkEWoWaZ45Q5oRz7TZvSwaaIywHHAXJ0+fhi
 D9XjzNY7/aIwJH61OL9Hx2f+P/sEPssAJsb+O6FFbCVrEQtRwdHB0UFntkbd85Qb8LFS
 JnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=xqBewfs0yRv9zowM52KWK7aVpkH8u64GAFft74ama6k=;
 b=g5BakFGR2/95P6ijSxlvOreVufTOJQUx9y2sg48vjCr++bX7eHooPUCzDm2goUYTjC
 iBx7LIpihJNneZhYH9CVQMs2/DCRqvdg5ExZ+l/gTBDQ9Ibe6ecXQkUdChlSvUcoafFS
 6U4DhHrma37I1GrOV4iTj42yE3RNuz67qha8R5BWMGbtrEHOUGut/2EYnO/Q9UYJ18uN
 /RGKi3FPVK7aGk990ZFOs6WpNgrMyZ1KT8+cwrNuWxfQLtwqVFDJ/3le3/VVlD51soER
 Ll2y0AWOIous4baTiWi3RxlnBuEG5ETE3gYvczPS1qtEGCf74Mnv7sRvxcq/ifrW7+8r
 Tc4A==
X-Gm-Message-State: AOAM530J4oQk0Hmyj9RQD45ihh7T69uNIz4MhQ/djNIN6PSGZv5uPzBl
 hF7m2t1PXfXGVGglIjhcI1EMqmy8HDnehg==
X-Google-Smtp-Source: ABdhPJw8L9pew0i5rMwch5DPLjrGZZfv5kS7HkK14p5D0qG3cB0l5PXMDj2qRSEg7bhLPvuMm36/gg==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr335102wrs.270.1593122677110;
 Thu, 25 Jun 2020 15:04:37 -0700 (PDT)
Received: from moi-limbo-9350.home
 (host86-139-146-71.range86-139.btcentralplus.com. [86.139.146.71])
 by smtp.gmail.com with ESMTPSA id l190sm13939277wml.12.2020.06.25.15.04.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 25 Jun 2020 15:04:36 -0700 (PDT)
From: Beata Michalska <beata.michalska@linaro.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v6 1/2] target/arm: kvm: Handle DABT with no valid ISS
Date: Thu, 25 Jun 2020 23:03:35 +0100
Message-Id: <20200625220336.10186-2-beata.michalska@linaro.org>
In-Reply-To: <20200625220336.10186-1-beata.michalska@linaro.org>
References: <20200625220336.10186-1-beata.michalska@linaro.org>
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
 target/arm/kvm.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index eef3bbd..265c4b8 100644
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
 
@@ -810,6 +821,47 @@ void kvm_arm_vm_state_change(void *opaque, int running, RunState state)
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
+        struct kvm_vcpu_events events;
+        /*
+         * KVM_CAP_ARM_INJECT_EXT_DABT support implies one for
+         * KVM_CAP_VCPU_EVENTS
+         */
+        memset(&events, 0, sizeof(events));
+        /*
+         * Skipping all the overhead of syncing vcpu regs back and forth
+         * and messing around with the vcpu_dirty flag to avoid
+         * overwriting changes done by KVM : directly calling
+         * the associated ioctl with the status set for external data abort,
+         * which, in turn, will be directly delivered to the affected vcpu.
+         */
+        events.exception.ext_dabt_pending = 1;
+
+        return kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events);
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
@@ -820,7 +872,12 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
