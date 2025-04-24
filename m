Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073662820B9
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504043; cv=none; b=R/OtWRvGU935777c2DBW3BBJ6himO0f/FAfJBOtYuP7GA4RGvucaLZ1AD4CmoAEjKoLRQGsQgQrtAQiTNcvulYgeMjlZX+4NPFXxadTZqcDPT++VR0mTWT0pFLL41d5yIUBrX0uhwG1HsgVVT9ob3d2XWZ25icGMqM9oRixZwZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504043; c=relaxed/simple;
	bh=zpH5RWwn66pK/eMc3LSMNEkV/3yaevWoUA1/kvmrIcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PdJP7R7IFpp77lSWIdYhnPZ+Z7HnsTfQisAHI44nIxOTzRM5ej2ryKAGXRgH2Q3BGFk3h2FpAZiJSC01BJ6aLd2pIUC7C9Z2VmC2enyzX/U/FHbvFpXvo75zQNKxJnsuRyT+o+mK2SgxkEaA+45hsqj85HcsbAv+mgWw2iAxfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h4DMR600; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h4DMR600"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cf848528aso7713375e9.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504038; x=1746108838; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RusfJk/Wwgs+hfa3WlHRZBdqt7Zg7qYVP8LFIn+weQg=;
        b=h4DMR6008fUDnxP/SDxJ/Vg7cy9wCO1LlmH9Ij+h5fPuzN56zC0xPskQklDHQnxNTJ
         ce5oED8EaCz9TRJ/daN1CX1VHkq5aIeLpawjd0T+y8rifQ9veREhuaaUE50FT7NBRORg
         f4w2uJVYoopmuZE4UTvpzTUXGUIMSI27DPQRgbNR2pZSi39hBS4kqNQeMLZopNPSaSSR
         gbLyAT+k1UxVaIF0CRqSFZnHFEApKMyi2rEk7XEVAgRm8UqsKrXcnWVgTihgELHwShFY
         Kq9ACuqjgH8MlJebT6KVSL4ySgmVeo7oDJOyJKHnEkK4F1kM/cI5y/wCZm61F+Cwpgxd
         Ne6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504038; x=1746108838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RusfJk/Wwgs+hfa3WlHRZBdqt7Zg7qYVP8LFIn+weQg=;
        b=IN5Na3VS8xcyk1D96NloraWbVKEjfJUZneuJ6DAKnyfHQ8aIxHatIEPSnoutlXX+0h
         nrZPnpqK1HCWQzFr+TzEMFxX+3mNZxM+nC10vBzILdNKC+wnjiy0LhHA2nHIEbJB5CYu
         Ag1JJSTg5JE6+yv2vqFJp/GrlJXOwX4m0FKYVjgH5VH8grC2lnTHwZJ1wOxOQO2QjkTu
         n+bWA2ygl47xheYcpar4pB5JaiYOoLu+xK4wOHtkqiNiGRN6UR4zGbWbfA4xa9DbIwVn
         bf60dGLG0pt4uMNmbVBOGb2SEJSV7Txt+YSnZk19j0zfUUOUN53XWpb6u/+ZV2ZTm9Ms
         4DVw==
X-Forwarded-Encrypted: i=1; AJvYcCX13hKTctVQnHrFaVZlnoivpKiup+Jl3zHVA47YMep91IeXWL8O4StCNzXJ7eFly7Bk9Im6Xyw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQawP4g7m+x387aRTTrwG5Wi4R5vFx0DQCzlTZmvZ1/0BQmoJO
	F+VFluhU3IJl+QtZoqIcZyr/uxnA2lTWjzathK6CuD3nDjL+pocsVRmS3r1ouAI=
X-Gm-Gg: ASbGncuKQthjnvzP/rBNr4kfM1GRxGZiTUQ6SRF8BzHGevzP5jKHPyxu3+psw4OO3en
	+ABU+Bya7gHJTWoX9YWsr30N4+IvczCqzKebkiAq3QAlgCcklzXnI/L5XS9ViswHxAlUEzzVjvt
	Ehgz5S2Q/poySs+Z+bqhw2HFgiOUhl2QCRalXkS33M07TGNmJz7NXEhdRvFxU/w8q0i4P138LWo
	ptCa3oVKCpIoRR3otAnMtZV80lPAmLZU2hZRmsoY2J6eKrGw3rkFPbVian775ueg+LPUw7a31rW
	FtlTsImN5aXH5uDEDu2gnxqxTaKfU9jf/N6XLOg0g3LYmRpKHHOP+tx9Qex0uM+zBb1so7G/d2K
	1V88eqxqo0I1LtnAKxJsxmUcjX3M=
X-Google-Smtp-Source: AGHT+IFmkqrLYBA6pxT3bgHP40xSeHaZYwIrDUExxYU5PjMxiNNE1p1s+eiHaAutjdes9ZQldE7V0g==
X-Received: by 2002:a05:6000:188d:b0:39e:dbee:f644 with SMTP id ffacd0b85a97d-3a06cfa5a93mr2715557f8f.46.1745504038249;
        Thu, 24 Apr 2025 07:13:58 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:57 -0700 (PDT)
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
	Elliot Berman <quic_eberman@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Alex Elder <elder@linaro.org>
