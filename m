Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B95824677B
	for <kvmarm@lists.linux.dev>; Sat, 28 Mar 2026 05:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675937; cv=none; b=ivyeBnPzRdGbHWVcM1/yx/c+KdNrqMG/TajavbqvmeSFRuwgWjyY9ATq0JH6HK1pCPVr4Q8GtdOaPy8lc1SsWyrd8y0z6yVUyWRHVRi6d1UmENNV0kTPFoNXA+qv6uZLXm9uTGm8W2whr7JlOs/uBKY8kmYZDk2LvRm+JzHVDFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675937; c=relaxed/simple;
	bh=p6lz8//QcBPyGWeIMhackmvndYzCYQ4x4eCh5/dmWP8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SI9TGdtcHbZasNyU75sHUb0Mjzxad8+Xqj42QIpZY4USg79g8+S5aAYyj8UQDCyjaAxjgOCutN8tqy2hatDtq2CtpdAmRRGoCzLJzW1snuNApJuN8+STPMvn6dq1LLKYGA1sUwEnAuszPZChAh3K//QmtzpS2LsntuhgFggtqJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LiNvA6Gv; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LiNvA6Gv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774675932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zOJ9iIsuZvHL5cyLqdAmY9/F0c2z+tYW7wmPGa32F7A=;
	b=LiNvA6Gv9B9EL4M01WVY9OIl4HG+G7cPdHPvRKnlGleR/TB3rZQ3i3HILU6oWbDiumeg2q
	LFs98nuOGnPNP8afIRjenAYkQQAagYf8kpOdxwbTk1NJZk3oNlYk5VzL+iBneaoCBJ1Dj0
	iyFmCK/OGLBW5mqJVrYyqbFVZF2oazI=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] KVM: arm64: ptdump: Initialize parser_state before pgtable walk
Date: Sat, 28 Mar 2026 13:31:55 +0800
Message-ID: <20260328053155.12219-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

If we go through the "need a bigger buffer" path in seq_read_iter(), which
is likely to happen as we're dumping page tables, we will pass the
populated-by-last-run st::parser_state to
kvm_pgtable_walk()/kvm_ptdump_visitor(). As a result, the output of
stage2_page_tables on my box looks like

0x0000000240000000-0x0000000000000000   17179869175G 1
0x0000000000000000-0x0000000000200000           2M 2   R   px ux  AF BLK
0x0000000000200000-0x0000000040000000        1022M 2
0x0000000040000000-0x0000000040200000           2M 2   R W PXNUXN AF BLK
[...]

Fix it by always initializing st::parser_state before starting a new
pgtable walk.

Besides, remove st::range as it's not used by note_page(); remove the
explicit initialization of parser_state::start_address as it will be
initialized in note_page() anyway.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/kvm/ptdump.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 6a8836207a79..5dfd526c6dc9 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -22,7 +22,6 @@ struct kvm_ptdump_guest_state {
 	struct ptdump_pg_state	parser_state;
 	struct addr_marker	ipa_marker[MARKERS_LEN];
 	struct ptdump_pg_level	level[KVM_PGTABLE_MAX_LEVELS];
-	struct ptdump_range	range[MARKERS_LEN];
 };
 
 static const struct ptdump_prot_bits stage2_pte_bits[] = {
@@ -131,16 +130,7 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
 
 	st->ipa_marker[0].name		= "Guest IPA";
 	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
-	st->range[0].end		= BIT(pgtable->ia_bits);
-
 	st->kvm				= kvm;
-	st->parser_state = (struct ptdump_pg_state) {
-		.marker		= &st->ipa_marker[0],
-		.level		= -1,
-		.pg_level	= &st->level[0],
-		.ptdump.range	= &st->range[0],
-		.start_address	= 0,
-	};
 
 	return st;
 }
@@ -151,14 +141,18 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 	struct kvm_ptdump_guest_state *st = m->private;
 	struct kvm *kvm = st->kvm;
 	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
-	struct ptdump_pg_state *parser_state = &st->parser_state;
 	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
 		.cb	= kvm_ptdump_visitor,
-		.arg	= parser_state,
+		.arg	= &st->parser_state,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
 
-	parser_state->seq = m;
+	st->parser_state = (struct ptdump_pg_state) {
+		.marker		= &st->ipa_marker[0],
+		.level		= -1,
+		.pg_level	= &st->level[0],
+		.seq		= m,
+	};
 
 	write_lock(&kvm->mmu_lock);
 	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
-- 
2.53.0

