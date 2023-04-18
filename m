Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07441C94A
	for <kvmarm@lists.linux.dev>; Tue, 18 Apr 2023 21:55:29 +0000 (UTC)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id otAtpDm3iuZFDotAtp5a56; Tue, 18 Apr 2023 23:47:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.fr;
	s=t20230301; t=1681854468;
	bh=cZSjVGZIUlYLIpCjOhOc0/Sg4X8Jz8GjKGH9/AcwNB8=;
	h=From:To:Cc:Subject:Date;
	b=Q6sEsKrhFoWuQ2stk0aG1FI8wza6+Ha+g2auGJtsu7dzre1BbLJ1BwVUEsdiO3oy8
	 hkFnkBWD81hqEJSpcCf/Y3FELHW2dvuqNhnVLBXIJhGCPv1tNlPHMLFh/4Oq7n5oDE
	 9Qou5ArgKmLeqQEbtYU4G2HEZLKNBL2GWvX8TjEQeUkcpHgiHOzRVj5ldEWdQUMjM6
	 yBVUKNq/3KNbqsbG2n0sayi81o6SuZ+XjpaYKr4yiyrUgA5sFgS3ZogzycHVDT2TpO
	 MSqgqgujgmvJ5yGgz9f4CS6HMJRxRg2z6gtQvBnEkLiOfyjiQdFItvFhgOs+U4O/18
	 iF95AxOOP6wgA==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 18 Apr 2023 23:47:48 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 1/2] KVM: arm64: Slightly optimize flush_context()
Date: Tue, 18 Apr 2023 23:47:37 +0200
Message-Id: <97bf2743f3a302b3066aced02218b9da60690dd3.1681854412.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bitmap_zero() is faster than bitmap_clear(), so use it to save a few
cycles.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 arch/arm64/kvm/vmid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index 08978d0672e7..bbf0677cfefa 100644
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -47,7 +47,7 @@ static void flush_context(void)
 	int cpu;
 	u64 vmid;
 
-	bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
+	bitmap_zero(vmid_map, NUM_USER_VMIDS);
 
 	for_each_possible_cpu(cpu) {
 		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
-- 
2.34.1

