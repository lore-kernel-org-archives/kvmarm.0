Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9114D58F
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 10:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zP+6Ggbl"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-db584b8fb9cso4556453276.2
        for <kvmarm@lists.linux.dev>; Tue, 05 Dec 2023 02:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701771780; x=1702376580; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KNy4G0m5CsZO0PVE02L10AoMnonCl62//5sk2193kL4=;
        b=zP+6GgblaPkKiqGMlWbK+3EvkbBbLWfu9TTrIXqPQ1kgYSDrgLAQTrG34syzoLovUb
         DepCd/m6Z/qORaj/S3ZJ3gUr/fYEwtkJoVVQVW8ACZrxxyBnAvx/C/f9flMoQ23Z8sNW
         cKMIRf4ZuZWvWTYyyBrmsdlhDKIAMyJRBycOjOIlBCG/BxMjlv/nGYFmCQiMl3+LC24s
         si+OQqdAeYGQNBfRkPy08VdDrzh7CBU/WCPKNY/qNp4b4iW8a332an4MenhwpMMtim9V
         4Ef2QS/MC36RSZMHIjV1KdfFGo4iPDf0sIDUW9O8BXnF9LIpKULifflckVnmEpqkFqpO
         OXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701771780; x=1702376580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KNy4G0m5CsZO0PVE02L10AoMnonCl62//5sk2193kL4=;
        b=Yw0KScLQ0V6wE+7o8j67A35fhIuQtl+QcyGRo/XPafE5ANlUB+1kYjhpfqRLec8UnH
         Iw6nJVBJDeH56TN9uHOvij90w7Ks1JM0p6KJojTuCSNd5VnWIG3LMZ+6QXI80vbzqpz+
         vAYN4wp7pwnwhH12iipF3MQ9BemW6QhwaFrSEeAsk86Ow+gtyd8N5vkKt0Eb1PyGRwUL
         LE+8Qmdd7+RRTzQRmpwYW25HxSGGG/Frqj924oAFatNkBQpwezlGDU2nnBBs2frQ7PjM
         T9oTvRyLDE44+Ozicyu1/HD3aAENU/uqhpwcxSxj3B6MD0UEAOSNDDCvudGlxVtUl0rY
         o/dQ==
X-Gm-Message-State: AOJu0YyulIkUBLWgqBcrTOxLJ54cEmCt4UD8w8HZBWuXiI0JqniYx+8s
	PYEQz8N1OaXaPfabXcQzh2z56BUaw40Ehyl7fECyvS2jJietvC52eSj+UMsfi2BpAc744r9GirJ
	B2+XxyXof6HuXBZmoDdWzm7Am3f8pbgM1jDw1XAlZlBQMJ0nm12BNFG3SSQ8=
X-Google-Smtp-Source: AGHT+IGA84W6+BmctaSHyOtZJKJ7ioMvvJ9dEcQAhOvOmohHsmNGlJO/KQGc97vOKqUco8GspSKDwhovZQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:d6d1:0:b0:db7:dce9:76d3 with SMTP id
 n200-20020a25d6d1000000b00db7dce976d3mr190013ybg.9.1701771780150; Tue, 05 Dec
 2023 02:23:00 -0800 (PST)
Date: Tue,  5 Dec 2023 10:22:46 +0000
In-Reply-To: <20231205102248.1915895-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231205102248.1915895-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231205102248.1915895-5-tabba@google.com>
Subject: [PATCH v1 4/6] KVM: arm64: Calculate FGT RES0 Bits
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

All FGT reserved bits are res0, and they are the ones remaining
after accounting for all defined trap bits. Now that we have full
coverage of the trap bits, calculate the res0 bits based on the
other bits.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h        | 19 +++++++------------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 --
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b0dc3249d5cd..44bbbb4110d3 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -344,49 +344,44 @@
  * Once we get to a point where the two describe the same thing, we'll
  * merge the definitions. One day.
  */
-#define __HFGRTR_EL2_RES0	BIT(51)
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
 #define __HFGRTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
+#define __HFGRTR_EL2_RES0	~(__HFGRTR_EL2_MASK | __HFGRTR_EL2_nMASK)
 