Subject: [RFC PATCH 10/34] gunyah: Common types and error codes for Gunyah hypercalls
Date: Thu, 24 Apr 2025 15:13:17 +0100
Message-Id: <20250424141341.841734-11-karim.manaouil@linaro.org>
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

Add architecture-independent standard error codes, types, and macros for
Gunyah hypercalls.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 include/linux/gunyah.h | 106 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)
 create mode 100644 include/linux/gunyah.h

diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
new file mode 100644
index 000000000000..1eab631a49b6
--- /dev/null
+++ b/include/linux/gunyah.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#ifndef _LINUX_GUNYAH_H
+#define _LINUX_GUNYAH_H
+
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/limits.h>
+
+/* Matches resource manager's resource types for VM_GET_HYP_RESOURCES RPC */
+enum gunyah_resource_type {
+	/* clang-format off */
+	GUNYAH_RESOURCE_TYPE_BELL_TX	= 0,
+	GUNYAH_RESOURCE_TYPE_BELL_RX	= 1,
+	GUNYAH_RESOURCE_TYPE_MSGQ_TX	= 2,
+	GUNYAH_RESOURCE_TYPE_MSGQ_RX	= 3,
+	GUNYAH_RESOURCE_TYPE_VCPU	= 4,
+	GUNYAH_RESOURCE_TYPE_MEM_EXTENT	= 9,
+	GUNYAH_RESOURCE_TYPE_ADDR_SPACE	= 10,
+	/* clang-format on */
+};
+
+struct gunyah_resource {
+	enum gunyah_resource_type type;
+	u64 capid;
+	unsigned int irq;
+};
+
+/******************************************************************************/
+/* Common arch-independent definitions for Gunyah hypercalls                  */
+#define GUNYAH_CAPID_INVAL U64_MAX
+#define GUNYAH_VMID_ROOT_VM 0xff
+
+enum gunyah_error {
+	/* clang-format off */
+	GUNYAH_ERROR_OK				= 0,
+	GUNYAH_ERROR_UNIMPLEMENTED		= -1,
+	GUNYAH_ERROR_RETRY			= -2,
+
+	GUNYAH_ERROR_ARG_INVAL			= 1,
+	GUNYAH_ERROR_ARG_SIZE			= 2,
+	GUNYAH_ERROR_ARG_ALIGN			= 3,
+
+	GUNYAH_ERROR_NOMEM			= 10,
+
+	GUNYAH_ERROR_ADDR_OVFL			= 20,
+	GUNYAH_ERROR_ADDR_UNFL			= 21,
+	GUNYAH_ERROR_ADDR_INVAL			= 22,
+
+	GUNYAH_ERROR_DENIED			= 30,
+	GUNYAH_ERROR_BUSY			= 31,
+	GUNYAH_ERROR_IDLE			= 32,
+
+	GUNYAH_ERROR_IRQ_BOUND			= 40,
+	GUNYAH_ERROR_IRQ_UNBOUND		= 41,
+
+	GUNYAH_ERROR_CSPACE_CAP_NULL		= 50,
+	GUNYAH_ERROR_CSPACE_CAP_REVOKED		= 51,
+	GUNYAH_ERROR_CSPACE_WRONG_OBJ_TYPE	= 52,
+	GUNYAH_ERROR_CSPACE_INSUF_RIGHTS	= 53,
+	GUNYAH_ERROR_CSPACE_FULL		= 54,
+
+	GUNYAH_ERROR_MSGQUEUE_EMPTY		= 60,
+	GUNYAH_ERROR_MSGQUEUE_FULL		= 61,
+	/* clang-format on */
+};
+
+/**
+ * gunyah_error_remap() - Remap Gunyah hypervisor errors into a Linux error code
+ * @gunyah_error: Gunyah hypercall return value
+ */
+static inline int gunyah_error_remap(enum gunyah_error gunyah_error)
+{
+	switch (gunyah_error) {
+	case GUNYAH_ERROR_OK:
+		return 0;
+	case GUNYAH_ERROR_NOMEM:
+		return -ENOMEM;
+	case GUNYAH_ERROR_DENIED:
+	case GUNYAH_ERROR_CSPACE_CAP_NULL:
+	case GUNYAH_ERROR_CSPACE_CAP_REVOKED:
+	case GUNYAH_ERROR_CSPACE_WRONG_OBJ_TYPE:
+	case GUNYAH_ERROR_CSPACE_INSUF_RIGHTS:
+		return -EACCES;
+	case GUNYAH_ERROR_CSPACE_FULL:
+	case GUNYAH_ERROR_BUSY:
+	case GUNYAH_ERROR_IDLE:
+		return -EBUSY;
+	case GUNYAH_ERROR_IRQ_BOUND:
+	case GUNYAH_ERROR_IRQ_UNBOUND:
+	case GUNYAH_ERROR_MSGQUEUE_FULL:
+	case GUNYAH_ERROR_MSGQUEUE_EMPTY:
+		return -EIO;
+	case GUNYAH_ERROR_UNIMPLEMENTED:
+		return -EOPNOTSUPP;
+	case GUNYAH_ERROR_RETRY:
+		return -EAGAIN;
+	default:
+		return -EINVAL;
+	}
+}
+
+#endif
-- 
2.39.5

