Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFDC523A
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757944208; cv=none; b=azTzuHA9IP5ftHJuxR6se8oeeY67H9O+irb8m9lMGG3arBnWS2XL8FzPkdQ6Igrv+6XVPTtVRwIQHror6Y/6aWf6rQUHwgPRI8LJbQ6/JiBdH4jdTrCOHZC+Rsjw3IVQEZkKTrxaesmAeJQO4U7rowByyC4nKgRS25sPLpy876E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757944208; c=relaxed/simple;
	bh=c7WHqduScyHLDDcMsq9d0TDkDIqfvJa2wH5RuAPMgL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lgH7D+emWRfzzC0p8k1c2HtkmW2/ZRSeOo5el9ip9AS0Lr17d9tLhXkAIWyJazY6FZGZtAFHA5KR1X0pB/ijNvPF7ZPGY/kNSmx+DxJOHxsPaSnnj6/FQLGki3UopQEegPSgvsr591RQmXA57aZyWdNOMDJgnzWci8Wz2GOfQhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fj55SB3M; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fj55SB3M"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8116af074e2so405111685a.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 06:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757944205; x=1758549005; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TTLchl8AB1FHcg0issnijieflGh4JJHnQc0EA5X3mh0=;
        b=fj55SB3MRQo5Z8V4FXYIY8Y73n6OM4PQ5FKpIucomATjkcme96k2Cw2C0oDGQmMFRr
         PN1+Tf5Ov4L+WM6F1Wbc7rb0SCxzzQsiXg4NsTU/wiIHvZKvdAV9mIa1cvbOOgAoZtSG
         p+4jy2u+GVZxPqY4hMoCzr8drAV4Im4MHgHNyBO669U69IlwhvtN1nE+Nc4lyfvvFHLv
         3DebtXT1emtZAPKaYfyS92KqljZ0OutM0VWKBo9AOYqQuUrAJcww2s7yBLLMy+bZ8Rs2
         S0qDop5mTtukl8oBVYr+ZoMnHsZjFmXmp1ywn06VWkmGZGh0v6ZmAi/vxMrIvk7P5j8P
         5UUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757944205; x=1758549005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTLchl8AB1FHcg0issnijieflGh4JJHnQc0EA5X3mh0=;
        b=KxGAswYDndPZXM+ibO01y8fxXqg3jZ2xOd8rbEiUHMADAzBrkJS7KaKbhxLIYDRA9F
         hBdOrikU8th16vXOsJZU3AGR8lVC/CNogzJx+pPvuAKmPLXj0zNViiEgkqGyTzj8A7QY
         8jRkW1OvKKB7wIa6VRsmsfoujLl2eI8iJKTiqT8xUkjpPHNlQ4FpFZFuIJntPaZsH4K6
         cYWMsyr2CcoFqDoCCUzAaSRRL8CcWA9jdwLRwGZnBfhBubSd0H9h+PaLXG8UCU7Z4Jp7
         0NnfnKKo4TyICcIefCELKrKN3J9gSbI0MrAWqkCcEi3J35a7gRv2b6g7j4t3YyR9bVEy
         xNrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpPrRLcUboi1W4FEWX5TU5VAiaa58veqmWC8iMBUhFTPUAQBBRwiPSwMUqdR5rAkXYKjZ7XkM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9hvyNZX0rjfoS/arjvDtnkHRNzdogGlq+nt6gtf7CxzR+YO2U
	4XMLHtgx4UdOrF7dH6XlBL9+4xnlo3aJjrY1nR8n/xDttaEoSWqAGtyz
X-Gm-Gg: ASbGnctvKBIth6wBazaTdmour4ak4/da10o7vDbVMRohTY5lIC68ouXeMTG2f8JUv2o
	UpFMdpEXrSdjPl2eXH4uUKxcBZXFaFqtHBqLzj+zGO6LoGor1PeI6GOq8JlfxK9WO4UyIZm/HqV
	jn6QWY/erzVYzC8J5fD9kTBzdiBnBaoAQ07ZALXAdsqRHkU9MRltntCn/FUqNOP+q/9tb/2SLHs
	jXlwcUHI6d/C1PzwV1bhhTlecLqYXQIn48eO1iwGpT2tjYOHmf4kli6Z8geZmhUQ6+yTI8AgBM/
	FjGdYZ7K9ukrp0DnQHxafumV3MXI5mogZ9i7lUEj4Jv+nGPxDxZDX0wGUGloIAmXFr8p2tdhzfU
	3qXM0goR/UrTu27XNHNZp
X-Google-Smtp-Source: AGHT+IG8T1D2VcobDSUfxZF55EW9JKFw5MqOt+0GKdF65CJsD1ElHprtWEh3DqhVRm63lx6N1nim4Q==
X-Received: by 2002:a05:620a:a493:b0:826:ef9:3346 with SMTP id af79cd13be357-8260ef93386mr1046185685a.18.1757944204974;
        Mon, 15 Sep 2025 06:50:04 -0700 (PDT)
