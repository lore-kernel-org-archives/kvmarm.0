Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7087C3D8117
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147001; cv=none; b=JEIJs/8m4o8D8AsVIKKrxsNkkgCdx7U7T+l0Bvn08g6iM8m4Qh4FH/a8Pyl8NF0xBVzv/BBhCtoqkh/K7BcctKf2y0qATrOa2pMjLW51JMsjlYOlQoRqLWSGJ2y6AHKLzGRaDPsnE4bz1ZlYvCpj8MOKSqj0x3yin6rl8Owm6fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147001; c=relaxed/simple;
	bh=RTITKTt8/00tVHzHX3kJ0PB866gXj1ZVjWj6O0grKkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tZeM5NvyrL/jIclfJac6AbR4VZRVjnYtz66FUBnlNZRDtGzOJf1CZJuty8k6uUdXVuVvbngdhELuC6cPVW1gM2UHpK4LdTvtXUHHUaEC6hS2Z02PGYwaQsMYfpikuC05QKr1PtaAWJ1T6yq2Cfc1Tg1HGRTlUzi7Av9IQBHvzs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o2Gmx3mA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o2Gmx3mA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48542d5aa9eso5894415e9.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146997; x=1773751797; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VEWbELOsDpdm123yqs/nC4AQmYY2qHXqVI/qysPxPqQ=;
        b=o2Gmx3mAw+oMFLBecbVthKL2ts5K7dAZzNbC3DGEIPPOcM0hBp7+djCkPTiQuw00gm
         0SURtAf07WpE2x7PVSneF/JSTf+A17HnjsiZw9LARIv5kOY7jrT33XFMKW9uKD2dE17q
         r+Uqrf/0GMlz7n1oYCQ+saZEIIa+yovcRGyJ0ecBVzxq+bSVpNcICbFd+NpAuzV/0Ux7
         iDeFVjC3puZK5XnROOnPD0tvufX+jZdVUAjzMmtZ7Y8TBfB9xZeQI7R0A7WWULIH04gY
         qRYa12vRczJRW2RznfilLXyzs8C5l1URaNqxMMlPFdoGe8wgSMMA2BgeeLjOfT+dIIib
         N4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146997; x=1773751797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VEWbELOsDpdm123yqs/nC4AQmYY2qHXqVI/qysPxPqQ=;
        b=fyvpeU2+6zS4B5AmEH6mUpgQS5I+DqqTwIL6LsNdplGet9o6KZzR5J2G0TZqyjzpj9
         94KJ/VHnlII7lyfCsKdG/nSPZwXgzChVwiBiHDI+IEUmIGKYWZU1UFesOB9ZYH8ICd88
         FrgDNJDHrJh9b8LRLDrsMKMTMnoDFJ+KWU2bnAmhQhfqSHSTj4zBDzCkHftir6r0UG6G
         J8jwdLwGKW0pO0fvNfUjar1eCYJSzZHD8HGBGWOTRrzVjnVuquI1qF6Maj3ZNepuSaYK
         s4z6lfMPUbWQJrXwaXxtOQZoaRidbhOJdmYumEi9XStBw7bgrTX+lKM5/GqdibeSesnF
         +SCg==
X-Forwarded-Encrypted: i=1; AJvYcCXQuvScfr5QqYRdzVEBWVT2qo9tNOAD0/7LlJnlHdKE41iv5YTAdYdnnr6F3G4ICSXNtTLhZs0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5m8Y5mw8XEsFuwFJ8ZvCHZTKeyS9ggdNWBRojb+cEK+Yezs/w
	xW0+TB0oD0t3rVogqgYkzejLx5PJPYm0ZkJkCbOdtne6uBpUNxfBzmaHRuszRYs6HnRdEM0CQ75
	dLUh4K2HTYDXqg3BubUY9/f3Y1vf4tQ==
X-Received: from wmpj41.prod.google.com ([2002:a05:600c:48a9:b0:485:3a2f:2f7e])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46cb:b0:485:3dfc:57c with SMTP id 5b1f17b1804b1-4853dfc073cmr92510315e9.21.1773146996957;
 Tue, 10 Mar 2026 05:49:56 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:31 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-13-sebastianene@google.com>
Subject: [PATCH 12/14] KVM: arm64: Restrict host updates to GITS_CBASER
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

Prevent the host from updating the ITS command queue base address
(GITS_CBASER) while the ITS is enabled or not in a quiescent state.
This enforcement prevents unpredictable hardware behavior and ensures
the host cannot update the hardware with a new queue address behind the
hypervisor's back, which would bypass the command queue shadowing
mechanism.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 539d2ee3b58e..9715f15cd432 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -291,6 +291,30 @@ static void ctlr_write(struct its_priv_state *its, u64 offset, u64 value)
 	writeq_relaxed(value, its->base + GITS_CTLR);
 }
 
+static void cbaser_write(struct its_priv_state *its, u64 offset, u64 value)
+{
+	u64 ctlr = readq_relaxed(its->base + GITS_CTLR);
+	int num_pages;
+
+	if ((ctlr & GITS_CTLR_ENABLE) ||
+	    !(ctlr & GITS_CTLR_QUIESCENT))
+		return;
+
+	num_pages = its->shadow->cmdq_len / SZ_4K;
+	value &= ~GENMASK(7, 0) | ~GENMASK_ULL(51, 12);
+
+	value |= (num_pages - 1) & GENMASK(7, 0);
+	value |= __hyp_pa(its->cmd_hyp_base) & GENMASK_ULL(51, 12);
+
+	its->cmd_host_cwriter = its->cmd_host_base;
+	writeq_relaxed(value, its->base + GITS_CBASER);
+}
+
+static void cbaser_read(struct its_priv_state *its, u64 offset, u64 *read)
+{
+	*read = readq_relaxed(its->base + GITS_CBASER);
+}
+
 #define ITS_HANDLER(off, sz, write_cb, read_cb)	\
 {							\
 	.offset = (off),				\
@@ -302,6 +326,7 @@ static void ctlr_write(struct its_priv_state *its, u64 offset, u64 value)
 static struct its_handler its_handlers[] = {
 	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
 	ITS_HANDLER(GITS_CTLR, sizeof(u64), ctlr_write, ctlr_read),
+	ITS_HANDLER(GITS_CBASER, sizeof(u64), cbaser_write, cbaser_read),
 	{},
 };
 
-- 
2.53.0.473.g4a7958ca14-goog

