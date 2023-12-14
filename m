Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC5E364DE
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3FQc+245"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e2eccf79f8so17297577b3.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548143; x=1703152943; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i5gQXx09qcREZzryPULHtbRcGtK2VgeJB/Kj9vzazEw=;
        b=3FQc+245I8ISlivUGw6cqPqzfvuJS7jJu4P+eM0089byQnTFSGmAAVTnTcqf3g7W4l
         7HPPl1YfcBfsJoH5Wa+YmdzmqWHeQ/C+p4tBqqPNGdUN/ouNzuG9Y7fsa9DQwX4TtYN4
         WEbgku0Qir+ZDft8kJLU+wrKHIXvIWEkYIY3f1amORS5AwZk/dCeJdVxyGEhjrkvamBv
         cNnUykseC/idmhJ9D+K7z/rewq0CjORtNr4r/3aZgMwYp7XJLPho1QsK9gKR4IrF+e+O
         2es0CyFnEUsSpm8ibMZjp5FBhqVnUFaDXUuyKvN+Y382lCzVtUQOYblTbLLrm2owmwZ7
         Ec1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548143; x=1703152943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i5gQXx09qcREZzryPULHtbRcGtK2VgeJB/Kj9vzazEw=;
        b=lmRG+8I/cVe+PL8SKRaRyqKEDGUXNVsPe7tz51EX4cf4IHq9gHL1sgIVRgAXoaH37G
         ZqpG5j8DmjRR7T7oEerTShXoZiOFL8I0UgcAC13xaLRWfyZlW3QJqZVUY0qpDu6OeL4Z
         FHZcem+ggOQ+TAMLhFSONB12k1T4AGc7BjWYbakwkpost81bH5gT4t6C0g++a/Mwuvt1
         HED3YLS/sPxE8guSn2b1d+KjaLGAQS24Y6n7ZwiepF8eBk6UNwn0TDBn6XMicrIxfd4+
         Ivv9bUkPyTJg+MaJm4QPoUXMU/3NTEIWrYxgC5ae20oHYkBFHUZwnXKhiSH+3cuveyJh
         UHWg==
X-Gm-Message-State: AOJu0Ywmz9Kza/4Eo+bRgByCSWylbNimP51QARBM5s9HGJBMKw95G6xk
	17YODWw4MHO4qYNSwXtQoKVDIHawDx604MwtorFXsDxTudTxYUZqsZ5liVHEWJbkcfLQ2amWT9l
	j2PpZzS1dMqpCZbm+4C+ZFx66rqFQ6QofVGnGyAj9XwFfzpPFNguRnCg7Zgw=
X-Google-Smtp-Source: AGHT+IGsVKQuOdWWEcKxeUozb/6rs0MXEj2XWfE6tghHpcrfAfgFpTD/eWCv6Y+3GCtQprtF3oD5mK159g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:3747:b0:5d5:5183:ebd7 with SMTP id
 fw7-20020a05690c374700b005d55183ebd7mr104796ywb.7.1702548142956; Thu, 14 Dec
 2023 02:02:22 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:50 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-11-tabba@google.com>
Subject: [PATCH v3 10/17] KVM: arm64: Update and fix FGT register masks
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

New trap bits have been defined since the latest update to this
patch.  Moreover, the existing definitions of some of the mask
and the RES0 bits overlap, which could be wrong, confusing, or
both.

Update the bits based on DDI0601 2023-09, and ensure that the
existing bits are consistent.

Subsequent patches will use the generated RES0 fields instead of
specifying them manually. This patch keeps the manual encoding of
the bits to make it easier to review the series.

Fixes: 0fd76865006d ("KVM: arm64: Add nPIR{E0}_EL1 to HFG traps")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 39 ++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 7de0a7062625..b0dc3249d5cd 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -344,30 +344,39 @@
  * Once we get to a point where the two describe the same thing, we'll
  * merge the definitions. One day.
  */
