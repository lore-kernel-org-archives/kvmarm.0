Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E6F4D58F
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 10:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iuuGCpJ8"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5cf4696e202so81044497b3.2
        for <kvmarm@lists.linux.dev>; Tue, 05 Dec 2023 02:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701771773; x=1702376573; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mbNXAavyUDHGLFaf/H2Km41MhnGZ7T3zACRWsLnC9PE=;
        b=iuuGCpJ8NJvjBGUH+jq4xfEK4GRux9Ya3jaK2HuV8lEODP+ffO7xlvgvdCq8fPVgku
         Yz/mBuIGZhn8aMn9+Vz9FziiQY9HCcBIbttsPs2eLLxmQYax15zwNEZW0GvvQSg8o3nO
         kTLRasXeoj6Vf8O0M3gwgS3WPR+8JuNeutoE9tHTtUpPWVe1uBN17IjKtRGx7JE2p3JU
         ih6egDiI75hSvULL4jZ2XwfOcopEAH+Cyi7HHlwRbJT0VynyiaTa4paZfZtx1v68pz7n
         okq7bBsXD82HKn4zCU/wv/cydd2h3So/u2MRVeWA/tt9sJtxt4Ls2KM8IuSGmhbNFEAq
         Q8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701771773; x=1702376573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mbNXAavyUDHGLFaf/H2Km41MhnGZ7T3zACRWsLnC9PE=;
        b=q99ite9Boz7rMSWvl+nJEN8lC6tVGVuEL6ruTImUsgvkg8GleKn6vdUh//d8qEgEAs
         l1xsJYMB3PSDNzjoGyNfnCvXSI9F4jlAQ/djqBFMcqyS4Lr9dIVG2p7cu44i9xUzfIXQ
         Dukf9ibV3pofKTVRdPFmo0EfZh3Jsp48ytlf4hEpTRtEzwovojKJ2uJly9kqAYyGis40
         isUUBy2vvEbXe/MGWdTTdnTdXeN4UrKt7ZndOf2J3ttMD0PO/dmqxbEPbylW3AgIhm0c
         Oekxir/yFqE94841x1akQE+99knVRjZvtVMeWch7DaY6cpKAi+XvitDcwbuHGtFwV7oM
         R9sg==
X-Gm-Message-State: AOJu0YzShsxPk9bsPEX248cCCz+C0Mq3phpz3oMOv1p9xFexE8SlX2uO
	t1CSnMIr70ryN7LxOBy7vxf/VR0xWd5u4d/vLAQPwVxx56W8LhV1tZZ7+qCbCmON59yqr24NBuA
	GkZFzitJX+zxEVLsBiveAHpngHyp/28FNnnUiYGgwdPFefwAfu3z9YAGaTfM=
X-Google-Smtp-Source: AGHT+IGH2qVpi9pIihf+uYi2PWJUGykJ/mYbA55qLn6qtxabqj4DOzm6cFRAS/uACLoa+jK7El1mtZWpJA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:ae11:0:b0:5d3:40f3:56bf with SMTP id
 m17-20020a81ae11000000b005d340f356bfmr410887ywh.1.1701771772872; Tue, 05 Dec
 2023 02:22:52 -0800 (PST)
Date: Tue,  5 Dec 2023 10:22:43 +0000
In-Reply-To: <20231205102248.1915895-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231205102248.1915895-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231205102248.1915895-2-tabba@google.com>
Subject: [PATCH v1 1/6] KVM: arm64: Update and fix FGT register masks
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

New trap bits have been defined in the latest Arm Architecture
System Registers xml specification [*]. Moreover, the existing
definitions of some of the mask and the res0 bits overlap, which
could be wrong, confusing, or potentially both.

Update the bits to represent the latest spec (as of this patch),
and ensure that the existing bits are consistent.

[*] https://developer.arm.com/downloads/-/exploration-tools

Fixes: 0fd76865006d ("KVM: arm64: Add nPIR{E0}_EL1 to HFG traps")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 39 ++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b85f46a73e21..b1061647e837 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -344,36 +344,45 @@
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

