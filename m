Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2AC284B4E
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504045; cv=none; b=SsX2h6x7PnkNTYiJ4Sb/r1IqSGI4NTChzIbKc5C5SuHZ3kHDfhU/14tWZLze3xTZlUsoUW6gpEP7Tfp6rAFozhHQpuuRcYTEXvmighJB0zIlU6EqkPwVM88m238NKyViIimenHv2BZC902OfDlh1qsqMqo8x9aAUy0z3FBfQsSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504045; c=relaxed/simple;
	bh=sOc+WgCBKAU0O5bB7WH2YBqY9uNwSXL1/wb8/ZYbbhE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EyEH7+4gifGenPY/Yd6oYlQkNJLC7AMm6H5QziGoT+UeQEpPHNkCYN+eDavr5Pe03oyldAK00f9gWian3OuNXbMKeXdeADEl6D9vHWqMfYZWlMe2cKhedCYil/gR6PW4D5wK2Qj/TPBW3uyMjuDSRII0Hs6+K8FzNCz5v82AhC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J4Cx08VP; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J4Cx08VP"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cfe574976so7691785e9.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504041; x=1746108841; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmKgb2P7k7ka3054x1IngydlF8noVj1FtGkMjW5J68k=;
        b=J4Cx08VPMXUJdjanhS3OtFa7/gcXxfktnfpYpzFmV9TC+bixQeezVIxuMgpFtYGgoo
         mEIag4KI8bKbZCg0I2Dku7MjOYURcp1MyVJU9JOwaKn0pYP2MI6gxQixzKOp9FACmBq4
         y/ajFOdHDs6e/17NTLmO26pzxmXucll8//fEAfoz9ySr3oslqQWnIop0Op8IFWsX9bv0
         PKXG/NqcDKPCl3nVuMNwdPX6c6c9qonSC1n3zjvRbKHHFfHYu8Ze8LlbJQoaxkFXtkXG
         tPxGYQ5Qr0Y2dojDso/7tBxfucI0JjaMdspkFhixHylcLHKJx1P34xc/bsJIWtDUxtN0
         1MIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504041; x=1746108841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmKgb2P7k7ka3054x1IngydlF8noVj1FtGkMjW5J68k=;
        b=kFK8F6+UyfmTORY/3p2tCMXOZ9k9qqT10v+aecVdHBgqzcxQ8wGd8PKuRcGioaRd8r
         Hh5UqxJaWC6fEhOWai1T/4/Lt6IqjeYAj9J9Jibw0iZiim/va8OapTTT0t0Y73H4j9dU
         VToNSVB1hHNOWFMHE3QzmPhWceSwXFCOkeSTkU7rCQxWyAAz/j8HrDi3PVz08ZW1FKKu
         O16pdPhoWED2KmFSmk9GvT4xzPJ0WIfIAeDUpYCo6ahIgzLyHyHbA8veJ7Qqv4NCaDzv
         3bm/fFfy4L0NwUfV8LD3no92r/8UgDwXw5HSFAviC0hM12BAoQS/XJQkVsJGLPY4/Rh+
         x21A==
X-Forwarded-Encrypted: i=1; AJvYcCVTafWDB3vmQrANldzlGPFuqzAJqx5xG4Kq9yCwmJppWlkwV+JJz6bfX5Kg6M56pTvuz8qkuAE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYw1CFe4R6RWZEk+zyoLmugaa5209Fp08mmLj2HMVLfZvydsXT
	jRsyV+t6LCcavtFcgrVlD9bqjUZDm7S2V0I/btHHgGPj9bQ+ZTrls15+DwB5n3Y=