-#define __HFGRTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51))
+#define __HFGRTR_EL2_RES0	BIT(51)
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
-#define __HFGRTR_EL2_nMASK	(GENMASK(58, 57) | GENMASK(55, 54) | BIT(50))
+#define __HFGRTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
 
-#define __HFGWTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51) |	\
-				 BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
-				 GENMASK(26, 25) | BIT(21) | BIT(18) |	\
+#define __HFGWTR_EL2_RES0	(BIT(51) | BIT(46) | BIT(42) | BIT(40) | \
+				 BIT(28) | GENMASK(26, 25) | BIT(21) | BIT(18) | \
 				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
-#define __HFGWTR_EL2_MASK	GENMASK(49, 0)
-#define __HFGWTR_EL2_nMASK	(GENMASK(58, 57) | GENMASK(55, 54) | BIT(50))
+#define __HFGWTR_EL2_MASK	(GENMASK(49, 47) | GENMASK(45, 43) | \
+				 BIT(41) | GENMASK(39, 29) | BIT(27) | \
+				 GENMASK(24, 22) | GENMASK(20, 19) | \
+				 GENMASK(17, 16) | GENMASK(13, 11) | \
+				 GENMASK(8, 3) | GENMASK(1, 0))
+#define __HFGWTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
 
-#define __HFGITR_EL2_RES0	GENMASK(63, 57)
-#define __HFGITR_EL2_MASK	GENMASK(54, 0)
-#define __HFGITR_EL2_nMASK	GENMASK(56, 55)
+#define __HFGITR_EL2_RES0	(BIT(63) | BIT(61))
+#define __HFGITR_EL2_MASK	(BIT(62) | BIT(60) | GENMASK(54, 0))
+#define __HFGITR_EL2_nMASK	GENMASK(59, 55)
 
 #define __HDFGRTR_EL2_RES0	(BIT(49) | BIT(42) | GENMASK(39, 38) |	\
 				 GENMASK(21, 20) | BIT(8))
-#define __HDFGRTR_EL2_MASK	~__HDFGRTR_EL2_nMASK
+#define __HDFGRTR_EL2_MASK	(BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
+				 GENMASK(41, 40) | GENMASK(37, 22) | \
+				 GENMASK(19, 9) | GENMASK(7, 0))
 #define __HDFGRTR_EL2_nMASK	GENMASK(62, 59)
 
 #define __HDFGWTR_EL2_RES0	(BIT(63) | GENMASK(59, 58) | BIT(51) | BIT(47) | \
 				 BIT(43) | GENMASK(40, 38) | BIT(34) | BIT(30) | \
 				 BIT(22) | BIT(9) | BIT(6))
-#define __HDFGWTR_EL2_MASK	~__HDFGWTR_EL2_nMASK
+#define __HDFGWTR_EL2_MASK	(GENMASK(57, 52) | GENMASK(50, 48) | \
+				 GENMASK(46, 44) | GENMASK(42, 41) | \
+				 GENMASK(37, 35) | GENMASK(33, 31) | \
+				 GENMASK(29, 23) | GENMASK(21, 10) | \
+				 GENMASK(8, 7) | GENMASK(5, 0))
 #define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
 
 #define __HAFGRTR_EL2_RES0	(GENMASK(63, 50) | GENMASK(16, 5))
@@ -375,9 +384,9 @@
 #define __HAFGRTR_EL2_nMASK	0UL
 
 /* Similar definitions for HCRX_EL2 */
-#define __HCRX_EL2_RES0		(GENMASK(63, 16) | GENMASK(13, 12))
-#define __HCRX_EL2_MASK		(0)
-#define __HCRX_EL2_nMASK	(GENMASK(15, 14) | GENMASK(4, 0))
+#define __HCRX_EL2_RES0         (GENMASK(63, 25) | GENMASK(13, 12))
+#define __HCRX_EL2_MASK		(BIT(6))
+#define __HCRX_EL2_nMASK	(GENMASK(24, 14) | GENMASK(11, 7) | GENMASK(5, 0))
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
-- 
2.43.0.472.g3155946c3a-goog

