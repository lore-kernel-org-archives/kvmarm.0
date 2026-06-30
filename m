Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4881E3F1640
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814894; cv=none; b=JFzmGWtyn4t3tGfucDJzx0BQbnbqoMB+psJVnyDQzxuerPBUoGWig8sj0bHcoV+2CpIPOvHSTRPG6TLnDgVrB90YlB1fRIiVfIyqaSeRT1fbI9Ts8LoPffSSjLM9yDIsr3Q4ct7Tt3pitwX31xE5I25ek1CY9qn58Wb4FUkwLAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814894; c=relaxed/simple;
	bh=mJH6zKl+wPnI8Gh9eK/dhD8a6MoXLFehdUoz/1vLpUI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KRzFgd9qJeva9MM1dwEsxVAbMDcSyK+zJ+14hZYks3qUPszuz5+dwiyZLkb/Jn+XfCLmVs91ZhkRxgFJMtLWKW4Az1ZVafsP1L+5rWJbyH6q/QS7qcgbZY+hhcjsJ/a9Yl3xwGtY7iWiQGii4oHmtR/r2TRhnhEDgI1mkHx72Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SNw2+iaL; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SNw2+iaL"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-492714d002cso16797845e9.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814892; x=1783419692; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b11GVtladPRwtAnrqyMBKjVI7QEbzNXpHeXS1BWCw8Q=;
        b=SNw2+iaLJsOiTKlVBxcpVEGLKS6vA73RXlTJARmVcuFNUivwwXH9yO0w4LTuCcb/9b
         tNtRtQa+0qlfoS6Qj4OOOgZ/Jv8MDg8LvA8uyeapzfTGnUEUI4+Fpa1moSBRL8DeRfhQ
         Iqp+pkIz+BTUiEduzFSu02ZPTIpEGx16baVHHSjAAt7c5BtgPvjGHkSQkzwDMZV1TzFV
         j6QNo620d0bs6X5ZXWDwpUmj7V9zQFyTG2hU45mcqQLcd7jyQezFfXZWFk8DBbJFHV8l
         +OoiSp6fXPDm70osd9a9rm9SlQRdAkJLKvcvU0mhznn7irJ7QSYbfRMsTER1DwF19w1P
         JMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814892; x=1783419692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b11GVtladPRwtAnrqyMBKjVI7QEbzNXpHeXS1BWCw8Q=;
        b=P+Qlj8D6W+QsqVwIkdsHQKPlopBzDas2UdWRyFy63iPD+WyQAHjYGvZ3NvI9sheDL4
         24U+yVUfeRvRHWPASoV7uDahQ+OABZd4uyLv73sO4BZdsNZbbeXG15p3M7VPF8CkHANq
         fcHsHV9YR4OXNKcTDGs4fP8vAsCIoqPGx5eTXrP3/4iQDC7zhmN4w33WR3kp8kjICXhf
         q1O1klVpP4lN5SGOGIYl1U5Zx0lyrgpj+HHQV5BgzjXRrvTEm8ErbM25veh/yWEgu3x3
         ieyKUdCLq8em0+VMxJBZxJQQV8vR7uiha5wlWZxswz9C1FZQisZUT6fU23VUV6ABZgvZ
         fE1g==
X-Forwarded-Encrypted: i=1; AFNElJ/8RrMSLaZpUEgeDpxHIQidQBYVtd3p2kEWaRZUNIoyvTBO9X0Z/z8dOXYFLVnNF1EdAt6zeOc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzmVw4U1TEo7Ye6FU0MAx1/JPiOv5YHRxYd/9w4+OXRMyvFHM0
	EEHhlNPiGBIyCYextmms6KmhRwCUi+nX9symHpeun5sKr0VgbG9mGo/sYgS8pWjh23rbxwBl/se
	OklhkG0GxLp9l+zZvAYkAdaDx31pfTw==
X-Received: from wrbdt17.prod.google.com ([2002:a05:6000:d11:b0:470:f736:b5d4])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a7b:cd15:0:b0:493:bd4f:510 with SMTP id 5b1f17b1804b1-493bd4f0530mr3477925e9.19.1782814891385;
 Tue, 30 Jun 2026 03:21:31 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:20:59 +0000
In-Reply-To: <20260630102058.3219867-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260630102058.3219867-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260630102058.3219867-8-sebastianene@google.com>
Subject: [PATCH v8 6/6] KVM: arm64: Zero out the stack initialized data in the
 FFA handler
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org
Cc: jens.wiklander@linaro.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, 
	sebastianene@google.com, seiden@linux.ibm.com, smostafa@google.com, 
	sumit.garg@kernel.org, suzuki.poulose@arm.com, vdonnefort@google.com, 
	yuzenghui@huawei.com, Sashiko AI <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Don't leak hypervisor stack data when using the FFA_VERSION call.
When the compiler doesn't support -ftrivial-auto-var-init=zero option
we need to zero out the stack initialized variable before returning data
to the host caller.

Closes:
https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.org/

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Fixes: c9c012625e12 ("KVM: arm64: Trap FFA_VERSION host call in pKVM")
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Link: https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.org/
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index bb01d8f83056..7407bc4b547a 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -881,7 +881,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
-	struct arm_smccc_1_2_regs res;
+	struct arm_smccc_1_2_regs res = {0};
 
 	/*
 	 * There's no way we can tell what a non-standard SMC call might
-- 
2.55.0.rc0.799.gd6f94ed593-goog

