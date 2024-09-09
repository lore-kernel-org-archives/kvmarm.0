Received: from mx.astralinux.ru (mx.astralinux.ru [89.232.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7C614A0A7;
	Mon,  9 Sep 2024 10:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.232.161.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725878408; cv=none; b=bpB427yGz9Oqn1aIal9S7ocRd1siuD5HmvYryAq116XwqOkjueQGYO42QVco4Lh02zInb2yr0th0NiQbmLDpx4XPnVDq0H+Ff1YUEpipDdun4N3gIoeIjxO/j81evgqkrV6ZeLuXClNZqqjhdeRmX0Z6Wv/S9GTs0W+VMkMe2Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725878408; c=relaxed/simple;
	bh=W/5Byqc4HSQmvKdLXbLG4kDtafYkNIOD/L1geBtLHjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JfopayH8dsfCX6opnX8GBxGNEvjBPHDeqWJA2waysr5KbTxVKiKMyIysFnFL+7uZfC7PaUjOYj5quWvfnpbx9Sqpn88e75JYHPvQgQJJDrNjMblPRKBBnvTvHQtO4TjnyazdmUrh5oT24HAEudWgFPR+WYjiZ9aZgh/aix2pr+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; arc=none smtp.client-ip=89.232.161.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Received: from [10.177.185.111] (helo=new-mail.astralinux.ru)
	by mx.astralinux.ru with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <abelova@astralinux.ru>)
	id 1snbmp-00BGaU-87; Mon, 09 Sep 2024 13:38:23 +0300
Received: from rbta-msk-lt-106062.astralinux.ru (unknown [10.198.22.134])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4X2Ncg5b7tz1c0X1;
	Mon,  9 Sep 2024 13:39:31 +0300 (MSK)
From: Anastasia Belova <abelova@astralinux.ru>
To: Marc Zyngier <maz@kernel.org>
Cc: Anastasia Belova <abelova@astralinux.ru>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Matt Evans <matt.evans@arm.com>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] arm64: KVM: prevent overflow in inject_abt64
Date: Mon,  9 Sep 2024 13:38:27 +0300
Message-Id: <20240909103828.16699-2-abelova@astralinux.ru>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240909103828.16699-1-abelova@astralinux.ru>
References: <20240909103828.16699-1-abelova@astralinux.ru>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DrWeb-SpamScore: 0
X-DrWeb-SpamState: legit
X-DrWeb-SpamDetail: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehuddgtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfftfghgfeunecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeetnhgrshhtrghsihgruceuvghlohhvrgcuoegrsggvlhhovhgrsegrshhtrhgrlhhinhhugidrrhhuqeenucggtffrrghtthgvrhhnpeevhfduuefhueektdefkedvgfekgfekffegvdetffehfefhffejhfehveevudeigfenucffohhmrghinheplhhinhhugihtvghsthhinhhgrdhorhhgnecukfhppedutddrudelkedrvddvrddufeegnecurfgrrhgrmhephhgvlhhopehrsghtrgdqmhhskhdqlhhtqddutdeitdeivddrrghsthhrrghlihhnuhigrdhruhdpihhnvghtpedutddrudelkedrvddvrddufeegmeefheeifeekpdhmrghilhhfrhhomheprggsvghlohhvrgesrghsthhrrghlihhnuhigrdhruhdpnhgspghrtghpthhtohepudehpdhrtghpthhtohepmhgriieskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprggsvghlohhvrgesrghsthhrrghlihhnuhigrdhruhdprhgtphhtthhopeholhhivhgvrhdruhhpthhonheslhhinhhugidruggvvhdprhgtphhtthhopehjrghmvghsrdhmohhrshgvsegrrhhmrdgtohhmpdhrtghpthhtohepshhuiihukhhirdhpohhulhhoshgvsegrrh
 hmrdgtohhmpdhrtghpthhtohephihuiigvnhhghhhuiheshhhurgifvghirdgtohhmpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopeifihhllheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhgrthhtrdgvvhgrnhhssegrrhhmrdgtohhmpdhrtghpthhtoheptghhrhhishhtohhffhgvrhdruggrlhhlsehlihhnrghrohdrohhrghdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehkvhhmrghrmheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlvhgtqdhprhhojhgvtghtsehlihhnuhigthgvshhtihhnghdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghenucffrhdrhggvsgcutehnthhishhprghmmecunecuvfgrghhsme
X-DrWeb-SpamVersion: Dr.Web Antispam 1.0.7.202406240#1725640479#02
X-AntiVirus: Checked by Dr.Web [MailD: 11.1.19.2307031128, SE: 11.1.12.2210241838, Core engine: 7.00.65.05230, Virus records: 12165305, Updated: 2024-Sep-09 08:42:30 UTC]

ESR_ELx_EC_IABT_LOW << ESR_ELx_EC_SHIFT = 0x20 << 26.
ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT = 0x21 << 26.
There operations' results are int with 1 in 32th bit.
While casting these values into u64 (esr is u64) 1
fills 32 highest bits.

Add explicit casting to prevent it.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: aa8eff9bfbd5 ("arm64: KVM: fault injection into a guest")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
---
 arch/arm64/kvm/inject_fault.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e..b6b2cfff6629 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -74,9 +74,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	 * an AArch32 fault, it means we managed to trap an EL0 fault.
 	 */
 	if (is_aarch32 || (cpsr & PSR_MODE_MASK) == PSR_MODE_EL0t)
-		esr |= (ESR_ELx_EC_IABT_LOW << ESR_ELx_EC_SHIFT);
+		esr |= ((u64)ESR_ELx_EC_IABT_LOW << ESR_ELx_EC_SHIFT);
 	else
-		esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
+		esr |= ((u64)ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
 
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
-- 
2.30.2

