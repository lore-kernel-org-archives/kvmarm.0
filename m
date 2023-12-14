Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1477A2E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1b/ms6TN"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3333aaf02b0so7127562f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548156; x=1703152956; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DxM0XHeehpr+WPJP1Pzkg4drlsNFy3fN21V8Kb3LPPA=;
        b=1b/ms6TNhKxgYd/8pjJuz/4bBvf0GTGK2akZpYqxdQlFqcDYFLEcAZQGlDs78pydzK
         JwKOX4fO9QcwEY0xhBmWJFaETcp3HKS9KyVr0BY/ls4yrNVE0/01CHIH3cpV5uH6JPEu
         55W+6V5LvoWNo+hx2/pU0GIPDN/dhI6oIfQJr8RSLJvYmEVNk3UycTeBybs3Avdo1qJk
         CXp84gpuuaRx8smONj1MpcDxGcBaqGyMcubfnLd48L3DbIcEMnXl50aGZmLFTIG6LZeE
         S3VBYL94AlASFXVqGKqQSNZ72QmwHFxNZuTNjErmGYQr1Dkc+rL0/ancayQfUBQDzY8p
         jgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548156; x=1703152956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DxM0XHeehpr+WPJP1Pzkg4drlsNFy3fN21V8Kb3LPPA=;
        b=F5e91sL2H3TxEijNUHvoeMimJc+9ycUdSHlSbkH7fJFBUgYIpjU/lS+V6X1ra88zIG
         IPjQwn1mqa8Jn9F5bjHsjr71yIQTmVd8Unux7uzHk4QRIjIzccQ0bKfonAf2UwU8EhDn
         YCzB4NfhvAQ/53DbOqwEIPMR1gPGQUU6qm/BkIxcYGuVk3sC+t0WlAyoXSwFgsRv4A8m
         E97C5Ky5nsGEek/kgNeoLObnofhgDTtum96dCGTyi38tEP6xjP5Q8/8/m6EnhtcrO8XY
         wosEybp2FCxAPpunLGnIZ3Qfj8j6NfUQd0JXGRCIGJe9m1x0HjZpRzUKJaMugBIRL21Z
         fefQ==
X-Gm-Message-State: AOJu0YyUN64MnxUJPdXdHgppXF5sNOm10T8KLpUdQg8mcjMnqbGrUmY4
	gI56FfiIENYDhgz6g7Ps4NLC2H8WP67WqmLyZPlTk6QpW7MSdzfVsZrb3br8CPVHq511O3hOyiT
	T4x216xIICpllG5kV9oRFZbvS4GfDbS3GbnlNDo7eYTQ3cixfAyBYvFMwU+g=
X-Google-Smtp-Source: AGHT+IHRZfkX+kRwxAcAgeOYuqBVIq7qh6v7y8TD4vtcPCdnrGYYlwGO4zqQN1aoI/8Pp/ExfSE/vt6lxQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4b06:0:b0:336:4a97:9f70 with SMTP id
 v6-20020a5d4b06000000b003364a979f70mr1374wrq.5.1702548156209; Thu, 14 Dec
 2023 02:02:36 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:56 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-17-tabba@google.com>
Subject: [PATCH v3 16/17] KVM: arm64: Mark PAuth as a restricted feature for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Protected VMs will only support basic PAuth (FEAT_PAuth). Mark it
as restricted to ensure that later versions aren't supported for
protected guests.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 8d97dff4bb7b..51f043649146 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -184,10 +184,18 @@
 	ARM64_FEATURE_MASK(ID_AA64ISAR0_EL1_RNDR) \
 	)
 
+/* Restrict pointer authentication to the basic version. */
+#define PVM_ID_AA64ISAR1_RESTRICT_UNSIGNED (\
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), ID_AA64ISAR1_EL1_APA_PAuth) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), ID_AA64ISAR1_EL1_API_PAuth) \
+	)
+
+#define PVM_ID_AA64ISAR2_RESTRICT_UNSIGNED (\
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3), ID_AA64ISAR2_EL1_APA3_PAuth) \
+	)
+
 #define PVM_ID_AA64ISAR1_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_DPB) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API) | \
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_JSCVT) | \
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_FCMA) | \
 	ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_LRCPC) | \
@@ -202,8 +210,8 @@
 	)
 
 #define PVM_ID_AA64ISAR2_ALLOW (\
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_ATS1A)| \
 	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) | \
 	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS) \
 	)
 
-- 
2.43.0.472.g3155946c3a-goog

