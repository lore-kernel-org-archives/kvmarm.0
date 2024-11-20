Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C2033C5
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732100005; cv=none; b=TKFcXOBjizYq+XDwG5A8SmSjPJTqBj/6mPbcDRPXVTKxJ4VfGO+NO3OLjMzxWrCwALOb7345GVuWoBNH5Pguvduz7HuA0+iPQ/vPZpb7JoR4Ljbby8MMFWyXiS6q3dBqEu/KWASfI5p/y70XjVBX0hCTmYRjznWco8i53ULCyeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732100005; c=relaxed/simple;
	bh=oOXl5u7jr+6J/sjzfnKoMq8Idlb8ayeMeSby8soo/b0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ra4zPiKgMwaKdKBTeCuD53pjf9sH4qmQ5xk4yjlbgE3LLcFdLYdLL7oJnWdhTB9r9e2QovPzX/70UqIP5Yv7ku95SgAFS6qvd9+0b0qs6K5vFpkN145lv6PZxYcFRXtmbALiGDllAfwURNctna2IxYwJ7l5lo9Uvteu5Qzm1c90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M7xOxInB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M7xOxInB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43154a0886bso30534105e9.0
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732100002; x=1732704802; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f42/EUroZ+Ntky4r0huxue9aybFDac6HgHyBNdqjIFU=;
        b=M7xOxInBs0o+POgCBFgPytBOjFwadN7d9oNUzHbs0HRsmLHGr3xfUggKU+XBD/5iQp
         ZuaJkOyBVeEj8+4s3qQwTwFV1xEWOAHmAu7CP3RQFQ1cFF01CNpv7j/GLwJ98UjOOJ3h
         wBId7k0X8jpTC8g6Ew0TC/y1rzlVN8WwH///B/aky1w9l/wXrDtab6GeWqRjBKOHBH86
         ieXZBB2ZyV5ASj7ZUcL+5EmwRNahVk4kX9qcEyzDICCfFKpQDc6yJfg4hQifV80sNuov
         NBjJx8yPOcxFVh9ZTQb1IjUTLCYX9ZXquWrpgEYJ0MPh3LXUwtlrwjy5oaQlwr0or0uk
         3/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732100002; x=1732704802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f42/EUroZ+Ntky4r0huxue9aybFDac6HgHyBNdqjIFU=;
        b=UnAFRtcHjWhkWuwXGLcK0CDDoIKWRBnzKitDN8OoWsLV5FDrKy3z7lUZu45Nl3gY1B
         5SdTOyQUXlO7/8ypj9g+WrgdOqOtUT87xJxTNsv+jWK2w5dg0uXm+laa1AHImL82FuQw
         gaK2yGIEmWp5/4QRKd8eYkvdTrhzwuokHzInhAfTXD11xUCrJ2+RUOH7JIxEcNdlxHrN
         5iMqyvbcSFc+1LsO4/pPdUl22T5ryDQSbk9mgEQ5QAY0DZfSvRlkUM2pY6OlIFdwLlIG
         yUPf9Ca8yCI5O2uIN/k2CXhSM8+8iuI2hFj3JzLAlWV1HVnl5QhbPfTEYLLTldNHfL6n
         1puA==
X-Gm-Message-State: AOJu0Yz98FwSiuWYdjZHQ8h1XLHVx+hs021+6ewGX95hl9JUsQpg36iO
	AjFgP6gRIY0bF9xQmHzMdt705jkcHWmg+J3tQ2qskr0uHAQU1z6amjlez/Fql3F6cJqFeF498m9
	ou2wVxAc7CHGtnds3FVXb63yoUbdtEUECr82UDxQRSA5ZJeEjrdDlyX/UZwZl0uTmZMmxdETwW4
	VhlMFLtWF+fu3HVQxtIEgqVR9td0E=
X-Google-Smtp-Source: AGHT+IFPX6eRpgufFtGAE+RtbW0UGVjU2hx2f4BR3zFtKKVagI2hwWLt5wnkcg1+LlBATxzL0czObknczQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:cc8f:0:b0:42c:ae4e:a983 with SMTP id
 5b1f17b1804b1-4334f020b66mr8555e9.3.1732100002370; Wed, 20 Nov 2024 02:53:22
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:53 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-12-tabba@google.com>
Subject: [PATCH v1 11/12] KVM: arm64: Update vcpu state with live value of
 VBAR_EL1 on injecting an exception
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

If the injection happens early, when VBAR_EL1 has just been set,
it's value wouldn't be up to date in the vcpu structure,
resulting in it being clobbered before returning to the guest
with the injected exception, which the guest wouldn't be able to
handle properly. Although this probably means that the guest
cannot properly run, this behavior is unexpected and makes
debugging harder.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 17783c8ddb92..54f23d9fea18 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -250,6 +250,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
+	vcpu_write_sys_reg(vcpu, read_sysreg(VBAR_EL1), VBAR_EL1);
 
 	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
 
-- 
2.47.0.338.g60cca15819-goog

