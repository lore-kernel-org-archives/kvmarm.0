Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B218D229B10
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 09:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746177679; cv=none; b=F4Sv+JYC5LCXaqGRvRfXz91AbnMyX6RCQsNgN3crgDGHdutQXeoiImBkSP8ne2OjBsodsyrO4D2FnKlxrSI77WyYQNuR9O0qkWVyb8FUmYytFMkuELIeATyYsOCGWkU6lS3YvkR3mEn1pSqzSYuZTXe0u+e9drTIuxCTZz2znwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746177679; c=relaxed/simple;
	bh=x8jU5cm1Fg5jhmw7TvC9ZyDUI9BUMgu95TARNLub1z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BY7M3qQPrs33fVJR2LTB/O+kAJN8T0PUpxGensVEzVYM3p63+iu5sFRWl5uL7k++q/DWE2t9+yxlkLlrArtweVxgGNl617CIISHi2vecXPYxHfXyPcxb1sIvg+qIJ0jn1Wp0LMvpZK8KNOfPfXbiyaZYSsSCsYjLq/aeBF7L0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=Noy8eYfp; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="Noy8eYfp"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e75608f582aso870135276.3
        for <kvmarm@lists.linux.dev>; Fri, 02 May 2025 02:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1746177673; x=1746782473; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fB5WC809wTl4CZgtJWZZ9LIth3xEsvGA35RJbEoV80=;
        b=Noy8eYfpEq8qS43Npgkk4dNs5x3AVm/wdg51/kUsc5qLm+5BeKDhqIYlUeO4zOEjrt
         A/IMpBiImpdbzPW42vzxPez+aBXmB5GWpM3jmPnw6398O+n+LPliinfEfFoUcU++SAfX
         BxdHzUmeFiPzCSm+vIIGglunDifYYLeF1XlW6b3+QUt9EERnb8SC/Sch5mQUs708UNoh
         ypFSMINhoEZKb6xdtF5TNhmBJDZS+z070PrQ5CjE823FnRslivgxKqEXBYinYmZBRMCA
         O5fvNvfnFo6K72vfKilTzlXMiSzkQu++qoXrp5h5GfHPWuY9R2nGe8iVe4r+h3Ob7Anq
         krTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746177673; x=1746782473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9fB5WC809wTl4CZgtJWZZ9LIth3xEsvGA35RJbEoV80=;
        b=bfZiOwCXw9MP99V0slQNnnWaYvSzQB5EK64dpdfz+ZJgI0xk7GNVAdJ0KEfzcPwFZk
         f3DBX1NqiaCxVWruQ2yNs2hkbDsjLWxbAAsvxMu18cPWeY6wDFtsIF/40ipHX31/Rxsb
         mULP5JE6OjAQqkDVbnT4dcXenkrQeKNA5hlCpfqvakcaqNs+FkhXH2oIkmgdwoVPbGjr
         gQybcDWU+KoVdr86oGc1u9KXFyPB7YJyVa82ODLuFWTfcgB7XDhyGIcPVpe5o9CJ4lfQ
         kOMfFHWgy0ObXc1bREVt9GqAuINh6g1FILbyfSu8L3utfnZpBiyvPab1PhE5GvqM8iHA
         784Q==
X-Forwarded-Encrypted: i=1; AJvYcCUS3zwUmbCvhyc0GXf2qovaQMUvz80xSTKWrIrkBd+sZNk1Xp7ovyEVOper5UDSN0nlqhxZ9cE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzve9isWq0xOyDyk32I/9YBagd60hAE0nZBR7qhF+5MTs8hWdHk
	B6AGh6utWPXU5ujd+e22xNI9e1pA6ST9rBHDbaYMqHzFe3liQ4I5omG7MvJg8Ls=
