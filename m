Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBD329B8E8
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773247854; cv=none; b=oRE42n7Rp0JGnX50/ImhhgnU2LQjpv2nHj6R5RxcJsSKSq4hZQrw/a5AsEquV7mKObZvu89yxCfFk43UWisECGfZvXP62jA63+m5sSC9iukWGPCiVIjkxbdynJvIKIYmxkZjFEgWMnZci/aD+QXqsnQiN4NB9LdVzlMIca72PgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773247854; c=relaxed/simple;
	bh=8JHxYH6w78CcZAaBE5OvkzwTcnjB77vZQ+h0cV+KZeQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=feui8Uk8PQfZ5kTbJL/Ghz2vlcVe0VyASaiHE4sJvNfHROuw2bD7/kpSBIE2C0CCpZvfFNfr65gXK5Xs085WFb5bqG4h89HD2habZ2DcggrSSvy9xqa1vYy6tfRIeTGc3XAqpfEcPrajCKB8ko58GGTneGEqDKphn9AgDRKxrUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IThB2gKV; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IThB2gKV"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439cbc5fd75so65358f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 09:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773247852; x=1773852652; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j+yutjzxpV6VuikO2aEUOwAu3nPmTlDI2JrtF18m66o=;
        b=IThB2gKVICQ9ktQSVVaFAMJM3tViEN5q0qdbHNq6J7gb365UhZj/dz1oezxO6I3Wp6
         x+i300WwOd7y6o1AlHToHbpOqSG5Q2THtnjAyAlfSU6c85CSq0iuh4hGps264QBySRoI
         3OrsqaypsO+eMx90UDWpZOPxW4k7yqk65TuhBFIz/beLJU236nOYdUUhL8kLeV9pGa1h
         Lm0t39gaTYw25r5v765mIP6Lfby6A2OVDe+lngDLlcKTPD1Mu1RlMdQH0qDAIf9tfbS2
         BLVa2ZMuQbC0lK+MJObZ/UTmB7BAVO6KVl6R1uSPHtKAMIRhtdmBWQMG3z4Tmp/+droc
         IUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773247852; x=1773852652;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j+yutjzxpV6VuikO2aEUOwAu3nPmTlDI2JrtF18m66o=;
        b=YLYMwm6CRPwogbqeWkoTsaldpvh7ztjMRoyLMGSf72OncSFmCoTCLOX1hNxHhw1LSj
         GiCdkjRc8FZ1awj6Yhw4ejOGaXENs7I7BO9D089RnkOUaeZBKQWoWRQ24lC20Jfico2N
         ud9De0R1hqXkc7nVQhX8YIajmaLwyhggCRBGIb1JesA4kEuOqHhyK/logfLWhrygmEtD
         Vejdl7dh/xELSqVT2IAp1tCOMgReIESemU8hRbcXLPFbz6/KfkGf/lCnT9j35iAxl5Xu
         78HKPeMg2muwpvTFTH9P3+sfUZz8e9svqAEhvBs25UWlsmVhzMpB87S3aoPg4DS0b1jH
         gbeg==
X-Gm-Message-State: AOJu0Yx47wcQh9NG7+p4y7CpywKhAAQ+jCDtTREUh509XiVeNhThznWi
	YONjGXciZpoEectET+NzRa86MHA8myOf4+bE6TiOWJFe8LgxA6I7THYR84H42nk03GT5CxZ9xnL
	cyPufj9Op8NdcH5I5hY1vnw==
X-Received: from wma1.prod.google.com ([2002:a05:600c:8901:b0:485:4f4a:bd84])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a44:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-4854b107c4amr53124835e9.17.1773247851698;
 Wed, 11 Mar 2026 09:50:51 -0700 (PDT)
Date: Wed, 11 Mar 2026 16:49:56 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260311164956.1424119-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix out-of-tree build for nVHE/pKVM tracing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org
Cc: kvmarm@lists.linux.dev, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

simple_ring_buffer.c is located in the source tree and isn't duplicated
to objtree. Fix its include path.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 143d55ec7298..3d33fbefdfc1 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -33,7 +33,7 @@ hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
 hyp-obj-y += $(lib-objs)
 
 # Path to simple_ring_buffer.c
-CFLAGS_trace.nvhe.o += -I$(objtree)/kernel/trace/
+CFLAGS_trace.nvhe.o += -I$(srctree)/kernel/trace/
 
 ##
 ## Build rules for compiling nVHE hyp code

base-commit: c84ebda4050f1a0c7283dd3d3b82f41cb2e72a18
-- 
2.53.0.851.ga537e3e6e9-goog

