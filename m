Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343941E9B32
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504034; cv=none; b=Kd/2x3OqqPvFygp7Cl/7sEkHlj22zdZI8s57zKm095t0j9WzNSK2ZpIWM6gPWYlepnPlUYjf4oGAOD35woY9m4ww23ZI3m3jYtVXjAQZ0dGIJ2QVuYpsfixcZtiaFhGqCxC/HmRZNeh8/5HqffwE48tvQ2I/uTNuUtPL8Je2xLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504034; c=relaxed/simple;
	bh=yHQVbNXozVjVHt5pOWEf6CFk11nfYNM4wHopdbI5gbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r+lOvLYC7PSVNfBL2pSu3FXXwc6412t2X+396qiNGNaH96bXrlqPXwlQ6QmQl39xzFGIcLi1Rho7x97z6XqqlTDAX/nsgFnNSv1U/WQA8evdw/Zd6pBEN3mDIXlqyIOQyqTvD8tSBbRsH3wn7nF7exQ52z5Yzr4fq4QAhPdPRSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Rgc4IUCO; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Rgc4IUCO"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39ac56756f6so1036069f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504030; x=1746108830; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlljNambtbwwvkzAI4LjAz2eo7Ti1KUJrgs8M2UB6Bg=;
        b=Rgc4IUCOzqKPVMwwqAyVNpY+BgA3hKztMHCg+nJvJRl/BPbvIaDgkvOMHwoFi+XHA/
         77zTA3cvZyrSV5/LDN5+qsNC7Z8hl6L30vEZ+5kABeIweUsb5KObrIH0Nj0yIvniKHjd
         FFy47FcVin+CBiSH/JvV7tkY8m6L3mk12pfHZWJoifzIa/dYM+OUpqstC3mRkg5QTvlu
         xgjNwqiIWrbyz+5VCuz9UcFNfQrTHFe4FezaR1FwlMskj3rs9qP5o4R1z/Q8ieuWoeAF
         77FY6iQaR2xwawlbY41VLZ0rMggDjGpEKoZ8nuCa+CzHry/3qbV0ls/LaBzKv5YSjrq6
         /eGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504030; x=1746108830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlljNambtbwwvkzAI4LjAz2eo7Ti1KUJrgs8M2UB6Bg=;
        b=g4XBJ/R41dD7evAVESYp29fljlqG3MKnCi6Luy/FyipcovxWE9aW103hypsGjulNhX
         0WSL4qtrTs2fieW7AclDOvvOALyP0AJXulYEoFLlqSbiqxZ21ScGXMct7OhGJIap1It0
         TYT3g1TP6lugjah5nqVzljsec4u2mXxe1yEUH/NQOL7bku+JrDjDla5AV4LLqZSftkmS
         4TOsdztsFMKCTJy8zmo4oXActexjREkfCQTsBcySXEQ9LWps3sxJKgOdPh1//ZNzbWMn
         e18ZeXkl9Rd6RQTZJ3LUSjDc5TFa6yzi26sV3Tq9QYVXXcQgBAmAVd7csMpndtgjD4lz
         Ib/w==
X-Forwarded-Encrypted: i=1; AJvYcCVLxc4jBFYICh/afCx7JB1qug2SC6yCt6aK2BN4LL5XG3Gs6kGtKiFNvrdLDKIZfPGovdE7fMk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzeToPNOJrzxBh8GeRqxT+sajiHscrHGgLP2vJL8NatIc9l+UIz
	6WihCVgD62UvsCVoPQJB3qGQqxWhfuyYiOaJ1EC9+rzdQF/+EBdsggEyP9X5dYs=
X-Gm-Gg: ASbGncvwb7VqZ080O7Bp1AljjJNd2kV7e79DuRxM4IOqu7XOldekPWauvubmfqQJaKc
	w4ovt4hojR7CdS1MyQXNcnGoJm0EmMTCQwSSjzq3nd6uyekUTItPnU8e65lUVtPqBy8TCaT8vlX
	IFWFqSqg7Iy98wwiUx7ycUcm6CZ+AdfkbrBNCtcEYqm3jOwy2Y5QniYIPyABPqEjl9t81vDGV3R
	LzvtrY37DJib7xN5nUGc0UQOaYbbEH0QHoEXqsD2qvIG69jd5/u4ZwVUQrhtJwnRydq8W9qPRWc
	4x4WswuZnkhg6zLLtntMYJWOgjrGLlSjH2whonYEYZvTUFkryLOF1GYDMLx7b19DmFoxmYNQXDg
	QECuq737Zi/9ALD6h
X-Google-Smtp-Source: AGHT+IGjTSYHUF3tyGvvpZJy9ttFB+SjTk/OBEoax4K5qs9LZf6N8lXayXTA0lInN+EeJy++KbQTNQ==
X-Received: by 2002:a05:6000:18a2:b0:391:47d8:de2d with SMTP id ffacd0b85a97d-3a06cf5ed4cmr2481988f8f.23.1745504030257;
        Thu, 24 Apr 2025 07:13:50 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:49 -0700 (PDT)
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
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 04/34] KVM: Add weak stubs for irqchip-related functions for Gunyah builds
Date: Thu, 24 Apr 2025 15:13:11 +0100
Message-Id: <20250424141341.841734-5-karim.manaouil@linaro.org>
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

The generic KVM core code (e.g., kvm_main.c and eventfd.c) calls into
irqchip-specific helpers such as kvm_set_irq(), kvm_irq_map_gsi(), and
kvm_irq_map_chip_pin(). These functions are defined in kvm_irqchip.c,
which is not required or compiled when porting KVM to run on top of the
Gunyah hypervisor.

To allow building the KVM core code without linking errors in such
configurations, provide weak stub implementations of these functions
in eventfd.c. These stubs return appropriate default values (e.g., -ENXIO
or -1) to indicate that the functionality is not available.

This allows the KVM core to build successfully for platforms that do
not use the in-kernel irqchip support, such as Gunyah.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 virt/kvm/eventfd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index d6702225e7f2..2a658d8277ed 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -56,6 +56,26 @@ kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
 	return true;
 }
 
+int __attribute__((weak))
+kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
+		bool line_status)
+{
+	return -ENXIO;
+}
+
+int __attribute__((weak))
+kvm_irq_map_gsi(struct kvm *kvm,
+		struct kvm_kernel_irq_routing_entry *entries, int gsi)
+{
+	return 0;
+}
+
+int __attribute__((weak))
+kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+{
+	return -1;
+}
+
 static void
 irqfd_inject(struct work_struct *work)
 {
-- 
2.39.5

