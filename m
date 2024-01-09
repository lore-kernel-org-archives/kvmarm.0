Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8F33A1D4
	for <kvmarm@lists.linux.dev>; Tue,  9 Jan 2024 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qxOlbB33"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f69158f32eso41933787b3.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Jan 2024 08:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704819411; x=1705424211; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ynJWgyIQTp0mxF1GFOGb+73JwIM0WneWjD70p63cQEA=;
        b=qxOlbB339GvNg2/7c+qCf7GlQRFutWv/MWjo3QNwERJg6LB+LyW+oCsvw27c7p7fK3
         8Lgdavw+mv+KQiS76DG6DlD9HegFivkrYsKnQ/eCAXCaMO6x2r4eL6vNcIJmh88EJCCu
         jtmkUT3ezQQ6ZtaKQ6JHQuS9df0AKSz2Y0PT/ku+WsbmFMAl3jNMTi9huCYPDsCITf/R
         ZPTgSAuLZTDi++4RA1KrCMRD3kICRwLkXn6xcAjozza9uriHZUSvjjBKbUx7xZD6IVLV
         szeHjI79IKmDUOl+YmF4ASl0ybiPwDnlUXefhu64x6grrd8gG3eNODFOX4nWJmdcwvqa
         YkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704819411; x=1705424211;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ynJWgyIQTp0mxF1GFOGb+73JwIM0WneWjD70p63cQEA=;
        b=WVw+FIkxUkF2e2t7lNOEUtWzuugel2LyAr+yf/+o4flIFmrKuvKAC0uqV/ktoPswRS
         RYlmqqCJ7FP97Xy4Qu17hbZd5x/5BuRYA5VCdmj39hZWit8vTQnJWaiKBuVu2QCzLX+q
         su73hVMkip28rNfAHZ5sw166jpP5Me4RddrRVcCvdfdaNc88iWuCugRFT6h3aMwwuIhH
         gO06ezl5j2vI7TLedp9XRhzGajGxvWUpiyqYHnUlvghOw/NPGiisdSVQbm3/+skXqLgW
         IVb1ItjbJg0wwJaFf1r6xh2OHj1XgD9J23aTXct6pTYdaLMko1nNCUGcb2qqGof0FFl0
         VJSA==
X-Gm-Message-State: AOJu0YwDIyok5+tMRsxXndZ1g9oUPFxP8KdDho12UM1/3+C6HvMVJ2bx
	0uO0J4sk3OdGhhTRXuN5K8UmuDZKRAVDJScTAr6mqaZx
X-Google-Smtp-Source: AGHT+IFJYk3i2RC1bH88fwAuau9C4zuiOPot5e3J0BArmIefW2S8KwtUXxKUu+wt+MEHyKZAdOV1+wsmcKU76wbbYQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:1369:b0:dbe:ab5b:c667 with
 SMTP id bt9-20020a056902136900b00dbeab5bc667mr159057ybb.2.1704819411220; Tue,
 09 Jan 2024 08:56:51 -0800 (PST)
Date: Tue,  9 Jan 2024 08:56:21 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109165622.4104387-1-jingzhangos@google.com>
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

