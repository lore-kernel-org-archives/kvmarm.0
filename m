Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDD51A83ED
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504055; cv=none; b=WI7usouR++RDCTKihv/ZwlrvGwjf3/zKoPpQzGyzx4wBwi0nfFqwOJlV1R96hpBbz+484dk32JkBYDhiite5Q7/bnVBwtFgSyDYsddkUNTPzBg9TOWjX7v8BCVTIhG/vsnvD8d89N59i0K0kx/wynaX6umW2ulEgxyF2dpxuz6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504055; c=relaxed/simple;
	bh=2aIlJTxyajv9w1JNq2QUWNBaFE1l1Iz4MgPOHzkWSHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UtciNqWdDn0WGwoRbdsS9O6BssjVZDaiD2XIxtULcr6SjM9/kVSx7oPpLoZfPgYCHPiEhDOox5lRBnr52hzTCZZcYv0uvMYYdgSec3pqvKhkHECpjqvRRMNWmk3LRV2WetLIkyyoFscYyPfBGnWkkz366jOuyX5XtrS/JaxAh6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FutfZqtK; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FutfZqtK"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cf06eabdaso10035745e9.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504051; x=1746108851; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnnNrRFux5qVcGjuNFA0c9YQRdgVNUximYQurTlnUC4=;
        b=FutfZqtK5Sk184gB9jTuqXF4HmBFUpGCXhJmMI+d0JGbfVFNO/B3veQo86j6bqHgIL
         hzCoe+Cu7Ij6ApEyDgGk1czRlFCxLYU3fX9vJrSaok6WEhkEp85gmK+5tay2gaFfc414
         uvu985VoxSSFX1eLiy/tEKSMhHlWr62AqExe5mvEWWRfub9ozYw2PDK269Xzqs29dHzd
         5F/zygDTvLjzInUJ10UEgjxe44UVfR9PiSjc2F7QiCgaLbomIeBq6tG0JX+u9fendxww
         7ab2nDlDZExSvsZokgTEeQtEEGEdEl/QXRUBf+5nXzD3D7lFm69OgHZbNFyslYqQPOnP
         PiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504051; x=1746108851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mnnNrRFux5qVcGjuNFA0c9YQRdgVNUximYQurTlnUC4=;
        b=qrC5u1p8UAw7wB2MbZQlStIPKiC0v1qagYwFUNOL1aqDcHy49b5M6Zvo6CqFXyzW8m
         mw0F4o5R2GwOQHJGsyvsOVAugASHP6au0v1QlUJ4cAr0uQKEyb9ofNbakyHVzIpQ9X7p
         Ip7znykNAwU+3hKjRLZzAiuSgikExRT00dR4gjxZGL8tOQz+cA8tkkdDsXh2f4O6aPXU
         S3IGVYYN9Yz20gpZcW3MCoi95GBtaPxnifzQzyb4RorXEK51jK35vxmwXxFAHqJEW3HN
         UaxBOxAtuRQ1QJRXs8K+uKjjmeAAnRH7AfRkzU+XNnFWdwkz32MDJnCLdQm0ePYDuV/6
         Xa9w==
X-Forwarded-Encrypted: i=1; AJvYcCU3VdgKiIN9Xn7MxiEJzfAHzMUYd97a3ROhwi7NoRR/+3uBFEKmtj0NRlFKlEsjUBW3Fj0+IVk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRdULSOXvn5biMEqfse8QIfrLhdVAo6g1ogcM3cH79Fg+OMfEH
	SbirKnMEidau4hwstMSi1Uy3AHc4W6CEub9g6WtkT2JO0VCCinnFR5DFGNtt2Y4=
X-Gm-Gg: ASbGncsqjTjklFVjmxzmBvKhQCcN1lwzpR7z3wgp/lekmlx7eOS799lAKmvE+syXoNy
	RPxYQ5xInthlg9qszRl5PpLRZrd4cG3RVBcu5H24fAkGOP7gMYDokxVZ/al5J0QN9LIV3kF4cM6
	90QC2aD4VLEDkS9bCtENdWNiqYeVjgIPOkBs8rrSYshaiw6gjBLKuXtj+4acqnovR/G5C2Q68WR
	tyX2LETO2JblFJsyqwgm6pfnVJsvRf190BS6PdhjFWsK9EiFKGqgTawsR8mSMLRvbYuUkDkAEs3
	ZbazYMAFE9ZbQnEDHrIjZCxKFPY9DiXZKHujbRdVVzHYNldW1mMeFkguWSdh+NWZfVa2zyYl7IB
	Nm9X8VVkAuFuKeCuS
X-Google-Smtp-Source: AGHT+IElBFJDMQbW748Xhn6uR3Gy7UiwZwfaHD4iyiwy3AqrKyTZYkKWwIgzmc9HZX/EcWP9CEo9Lw==
X-Received: by 2002:a05:6000:18a2:b0:391:47d8:de2d with SMTP id ffacd0b85a97d-3a06cf5ed4cmr2483522f8f.23.1745504050693;
        Thu, 24 Apr 2025 07:14:10 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:10 -0700 (PDT)
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
Subject: [RFC PATCH 19/34] gunyah: Add hypercalls for running a vCPU
Date: Thu, 24 Apr 2025 15:13:26 +0100
Message-Id: <20250424141341.841734-20-karim.manaouil@linaro.org>
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