X-Gm-Gg: ASbGnct1psbVU+iQ/jv1OhPsYjEBSjWoCnpaBU1B1X/K6DWC9SoGxMIrK78XlafhQvt
	5yDEM4ELw/tUIpIN2WPb3zsds4O4MZih3yrKFboGXzqnilHvihXDKTPU3kRupNE05TMmz3g7nAa
	4HVBqSvuirTimYFEC53lHRxD3Dyv76cDWruuvvYUahV6A7BGJYusThNU3UQKsK4nGa/mDYPF+s7
	svUnDC1pQPpyurtUQDTdfbefw0fYXGbv8beNGPZyYs1j9a2a9n715t9ES2vw25+ssQGnEOIEfMI
	N4IgHJ1EDy6G5Hm/w4C3gDCKAch12gO2KFVczW6cDa17R1Bki1Dn
X-Google-Smtp-Source: AGHT+IGQUPnvqf/qgEgSqRGNA98GCO3ipomvK0QEj746mMZOPYN8VysAcht5q3HIlb1fWVBbhO3x6w==
X-Received: by 2002:a05:6902:2085:b0:e63:ecdf:4d6b with SMTP id 3f1490d57ef6-e75655490b5mr3096136276.13.1746177673505;
        Fri, 02 May 2025 02:21:13 -0700 (PDT)
Received: from donna.immunant.com ([12.9.190.3])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e755e7d92d0sm556427276.55.2025.05.02.02.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 02:21:13 -0700 (PDT)
From: Per Larsen <perl@immunant.com>
To: linux-kernel@vger.kernel.org
Cc: sebastianene@google.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	jean-philippe@linaro.org,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	lpieralisi@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	qperret@google.com,
	qwandor@google.com,
	sudeep.holla@arm.com,
	suzuki.poulose@arm.com,
	tabba@google.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	armellel@google.com,
	arve@android.com,
	ahomescu@google.com,
	Per Larsen <perlarsen@google.com>,
	Per Larsen <perl@immunant.com>
Subject: [PATCH 1/3] KVM: arm64: Restrict FF-A host version renegotiation
Date: Fri,  2 May 2025 02:21:06 -0700
Message-ID: <20250502092108.3224341-2-perl@immunant.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250502092108.3224341-1-perl@immunant.com>
References: <20250502092108.3224341-1-perl@immunant.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Per Larsen <perlarsen@google.com>

FF-A implementations with the same major version must interoperate with
earlier minor versions per DEN0077A 1.2 REL0 13.2.1 but FF-A version 1.1
broke the ABI on several structures and 1.2 relies on SMCCC 1.2 is not
backwards compatible with SMCCC 1.2 (see DEN0028 1.6 G BET0 Appendix F).

If we return the negotiated hypervisor version when the host requests a
lesser minor version, the host will rely on the FF-A interoperability
rules. Since the hypervisor does not currently have the necessary
compatibility paths (e.g. to handle breaking changes to the SMC calling
convention), return NOT_SUPPORTED.

Signed-off-by: Per Larsen <perlarsen@google.com>
Signed-off-by: Per Larsen <perl@immunant.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 3369dd0c4009..10e88207b78e 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -712,7 +712,24 @@ static void do_ffa_version(struct arm_smccc_res *res,
 
 	hyp_spin_lock(&version_lock);
 	if (has_version_negotiated) {
-		res->a0 = hyp_ffa_version;
+		/*
+		 * FF-A implementations with the same major version must
+		 * interoperate with earlier minor versions per DEN0077A 1.2
+		 * REL0 13.2.1 but FF-A version 1.1 broke the ABI on several
+		 * structures and 1.2 relies on SMCCC 1.2 is not backwards
+		 * compatible with SMCCC 1.2 (see DEN0028 1.6 G BET0 Appendix F).
+		 *
+		 * If we return the negotiated hypervisor version when the host
+		 * requests a lesser minor version, the host will rely on the
+		 * aforementioned FF-A interoperability rules. Since the
+		 * hypervisor does not currently have the necessary compatibility
+		 * paths (e.g. to paper over the above-mentioned calling
+		 * convention changes), return NOT_SUPPORTED.
+		 */
+		if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version))
+			res->a0 = FFA_RET_NOT_SUPPORTED;
+		else
+			res->a0 = hyp_ffa_version;
 		goto unlock;
 	}
 
-- 
2.49.0

