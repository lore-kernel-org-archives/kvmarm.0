Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D272046B6
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 13:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741095838; cv=none; b=QdgvmD31lEZMpt9yAA9V4yobbe0+cdJ6LlMjZmDK8JnyWYZTuvv1dj3izwysUxcOKkcTb2o2mKLD6YAj/CbLeIJnHpwQEf5y/9j2h+YL/8p2bL7ZYoIaZudcG8JdvVc2OmGa6SS9Z+76HRjyo3/uN+9nJSQUMl79NSIQ4EZqcWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741095838; c=relaxed/simple;
	bh=9Cw1IH7xoxtLsb0KLmFRhEqUvO2U41ms9Pgb7VR+2vE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XTELgW/veTlvmOs0Ca+goGLnb1m0Pbt4wsXel6+Xk6fbnCiJ2TF5Ri2bZO1lOEHGpSaz6IdqYfRRiljtrZHLXgYKwLnB1AvgeikevaP/1BkBNk0WLK2ZQJ0sPkJKpVQusBS4ASGGnUsljUijrCDC+yAUjKXQ1omdKd5WWUVsO0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x6aXlv2j; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x6aXlv2j"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43ab456333aso50888365e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 05:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741095835; x=1741700635; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aJwR7NM7qgJyDoaMyIjmipwZ0p8zhJtFWoNDi35Q6UY=;
        b=x6aXlv2j4n9HxE5YJEWYIrnPvmF/tLSkEvf7gow2pCiP68rr/wCE22fxB30ZLpzXd6
         u/PNYdZH6cxzVEQqZ7J4GbKRYUjsVGIzdFZbJLegLHjW1AgOQiNPI/0oYpPU/reGAOAg
         tMEKKa7rrV/2Us999pzGXYR1Yfjz9SrC8gXXsk6+jWDTuAbVAngn2vTBikVwT5w5vxty
         VyD54JNGzsxV8rMlYFsnPwzdyb0dPG4bR3qvF8QiKY1LsGBFsYoOLAqdXiKx1YSVoGf6
         rO3q3VB2XjV7nLiIf5GExbSqrnhvQi3ZtmRONDf+ZGu5dU6J4dUQonMgT49wAYhd8LaE
         lRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741095835; x=1741700635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aJwR7NM7qgJyDoaMyIjmipwZ0p8zhJtFWoNDi35Q6UY=;
        b=iePEj24wvyUhrNwoiv5yaX7+PPP78O9viDk5nvXhFiEC31wAt8NI+H7cnPTy0qWUQu
         ceOF4+TE1uooNXi+VaQnG5hO+1NvLR/YK7kjQoKEOeaDiIhztJVOgR4nml8XyQKFSjRu
         +8eCmTu6VnHSxuUQMOipwnK3Tgu8Wu9/U4CHiO9ywLgU+uYip9r5zIo3voXUATcU8Gy6
         F5ZysS0HeHao6lD6SmF3sG0bpIFi6jgVXGSaN7ZDLl3QX4qaIXR/yBeXRO4IZbQ/dPO0
         S+9pxEn/T1dho9RHpolnKZ36iUuV+xbZg4/jaKA8wc2U5/7rq4qDjT2ITq/rnv3p91/Y
         hFZw==
X-Forwarded-Encrypted: i=1; AJvYcCWBLSQe8qCvSViIhwtSp8V0JXqU5o6ONU+kAGAfrM6lWQcJBQk3atW3BcSU380hVDnjZzWuPaU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNOOGihwakwUK++rqFDn5n9DRU/WPn1nSUoMQP/lzb4fO97lv9
	0EuZIYMh7rc8gOHAU8gHYrNIpQ8E81V6sl2qOHqIk8HtSM0fRRXbvigOB4X9hWPCs5ADlSWFHYm
	Fw0E4XO9SdJS6cVZvfw==
X-Google-Smtp-Source: AGHT+IHuciObnyTqS58fROBaIT+QoD8DEu2FY6Ra9IE8fIz0oz/Si6xHw1earUtEBbeoC9ZyaeZgeRKxDyWAOb/F
X-Received: from wmbay1.prod.google.com ([2002:a05:600c:1e01:b0:43b:c9a4:5137])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3ba0:b0:43b:cbe2:ebeb with SMTP id 5b1f17b1804b1-43bcbe2ef02mr21962745e9.24.1741095835455;
 Tue, 04 Mar 2025 05:43:55 -0800 (PST)
Date: Tue,  4 Mar 2025 13:43:45 +0000
In-Reply-To: <20250304134347.369854-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250304134347.369854-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304134347.369854-3-vdonnefort@google.com>
Subject: [PATCH v2 2/3] KVM: arm64: Distinct pKVM teardown memcache for stage-2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In order to account for memory dedicated to the stage-2 page-tables, use
a separated memcache when tearing down the VM.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 12691ae23d4c..ace3969e8106 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -246,6 +246,7 @@ typedef unsigned int pkvm_handle_t;
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
+	struct kvm_hyp_memcache stage2_teardown_mc;
 	bool enabled;
 };
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3927fe52a3dd..15f8d5315959 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -678,7 +678,7 @@ teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
 
 int __pkvm_teardown_vm(pkvm_handle_t handle)
 {
-	struct kvm_hyp_memcache *mc;
+	struct kvm_hyp_memcache *mc, *stage2_mc;
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
 	unsigned int idx;
@@ -706,7 +706,8 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 
 	/* Reclaim guest pages (including page-table pages) */
 	mc = &host_kvm->arch.pkvm.teardown_mc;
-	reclaim_guest_pages(hyp_vm, mc);
+	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
+	reclaim_guest_pages(hyp_vm, stage2_mc);
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->nr_vcpus);
 
 	/* Push the metadata pages to the teardown memcache */
@@ -717,7 +718,7 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 		while (vcpu_mc->nr_pages) {
 			void *addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
 
-			push_hyp_memcache(mc, addr, hyp_virt_to_phys);
+			push_hyp_memcache(stage2_mc, addr, hyp_virt_to_phys);
 			unmap_donated_memory_noclear(addr, PAGE_SIZE);
 		}
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 930b677eb9b0..19921ca407c6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -111,6 +111,7 @@ static void __pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 
 	host_kvm->arch.pkvm.handle = 0;
 	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
+	free_hyp_memcache(&host_kvm->arch.pkvm.stage2_teardown_mc);
 }
 
 /*
-- 
2.48.1.711.g2feabab25a-goog

