Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0F047D92E
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121043; cv=none; b=uNY8jpfgcziOVkAMTnytZ3vqqqyOjeFa5JVIn+UdBqWxklBGFv6fSO//lOKUtos1CGx6L8NTiaKh6vAtJSnWXAlboX0dXUlsu/X0zpx55W5iBG163rss0BevqPB905crM4ayW2SehgI+Zo8tVipOp74FKyZ/x1J1YsPT3Gl2l9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121043; c=relaxed/simple;
	bh=evapBqF9fdH+H6PlBk1r5uqALms6dqHIsGbi9+k9YLk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CTWG+Oi20ms+5l/DnolVCc5IwOv74psN3UPP93gcjtmF6qBd6Zj5aTWcH8Rnh3rAtyJjJs002k4vfaa0NO75c2AYlqsfoEIxzsV2Q2/QVfxjUlMb5f++buqQV4Puaq6MnbLsj16JXxDC8qS9IvxF2YuTrAOyDChLlaLdx1cCnlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zpaszodb; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zpaszodb"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c206d40018aso169805566b.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121036; x=1786725836; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kTVefapbptpCkdGjL+1kDLjlNC/ag2PzDpk3DPL7XNw=;
        b=Zpaszodb1RI8nBME6jMS3deH74qsoXijkomGlhUpAEpcQKyvzKO9umuU87cGxdt7zv
         Xe/LBEJKspZieuyUBQVmb1QxJkLg3inOkuLZbNW3RdhFRuVKnWN0tvOoG9ZxkqCpDG/0
         UbDenk8UZByRZ2Sm5/dsccDD0qxOkaoMAQKasSX1v6dSbB/YZfOiMoqsXJVB3BESC2DN
         +XTgYojwP3J2jNg4HNQdSEwy4WmgY9mz8+1WQej38w9Axb+Si5yc8IR6qD4g3Tk7mhES
         wzGXi8YAc55oL4+U1BGmOR1EsGFVu++RTFGbIAaeI+apOaufyzA6xz8hObF0Gf59JGK0
         89gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121036; x=1786725836;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kTVefapbptpCkdGjL+1kDLjlNC/ag2PzDpk3DPL7XNw=;
        b=pVLa1i8qDS3iTXHT0JpztOwUuRqjgcZ5CaBXQ7FJm+NcQjbmn2z30KuL8ML/pKHTTU
         JrcDijfF9JhyfiXbCEJpYu40I1bW88NRHvqGVbwEaUR75EXcZeW4YmMJsQpGs++3/4MM
         k9t/G+jUzEQgXj8DPyIXplH4CdbWKDuSQj1a7odgO86rTQxWZMzcFAxpeTSr+7e6MnZR
         91kdorBb9Sb0lZCpL2t6nuXu9pOV2cPB9AzOJocLd7x+jwW80mwnwXip9dR8RvquWZso
         pyt1/qDJIOYPA4s+BfAFXq99aKpIstDtkaPM1W8gNjCE3K8wLJBj9gzMOuiJA+UHvhQI
         i+tg==
X-Gm-Message-State: AOJu0YwOfF6nX9UsSBqX1inTDX4SI3VmJbMh35kK+zPR6WJpuyEhlLz8
	OHobAn+mVOW5HCzVbaOTX8xU/dkd7ZPOqxchA3ascxIEUMu1rMnJ3a/TOrdffv9uZkv8lgbyqj0
	iUSiY3PLW9sDrwCVa+aksfEkvhFxM2g==
X-Received: from ejoz15.prod.google.com ([2002:a17:906:668f:b0:c12:533f:6b88])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:2ad4:b0:c20:61e0:e3ab with SMTP id a640c23a62f3a-c2061e10ffbmr524125066b.3.1786121036039;
 Fri, 07 Aug 2026 09:43:56 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:22 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-14-sebastianene@google.com>
