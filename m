Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474EDC63699
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BED0C20BED
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gEbk0tKi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BED0C20BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 631504B7F6;
	Wed,  4 Nov 2020 13:37:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SJD4TG2jWRf5; Wed,  4 Nov 2020 13:37:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C094B712;
	Wed,  4 Nov 2020 13:37:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 353044B7B7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jgtc58qnqCmq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:37:19 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 121E54B7D5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:37:18 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id 23so2449135wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=k1mZbgF5Ouf6celHonuP3A/s1Eh7mvuRv0TPOHTEAQo=;
 b=gEbk0tKiTb2BPXDRISpv4WCdZLKXkbNLCjo9s0sAl7NmT5+hkNrkumyGOXB7xc/JYH
 YXXMWPL4izPCNAKWaVBjsFPxiTj85GP1FLZnDTuyUdZ7/PODY8ozmEI3bzsOGhIqrlPj
 PR5DFKv8a9eoIKBPgbZOXc7z6HwbThHepHAzSJ6MXbm/AvlBnQLNI1xKBJUgOs7R+/GI
 JpqrxNWZZk9x5mTbJY2i9dQ4QZtZ/ZxKVbnD2PT5EtwNYOfFK8lGQdFnx7W1IwaRFg7W
 n0BgSJehlQZsUSwbm1Db3EwQnJf2RK63eIxGuJPtxBov4BTrqTjJKFIyEAa0/J8LrmfX
 Z3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=k1mZbgF5Ouf6celHonuP3A/s1Eh7mvuRv0TPOHTEAQo=;
 b=pWnoGjYV6jQP6EW+Qr/NuUVhyFQj0QG3hLnvP9vg30tmhTkalAyWP4OPiYESY1NaC7
 UKAW0PIyZGpUR7t7P2xEVlo8dTMsQboT7NFOzQlsfYjFSHpNWHr5KL0TKXLlGYz16X4Q
 OPP2MtgbtKikdCiRNTd5joZaH94nQ/OUGgPiugAY1mptc3/lgZ0Y+/Oj9wxNzpWOCzjU
 EfhoOaOE/y30yx0MtfA/LvAryRCGSKH66mEDsrgYkbbsWEHtap3Cj5KkzctOwHaA52N0
 GoeRf1Y8WsUz2zGGhrriliheixSA45f4iG3R78Pj0VCeuuWfDupksZRqVFYSRaD3iHvy
 MtHQ==
X-Gm-Message-State: AOAM533wh+18vllcolMUk6XXXrZbk0hvonXeaRoE+LL2Abu/e41AWTFk
 jDBB9iVVaC9V1AS05+SQ09AoahhCP3W38/QW
X-Google-Smtp-Source: ABdhPJwJO5eUF6ZkZBcH8S7L48cw9sDQ5/YjzG6ipw3jIJSUlXblzToWcdhHw2LopEHH3RHQGlLScg==
X-Received: by 2002:a7b:cf1a:: with SMTP id l26mr6109935wmg.18.1604515036611; 
 Wed, 04 Nov 2020 10:37:16 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id e7sm4292303wrm.6.2020.11.04.10.37.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:37:15 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 18/26] kvm: arm64: Intercept PSCI_CPU_OFF host SMC calls
Date: Wed,  4 Nov 2020 18:36:22 +0000
Message-Id: <20201104183630.27513-19-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add a handler of the CPU_OFF PSCI host SMC trapped in KVM nVHE hyp code.
When invoked, it changes the recorded state of the core to OFF before
forwarding the call to EL3. If the call fails, it changes the state back
to ON and returns the error to the host.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
index c3d0a6246c66..00dc0cab860c 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci.c
@@ -13,6 +13,8 @@
 #include <kvm/arm_psci.h>
 #include <uapi/linux/psci.h>
 
+#include <nvhe/spinlock.h>
+
 /* Config options set by the host. */
 u32 kvm_host_psci_version = PSCI_VERSION(0, 0);
 u32 kvm_host_psci_function_id[PSCI_FN_MAX];
@@ -20,6 +22,7 @@ s64 hyp_physvirt_offset;
 
 #define __hyp_pa(x) ((phys_addr_t)(x) + hyp_physvirt_offset)
 
+static DEFINE_PER_CPU(hyp_spinlock_t, psci_cpu_lock);
 DEFINE_PER_CPU(enum kvm_nvhe_psci_state, psci_cpu_state);
 
 static u64 get_psci_func_id(struct kvm_cpu_context *host_ctxt)
@@ -76,9 +79,32 @@ static __noreturn unsigned long psci_forward_noreturn(struct kvm_cpu_context *ho
 	hyp_panic(); /* unreachable */
 }
 
+static int psci_cpu_off(u64 func_id, struct kvm_cpu_context *host_ctxt)
+{
+	hyp_spinlock_t *cpu_lock = this_cpu_ptr(&psci_cpu_lock);
+	enum kvm_nvhe_psci_state *cpu_power = this_cpu_ptr(&psci_cpu_state);
+	u32 power_state = (u32)host_ctxt->regs.regs[1];
+	int ret;
+
+	/* Change the recorded state to OFF before forwarding the call. */
+	hyp_spin_lock(cpu_lock);
+	*cpu_power = KVM_NVHE_PSCI_CPU_OFF;
+	hyp_spin_unlock(cpu_lock);
+
+	ret = psci_call(func_id, power_state, 0, 0);
+
+	/* Call was unsuccessful. Restore the recorded state and return to host. */
+	hyp_spin_lock(cpu_lock);
+	*cpu_power = KVM_NVHE_PSCI_CPU_ON;
+	hyp_spin_unlock(cpu_lock);
+	return ret;
+}
+
 static unsigned long psci_0_1_handler(u64 func_id, struct kvm_cpu_context *host_ctxt)
 {
-	if (func_id == kvm_host_psci_function_id[PSCI_FN_MIGRATE])
+	if (func_id == kvm_host_psci_function_id[PSCI_FN_CPU_OFF])
+		return psci_cpu_off(func_id, host_ctxt);
+	else if (func_id == kvm_host_psci_function_id[PSCI_FN_MIGRATE])
 		return psci_forward(host_ctxt);
 	else
 		return PSCI_RET_NOT_SUPPORTED;
@@ -97,6 +123,8 @@ static unsigned long psci_0_2_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_0_2_FN_SYSTEM_RESET:
 		psci_forward_noreturn(host_ctxt);
 		unreachable();
+	case PSCI_0_2_FN_CPU_OFF:
+		return psci_cpu_off(func_id, host_ctxt);
 	default:
 		return PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.29.1.341.ge80a0c044ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
