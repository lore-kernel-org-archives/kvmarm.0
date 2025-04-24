Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B26B1A072C
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504030; cv=none; b=j8ePKOa8aujVBYglAHZasWTAaiawy0wFqZrXJdIVUGnMNqNzKZT+1wkoI7RgSGaxmT4q8bZCfTTQFXQPaaRJW7jLu8F4vnoNdf2P9W9CACWnrYO6oHTD3TbWneokNiCBW0Zok6oNfAwWK571vPf3m5AyRoFYWjaDs/G3LFABZ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504030; c=relaxed/simple;
	bh=g59SsG0N84wb4f6piJJJcigRQ9wXVyh8p4R6BkHSxiU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s5kFjecHTJr3xP2COsbnIBAu68og4eusBJ+P4DU53LVfwEHYvd0Ciuu3DXoVu+xtlHtlYrsPyqqjuC6PKQkJh2wvTDbQk/0Uw2RUvEt30YwTNhknMFzsSVFfg8KDEcIF9XC31/yVQa3KCjhFN/xA2bUSG0vMREClPbINEK8o36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gmMsib9V; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gmMsib9V"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39c1ef4acf2so877352f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504027; x=1746108827; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pJfw58KOVJlcvsi2YwD0da6h5VnpsCyDZ/he/rc1kk=;
        b=gmMsib9V1qQdIbkUCR8/klhR1j3CfUFi/npxSSC4L9GWaDoYilmE+C85UNMijit/D2
         WIW3C+v06NhTKuZ93DP1v9fiCzWQFIW+280UwDbsD8u/18FZ+YQfbRsboO20LfXznrb8
         cUlo1aQMzeudgvSY56M8mFi80t7wZGxOrogVCB1c39f07/+6/oHWtuKjgiHkZa28XSzJ
         njQXhvODwy8hkMAyWZfzzcDES4376j+nPdul4ViJ9NiCs0yNm1p8fpfnbcCf0BEEbt2Y
         jtsISfDkQbqhnwZ54VZJhHST7xDb3vpGtgMlKpaMZ+J9VA4nRE0OK5tIKy60LBpRDFjy
         t9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504027; x=1746108827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pJfw58KOVJlcvsi2YwD0da6h5VnpsCyDZ/he/rc1kk=;
        b=IA1QziJOlfmUnIoCvyxKd7H5y8QbmXMPWqQe0HHlzJyoUwJ7yPYVpXH/4xvHBWPTDo
         sUDF+zjueq47c+tgFasphqHz1aP3c5s24mcqYXUD59VsFoYGhP0p1PUBKmPAJON3ATEI
         0OuBD8cNd/wp3qS92yYuHl3yhk99fkhnfQ7DUpkscduCAGtqQ/zIX/nkh5XuX1iAOWCF
         W5AVHZm8SKzLGWb+XUn+PBM8bttS5cw7sLHc2v30BgCNj8a28r3p3dTUSR5OJ6kkRQlP
         VXStdU5ByxmHB2pr6wHtVzP4syj/ZWHNP3i5xFiH+KhbSNsjrCm9jsEbGr8iOuwzNptJ
         czCw==
X-Forwarded-Encrypted: i=1; AJvYcCUyzudl9AytxF9oMKlZAZkCAqV7C/OI5h3pBHtdVLTdQq2d6y3dlwcz7z3eTlFJuSvvx9WM8KE=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywo3BsMVCYq9DILJHv34+tVjJYkIXXVbch6GUMoAriaUYWmUsOs
	qYqTAbIW38GwbfbUoFTt8zJl8uVpRBVkkCyGFc1UyBxzuug6I+VkuEDRVLsfmI8=
X-Gm-Gg: ASbGncsKYlSyGTHf0AE2Ovo5nwhjHuokyrL7U6s3CWPadKjAfA+Gt405T0SGQipMbic
	TjvWDyeL5IEB+RxG8kQ7vONBJprIXtDSVb+dFMzgmzIJKaFYoxNa6vlQRpfKkl13PDeSK4Vajc7
	4/ibD2WhypjMtKilOT+eAyFzMgDEra09vRQ+C369BPHe0gyy84OwsVfk443M9lMe8tsMbS1wAQo
	k6GUt4vzbsYsNVM5UsLqx/Y5vbBhqGMb3elUAeXa0jP0enO67hk05FUV1c0g+yGUBCuET19l5bz
	O+BZOBrGB/KjrJwWkIXTeXTYOE5LeR84LjLMSz9yi8EDbsjUNyxFPmYb/wxrQ/TY085swzRFtaI
	wr14SkeXBsIEjV44c
X-Google-Smtp-Source: AGHT+IGfRrIJRrexUH30juVxzQxuzQYHkS7hGTbMmJLV2Lp0+vmOpc/tkASkqUk2GbTXQepziYNH6A==
X-Received: by 2002:a05:6000:2510:b0:391:304f:34e7 with SMTP id ffacd0b85a97d-3a06cfab9abmr2560733f8f.44.1745504026564;
        Thu, 24 Apr 2025 07:13:46 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:46 -0700 (PDT)
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
Subject: [RFC PATCH 01/34] KVM: Allow arch-specific vCPU allocation and freeing
Date: Thu, 24 Apr 2025 15:13:08 +0100
Message-Id: <20250424141341.841734-2-karim.manaouil@linaro.org>
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

Gunyah KVM backend [1] requires custom vCPU allocation to associate
architecture-specific state with each virtual CPU. The generic KVM
core currently allocates vCPUs directly using the kvm_vcpu_cache slab,
which does not allow architecture code to intervene in the allocation
process.

Introduce two weakly-defined functions, kvm_arch_vcpu_alloc() and
kvm_arch_vcpu_free(), which default to using kmem_cache_zalloc()
and kmem_cache_free() respectively. Architectures can override
these functions to implement custom vCPU allocation behavior.

Replace all direct allocations and frees of vCPUs in kvm_main.c
with calls to these helper functions to allow arch-specific
substitution.

This change is required to support architectures such as Gunyah
that must allocate architecture-private state along with the vCPU.

[1] https://github.com/quic/gunyah-hypervisor

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1dedc421b3e3..3461346b37e0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1581,6 +1581,8 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
+struct kvm_vcpu *kvm_arch_vcpu_alloc(void);
+void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69782df3617f..dbb7ed95523f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -476,7 +476,7 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	put_pid(vcpu->pid);
 
 	free_page((unsigned long)vcpu->run);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
+	kvm_arch_vcpu_free(vcpu);
 }
 
 void kvm_destroy_vcpus(struct kvm *kvm)
@@ -4067,6 +4067,16 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 }
 #endif
 
+struct kvm_vcpu __attribute__((weak)) *kvm_arch_vcpu_alloc(void)
+{
+	return kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
+}
+
+void __attribute__((weak)) kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	return kmem_cache_free(kvm_vcpu_cache, vcpu);
+}
+
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
@@ -4103,7 +4113,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	kvm->created_vcpus++;
 	mutex_unlock(&kvm->lock);
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
+	vcpu = kvm_arch_vcpu_alloc();
 	if (!vcpu) {
 		r = -ENOMEM;
 		goto vcpu_decrement;
@@ -4182,7 +4192,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 vcpu_free_run_page:
 	free_page((unsigned long)vcpu->run);
 vcpu_free:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
+	kvm_arch_vcpu_free(vcpu);
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
-- 
2.39.5

