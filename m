Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852C57479
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 14:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033A3C433A8;
	Thu, 16 Feb 2023 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676557311;
	bh=rCEjLLVsTGonFud3H7BkWOpBovbyq0wpTVXBpO5J6GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coJ+WuougGjW/dNobIz865CknMyLAE5fjJdQEW+mGMmcDgUKxiNHIqyVTptljtaII
	 +pfCAabezbp2pdA3AZ4kwkyiRywf5XBay8G0ME4nVO72pe/aXzmZrvZ4jTP6xQpifJ
	 /88LDImUQHNa5qWxel2mdKlCpZrqpXSI9rUjPvUnCR4AYhpHS91ZN5KFylCAPm4hPA
	 RIKzZxDjGsoC2LAzFuC9/PThvp3WEWmWEwNpueId0agGBM75Hp5nRL8KyzKsLz04Dq
	 YY8Z68IPRuJtLJIrYfLc5uCFJGJZ2Yk4h88Puw62P9VbJ4D0maz2R2G/0yAj3HWKKp
	 jh5Es3YIASw8w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pSf8v-00AuwB-93;
	Thu, 16 Feb 2023 14:21:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	dwmw2@infradead.org
Subject: [PATCH 09/16] KVM: arm64: timers: Allow save/restoring of the physical timer
Date: Thu, 16 Feb 2023 14:21:16 +0000
Message-Id: <20230216142123.2638675-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Nothing like being 10 year late to a party!

Now that userspace can set counter offsets, we can save/restore
the physical timer as well!

Nobody really cared so far, but you're welcome anyway.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 07444fa22888..46e910819de6 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -590,11 +590,16 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 	return copy_core_reg_indices(vcpu, NULL);
 }
 
-/**
- * ARM64 versions of the TIMER registers, always available on arm64
- */
+static const u64 timer_reg_list[] = {
+	KVM_REG_ARM_TIMER_CTL,
+	KVM_REG_ARM_TIMER_CNT,
+	KVM_REG_ARM_TIMER_CVAL,
+	KVM_REG_ARM_PTIMER_CTL,
+	KVM_REG_ARM_PTIMER_CNT,
+	KVM_REG_ARM_PTIMER_CVAL,
+};
 
-#define NUM_TIMER_REGS 3
+#define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
 
 static bool is_timer_reg(u64 index)
 {
@@ -602,6 +607,9 @@ static bool is_timer_reg(u64 index)
 	case KVM_REG_ARM_TIMER_CTL:
 	case KVM_REG_ARM_TIMER_CNT:
 	case KVM_REG_ARM_TIMER_CVAL:
+	case KVM_REG_ARM_PTIMER_CTL:
+	case KVM_REG_ARM_PTIMER_CNT:
+	case KVM_REG_ARM_PTIMER_CVAL:
 		return true;
 	}
 	return false;
@@ -609,14 +617,11 @@ static bool is_timer_reg(u64 index)
 
 static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	if (put_user(KVM_REG_ARM_TIMER_CTL, uindices))
-		return -EFAULT;
-	uindices++;
-	if (put_user(KVM_REG_ARM_TIMER_CNT, uindices))
-		return -EFAULT;
-	uindices++;
-	if (put_user(KVM_REG_ARM_TIMER_CVAL, uindices))
-		return -EFAULT;
+	for (int i = 0; i < NUM_TIMER_REGS; i++) {
+		if (put_user(timer_reg_list[i], uindices))
+			return -EFAULT;
+		uindices++;
+	}
 
 	return 0;
 }
-- 
2.34.1

