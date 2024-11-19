Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42930149C7A
	for <kvmarm@lists.linux.dev>; Tue, 19 Nov 2024 20:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732049926; cv=none; b=n/XCJlG+TX7SKQy3lr7lhmVqmV6JegK7Z0f2TG5O8d5Pes5VHOCBfXhNoEiSAilMO+4jY8NrVfOOF/tws0lFEGROg1+DkdmHxt4cP0MXELiFv2Sqzr0N3RGwpl91xwhNSEkIhlHiDRC5pwaCahgVbr+7zNW6oBZc+Mi1z/pnmys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732049926; c=relaxed/simple;
	bh=8WEdVpyGErxs99Yh1r9MEMQl5LIFDjaIDidlxrekh0s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=T40oIyfM33Ozvv/lzKJaClsCcN20AtiYXQSJkXY28+tgXGHpYfiGosHeAN2Mf3ZaEg5QxAWwM3VOsUz5u4kR9juIDpd0aMDm6l+/nf3QhzKIWf6NJxmfqFxH3nwcJN94paq/xD2J09g+kvieYm+32wiYqfwLZ1lZMOx9wYuBTw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hmmrSnMh; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hmmrSnMh"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e3314237b86so4882636276.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Nov 2024 12:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732049924; x=1732654724; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r6S4rOH3+OQSdJMr5U+1w/fQ9eAelD/5+HuDvTmNypE=;
        b=hmmrSnMhXwLP7tpD0EMNMfpbAG7k09uxNd5mUwWERe9HoN3fcrtBNPDM/4fdK6n52V
         +bnVwcsr7Di9dNBCmyyIXXR/dc5oJHte2KShVYlL9ez4RfWDsaruUTWmqZ10u4Wr1djR
         KrjpeEzw61oan9lIY/eGAZYgbIQ0DR071WbbHZe057piompZZ0TTlNvnu6csZgdJjubv
         XirW4ot3VnJhjPa431aQ1A2j5JYNDNXju4K/BKQgZWvulqD+9GNavUdHCwULihHiaw+b
         okP1LYNAtE/k6qJm8lo+udUWQz2dN9fOZaZkX22mp2XXlL8x1ARSClbYnAUTTUwgpDm+
         uRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732049924; x=1732654724;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r6S4rOH3+OQSdJMr5U+1w/fQ9eAelD/5+HuDvTmNypE=;
        b=iupkAwW6Cg9Ubf8HuA8KeEO0cDLaDLP8qLDaU/0sfEBXMyif3jOXHPHnt4YhQovp+M
         y+vOIwJkYdODi3mJQrza3u0CjUlRwv7JAIoxcE6w/23lWSM2cEe2SOYh5dTKrhKR+xDL
         Vf8YidabuswpCzKXfpSngttYHfvqu/0YimwYXOaSYauaUmq24lwkOsVG6I+t8CQd1ohQ
         Ll7EYTFkLg+EshPvnpXlNwzTzKxCiYENptwptPdShLJCVZ5DQRjAM0EDCt8uHBteoARq
         hkS5dRrR4BNcS40A41hLL5L5AnEyevBEGu3XSL1PJv3HJkNzWR3YP9WmDSp5vkt33yqX
         RCpA==
X-Forwarded-Encrypted: i=1; AJvYcCUUgUYzDMhpL3BX5UIQMR985VojHluWYF6Z9xlDfgUQPp+U2Swv+rNPbP5ZgtXv+PG8w3U54Ik=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6K2jQqZWKVo/JickjIaF8JmylJ0bv5xChxtm9IEWjgoqCvi3s
	xaF39plw56xK8Q43fRlYvKPrUlt1FnkADNmkolO6d92uEEoi0yme3scC4B5eiA4+f6u6di3XXcy
	LtyyObw==
X-Google-Smtp-Source: AGHT+IHpK5pQqyJ2pkrSLDCOOUklWO2InSnJR1eVoVoMwnsqp16+77q4Yb5PQps1c7yCQOY0bhbxQaG15qmS
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:2d0b:0:b0:e38:c40b:a0a9 with SMTP id
 3f1490d57ef6-e38cb60bac3mr38276.5.1732049924316; Tue, 19 Nov 2024 12:58:44
 -0800 (PST)
Date: Tue, 19 Nov 2024 20:58:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241119205841.268247-1-rananta@google.com>
Subject: [PATCH] KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_pmu_overflow_status() currently checks if the PMCs are enabled for
evaluating the PMU overflow condition. However, ARM ARM D13.1.1 states
that a global enable control (PMCR.E), PMOVSSET<n>, and PMINTENSET<n>
are sufficent to consider that the overflow condition is met. Hence,
ignore the check for PMCNTENSET<n>.

The bug was discovered while running the SBSA PMU test, which only sets
PMCR.E, PMOVSSET<0>, PMINTENSET<0>, and expects an overflow interrupt.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ac36c438b8c1..3940fe893783 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -342,7 +342,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 
 	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
 

base-commit: adc218676eef25575469234709c2d87185ca223a
-- 
2.47.0.338.g60cca15819-goog

