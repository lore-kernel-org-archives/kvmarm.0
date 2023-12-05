Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915D74D58F
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 10:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gVYTVuUk"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5d04540d5aaso81188747b3.1
        for <kvmarm@lists.linux.dev>; Tue, 05 Dec 2023 02:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701771778; x=1702376578; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6/1/nR/wPZ7NA+ogBhISAqTkBseTGBaMyb03BUPjq4U=;
        b=gVYTVuUkMJDBSoo7oXMm4+C/1dq4wu5dQYmth49ASiRLuoNYH9Jc1oySj/7mtjNbzt
         xdL2MxqI/ACa8gzdqA6swjQRrRHCIwPcDFn/GPjUuWdmiOfuh9B68aW1bj3uIRtCIXlH
         uzmzRf3imIGICxnS2Y46HaTwh/e+vInxCcL9xFwohypbCtmj7t9sndy0OXeO4dd0q5dE
         PEFkN12o3GqzTRyetAlGyD5NSqfq01h4N1C2ekLqrmherii9ff7Vml8MWCArdS4f6OHo
         SQVXmlXDt3H5iPr+8ZZ/05jdoXVp2rgVkXbebnLqEkagUVIDo+DY9C7KrSvfbLwhIf4l
         QPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701771778; x=1702376578;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6/1/nR/wPZ7NA+ogBhISAqTkBseTGBaMyb03BUPjq4U=;
        b=F6WxFbc2DLfjNZzWgUPZK92f6qy9ytQF6GsQorXK00VeXtaCAddPQ4rl8yeNPjJr5f
         YO9Jq6TSjABW0nNgUTpocbyH82xd92VwRIlGnrykJXSWEmBEHYw/m0wk0B6Vp4j2tnXA
         cbMon1wWiKHP65I9eI7yDfD7AbU26aoZxTZfmx9nfreMqsOffFnoGieyCGTNRlBhL9gg
         sJ1hzi9njhG39igbNQlQGkjGMMSWCBrzzFrmSes6FwWySHPdwHtt/b4J+3JCZteYz9xY
         SD+KQt3YE8O8fgLE+KID1TdUF9dj48HsTnHSZ96Fa8SugaCcSc52n3PA33klPznkB4XL
         TvDQ==
X-Gm-Message-State: AOJu0YycOOGLT9QwVnsflnLI4UwfsP+TorSOIePcc8nOL0DqpKV6ERp5
	u/SFrIDyNAk8qcpXpbTLPHJCvR01X19Eln066er7gNHANw/894CodJqW4Pyh/vK7v3ZQaBeMUqy
	fWmz65qHsNAmeFPLbS3AApAZC03rAMXU/x/Zdp8yVwT3aZ9OgblBciNNgSlg=
X-Google-Smtp-Source: AGHT+IFx6QtlZCISWo5zQurlwbwfl/q4BA+QdlQsjnDHwvFwpmn/4q0wJ5or16gDPeh6bB5cpSUmEIAy6A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:d444:0:b0:5d2:913a:6421 with SMTP id
 g4-20020a81d444000000b005d2913a6421mr552135ywl.8.1701771777402; Tue, 05 Dec
 2023 02:22:57 -0800 (PST)
Date: Tue,  5 Dec 2023 10:22:45 +0000
In-Reply-To: <20231205102248.1915895-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231205102248.1915895-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231205102248.1915895-4-tabba@google.com>
Subject: [PATCH v1 3/6] KVM: arm64: Add build validation for trap mask values
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

These checks help ensure that all the bits are accounted for, and
that there hasn't been a transcribing error from the spec.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f99d8af0b9af..2c6e8cbbd081 100644
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

