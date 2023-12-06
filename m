Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7835723761
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sa1u4QYV"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5d8da78a5fbso44889297b3.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857125; x=1702461925; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2TJmXAyMlLq37D84xcPpHxE3ngyDcypNkknRz4uO3sM=;
        b=sa1u4QYVAbEeDsu3JMWowzaZzXTNWNdVRsIR+BXjGE4lG9gB9kIaPZxOuh9+E66g04
         sWA8t3UoUeY0EQLsaVWA6tYhZ//Y6N/7Cr/YbsYt+Fuc4C/VSGKRpYgjhVB4UCoZD5br
         PVN6W7ELxIqvwLfkKrp2p8Dg+2u+y66mO3ik+5y/rBlvrlPuecqDBhpv4zCZRJjVudhn
         MZXxsScwGnglwXa80M7iPD7YpZCl9tJQGmStS4GvKE0Z0Bf+Mm30Y98e+EFuo1H7oskQ
         3nWy3A62QxEIdsk3qM8WK5tUFrbMGp4MBPkoqOLTRcrnOB2DpUIyIyixwF5mstgV07AV
         q/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857125; x=1702461925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2TJmXAyMlLq37D84xcPpHxE3ngyDcypNkknRz4uO3sM=;
        b=dr+QsZRgdHDny4p385IY/I8coQjFVozCxHKxAO7cgrF6oyXtBknMgkBTpAd3C1kwND
         llwcP6Qz62p7x6YGI/7SfuYpp6xBTBm7e3fDbGERh6QJIB6Ca3XA+H3EYOMhgkgEqgxO
         VRmYowbZhIpeE7NoZTUdA5EoWen3sPAi/4T+muhpNs3XzVxy8SJGW93lxCh1D99OCVYz
         aXeMt6RAkre6QpOLxNAdtt0iKjnUBY4e7kagAVaIxHGb7c+TLBIErYFAkuuxGnJtEq9b
         uJmX0MN3wRECHkynmHC0ylecBDJYA25xiSOTpp2hoPHkzcoijABjS/k87MwhoooGcfrZ
         d+dw==
X-Gm-Message-State: AOJu0Yw+V6NtmFlU2jmA5z9ZE50z3PG3ZeRuXd1y5b0gtBs59gEJ0auT
	Yeke3EaEmdRy2JcDF4wIxrqeohcM815x7DPqCv8ZnbaY8ua95W6oX9l+v79SDNoZrUC/h8g6BuP
	Hq7+eNAIThJo/Y94Sl6rWbxV+qZck/UvCPJDPt80t3bmOlf6a7mReq9OQcGI=
X-Google-Smtp-Source: AGHT+IEFzffHRskaWLPakpYdzJ6Gt1ONO3k/HVucINukuH87ikK+agwB0OjnhR1n384HG7K/lV8M1+I4bA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:e0d3:0:b0:d9a:50d2:a8be with SMTP id
 x202-20020a25e0d3000000b00d9a50d2a8bemr4940ybg.1.1701857125216; Wed, 06 Dec
 2023 02:05:25 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:58 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-9-tabba@google.com>
Subject: [PATCH v2 08/12] KVM: arm64: Use generated FGT RES0 bits instead of
 specifying them
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Now that all FGT fields are accounted for and represented, use
the generated value instead of manually specifying them.

For __HFGWTR_EL2_RES0, however, there is no generated value. Its
fields are subset of HFGRTR_EL2, with the remaining being RES0.
Therefore, add a mask that represents the HFGRTR_EL2 only bits
and define __HFGWTR_EL2_* using those and the __HFGRTR_EL2_*
fields.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 34 +++++++++++++++-----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b0dc3249d5cd..5b634e909d1c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -344,34 +344,32 @@
  * Once we get to a point where the two describe the same thing, we'll
  * merge the definitions. One day.
  */
