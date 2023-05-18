Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F7911CB4
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 10:43:22 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3f4ad71b00eso11869155e9.2
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 03:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684406601; x=1686998601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mp00WwehAYxhmIULq9IO59RiAwWhddV/IMvvStrd9QY=;
        b=S2AxPAGUw+TvyThlV0Vf9cbp1xI9Tav8+vI1C0HsNRWQUwjPnUfVaZBIq+Z35A/LpQ
         BT/LZzrLBEr9cZanYzuUOX0BLluH/JGkUUG+lTV/ICIc82pxJfjUIMyw7/8/FLKN/RBR
         aSdzIsMBP6x8uF8uKvytzyTv7Nika6GmXKknU1t13judHK5pQXYkc45CH9O/FNZzWelx
         2xdS/Cd0Lu388nw322+bSI4hANfoaf3sEU5YCoeV5bVT4xUXXGoa1gnunBNzPikdnj4g
         bJrI3ZFiIRwIxxl2GEFk1IRNhBW81wwgu8mpKAoEGOvXDyZ1t8s1mfcqs8CAKI1GNsph
         pP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684406601; x=1686998601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mp00WwehAYxhmIULq9IO59RiAwWhddV/IMvvStrd9QY=;
        b=Ybq78mb0ZP2ZmIoVlNFcikd2uF6znD0rNraHPqhtqdXSlLSbMoF7LuCPUmoJsghXWz
         cUhzaWgIvKmevxXZQacRewXE2Ix3pvs+uwlWnfd9/tlM+3ZbMWU8tePsruC5BCFSqEIS
         2IaU2ExOv1zXNqu3KhmG4mYdDEOpWbGADacdu/ImSbsAaB8heiYjT5Cee5drMpNuZnB8
         IJsQIVoSlEe201PupM3mgWYgN9I3vcgjxthJzo5nGeeHOTMpqBnhlEiEiVeBKN8pvV0e
         rHIFrKXFtGkmPWJM4u82GGEuhtDLrKnxrW1VRyvdSu6j2LGa6SH9pw86NmvLPFQHs9sX
         elWw==
X-Gm-Message-State: AC+VfDwNAfKDtw4S0naHITtv1RQHQS9aveCFnYrQihdrzeQTQcwgJPv3
	ZVFwLdQZK1uV84iOG1VoixrZnA==
X-Google-Smtp-Source: ACHHUZ74xHy3Q+upbLQlKFFcBssYX0WpfXMEve5SgQOi/ntELy8xB4pjSzgKM2I4g5IiYUtWQ6beAA==
X-Received: by 2002:a05:600c:2049:b0:3f1:6fea:790a with SMTP id p9-20020a05600c204900b003f16fea790amr1174571wmg.30.1684406601090;
        Thu, 18 May 2023 03:43:21 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id f6-20020a1c6a06000000b003f427cba193sm4880523wmc.41.2023.05.18.03.43.20
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
Subject: [PATCH 4/4] KVM: arm64: vgic: Fix a comment
Date: Thu, 18 May 2023 11:09:18 +0100
Message-Id: <20230518100914.2837292-5-jean-philippe@linaro.org>
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

It is host userspace, not the guest, that issues
KVM_DEV_ARM_VGIC_GRP_CTRL

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index c199ba2f192ef..6eafc2c45cfcf 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -406,7 +406,7 @@ void kvm_vgic_destroy(struct kvm *kvm)
 
 /**
  * vgic_lazy_init: Lazy init is only allowed if the GIC exposed to the guest
- * is a GICv2. A GICv3 must be explicitly initialized by the guest using the
+ * is a GICv2. A GICv3 must be explicitly initialized by userspace using the
  * KVM_DEV_ARM_VGIC_GRP_CTRL KVM_DEVICE group.
  * @kvm: kvm struct pointer
  */
-- 
2.40.0

