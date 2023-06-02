Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CD1332F8
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 17:02:52 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-76998d984b0so116987839f.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 10:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685725371; x=1688317371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DZrtPESLe1mA5daPGrUc+60GXQlGnhOLsAUJu36d7rQ=;
        b=Qq3RLBS2mk0SnALShNCtm+TQlg+XH/AHekNH7/7QlGAv3Kwq/6fPi6+CvfRavpIs4G
         RjyTeXe+0RGaZAufFJ8EvFNFa8pOjeTTjjb8sD9rItu1zRExurnNtBOtX6w1QJedD+7I
         afR/Bn/wNwB2NO7fNerz8ES6XgY4MyN711P03otg/ynXmiG0KHjiA/NCjGChETeqa8Sq
         PPIW2euhDqJ/s3oFviuWT4EcIxz18d4QuSIOimUwO4KwNQ9xdjmAWN3FZO+WhB+n8/fm
         Z+b1LzGrVLf99x0xH1gni5y4fL0Jf+jIx8h2sro9EeSCJDdt5AbgU5s/l97G1yjsUE5q
         7IyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685725371; x=1688317371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DZrtPESLe1mA5daPGrUc+60GXQlGnhOLsAUJu36d7rQ=;
        b=ISX9tDK3uqqMzDm9PATtDZo662zbF7qWeglO4caurOeKxU1n5vieyNmpFuCL7md7RX
         7pkstIIH/tczeXp6B8bcXgqkE6AULgRhylFr3vCXFkWRWQuOWH0l8DlkjIokMUe+gdQH
         aonuNcja+f0gW/Fs/3Yw5RO/a/CVRsuE71Ng3z6G4TnsgMc8bx9YopU/TntqrI5JRxRx
         ZZ9HjXbxzKBiH9zZCqju7KnJoLVcOQejt0EpsqFlW7Hqelj7CSYnqN8bhvsLU0fKcUU9
         O+lLq+cKMNgbz4cmFdkw/crKm+sCi451w9dS51TO82Brukn91i8HkHIWthVy3+BjwmC6
         wgiQ==
X-Gm-Message-State: AC+VfDy+wLS2RE1AVa/mC8PjeQpaOUufBvI0EPGQ39Gy0WOgVonUFLdE
	/w69K8rn1/fRFc5AzluOq4/8lVCwIzXUNiaZeA==
X-Google-Smtp-Source: ACHHUZ7jQlp0MVeJbVOdhempnaGESwJq6ISHR98G4dlzn8EXHZtiMaS3iQFnqJ6k1wVSGZ9JZpTQJ2Y+ISmEsdfLAw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:5904:0:b0:766:6741:8849 with SMTP
 id n4-20020a6b5904000000b0076667418849mr1203200iob.3.1685725371731; Fri, 02
 Jun 2023 10:02:51 -0700 (PDT)
Date: Fri,  2 Jun 2023 17:01:45 +0000
In-Reply-To: <20230602170147.1541355-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602170147.1541355-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602170147.1541355-2-coltonlewis@google.com>
Subject: [PATCH 1/3] arm64: Add a capability for FEAT_BBM level 2
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ricardo Koller <ricarkol@google.com>

Add a new capability to detect "Stage-2 Translation table
break-before-make" (FEAT_BBM) level 2.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c331c49a7d19c..c538060f7f66b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2455,6 +2455,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 1,
 		.matches = has_cpuid_feature,
 	},
+	{
+		.desc = "Stage-2 Translation table break-before-make level 2",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_STAGE2_BBM2,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_EL1_BBM_SHIFT,
+		.field_width = 4,
+		.min_field_value = 2,
+		.matches = has_cpuid_feature,
+	},
 	{
 		.desc = "TLB range maintenance instructions",
 		.capability = ARM64_HAS_TLB_RANGE,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 40ba95472594d..010aca1892642 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -41,6 +41,7 @@ HAS_PAN
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
+HAS_STAGE2_BBM2
 HAS_STAGE2_FWB
 HAS_TIDCP1
 HAS_TLB_RANGE
--
2.41.0.rc0.172.g3f132b7071-goog
