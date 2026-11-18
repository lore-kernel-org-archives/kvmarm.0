Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015181;
	b=5DpuX+jR50dQgL1jxxc/bI2IQSAwvC4o3qESSA7Dtxwsu/XvKSdse/ygAt4L+AGavuvT
	 RBTltMfmqxliFPikjGZHe5zss+KE2xgPMh9vNYsOcEkCKOZbHVjA5JspJz4pRcAHIgPkN
	 jOPUvNhVhbfVPGRIxxKCdc2u5/vTZvglshdaU6S/ZHN6ylNAD8RYiv7z4x1W7sPkVTLgG
	 GLuyJ5ww42Og10KovlYdptb9wRrpyqv2uw1/dlWbkx2THhuONGiLyd/yyBZuciLrF8HTe
	 4hLThrUNCOoOSeNjcwArXNPzVPQnDMHMh3E02M4EYtI2fflwFsKlrNFb0YrEo3hRtLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015181;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4abZZAGFr+op4Fiin9qqMvU61lk2F4uPWmmjiHuLcbQ=;
	b=KQlHD+Uq7DbAH8HMwdpTTabR3/9Gg/LEV65QnnU1+ZYjP8zOoJlhqK3hxzhtDuCqhQwX
	 byJkvwDvhsoYCUzc02/3I4sXH3xtepJRZyG0H4LDBGk1cfR865q5CpSsHLrrXznBAfhSp
	 jf795KqKgE+21+MwJAKkso2/HvdxotaVv74H6uDpVBaSJwSTvFPAfHqTjcg0LUXvPqyLF
	 H2TVyXrg8XWiZPo5Jym/aCH9jWELHxuprAwqt6oGHZy2SQbNY8RZLA5G6IloUxkNjJ+b6
	 x773SynxMPqbLZ+PloXQHjRCH4Q2XSpCMQJkpF911FGDChGyuVhnklZvi9Dx+NZCicA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xKSb0yMy;
	arc=none smtp.remote-ip=95.215.58.227
Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3F4606A333
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD3F4606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xKSb0yMy
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=AgR9DTR2Y4DJllQF/5/cjrLNXKWsG0SIqMY2siOpC2M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015178; v=1; x=1795619978;
 b=xKSb0yMy4rDzsorbN5K8uw5G5Ki/2BIcjXZhP4T1iud4f7XIHrWONQYM6C1/SZBbOeUApbbm
 zYzPhmYs3W+EZAgHyOyLanZhr0EqVESo+2vlI4jJUEn4Tj9uDVbeTQAg7PvaSy3h8MTsvzU+xka
 i8mPaFJd6cuDBOvkwg8aDyPc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id dc4acb5ede39579a;
	Wed, 18 Nov 2026 15:19:38 +0000
X-Mizu-Trace-ID: dc4acb5ede39579a
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
Subject: [PATCH v4 05/13] irqchip/gic-v3-its: Compute the wait target under the ITS lock
Date: Wed, 18 Nov 2026 15:18:56 +0000
Message-ID: <20261118151904.4099560-6-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118151904.4099560-1-fuad.tabba@linux.dev>
References: <20261118151904.4099560-1-fuad.tabba@linux.dev>
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
its->lock. That's fine while cmd_base never changes, but the pKVM
takeover in a subsequent patch switches cmd_base to a copy of the queue
while the other CPUs are stopped, and a CPU stopped in the wait before
it has converted the pointer would compute its target against the wrong
base.

Compute the offset in its_post_commands(), under the lock, and pass it
to the wait instead of the pointer.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 drivers/irqchip/irq-gic-v3-its.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index bbfea565149bb..734fe4fb52bd6 100644
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

