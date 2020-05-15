Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0F5C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F37EB2074D
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="hem7MA7S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F37EB2074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97D714B4CB;
	Fri, 15 May 2020 06:59:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I4TJset2KPoI; Fri, 15 May 2020 06:59:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06A3C4B4F2;
	Fri, 15 May 2020 06:59:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 444434B4D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KqzdMyz3Zcre for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 06:59:29 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 525714B4DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:18 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id v12so2966401wrp.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 03:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=qIsoQzx8QXc1ir+dRugWu1fsq9J9q4alaZWOk635tTE=;
 b=hem7MA7Smzp8TqztYBuB5W3IWuLc4iqDhkp4S4YrnIqEmIZYd5pPdRcokkZiSQCBXL
 58opF2y7yXszqJ3evDxLwos9xZqkclw8sRQh7P0+fHtLZlqrEbIdYFuY2QzUT/3oNp3+
 56D/84m33gXnqSp+cu9AJxgtA7yK1RJAbAO0VQpW+NCdV214WKsw960f4Toq0JR2zORt
 KAesZDc+Dr2ZIqP8yY5XwJ6nLSGu7pB7APkga9EQl8I78PToaK+HwDB54eqVuf/tRtOS
 pzcnoFrrzdZU3MnypcCryPp2ei+6BLBHpvUaf/5Qk4Uvog7s+owQl8nsBFbR/RUPagH9
 HC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=qIsoQzx8QXc1ir+dRugWu1fsq9J9q4alaZWOk635tTE=;
 b=Cp28PgasnzkL5gic1+58cAbB1D2QFMyB9XUFADOjmvfHSnPgFNOiMTw1wTxRzdkMG2
 cb0jswzCctFvZXi5O3JgWH3lB27+18gPUa0WI47YDyEnxTYzVB22m+wRz0I8yfhC2qvA
 Hgp49AnC/RWzaB4/wKNJeubd/bE6s//VKSnI5RB9eD2RTum0sHiVMkNJZfN6hpyl428j
 rU50wUueshghJ+kYBOvxvDmamswP//jQMqGBRhJcCkXvSbrknHRAabOoMrq7QwTq3Y4x
 eUt/N72IAUTQ4mG/vtEDw28GTz8AJIwBw8a9PCa5s+WM4C1nuf3MwPlfKrExlRjSYt9i
 Pu/w==
X-Gm-Message-State: AOAM532aEAVuS8K9ZXhQ6xXnz5Ykcsr2mjnrPFwXgJGpcTdUruLChYub
 NCUtWkTyVmGA6HEqMqhSk4nXfg==
X-Google-Smtp-Source: ABdhPJyxwMkIRcpBncYa6eIwpuEAvcR55Rq93vJeaU2e4BAy6oJpiroVdqRq+R0wPBTMFUMxTSk9rw==
X-Received: by 2002:adf:fa44:: with SMTP id y4mr3731198wrr.135.1589540357099; 
 Fri, 15 May 2020 03:59:17 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id 128sm3156597wme.39.2020.05.15.03.59.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 03:59:16 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2 12/14] arm64: kvm: Add comments around __kvm_nvhe_ symbol
 aliases
Date: Fri, 15 May 2020 11:58:39 +0100
Message-Id: <20200515105841.73532-13-dbrazdil@google.com>
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

With all source files split between VHE/nVHE, add comments around the list of
symbols where nVHE code still links against kernel proper. Split them into
groups and explain how each group is currently used.

Some of these dependencies will be removed in the future.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h | 47 ++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 217e5e5a101d..0b3a3fe07a64 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -61,23 +61,36 @@ __efistub__ctype		= _ctype;
  * memory mappings.
  */
 
-__kvm_nvhe___icache_flags = __icache_flags;
-__kvm_nvhe___kvm_handle_stub_hvc = __kvm_handle_stub_hvc;
-__kvm_nvhe_arm64_const_caps_ready = arm64_const_caps_ready;
-__kvm_nvhe_arm64_enable_wa2_handling = arm64_enable_wa2_handling;
-__kvm_nvhe_arm64_ssbd_callback_required = arm64_ssbd_callback_required;
-__kvm_nvhe_cpu_hwcap_keys = cpu_hwcap_keys;
-__kvm_nvhe_cpu_hwcaps = cpu_hwcaps;
-__kvm_nvhe_kimage_voffset = kimage_voffset;
-__kvm_nvhe_kvm_host_data = kvm_host_data;
-__kvm_nvhe_kvm_patch_vector_branch = kvm_patch_vector_branch;
-__kvm_nvhe_kvm_update_va_mask = kvm_update_va_mask;
-__kvm_nvhe_kvm_vgic_global_state = kvm_vgic_global_state;
-__kvm_nvhe_panic = panic;
-__kvm_nvhe_sve_load_state = sve_load_state;
-__kvm_nvhe_sve_save_state = sve_save_state;
-__kvm_nvhe_vgic_v2_cpuif_trap = vgic_v2_cpuif_trap;
-__kvm_nvhe_vgic_v3_cpuif_trap = vgic_v3_cpuif_trap;
+/* If nVHE code panics, it ERETs into panic() in EL1. */
+__kvm_nvhe_panic			= panic;
+
+/* Stub HVC IDs are routed to a handler in .hyp.idmap.text. Executed in EL2. */
+__kvm_nvhe___kvm_handle_stub_hvc	= __kvm_handle_stub_hvc;
+
+/* Alternative callbacks, referenced in .altinstructions. Executed in EL1. */
+__kvm_nvhe_arm64_enable_wa2_handling	= arm64_enable_wa2_handling;
+__kvm_nvhe_kvm_patch_vector_branch	= kvm_patch_vector_branch;
+__kvm_nvhe_kvm_update_va_mask		= kvm_update_va_mask;
+
+/* Values used to convert between memory mappings, read-only after init. */
+__kvm_nvhe_kimage_voffset		= kimage_voffset;
+
+/* Data shared with the kernel. */
+__kvm_nvhe_cpu_hwcaps			= cpu_hwcaps;
+__kvm_nvhe_cpu_hwcap_keys		= cpu_hwcap_keys;
+__kvm_nvhe___icache_flags		= __icache_flags;
+__kvm_nvhe_kvm_vgic_global_state	= kvm_vgic_global_state;
+__kvm_nvhe_arm64_ssbd_callback_required	= arm64_ssbd_callback_required;
+__kvm_nvhe_kvm_host_data		= kvm_host_data;
+
+/* Static keys shared with the kernel. */
+__kvm_nvhe_arm64_const_caps_ready	= arm64_const_caps_ready;
+__kvm_nvhe_vgic_v2_cpuif_trap		= vgic_v2_cpuif_trap;
+__kvm_nvhe_vgic_v3_cpuif_trap		= vgic_v3_cpuif_trap;
+
+/* SVE support, currently unused by nVHE. */
+__kvm_nvhe_sve_save_state		= sve_save_state;
+__kvm_nvhe_sve_load_state		= sve_load_state;
 
 #endif /* CONFIG_KVM */
 
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
