Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2503AC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:58:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE7A74B24E;
	Tue, 19 Apr 2022 02:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K37Thgy3YBV9; Tue, 19 Apr 2022 02:58:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F144B28A;
	Tue, 19 Apr 2022 02:58:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D305D4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:58:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pa8QjiEN5JY7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:59 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7424A4B202
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:59 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 e18-20020a17090301d200b00158faee4449so3116236plh.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xBTLHLT7VrzBgTmY/Z5pWtMxjNk9GRjM0Wsv/9rlNHc=;
 b=VXqtSraq8cu7MS05g2E9z+XuvMzeSXl2fFGX5Y01D5E/dIxxlzx8ieTe37RrjIk3U8
 Qh9dlqkHr26rlE7cUeUJ722X9fORrcSyls/mjjfEdxkk7qv/i5exSe67vJL6znd7Jmxj
 XQleVnWUgNa/U6XHeLU4cVi7jJbuACQra/1UYgGqj4K+tkf/7sFnacr1qvJFFrXMhwrq
 LjiCU6LR5oMDmzv/AEuJDND+2wNX7EIcualNNJMKjPM+NXlYzs2C04kgPXIuXt8MTbBE
 VzdBDFwig9oH+F/vqkUZNWb/QeEljHfxo03ihPpY/Au8WjocLvzfT43Yox/2khE42Mcv
 XECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xBTLHLT7VrzBgTmY/Z5pWtMxjNk9GRjM0Wsv/9rlNHc=;
 b=vZMl2c3CS6nJKLBY7meGl7gRqSEqkEXsm7Ayur/1Miv7k60f8mNejeSc0sopx28mhf
 jyG25HOmwZAEdfu27UN03LKN9rId9QcNX6Rd7V8WLKgX7GPUCH6t7Gf/YjU6RAaKNtyF
 NtVKJ6dY0IY2AO3r8qXzbhCJwjUsGSIvXyjeg80VLHiWhvvB/VTVoaDUjGfwp4V5ZaM6
 3vA+3hzIK3uQDmo0X+6/icf5HzBc/eF9tzOdFQTMcDu0yE6bp+KsBNRwUtYwmDqkd8mp
 2dMp+rhFQYc35CPKOcZUdFZ6fDsHQJXo/+YiHANIy9Fur4Xk18M1MbxO/gQrapk6UYg+
 2nvw==
X-Gm-Message-State: AOAM530HExl4it/pEwxESrlSbUg9esbrzwAwFSq5g3eUwhRQ/g/o93cX
 L0vYdnANntzFovF2fRP/0voJFYH0Wfw=
X-Google-Smtp-Source: ABdhPJwdi9SagPghJ2ANdJN9l35v2yt6f3eckRDsDVajt8Roakd+ylnifLm17O2VDNHE6Bdtl1/igHdjhO4=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:390d:b0:1d2:7a7d:170e with SMTP id
 ob13-20020a17090b390d00b001d27a7d170emr13243483pjb.230.1650351478693; Mon, 18
 Apr 2022 23:57:58 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:39 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-34-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 33/38] KVM: arm64: selftests: Add helpers to extract a
 field of ID registers
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Introduce a couple of helpers to extract a field of ID registers.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  5 ++++
 .../selftests/kvm/lib/aarch64/processor.c     | 27 +++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 8f9f46979a00..e12411fec822 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -185,4 +185,9 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+int extract_signed_field(uint64_t val, int field, int width);
+unsigned int extract_unsigned_field(uint64_t val, int field, int width);
+int cpuid_extract_ftr(uint64_t val, int field, bool sign);
+int cpuid_extract_sftr(uint64_t val, int field);
+unsigned int cpuid_extract_uftr(uint64_t val, int field);
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9343d82519b4..c55f7dfc8567 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -500,3 +500,30 @@ void __attribute__((constructor)) init_guest_modes(void)
 {
        guest_modes_append_default();
 }
+
+/* Helpers to get a feature field from ID register value */
+int extract_signed_field(uint64_t val, int field, int width)
+{
+	return (int64_t)(val << (64 - width - field)) >> (64 - width);
+}
+
+unsigned int extract_unsigned_field(uint64_t val, int field, int width)
+{
+	return (uint64_t)(val << (64 - width - field)) >> (64 - width);
+}
+
+int cpuid_extract_ftr(uint64_t val, int field, bool sign)
+{
+	return (sign) ? extract_signed_field(val, field, 4) :
+			extract_unsigned_field(val, field, 4);
+}
+
+int cpuid_extract_sftr(uint64_t val, int field)
+{
+	return cpuid_extract_ftr(val, field, true);
+}
+
+unsigned int cpuid_extract_uftr(uint64_t val, int field)
+{
+	return cpuid_extract_ftr(val, field, false);
+}
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
