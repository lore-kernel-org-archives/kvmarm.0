Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4257147ACE0
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121038; cv=none; b=TJPpwYmSrZt9x7FbcXyTOdBt/qls3hOjvD7PeMxJJboESUcLzmM/oSgluTqXu09v065N6UVQSpS0kpL7gr0M6WbTa0+fO9JJ7QxEXz4MEW89JYR0Gdufl9U9fW1mr7qp7uMKYALQ9cKSIGr9DEaYjhPijCcZ/PXNVFO6AqIstC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121038; c=relaxed/simple;
	bh=STYl0ghz5J/YkTbmptnKIYNWYygu2v7YgYHI7YW7274=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=phbE8vz7V1GRPSDPwh0NsGvW3bQPSnyjGrRK+5Dvgp/ivqVjvm8gjhX73lmHvB5B+YEK8uPaMif6GTIWqmdSBQsQGz3koX3HuHVgTVjSO10up36TG66qLjQBH/nTdSrdzFffwybw1T6xnOl/81dXniALRraoVw/g7A9B1mdwMfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IsQGPit3; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IsQGPit3"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49571407d1dso22488775e9.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121033; x=1786725833; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pEop5HcfowkDeNq3FT2Q1c6RiGCFxpFvlXH/k0dA9E8=;
        b=IsQGPit3Tn1KAYQizfwwfVPAvJz6+Q6cOdrY2CFjZltXcR2YNK9El2O5qnYLG+yZCW
         oGKRqOSP8dY8YUR9Im/mbgm81Kv9QIyt6C+neM0GEu4j7XrDqbw18pkNEjUOYBJbE8Cf
         0lhal4IY8NoBw/m3CJXDngG5pEycw6ISvgnPVkiP6zvS0jv/oViu2BxQHljkoXvSDRPT
         4hDkt9bFWdEu304XYywPUD0ehHmMP1rADc4KyD2GyiFxN28vGqd92gaCAJtcH3VotJ25
         LkF+LYV+5+G0QqcXp2I7sbD5/2gWVPqQoaJmXIoiv3eX3FFHJaQjd7hALQc7HqPLB3/7
         PiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121033; x=1786725833;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pEop5HcfowkDeNq3FT2Q1c6RiGCFxpFvlXH/k0dA9E8=;
        b=jY6Vjm/+H0esy+gTywjSeIfJGrRp/Mesik8/Zfxwd6I93+qImzskPIIS4gzyVpEAHB
         r0l+4a55nOEUB3dQIKaiqt9nEaMs1f+KSuUQQ6nDHe8hiWB95i8qKPH6pI2U28eePRBD
         Gk/rPkwkh7tZpWk1ulNh8OqR2ZcOeG4wZbRJe1oU+8h/amhhljxDiTK9eClp9sVmby9I
         UJFWSmnf3PeAYRIHkjt+0dle6JuK/yKx8O5n99nC8zRt3Dqi0jZuOMWyNPY+8OTB/pRW
         ZFDjTdyMDH7lss1DQvV9IUmDJCNAHa5Q1LagSdoGRMSoAyQ7KJ8RttuH0tX/OT1hALN1
         QNsQ==
X-Gm-Message-State: AOJu0YxbwfYEW+0kVo9+e9tekXftgTN7C9/bFuHg438JQV9K8ezV93xN
	hrKAwgILQbaRMKoLEbL71FgmIRZCq4+ydl9gTkdE+MOC1D0Iumqj/p2p5J2iCg7MD2yKnO8KZc7
	ujCISBIWPC0UZRLZr/dAyUrevDTbecw==
X-Received: from wmbhi12.prod.google.com ([2002:a05:600c:534c:b0:498:124b:1aa0])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:2e54:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-4994e7c1445mr233498895e9.10.1786121033123;
 Fri, 07 Aug 2026 09:43:53 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:20 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-12-sebastianene@google.com>
Subject: [PATCH v2 10/13] KVM: arm64: Restrict host updates to GITS_CTLR
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

Prevent unpredictable hardware behavior when the host tries to enable
the ITS while it is not in quiescent state.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 5629e2a070df..b9b71aa18d48 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -403,8 +403,35 @@ static void cwriter_read(struct pkvm_protected_reg *region, u64 offset, u64 *rea
 	*read = readq_relaxed(its->base + GITS_CWRITER);
 }
 
+static void ctlr_read(struct pkvm_protected_reg *region, u64 offset, u64 *read)
+{
+	struct its_priv_state *its = region->priv;
+	*read = readl_relaxed(its->base + GITS_CTLR);
+}
+
+static void ctlr_write(struct pkvm_protected_reg *region, u64 offset, u64 value)
+{
+	struct its_priv_state *its = region->priv;
+	bool is_quiescent, is_enabled;
+	u32 ctlr;
+
+	ctlr = readl_relaxed(its->base + GITS_CTLR);
+	is_quiescent = !!(ctlr & GITS_CTLR_QUIESCENT);
+	is_enabled = !!(ctlr & GITS_CTLR_ENABLE);
+
+	/*
+	 * If it's disabled and not in quiescent state and it tries to enable
+	 * it, bail out.
+	 */
+	if (!is_enabled && (value & GITS_CTLR_ENABLE) && !is_quiescent)
+		return;
+
+	writel_relaxed(value, its->base + GITS_CTLR);
+}
+
 static struct its_handler its_handlers[] = {
 	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
+	ITS_HANDLER(GITS_CTLR, sizeof(u32), ctlr_write, ctlr_read),
 	{},
 };
 
-- 
2.55.0.654.g21b8a5bc05-goog

