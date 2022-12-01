Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63718C4321E
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 15:52:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E58B4B286;
	Thu,  1 Dec 2022 10:52:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YNgmI1FlmZ1R; Thu,  1 Dec 2022 10:52:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 012694B256;
	Thu,  1 Dec 2022 10:52:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E411640DCD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 05:50:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aiq2b0TV-zjn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 05:49:59 -0500 (EST)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 01A0840DAE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 05:49:58 -0500 (EST)
Received: by mail-pl1-f179.google.com with SMTP id w23so1250855ply.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 02:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=JPjVjf+i0nuKjzq4xuTtWcDbzlk974FEzySz6jaQavQ=;
 b=707jnRzZEQf01TpjqN9DSN/NFPM/VMAM0ZKeLKPJRYCiI6ojaLlzyyjRPUpTLHEb7+
 t/85QUAWoI1i3uBqrU+h1j5F4G8R54m7oP3WPD6Z75LxFEs8MFosOJnDoLoJMShEhD6T
 M0uSLQjMILQC+3vSNj7yMjn7Uf63q85nOteYpM/WFq3kNP/C4aTX+hOPClaIklzFJcn5
 9uFkhbiVD8TmmdCAgFtsMbaJH9BYrMzT0ak6Zy/dNho9mC3EqFLBduH3k6r/R8W0Ehwh
 3gwT9d0maH8rr+D9FUCYBsu4HRCMmow03xksU5//CMHjWJ9+r3fRPZkEhMzUnLtP4A4y
 iGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=JPjVjf+i0nuKjzq4xuTtWcDbzlk974FEzySz6jaQavQ=;
 b=e0ATUTaBQqC542nqwSpL0umZ5+hey8qWqDtyPoUl6XVX96FN+8HdDKHtpD+qmZfDC0
 TunRL43inA95/rP6uiKEXDFKCWQ3fKThXa8AQIKxcd+NMUfUuRVW7TEJ3MA/fS7hZOo4
 XtpMjHY3v9dCWzpvquek+x5mV8qBF76HjQJPtKK3YN/2NiwEMqyK7OEMiZxMldbM7Dqh
 rRGImcS/x1FSRhdXQByATNLhjYjcoohvLcCEZuOFqlwEhawNVVKPtF0/OMDCauc2xJ/l
 TxcgI1scBtPbK71Ey5B61UD0mXo3Yql8Wn52szlaPh8g5T3ZBsF3Gj024zq4i/oFk8vX
 EDEw==
X-Gm-Message-State: ANoB5plNxvrMsNIelvf+OpFGf5Nki2Ci5xpr7g+KODuiSfG8QLxsyTcP
 rdlh74wUVsrY3IEWZC807g8XHQ==
X-Google-Smtp-Source: AA0mqf5Yhsy8Ypvr0GCLP2Zg6ZsUX9UGviILhc7n8Tbc14XMJHu8PCzO14QcWmW7k5EhIGo/uGorQw==
X-Received: by 2002:a17:902:8d98:b0:189:8e39:3c88 with SMTP id
 v24-20020a1709028d9800b001898e393c88mr19470197plo.102.1669891797955; 
 Thu, 01 Dec 2022 02:49:57 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 4-20020a630804000000b004785a63b44bsm2320580pgi.43.2022.12.01.02.49.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Dec 2022 02:49:57 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH 3/3] KVM: arm64: Handle CCSIDR associativity mismatches
Date: Thu,  1 Dec 2022 19:49:14 +0900
Message-Id: <20221201104914.28944-4-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221201104914.28944-1-akihiko.odaki@daynix.com>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 01 Dec 2022 10:52:00 -0500
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

CCSIDR associativity mismatches among the physical CPUs causes a vCPU
see inconsistent values when it is migrated among physical CPUs.

It also makes QEMU fail restoring the vCPU registers because QEMU saves
and restores all of the registers including CCSIDRs, and if the vCPU
migrated among physical CPUs between saving and restoring, it tries to
restore CCSIDR values that mismatch with the current physical CPU, which
causes EFAULT.

Trap CCSIDRs if there are CCSIDR value msimatches, and override the
associativity bits when handling the trap.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 1 +
 arch/arm64/kvm/sys_regs.c            | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b45cf8903190..df2bab867e12 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -64,6 +64,7 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 static inline bool vcpu_cache_overridden(struct kvm_vcpu *vcpu)
 {
 	return cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
+	       cpus_have_const_cap(ARM64_MISMATCHED_CACHE_ASSOCIATIVITY) ||
 	       vcpu_el1_is_32bit(vcpu);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1f0cb015e81c..181a5b215a0e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -110,8 +110,13 @@ static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
 	 * [If guests should attempt to infer aliasing properties from the
 	 * geometry (which is not permitted by the architecture), they would
 	 * only do so for virtually indexed caches.]
+	 *
+	 * This also makes sure the associativity bits of the CCSIDRs, including
+	 * the ones of CCSIDRs for instruction caches, are overridden when the
+	 * physical CPUs have a heterogeneous configuration so that a vCPU sees
+	 * the consistent values if it is migrated among physical CPUs.
 	 */
-	if (vcpu_cache_overridden(vcpu) && !(csselr & CSSELR_IN)) // data or unified cache
+	if (vcpu_cache_overridden(vcpu))
 		ccsidr &= ~CCSIDR_ASSOCIATIVITY_BITS_MASK;
 
 	return ccsidr;
-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
