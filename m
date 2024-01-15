Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7711C1B592
	for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 22:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sSc+HEUP"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f38d676cecso108127417b3.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 14:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705356173; x=1705960973; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fs5plhdODh5O3jwOa02ZCAJ9LDrZDHKVjydsmrZKIRI=;
        b=sSc+HEUPAZLe7l3RNJ9ysQXnvM/B2AC0a+XkcE6kjp/Xd4syhSiNed53Lw1mQXFzrZ
         ftwXv1017ZU9mSSkEp4kb+dSkhTeZIvfCpid6na2LEHeKmUSzMwJWlkuJMPed512Bg6U
         z+clEk5pTMEI698lnjn5FqjFP7LKpbTyttSSOF0p/BQ+zcoZVxbzJhx1pp3mTBrYOcMs
         7XjjZj656ZaSznPoo4nPQb9AQDVCT5u92kh5fwounyIOvS2dKQ/qsQHfMX4OT8zWp2GC
         WGXPX4p3UkH6YZGnFinu08HyH8ARKxiwr0OI/DsEquHy1OTK6aeoWNTWnvL6zRMWwkpW
         GHPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705356173; x=1705960973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fs5plhdODh5O3jwOa02ZCAJ9LDrZDHKVjydsmrZKIRI=;
        b=wh23G0LnC2mp6YouEaOxZJemfBsjBy12MYjNjjdENqBWFJkGHOcT8ye/yU5oy+IbUH
         nJE+pj0q9vo1tbwUR/7gluz7HskemipqcxaGTMl3gfGfSF1sZT85p0368EsxtbjnD8K/
         xp8zMg2TKFy5CG7MNj1lmAtQ2koqmENQKYINjQaukMb7uNdR9EqI1oseov/2aqPN5C1t
         +vq9eK3HY5502D8qXzVbXqKOBUDdQ8A443DAqrRaTAuz2Msx99DDkglKr5rsEn33fbq+
         m3zOmkmyY8gKkk4bxSdHYbsY02171E/TmCdcjDgFx+tYXU7RqKAcTNT72+zOinsjBXlj
         nuHg==
X-Gm-Message-State: AOJu0Yy/sTKjbU53fObczzNDbJVcOm0ZihLWXhwEKoI3GozUc6krUluN
	ubUxfddPTBcFUz2XTZEGzDt1Nhmw5OxOowy9mGGhbz+k
X-Google-Smtp-Source: AGHT+IF+fzRJLAXxL6I3qdWZEbC2fAkyfSI5O2l3h7Gnd5rTDrziaodY8En22xaBj29yb4KDWgcqegBtA+/+HIEKgQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:aac7:0:b0:dc2:232b:5cf1 with SMTP
 id t65-20020a25aac7000000b00dc2232b5cf1mr57299ybi.1.1705356173573; Mon, 15
 Jan 2024 14:02:53 -0800 (PST)
Date: Mon, 15 Jan 2024 14:02:09 -0800
In-Reply-To: <20240115220210.3966064-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240115220210.3966064-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240115220210.3966064-2-jingzhangos@google.com>
Subject: [PATCH v2] KVM: arm64: selftests: Handle feature fields with nonzero
 minimum value correctly
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

There are some feature fields with nonzero minimum valid value. Make
sure get_safe_value() won't return invalid field values for them.
Also fix a bug that wrongly uses the feature bits type as the feature
bits sign causing all fields as signed in the get_safe_value() and
get_invalid_value().

Fixes: 54a9ea73527d ("KVM: arm64: selftests: Test for setting ID register from usersapce")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Reported-by: Itaru Kitayama <itaru.kitayama@linux.dev>
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>

---
* v1 -> v2:
  - Use ftr_bits->safe_val for minimal safe value for type FTR_LOWER_SAFE.
  - Fix build error reported by Zenghui with gcc-10.3.1.
---
 .../selftests/kvm/aarch64/set_id_regs.c        | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index bac05210b539..16e2338686c1 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -32,6 +32,10 @@ struct reg_ftr_bits {
 	enum ftr_type type;
 	uint8_t shift;
 	uint64_t mask;
+	/*
+	 * For FTR_EXACT, safe_val is used as the exact safe value.
+	 * For FTR_LOWER_SAFE, safe_val is used as the minimal safe value.
+	 */
 	int64_t safe_val;
 };
 
@@ -65,13 +69,13 @@ struct test_feature_reg {
 
 static const struct reg_ftr_bits ftr_id_aa64dfr0_el1[] = {
 	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, PMUVer, 0),
-	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, ID_AA64DFR0_EL1_DebugVer_IMP),
 	REG_FTR_END,
 };
 
 static const struct reg_ftr_bits ftr_id_dfr0_el1[] = {
-	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_DFR0_EL1, PerfMon, 0),
-	REG_FTR_BITS(FTR_LOWER_SAFE, ID_DFR0_EL1, CopDbg, 0),
+	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_DFR0_EL1, PerfMon, ID_DFR0_EL1_PerfMon_PMUv3),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_DFR0_EL1, CopDbg, ID_DFR0_EL1_CopDbg_Armv8),
 	REG_FTR_END,
 };
 
@@ -224,13 +228,13 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
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
+			if (ftr > ftr_bits->safe_val)
 				ftr--;
 			break;
 		case FTR_HIGHER_SAFE:
@@ -252,7 +256,7 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 			ftr = ftr_bits->safe_val;
 			break;
 		case FTR_LOWER_SAFE:
-			if (ftr > 0)
+			if (ftr > ftr_bits->safe_val)
 				ftr--;
 			break;
 		case FTR_HIGHER_SAFE:
@@ -276,7 +280,7 @@ uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
 	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
 
-	if (ftr_bits->type == FTR_UNSIGNED) {
+	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
 		case FTR_EXACT:
 			ftr = max((uint64_t)ftr_bits->safe_val + 1, ftr + 1);

base-commit: 0dd3ee31125508cd67f7e7172247f05b7fd1753a
-- 
2.43.0.381.gb435a96ce8-goog

