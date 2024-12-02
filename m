Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D7C136352
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154489; cv=none; b=ZJWe7wRzPmKZYOAkLHsz14VQbRMsAqKrB+7kYnlCHElNLy/vTcnhdZlnBxYy5FNfgQWNiHmjkZnyjb2QUxcY43qjfrilTyLJs1gCllX+sb0en+P6SVuAq9j2GS0NW6uv3+cv/z9x1nLObUEckEYxfpXKh07RkYtMd8WzdQLZNaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154489; c=relaxed/simple;
	bh=XvHH0W/7V1pRBB3ZibOj0QhJUoHjo9dp2MjInUw/Lzs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VDzkg+QYbAqmc3w7eg+513HReDsAP93pl1v4M3I2oDEqhHpH87EAxksVT2lvRN+jtxgryU0e5WZUC+EnVEX4Dd/7pZZk3TBKJ4muviyXGZ9h3pNBpoa4wkyog3zzkLhWsE5w7WnmGnbE4tfp94ev40iQIy04Do1rYiSNMhOu/Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2xEvUiNE; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2xEvUiNE"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3825a721afaso2394728f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154486; x=1733759286; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C3AEmgqEm+cvkyX+Y7gfd4xBQC+JlaYoJMIK/6vkrhU=;
        b=2xEvUiNEEtuAySoLxsWP2RJgKd8LToG1CPDlH4L7DUfPW+bVHWza6530/HXegVNSWK
         MQWk+W7F2HYjdZzC5WwQmEOvrJG/eg242xNnh0XQmayk4SYlQavVZOUMqcu6pyNi8WR6
         yuSMQId5uSsdduEEo5Zv1brz3k6Aqx2KZ19vhJoG6pGgeTn/UVYtRRxj8Y7NyU3DshGf
         qw/g1UYhh1wIjIptg7MIKfTHU7XWuQDsuK9VeEcQ+GWxy7ih6wt6edNUKMKQN9J8Z0l5
         9wfc/eZWgaoYtmtiVfZtO8Uo6+crSSgfFhShvnyH/t9m07xKC/e9tJbMRgIs7TIJ3WpV
         JK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154486; x=1733759286;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3AEmgqEm+cvkyX+Y7gfd4xBQC+JlaYoJMIK/6vkrhU=;
        b=fBuQuNuuBuUfdnHfJK94h7zqUBQ916q6EGg6Jopg9qslfWTci0o92QVmBiz/HM+Miq
         7zffLavtY+DLf92Vff1buhvOPf0vlvP054xdtAdre5kBvShUc1NxQa6sWnvjhCROdwxB
         KZo4CJcPp7vk9XqRqq/eUIOZUcoQB6bpbbIL9Fv5/ohbXv+Ov6OKZhH1oxYSZFTgz5MV
         B8rwGOPi7A1z+KVe8eGbiX+XGVED24rVAisPlf+JLdL7Twht5Mw+j4qmcihlUtofyhzD
         tJDIdN+wHnOiGPDVKA8h0fdAvrWZGyyPjUAMPenuCW+Zf8RW+gJOFCsZ4BEfIkzVUjvA
         9UUw==
X-Gm-Message-State: AOJu0YwhcoCTiVh6FgIoWqwhEY/95xm7wClef2Y7qXKD9Khnz8CmMyhs
	CvmPyszb/8z0pIv0UiUxcjv8SKuRaRP9n2uXhQYhMPvt57y1gLAneBv3SB18y67cY4ZP7vSS4Xp
	N5oc0iW/LjcAOlpURCqnJgMoUf6FvqGD51Dl8a4ooKs39p/6nvrvX4y3b/ehD4iZChmGuV9kZNa
	5OddbePdmO1Ykfov5FZs8GNY9Ik6k=
X-Google-Smtp-Source: AGHT+IGhSynrcs4SqVVKs22wLLKLNJi/dXD0I1g5U0lYlcBLFc8w5xASAAEhBPJ+vcKS1qXzNPJOrCrAwQ==
X-Received: from wmjy25.prod.google.com ([2002:a7b:cd99:0:b0:431:1c66:db91])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4617:b0:385:e16d:f89
 with SMTP id ffacd0b85a97d-385e16d1024mr11521621f8f.34.1733154486245; Mon, 02
 Dec 2024 07:48:06 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:38 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-12-tabba@google.com>
Subject: [PATCH v4 11/14] KVM: arm64: Refactor kvm_reset_cptr_el2()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fold kvm_get_reset_cptr_el2() into kvm_reset_cptr_el2(), since it
is its only caller. Add a comment to clarify that this function
is meant for the host value of cptr_el2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cf811009a33c..7b3dc52248ce 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -619,7 +619,8 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
 		write_sysreg(val, cptr_el2);
 }
 
-static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
+/* Resets the value of cptr_el2 when returning to the host. */
+static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
@@ -643,13 +644,6 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 			val &= ~CPTR_EL2_TSM;
 	}
 
-	return val;
-}
-
-static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
-{
-	u64 val = kvm_get_reset_cptr_el2(vcpu);
-
 	kvm_write_cptr_el2(val);
 }
 
-- 
2.47.0.338.g60cca15819-goog

