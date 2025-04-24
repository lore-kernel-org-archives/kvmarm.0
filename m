Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2E31B4F15
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504033; cv=none; b=aiCtjRgZIaeKoP8tp/ffpnQ6g1r550D5zrnZRKow1oYYcqTksxpfBG8PTqPd8dpsKc3DOFXomZr/7gO2qxek3MRRLYMs/v3fMIaB5Zo8GE2kwCe+q/OGqaeAtLmlNWf6QiIdKt4GpT0afz3KO55ViZIW13XvWRVSZbaBHlX3Flw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504033; c=relaxed/simple;
	bh=wzaNO/FV98NvOhVwcurDeWV9o2lzkiDEMgzO9vOQkfc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CpBk0g0oplUdurWgbEkY/mkONqs1c3MMl8bIGjfvOtNFaA1QmwyRArN8bWtzz9VlsgW8BHY1BIRY+9APjdSOiRg3/sqwgV2J+kLZ0oXVSYqtE+GXHsgvfEhk6qNIQiqkLtxnUEboZ2aMerhAM+cZ9bgRObSHdIeI7CxSHLwoupY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QUl5s/oX; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QUl5s/oX"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39efc1365e4so559218f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504029; x=1746108829; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Hk5UBQTvuxPsQW0619Tu3I4qsqkftwTtmBE5Ybb85g=;
        b=QUl5s/oXssI3CA9Zv6AHEWlhpVFMyHtZas8B6TL3jaiF0qcC+p+JxsUOCu9n8x8Mbj
         Apiev7Re4kRiAkT29YZyMhagcy5hXAPSXiwcq6oii/FYY612hEi6ADlgwNkFroWRH1FG
         p2mh0RhezF4LdCGORbTdy8RdkTCrv6RJ4AvE7oZhFxxxZzPt4Flrar5A7kryJSc+oWFb
         RIrk5tBK7gB+07lorhFsf7+55Wp7oNa1J5FJDB+v2Zs2P2Kig4p9efkFMht3zYzY+pNQ
         HaHy56BV77JkPlD6TFIqGxVm+pbdBOcXNcXFZjU+153je7+SsKwFxPt5qVC01iqBvzlA
         bVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504029; x=1746108829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Hk5UBQTvuxPsQW0619Tu3I4qsqkftwTtmBE5Ybb85g=;
        b=cnWB/f0mt3E+UYSwTtMoQcjQrSeZjRKi4gJLdnwl/P2HCSxyNavTdGUL+k1nak+wer
         iGmBL8vMlH/15kv2srYtDewlB/4TPeZSF3HvaAyjTrfJODY8YzVa/cnhHvirxBl0iF6q
         BiHpWINGsVnACkNkcxu3aN9W+ca4TFZ3tJkeRIBR5ikhdFuS7m42cdaSIHkkTDouUGD+
         Q2zr0Kov7MijoKVjIJrUa43E0d/yGKfvD4JtsHbWnO4iq+CnyyZnOW/KQaOzqbOmwgaB
         ScUzr4ocqX0FEcpuUXGG2T/jy8QWCHeceWLwbMe7x4p19ejgx3ddr+Khic6HrsUfGR6L
         h5hg==
X-Forwarded-Encrypted: i=1; AJvYcCUpV8QJSiL5o8B2neMxiDZeuP9oPN99vEsDiS29EvDyhRfVJkshuJkOuYjfhvJ/PyeW8uxkuz0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBGlTpmCmv15YALCDT70elOKVRIlvVfslgRNxD0mC/XDSwipur
	GUfRxJd9ULELEaPcf+S3ncFgkN24SsjIP4EPI1sSh6tbvO1ZzIOwW5pJStfwxfc=
X-Gm-Gg: ASbGncvMkGdO3NsNWq1sUiPA3eIjse7r4PuLdc4ZDCGV+ySED4t5X3d1q2qFCDGn33K
	8s+9tNBxo9rm+2COgXg0Ag6fnwQBb0TTaQzPwKxiYigbSCi9tJ7stdkJQn9YX7r6t2TcQh74KXT
	oeerWAXr+5AWDt8KkKb+TdaSrj55Elo9aujgMCj4uzUgpbUjrrVYF0AajKlwZSbIc/0gS8V851Z
	1ZWqnhSWoQlZQ6DixtY1TrXx5tuq4ZhGYizZ3zlTOv5N/rDfkFUm9beEuDBlAEwYGp/PwejrvoF
	MTlE9UgQXhousfyLdapvcl2IN0+6ZmxTfmTl6W3e6pICeOZHGYUnQ3XGxhXfpoXXfths+U/p93s
	LdjTGRMmL9whlBV1m+bVecrfm3rI=
X-Google-Smtp-Source: AGHT+IEX65fw+AuwIbm8DfCqVPIwMLBPu7X4mEmOAObvmlxgMqJT5rSe8ZZGCXBt4CgJFkEQIJbeNw==
X-Received: by 2002:a05:6000:1a85:b0:391:39fb:59c8 with SMTP id ffacd0b85a97d-3a06cf61418mr2487543f8f.25.1745504029007;
        Thu, 24 Apr 2025 07:13:49 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:48 -0700 (PDT)
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
Subject: [RFC PATCH 03/34] KVM: irqfd: Allow KVM backends to override IRQ injection via set_irq callback
Date: Thu, 24 Apr 2025 15:13:10 +0100
Message-Id: <20250424141341.841734-4-karim.manaouil@linaro.org>
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

Some KVM backends, such as Gunyah, require custom mechanisms to inject
interrupts into the guest. For example, Gunyah performs IRQ injection
through a hypercall to the underlying hypervisor.

To support such use case, this patch introduces a new optional callback
field `set_irq` in `struct kvm_kernel_irqfd`. If this callback is set,
irqfd injection will use the provided function instead of calling
kvm_set_irq() directly.

The default behavior is unchanged for existing users that do not override
the `set_irq` field.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 include/linux/kvm_irqfd.h | 1 +
 virt/kvm/eventfd.c        | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
index e8d21d443c58..7d54bc12c4bf 100644
--- a/include/linux/kvm_irqfd.h
+++ b/include/linux/kvm_irqfd.h
@@ -46,6 +46,7 @@ struct kvm_kernel_irqfd {
 	/* Used for level IRQ fast-path */
 	int gsi;
 	struct work_struct inject;
+	int (*set_irq)(struct kvm_kernel_irqfd *);
 	/* The resampler used by this irqfd (resampler-only) */
 	struct kvm_kernel_irqfd_resampler *resampler;
 	/* Eventfd notified on resample (resampler-only) */
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 5f3776a1b960..d6702225e7f2 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -63,6 +63,11 @@ irqfd_inject(struct work_struct *work)
 		container_of(work, struct kvm_kernel_irqfd, inject);
 	struct kvm *kvm = irqfd->kvm;
 
+	if (irqfd->set_irq) {
+		irqfd->set_irq(irqfd);
+		return;
+	}
+
 	if (!irqfd->resampler) {
 		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1,
 				false);
-- 
2.39.5

