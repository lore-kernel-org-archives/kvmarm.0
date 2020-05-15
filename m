Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33091C433E4
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DABBD2076A
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="MYaMiRiz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DABBD2076A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82B6D4B4E6;
	Fri, 15 May 2020 06:59:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DQG7Lstb086q; Fri, 15 May 2020 06:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 966324B4F7;
	Fri, 15 May 2020 06:59:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B39A74B4EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8BS-YKStUvWe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 06:59:24 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 909CE4B494
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:16 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id 50so2980112wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 03:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=wKY3Sv04y9T25D28x0+yoca4JqoOKU6viRzuCp/o2d8=;
 b=MYaMiRiz1CtiS090xzgno9gIDJcuB2yEV9pYsHZtfn9MDBV+1Lb61O84bGSxxbGm/3
 elvcYsu2EMhv9Gis8QZnBIOfyFjmlnBWT0yDiIl16ZEZyh3Qm2DUSWuuWJSyOUeY583g
 VlLJUs441j/vco+A7dJ+tQTgMJFr8y3hnQBIXgJ8aKdEObgPU12qX43fP37XyYzPrG1l
 SBK8QAmP9SNb143vdUN+gyCeM1j9SpSGBwNh2pu1WvbRYKCLTVIlN5u/kP3JR6OXkrIu
 rx5ygMcBqj5CmvNXSxpp7oj3wxNgnG8OattGZ5qDmnj7RZ8ahWDTu8FsKX32glfhzpzs
 QbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=wKY3Sv04y9T25D28x0+yoca4JqoOKU6viRzuCp/o2d8=;
 b=f+ONlS08t4KGRa8/IxZJ4uUfdRVKgR7vV/YB78d3zZJWbtbJxdskh6c8KuYwot6o2T
 bVLQUXvjRQX0tUDDSJWM6MZsmolVCuj8maxXG9KoNzI1a0F72fSftfln9SItQ28xD095
 BjH8Rw/RymdsakYs+XIfYcTzUzmxoHtG9uhyh8UgCJqJfIB9xyPNspwUz4ORPTSNnYXD
 hPovcFp+BP+KlJvUAC/s0vuEAPw33k7r4x+qmGRmuM6sBxxw9aO6oQniyVQr/ZaBJWU4
 dw2v7fWIPxda4HVXC0aWA2qGyMvMgRWIpdsLbnxv17DsVVcdAMK5ePshQJ2Aj2fcOF8B
 QdKg==
X-Gm-Message-State: AOAM532bTNkS5d+PdYvXC7RP5AE3qjoIKnqEOaWkhM4dUX1ZEDWKWut+
 oy4PLhi+G3+5t+YZ8RUz5APvng==
X-Google-Smtp-Source: ABdhPJxDpM4n30e5iBr2RTiZvdPUETO1aVERF22wXT/LtFQlS2FUwWdRvrja8ivqmLjEU8Yx1VWMvA==
X-Received: by 2002:a5d:62c7:: with SMTP id o7mr3622526wrv.212.1589540355340; 
 Fri, 15 May 2020 03:59:15 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id l19sm3242185wmj.14.2020.05.15.03.59.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 03:59:14 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2 11/14] arm64: kvm: Compile remaining hyp/ files for both
 VHE/nVHE
Date: Fri, 15 May 2020 11:58:38 +0100
Message-Id: <20200515105841.73532-12-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515105841.73532-1-dbrazdil@google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

This patch is part of a series which builds KVM's non-VHE hyp code separately
from VHE and the rest of the kernel.

The following files in hyp/ contain only code shared by VHE/nVHE:
  vgic-v3-sr.c, aarch32.c, vgic-v2-cpuif-proxy.c, entry.S, fpsimd.S
Compile them under both configurations. Deletions in image-vars.h reflect
eliminated dependencies of nVHE code on the rest of the kernel.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h   | 19 -------------------
 arch/arm64/kvm/hyp/nvhe/Makefile |  5 +++--
 2 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c16cf4e2cd8b..217e5e5a101d 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -61,26 +61,8 @@ __efistub__ctype		= _ctype;
  * memory mappings.
  */
 
-__kvm_nvhe___fpsimd_restore_state = __fpsimd_restore_state;
-__kvm_nvhe___fpsimd_save_state = __fpsimd_save_state;
-__kvm_nvhe___guest_enter = __guest_enter;
-__kvm_nvhe___guest_exit = __guest_exit;
 __kvm_nvhe___icache_flags = __icache_flags;
 __kvm_nvhe___kvm_handle_stub_hvc = __kvm_handle_stub_hvc;
-__kvm_nvhe___vgic_v2_perform_cpuif_access = __vgic_v2_perform_cpuif_access;
-__kvm_nvhe___vgic_v3_activate_traps = __vgic_v3_activate_traps;
-__kvm_nvhe___vgic_v3_deactivate_traps = __vgic_v3_deactivate_traps;
-__kvm_nvhe___vgic_v3_get_ich_vtr_el2 = __vgic_v3_get_ich_vtr_el2;
-__kvm_nvhe___vgic_v3_init_lrs = __vgic_v3_init_lrs;
-__kvm_nvhe___vgic_v3_perform_cpuif_access = __vgic_v3_perform_cpuif_access;
-__kvm_nvhe___vgic_v3_read_vmcr = __vgic_v3_read_vmcr;
-__kvm_nvhe___vgic_v3_restore_aprs = __vgic_v3_restore_aprs;
-__kvm_nvhe___vgic_v3_restore_state = __vgic_v3_restore_state;
-__kvm_nvhe___vgic_v3_save_aprs = __vgic_v3_save_aprs;
-__kvm_nvhe___vgic_v3_save_state = __vgic_v3_save_state;
-__kvm_nvhe___vgic_v3_write_vmcr = __vgic_v3_write_vmcr;
-__kvm_nvhe_abort_guest_exit_end = abort_guest_exit_end;
-__kvm_nvhe_abort_guest_exit_start = abort_guest_exit_start;
 __kvm_nvhe_arm64_const_caps_ready = arm64_const_caps_ready;
 __kvm_nvhe_arm64_enable_wa2_handling = arm64_enable_wa2_handling;
 __kvm_nvhe_arm64_ssbd_callback_required = arm64_ssbd_callback_required;
@@ -89,7 +71,6 @@ __kvm_nvhe_cpu_hwcaps = cpu_hwcaps;
 __kvm_nvhe_kimage_voffset = kimage_voffset;
 __kvm_nvhe_kvm_host_data = kvm_host_data;
 __kvm_nvhe_kvm_patch_vector_branch = kvm_patch_vector_branch;
-__kvm_nvhe_kvm_skip_instr32 = kvm_skip_instr32;
 __kvm_nvhe_kvm_update_va_mask = kvm_update_va_mask;
 __kvm_nvhe_kvm_vgic_global_state = kvm_vgic_global_state;
 __kvm_nvhe_panic = panic;
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index a67958f29fd7..819d5271c49a 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,8 +7,9 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -fno-stack-protector \
 	     -DDISABLE_BRANCH_PROFILING $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-y := ../timer-sr.o timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o \
-	 ../hyp-entry.o
+obj-y := ../vgic-v3-sr.o ../timer-sr.o timer-sr.o ../aarch32.o \
+	 ../vgic-v2-cpuif-proxy.o sysreg-sr.o debug-sr.o ../entry.o switch.o \
+	 ../fpsimd.o tlb.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
