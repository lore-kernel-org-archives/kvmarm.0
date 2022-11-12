Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5E7C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:17:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0755A4B824;
	Sat, 12 Nov 2022 03:17:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d9l0Z05r-M6S; Sat, 12 Nov 2022 03:17:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E6E4B84B;
	Sat, 12 Nov 2022 03:17:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 445D44B7F9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zgoIMv37P4Vb for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:17:27 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 196134B7DB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:27 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 e12-20020a62aa0c000000b0056c12c0aadeso3842816pff.21
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=erREdX/KDsXecKj6gAJQc8HQGGxLcgScAAv0CqZULEU=;
 b=YpZw7R2gC5bvKwjGM8NpdnFt1KqwMZgN0FK+q3Tcnq4RSpkrJ5mlI8gWdBgR1P3PNY
 wtWzQsCJAqHyfWbM4T6Blssr1vYpjmXg8r3avJ3Ag1eRynebA0swGQiLy+T/1xOLVqmx
 uKzeeAOCidZWlofpDaepHSuA37EGmUdkY+nB9QsBoniCzied3NX2L3xwX+W+QenR+ZG1
 qe7sBJhQop7ZDaWqme1bLG2j1DUYNgOzuWcEQ4r62GNmnVKY3n/YokKrJD6DndIW86EL
 O5F8B+cOkhxiU1R0kRa5Etvr8wVBsf/tf0E3jTUURwKOs26mJNks+CHuJUcJpad+jjix
 9UEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=erREdX/KDsXecKj6gAJQc8HQGGxLcgScAAv0CqZULEU=;
 b=1881/kqd9folJ8wOZXAoll7r5TJgKLKOwzY9Xr164ytM3ayF2skBVSYBNUm8YHj2Zx
 Dj5joXuj4CW727mv/qhDECiZl2ZiZZVpMrU22ryU9CsxDWNs3Kpa1Fm4lBBfZpJB8Mn1
 9KO4gvjWPPzcskY9LKuYZstSf5mdHVcSU1PExx2TgHj5uu0szC6zv3qNfRdlSfAukbCj
 NQyeqDLRur6FLip5M4g5skTAOVuplo+5R/N0ZgeWHhYB+8WtR40+WMz2geIYwdhdURnC
 /Rv1bNyoDrqeaz0N+DwUsDSrECeB/iU5SK0KOD+tR3Bt9pOy3HYD/c9ZlqQmG1XwWXfV
 pGew==
X-Gm-Message-State: ANoB5plXsaexjGyvf14me1fmnficgbyMUS7HZNtAAGHX2r0wDSgxg3Wv
 1X4w23p0+F4eDSu/Gga+P09I26LJEHvY/w==
X-Google-Smtp-Source: AA0mqf6QQp6GfMYPE6XZxs/+skS8K7KjLSTBecvWkfOO3UbLxYSWSVwUiwHGGOFgupv2VbGHKjubxmxwv9+J9A==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:92ca:0:b0:56c:6bcc:cf0e with SMTP id
 k10-20020aa792ca000000b0056c6bcccf0emr6073185pfa.64.1668241046330; Sat, 12
 Nov 2022 00:17:26 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:07 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-6-ricarkol@google.com>
Subject: [RFC PATCH 05/12] arm64: Add a capability for FEAT_BBM level 2
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
 dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
 reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvmarm@lists.linux.dev, ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

Add a new capability to detect "Stage-2 Translation table
break-before-make" (FEAT_BBM) level 2.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6062454a9067..ff97fb05d430 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2339,6 +2339,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 1,
 		.matches = has_cpuid_feature,
 	},
+	{
+		.desc = "Stage-2 Translation table break-before-make level 2",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_STAGE2_BBM2,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_EL1_BBM_SHIFT,
+		.field_width = 4,
+		.min_field_value = 2,
+		.matches = has_cpuid_feature,
+	},
 	{
 		.desc = "TLB range maintenance instructions",
 		.capability = ARM64_HAS_TLB_RANGE,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index f1c0347ec31a..f421adbdb08b 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -36,6 +36,7 @@ HAS_PAN
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
+HAS_STAGE2_BBM2
 HAS_STAGE2_FWB
 HAS_SYSREG_GIC_CPUIF
 HAS_TIDCP1
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