Subject: [PATCH v2 12/13] KVM: arm64: Prevent the host from programming new
 GITS_BASER tables
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Don't allow the host to change the layout of the tables or to modify the
address programmed in the GITS_BASER registers to point to new tables
and bypass the sanitization.
Prevent the host from updating the ITS tables while the ITS is enabled
and the tables are set to prevent undefined behavior.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 44 +++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 97cfa31d90d1..82dc60dcde68 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -42,18 +42,23 @@ void its_emulate_forward_req(struct pkvm_protected_reg *region, u64 offset, bool
 struct its_handler {
 	u64	offset;
 	u8	access_size;
+	u8	num_registers;
 	void	(*write)(struct pkvm_protected_reg *region, u64 offset, u64 value);
 	void	(*read)(struct pkvm_protected_reg *region, u64 offset, u64 *read);
 };
 
-#define ITS_HANDLER(off, sz, write_cb, read_cb)		\
+#define ITS_HANDLER_REG_PAIR(off, sz, registers, write_cb, read_cb)	\
 {							\
 	.offset = (off),				\
 	.access_size = (sz),				\
+	.num_registers = (registers),			\
 	.write = (write_cb),				\
 	.read = (read_cb),				\
 }
 
+#define ITS_HANDLER(off, sz, write_cb, read_cb)		\
+	ITS_HANDLER_REG_PAIR(off, sz, 1, write_cb, read_cb)
+
 struct dte_entry {
 	u32	device_id;
 	u64	itt_pfn;
@@ -460,10 +465,42 @@ static void cbaser_read(struct pkvm_protected_reg *region, u64 offset, u64 *read
 	*read = readq_relaxed(its->base + GITS_CBASER);
 }
 
+static void baser_write(struct pkvm_protected_reg *region, u64 offset, u64 value)
+{
+	struct its_priv_state *its = region->priv;
+	u32 ctlr = readl_relaxed(its->base + GITS_CTLR);
+	int baser_idx;
+	u64 baser;
+
+	if ((ctlr & GITS_CTLR_ENABLE) || !(ctlr & GITS_CTLR_QUIESCENT))
+		return;
+
+	baser_idx = (offset - GITS_BASER) >> 3;
+	baser = its->host_state->tables[baser_idx].val;
+
+	/* Prevent if it tries to change from direct layout to indirect layout */
+	if ((value & GITS_BASER_INDIRECT) != (baser & GITS_BASER_INDIRECT))
+		return;
+
+	/* Don't allow the host to point to new tables or new attributes */
+	value &= ~(GENMASK_ULL(47, 12) | GENMASK_ULL(9, 0));
+	value |= (baser & GENMASK_ULL(47, 12)) | (baser & GENMASK_ULL(9, 0));
+
+	writeq_relaxed(value, its->base + offset);
+}
+
+static void baser_read(struct pkvm_protected_reg *region, u64 offset, u64 *read)
+{
+	struct its_priv_state *its = region->priv;
+	*read = readq_relaxed(its->base + offset);
+}
+
 static struct its_handler its_handlers[] = {
 	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
 	ITS_HANDLER(GITS_CTLR, sizeof(u32), ctlr_write, ctlr_read),
 	ITS_HANDLER(GITS_CBASER, sizeof(u64), cbaser_write, cbaser_read),
+
+	ITS_HANDLER_REG_PAIR(GITS_BASER, sizeof(u64), 8, baser_write, baser_read),
 	{},
 };
 
@@ -472,13 +509,14 @@ void pkvm_its_emulate_handler(struct pkvm_protected_reg *region, u64 offset, boo
 {
 	struct its_priv_state *priv = region->priv;
 	struct its_handler *reg_handler;
+	u64 end;
 
 	if (!priv || !IS_ALIGNED(offset, reg_size))
 		return;
 
 	for (reg_handler = its_handlers; reg_handler->access_size; reg_handler++) {
-		if (reg_handler->offset > offset ||
-		    reg_handler->offset + reg_handler->access_size <= offset)
+		end = reg_handler->offset + reg_handler->access_size * reg_handler->num_registers;
+		if (reg_handler->offset > offset || end <= offset)
 			continue;
 
 		if (reg_handler->access_size < reg_size)
-- 
2.55.0.654.g21b8a5bc05-goog

