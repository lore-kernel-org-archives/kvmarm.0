Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43D93BC674
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147001; cv=none; b=po60ky1QVlmpqrSTTYQ4/Ola/KJ3xgJu4s6PaUN4cV+glubzJDpgRwGO0iFMqYhfaiTScIj6bANr+1O3N9xdeDAM01Zc9yLTcl0DRXwUA1y/vidfBwiXmMiw/7ZrdqIic9qgRdtsHGuan8BKEl73KRydegasV/EdcOYdktfotyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147001; c=relaxed/simple;
	bh=dQXB6lQBS0QKJpL+HhStZfpp+h+pcXSATbZcztl2TJk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UE3RmDrGhjm//m0Jt8NSjd0sH77KqOzVLrTrY9/xH7zYunhRi+MXzs5AxLqmtqnRoS+CdAbKZxjsF5NHCLml0tLNjUi27Q3zla36cWjD+Dyg+nnijx0WsOJBsQITyiSe7DxdAWJ7OphP0goDXVQhFSWcF4uicmexkpszUu92ACk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yzyQYoK1; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yzyQYoK1"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-483786a09b1so16873455e9.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146998; x=1773751798; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ok3Trxc1drhi1LSuLE9o9e58C6eJmakQglQiNgbjypE=;
        b=yzyQYoK1lyGPyu+alIuqIeoKySKFuNhD0SxewXg8HR1X58wsq11u+OnkOAGHgUqSHw
         R1v1BALDelnF2Fwli/QfOTu/hbpwDjbTtddj6f3Tmdwhv7kZO8eAJFN8Rc9niiHqHQEN
         BmpJeDVh/sE16ptPj20da6rm1awiPC03m6IG+is1Qx1u/aZoI1Vpo9hdH4/QOlgHKptP
         fyFtI5Df9kYAMYcqGrjuLGgCeFX4ZFsScM49c+MmV740M2B/Jb0dBuzbToJJOpTcYAPD
         apZ2PvB/HrYkUMH6eomBY2PHK4yY6BAK7NKW1vGhQGT3pH6lIdCsKPAhnthzgh+kxx4z
         8lfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146998; x=1773751798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ok3Trxc1drhi1LSuLE9o9e58C6eJmakQglQiNgbjypE=;
        b=CjTbcXVq/Efguo6rfWz0bk58NTvokV+PzTtH6liqQKFZX7rBmFjsWBcO5By+5hxVc3
         nCHGiIiXLm6sCajfZa8l73F64clmENW1Fqc4dRT4Skcf5JHJjiOpi9ISeUHMnkA1dejh
         bIQJzPC4sfP/8keNsyU2TdfX4u+fvUQJDRnAb9EYiVbVk26OBEQj8yDPCxjvKe8Th5OD
         nE79ucV1GEPx+AnbhS83KKbRBxp9OeosXMnTcMPHNYWIhI0GQAD6FtIMpGZOlPT4c77r
         2M4do+ymnmcTsKE1Knt329SROr94PBox5CKMxHvJloKz2QjuDuAQoTw0piTvpmtj9w4G
         r//A==
X-Forwarded-Encrypted: i=1; AJvYcCU5OYB/9slnvTvLehnhPQSaWICXIdLHEYAUpJQ43Or+mLn+LbL+MGsy02Xrk4w8NJ4s3phgJhE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4F/mkJH2PegfAkP4J/dFFeU0RCahsdESiKTKPFfBkyf6EqmV/
	vDfK8JXLJpcP4kae3tGOSP/5a6nbL8SZYRA/MddO9SkcqFpuIX/qfpAkNBjtwg4zywt1bK1pUKh
	Y8nsPS1R8pYgBGNr8IrMGzsYuWOHrPw==
X-Received: from wrbeh2.prod.google.com ([2002:a05:6000:4102:b0:439:e77e:e4b4])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8708:b0:485:3a03:ceca with SMTP id 5b1f17b1804b1-4853c39afc4mr90731285e9.23.1773146998009;
 Tue, 10 Mar 2026 05:49:58 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:32 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-14-sebastianene@google.com>