-#define __HFGRTR_EL2_RES0	BIT(51)
+#define __HFGRTR_EL2_RES0	HFGxTR_EL2_RES0
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
 #define __HFGRTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
 
-#define __HFGWTR_EL2_RES0	(BIT(51) | BIT(46) | BIT(42) | BIT(40) | \
-				 BIT(28) | GENMASK(26, 25) | BIT(21) | BIT(18) | \
+/*
+ * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
+ * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
+ */
+#define __HFGxTR_READ_ONLY_MASK	(BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
+				 GENMASK(26, 25) | BIT(21) | BIT(18) | \
 				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
-#define __HFGWTR_EL2_MASK	(GENMASK(49, 47) | GENMASK(45, 43) | \
-				 BIT(41) | GENMASK(39, 29) | BIT(27) | \
-				 GENMASK(24, 22) | GENMASK(20, 19) | \
-				 GENMASK(17, 16) | GENMASK(13, 11) | \
-				 GENMASK(8, 3) | GENMASK(1, 0))
-#define __HFGWTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
-
-#define __HFGITR_EL2_RES0	(BIT(63) | BIT(61))
+#define __HFGWTR_EL2_RES0	(__HFGRTR_EL2_RES0 | __HFGxTR_READ_ONLY_MASK)
+#define __HFGWTR_EL2_MASK	(__HFGRTR_EL2_MASK & ~__HFGxTR_READ_ONLY_MASK)
+#define __HFGWTR_EL2_nMASK	(__HFGRTR_EL2_nMASK & ~__HFGxTR_READ_ONLY_MASK)
+
+#define __HFGITR_EL2_RES0	HFGITR_EL2_RES0
 #define __HFGITR_EL2_MASK	(BIT(62) | BIT(60) | GENMASK(54, 0))
 #define __HFGITR_EL2_nMASK	GENMASK(59, 55)
 
-#define __HDFGRTR_EL2_RES0	(BIT(49) | BIT(42) | GENMASK(39, 38) |	\
-				 GENMASK(21, 20) | BIT(8))
+#define __HDFGRTR_EL2_RES0	HDFGRTR_EL2_RES0
 #define __HDFGRTR_EL2_MASK	(BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
 				 GENMASK(41, 40) | GENMASK(37, 22) | \
 				 GENMASK(19, 9) | GENMASK(7, 0))
 #define __HDFGRTR_EL2_nMASK	GENMASK(62, 59)
 
-#define __HDFGWTR_EL2_RES0	(BIT(63) | GENMASK(59, 58) | BIT(51) | BIT(47) | \
-				 BIT(43) | GENMASK(40, 38) | BIT(34) | BIT(30) | \
-				 BIT(22) | BIT(9) | BIT(6))
+#define __HDFGWTR_EL2_RES0	HDFGWTR_EL2_RES0
 #define __HDFGWTR_EL2_MASK	(GENMASK(57, 52) | GENMASK(50, 48) | \
 				 GENMASK(46, 44) | GENMASK(42, 41) | \
 				 GENMASK(37, 35) | GENMASK(33, 31) | \
@@ -379,12 +377,12 @@
 				 GENMASK(8, 7) | GENMASK(5, 0))
 #define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
 
-#define __HAFGRTR_EL2_RES0	(GENMASK(63, 50) | GENMASK(16, 5))
+#define __HAFGRTR_EL2_RES0	HAFGRTR_EL2_RES0
 #define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
 #define __HAFGRTR_EL2_nMASK	0UL
 
 /* Similar definitions for HCRX_EL2 */
-#define __HCRX_EL2_RES0         (GENMASK(63, 25) | GENMASK(13, 12))
+#define __HCRX_EL2_RES0         HCRX_EL2_RES0
 #define __HCRX_EL2_MASK		(BIT(6))
 #define __HCRX_EL2_nMASK	(GENMASK(24, 14) | GENMASK(11, 7) | GENMASK(5, 0))
 
-- 
2.43.0.rc2.451.g8631bc7472-goog

