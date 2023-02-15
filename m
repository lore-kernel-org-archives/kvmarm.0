Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B95315AD
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:07:30 +0000 (UTC)
Received: by mail-il1-f202.google.com with SMTP id k8-20020a056e02156800b003152ca1c48aso7089167ilu.21
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m5yslkEpatxEcn+ZjK5j+e94Zo++KRDXawZarevQP94=;
        b=ej58N8ysN78T8KDIyhj11kncochsRhNrA7Bi1OZuap4Gcpp106AW/WAmUpics1Lde9
         kGvkmrs+EJ/ITG/iLFxr7BlJjVCMrCfMydCohpT3IMM3duvIOEbBca0NDCaC9k5vDekp
         oSGROHd7tFDelb/YWizk3eyN9FziTr642Viat9eIJun84G/gs2Ps603ZiGKb0x4DcJUq
         JPJjjkUK7GP8EWJpE6UWuTqBYHACKRbI8Zig0XQV2X3ztZEdAu7mL8LKQbKdggWvU4wS
         cjsXmnc2IAS3tO4RpRViCgFmrjyChCrnV62EEUw563Wsig3C9O/Zj+Wk8TLLCEZrt2hN
         fkdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5yslkEpatxEcn+ZjK5j+e94Zo++KRDXawZarevQP94=;
        b=yn637fSLqd672ipiE7nPIzSneOwqEBg19Z0DndKU+VZ2nr8ETVELdEO0XSPKUrS2ZA
         HH9R+jCPzQ5OuJU8v4o45+1I4R8YTmAY9RRNmnwdoK5gfDza7+bZuESAZ2TFTWsbi5Dn
         zsfecqtxaTQyTrxn04qbf7oPNojRAiFWHPEGfRV9K0pDQT4dl0MDJHjQHOwcLuxlpJKO
         wEP1pcTsAVuzGlQRmTQMx68X47a206Ype7lp4K33AQKaT+uUFMsE4DZyEN0iy62r0vJu
         85Y1HtnREFRudgolzMIHtaHSGa9VHM0LQadW00O1Us3KHhbQSlmfoiYxTHD2R0uNgOpb
         S8rA==
X-Gm-Message-State: AO0yUKVyeTHd0e+P3h+VmHRJTfG2fEMqJ7cChkCBPAI9V/ua49r8iFNq
	UpJLVJ79j6xOIms87oIlqlAMSQfInkCP
X-Google-Smtp-Source: AK7set/cu+50CTo8tUd6eYrVsq7uo+6UvW9Awlq764pXwqJwlSlmlCFOjle5EQ89W8sHdvl4KibNwCJJu8LF
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6638:3e0f:b0:3c4:a4d1:cc49 with SMTP
 id co15-20020a0566383e0f00b003c4a4d1cc49mr359864jab.3.1676423249641; Tue, 14
 Feb 2023 17:07:29 -0800 (PST)
Date: Wed, 15 Feb 2023 01:07:08 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-8-rananta@google.com>
Subject: [REPOST PATCH 07/16] selftests: KVM: aarch64: Add PMU cycle counter helpers
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add basic helpers for the test to access the cycle counter
registers. The helpers will be used in the upcoming patches
to run the tests related to cycle counter.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index d72c3c9b9c39f..15aebc7d7dc94 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -147,6 +147,46 @@ static inline void disable_counter(int idx)
 	isb();
 }
 
+static inline uint64_t read_cycle_counter(void)
+{
+	return read_sysreg(pmccntr_el0);
+}
+
+static inline void reset_cycle_counter(void)
+{
+	uint64_t v = read_sysreg(pmcr_el0);
+
+	write_sysreg(ARMV8_PMU_PMCR_C | v, pmcr_el0);
+	isb();
+}
+
+static inline void enable_cycle_counter(void)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenset_el0);
+	isb();
+}
+
+static inline void disable_cycle_counter(void)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenclr_el0);
+	isb();
+}
+
+static inline void write_pmccfiltr(unsigned long val)
+{
+	write_sysreg(val, pmccfiltr_el0);
+	isb();
+}
+
+static inline uint64_t read_pmccfiltr(void)
+{
+	return read_sysreg(pmccfiltr_el0);
+}
+
 static inline uint64_t get_pmcr_n(void)
 {
 	return FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
-- 
2.39.1.581.gbfd45094c4-goog