Add hypercall to donate CPU time to a vCPU.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/gunyah/gunyah_hypercall.c | 37 ++++++++++++++++++++++++++++
 include/linux/gunyah.h               | 35 ++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/arm64/gunyah/gunyah_hypercall.c b/arch/arm64/gunyah/gunyah_hypercall.c
index 1302e128be6e..fee21df42c17 100644
--- a/arch/arm64/gunyah/gunyah_hypercall.c
+++ b/arch/arm64/gunyah/gunyah_hypercall.c
@@ -39,6 +39,7 @@ EXPORT_SYMBOL_GPL(arch_is_gunyah_guest);
 #define GUNYAH_HYPERCALL_HYP_IDENTIFY		GUNYAH_HYPERCALL(0x8000)
 #define GUNYAH_HYPERCALL_MSGQ_SEND		GUNYAH_HYPERCALL(0x801B)
 #define GUNYAH_HYPERCALL_MSGQ_RECV		GUNYAH_HYPERCALL(0x801C)
+#define GUNYAH_HYPERCALL_VCPU_RUN		GUNYAH_HYPERCALL(0x8065)
 /* clang-format on */
 
 /**
@@ -113,5 +114,41 @@ enum gunyah_error gunyah_hypercall_msgq_recv(u64 capid, void *buff, size_t size,
 }
 EXPORT_SYMBOL_GPL(gunyah_hypercall_msgq_recv);
 
+/**
+ * gunyah_hypercall_vcpu_run() - Donate CPU time to a vcpu
+ * @capid: capability ID of the vCPU to run
+ * @resume_data: Array of 3 state-specific resume data
+ * @resp: Filled reason why vCPU exited when return value is GUNYAH_ERROR_OK
+ *
+ * See also:
+ * https://github.com/quic/gunyah-hypervisor/blob/develop/docs/api/gunyah_api.md#run-a-proxy-scheduled-vcpu-thread
+ */
+enum gunyah_error
+gunyah_hypercall_vcpu_run(u64 capid, unsigned long *resume_data,
+			  struct gunyah_hypercall_vcpu_run_resp *resp)
+{
+	struct arm_smccc_1_2_regs args = {
+		.a0 = GUNYAH_HYPERCALL_VCPU_RUN,
+		.a1 = capid,
+		.a2 = resume_data[0],
+		.a3 = resume_data[1],
+		.a4 = resume_data[2],
+		/* C language says this will be implictly zero. Gunyah requires 0, so be explicit */
+		.a5 = 0,
+	};
+	struct arm_smccc_1_2_regs res;
+
+	arm_smccc_1_2_hvc(&args, &res);
+	if (res.a0 == GUNYAH_ERROR_OK) {
+		resp->sized_state = res.a1;
+		resp->state_data[0] = res.a2;
+		resp->state_data[1] = res.a3;
+		resp->state_data[2] = res.a4;
+	}
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_vcpu_run);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Gunyah Hypervisor Hypercalls");
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 573e3bbd4cb6..f86f14018734 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -219,4 +219,39 @@ enum gunyah_error gunyah_hypercall_msgq_send(u64 capid, size_t size, void *buff,
 enum gunyah_error gunyah_hypercall_msgq_recv(u64 capid, void *buff, size_t size,
 					     size_t *recv_size, bool *ready);
 
+struct gunyah_hypercall_vcpu_run_resp {
+	union {
+		enum {
+			/* clang-format off */
+			/* VCPU is ready to run */
+			GUNYAH_VCPU_STATE_READY			= 0,
+			/* VCPU is sleeping until an interrupt arrives */
+			GUNYAH_VCPU_STATE_EXPECTS_WAKEUP	= 1,
+			/* VCPU is powered off */
+			GUNYAH_VCPU_STATE_POWERED_OFF		= 2,
+			/* VCPU is blocked in EL2 for unspecified reason */
+			GUNYAH_VCPU_STATE_BLOCKED		= 3,
+			/* VCPU has returned for MMIO READ */
+			GUNYAH_VCPU_ADDRSPACE_VMMIO_READ	= 4,
+			/* VCPU has returned for MMIO WRITE */
+			GUNYAH_VCPU_ADDRSPACE_VMMIO_WRITE	= 5,
+			/* VCPU blocked on fault where we can demand page */
+			GUNYAH_VCPU_ADDRSPACE_PAGE_FAULT	= 7,
+			/* clang-format on */
+		} state;
+		u64 sized_state;
+	};
+	u64 state_data[3];
+};
+
+enum {
+	GUNYAH_ADDRSPACE_VMMIO_ACTION_EMULATE = 0,
+	GUNYAH_ADDRSPACE_VMMIO_ACTION_RETRY = 1,
+	GUNYAH_ADDRSPACE_VMMIO_ACTION_FAULT = 2,
+};
+
+enum gunyah_error
+gunyah_hypercall_vcpu_run(u64 capid, unsigned long *resume_data,
+			  struct gunyah_hypercall_vcpu_run_resp *resp);
+
 #endif
-- 
2.39.5

