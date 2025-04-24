Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05D22957AD
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504072; cv=none; b=ds34ukGL1WRMsDEdm+H2pGu4AntiDI3ZZdJjDCrAYeXZkb5T+UFJ2GuKDd6+Batr63xwhryAe9x3v7DZWR5a02Trb6WzfP29bIWAnhhjreXGbkewcy0LwipQ1WDyxy2AFxBELiGn0H6ryKywNhRplPhcIuBNsciqugFDQArXzj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504072; c=relaxed/simple;
	bh=D+WfMC8Jh2PxaUkmB3v59ZfRR9QkXj4ch9yqlrdrhtI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AmnW3dnks/kylES9roW6zWhouAfuIv8iva8xUexVRJIZOo8Msy8wOlnAG2tpmBgtr6FxhhjoCNkEdSkax69rUCHPG0csS6bf3xZjk1h0ShWjt0ZOVNo63z5sUxFKfvlRVuaP7sLdBRyhDJhn8Cr2UeQ7gXnEP1x9HHY0IGXveyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kvVN52Ly; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kvVN52Ly"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43690d4605dso8295175e9.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504068; x=1746108868; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oa6gfxRAjkR7wfTiIJFT8jbfGXVVwGTh4OuP6vCgukQ=;
        b=kvVN52Lyd6zTeju2hQFJwulOW79BMVQX7n76XNXQswHUtsZig9FwyZcsVuCnaSU0ae
         rM4GHeFaiwnSPaMgAEj4wFZ1ZVC1NIc2hpUlux5m7Krjy7dUSofCCVkMRiV3VJ5rsFdN
         PeCg7kFlh8JsDehtLP+a1ANyu6OyT8nftMbd0JR+N39xOsrHm+ItWRdowA1zTVn1NmB6
         V9ZqnRJK0k+QReiEAMbMTJV5YJj0iBmEKmtuUSc5fDr5iOZZ1bgFYXpyuqSoHqAJ9RnE
         wuS2bBaXqcXBFqIHcAPWqkoXChjKDOu8aX37o6+45TjnTRsP/UNfITsuPL/fXYdxCFKw
         fO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504068; x=1746108868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oa6gfxRAjkR7wfTiIJFT8jbfGXVVwGTh4OuP6vCgukQ=;
        b=n4BNwRVrkuZASOSV4aWqhr/x0gd4mM6P3oUWXiMJc/deFiX1RdXLVQVr/g1srWqai2
         h7OFb9ZZxdGd1/QQ92ErrG6qEwd3T5v1VLkPyfaomQMRzK5wBqLQsmukNd0aUk7jJaJH
         4Nf2T0t78Gxe0KmQp6KkrvAwtwhB+qwsA1Pw5PUq11IbEKKbx0rTHQI8TnnHRz4Jy6AN
         kHU86MoWHeAH1EVFlUowv3bRQ8O4l9bsr6cFV5mFxVhVdPufdrDuTbN3MMlQRUqetGv+
         nq1TSA1OQkCvIK0RjlaW7h1e1+rWj4xqmExzyXAPKpDWloKF9chgZhoQV4Dw7r1kMKtA
         4TDg==
X-Forwarded-Encrypted: i=1; AJvYcCUM14UFqwXW+MtGpGwZDr/gqkDXFjjpEM5/kG3ArRU7rqbQm7a6XxPL0GokD3HMnmEbDAR6ECI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzglN0QufVrX2BHIWg5aE7OxmG00e/IY0JxNc+FV8N4C2Te2w5F
	3gyrnbMfP0aVc3bnE3i0ToRyObOvxS5Y6V5PP+Ww7vEbfbVGZyE5UTEbUtB4QSo=
X-Gm-Gg: ASbGncvnZ/QQZWh165m++UnUEjeXu5DeGU68d3wr2fatZ8lzNhFW5kNw4enCKuqeuNp
	n0FyuL6N6WtmP0GUWdI/QsQ+B/NxQpZjhg1nxh+QCTJU2nvbqy9GhPO0WFFI+FbJPHo2IOZVrJg
	N4dIyHWTWNte91WMTFk/sG2KMX9yC7jFgNnOnLBQ72qPUeoQ8voX31p1hp9KHnDdCZQOIzVgNWH
	zv1qmqgeCp2ZxJUq1ZkCIVA8mmSxuMcoHsUIPTb7/WCixOOpFjzlxHvZXZuSdMOP19rb6kvOHBx
	2/m9empx0UlFKPMv7Q4nUJRKKoNOIZU6dBhqwTe849la4ru4TNcyUXJIigzjvMGCzJt12mlYIGg
	TX5lW82QqyNq9Cl76