X-Gm-Gg: ASbGncvhxTvZzIsZiXc7AGMZqu7oh/ME6Qw6sInw5pfL/KaX9TEW6eK41eaCwSSRD9j
	NZNN9ux1eX6Iyg6h5G/bKWRCtXJvW8/LwqFM2d8ZbRpuask1gKHI5LG2l0IeBvirUUl2Y51F1ru
	XboQH0JDLfLmfV3c0sCPVX0ZWafzWy28I+PCQyyz4Bi23H0OlF7RMOB0/VCcaAVt8ML9vIT8S5+
	WpN0la+Y0U63tP3NtQgJbvShe4fY8csg6FCrzZnaE0ss0pwOacDd+YhUhvfGXuv/j0SjjhJ+qFN
	5iTvO8GksYLQHN4uaMvFh6E/PcdaMFIpbihELazq9wVU6n6uipUH+YIIdlShN/JvzMqHW6MyAhL
	vF9Wqv+k+OCgFa5NjQVELlG73Ix4=
X-Google-Smtp-Source: AGHT+IGfkZ98OulZ0pJYU5c1ld+aBqoKjFuSpgzRjo7Jvo/4HTkJCAjHkRJEje6F6WXTnu8CxQELEw==
X-Received: by 2002:a05:600c:3b0c:b0:43c:e8ba:e166 with SMTP id 5b1f17b1804b1-4409bd83db4mr21261755e9.22.1745504040937;
        Thu, 24 Apr 2025 07:14:00 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:00 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 12/34] gunyah: Add hypervisor driver
Date: Thu, 24 Apr 2025 15:13:19 +0100
Message-Id: <20250424141341.841734-13-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

Add driver to detect when running under Gunyah. It performs basic
identification hypercall and populates the platform bus for resource
manager to probe.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 drivers/virt/Makefile        |  1 +
 drivers/virt/gunyah/Makefile |  3 +++
 drivers/virt/gunyah/gunyah.c | 52 ++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)
 create mode 100644 drivers/virt/gunyah/Makefile
 create mode 100644 drivers/virt/gunyah/gunyah.c

diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
index f29901bd7820..ef6a3835d078 100644
--- a/drivers/virt/Makefile
+++ b/drivers/virt/Makefile
@@ -10,3 +10,4 @@ obj-y				+= vboxguest/
 obj-$(CONFIG_NITRO_ENCLAVES)	+= nitro_enclaves/
 obj-$(CONFIG_ACRN_HSM)		+= acrn/
 obj-y				+= coco/
+obj-y				+= gunyah/
diff --git a/drivers/virt/gunyah/Makefile b/drivers/virt/gunyah/Makefile
new file mode 100644
index 000000000000..34f32110faf9
--- /dev/null
+++ b/drivers/virt/gunyah/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_GUNYAH) += gunyah.o
diff --git a/drivers/virt/gunyah/gunyah.c b/drivers/virt/gunyah/gunyah.c
new file mode 100644
index 000000000000..3e795e3ba881
--- /dev/null
+++ b/drivers/virt/gunyah/gunyah.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/gunyah.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+static int gunyah_probe(struct platform_device *pdev)
+{
+	struct gunyah_hypercall_hyp_identify_resp gunyah_api;
+
+	if (!arch_is_gunyah_guest())
+		return -ENODEV;
+
+	gunyah_hypercall_hyp_identify(&gunyah_api);
+
+	pr_info("Running under Gunyah hypervisor %llx/v%u\n",
+		FIELD_GET(GUNYAH_API_INFO_VARIANT_MASK, gunyah_api.api_info),
+		gunyah_api_version(&gunyah_api));
+
+	/* Might move this out to individual drivers if there's ever an API version bump */
+	if (gunyah_api_version(&gunyah_api) != GUNYAH_API_V1) {
+		pr_info("Unsupported Gunyah version: %u\n",
+			gunyah_api_version(&gunyah_api));
+		return -ENODEV;
+	}
+
+	return devm_of_platform_populate(&pdev->dev);
+}
+
+static const struct of_device_id gunyah_of_match[] = {
+	{ .compatible = "qcom,gunyah-hypervisor" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, gunyah_of_match);
+
+/* clang-format off */
+static struct platform_driver gunyah_driver = {
+	.probe = gunyah_probe,
+	.driver = {
+		.name = "gunyah",
+		.of_match_table = gunyah_of_match,
+	}
+};
+/* clang-format on */
+module_platform_driver(gunyah_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Gunyah Driver");
-- 
2.39.5

