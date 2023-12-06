Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F2F1A725
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foDiQLg2"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-332e2f70092so572430f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857120; x=1702461920; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pwpiYPnrLh7ZPPeMTHXM6zzGCouwusiFVLcrD3/1XkI=;
        b=foDiQLg2l8IBqQiUuk/GR+I0/c7r0MGe/eb/UM5UvWV8qOiaRRMrtwQ1qcAnsIdMd8
         ubKLjE/YVYfPNIP8xdm+IK/6gh1Nw75bwgOtkaFH0h9gNnKzYZwDp7jHfLR9dKRaj7aQ
         7n4wyHb65qKuDWnLsrpxSWH//Yomd/DsMzd30xeQJNnZUYTLYVpg+THNzqwLXJE0ceY0
         EO9BdvDm5dKkkQIPqtFhc57hWfOXLo9sVOqhcc64zhiYZxUDGNLctikff8/EAk8Cysap
         0Wlz24QjB3NuQ/K1Qpp/7yJc3mns7xXqa3xP5T5vjI3G+xdXnndE4Wrj0FQ2JbWzQP4t
         R+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857120; x=1702461920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pwpiYPnrLh7ZPPeMTHXM6zzGCouwusiFVLcrD3/1XkI=;
        b=lxAW2X+0QKgDGbm7gkBSpX+iLdti+vJevg86tKmtHrZnLisdVrvgg4lK13+7nvtVbs
         lgCNP+T6FCfsZRHHcn/DL1jymcuhsczkP7V9fkRkCT/fgJu9b1fOt72mh6MTF7noLD7z
         gx04OhtFD0waiN/l86QtlH+Mge6v1COTTZ4mkOxhIc3fv3qO/j3yHwIrbKI3yQMjtSDo
         xhl9xlLu7jw9mPePpUv5hkbJAGlus43jDFVX+oQShMytyu9mbhluY4VlXAB5+YUmrEU6
         hwKyvXislZZgqL6OkdKv6gUW0LI5X8PPXTFi4fpePunD9cdr8JYmWTG0dowx20WpdDWK
         YdGA==
X-Gm-Message-State: AOJu0YyAUWxp30KHDuc7bozTUGoJ5g+BcT3/kwQzs61adaqeheUBq0Pi
	6f/UESC1hd1xGDfG4+V859zszvroKbwZdZlGdTg1rWCIBNmE5e4Teep7y+QV4tCyv1+USdbdUzX
	5o861hN4JJiY5VOAuLoRpEIrcab3QfqSDocfsN1ZW0aosvdAHSkYAlZ+h+14=
X-Google-Smtp-Source: AGHT+IERN/r4rU8oOHVmYbqOhtc4WXgg80j7W/v0wLqeViOqqlE24uS8quGxh0Y4vDvK9hfQiIh3Ls9ilA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:5d83:0:b0:333:3029:781 with SMTP id
 ci3-20020a5d5d83000000b0033330290781mr2908wrb.3.1701857120003; Wed, 06 Dec
 2023 02:05:20 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:56 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-7-tabba@google.com>
Subject: [PATCH v2 06/12] KVM: arm64: Update and fix FGT register masks
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

New trap bits have been defined in the 2023-09 Arm Architecture
System Registers xml specification [*]. Moreover, the existing
definitions of some of the mask and the RES0 bits overlap, which
could be wrong, confusing, or both.

Update the bits to represent the latest spec (as of this patch,
2023-09), and ensure that the existing bits are consistent.

Subsequent patches will use the generated RES0 fields instead of
specifying them manually. This patch keeps the manual encoding of
the bits to make it easier to review the series.

[*] https://developer.arm.com/downloads/-/exploration-tools

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
2.43.0.rc2.451.g8631bc7472-goog

