Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF227F74E
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504039; cv=none; b=BThIC+cf3WP73FKFF++7eAg3X8lZOeMmv+Ls2BUIbV4c6V1E/EgaZCnfhmuf7n4ftQFLvKX9y9RPKDl6VP+ddGXywPFoYpHpteIGudeh8M6skHSE9elDrXmiiXasWo6QmM3kiioqKB1A8URKVkY5fjLuu/bSBtSeP6DJkuevQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504039; c=relaxed/simple;
	bh=pMsi9MMq97g7CjVTvZZzMUKV739tetlHWJOghEinxps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CMsHz6Zead52Xo5KEWo4QVVmvfuSpT/HSZ1ttyRUmK/LnafopDHcsFBHMezkCtf8pr41hbmkDhGXRSZXQlg9udHaZRrGeOvAhzEkLq3JogvAkTB4KmHFXrTj7cnXdoJkqCFlBV6NESsyf9NSuSx3yUkmDTDnnPJsmOiDrIzJx7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bCc/aBwY; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bCc/aBwY"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39c1efc457bso759127f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504034; x=1746108834; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S74NKpGFaVYOESsCH+rK4kh5DkFdas6Gq4YwtRp9OLI=;
        b=bCc/aBwYZrHs9dmNBqpcdTW4h/1d5AUZFmsTadFZcqhDYOJsKn0Y17ulJcs2uuv2Xt
         HzGud0eOlHZ57J1razeK4vDOrxZ9lH1ROsS6dtkoU9cLioPqanOdA0QNZS3we3WRcpjT
         zgc07DJRoc43f5Y5u3mWFfj2Ug+K+++4H7UBn6Q6OMRumLFvYS0TOa5B/5l3mfHQQS0+
         pnTZ/eeuOYO4Xq/ZtYAsTkIeNr9lBFa2CQoKZFIo4RJdaAluigmgeUow+3emX5t39BLM
         /eOJkE20GAWub8Dd0iqpuHDUm/xa1h4EnsrOKjgqw0IZoLYKEA+lLkB1WPXkHtG5gV5C
         /+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504034; x=1746108834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S74NKpGFaVYOESsCH+rK4kh5DkFdas6Gq4YwtRp9OLI=;
        b=jj2BWhCXqiYC1SUee+pmYoUq2/n7BdJzZf8tyUhzx3ovfe8/NlljyZxiH5KMaJU1NR
         Z1XebDAQWsjVKZS2QMyymLqVMEhOUT4qeB9iNsrY1pqvT0re+0FVih2BXEW512P2oQkV
         91phyjALDhnJMW0gNuhiKcb7Ro0WPr1dD9wieI4zhL/ODZLT53njWWN/B6a/mccX/g0n
         bWme62kNpKapgSJ0m80cqxd8VhW/P6Sc3f+P/rGimghwzj6T7cCP8MoFdmo2+VhA8UWB
         QMHbcQPSdd3nHIaz6mZCumYd9FAHzlw8XhmH1n8PPq221jdec05m/nlSyTvQBx+VA7xW
         Mg/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHI1+csdPXjVplOhY00PgN2gdU0gLUvaTMfnPT0rJcp+fzZ8aZUlZ/uS2Qux4RLYRJS5um/X0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOLNwMyMm93o2tp5AgXwg0xvt3iR0pQofEx99CUReY2QeXIvxZ
	NINqpKKTBQGCPHinfqidCN/J6ewerW/uBF7oi8m8MicgtyfxWbzifEO0oS3jxWQ=
X-Gm-Gg: ASbGnctWK1SxWbTA1vtV3NMe35OcgEja+ei2sBepbfgervbkAMeuxtzI7WYKQ1fMCHG
	b0x7XXH/znfdEh1AoEMXXWgaHB8wxMaDo3z7DD13mAsxl/T/HEaMA1lAlxaYJIdU7xMzbX394Fa
	oZyf8dOklOY/2Y/mQiZZeMNOVxcKVVqOle3J1V4ic3bmXYgLwaQjo3Q1ePdufu4xCWcWY1s/Nqx
	XQjkzbY6jUcQhOHyJf/xCFw7rutGj8wl4bZDj7gbVZcSjOjQ/z2ow3SL4CM4zceU4sAja24KZlS
	u0Y3dXEu2Eg/qNlwCr/Yla6to+gVYEUEXlnnFGxtdTHEX1wTJJ9/rfmxFWRRmJW4AsR2S0AW1FN
	4vZoviPUgIyimd/PM
