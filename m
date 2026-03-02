Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4013B1E98FF
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452635; cv=none; b=IDKTnLw0xkazfNbCemPH5/h6Y//if4Ht96h7orV1heysAzZEqldzYbK6vjymq5exO9HODhhwejhK5W1QT+0kvQ2v0SdJllffkfZpm3NzlPHvBq6ffuE/+xIOEBP247iZlWUnxrb+YFe3UiGxgTwgzqn9M/5oS76zdztYlosv+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452635; c=relaxed/simple;
	bh=XYv2uFoCScsWY4QYL23fib7a+k78PtSH2Bqah2U4qNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcnhmI/i697l9SJZYummd9UKwfKzKIcbYWQPqgn1BRPcP1CRVAj159Z+pY79WRID/IwvllIpyvf1kgbeEo915uOOKXW/e5fZEgfGWRVd6tn1wVGn82hnWh5nBPmiBHHUvWmJAq/lBwF4P4KPzT1KGDQLwmckuEzEw7w/ROrw6k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+oRTm/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+oRTm/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFA4C2BC86;
	Mon,  2 Mar 2026 11:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452635;
	bh=XYv2uFoCScsWY4QYL23fib7a+k78PtSH2Bqah2U4qNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+oRTm/38BZES5QNRLH3fG9evg+VNxa5AvoUru8iuxu2hhxUFF6AWHo0x1LmMpel7
	 I5lQ4sQs5Veyh+uSJVkOW4vdnpKuytDq7NoZwH+FBiT46IYv32SDyEEPGsJ1+AP/24
	 FooeLWS5Mu2X9ZaJf5oG/+boZt32AT87z0TbWogRe18lwKRihnE5Lsk+GSmuVB3Dat
	 h/3AQ2AQiPN2oEj1BAUg0liT/cf5g2ElDse/w7cbXAr8ZUfZHlOV0e+6eRHTVOieRP
	 riJ+K+d48O9FQi/+GWGgGoKcndRRyQzwu/+s28KXHuxRP8yCR+VsLQ07XLcKFlJ1K6
	 gwoSsD38w5vbQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1th-0000000FDFJ-0OkR;
	Mon, 02 Mar 2026 11:57:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 01/11] arm64: Skip update of an idreg field affected by an override
Date: Mon,  2 Mar 2026 11:56:42 +0000
Message-ID: <20260302115653.1517326-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302115653.1517326-1-maz@kernel.org>
References: <20260302115653.1517326-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When computing the new value od an idreg that contains a field
affected by an override, do not update that particular field.

The value computed at init-time must be kept as-is, as that's
what the user has asked for, for better or worse.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c31f8e17732a3..28fc77443ccd3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1224,6 +1224,13 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
 		s64 ftr_cur = arm64_ftr_value(ftrp, reg->sys_val);
 		s64 ftr_new = arm64_ftr_value(ftrp, new);
 
+		/*
+		 * Don't alter the initial value that has been forced
+		 * by an override.
+		 */
+		if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
+			continue;
+
 		if (ftr_cur == ftr_new)
 			continue;
 		/* Find a safe value */
-- 
2.47.3

