Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618FC47CA65
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121041; cv=none; b=NSJSO4Upd35NkXxIi0z7tO2YYaLnSuSH5izvENSNAmxGwQnYRcXPZ0Tt3X1n+b4jm1b+o4bScauUdBVmBhE4HRuG0ECQ/8T8b1Pbi6b4s4ZiUSYyzDeqEa+N8Ahqw831kJ0kY+hf7Vvohpo19wft4B1F1ME20wnG1Wno5ikEWAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121041; c=relaxed/simple;
	bh=WJpZQ0SdOrH7RGvEvyDpMPhGUMqMI5kRtv8KfcRLpcY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cxEvXwbI8THv/27SJby64hBNHAURMIuOOFuzuToS6FH3OweIFSdXTkH0OTOimjdQWgsonvg8ynmibPDEJi+75PfhNVFR2urYhiJPrqP4NripLgJtkpMY5d4xzgvzaAFOL3Y0n0gL4T5/nCDs7NLmA9xNXpjRG/aRtBap75VXNBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cSMASzM7; arc=none smtp.client-ip=209.85.208.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cSMASzM7"
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39f44d8edb6so13439381fa.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121035; x=1786725835; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7TXLJIzu0sdUTbcYifBsweWW0qiwt6RC0AmUjCHWXcg=;
        b=cSMASzM7c0+uXiQdQIwGKmSqLxX+y+z1iqYNUhdrn0YfB7dL2nesWHWlGE6LvY6b+q
         tiM8MOc4o6I15qv2QA/eE3IbY6JhcW18N0mfFJntWW7wrNgiJdAAZ5z70ff5jhKNwvMX
         QfTajyIwdUhtacA3Gy+jmSwTjVZ3nHVHekE+9hqismQXTPx7DObzhtWPVtQV4/jOVogB
         da6OE+wfki/Qblm1kydfdlQNrRrX4N8lFWl1QfDJxwNWMQzEZes2I2MLPk8SV2SXqphm
         hc3HTasJEYgUTbNrvgqVlkM+ctXMRD+9/XVMPrdeqxNA8uHdgF7VvPEKQK3pF7INNMPs
         TLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121035; x=1786725835;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7TXLJIzu0sdUTbcYifBsweWW0qiwt6RC0AmUjCHWXcg=;
        b=PTmUXmwdni7t/sNy9KKJV0Zn0DQxd6M6pTZeiYxcsdpHcdwMTCHvUcbGn8brCAZ25+
         tUMCuJdjbRgMl8qaYeX7vKu/bx4sjfPdzjfV0LAuLZgVEkxuFb1hHS1+63I8M+RTp3gn
         3RKQLeUtKYqWhLBVUgSHUBuFb+orW/9Wq9XfLsgMOCq8jpsO6wGHC6R1jWRFnNASDMg2
         5Ufym+Xjt0q4GWrAM9yF7A19wSdI1BOkPqlk/x4q/AoDuVqhuf083Prmk/O28r+U6Uge
         CehVM/11nCMlj5yDjGXmXEyGTdNMCL+s2ax7/OhjVo8IziiHrC1svbqlsOTgSuejSuPo
         ZWdA==
X-Gm-Message-State: AOJu0YxsNFp9hzI1C8Dite86GQXL83viGS8cq+W4Bs8pshE/pQ7UbShb
	tUaRFtOTJnQ2CMdWObpaTT7/qgcQ/+rXdLWElC+uz1+avoWXHUUfqQcG4SHBSBoNeKj6iNGX9qs
	dWttqXdGuK0ynBTyF/Q+ZCJTb6Mxg1w==
X-Received: from ljik18.prod.google.com ([2002:a2e:8892:0:b0:397:f415:3317])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a2e:bc0d:0:b0:39b:f64:1af3 with SMTP id 38308e7fff4ca-39fe56728b1mr2004231fa.8.1786121034668;
 Fri, 07 Aug 2026 09:43:54 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:21 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-13-sebastianene@google.com>
Subject: [PATCH v2 11/13] KVM: arm64: Prevent the host from specifying a
 different command queue
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

Don't let a malicious host re-program the command queue register with a
different address and size to bypass the commands sanitization.
Prevent unpredictable hardware behavior and restrict updates to the
GITS_CBASER while the ITS is enabled or not in a quiescent state.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 32 +++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index b9b71aa18d48..97cfa31d90d1 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -429,9 +429,41 @@ static void ctlr_write(struct pkvm_protected_reg *region, u64 offset, u64 value)
 	writel_relaxed(value, its->base + GITS_CTLR);
 }
 
+static void cbaser_write(struct pkvm_protected_reg *region, u64 offset, u64 value)
+{
+	struct its_priv_state *its = region->priv;
+	int num_pages;
+	u64 ctlr;
+
+	ctlr = readl_relaxed(its->base + GITS_CTLR);
+	if ((ctlr & GITS_CTLR_ENABLE) || !(ctlr & GITS_CTLR_QUIESCENT))
+		return;
+
+	num_pages = its->host_state->cmdq_len / SZ_4K;
+
+	/* Don't let the host program a different command queue */
+	value &= ~(GENMASK(7, 0) | GENMASK_ULL(51, 12));
+	value |= (num_pages - 1) & GENMASK(7, 0);
+	value |= __hyp_pa(its->cmd_original) & GENMASK_ULL(51, 12);
+	its->needs_flush = (value & GITS_CBASER_SHAREABILITY_MASK) != GITS_CBASER_InnerShareable;
+
+	writeq_relaxed(value, its->base + GITS_CBASER);
+
+	/* Restart the CMDQ to read from 0 */
+	its->cmd_offset = 0;
+	writeq_relaxed(0, its->base + GITS_CWRITER);
+}
+
+static void cbaser_read(struct pkvm_protected_reg *region, u64 offset, u64 *read)
+{
+	struct its_priv_state *its = region->priv;
+	*read = readq_relaxed(its->base + GITS_CBASER);
+}
+
 static struct its_handler its_handlers[] = {
 	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
 	ITS_HANDLER(GITS_CTLR, sizeof(u32), ctlr_write, ctlr_read),
+	ITS_HANDLER(GITS_CBASER, sizeof(u64), cbaser_write, cbaser_read),
 	{},
 };
 
-- 
2.55.0.654.g21b8a5bc05-goog