-#define __HFGWTR_EL2_RES0	(BIT(51) | BIT(46) | BIT(42) | BIT(40) | \
-				 BIT(28) | GENMASK(26, 25) | BIT(21) | BIT(18) | \
-				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
 #define __HFGWTR_EL2_MASK	(GENMASK(49, 47) | GENMASK(45, 43) | \
 				 BIT(41) | GENMASK(39, 29) | BIT(27) | \
 				 GENMASK(24, 22) | GENMASK(20, 19) | \
 				 GENMASK(17, 16) | GENMASK(13, 11) | \
 				 GENMASK(8, 3) | GENMASK(1, 0))
 #define __HFGWTR_EL2_nMASK	(GENMASK(63, 52) | BIT(50))
+#define __HFGWTR_EL2_RES0	~(__HFGWTR_EL2_MASK | __HFGWTR_EL2_nMASK)
 
-#define __HFGITR_EL2_RES0	(BIT(63) | BIT(61))
 #define __HFGITR_EL2_MASK	(BIT(62) | BIT(60) | GENMASK(54, 0))
 #define __HFGITR_EL2_nMASK	GENMASK(59, 55)
+#define __HFGITR_EL2_RES0	~(__HFGITR_EL2_MASK | __HFGITR_EL2_nMASK)
 
-#define __HDFGRTR_EL2_RES0	(BIT(49) | BIT(42) | GENMASK(39, 38) |	\
-				 GENMASK(21, 20) | BIT(8))
 #define __HDFGRTR_EL2_MASK	(BIT(63) | GENMASK(58, 50) | GENMASK(48, 43) | \
 				 GENMASK(41, 40) | GENMASK(37, 22) | \
 				 GENMASK(19, 9) | GENMASK(7, 0))
 #define __HDFGRTR_EL2_nMASK	GENMASK(62, 59)
+#define __HDFGRTR_EL2_RES0	~(__HDFGRTR_EL2_MASK | __HDFGRTR_EL2_nMASK)
 
-#define __HDFGWTR_EL2_RES0	(BIT(63) | GENMASK(59, 58) | BIT(51) | BIT(47) | \
-				 BIT(43) | GENMASK(40, 38) | BIT(34) | BIT(30) | \
-				 BIT(22) | BIT(9) | BIT(6))
 #define __HDFGWTR_EL2_MASK	(GENMASK(57, 52) | GENMASK(50, 48) | \
 				 GENMASK(46, 44) | GENMASK(42, 41) | \
 				 GENMASK(37, 35) | GENMASK(33, 31) | \
 				 GENMASK(29, 23) | GENMASK(21, 10) | \
 				 GENMASK(8, 7) | GENMASK(5, 0))
 #define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
+#define __HDFGWTR_EL2_RES0	~(__HDFGWTR_EL2_MASK | __HDFGWTR_EL2_nMASK)
 
-#define __HAFGRTR_EL2_RES0	(GENMASK(63, 50) | GENMASK(16, 5))
 #define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
 #define __HAFGRTR_EL2_nMASK	0UL
+#define __HAFGRTR_EL2_RES0	~(__HAFGRTR_EL2_MASK | __HAFGRTR_EL2_nMASK)
 
 /* Similar definitions for HCRX_EL2 */
-#define __HCRX_EL2_RES0         (GENMASK(63, 25) | GENMASK(13, 12))
 #define __HCRX_EL2_MASK		(BIT(6))
 #define __HCRX_EL2_nMASK	(GENMASK(24, 14) | GENMASK(11, 7) | GENMASK(5, 0))
+#define __HCRX_EL2_RES0         ~(__HCRX_EL2_MASK | __HCRX_EL2_nMASK)
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 2c6e8cbbd081..bf045dc32996 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -86,8 +86,6 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 #define CHECK_FGT_MASKS(reg)							\
 	do {									\
 		BUILD_BUG_ON((__ ## reg ## _MASK) & (__ ## reg ## _nMASK));	\
-		BUILD_BUG_ON(~((__ ## reg ## _RES0) ^ (__ ## reg ## _MASK) ^	\
-			       (__ ## reg ## _nMASK)));				\
 	} while(0)
 
 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
-- 
2.43.0.rc2.451.g8631bc7472-goog

