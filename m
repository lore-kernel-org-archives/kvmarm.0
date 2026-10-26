Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002991;
	b=fFpHlHkHBzTn8HsT8f3yYrN/uOMW+X0ROeXocnCB1t4rEl652A0CHRKRxEca8QMm01bM
	 6vkF8/N7pDyoFawzZ5sLCNMglr3ETQgddpTdbE30ESDbRZGh9sVzsxOXFW0daLaiFdRIh
	 cUX6ExNs6mKW8siXZwzwVurFVJfORN2KIhEfY/JQdRX/0m8xrnOmbTn7AqXmCknTNEBU5
	 PpKA6NQ4z4TN9nX0qIyPkTx8+qKzDC7CafClEikun83PFpbgubOsb9qKhvznP3taKEzFh
	 vcGVzM4YrSQtcvlQryzprl9QkkqPOgOh30B5L+C5vlsNC4GQmWa2y/uFr1io1As6pkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002991;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=w4N8ZW/s1BKVrlyy1gY9Ahq28l6tlIiYccC8/EYeZPM=;
	b=fVRlq6w0S4+5I512p93zByIvPQ1olFoUOZjU7EtGFf6m/60VbR9z26Y2PNe64fJ+9U87
	 a/LtmklKYbSvrY3DdsBQYtaBuN6pD7CT83ormzItauNUFkq0qtsSyRqtosnez2kV5/tNx
	 kSwqUHRfq60Auf2jydXhbw/RXxtH2lVzVzM8ogWm3jt1bZ3/JzRo79UNzu1Oz5x9lRl2i
	 QLhPLShqTkeYwtzhQlfWu0a3ZZLCXrEi06h2WuSRZ6RSAzonQRmGW72xW86DY4EPMZNDI
	 t/rgdhpxu/skgynyrjkgIaZyLZygnJIB9+Ps+B99sIdWIA7sCXBVwI+PeE6kooU7WOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y+Iyn/0R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567A2606A31D
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 08:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y+Iyn/0R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D595D1F01828;
	Mon, 26 Oct 2026 08:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793002990;
	bh=w4N8ZW/s1BKVrlyy1gY9Ahq28l6tlIiYccC8/EYeZPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+Iyn/0R5Uo0vF0saj3WkwYUlUNM5WYbCbg2LdNLgfQjUqM+OOmRn1FLSf1D2ztOR
	 ZM+HamV97nKXFsgMQNTb6XXOcHFUFvqBEE756eMunDFyIr58Aw4m/TA5/QdqWBJTPT
	 UkRAtK62hKrJ4KTVTD5w5NNCK1dGj8Cppca9ttYZc6jPql3IcwCcJbJY3NljRWxPsx
	 3o721dZQdUW38S3s5g/Pwnw3WZpT16ELLtQ3e1MBMhO+r8ZNZuyCnXvSiKWnssIuUk
	 9hGfr9mpYqcTfgPIerFYouCbshmO5wWzD6D3vFBqE8+vRIMG9hLNioiOCVsgx9ltGT
	 yvdHpWt+x3ZZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLFz3-00000007A40-0Md2;
	Mon, 26 Oct 2026 08:23:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/2] arm64: Add return value to mte_disable_tco_entry()
Date: Mon, 26 Oct 2026 08:23:04 +0000
Message-ID: <20261026082305.2515705-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026082305.2515705-1-maz@kernel.org>
References: <20261026082305.2515705-1-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to provide adequate levels of synchronisation when clearing
TCO, update mte_disable_tco_entry() to indicate whether it has actually
done something.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/mte.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 7f7b97e099968..411e5a6f6d94c 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -224,10 +224,10 @@ static inline bool folio_try_hugetlb_mte_tagging(struct folio *folio)
 }
 #endif
 
-static inline void mte_disable_tco_entry(struct task_struct *task)
+static inline bool mte_disable_tco_entry(struct task_struct *task)
 {
 	if (!system_supports_mte())
-		return;
+		return false;
 
 	/*
 	 * Re-enable tag checking (TCO set on exception entry). This is only
@@ -240,8 +240,12 @@ static inline void mte_disable_tco_entry(struct task_struct *task)
 	 * expensive.
 	 */
 	if (kasan_hw_tags_enabled() ||
-	    (task->thread.sctlr_user & (1UL << SCTLR_EL1_TCF0_SHIFT)))
+	    (task->thread.sctlr_user & (1UL << SCTLR_EL1_TCF0_SHIFT))) {
 		asm volatile(SET_PSTATE_TCO(0));
+		return true;
+	}
+
+	return false;
 }
 
 #ifdef CONFIG_KASAN_HW_TAGS
-- 
2.47.3

