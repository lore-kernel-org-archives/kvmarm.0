Return-Path: <SRS0=z6yB=AI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A0AC433DF
	for <kvmarm@archiver.kernel.org>; Sat, 27 Jun 2020 15:26:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3D3221919
	for <kvmarm@archiver.kernel.org>; Sat, 27 Jun 2020 15:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SiLDQW9d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3D3221919
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C2E44B39C;
	Sat, 27 Jun 2020 11:26:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ke1MenJgGVNg; Sat, 27 Jun 2020 11:26:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47DE54B392;
	Sat, 27 Jun 2020 11:26:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9969F4B382
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Jun 2020 11:26:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 39RyW3K4xfS4 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 27 Jun 2020 11:26:23 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B42C4B38B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Jun 2020 11:26:23 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id r12so12221850wrj.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Jun 2020 08:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=sywPQP4YPO8LGxojbcR8IAxntZAWNms0b4i/i1pRSn4=;
 b=SiLDQW9dcgpRB6D+KHc4ARCZLzJcBv9wbmBl4Y3XnNwMMNDquQ8xAkUMQEk4NEqz3I
 US+u4+pR37pYZkW+V+ev0Q7MSo0Zn64BTrOlt06UXkFpBxQmdAkYWi6hyCIp6IX7qecu
 LM1cZqdjmiechPF2m2IKTwf+V2pkZYu/o16dP68nrFoL/AAkEk1GF7aN5QJ4YxHr+6aL
 ZWzsmV26h+uK0gijybQkuWz1WZ6mRGFPLnjXuztj4iiJ5+jQGSfw4cuvAx1sr5tqo9VB
 KrcQljcWTBykuVNj1ecLPGi7tR1Pj+AcDivbiYcOnehl1cb6ABsHZJ9HTlVJWg3nGSKC
 DXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=sywPQP4YPO8LGxojbcR8IAxntZAWNms0b4i/i1pRSn4=;
 b=g3d4P2zeSr9aF2bNomxw9YtJlXNqeRUAxe1GyOwT4PWxzfcZ+Jqu0YU/U6ffdIN5Yt
 mPp/074pMesLuIQ6ycKEPlcm6Fj4Xu38CMPL6iallgkS+ZlsuD6fqxqZ3tRaVmAo/rjd
 fZa3gqPbtJELzgJsQVjoaQhTK8gzjW9+g4HTL/9bQuu1HvPAd89dbmJeEqYB+xrEpJbF
 0NYHTdmYJ/CfZKE8cpzHQSmvLxq4wzSKCkzS9BA5nUdNZ/vhYta//zO5X+jcZ0d+Fdn8
 CNuc10IeQpBWKZgkmNsJ4B4W4N6CdjjeE7nZfnrUADgqcMosqbNYMGN4UF/IWIdRYVh9
 Ff7w==
X-Gm-Message-State: AOAM531GQ66bYEnJ+OMX/O29ZzOfD4foqb2n1oTmfB8UiCwujWOuArda
 hrrvXu4Ez4a+LmqOgr5ioHtWxKcCwqfqOg==
X-Google-Smtp-Source: ABdhPJxkoUM9UcCa/lpe3+bR7cO6H5cyDGmpNECjgEgD+ajwHt0wfs6AcwU6Nii6I2V10pX1h16kXQ==
X-Received: by 2002:adf:f388:: with SMTP id m8mr9219258wro.338.1593271582640; 
 Sat, 27 Jun 2020 08:26:22 -0700 (PDT)
Received: from moi-limbo-9350.home (host-92-18-20-3.as13285.net. [92.18.20.3])
 by smtp.gmail.com with ESMTPSA id
 c6sm20965438wma.15.2020.06.27.08.26.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 27 Jun 2020 08:26:22 -0700 (PDT)
From: Beata Michalska <beata.michalska@linaro.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v7 1/2] target/arm: kvm: Handle DABT with no valid ISS
Date: Sat, 27 Jun 2020 16:25:55 +0100
Message-Id: <20200627152556.7391-2-beata.michalska@linaro.org>
In-Reply-To: <20200627152556.7391-1-beata.michalska@linaro.org>
References: <20200627152556.7391-1-beata.michalska@linaro.org>
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
 target/arm/kvm.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index eef3bbd..3ea6f9a 100644
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
 
@@ -810,6 +821,46 @@ void kvm_arm_vm_state_change(void *opaque, int running, RunState state)
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
+        /*
+         * KVM_CAP_ARM_INJECT_EXT_DABT support implies one for
+         * KVM_CAP_VCPU_EVENTS
+         */
+        struct kvm_vcpu_events events = { };
+        /*
+         * The external data abort event will be handled immediately by KVM
+         * using the address fault that triggered the exit on given VCPU.
+         * Requesting injection of the external data abort does not rely
+         * on any other VCPU state. Therefore, in this particular case, the VCPU
+         * synchronization can be exceptionally skipped.
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
@@ -820,7 +871,12 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
