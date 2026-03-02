Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF5E27FD52
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452637; cv=none; b=KiFFGtPjPaObI/DD4Ce3aCc54kvTsO5UMOUKJW3bD4ecLM+Vw1Bq1z1K93dUPIcdRPSeHXEhSlvjTltMg0ciuZ5l8FB6OD32gUTtctMrQddv1yKQ40Hgpf5mYDUNX/FQZHd2lyuTIyyX6fGvelR9eOeN6KXhtMaOV0GMsp3YWs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452637; c=relaxed/simple;
	bh=0NKj1xsMfzoojLz4OrS8obtJgA9ZMg+TGGATcRFcjHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sg+/cAX8dUyRcV3a4sxkdTMlituZamTAMA5D1fyv0QiieOKipz+a887KOuUpIOLANE01S1xNmyVUDjsZrO4qQtm2sgrOTZhVC7HcDmMtZfSWjc9hbPCmk+lXEmpr7LblxPGp+JFwXOy7G9RLwLzTyeWCMia6+6oSSQRSgwA0BCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiBVZUUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiBVZUUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22290C19423;
	Mon,  2 Mar 2026 11:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452637;
	bh=0NKj1xsMfzoojLz4OrS8obtJgA9ZMg+TGGATcRFcjHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiBVZUUlnq8zGVinPS7sPQ0gGmuiCUZLHUsXkUDBRT57uGcDfnkf6wjpI+Qy8z1tc
	 YwqPUK9m5tE3s1FnVZvlism6SculbxHpdYpb/tnoFzoGjXcoLLoCGlR+bw+j67ixya
	 8+apRvgfkPY8ZEHYMFdnUpjhBwKtPfoFlesQ8k+o4hzvSoVQ/wJxPnoWxwnEjRZUrS
	 RCEwhKIpH3mZRttfAQ5yo5QqNgXB8tUxaSjC8+QVMegCJYWQc2eS/TeOUidXLBjl47
	 FCFiPa0mpjx384jsAdFuAd1/5FMNOzyBSTY5G/pDqisvctPvyUYO9M7Z+zK93tK4Dt
	 DpmKgJhPA1oEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1tj-0000000FDFJ-1VAX;
	Mon, 02 Mar 2026 11:57:15 +0000
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
Subject: [PATCH v2 11/11] arm64: Remove FTR_VISIBLE_IF_IS_ENABLED()
Date: Mon,  2 Mar 2026 11:56:52 +0000
Message-ID: <20260302115653.1517326-12-maz@kernel.org>
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

Now that FTR_VISIBLE_IF_IS_ENABLED() is completely unused, remove it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e853a0ac7db38..d8accc9c94fab 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -62,8 +62,6 @@ enum ftr_visibility {
 #define FTR_CONFIG(c, e, d)				\
 	(IS_ENABLED(c) ? FTR_ ## e : FTR_ ## d)
 
-#define FTR_VISIBLE_IF_IS_ENABLED(c)	FTR_CONFIG(c, VISIBLE, HIDDEN)
-
 struct arm64_ftr_bits {
 	bool		sign;	/* Value is signed ? */
 	enum ftr_visibility visibility:8;
-- 
2.47.3

