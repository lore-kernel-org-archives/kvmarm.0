Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6620DC43461
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 09:17:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0764B208B3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 09:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="fSryvZyp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0764B208B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E88A4B25D;
	Thu,  3 Sep 2020 05:17:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T9OfWyIUNvxR; Thu,  3 Sep 2020 05:17:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B5764B21C;
	Thu,  3 Sep 2020 05:17:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA0C14B1C9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 05:17:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SBBbYUHv6yz8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 05:17:54 -0400 (EDT)
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com
 [209.85.218.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B39D4B21C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 05:17:51 -0400 (EDT)
Received: by mail-ej1-f68.google.com with SMTP id a15so2779579ejf.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 02:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=mwdRMAavqdTzOvo7Ir5BJvWRsG9Q05qSRw6OHtvkMgg=;
 b=fSryvZypFiRayJ6qbXdHAuS+6FDnue70hvCWNO7yOK8m0hMkAwkbG1pA/JeNI0g4bP
 6BM7jhcArJY2rH/F2rySk6k1pOyCgrpB3aynRg2CWQT9D+5Gdy/9FaJUCJgmN9O/SF3N
 4+pQVl03npehC5dbcL3VFetoYyKoZjOs1/SuBZd8+sE6LrP6fd+64/cDg6RMPEfAHBdj
 yJWNrZ4eV4GH5S84SAX+WO2Nk68D36mOzVejo4YmLFm+B0tkHmYZu33yKfcuj2dtUon6
 DM77MiypYG43OUNr5/rK0Bs6MkABNFfbRrRvyezu9uc+d9VeuHmo81HSmvyhD1Ku4Qg2
 NVrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=mwdRMAavqdTzOvo7Ir5BJvWRsG9Q05qSRw6OHtvkMgg=;
 b=eIRWELz6ern3Eh8S+E0Fws9JxRR8AelkQ1LAGVx5rMkRAFsS0xNEJ6DzCjAuaSHW1/
 1drqyMaHT0/963IM/o2+itRFDhSeJwKCKENmfqhCH08aPtU4p/B8iJnX93JoeX0SaCdp
 3Dsfbs58DEQth1nLbb+tP+JCIgBx/55gZhMdb6bUGKpeWSy3+DeY/+QY1mvUyEGVRjb1
 7LjqUBfDN3KxzbgTktXZ4D0hGPZmJt8pX4wg24aTN1h+rElfcjc7eJLEbTaA6bihuKzZ
 EywHpyov7iOJq6/jtdZwxTcxXEAzcbjAcElHJ3NNhIVH6xgddkTirtR79gZ26v6zPQaF
 vRRg==
X-Gm-Message-State: AOAM530BxDlYZLw8J8lqQmCAm3n3iZWdgcdBOkb+vvrw08aCe83RacyW
 tZ4D74cn3Pox3SIbaF3NeCPJ1A==
X-Google-Smtp-Source: ABdhPJyIo0tfIVl9zQQOPILZ6Iv+dAifCx9Hj7ENqoQaHZteaS0OleBiI3IwVUhr2OYIrgj5J+SKnQ==
X-Received: by 2002:a17:906:a1d8:: with SMTP id
 bx24mr1085448ejb.161.1599124670371; 
 Thu, 03 Sep 2020 02:17:50 -0700 (PDT)
Received: from localhost
 (dynamic-2a00-1028-919a-a06e-64ac-0036-822c-68d3.ipv6.broadband.iol.cz.
 [2a00:1028:919a:a06e:64ac:36:822c:68d3])
 by smtp.gmail.com with ESMTPSA id l19sm2594526ejn.67.2020.09.03.02.17.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Sep 2020 02:17:49 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 06/10] kvm: arm64: Duplicate arm64_ssbd_callback_required
 for nVHE hyp
Date: Thu,  3 Sep 2020 11:17:08 +0200
Message-Id: <20200903091712.46456-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903091712.46456-1-dbrazdil@google.com>
References: <20200903091712.46456-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hyp keeps track of which cores require SSBD callback by accessing a
kernel-proper global variable. Create an nVHE symbol of the same name
and copy the value from kernel proper to nVHE at KVM init time.

Done in preparation for separating percpu memory owned by kernel
proper and nVHE.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 10 +++++++---
 arch/arm64/kernel/image-vars.h   |  1 -
 arch/arm64/kvm/arm.c             |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c |  3 +++
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 189839c3706a..9db93da35606 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -529,23 +529,27 @@ static inline int kvm_map_vectors(void)
 
 #ifdef CONFIG_ARM64_SSBD
 DECLARE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
+DECLARE_KVM_NVHE_PER_CPU(u64, arm64_ssbd_callback_required);
 
-static inline int hyp_map_aux_data(void)
+static inline int hyp_init_aux_data(void)
 {
 	int cpu, err;
 
 	for_each_possible_cpu(cpu) {
 		u64 *ptr;
 
-		ptr = per_cpu_ptr(&arm64_ssbd_callback_required, cpu);
+		ptr = per_cpu_ptr_nvhe(arm64_ssbd_callback_required, cpu);
 		err = create_hyp_mappings(ptr, ptr + 1, PAGE_HYP);
 		if (err)
 			return err;
+
+		/* Copy value from kernel to hyp. */
+		*ptr = per_cpu(arm64_ssbd_callback_required, cpu);
 	}
 	return 0;
 }
 #else
-static inline int hyp_map_aux_data(void)
+static inline int hyp_init_aux_data(void)
 {
 	return 0;
 }
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8982b68289b7..5fc5eadfb3e6 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -69,7 +69,6 @@ KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
 
 /* Global kernel state accessed by nVHE hyp code. */
-KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
 KVM_NVHE_ALIAS(kvm_host_data);
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 46dc3d75cf13..1bb960812493 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1549,7 +1549,7 @@ static int init_hyp_mode(void)
 		}
 	}
 
-	err = hyp_map_aux_data();
+	err = hyp_init_aux_data();
 	if (err)
 		kvm_err("Cannot map host auxiliary data: %d\n", err);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index cc4f8e790fb3..4662df6330d7 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -27,6 +27,9 @@
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 
+/* Non-VHE copy of the kernel symbol. */
+DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
