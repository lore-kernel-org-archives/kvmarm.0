Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624536;
	b=y4y+OkCi04BM/WyzmUkdpUH4FIKES2wyu2O7zR79QQJN3JprboKwMvHiD2OZYy/US4dX
	 1iv3lV4+YM/j4smmagYeYT/bvH/6um3C6PBscn4is08XnvioRKFiGq/f+0/RsME4poHNs
	 MyuMELR7JD8M+HpAoEDk/AT/unIMmiX0oSrAKuXwcAgWldR3xNodbEyef/9ALSFnvNVqq
	 1DiZfmKXEGdi/z6nMbY8YBiDAmZKgNdKLqvmDoqhLCtveJHA8MISUwfGUAYiEBK8v0YFx
	 FvOVi2sUM75NFkBahaxR2csRTlcbXxUXfOyWPZJdEhrmbnTN+uO7J7ZARNXaFAE+eMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624536;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L806xsiGlwO13TAwrjN8i31kZe6YvPSlLcIj0vmc54w=;
	b=M5Jl8muL3OURgoUgKLEwYAmGYWAtGjX0KBXV9dgcivUfy+5j2ZgV06SgVRElmuDpmbjs
	 L6JpnvCG/Vm4QFvSMp2JjlsCYEY5811XRnuQhuL/g/U/4/cACnCwdXMsWnNkYBhmjrsSt
	 oTqYdMEE63TB+86OK/7s531Al0e2L49OznFy49S6TeySdQeLqtrb8hyceo8Y4bUnDfBsM
	 BZhYOZ8lqWILmtKcMC7bp/SU+GgvbcbdbLmABu4+N1GJhk8aS95+vtu/x+U9CAbwPW7YP
	 AZZ+aTqDmMP7sIdfGf6y9C/0Bd0JoX+v1rusjQb7pD5tSB9Lf/RcbdwuIeGgr8S6+Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TjAx56T7;
	arc=none smtp.remote-ip=91.218.175.8
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A18260A2605
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A18260A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TjAx56T7
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CBH6n7O8BP/HoFkIHe06UxiI77aEmPLQp99OnnXWeHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624533; v=1; x=1794229333;
 b=TjAx56T7pLXnuPa7R0RTirXIC9JVUa5pjHj0na8JD9eN/L8lGgpXvIVDx7vbE6wuCeX0Y67r
 sBTcJ3ODe9528XLhf/EkggfVJdLTpxNiFFdd6bRU4CH+fJi1wqTGNmOIfrg0grgZwfayhAi+dop
 b2gxLjHpwWRzIAKodRKg0Am0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a4c58a5f30d34fbb;
	Mon, 02 Nov 2026 13:02:13 +0000
X-Mizu-Trace-ID: a4c58a5f30d34fbb
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/13] irqchip/gic-v3-its: Compute the wait target under the ITS lock
Date: Mon,  2 Nov 2026 13:01:25 +0000
Message-ID: <20261102130133.3684226-6-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
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

its_wait_for_range_completion() converts the posted command pointer into
a queue offset against its->cmd_base, after the caller has dropped
its->lock. That's fine while cmd_base never changes, but the protected
KVM takeover in a later patch switches cmd_base to a copy of the queue
under the lock, and a wait racing with it would compute its target
against the wrong base.

Compute the offset in its_post_commands(), under the lock, and pass it
to the wait instead of the pointer.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 drivers/irqchip/irq-gic-v3-its.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 8cc1bd8e7835b..f06da58cccf3d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1144,13 +1144,13 @@ static struct its_cmd_block *its_allocate_entry(struct its_node *its)
 	return cmd;
 }
 
-static struct its_cmd_block *its_post_commands(struct its_node *its)
+static u64 its_post_commands(struct its_node *its)
 {
 	u64 wr = its_cmd_ptr_to_offset(its, its->cmd_write);
 
 	writel_relaxed(wr, its->base + GITS_CWRITER);
 
-	return its->cmd_write;
+	return wr;
 }
 
 static void its_flush_cmd(struct its_node *its, struct its_cmd_block *cmd)
@@ -1167,13 +1167,12 @@ static void its_flush_cmd(struct its_node *its, struct its_cmd_block *cmd)
 
 static int its_wait_for_range_completion(struct its_node *its,
 					 u64	prev_idx,
-					 struct its_cmd_block *to)
+					 u64	to_idx)
 {
-	u64 rd_idx, to_idx, linear_idx;
+	u64 rd_idx, linear_idx;
 	u32 count = 1000000;	/* 1s! */
 
 	/* Linearize to_idx if the command set has wrapped around */
-	to_idx = its_cmd_ptr_to_offset(its, to);
 	if (to_idx < prev_idx)
 		to_idx += ITS_CMD_QUEUE_SZ;
 
@@ -1216,10 +1215,10 @@ void name(struct its_node *its,						\
 	  buildtype builder,						\
 	  struct its_cmd_desc *desc)					\
 {									\
-	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;		\
+	struct its_cmd_block *cmd, *sync_cmd;				\
 	synctype *sync_obj;						\
 	unsigned long flags;						\
-	u64 rd_idx;							\
+	u64 rd_idx, wr_idx;						\
 									\
 	raw_spin_lock_irqsave(&its->lock, flags);			\
 									\
@@ -1242,10 +1241,10 @@ void name(struct its_node *its,						\
 									\
 post:									\
 	rd_idx = readl_relaxed(its->base + GITS_CREADR);		\
-	next_cmd = its_post_commands(its);				\
+	wr_idx = its_post_commands(its);				\
 	raw_spin_unlock_irqrestore(&its->lock, flags);			\
 									\
-	if (its_wait_for_range_completion(its, rd_idx, next_cmd))	\
+	if (its_wait_for_range_completion(its, rd_idx, wr_idx))		\
 		pr_err_ratelimited("ITS cmd %ps failed\n", builder);	\
 }
 
-- 
2.47.3