X-Google-Smtp-Source: AGHT+IHx9bXGbc/XwzdBX2sEvhGOWsNMsxK7elP9ZHfuoFqJa71fFuvenAr2zCrjXuMcvE5wd1GoWA==
X-Received: by 2002:a05:6000:290d:b0:391:3b11:d604 with SMTP id ffacd0b85a97d-3a06cfa9d47mr2143588f8f.54.1745504034133;
        Thu, 24 Apr 2025 07:13:54 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:53 -0700 (PDT)
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
Subject: [RFC PATCH 07/34] KVM: gunyah: Pin guest memory
Date: Thu, 24 Apr 2025 15:13:14 +0100
Message-Id: <20250424141341.841734-8-karim.manaouil@linaro.org>
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

Qualcomm's Gunyah hypervisor allows to implement protected VMs, in which
private memory given to the guest is no more accessible to the host (an
access violation will be raised if the host tries to read/write that
memory).

In the context of protected VMs (aka confidential computing), the consensus
to manage this memory is via guest_memfd. We would like this port to be
be based on guest_memfd. However, for this RFC, the port allocates
anonymous pages, which are subject to migration and swap out. That will
trigger a violation if the memory is private, which is the case for most
of the guest's main memory.

Since the memory is allocated and given to the guest for possibly an
unbounded amount of time, we longterm pin the pages to prevent the
kernel from touching and possibly swapping or migrating those pages.

In upcoming versions of this port, we intend to move to guest_memfd.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/gunyah.c           | 68 ++++++++++++++++++++++++++++---
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index efbfe31d262d..9c8e173fc9c1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -229,6 +229,9 @@ struct kvm_s2_mmu {
 };
 
 struct kvm_arch_memory_slot {
+#ifdef CONFIG_GUNYAH
+	struct page **pages;
+#endif
 };
 
 /**
diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 0095610166ad..9c37ab20d7e2 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -660,11 +660,47 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 {
 }
 
-void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *old,
-				   const struct kvm_memory_slot *new,
-				   enum kvm_mr_change change)
+static int gunyah_pin_user_memory(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	unsigned int gup_flags = FOLL_WRITE | FOLL_LONGTERM;
+	unsigned long start = memslot->userspace_addr;
+	struct vm_area_struct *vma;
+	struct page **pages;
+	int ret;
+
+	if (!memslot->npages)
+		return 0;
+
+	/* It needs to be a valid VMA-backed region */
+	mmap_read_lock(current->mm);
+	vma = find_vma(current->mm, start);
+	if (!vma || start < vma->vm_start) {
+		mmap_read_unlock(current->mm);
+		return 0;
+	}
+	if (!(vma->vm_flags & VM_READ) || !(vma->vm_flags & VM_WRITE)) {
+		mmap_read_unlock(current->mm);
+		return 0;
+	}
+	mmap_read_unlock(current->mm);
+
+	pages = kvcalloc(memslot->npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	ret = pin_user_pages_fast(start, memslot->npages, gup_flags, pages);
+	if (ret < 0) {
+		goto err;
+	} else if (ret != memslot->npages) {
+		ret = -EIO;
+		goto err;
+	} else {
+		memslot->arch.pages = pages;
+		return 0;
+	}
+err:
+	kvfree(pages);
+	return ret;
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -672,11 +708,33 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	return 0;
+	int ret;
+
+	switch (change) {
+	case KVM_MR_CREATE:
+		ret = gunyah_pin_user_memory(kvm, new);
+		break;
+	default:
+		return 0;
+	}
+	return ret;
+}
+
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+				   struct kvm_memory_slot *old,
+				   const struct kvm_memory_slot *new,
+				   enum kvm_mr_change change)
+{
 }
 
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
+	if (!slot->arch.pages)
+		return;
+
+	unpin_user_pages(slot->arch.pages, slot->npages);
+
+	kvfree(slot->arch.pages);
 }
 
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
-- 
2.39.5

