Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8793793DD
	for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 16:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776789679; cv=none; b=Vy3eru+fuL0FJjrq/g+mScTlIWxF10st6jcsLYZ1Hax7ovOk2KnqBAyQj2q4rsAbJ//ykr9UeAFLgEfOqrTUDVsRPcs59zKpkbrQRVAl+qYa/7Czbldh+EZT4Emnwnl2zqP4ztjiL2HHuhc3sPa63hIoTxxlZApXGo8WbNxoX2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776789679; c=relaxed/simple;
	bh=JgBQYCcFyw7eZBRlU8slk/gqMwHy5PO1mGjXHwFR09k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YOwywXt3ZaK/tj/wwBJexC382+8nXDE2yHL1JoTCt3IabiLjrBobpq6epzze65FtV4CMG2qIp21hXuWXZR6IjV/vCAW2DMhCqiG6vtUNB0Ekg8b1VsRE1sdHeCTmsblHZ6CO4z64Y43pBk7pvj0J1pA86B4fmaXXDAUof8ZmuRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H+FHcYDj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H+FHcYDj"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b258636d16so45213915ad.2
        for <kvmarm@lists.linux.dev>; Tue, 21 Apr 2026 09:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776789677; x=1777394477; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mGHowqlkhnvPIJdGbn1Su1BmTTCjZzOEKR7Ulucq9pI=;
        b=H+FHcYDj5lmQoK0Aa2sllPRjupfMxOxqYwvtHxA0+wiT9OYTYEMj5kNe+Ca9zgqOfz
         uSCW7c9byUS3HtXp1sdCquJaSfqv+0WYNxUTAJ6x7uiKaw1SW+2SfoZ9p2be7f/wB1q2
         nFyOwwmBS4KnyRhd/w8T9XeYqPQoOcX8AEOmzPht4g6YY1mNpMUROprmUnIkI0HgLRlH
         IZkXOvrajZVWI2Ug9WeVS7a9Z1BlmS1TTkfzyOyRpLi68q+QVNdB1Hnmpm0tSYIEmU2r
         VziAaarTZpHojZ60SReQGw0PIxFdwq5wdve4i5PgNodEeJ7cIAISmIv0QMWmiQcUuHy3
         HcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776789677; x=1777394477;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mGHowqlkhnvPIJdGbn1Su1BmTTCjZzOEKR7Ulucq9pI=;
        b=RhbT9mclGto6qddIN7rTf9i7fxk7SCcjyNO9PiY11gwDlUAuVXGyj/HCecxB3u1rYv
         O+u2NHfFbtQgtnYEZzP/fFH64j7IaoJsA3LoIm/rL8rPxW13PWp4toeWEG/gD5fnt4a1
         qEGldDFyh2V8536e/RW1lEnzhxMqg56CtlIls+8wmlIW97zdoag0jhA7m09eI8Xp0ALP
         3DCsSjg5avIvdd7+al/X7fR/udjhMA4P+cNdXnmRrQZruft7KMp9DxK1sZ9+72PwFzoN
         acvDBIwYm3qTCzzQHtfw1NK3K0NIKdAE7iKVOnLUovLtY3UcQ2NFrW2x9GvqwqOXUfZr
         3LaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8/QOJKoDKWzdaN7Svb9qvkJnV1Kz8I3GSR6iIfOzLHvkluvboXhocypIKKddW6+uZAm9dXmr8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyN0RwwemTIUQKi+TLGeumyFUrhH5sJDjPzRYQ//P7U7K7EtySh
	lc3U/+M6kTiSCCTpKHT99Z6v5IUU5Zc4RQP6xJnOti8lQjwQA6xJT/TcDIYmXooxyR5ZK3SeduQ
	Pcdj20WlZ8w64IA/L5X2pH6Wr8A==
X-Received: from plik3.prod.google.com ([2002:a17:903:3843:b0:2ae:bb1f:5234])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1ac6:b0:2b2:5840:808e with SMTP id d9443c01a7336-2b5f9ee9487mr187401765ad.10.1776789676962;
 Tue, 21 Apr 2026 09:41:16 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:41:12 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260421164112.2448553-1-jingzhangos@google.com>
Subject: [PATCH] KVM: arm64: Treat ID_AA64DFR0_EL1.PMUVer as an unsigned field
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

ID_AA64DFR0_EL1.PMUVer is an unsigned 4-bit field, but was historically
marked as signed in the cpufeature table. This led
kvm_init_host_debug_data() to fail detection of PMUv3 implementation on
systems with PMUv3p8 or newer, as the signed extraction of the field
(e.g., 0b1000 for PMUv3p8) would result in a negative value.

Fix this by marking the field as unsigned in the ftr_id_aa64dfr0 table
and updating the KVM initialization code to use unsigned extraction.
While at it, ensure that both the 'Not Implemented' (0b0000) and
'Implementation Defined' (0b1111) values are correctly handled as
indicating the absence of a standard PMUv3.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 arch/arm64/kvm/debug.c         | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 32c2dbcc0c641..1b5e37a1a41b4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -565,7 +565,7 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	 * We can instantiate multiple PMU instances with different levels
 	 * of support.
 	 */
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_EL1_PMUVer_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_EL1_PMUVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_EL1_DebugVer_SHIFT, 4, 0x6),
 	ARM64_FTR_END,
 };
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3ad6b7c6e4ba7..2834d7ef9dedb 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -75,8 +75,10 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 void kvm_init_host_debug_data(void)
 {
 	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
+	u64 pmuver;
 
-	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
+	pmuver = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT);
+	if (pmuv3_implemented(pmuver))
 		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
 							      read_sysreg(pmcr_el0));
 
-- 
2.54.0.rc1.555.g9c883467ad-goog

