Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ADDFC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:15:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2CBB2072E
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="iRnQElWN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2CBB2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D8544B562;
	Thu, 25 Jun 2020 09:15:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QFtlwOMFuxKB; Thu, 25 Jun 2020 09:14:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B8044B2F1;
	Thu, 25 Jun 2020 09:14:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 591F24B4D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iPq5vhgCW4eR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:55 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D56B44B54D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:51 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id j18so5510813wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=2xpUOlwp0j4kixcuMcqYD0AVOmVjntpoGLeDVKp6rbQ=;
 b=iRnQElWNuHWk5fkQJF9im7CPlbJ9s/Bv5rCHrLY97GTMyPQ2dZYP36n/XKpi63GaHn
 JA1R/BQlEchrEHNOQwpdifXawZeODF0nGmB92XE1WjeQEoE2PqOZuCQhAF9rn9N5gNZy
 BMBB4OlK8yg0mXG8GihwNzAkOFUBbWjICQ71Ipnn3KMaWKjAb/jV9bprS88dweJBZLpT
 d5qV++ZR8gnS+iLMEWT0cv2f9upcX3PVnwIVbNslO1QGcenEcmH6uqXPvLljk9KbySxi
 z0sTO6eC0+ZGJlnxY5xs5+hzu2pjm0BQbhnwy10yWjsLoHhvfTNppPi/TqtACFX2TN6r
 RXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=2xpUOlwp0j4kixcuMcqYD0AVOmVjntpoGLeDVKp6rbQ=;
 b=eVjnfme5uYa8oqSAEeAGqdEwKu3YVatiJHpXQSTEqPviN0W9luExrKh/9C7I+YWW7W
 jYXPeskmNR0D8+eJufSdPKSoBvgDKw0lMrJyJiYpuSiUiio9Hon5frogWTxIb02WXMgh
 B/oy6PDH+1HnytSVpaAiGReTE8D+TSt73n/VS1jkIk7xhr1mIredA7KrTEK4ld4HIV52
 I+irgDgs3G+G8ViEC4a7FQGEsNEZxGobgBRkuQ5c6VPdOAIujujdcXGUPizzfugLjgoc
 7N6Y7byZNewQss+e3skjd0aqh+IfXqj2xIzT4DmLtvlmeXQzku3k5Wug8z8Khh+4Tkd3
 sqSw==
X-Gm-Message-State: AOAM532AvuCY4YKa+3pgV3lSkUilGY//5YC7vFKrm9SuHdD/ikV/z5CJ
 /n879Htme8iUFqfMU8Lrpi25Ag==
X-Google-Smtp-Source: ABdhPJxGxJja/jT5oTKGrw+3w0aijL5YvUJiF17syWz5nrHEReD8sNkVNAERPfeh53aofCnuLFYTBA==
X-Received: by 2002:a1c:7fd7:: with SMTP id a206mr3350840wmd.104.1593090890761; 
 Thu, 25 Jun 2020 06:14:50 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id x18sm11904701wmi.35.2020.06.25.06.14.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:49 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 13/15] arm64: kvm: Compile remaining hyp/ files for both
 VHE/nVHE
Date: Thu, 25 Jun 2020 14:14:18 +0100
Message-Id: <20200625131420.71444-14-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
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

The following files in hyp/ contain only code shared by VHE/nVHE:
  vgic-v3-sr.c, aarch32.c, vgic-v2-cpuif-proxy.c, entry.S, fpsimd.S
Compile them under both configurations. Deletions in image-vars.h reflect
eliminated dependencies of nVHE code on the rest of the kernel.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h   | 29 -----------------------------
 arch/arm64/kvm/hyp/Makefile      | 13 +------------
 arch/arm64/kvm/hyp/nvhe/Makefile |  5 +++--
 arch/arm64/kvm/hyp/vhe/Makefile  |  4 +++-
 4 files changed, 7 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 221024e745c9..8ba32bff7bb2 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -63,35 +63,6 @@ __efistub__ctype		= _ctype;
 
 #define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
 
-/* Symbols defined in aarch32.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(kvm_skip_instr32);
-
-/* Symbols defined in entry.S (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__guest_enter);
-KVM_NVHE_ALIAS(__guest_exit);
-KVM_NVHE_ALIAS(abort_guest_exit_end);
-KVM_NVHE_ALIAS(abort_guest_exit_start);
-
-/* Symbols defined in fpsimd.S (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__fpsimd_restore_state);
-KVM_NVHE_ALIAS(__fpsimd_save_state);
-
-/* Symbols defined in vgic-v2-cpuif-proxy.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__vgic_v2_perform_cpuif_access);
-
-/* Symbols defined in vgic-v3-sr.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__vgic_v3_activate_traps);
-KVM_NVHE_ALIAS(__vgic_v3_deactivate_traps);
-KVM_NVHE_ALIAS(__vgic_v3_get_ich_vtr_el2);
-KVM_NVHE_ALIAS(__vgic_v3_init_lrs);
-KVM_NVHE_ALIAS(__vgic_v3_perform_cpuif_access);
-KVM_NVHE_ALIAS(__vgic_v3_read_vmcr);
-KVM_NVHE_ALIAS(__vgic_v3_restore_aprs);
-KVM_NVHE_ALIAS(__vgic_v3_restore_state);
-KVM_NVHE_ALIAS(__vgic_v3_save_aprs);
-KVM_NVHE_ALIAS(__vgic_v3_save_state);
-KVM_NVHE_ALIAS(__vgic_v3_write_vmcr);
-
 /* Alternative callbacks for init-time patching of nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_enable_wa2_handling);
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ef1aa7fe8f5a..f54f0e89a71c 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,16 +10,5 @@ subdir-ccflags-y := -I$(incdir)				\
 		    -DDISABLE_BRANCH_PROFILING		\
 		    $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
+obj-$(CONFIG_KVM) += vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
-
-hyp-y := vgic-v3-sr.o aarch32.o vgic-v2-cpuif-proxy.o entry.o \
-	 fpsimd.o
-
-# KVM code is run at a different exception code with a different map, so
-# compiler instrumentation that inserts callbacks or checks into the code may
-# cause crashes. Just disable it.
-GCOV_PROFILE	:= n
-KASAN_SANITIZE	:= n
-UBSAN_SANITIZE	:= n
-KCOV_INSTRUMENT	:= n
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0f4c544f07db..ad8729f5e814 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,8 +6,9 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o \
-	 ../hyp-entry.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
+obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
+	 ../fpsimd.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index a1dbbc5409bd..090fd1e14be2 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,9 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o ../hyp-entry.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
+obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
+	 ../fpsimd.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
