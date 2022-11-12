Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9407A23
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:26 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id b1-20020a17090a10c100b0020da29fa5e5so3711655pje.2
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=6TT4ZqLevfbGsrUQg6vXe/HP+4YaOKjVwKyXc7ljgguNWecJvJEyjVPoi1FFZwnHtl
         pQAtkCijt3A4ySfPJjIobUDIqldnob/v15OtsJrtYkcwsZlOvt1ELHvgjCklWdoq39iJ
         yuZaxrUCHIWXGEcG0ZdCNUgKsYvXP7VE6iHQbHiArdXW8N0yJop4NHMIYNmVeAxLRqOI
         7rQ8IuNObh4eEI9W7dwU5vLESIinl0m8GcHtehHC6NO2m59YBT/K9m1HB9eu91P2taZh
         QqgIPOXA+Pcc2aglaag4hIzeIY2uAA/x99sb3da9Mfy3Pih2+Fioh7WlecGaUfcgqyfr
         CkQQ==
X-Gm-Message-State: ANoB5pnhNebu2kLVkkH9iixbhM4I23q0HKxI56B7HDIujYbaB3ri/N1F
	p0PWhKhuoFBd7o/EOu9gD3kWwNbZx3MnIQ==
X-Google-Smtp-Source: AA0mqf6QQp6GfMYPE6XZxs/+skS8K7KjLSTBecvWkfOO3UbLxYSWSVwUiwHGGOFgupv2VbGHKjubxmxwv9+J9A==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:92ca:0:b0:56c:6bcc:cf0e with SMTP id
 k10-20020aa792ca000000b0056c6bcccf0emr6073185pfa.64.1668241046330; Sat, 12
 Nov 2022 00:17:26 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:07 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081707.awUE0uU3bcUvaTdCER4LpNQiyrHRNAS1aGt04sTdco4@z>

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