Received: from cachyos-x8664 ([185.221.23.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-82a0d349ca3sm167578685a.64.2025.09.15.06.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:50:04 -0700 (PDT)
From: Jia Qingtong <jiaqingtong97@gmail.com>
X-Google-Original-From: Jia Qingtong
To: oliver.upton@linux.dev,
	maz@kernel.org
Cc: will@kernel.org,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	cohuck@redhat.com,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	jiaqingtong@huawei.com,
	jiaqingtong97@gmail.com,
	yuzenghui@huawei.com,
	jiangkunkun@huawei.com
Subject: [RFC RESEND PATCH] arm64: Rename is_midr_in_range_list and add is_midr_subset_of_range_list
Date: Mon, 15 Sep 2025 21:49:29 +0800
Message-ID: <20250915134932.8137-1-jiaqingtong@huawei.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jia Qingtong <jiaqingtong@huawei.com>

Regarding the is_midr_in_range_list function, from the early discussions
during submission [1][2], we know:
1. The VMM must ensure the correctness of the target impl CPU set.
2. For errata-related fixes, if any target impl CPU is affected,
then all CPUs are considered affected.

However, in commit e403e8538359 ("arm64: errata: Assume that unknown CPUs
_are_ vulnerable to Spectre BHB")
and commit d4647f0a2ad7 ("arm64: Rewrite Spectre-v2 mitigation code"),
the functions is_spectre_bhb_safe and
spectre_v2_get_cpu_hw_mitigation_state use is_midr_in_range_list
to determine whether the current chip is not affected by the issue
(rather than, as we might expect, whether it is affected by the erratum).

Therefore, for the arg ranges of is_midr_in_range_list being tested,
as long as there is one MIDR present in the target impl CPUs,
the current VM (and the target impl CPUs) are considered not affected by
the issue.

This seems somewhat contrary to the original idea, since the VMM does not
know whether KVM implements positive or negative logic.

Hence, we may need to rename is_midr_in_range_list to
is_any_midr_in_range_listto explicitly mean "if any target impl CPU is
in range_list" and additionally introduce is_midr_subset_of_range_list
for someone like is_spectre_bhb_safe to use.

This patch just show is_midr_subset_of_range_list and it's example usage.

[1] https://lore.kernel.org/kvmarm/86cyftty9q.wl-maz@kernel.org/
[2] https://lore.kernel.org/kvmarm/ZyG3FiUiyOi4t3rQ@linux.dev/

Fixes: 86edf6bdcf05 ("smccc/kvm_guest: Enable errata based on implementation CPUs")
Signed-off-by: Jia Qingtong <jiaqingtong@huawei.com>
---
 arch/arm64/include/asm/cputype.h |  1 +
 arch/arm64/kernel/cpu_errata.c   | 41 +++++++++++++++++++++++++++++++-
 arch/arm64/kernel/proton-pack.c  |  4 ++--
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 661735616787..1339a2e37104 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -304,6 +304,7 @@ struct target_impl_cpu {
 
 bool cpu_errata_set_target_impl(u64 num, void *impl_cpus);
 bool is_midr_in_range_list(struct midr_range const *ranges);
+bool is_midr_subset_of_range_list(struct midr_range const *ranges);
 
 static inline u64 __attribute_const__ read_cpuid_mpidr(void)
 {
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 59d723c9ab8f..30cc91f875d9 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -53,6 +53,45 @@ bool is_midr_in_range_list(struct midr_range const *ranges)
 }
 EXPORT_SYMBOL_GPL(is_midr_in_range_list);
 
+bool is_midr_subset_of_range_list(struct midr_range const *ranges)
+{
+	int i;
+	unsigned long midr;
+	struct midr_range const *range_ptr;
+
+	if (!target_impl_cpu_num) {
+		midr = read_cpuid_id();
+		range_ptr = ranges;
+		while (range_ptr->model) {
+			if (midr_is_cpu_model_range(midr, range_ptr->model,
+					range_ptr->rv_min, range_ptr->rv_max))
+				break;
+			range_ptr++;
+		}
+		return range_ptr->model != 0;
+	}
+
+	for (i = 0; i < target_impl_cpu_num; i++) {
+		bool found = false;
+
+		midr = target_impl_cpus[i].midr;
+		range_ptr = ranges;
+
+		while (range_ptr->model) {
+			if (midr_is_cpu_model_range(midr, range_ptr->model,
+					range_ptr->rv_min, range_ptr->rv_max)) {
+				found = true;
+				break;
+			}
+			range_ptr++;
+		}
+		if (!found)
+			return false;
+	}
+	return true;
+}
+EXPORT_SYMBOL_GPL(is_midr_subset_of_range_list);
+
 static bool __maybe_unused
 __is_affected_midr_range(const struct arm64_cpu_capabilities *entry,
 			 u32 midr, u32 revidr)
@@ -276,7 +315,7 @@ static bool has_impdef_pmuv3(const struct arm64_cpu_capabilities *entry, int sco
 	if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
 		return false;
 
-	return is_midr_in_range_list(impdef_pmuv3_cpus);
+	return is_midr_subset_of_range_list(impdef_pmuv3_cpus);
 }
 
 static void cpu_enable_impdef_pmuv3_traps(const struct arm64_cpu_capabilities *__unused)
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index edf1783ffc81..ce3660625743 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -172,7 +172,7 @@ static enum mitigation_state spectre_v2_get_cpu_hw_mitigation_state(void)
 		return SPECTRE_UNAFFECTED;
 
 	/* Alternatively, we have a list of unaffected CPUs */
-	if (is_midr_in_range_list(spectre_v2_safe_list))
+	if (is_midr_subset_of_range_list(spectre_v2_safe_list))
 		return SPECTRE_UNAFFECTED;
 
 	return SPECTRE_VULNERABLE;
@@ -864,7 +864,7 @@ static bool is_spectre_bhb_safe(int scope)
 	if (scope != SCOPE_LOCAL_CPU)
 		return all_safe;
 
-	if (is_midr_in_range_list(spectre_bhb_safe_list))
+	if (is_midr_subset_of_range_list(spectre_bhb_safe_list))
 		return true;
 
 	all_safe = false;

base-commit: d69eb204c255c35abd9e8cb621484e8074c75eaa
-- 
2.51.0

