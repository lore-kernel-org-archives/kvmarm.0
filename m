Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3381B594
	for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dlxl2JjT"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-db402e6f61dso12335112276.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 14:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705356138; x=1705960938; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ynJWgyIQTp0mxF1GFOGb+73JwIM0WneWjD70p63cQEA=;
        b=dlxl2JjTvgxCf37fkZaonnnBBlKZO8rcoJ6qWCj52c4UvWJ4HO/BBFIRUSb3QzHil4
         /URhF7TBh+yUqVLRvERdGRl/HakMePEuL0HRWo1XEw9UpoPSxT8x/sOu+Bn/OVGtHkFM
         IvgSsEY+BnN7TvUHX/5WO2gLp6BpkygkQMr780H1rZTk8C9De54uShCxUQnZS3vWr2Yg
         23eDM0+hjI/N7kGEbgkvTb9+hmkH5sZlkTtpMdcrc6A1nWwOp1V2mZoqaVozK3IExYUB
         r+6rrON4y6ROIhJoqEJ2y6n3Sd0Q7WW+tdFP1/SHHvQx/KWs97zBTdrEVdmybq8h5QYt
         6onQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705356138; x=1705960938;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ynJWgyIQTp0mxF1GFOGb+73JwIM0WneWjD70p63cQEA=;
        b=rXvJOWEqbvRozDee1nTElUepFBmIv+D6DLBVzwjyiFZp+XuB4FFwC+WUvZe2j74Pvu
         qbJ7JiozkFwfR96xPI8b+N4j+ufYoNp36kpEROoSObfPWGaSAwnKHuonCO/kWDZRsyS3
         4j5c0MJesvCKNDEJgNtLE6nqa/knp6j/3EFEjYR3H0igQE1sIf9bTjcGE4G7VOi719Xv
         gxsh2vTSGBjJ5yUIt3r5TFcbfvWqz7rCtePpqDinMcPkMeZNfLcI/AzKReINnW/3d4fL
         H8rur80NpRd4AXdjlq3zR4+y6coMVCyCAz9UUX6j6GHG3yik1lxxy9ZYu7EoOj6Cxmp8
         ID0g==
X-Gm-Message-State: AOJu0YzEqiaW2I4qtdZ3W5flE3jSjg7ozkHOiKTo5SIS4MT34RE0r1WF
	b1JkBhv32DFkATwJKk0gItt1tnZnHQl+X4bEH0HLuJbz
X-Google-Smtp-Source: AGHT+IG/Iz6XwIuapV7X0ZZ3a5fIRKR0t1lv2wuRi/0Zp4hZu5zvYSaE2O3U898S6kuTsnCQsTVHzwgeQxaXgAgzGg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:8c:b0:dc1:f6f0:16cf with SMTP
 id h12-20020a056902008c00b00dc1f6f016cfmr1218961ybs.11.1705356137876; Mon, 15
 Jan 2024 14:02:17 -0800 (PST)
Date: Mon, 15 Jan 2024 14:02:08 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240115220210.3966064-1-jingzhangos@google.com>
Subject: [PATCH v1] KVM: arm64: selftests: Handle feature fields with nonzero
 minimum value correctly
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

There are some feature fields with nonzero minimum valid value. Make
sure get_safe_value() won't return invalid field values for them.
Also fix a bug that wrongly uses the feature bits type as the feature
bits sign causing all fields as signed in the get_safe_value() and
get_invalid_value().

Fixes: 54a9ea73527d ("KVM: arm64: selftests: Test for setting ID register from usersapce")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Reported-by: Itaru Kitayama <itaru.kitayama@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 .../selftests/kvm/aarch64/set_id_regs.c       | 20 +++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index bac05210b539..f17454dc6d9e 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -224,13 +224,20 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
 	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
 
-	if (ftr_bits->type == FTR_UNSIGNED) {
+	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
 			ftr = ftr_bits->safe_val;
 			break;
 		case FTR_LOWER_SAFE:
-			if (ftr > 0)
+			uint64_t min_safe = 0;
+
+			if (!strcmp(ftr_bits->name, "ID_AA64DFR0_EL1_DebugVer"))
+				min_safe = ID_AA64DFR0_EL1_DebugVer_IMP;
+			else if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_CopDbg"))
+				min_safe = ID_DFR0_EL1_CopDbg_Armv8;
+
+			if (ftr > min_safe)
 				ftr--;
 			break;
 		case FTR_HIGHER_SAFE:
@@ -252,7 +259,12 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 			ftr = ftr_bits->safe_val;
 			break;
 		case FTR_LOWER_SAFE:
-			if (ftr > 0)
+			uint64_t min_safe = 0;
+
+			if (!strcmp(ftr_bits->name, "ID_DFR0_EL1_PerfMon"))
+				min_safe = ID_DFR0_EL1_PerfMon_PMUv3;
+
+			if (ftr > min_safe)
 				ftr--;
 			break;
 		case FTR_HIGHER_SAFE:
@@ -276,7 +288,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
 	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
 
-	if (ftr_bits->type == FTR_UNSIGNED) {
+	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
 			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);

base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a
-- 
2.43.0.472.g3155946c3a-goog