X-Google-Smtp-Source: AGHT+IERVpNU2DILo0bvt8R4DAynThAP/fjqterv2/ng44U7A/g/KpyVK5SJtSkw42xdSMDhah0Vrw==
X-Received: by 2002:a05:6000:1acb:b0:391:2f15:c1f4 with SMTP id ffacd0b85a97d-3a06cfad64amr2138772f8f.55.1745504067786;
        Thu, 24 Apr 2025 07:14:27 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:27 -0700 (PDT)
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
	Alex Elder <elder@linaro.org>
Subject: [RFC PATCH 32/34] gunyah: Add hypercalls for sending doorbell
Date: Thu, 24 Apr 2025 15:13:39 +0100
Message-Id: <20250424141341.841734-33-karim.manaouil@linaro.org>
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

Gunyah doorbells allow a virtual machine to signal another using
interrupts. Add the hypercalls needed to assert the interrupt.

Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/gunyah/gunyah_hypercall.c | 38 ++++++++++++++++++++++++++++
 include/linux/gunyah.h               |  5 ++++
 2 files changed, 43 insertions(+)

diff --git a/arch/arm64/gunyah/gunyah_hypercall.c b/arch/arm64/gunyah/gunyah_hypercall.c
index 38403dc28c66..3c2672d683ae 100644
--- a/arch/arm64/gunyah/gunyah_hypercall.c
+++ b/arch/arm64/gunyah/gunyah_hypercall.c
@@ -37,6 +37,8 @@ EXPORT_SYMBOL_GPL(arch_is_gunyah_guest);
 
 /* clang-format off */
 #define GUNYAH_HYPERCALL_HYP_IDENTIFY		GUNYAH_HYPERCALL(0x8000)
+#define GUNYAH_HYPERCALL_BELL_SEND		GUNYAH_HYPERCALL(0x8012)
+#define GUNYAH_HYPERCALL_BELL_SET_MASK		GUNYAH_HYPERCALL(0x8015)
 #define GUNYAH_HYPERCALL_MSGQ_SEND		GUNYAH_HYPERCALL(0x801B)
 #define GUNYAH_HYPERCALL_MSGQ_RECV		GUNYAH_HYPERCALL(0x801C)
 #define GUNYAH_HYPERCALL_ADDRSPACE_MAP		GUNYAH_HYPERCALL(0x802B)
@@ -64,6 +66,42 @@ void gunyah_hypercall_hyp_identify(
 }
 EXPORT_SYMBOL_GPL(gunyah_hypercall_hyp_identify);
 
+/**
+ * gunyah_hypercall_bell_send() - Assert a gunyah doorbell
+ * @capid: capability ID of the doorbell
+ * @new_flags: bits to set on the doorbell
+ * @old_flags: Filled with the bits set before the send call if return value is GUNYAH_ERROR_OK
+ */
+enum gunyah_error gunyah_hypercall_bell_send(u64 capid, u64 new_flags, u64 *old_flags)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_hvc(GUNYAH_HYPERCALL_BELL_SEND, capid, new_flags, 0, &res);
+
+	if (res.a0 == GUNYAH_ERROR_OK && old_flags)
+		*old_flags = res.a1;
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_bell_send);
+
+/**
+ * gunyah_hypercall_bell_set_mask() - Set masks on a Gunyah doorbell
+ * @capid: capability ID of the doorbell
+ * @enable_mask: which bits trigger the receiver interrupt
+ * @ack_mask: which bits are automatically acknowledged when the receiver
+ *            interrupt is ack'd
+ */
+enum gunyah_error gunyah_hypercall_bell_set_mask(u64 capid, u64 enable_mask, u64 ack_mask)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_hvc(GUNYAH_HYPERCALL_BELL_SET_MASK, capid, enable_mask, ack_mask, 0, &res);
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_bell_set_mask);
+
 /**
  * gunyah_hypercall_msgq_send() - Send a buffer on a message queue
  * @capid: capability ID of the message queue to add message
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 72aafc813664..26fdfa3174da 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -329,6 +329,11 @@ gunyah_api_version(const struct gunyah_hypercall_hyp_identify_resp *gunyah_api)
 void gunyah_hypercall_hyp_identify(
 	struct gunyah_hypercall_hyp_identify_resp *hyp_identity);
 
+enum gunyah_error gunyah_hypercall_bell_send(u64 capid, u64 new_flags,
+					     u64 *old_flags);
+enum gunyah_error gunyah_hypercall_bell_set_mask(u64 capid, u64 enable_mask,
+						 u64 ack_mask);
+
 /* Immediately raise RX vIRQ on receiver VM */
 #define GUNYAH_HYPERCALL_MSGQ_TX_FLAGS_PUSH BIT(0)
 
-- 
2.39.5