Subject: [PATCH 13/14] KVM: arm64: Restrict host updates to GITS_BASER
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Prevent the host from updating the ITS tables while
the ITS is enabled and the tables are already set.
This enforcement prevents unpredictable hardware behavior
and ensures the host cannot update the hardware with
an unverified table address or size or change its layout.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 45 +++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 9715f15cd432..e4136a4a2ecb 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -22,6 +22,7 @@ struct its_priv_state {
 struct its_handler {
 	u64 offset;
 	u8 access_size;
+	u8 num_registers;
 	void (*write)(struct its_priv_state *its, u64 offset, u64 value);
 	void (*read)(struct its_priv_state *its, u64 offset, u64 *read);
 };
@@ -315,18 +316,48 @@ static void cbaser_read(struct its_priv_state *its, u64 offset, u64 *read)
 	*read = readq_relaxed(its->base + GITS_CBASER);
 }
 
-#define ITS_HANDLER(off, sz, write_cb, read_cb)	\
+static void baser_write(struct its_priv_state *its, u64 offset, u64 value)
+{
+	u64 baser, ctlr = readq_relaxed(its->base + GITS_CTLR);
+	int baser_idx;
+
+	if ((ctlr & GITS_CTLR_ENABLE) ||
+	    !(ctlr & GITS_CTLR_QUIESCENT))
+		return;
+
+	baser_idx = (offset - GITS_BASER) >> 3;
+	baser = its->shadow->tables[baser_idx].val;
+	if ((value & GITS_BASER_INDIRECT) != (baser & GITS_BASER_INDIRECT))
+		return;
+
+	value &= ~GENMASK(47, 12) | ~GENMASK(9, 0);
+	value |= (baser & GENMASK(47, 12)) | (baser & GENMASK(9, 0));
+
+	writeq_relaxed(value, its->base + offset);
+}
+
+static void baser_read(struct its_priv_state *its, u64 offset, u64 *read)
+{
+	*read = readq_relaxed(its->base + offset);
+}
+
+#define ITS_HANDLER(off, sz, num, write_cb, read_cb)	\
 {							\
 	.offset = (off),				\
 	.access_size = (sz),				\
+	.num_registers = (num),				\
 	.write = (write_cb),				\
 	.read = (read_cb),				\
 }
 
+#define ITS_REG(off, sz, write_cb, read_cb)	\
+	ITS_HANDLER(off, sz, 1, write_cb, read_cb)
+
 static struct its_handler its_handlers[] = {
-	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
-	ITS_HANDLER(GITS_CTLR, sizeof(u64), ctlr_write, ctlr_read),
-	ITS_HANDLER(GITS_CBASER, sizeof(u64), cbaser_write, cbaser_read),
+	ITS_REG(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
+	ITS_REG(GITS_CTLR, sizeof(u64), ctlr_write, ctlr_read),
+	ITS_REG(GITS_CBASER, sizeof(u64), cbaser_write, cbaser_read),
+	ITS_HANDLER(GITS_BASER, sizeof(u64), 8, baser_write, baser_read),
 	{},
 };
 
@@ -354,14 +385,16 @@ void pkvm_handle_gic_emulation(struct pkvm_protected_reg *region, u64 offset, bo
 	struct its_priv_state *its_priv = region->priv;
 	void __iomem *addr;
 	struct its_handler *reg_handler;
+	u64 end;
 
 	if (!its_priv)
 		return;
 
 	addr = its_priv->base + offset;
 	for (reg_handler = its_handlers; reg_handler->access_size; reg_handler++) {
-		if (reg_handler->offset > offset ||
-		    reg_handler->offset + reg_handler->access_size <= offset)
+		end = reg_handler->offset + reg_handler->access_size * reg_handler->num_registers;
+
+		if (reg_handler->offset > offset || end <= offset)
 			continue;
 
 		if (reg_handler->access_size & (reg_size - 1))
-- 
2.53.0.473.g4a7958ca14-goog

