Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259AB27724
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0I1CQvrd"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33349915da3so6605872f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548147; x=1703152947; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YHMfz93osdDIzHj8sFYcObKkkgc+A/MWXsB9b6JOSI=;
        b=0I1CQvrd5hC7pthJkbaFyzLb8JZMDe16EV0FZDAtYyap/ngjNbUpIf1F51i9FTFG9b
         DmucPyofr61WxA0rDZ+kfig8oMVqg9NvhziHvAJJXx5r6FKNKEMmtTxnL5OQ86m03/ER
         oiiqZYeltWoIOVKtd77RrntNICrwkjUuFPKVdeZ9GsGFOzg3qRs7p5M33+9Xukn8ON7i
         7yrNQeD8YLEWH7r7DIu4ksNPOg7rAOkVkqzClW4Rw3/x1XiHT4tu4dHK1pVlBPij/VAe
         PWGm0vUZdp2reNbVBBwlaFJWHDYN9MV2jitycaFuqcDX6I8IHCWv+qHW3eFzYCH2p3Pl
         wFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548147; x=1703152947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2YHMfz93osdDIzHj8sFYcObKkkgc+A/MWXsB9b6JOSI=;
        b=j35Drn9lJbKmwKstHwkgqo7LTZvlATwzv+t8pX03QJm800ZaZ0B8OyODiXJ6yN+ZyI
         0V7hSEM6HPR2V+pjJqcF7CUIU8KbjVuvmnqxgGHvlcMuXc5dFlZ/xh+xVktoWjzULWlD
         T921XBvA71GMOdx1NYLVKMDIDLQsJHPfWQPg/iY4yIQYBkeLf6XauIIf4VikazkjcZJL
         Q/c2qRTHpMhXTuUO/zie3x9rskBh08kWZH/xWycC3czVLaErwmBhuT6lBV1EY4Eq7SIt
         yRcrs8eAdeZe5nsqIWV05tM4rlfk219hIpX9qdl+XCW3fs8w17H7R/Oq699Q9PvN0dxZ
         Q00A==
X-Gm-Message-State: AOJu0Yxdfs/JRsjQOWtbkWaksnK9eAjM5zyU0oRkPBkMMhxZEKqI0BEK
	pQBVe5kBLfUbnI8RNvJjuAEMOvoHELkMow3YNIO0osnBikbasOHjSq/lrHBxm6k4NOnV6QV7YlN
	0dKkUDKCBRv56AVbA88yGXyWudgLUZWWAnxOp8Xz1pXVRkVhT4wMhWBI5f80=
X-Google-Smtp-Source: AGHT+IGYJ2r+eNVdRL3O6QiEgHCH0b4HeQUoNWeRagEwAx1cqIKSOHfeyUAxUn78URaYgFjOR7hmR2d2KQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:64ca:0:b0:333:3363:2e19 with SMTP id
 f10-20020a5d64ca000000b0033333632e19mr51282wri.12.1702548147402; Thu, 14 Dec
 2023 02:02:27 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:52 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-13-tabba@google.com>
Subject: [PATCH v3 12/17] KVM: arm64: Use generated FGT RES0 bits instead of
 specifying them
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
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
index b0dc3249d5cd..bd20d27f1b33 100644
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
+#define __HFGRTR_ONLY_MASK	(BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
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
+#define __HFGWTR_EL2_RES0	(__HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)
+#define __HFGWTR_EL2_MASK	(__HFGRTR_EL2_MASK & ~__HFGRTR_ONLY_MASK)
+#define __HFGWTR_EL2_nMASK	(__HFGRTR_EL2_nMASK & ~__HFGRTR_ONLY_MASK)
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
2.43.0.472.g3155946c3a-goog

