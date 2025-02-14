Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE652264A61
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 15:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739545387; cv=none; b=ISTFTSZ07XPSrAuvZcFNSeJ9FIzcGmvII3FruH8NirzZQ0rzFl44txTjXhLv65HZz4BjkFWtR3wYgFSNhc2KRJPFd3NCTmyRhtA2LFqzoG6JPlaDlS0+/Xg0yAGva+iwdK17dtFmztTvL6tE9IkCeA8J8qQj8nKj48MXB59A5qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739545387; c=relaxed/simple;
	bh=nyUcA4QgHqNAzCJJzzq9GnzlxEuhzEDEV44OGGmB/h8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s8+R/O/J2oOlYfo+uC0rX83dAKUPe828UvSrTqFfa7ivM/z0OFpxn39x8hXrAidtOGvXnYIHWRlsar5Qvr3kaDBIQJDOj9fNKzeMOE/UuXDmuFwGJ6h00d+vGMUR+mF25qg13wtNhSOn0AUSgAAThse10NREZkPhQUYZzprn7+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KD0A+BUw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KD0A+BUw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4393ed818ccso19353015e9.3
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 07:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739545384; x=1740150184; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRj6n4bTixP89CvsI9ePKxiWL1iNoVj4jU65kUD8C5I=;
        b=KD0A+BUwawAu0dN+OwPy74tE8w6kg/ZP37cAQFgiJgKHVP889PX/DBuM0j8SJT95yI
         8NQkh1VMrfWsDTtPO1eSQT8BUfG9Bh4kI0RugiDs//FJ97n7xvRWQYmkNMEE4QwsE36l
         KiOu7S85igew0zWSZq2YLRwChGu2sKI/L4hqRgguAPl+ahIaag84FKUh3XvolgxGFnLm
         v817vQzFuWUYPvVaECbJFVrb5rsmOAo/WCVIofBryEccfxQbSsOCONSrWWEsBgEBBHR6
         KG+bGLJMxCObT3p1U+fCq3+Jr6rnN4ezGXi/sSj0/B7EpdmHPnUdEf95Hctg6lt9XYJ0
         ximw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739545384; x=1740150184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRj6n4bTixP89CvsI9ePKxiWL1iNoVj4jU65kUD8C5I=;
        b=pZFbWIxg1Xq6bx4i/JIQoDr6CKM+S8W5rKwp4ud0uxCIFZV5dz5fRebfNx1BsQSAJX
         dFA5bX9f4N3Y38nrq1Fn2bIFQdg+FsX8XNQar4eQ4SquHKQT+OTOVCjgsuRfjKL9BDSh
         Hxme89fVTrwJt9eASfZ6/8fHiqC8AcxqMYtUSPlP/rzk6KHZi4hlf7g5VRzUSo5uxvAN
         2CWoG/8FpKi1Hi2+7g59g7j6Xqy1Kgyqx4zqQdxA5mVji9W//l5mopDMQhRrafvaUjm7
         4uU/r4L5ZadF14lW9k9d/qiMg5mQiLf5C3vUF1BHNOw0ZNCLzToxVseHW1N2jRk5IKES
         Yxhw==
X-Gm-Message-State: AOJu0YzxhlbVc4FQibuDNlm2JVlqfxIXrjA/Mc/asg9nNlx7lWB38uZo
	2vZ7BzvJaj/caMJI7vWA+Lxk2cTaegpQJVxfRw+kWjNGqQN5Bns6hZUloZgq3vbY+bSZOkkujdd
	GtvbiTUu5YpjSzeQZlYh04wc9B73CTheOxRN5bAgb7CjCC4lirPHcaFfbnbcrhf00C1H+7QgtMF
	BIfYYRgyHGDaR1vu/rUyZUaY6wmGE=
X-Google-Smtp-Source: AGHT+IEglSW2EtsSFVf9fcOIM3+3aUm0nM7Eie3OCOuC5Vt/mpe6XmW6SWFeotwZzhcO5dPAfS5CWFuKYw==
X-Received: from wmbfk5.prod.google.com ([2002:a05:600c:cc5:b0:439:62f3:846e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5489:b0:439:6dba:adfa
 with SMTP id 5b1f17b1804b1-4396dbaaf94mr4872045e9.19.1739545384118; Fri, 14
 Feb 2025 07:03:04 -0800 (PST)
Date: Fri, 14 Feb 2025 15:02:57 +0000
In-Reply-To: <20250214150258.464798-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250214150258.464798-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250214150258.464798-3-tabba@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Factor out pkvm hyp vcpu creation to
 separate function
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Move the code that creates and initializes the hyp view of a vcpu
in pKVM to its own function. This is meant to make the transition
to initializing every vcpu individually clearer.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 48 ++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 930b677eb9b0..06665cf221bf 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -113,6 +113,24 @@ static void __pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
 }
 
+static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
+{
+	size_t hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
+	pkvm_handle_t handle = vcpu->kvm->arch.pkvm.handle;
+	void *hyp_vcpu;
+	int ret;
+
+	hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
+	if (!hyp_vcpu)
+		return -ENOMEM;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, vcpu, hyp_vcpu);
+	if (ret)
+		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
+
+	return ret;
+}
+
 /*
  * Allocates and donates memory for hypervisor VM structs at EL2.
  *
@@ -125,9 +143,8 @@ static void __pkvm_destroy_hyp_vm(struct kvm *host_kvm)
  */
 static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 {
-	size_t pgd_sz, hyp_vm_sz, hyp_vcpu_sz;
+	size_t pgd_sz, hyp_vm_sz;
 	struct kvm_vcpu *host_vcpu;
-	pkvm_handle_t handle;
 	void *pgd, *hyp_vm;
 	unsigned long idx;
 	int ret;
@@ -161,33 +178,12 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	if (ret < 0)
 		goto free_vm;
 
-	handle = ret;
+	WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);
 
-	host_kvm->arch.pkvm.handle = handle;
-
-	/* Donate memory for the vcpus at hyp and initialize it. */
-	hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
 	kvm_for_each_vcpu(idx, host_vcpu, host_kvm) {
-		void *hyp_vcpu;
-
-		/* Indexing of the vcpus to be sequential starting at 0. */
-		if (WARN_ON(host_vcpu->vcpu_idx != idx)) {
-			ret = -EINVAL;
-			goto destroy_vm;
-		}
-
-		hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
-		if (!hyp_vcpu) {
-			ret = -ENOMEM;
-			goto destroy_vm;
-		}
-
-		ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, host_vcpu,
-					hyp_vcpu);
-		if (ret) {
-			free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
+		ret = __pkvm_create_hyp_vcpu(host_vcpu);
+		if (ret)
 			goto destroy_vm;
-		}
 	}
 
 	return 0;
-- 
2.48.1.601.g30ceb7b040-goog

