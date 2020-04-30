Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A9AC47255
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:49:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1ABE12074A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="efC8vkYg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ABE12074A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8D194B539;
	Thu, 30 Apr 2020 10:49:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vruJ1NXa4cPe; Thu, 30 Apr 2020 10:49:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB234B540;
	Thu, 30 Apr 2020 10:49:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E46A24B4DC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:49:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tK0cB36wPgkr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 10:49:09 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D759C4B52C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:49:08 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id c12so2136069wrp.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=umkbm5KRG1N3np5zJ4HE1sftpuuUyazttPbykboHAm8=;
 b=efC8vkYgvNM1vKeVr2o1KyvheFweWQLdJEpfuO35sBECfVZWnRqYWwF651X3tv7WUl
 y7foAr0R0XqqiZFBrmI42yS1Ovwh7dWqJWSGU7t2oFv+doT6ZnA2r5ymHwPFZD2OBVPT
 pMw0DH9qc39RJ/JvzQIbUxJASJN7ZxUpMhrKoubW3zdb3umhK9O7VKPc1aDoQUlJyVMx
 O+Ei/SA4/M9+HqIx1BrLA84FsSF9Zm4hUlUT/C6/Qx4J7F1lhqzW5VbWxfHgrTX0eWjE
 Nzs6eMyZqIpzGWPgODgpMKn5JoW7WpNAATr3jAtV9DoXK0zChwiEWhVhc5aN3uSgaXwW
 91Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=umkbm5KRG1N3np5zJ4HE1sftpuuUyazttPbykboHAm8=;
 b=qn5RM41yalP+ha1XdF16qNL+4GirUR3y0EP2hQcBGS8HrWOgnDpumB0FCXr/c+B7Fd
 2DMyaxnKgo5/h1oA9cMzjNeVkEsDg8qOuhbkbY6/TNquxfmmODrLKkKIhFufPzdO1gh7
 FXZPLB8KtOs+Oz/bkj0mUP5/kWn4IBX6ontHjqtr5zs/+3xgbTHcb4uIyHD1Wc+d7R+n
 zHGQXb/KXd5Q70M+iR58Yg03TnTos9EfTWe5EPEIFLIPhQjKGLf4QNHmus6IEJqAWR6L
 f/em54ocvnHsPpLrgvH5WvVCbSG62qLoqK4MfkaCgHWFtsit93ByDWhXXQitowSjw+Qs
 /ugw==
X-Gm-Message-State: AGi0PuYXIMZuNxbDKCe3cxYluPU35jg6+H4u4UK5M7s+Us/+1qd3/QnT
 dK2f2CX2aFddJ5t5vbYWDzXHvIPzjX0=
X-Google-Smtp-Source: APiQypIpmxrWfSEem32pw/VDQBnv+MYBdsOIVLgK9Hym1JocNQpMrPcTj2RTIrgFipnFVqbek+O/ww==
X-Received: by 2002:a5d:6841:: with SMTP id o1mr4321497wrw.412.1588258147736; 
 Thu, 30 Apr 2020 07:49:07 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d4b6:9828:8bd2:ce6f])
 by smtp.gmail.com with ESMTPSA id s14sm12054954wmh.18.2020.04.30.07.49.06
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Apr 2020 07:49:07 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 12/15] arm64: kvm: Compile remaining hyp/ files for both
 VHE/nVHE
Date: Thu, 30 Apr 2020 15:48:28 +0100
Message-Id: <20200430144831.59194-13-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200430144831.59194-1-dbrazdil@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
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
index b3de24d7ecd1..e272eedfe19a 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -61,26 +61,8 @@ __efistub__ctype		= _ctype;
  * memory mappings.
  */
 
-__hyp_text___fpsimd_restore_state = __fpsimd_restore_state;
-__hyp_text___fpsimd_save_state = __fpsimd_save_state;
-__hyp_text___guest_enter = __guest_enter;
-__hyp_text___guest_exit = __guest_exit;
 __hyp_text___icache_flags = __icache_flags;
 __hyp_text___kvm_handle_stub_hvc = __kvm_handle_stub_hvc;
-__hyp_text___vgic_v2_perform_cpuif_access = __vgic_v2_perform_cpuif_access;
-__hyp_text___vgic_v3_activate_traps = __vgic_v3_activate_traps;
-__hyp_text___vgic_v3_deactivate_traps = __vgic_v3_deactivate_traps;
-__hyp_text___vgic_v3_get_ich_vtr_el2 = __vgic_v3_get_ich_vtr_el2;
-__hyp_text___vgic_v3_init_lrs = __vgic_v3_init_lrs;
-__hyp_text___vgic_v3_perform_cpuif_access = __vgic_v3_perform_cpuif_access;
-__hyp_text___vgic_v3_read_vmcr = __vgic_v3_read_vmcr;
-__hyp_text___vgic_v3_restore_aprs = __vgic_v3_restore_aprs;
-__hyp_text___vgic_v3_restore_state = __vgic_v3_restore_state;
-__hyp_text___vgic_v3_save_aprs = __vgic_v3_save_aprs;
-__hyp_text___vgic_v3_save_state = __vgic_v3_save_state;
-__hyp_text___vgic_v3_write_vmcr = __vgic_v3_write_vmcr;
-__hyp_text_abort_guest_exit_end = abort_guest_exit_end;
-__hyp_text_abort_guest_exit_start = abort_guest_exit_start;
 __hyp_text_arm64_const_caps_ready = arm64_const_caps_ready;
 __hyp_text_arm64_enable_wa2_handling = arm64_enable_wa2_handling;
 __hyp_text_arm64_ssbd_callback_required = arm64_ssbd_callback_required;
@@ -89,7 +71,6 @@ __hyp_text_cpu_hwcaps = cpu_hwcaps;
 __hyp_text_kimage_voffset = kimage_voffset;
 __hyp_text_kvm_host_data = kvm_host_data;
 __hyp_text_kvm_patch_vector_branch = kvm_patch_vector_branch;
-__hyp_text_kvm_skip_instr32 = kvm_skip_instr32;
 __hyp_text_kvm_update_va_mask = kvm_update_va_mask;
 __hyp_text_kvm_vgic_global_state = kvm_vgic_global_state;
 __hyp_text_panic = panic;
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 2b8286ee8138..41018d25118c 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,8 +7,9 @@ asflags-y := -D__HYPERVISOR__
 ccflags-y := -D__HYPERVISOR__ -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 	     $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-y := ../timer-sr.o timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o \
-	 host_hypercall.o ../hyp-entry.o
+obj-y := ../vgic-v3-sr.o ../timer-sr.o timer-sr.o ../aarch32.o \
+	 ../vgic-v2-cpuif-proxy.o sysreg-sr.o debug-sr.o ../entry.o switch.o \
+	 ../fpsimd.o tlb.o host_hypercall.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
