Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EBF3587A9
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820217; cv=none; b=ZLYqE8IRta/AirgdAEGJURdrHSTQnpvH7ms89yUxYfQIcctGTZeLdSoGtla3slv8RaWWUpM0h2bK67p+Ob2xbfOH/vZW2rUTHC3HFXwcjXinDUFd47TOoNULVoQBmvgMJGL3dWUI0RIOent42kHPdUFFQznsYjEZhsjPQ8gsnQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820217; c=relaxed/simple;
	bh=Dm/szfHimmX0FDqaxAVh9kHmntpiqJjHXOSsKyz6SVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwHZaTjedLjbDsP+Ko0YMgjZWfHt8TX+GkAeQ3jRhVK1FuX9HSRXWbEyG3mo7CRTXlRYEIO93iQLnmjAp1Pz4Dbzk9iLi/HGDbMQeIekESOA/QseroNPajin63jRad/Aiw/UmnL6BJpASGT6O+2X7augFXu9/BEp7QiJnSfJaOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPn17J6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPn17J6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09132C4AF09;
	Mon, 19 Jan 2026 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820217;
	bh=Dm/szfHimmX0FDqaxAVh9kHmntpiqJjHXOSsKyz6SVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPn17J6Tvl8EoN2zKl/y/GPQ/6B2Z2EQ2ZtlBkv9lAnBF9Nv1APoQ1zz8iq5ZWXK/
	 eAyIsYZEAkqgbUNwUbgO9PgSSaJLJ41qXMowyfYevnklhe4pBpQKMJ1Olhvz4NMGtN
	 taP7ECFW6I85rjGNOvzlC1kmf+3GdPkVd/s3fhpQ7rnmNuyKJsbp8mhV1VBIe0AlfN
	 S2mwRBMiAEfHZ+IHaOAIe6C+g7PpTGKHKj30c8yEQqj9UgkYiF9G92yyEBnnIGdx+R
	 nn0AdE93UbCXIe3GiZhGt2iv0L7d2VS3eZI02A/5+gcCh4UbHSkzfPl1srLIPOVqWZ
	 bMLa3WHr036xg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vhmwI-00000003YVK-3zmM;
	Mon, 19 Jan 2026 10:56:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 1/6] arm64: Add MT_S2{,_FWB}_AS_S1 encodings
Date: Mon, 19 Jan 2026 10:56:46 +0000
Message-ID: <20260119105651.255693-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119105651.255693-1-maz@kernel.org>
References: <20260119105651.255693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

pKVM usage of S2 translation on the host is purely for isolation
purposes, not translation. To that effect, the memory attributes
being used must be that of S1.

With FWB=0, this is easily achieved by using the Normal Cacheable
type (which is the weakest possible memory type) at S2, and let S1
pick something stronger as required.

With FWB=1, the attributes are combined in a different way, and we
cannot arbitrarily use Normal Cacheable. We can, however, use a
memattr encoding that indicates that the final attributes are that
of Stage-1.

Add these encoding and a few pointers to the relevant parts of the
specification. It might come handy some day.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/memory.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 9d54b2ea49d66..a2b7a33966ff1 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -175,19 +175,24 @@
 #define MT_DEVICE_nGnRE		4
 
 /*
- * Memory types for Stage-2 translation
+ * Memory types for Stage-2 translation when HCR_EL2.FWB=0. See R_HMNDG,
+ * R_TNHFM, R_GQFSF and I_MCQKW for the details on how these attributes get
+ * combined with Stage-1.
  */
 #define MT_S2_NORMAL		0xf
 #define MT_S2_NORMAL_NC		0x5
 #define MT_S2_DEVICE_nGnRE	0x1
+#define MT_S2_AS_S1		MT_S2_NORMAL
 
 /*
- * Memory types for Stage-2 translation when ID_AA64MMFR2_EL1.FWB is 0001
- * Stage-2 enforces Normal-WB and Device-nGnRE
+ * Memory types for Stage-2 translation when HCR_EL2.FWB=1. Stage-2 enforces
+ * Normal-WB and Device-nGnRE, unless we actively say that S1 wins. See
+ * R_VRJSW and R_RHWZM for details.
  */
 #define MT_S2_FWB_NORMAL	6
 #define MT_S2_FWB_NORMAL_NC	5
 #define MT_S2_FWB_DEVICE_nGnRE	1
+#define MT_S2_FWB_AS_S1		7
 
 #ifdef CONFIG_ARM64_4K_PAGES
 #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
-- 
2.47.3

