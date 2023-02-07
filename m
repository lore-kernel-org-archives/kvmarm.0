Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6A20E8
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 09:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DC9C433D2;
	Tue,  7 Feb 2023 09:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675763017;
	bh=2jOfnH0AFTuGvcLFpRa+d5kJkfqu1bU9jqbnaCSbRMI=;
	h=From:To:Cc:Subject:Date:From;
	b=BvhNDDpwz0Jha72zCVR5OsOcpjPXKm22dRW3sfP3nUC5ZsolU+rzWEqYYt7Zkyn7G
	 NX/Iy49eFmOwtDLf2sUTkVD+nRyou2NOqlvVJyWKMH/jC8cFzY/6g/7BaUNtG0gK39
	 yDN+Jkx+EnDsLLQU/rA3j1HCoq6RT62frDWeEY/Iqkonw+VN0V0tFN4KSj8uNs32dF
	 n3sAyhNrb6Vcb2nnomrPXVC82nTYJFDH94FMfnkh8lW7f48EwW/juL2bACbrUHIWSo
	 xnZV/W5jWsGfr12VgCh+he/43J+WzumW/LgipPXyWU1MQlrZIk/eGTMlNCz5pSK3g1
	 40PJVD4XX7qFg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pPKVj-008HEr-2M;
	Tue, 07 Feb 2023 09:43:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Fix non-kerneldoc comments
Date: Tue,  7 Feb 2023 09:43:21 +0000
Message-Id: <20230207094321.1238600-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The robots amongts us have started spitting out irritating emails about
random errors such as:

<quote>
arch/arm64/kvm/arm.c:2207: warning: expecting prototype for Initialize Hyp().
Prototype was for kvm_arm_init() instead
</quote>

which makes little sense until you finally grok what they are on about:
comments that look like a kerneldoc, but that aren't.

Let's address this before I get even more irritated... ;-)

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/63e139e1.J5AHO6vmxaALh7xv%25lkp@intel.com
---
 arch/arm64/kvm/arm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..6b59d89811be 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1909,9 +1909,7 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
 	return 0;
 }
 
-/**
- * Inits Hyp-mode on all online CPUs
- */
+/* Inits Hyp-mode on all online CPUs */
 static int init_hyp_mode(void)
 {
 	u32 hyp_va_bits;
@@ -2187,9 +2185,7 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
 	kvm_arm_resume_guest(irqfd->kvm);
 }
 
-/**
- * Initialize Hyp-mode and memory mappings on all CPUs.
- */
+/* Initialize Hyp-mode and memory mappings on all CPUs */
 int kvm_arch_init(void *opaque)
 {
 	int err;
-- 
2.34.1

