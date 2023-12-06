Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19B41A725
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lpMAUu9J"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5d3a1f612b3so95020857b3.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857123; x=1702461923; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0rwJ30mtQDKT8Q+NADoqH7KGsOCgT9qo84vSBXBr5ag=;
        b=lpMAUu9JgSDq9q2DTPIMu8USgf2F6bGRBB488Xi3QlYqnDleRRPsyIydSSrMMC93j6
         CEGqKogXmIlsIA1GJay4/d9CLamXcuA6lMD6YVRQY000OruTDksxs4hhjlZTRZaEtV/I
         GZveiId8R1Jsk/PP7o7JSPGJqo+9HRA9g6dhxEqvLpTaUqwWfOz3VH9Eze+hXpfqS3Fl
         ey6ex+eiLWf9Qq5xpMiD17VDbqvBxzFxRKrwlJIDy8uD4bz1l0e42ZNRrpblL8uUelhO
         Vs4NFOY4rKJJqUT9wSHGervlhhRNJJaemWETBoVP6sarj0utsS1s+1dYWXxVbYN8/HeH
         vAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857123; x=1702461923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0rwJ30mtQDKT8Q+NADoqH7KGsOCgT9qo84vSBXBr5ag=;
        b=G9Aae9x/31dJ+xOjVHYRTFD0YMrz9l9v3WbckfEFO8dG63M1Mv3jQuPsNMVBtNGHyI
         PzTlivYAA9cQGo/Den82UEsW++BDaspRKfHTXdY7UJ1nKF0roEYR+zo1DPX7bvIAW1V2
         rG4LU3PltNOPC4KAIzVGm5A9mqgQeYhWs8hIdlOZI1NIKIUvqd7piW3iXK8lDw34p1LA
         D+aahbhBPeDlvDxMfTEStYAaVUF3WBDhF49GSz9Sf5q71h2Qgn4NxTGnuDcyB18ADzg5
         rTlmwmS1xyWFL5mLzJp73naWHYqqIFC1SuGvUnx2ts4cpcfhZvVdBu6P+4IKz9ASCS8b
         XwrQ==
X-Gm-Message-State: AOJu0YzuHwXWUS70ssbwltuFE3ikUl6rZq/j4Tnas86flkS1F4GbxnwG
	78Dwv7VAVDvO5Daqr58ykEAiyjJuB+aB8BH2l7gmo/lmwY2I3DbKPPAb5G+MnvY2eH7qXyt6i99
	U/mEFs6p4iJ1HHhQSUsSYznfWYWvewJrUoS5CrGtF7wMsyWVVo6cLUFXpeCk=
X-Google-Smtp-Source: AGHT+IGbI1V/lZzU72pljVYJRqszGeM94wQTaGKOFZNfAmCrHkJ+RF1iF3Ab3jJIweG3Lob8HrVaPkV+Dw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:be18:0:b0:5d4:27ab:83c with SMTP id
 i24-20020a81be18000000b005d427ab083cmr5758ywn.1.1701857122557; Wed, 06 Dec
 2023 02:05:22 -0800 (PST)
Date: Wed,  6 Dec 2023 10:04:57 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-8-tabba@google.com>
Subject: [PATCH v2 07/12] KVM: arm64: Add build validation for FGT trap mask values
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

These checks help ensure that all the bits are accounted for,
that there hasn't been a transcribing error from the spec nor
from the generated mask values, which will be used in subsequent
patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 76a3d78b13d9..91d0f73161bd 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -79,6 +79,16 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		clr |= ~hfg & __ ## reg ## _nMASK; 			\
 	} while(0)
 
+/*
+ * Validate the fine grain trap masks.
+ * Check that the masks do not overlap and that all bits are accounted for.
+ */
+#define CHECK_FGT_MASKS(reg)							\
+	do {									\
+		BUILD_BUG_ON((__ ## reg ## _MASK) & (__ ## reg ## _nMASK));	\
+		BUILD_BUG_ON(~((__ ## reg ## _RES0) ^ (__ ## reg ## _MASK) ^	\
+			       (__ ## reg ## _nMASK)));				\
+	} while(0)
 
 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
@@ -86,6 +96,14 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
 	u64 r_val, w_val;
 
+	CHECK_FGT_MASKS(HFGRTR_EL2);
+	CHECK_FGT_MASKS(HFGWTR_EL2);
+	CHECK_FGT_MASKS(HFGITR_EL2);
+	CHECK_FGT_MASKS(HDFGRTR_EL2);
+	CHECK_FGT_MASKS(HDFGWTR_EL2);
+	CHECK_FGT_MASKS(HAFGRTR_EL2);
+	CHECK_FGT_MASKS(HCRX_EL2);
+
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
 
-- 
2.43.0.rc2.451.g8631bc7472-goog

