Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E2E5D8E5
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 22:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1VEBhZ/O"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da04fb79246so297886276.2
        for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 14:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700691331; x=1701296131; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rHQ5lVYi4/2MX2skoChLDy6Ocqhy29V3zUGeEPzVvPk=;
        b=1VEBhZ/O5zeI/e0WJm4n8vCit89K6IhNuhFF+NOMFEb7exBndQiHtvpBiT9pwg1svg
         SqtWe14N0++dDZzeVL1T2yeDsB7dDexlPD8A2YPOy0q+m+QIAO16KIdG9BKG+OAApGDc
         +V0mz/2uUfKjIplW+Wun9pJtVifTlhVuugJEu8ArfAAD02pRbNftvUCh+XO0bhgAOW6T
         xSqB3xCFFE/od3N2j1szArclo7ypgS2zbFa0v0r1YvFNsYTBVMpe7U7bOukoSFxitWBW
         0x+vmplFXoi6YGgsNr2kuKD37G+HySalfggDVyPtdpAcEw7n2TKWTYFEbgzsK0TMIFgf
         RGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700691331; x=1701296131;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rHQ5lVYi4/2MX2skoChLDy6Ocqhy29V3zUGeEPzVvPk=;
        b=eWgbl2igNSLlF+lBp0oDq8xT+npawsnV8+Jl9skvJ1IriJ7eudCopIRj8JzuslYQPh
         J2oOzJHgSxz75D+ZT5+T5qKxbZ7CotSlEomVfGmvrbj6wtKZ/2jlJSNMWUBsJYYM162e
         djvzphdtFde1ypNx8umEqvgGVHU+znjTgbXlSPWCPaBMZRO3A5yVwHrUL/YIXlAxQ7pn
         W4/SMpEbX/oznSMaV5h2/2T6pj7n1/N8yD4ETzckeSFj961PITbggZgMG7t1/2um6QT1
         ar07vifyiMQPcI6WoFkF9NVxuJo5JZgDuZBeKcyb8J1QMww28CyTipIhYIK8weR3bi5/
         q2Og==
X-Gm-Message-State: AOJu0Yyw9/WJJousNOjYnV6VkIwibiWuAV1e40M4K3h8vCaV80YBpkmc
	ryiHUsdb6KKU7qlt1X99CxEjl2XpVb2v
X-Google-Smtp-Source: AGHT+IEKPFb2EHSzpX16MEr8UpukYHRCQvq4K7GrE1lzHEciYPJMeZQvd7fCFY+au119NI7M63atWhaudwtg
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:ce4e:0:b0:da0:c6d7:8231 with SMTP id
 x75-20020a25ce4e000000b00da0c6d78231mr109435ybe.0.1700691330951; Wed, 22 Nov
 2023 14:15:30 -0800 (PST)
Date: Wed, 22 Nov 2023 22:15:26 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231122221526.2750966-1-rananta@google.com>
Subject: [PATCH] KVM: selftests: aarch64: Remove unused functions from vpmu test
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

vpmu_counter_access's disable_counter() carries a bug that disables
all the counters that are enabled, instead of just the requested one.
Fortunately, it's not an issue as there are no callers of it. Hence,
instead of fixing it, remove the definition entirely.

Remove enable_counter() as it's unused as well.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/vpmu_counter_access.c  | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 5ea78986e665f..e2f0b720cbfcf 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -94,22 +94,6 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
 	isb();
 }
 
-static inline void enable_counter(int idx)
-{
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenset_el0);
-	isb();
-}
-
-static inline void disable_counter(int idx)
-{
-	uint64_t v = read_sysreg(pmcntenset_el0);
-
-	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
-	isb();
-}
-
 static void pmu_disable_reset(void)
 {
 	uint64_t pmcr = read_sysreg(pmcr_el0);
-- 
2.43.0.rc1.413.gea7ed67945-goog

