Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFD822F03
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAAAzI0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01D2C43391;
	Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897424;
	bh=JPDliCysNAGaXceqZR+n1mYKUpMZcy9h1sqDdiU78iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAAAzI0+e8OMB4uVsbmcNBA09z82k8sDTTbqvT0mKIyOewMLzK6sXfUE2W6rywQGt
	 DtanklzVP6evaAouzKlAna36jJ3wo6joNW5vIJzK16hjMTFJbDja9RrTLdOxAsm7qS
	 1ueB+/tLgYXGJtyzKZZvTEqt7yJyIBZedy1Sm3YAlUgmPM9biOy6tKjKbCJ03P65Z2
	 E1UyRMCMfC9pGQ2H4uz8mruv3OuraXwnI8KFaZndOEpe3hAy8cwyte2G9cYdVc93rE
	 Ho2l1EvAU9nkormzdBCnSWXn6598C/fi+7YcSwujelyW+OIYRYqTdaoHnUDTCojrRI
	 yd8C1H2th9IVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayM-00CkQ4-8O;
	Mon, 13 Nov 2023 17:43:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 02/12] arm64: cpufeature: Correctly display signed override values
Date: Mon, 13 Nov 2023 17:42:34 +0000
Message-Id: <20231113174244.3026520-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231113174244.3026520-1-maz@kernel.org>
References: <20231113174244.3026520-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When a field gets overriden, the kernel indicates the result of
the override in dmesg. This works well with unsigned fields, but
results in a pretty ugly output when the field is signed.

Truncate the field to its width before displaying it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e52d2c2b757f..767a6f288755 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -950,7 +950,8 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
 				pr_warn("%s[%d:%d]: %s to %llx\n",
 					reg->name,
 					ftrp->shift + ftrp->width - 1,
-					ftrp->shift, str, tmp);
+					ftrp->shift, str,
+					tmp & (BIT(ftrp->width) - 1));
 		} else if ((ftr_mask & reg->override->val) == ftr_mask) {
 			reg->override->val &= ~ftr_mask;
 			pr_warn("%s[%d:%d]: impossible override, ignored\n",
-- 
2.39.2

