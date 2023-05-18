Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472C81C04
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 10:43:22 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f417ea5252so13118015e9.0
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 03:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684406600; x=1686998600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIOLMvBU8l6RE5ODSm65W2zRH+B2CDJfYYoC+8i5LwQ=;
        b=m+Jv0HHdp4unaRjWpY/Lf8GJaa50QCjfQEZtRQZWeS/nA6asge9VCeKu6voHDMbags
         TYTQRhQBnI4qMztOxua3nXHgECh7lVLoxtiVULtazvA/jb6vUzGJDIIH0U6eJWpNWJUr
         837h9erdCxCUJe69D4mlSUNed17JuuwYKFlEGNjS6+iAWPpmr+e/PA5vh+kTD1O5rC6h
         AFfkIdujUokeJP0tSeHl8zOd1OXmCvhch9y+2OmBBnev5IB4OmpmQKvoEJA2JxYXQplc
         Qyxs+6Yj/sCJ3Vadimhn5hfMjoL+s0nym5qf42vLjlEGoN9x98Rqa3AV3Y3ieCSnZ37m
         4obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684406600; x=1686998600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sIOLMvBU8l6RE5ODSm65W2zRH+B2CDJfYYoC+8i5LwQ=;
        b=WlwDLOXSi77xsbTVIhYLIgin8IYKXiHgGQ0TDKKDeg3DXxGLGZjlzR7zTgJjQlCZ3a
         gbhJ935JA9OYc/VkkfDCaG5TwtbyVvoNYweasdXHlDFKTDW4twAn/dv16eD5LBGNq+wX
         cLadchL7E/d8lsbwyPhHFAcRxBPuWkfe8WjzoTbIdw34L1WUIeJEI/ku7m2Hm12xdtiN
         Om83/OG+P6ia9sKdz+IIdaFVLn+QeWpsbz/fRh8xJO7RIXjc5GBVGtyedxvR3IQqOH2f
         jkmmkYxh3ziosgoQZ/XMYTBc+2Y9h/U1IfrXeS6JBHpfyc57UN87b6Jg7ek7s2C5B0dB
         7ySw==
X-Gm-Message-State: AC+VfDwfUlnMZ8NbNlxEZVVoZ+fq/NPp/UO+8D74SCkSWRdXwkJ+rhQZ
	B8qemcNP+kG1o1HM4vRjPvHrHA==
X-Google-Smtp-Source: ACHHUZ7OKBt45+2Zkcx84mVW2RHOklZaJvAvHo8vjc+C6OjjzBMyd5t0EoNV1ByX2NDFF6P6Lb44Dg==
X-Received: by 2002:a05:600c:290a:b0:3f0:b1c9:25d4 with SMTP id i10-20020a05600c290a00b003f0b1c925d4mr1104993wmd.21.1684406600409;
        Thu, 18 May 2023 03:43:20 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id f6-20020a1c6a06000000b003f427cba193sm4880523wmc.41.2023.05.18.03.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 03:43:20 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: oliver.upton@linux.dev,
	maz@kernel.org
Cc: james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH 3/4] KVM: arm64: vgic: Fix locking comment
Date: Thu, 18 May 2023 11:09:17 +0100
Message-Id: <20230518100914.2837292-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230518100914.2837292-1-jean-philippe@linaro.org>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is now config_lock that must be held, not kvm lock. Replace the
comment with a lockdep annotation.

Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 3bb0034780605..c1c28fe680ba3 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -184,13 +184,14 @@ static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
 	}
 }
 
-/* Must be called with the kvm lock held */
 void vgic_v4_configure_vsgis(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	kvm_arm_halt_guest(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-- 
2.40.0

