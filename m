Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA073E8696
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146998; cv=none; b=LNEEqxcdoXkK1iPxaxK85lw4ZfnWltH/8V1qX5xrxqQ0I6EuW2XvIKweh9iOnuWiz2u/IRNcN+Fk+rm/vEtkgyYFZgIIwM8huVCWa/CrlrLGjG4i+eTHZYEskhcam5dmzEtsLnRr7bzjsm8mP3LOssOn9/RK0w6JAljYLcw/7FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146998; c=relaxed/simple;
	bh=LsNi7e8n3RFGuOzyrWgX5uI+Z/GYNBc3tYFBs+03ZZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JHeleHZY2fT4H8ZsHnIZXjZ24YgdRfJpYUyYevx/vf4O+mcTiW2edmvU5BjgoZ1eNjQQEH1w2FpSGMRZvZ1+WWcXMcJEwNWqTytEYzCt5COV2mX4n6vBC6eh5KuAuGjzgH/sSIiIuaQ2b0B7ubB6FDi8xFfc2VSex1FrKv8unPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gxxjW6+8; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gxxjW6+8"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6612922bf82so5439185a12.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146996; x=1773751796; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6R0MEPExNqGukuDQgEpxXtxN4aPLVf9h/otxBvo9VYk=;
        b=gxxjW6+8qeLfIMRQsicD3ByF9ijb3HQqPlQx6Z2GzWKd3lluOuaZqLTTXuS7KHo7mJ
         VxE8ZOGUbCIfn0HpB7/jX9jbUEZ0hKutyY0IZ3uDIuQlXr4KYxY9KEWPFqQjZrn3AnWM
         PLMS4lpzxS0sIA71ZqAlX4QZfEj9AoLr4M2X24SM7m0YlBYdae+11He07ie6M02Y0C+U
         BDywPRSx8eSuWqtwt3JFKPtbFhRPZTEXtQYg3kn7+guQadxluMkTLr7xozfkPPQPapyX
         qYpk3nPYO0pJY3MAv5ZScvKtU2XnQ1zc6s159kpo8ipHRYsUpGEW6nNUSgCLpSR9wb2x
         YwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146996; x=1773751796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6R0MEPExNqGukuDQgEpxXtxN4aPLVf9h/otxBvo9VYk=;
        b=nmHf00gAhxyLJ1tPLcQFgDdyK+sGbo4beYXC7f66NnRfy20f2rsb6PseRSPpDB4IPo
         bWYqo+XyAHkV+xyiG9QgnfwxvPUvQs+BZv53Y/ncMUftFbhbHZOqxykdOXlJ44z6Z4lL
         lkQX7AzR+7udJu6KKof1wP+42ypkquf2a+fJcF9GvZVkWNP7AevOgnfzeAdmWUW67yPG
         eCQ8jUI9mz+LhXeQQo+8+iw6hmA+DOxvpQNPgqreuoKM1YWvZw2EjqjmOO/1RfZgV3S9
         siVBU1/CJsWHs0SYn7J+OWra5UVIrUCLBDII0y2+JL42qktNjas4sm8ZU6D5/Z+I6yts
         5srg==
X-Forwarded-Encrypted: i=1; AJvYcCW8AKdy8wDcP0HBkxcd1RBGhSUB/T6kqQL23gfMQHYE5ufLj50+taXYndmkmUACwfEf0Wz28ls=@lists.linux.dev
X-Gm-Message-State: AOJu0YypyyB0x1HHFTtZ+zAEYj6JvYTa7ay6TtkC0A1lKQAybt8mPttY
	Yod6mS9INEdZtNT+C7WCWxd9uhCSrHoUFgR2mLYsfYDJPqd89ZxUFlvXGxFvG08z5dzGVZDZ4Ur
	a4e1pcVQtuD/q9e36W9TZr7A/+LncpQ==
X-Received: from edtb1.prod.google.com ([2002:aa7:c901:0:b0:662:85d8:35f8])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1463:b0:662:bd98:890a with SMTP id 4fb4d7f45d1cf-662bd988b1bmr1727440a12.25.1773146995409;
 Tue, 10 Mar 2026 05:49:55 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:30 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-12-sebastianene@google.com>
Subject: [PATCH 11/14] KVM: arm64: Restrict host updates to GITS_CTLR
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

Prevent unpredictable hardware behavior when the
host tries to enable the ITS while it is not in
quiescent state.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 4782a9a24caa..539d2ee3b58e 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -274,6 +274,23 @@ static void cwriter_read(struct its_priv_state *its, u64 offset, u64 *read)
 	*read = readq_relaxed(its->base + GITS_CWRITER);
 }
 
+static void ctlr_read(struct its_priv_state *its, u64 offset, u64 *read)
+{
+	*read = readq_relaxed(its->base + GITS_CTLR);
+}
+
+static void ctlr_write(struct its_priv_state *its, u64 offset, u64 value)
+{
+	u64 ctlr = readq_relaxed(its->base + GITS_CTLR);
+	bool is_quiescent = !!(ctlr & GITS_CTLR_QUIESCENT);
+	bool is_enabled = !!(ctlr & GITS_CTLR_ENABLE);
+
+	if (!is_enabled && (value & GITS_CTLR_ENABLE) && !is_quiescent)
+		return;
+
+	writeq_relaxed(value, its->base + GITS_CTLR);
+}
+
 #define ITS_HANDLER(off, sz, write_cb, read_cb)	\
 {							\
 	.offset = (off),				\
@@ -284,6 +301,7 @@ static void cwriter_read(struct its_priv_state *its, u64 offset, u64 *read)
 
 static struct its_handler its_handlers[] = {
 	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
+	ITS_HANDLER(GITS_CTLR, sizeof(u64), ctlr_write, ctlr_read),
 	{},
 };
 
-- 
2.53.0.473.g4a7958ca14-goog

