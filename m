Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9902C85F
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JGnR5YlR"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5d7e7e10231so6079667b3.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857130; x=1702461930; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HW/Vv3mSkSFHB5VAj+6EqxXcgxfeUWtj4k9vDGbRJvc=;
        b=JGnR5YlRFu+Ov5X7PIhrSnzwUYZrmMF8rv8YKMP9jH2NRJehYSMKRZOh4c3+rtMSMi
         6TDtBlzQJAtHMlKt7GgaK95Tf0jkZE3OiTcylDXX5pVwsnabejhbhDF9vgyhzyvfCiiA
         scMQxP8EQLULQnKnqr6LQUzTJKbDZqKjieMBHtAWvfrKPPsQKtNaXTKtU60PS5zOZPca
         g7DZ8wEWTqdQUalGVBkENAR+nKO8uFomygRFKhsWkuFqIGWsr+qmDorJiIUvQPDwe+AO
         LRM7+Nb4EPnfgSaUFXO2vhgo5Ur5II69knNlTa3OLZqTrAG4CE7KUTgx3Rg4VL6fDYJb
         umRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857130; x=1702461930;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HW/Vv3mSkSFHB5VAj+6EqxXcgxfeUWtj4k9vDGbRJvc=;
        b=gg3VbWiIOGZkJNVmtzagTaFnytPR2Ak8BIqmwYcFEyr1QEOEao8re8YJUmLwXkk2QJ
         mygVanCVgI4IZkCUk98lQInVSeMj76heTrgWOTI9bSxofE2iRKyX6YpnetLHvSOkiigf
         z4czheZAffg7MqcfekJggKfrPSdukeWgseCXhZFUVPw6bxir9XhGgaPjVugPFHXvwK9A
         1qn42M3c7FXZjSepHMmpLs/WmG846cabVE1Qm0FBGds07NNhxUJZze5de7fvd3xFc9ZX
         h4dCDdqkWgy/3raOJ020tC9Dcj77ZGBkbq07hoePqbiJJ8G+fhGU8wT4obH7NUhwBca4
         cUsg==
X-Gm-Message-State: AOJu0Yy4Douv3wHlE4feToDVwQyhvlcbwfTWKlTH5PFASCeQrMUbl7vy
	6Eci7SX2DhFM3TJKonmPtslGpE/8z4crXPWFtwvxo7r4MKzFEpsEvUq5xGlHrFOZOVgPg3NEIOh
	o3HDQ5LaKxfjq+1GVnbxF5rNflnFRxZGl0WF7RAglfe9ucHvse/K+eemqaNE=
X-Google-Smtp-Source: AGHT+IEaBmTdiG0NoBlZ9erFMtnEWC6ZNpGw+9oQp6BaW3v1/i3+l76rFQRrsI39CL2HJKdSYnpVd0lpbA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:3382:b0:5d3:985c:800c with SMTP id
 fl2-20020a05690c338200b005d3985c800cmr103615ywb.3.1701857130088; Wed, 06 Dec
 2023 02:05:30 -0800 (PST)
Date: Wed,  6 Dec 2023 10:05:00 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-11-tabba@google.com>
Subject: [PATCH v2 10/12] KVM: arm64: Define FGT NMASK bits relative to other fields
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Now that RES0 and MASK have full coverage, no speed to manually
encode NMASK. Calculate it relative to the other fields.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 02442bc90717..cb01dd18f763 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -346,21 +346,21 @@
  */
 #define __HFGRTR_EL2_RES0	HFGxTR_EL2_RES0
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
-#define __HFGRTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
+#define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
 
 #define __HFGWTR_EL2_RES0	(__HFGRTR_EL2_RES0 | HFGWTR_ONLY_EL2_RES0)
 #define __HFGWTR_EL2_MASK	(__HFGRTR_EL2_MASK & ~HFGWTR_ONLY_EL2_RES0)
-#define __HFGWTR_EL2_nMASK	(__HFGRTR_EL2_nMASK & ~HFGWTR_ONLY_EL2_RES0)
+#define __HFGWTR_EL2_nMASK	~(__HFGWTR_EL2_RES0 | __HFGWTR_EL2_MASK)
 
 #define __HFGITR_EL2_RES0	HFGITR_EL2_RES0
 #define __HFGITR_EL2_MASK	(BIT(62) | BIT(60) | GENMASK(54, 0))
-#define __HFGITR_EL2_nMASK	GENMASK(59, 55)
+#define __HFGITR_EL2_nMASK	~(__HFGITR_EL2_RES0 | __HFGITR_EL2_MASK)
 
 #define __HDFGRTR_EL2_RES0	HDFGRTR_EL2_RES0
 #define __HDFGRTR_EL2_MASK	(BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
 				 GENMASK(41, 40) | GENMASK(37, 22) | \
 				 GENMASK(19, 9) | GENMASK(7, 0))
-#define __HDFGRTR_EL2_nMASK	GENMASK(62, 59)
+#define __HDFGRTR_EL2_nMASK	~(__HDFGRTR_EL2_RES0 | __HDFGRTR_EL2_MASK)
 
 #define __HDFGWTR_EL2_RES0	HDFGWTR_EL2_RES0
 #define __HDFGWTR_EL2_MASK	(GENMASK(57, 52) | GENMASK(50, 48) | \
@@ -368,16 +368,16 @@
 				 GENMASK(37, 35) | GENMASK(33, 31) | \
 				 GENMASK(29, 23) | GENMASK(21, 10) | \
 				 GENMASK(8, 7) | GENMASK(5, 0))
-#define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
+#define __HDFGWTR_EL2_nMASK	~(__HDFGWTR_EL2_RES0 | __HDFGWTR_EL2_MASK)
 
 #define __HAFGRTR_EL2_RES0	HAFGRTR_EL2_RES0
 #define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
-#define __HAFGRTR_EL2_nMASK	0UL
+#define __HAFGRTR_EL2_nMASK	~(__HAFGRTR_EL2_RES0 | __HAFGRTR_EL2_MASK)
 
 /* Similar definitions for HCRX_EL2 */
 #define __HCRX_EL2_RES0         HCRX_EL2_RES0
 #define __HCRX_EL2_MASK		(BIT(6))
-#define __HCRX_EL2_nMASK	(GENMASK(24, 14) | GENMASK(11, 7) | GENMASK(5, 0))
+#define __HCRX_EL2_nMASK	~(__HCRX_EL2_RES0 | __HCRX_EL2_MASK)
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
-- 
2.43.0.rc2.451.g8631bc7472-goog

