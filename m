Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801189;
	b=j0L7Hf5e2pvOBpWoyt3z0C/6O6S71ZlGF1JtlYMlGdqzL7s1/PaC0keJlWq0JBk9q3G3
	 PlMFOL4kaHeRkrI0BBhtkKw/AmcRyLQBFTZ7Z6BfyzxjCJmqieXb79LnX3ujI6+bD/SoC
	 j/8d+5qvJxyrjUQ30Oadzjd8VgulDlNTeWavME/bfhoOkvZ2cV7skm/B1DNt2RIjl8J+f
	 GvuvjXSzjUP2XhqFjAOvNRX9IDtW2ShMBrUomf9cukHG1FsZJAhSFGnsfHWfLV+cXYGjY
	 t10tfzbpQxnPFuPTgU0MsnH4thb2vewx8+s/0Mn8J501UL6WdQlwyB9B/PkJGwvPeaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=/BSvWpOJsi3sveNpByUAOa/5y9WQoQ7F5yD2zRlMNBI=;
	b=Dqj8Rv/zPire5o3ptOiPGw0FBRueZbsUwvGB5npENbu7C0xWukau1nq13xgV0VUN3igB
	 naAs12tAQjxd59lH4rodP4In8BWJpybuyQ5onD8QsFrHUC3SDg7g49zC1P44uZ12xGTtx
	 h9VPCkNJNO5dsQ70vyfhHj+SGIAq1MpgXvzAlsMMsM+6tkmNpN9quxZt7Y9ysLdYgvmij
	 YeS+TP4eNEsdYVqUbbBM0MgJyD/eKOw6xX5windhz6i2GnjcLrWzPofLmsuIE/3u+rjoq
	 Z1bZYF1lBp88Yw42RRpap1KK+aLfVlWYO5jCL0If/mAVUt7MlInDslCFjUvtn0ApZhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="VP7/uxFK";
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAFF606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 14:06:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAAFF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VP7/uxFK
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a70b42bab0so11271865e9.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 06:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793801187; x=1794405987; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/BSvWpOJsi3sveNpByUAOa/5y9WQoQ7F5yD2zRlMNBI=;
        b=VP7/uxFKFrkc7UEOurpggl0ZJJ6BCYmCBXiozkWBHJpBwQk/Ose5Bxl0BCHUiQB7Ei
         0NyX1wd/r2z4vYN48T8B9fh+SB+gGi7Pc3G5QWnfcwuG7+7Z5EnMdrE7agYpwn76AQH3
         VrzHQwOMXqzmjpik8FBYloXwaodLZQz5F/f60vBY+U3jnOMW1HPnEEYH87hlkXqgisfE
         E+2rMrg5YhD6A0gCoaig+BPjJOBZq/FGqRzcOBbwufJ6lDx0wuH06mfg/pW/Qp26aH+u
         qq8Hnh7WB8vYaWllRhXBOIVske3AnJmubJnOCtYHJcQwVFZO3OvSDjgDe3aKGIZj4onf
         Z5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801187; x=1794405987;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/BSvWpOJsi3sveNpByUAOa/5y9WQoQ7F5yD2zRlMNBI=;
        b=CtAoAg3VGwxkuYr9LPrCn9hOkJ6EWZLHrqyuGP5Y231FZCP3xM4o9x2nZQmQc+1X2K
         zUmCRpeHk74hnDuVxg9JvjWROdcbc8MwyYQ3hrRpTo3tcxwz8j+wuZBTamyYXS6T8Xjl
         tSOPPDyc8h5OVxeXOjNDGw64qHSbIgDTIJrIUXYmLqlIS3ZIHauo8NSeuxehdwZeQsXg
         BfPHLiFQb6h8gX6YR92y3cl33drt2RH1qRwntedMpHqp3YCwzVdW6zsTGuMb+dp6Z0RH
         tsa7aEBXG3bTlzatWNvC2R9X0ec8EpibRkHOTuwGHEKVNsv3izThT8j/AWtrOP7cX3Ig
         CPQA==
X-Forwarded-Encrypted: i=1; AKwUvBwjiguZfqBHbrwo/ndOc3ctESn9IZ/2jqHe0ARxL+6yfzbkh1XJNn4Hxkb9UvK+z46ag8GIsnw=@lists.linux.dev
X-Gm-Message-State: APuU4Z9ipNTZBU929+jo6Idtb66kQxBIqTXL1SioKqG3SUwDgxX10eME
	+OF4xAu6lnUTEY+lEQ9DR9/Kf4v3vSbHXWBHQSco9zndd78ek0Jw8/ydIdgFrQIq1qEBTGhLQkg
	iKMfmrViMft8sbIqP+iNAUg==
X-Received: from wmpo21.prod.google.com ([2002:a05:600c:3395:b0:4a1:cf4b:72c2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b02:b0:4b4:a551:681a with SMTP id 5b1f17b1804b1-4b4a55168c2mr28580285e9.3.1793801186750;
 Wed, 04 Nov 2026 06:06:26 -0800 (PST)
Date: Wed,  4 Nov 2026 14:06:09 +0000
In-Reply-To: <20261104140612.137869-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261104140612.137869-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261104140612.137869-3-vdonnefort@google.com>
Subject: [PATCH v2 2/5] KVM: arm64: Use HYP_REASON_ERET_HOST on trace_hyp_exit
 from PSCI_CPU_ON
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The hyp_exit on PSCI_CPU_ON logs PSCI as a reason but really we eret to
the host. Use HYP_REASON_ERET_HOST instead.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index e20db999e328..48228991a7ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -213,7 +213,7 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
 
-	trace_hyp_exit(host_ctxt, HYP_REASON_PSCI);
+	trace_hyp_exit(host_ctxt, HYP_REASON_ERET_HOST);
 	__host_enter(host_ctxt);
 }
 
-- 
2.56.0.455.g6c5a503b38-goog

