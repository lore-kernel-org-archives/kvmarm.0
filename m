Received: from out-253.mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DCA8483
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 19:17:27 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676142471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=766mrZzi9sUN8wUut4UfkASE1CblQP7qLoaZc+hbkSQ=;
	b=orIj2ZjLDRmk89H+pmowuTKeI9mErG0+7/RmDmNBtGGq6BrP/QMV1O/GGM7yxFVWIwLsw+
	ZZL+Bxs8VrKIwKOA0ujepp12fGGwurQ8xtc6Tsc8HFH9qH1ClKJiYCQkPtMH7DpHsjmCUL
	HUzbG2VwU2AyLj3qvzSwxP8ptzYgNxM=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Andre Przywara <andre.przywara@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: nv: Use reg_to_encoding() to get sysreg ID
Date: Sat, 11 Feb 2023 19:07:42 +0000
Message-Id: <20230211190742.49843-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Avoid open-coding and just use the helper to encode the ID from the
sysreg table entry.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Applies to github.com/oupton/linux kvm-arm64/nv-prefix

 arch/arm64/kvm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f7ec27c27a4f..315354d27978 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -26,8 +26,7 @@
 void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
-			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+	u32 id = reg_to_encoding(r);
 	u64 val, tmp;
 
 	val = p->regval;
-- 
2.39.1.581.gbfd45094c4-goog

