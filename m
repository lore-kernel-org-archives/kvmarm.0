Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFC1466B73
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707916; cv=none; b=FOYfYWhevRFfBgRk4z1kdm/5hkzSf4QfenZehss5MU0kPPRPy9Glreha74+gilHwoBYOPqq1sb5Ya88YmZHYfv2WCUtnYCpCDG0V8H2JDpDzuah1JuYF7vDSX1C6+P//4kb2f6UuOFaTii8rWbtv2bo3qZeuVjcAhkAoKxIO45A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707916; c=relaxed/simple;
	bh=ekF+EqAqxUIoNHacdJRxFOkqPmHLuXqzXJMGa52578E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cDEALruIsPTrlKnw2MXkPUys0yVZMqoOgXd4EFVOYEUEDLJw2qcov7PrLDniE7YQ2k5aPi3JNfzitK0oO44Gno0Gp+XlWg5j0DsTn/ggmm6z2zXMg7wuNNsr9O75ervbreNYdXJZL9f3iKVF2DR8KU8oNM9WwGKzfZ6KkRipijE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQxfYDCN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQxfYDCN"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b93debc8so56618515e9.1
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707913; x=1782312713; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y79oPW1dRkbvOFQ/8D6OY6Iq3f4xRjBQw7MgzYvcGaA=;
        b=CQxfYDCN/Lz5sw6FsU05ym1XJhOrC7BlVyQKmv473ZcH9sUTGE/NdnycfGsietiGcI
         kdSMOctoHWkNQEaI8chIQDOvfhT3SaSRhS19TO1DCRgipezNCKrm6FL2VNQjdEIcYjbN
         ZROcGRtSbH3exbtD9hQ7txOEj87vq9JzCDSIBjqS6cDAouJsiba91syUqC2eZEd7QxmU
         Kb2ABs+Qs5Xzs9HfXN55dqqguY92SCXbskBsGDDAvMMAKva3ZBIdHH4FNf3LCy52n1cu
         tsgdAHhQbOfOtdv0V/+V7UN8Uz07ceW5Af8Mqd/NpEj6sVZCJqvseqZUl3l0gf3Ioo5d
         Flxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707913; x=1782312713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y79oPW1dRkbvOFQ/8D6OY6Iq3f4xRjBQw7MgzYvcGaA=;
        b=NxcdgN3P33Ihxc6FS2a5XiQMoFoKfAyCrj3iNnXD/hjvz1MDqif6tUdLXPKTYA1TdX
         TMdqqq6yqGnCtnnM/eNvCNRfrHjTyiyARaA+h+SY1J3Qr/KrsuIa3zJVEyHTzLzulQpB
         CgsIQ7U/x3AJhNVSPiwF9FM7lvXnx2gaoSIpaP4b4VyQ5GELm2SPMzM1h9G9kp9oGZgg
         cw8qtEUZ170Xeh/yMZZwxZvzHKbMb5C/LY8ZIkFbPEIrbINafIh8AKlclegkjizIU50J
         uNu2wWOWtYPAl+Kr5eoeRZftAO3Nld9yvSj8G3J4ciuVbV+rWE7DXXK6+kz+6nQtPMOm
         Ncyw==
X-Forwarded-Encrypted: i=1; AFNElJ/zUTY9/Og2BX78c0ovUBzGNtNcYwFxrV1GRw4l+84NSwpsfbJbKaFizOsVN7uTdJbVIX2ABzM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8ai9mZZ4cu00WocthTeghXIMOmXcmU5yMDEau2Di8v7PgB6AC
	nG7X48a3ETwa2Mf7nWy2fQx7BT9Y3nUgoHRKZneRW/1+9PFPU1CBJq2Yy/RvMwcUpatC2iPadc3
	gScZNBLqcVhrHm4kwiA+VL9qWFdkbUw==
X-Received: from wmxb4-n2.prod.google.com ([2002:a05:600d:8444:20b0:490:4477:50d3])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4743:b0:492:1e36:bb03 with SMTP id 5b1f17b1804b1-492333f829dmr72605705e9.36.1781707912951;
 Wed, 17 Jun 2026 07:51:52 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:51:30 +0000
In-Reply-To: <20260617145130.3729015-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260617145130.3729015-1-sebastianene@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617145130.3729015-8-sebastianene@google.com>
Subject: [PATCH v7 7/7] KVM: arm64: Zero out the stack initialized data in the
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

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes:
https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.org/
Fixes: c9c012625e12 ("KVM: arm64: Trap FFA_VERSION host call in pKVM")
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index d7c5701d0584..b321682ead04 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -883,7 +883,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
-	struct arm_smccc_1_2_regs res;
+	struct arm_smccc_1_2_regs res = {0};
 
 	/*
 	 * There's no way we can tell what a non-standard SMC call might
-- 
2.54.0.1136.gdb2ca164c4-goog

