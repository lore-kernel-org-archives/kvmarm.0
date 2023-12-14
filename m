Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE022E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y9Lwr+gF"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e2eccf79f8so17298547b3.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548145; x=1703152945; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MtoBQdO9BZcT6cVULOx3THPVjJf72EU09T5C8iMtUIE=;
        b=Y9Lwr+gF3pDhWTx04j13/Tcn7EPgoZmsDOZ5B6ZI8p3hF6c2365+OQLmFOiYA3Ru/5
         Gg6JQZelqglbhY3CoWoZDuJo7E7NhiTMH3vQChoNL61ju4rvUJU8IEOKuLMYor5bysXG
         Qf4det3ChaxAZz39MXfOAR6EoLSd2BSIwf5ur1hYTF4EYnKoI9HsvsTZfr5Z9DXmM48g
         y4s5Abnxl1K5HMTnk9ey5B5xQyK8qx9oaW357AjnN6llYwGpktVmYXs3X6r02unPhKqv
         vzu7L1smeVcx+Oega9GC+UsYjJTEiGjkkAOvGonGfqTvnx1hOYqDnHRuKEkNvIcpFwFV
         xAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548145; x=1703152945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MtoBQdO9BZcT6cVULOx3THPVjJf72EU09T5C8iMtUIE=;
        b=CWDXKFDRplVcM7y+DQWwtUM7Xwuo4uOE+x1fNenKWFzsibmuEUqlYO4lZPMwxDM3xl
         h7U6hENqX2MOPRmm5PCLf/IxzyXJiu/qJh1hF4FFqNSw013ShD9UOZkdTzockMeOsv9e
         2vJkrkgQVzAb/zyzQKOQp9HosGUBjFFBYY2EHlCuKKmXhkkc1L2WMdCnE8qEVLkRYwIM
         gs6DJy4+8vuh10KK3/9bL6XbT2RS/mHdnVzl++MUqJZq/DJnwRwMU8wtD4YjHlHPfFWZ
         ZtxIvRSE9SzkdwAz05mNjsfTwsyf2+uYDpGRoMJthQgYEY4mOkYuY9RXiMMrDAZlSyTC
         yRPg==
X-Gm-Message-State: AOJu0Yy8twu2va5u1847LGnGi4g6HRinvZURO2V08FCFzdyqEn5r/WOw
	yzyy2NpjxWkwnzXeq7StZhEq5plOEYH0FfQdytH1/2olZ91VjcWhob0RRwGzHKOsbxMsX4MIhYF
	KWNjH7yBmPS+F96hmv2pe4Qa1m5jwkoz2PwOUa1QRGsjy4Q62oZJxHtyvhNs=
X-Google-Smtp-Source: AGHT+IF3yQ4ifUSZxuey84w9AQVk0MTmWSACizMj1HStOjIjCJwuTOu76xneTkqOBFoVyWUvXJZXskiKxQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:891:b0:5d0:a744:719a with SMTP id
 cd17-20020a05690c089100b005d0a744719amr115733ywb.2.1702548145070; Thu, 14 Dec
 2023 02:02:25 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:51 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-12-tabba@google.com>
Subject: [PATCH v3 11/17] KVM: arm64: Add build validation for FGT trap mask values
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
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
index 22f3b916f60c..17ce40f5b006 100644
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
2.43.0.472.g3155946c3a-goog

