Return-Path: <SRS0=nOLV=77=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BFFC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 12:26:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 948DB2075E
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 12:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="XImm0NWh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 948DB2075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C31D4B178;
	Thu, 18 Jun 2020 08:26:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qipUUyC9XpIk; Thu, 18 Jun 2020 08:26:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C555A4B157;
	Thu, 18 Jun 2020 08:26:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BEF94B080
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 08:26:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UjZsC-ORsFxK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2020 08:26:14 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5F6D4B183
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 08:26:12 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id l11so5871425wru.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 05:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=5ceSCnqPU+qhFBApWd37Hj9Iarz1DhO8p+J0NPEP0HY=;
 b=XImm0NWhTRSHFfFBJjAzpQWgVma/Daqep8ONE/WtU0eu796P/BJ1Ml/kY6divma1BZ
 divyMCuPOWy2+Na9sCUHeEQHXDGfXSrgILV1ChiotyZiFrKWVTKqgspfJUGxjfiEFgAL
 bs5UNOB+ODc6oS4w10pOJ3JbNBTelTewFdDqnIa1dm5DMNHubszjkQpu58Yxu8UYt6kH
 0U8YLbm977SDUYSQKiIzCGXda5Ch3oM5q6dqt+qPLbB2dq6mnOVBJyXBQWnz3EztZbB2
 sQWwr4W/YZTBEUbTz1tEwW8ducrc7HBqZu1rOprt/H5743BsmmMTZQKJee9lmFylU00/
 TXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=5ceSCnqPU+qhFBApWd37Hj9Iarz1DhO8p+J0NPEP0HY=;
 b=ovRMGzKH88Gm+HytdhbVzFSFfwUybCr0yWVp6i/YitMMJ2LJqeQjPZvUEGbbqJMzZM
 OgL+MlcKrsKcs09OrZ0WIzH6j+KbV85CZW5NuaZggCbsdqmJU5o9j661rYuLoSj8ugd4
 em4r9epbBsMbeOrjhTH2Nay7cAVKzZVtqKfHDFmYbjsgG8NzFCdFi9iM899Em3Uban4o
 lfGJS+FsrEYV5Jm8TVHFbPL0XulwRTqIGZRJxClFEmSZag6CGjrmdunsxNm4t7bbckJr
 rmDgrlL/j0SkJplXQTQhbU/D2Fvcv8Ey2ocVjZylUrrtapJy3qEs+87YFi9dzAczCbcP
 zyxg==
X-Gm-Message-State: AOAM533wuBTMMIPHijuBqeEkZXi5YgJtVkJ6cOMvb8tygMr25G5ouCJc
 GchInXLzFT+1bWdPEbgttcAOPg==
X-Google-Smtp-Source: ABdhPJwR+2X7OijhjCKVfnY0bd5pmPZUZ3Q1eOHRC2W/NjdYmx/NZTyrTPK2hq0x8R87nRQuJSwogQ==
X-Received: by 2002:a5d:654c:: with SMTP id z12mr4248011wrv.315.1592483171911; 
 Thu, 18 Jun 2020 05:26:11 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c1af:c724:158a:e200])
 by smtp.gmail.com with ESMTPSA id 125sm3467359wmc.23.2020.06.18.05.26.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 18 Jun 2020 05:26:11 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 13/15] arm64: kvm: Add comments around __kvm_nvhe_ symbol
 aliases
Date: Thu, 18 Jun 2020 13:25:35 +0100
Message-Id: <20200618122537.9625-14-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618122537.9625-1-dbrazdil@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
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

This patch is part of a series which builds KVM's non-VHE hyp code separately
from VHE and the rest of the kernel.

With all source files split between VHE/nVHE, add comments around the list of
symbols where nVHE code still links against kernel proper. Split them into
groups and explain how each group is currently used.

Some of these dependencies will be removed in the future.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h | 53 +++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 2cc3e7673dc2..da8f39fae5e8 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -61,30 +61,43 @@ __efistub__ctype		= _ctype;
  * memory mappings.
  */
 
-__kvm_nvhe___hyp_panic_string = __hyp_panic_string;
-__kvm_nvhe___hyp_stub_vectors = __hyp_stub_vectors;
-__kvm_nvhe___icache_flags = __icache_flags;
-__kvm_nvhe_arm64_const_caps_ready = arm64_const_caps_ready;
-__kvm_nvhe_arm64_enable_wa2_handling = arm64_enable_wa2_handling;
-__kvm_nvhe_arm64_ssbd_callback_required = arm64_ssbd_callback_required;
-__kvm_nvhe_cpu_hwcap_keys = cpu_hwcap_keys;
-__kvm_nvhe_cpu_hwcaps = cpu_hwcaps;
+/* If nVHE code panics, it ERETs into panic() in EL1. */
+__kvm_nvhe___hyp_panic_string		= __hyp_panic_string;
+__kvm_nvhe_panic			= panic;
+
+/* Values used by the hyp-init vector. */
+__kvm_nvhe___hyp_stub_vectors		= __hyp_stub_vectors;
+__kvm_nvhe_idmap_t0sz			= idmap_t0sz;
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
 #ifdef CONFIG_ARM64_PSEUDO_NMI
-__kvm_nvhe_gic_pmr_sync = gic_pmr_sync;
+__kvm_nvhe_gic_pmr_sync			= gic_pmr_sync;
 #endif
-__kvm_nvhe_idmap_t0sz = idmap_t0sz;
-__kvm_nvhe_kimage_voffset = kimage_voffset;
-__kvm_nvhe_kvm_host_data = kvm_host_data;
-__kvm_nvhe_kvm_patch_vector_branch = kvm_patch_vector_branch;
-__kvm_nvhe_kvm_update_va_mask = kvm_update_va_mask;
-__kvm_nvhe_kvm_vgic_global_state = kvm_vgic_global_state;
-__kvm_nvhe_panic = panic;
+__kvm_nvhe_vgic_v2_cpuif_trap		= vgic_v2_cpuif_trap;
+__kvm_nvhe_vgic_v3_cpuif_trap		= vgic_v3_cpuif_trap;
+
+/* SVE support, currently unused by nVHE. */
 #ifdef CONFIG_ARM64_SVE
-__kvm_nvhe_sve_load_state = sve_load_state;
-__kvm_nvhe_sve_save_state = sve_save_state;
+__kvm_nvhe_sve_save_state		= sve_save_state;
+__kvm_nvhe_sve_load_state		= sve_load_state;
 #endif
-__kvm_nvhe_vgic_v2_cpuif_trap = vgic_v2_cpuif_trap;
-__kvm_nvhe_vgic_v3_cpuif_trap = vgic_v3_cpuif_trap;
 
 #endif /* CONFIG_KVM */
 
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
