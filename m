Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3994C85C7F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 16:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706028520; cv=none; b=ln6hNFuccRCceavj1gimer1jEresLWikBfYpcA1a6Z8vcwGnkGP7wGR7mXZ7/FFWIzdwtgiDBLopnX/CubPnmiZ82GWREf9Rd74e5JPDi/TC5zAdIkpbwvbvLrHtE+FliYL67qf/oHF/AI9w0vsOeRBnp30RCyDQhHVTPJGxWNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706028520; c=relaxed/simple;
	bh=xeMH/PTY9RvVC0crS+oE1ldLHgl6NeMg+38kZCLwc40=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SVUD/+kD+pCN1EFw7lFejWBl6nwz0irSDO49tAKlJG95MlqDUW7NVWk74MwwOO6ftbnKLXkg2D9vEfEZeOVZFel2FA/hDrbfshvaZK3mNx4EsYjxmH9PxwujoGU/H0oB2hCqhDo98mOOA9sBlhDfEZXqBNYDNoOn4uS5H5kwhOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U77jnj3i; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U77jnj3i"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-40eb6ce1ddaso8550005e9.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 08:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706028515; x=1706633315; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OBfCCDyzKoRpaf1abp6hy1jxU0Vk3dNquTbtYZnKWbE=;
        b=U77jnj3ircuTkydM1n4NQymFCLq6QZiXAvlJNwfsXef8EMv49tXwIKn/O808lzdQ0V
         noCYvSUWeYjngwFil03oQpeHQ6efZiSF8ETiQgovgwiDiQIegu6YNBB5Owr+Roy4kbLR
         7EJHQ4KMRWt8z6q87B4kM/AYNUfJ3sKcsl7JfJIlsf/orDrENNcdnIWS9SRyJ3J6RojW
         3Ims+yA0xFmsYjgQIUJaDsDo160VGa2X/XHMAgdN6Ty5s2IMXcRPZkHvqxD/+zy8GgnH
         dupoRX9r8PysXBknhanNeG7OEwkWSQN4z6SjU6KU57zLEhArJg1Vnt4EiRmarUqCyqPf
         /j8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706028515; x=1706633315;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OBfCCDyzKoRpaf1abp6hy1jxU0Vk3dNquTbtYZnKWbE=;
        b=d61TX7WxsYcJqQrZ6cUuDJJo3CJBud6bR3fOaTDp2KEGEYHLgpvhi8Z5TQkW6PuCR/
         9uwFvCPgl/RhDyU0ovFnqKqUInXOdb9uuSVZMOXGP6bYNLt/+8vn3/OJNydL/Gn1/39w
         koZsvzszfhe+LEuFuEGNU5BkxLMPCtZ7axwkBnl4FprIMXm0h4Y/JCDpFOJrtkkthQuN
         5mgp6CUMH5A1WJbM27VgGyoV5CM6LLnh3ctT4R3u9TOZ6qlt3whS63ydJTylyNEFcKI3
         nIrZas6zD2+GCcRa0elPds48y6VaZ49m/vkNzwyHNB4A3LHJ5cNkp4EGwsbUKNUtDTM1
         eWMg==
X-Gm-Message-State: AOJu0YyW3XJ1IIpA2LAwFpOS/XWTsqYbEJL9xhr3w+bK+sxbagIUGDnV
	AKgyBQFZ93oJcnPvafXY6VT832qiKo7V6Qb4xqogIA4Z6niQ2dsGkt2eZF6SH+Ft9RRMMrVP9fQ
	uZACqyLjGqVmGhVlEM2JyXJPtEg==
X-Google-Smtp-Source: AGHT+IH+Mlr6tHRfY6bx2hXJSMKsnWPJRGl4NYKa0sp9VUfpgnmD9gh0uN5EJJTqznNM7e5Ct5DDTXdfW1jXBoCyNNc=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:4e50:b0:40e:bf1e:9e84 with
 SMTP id e16-20020a05600c4e5000b0040ebf1e9e84mr17364wmq.5.1706028515271; Tue,
 23 Jan 2024 08:48:35 -0800 (PST)
Date: Tue, 23 Jan 2024 16:48:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240123164818.1306122-2-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Fix circular locking dependency
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The rule inside kvm enforces that the vcpu->mutex is taken *inside*
kvm->lock. The rule is violated by the pkvm_create_hyp_vm which acquires
the kvm->lock while already holding the vcpu->mutex lock from
kvm_vcpu_ioctl. Follow the rule by taking the config lock while getting the
VM handle and make sure that this is cleaned on VM destroy under the
same lock.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/pkvm.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8350fb8fee0b..b7be96a53597 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -101,6 +101,17 @@ void __init kvm_hyp_reserve(void)
 		 hyp_mem_base);
 }
 
+static void __pkvm_destroy_hyp_vm(struct kvm *host_kvm)
+{
+	if (host_kvm->arch.pkvm.handle) {
+		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
+					  host_kvm->arch.pkvm.handle));
+	}
+
+	host_kvm->arch.pkvm.handle = 0;
+	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
+}
+
 /*
  * Allocates and donates memory for hypervisor VM structs at EL2.
  *
@@ -181,7 +192,7 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 	return 0;
 
 destroy_vm:
-	pkvm_destroy_hyp_vm(host_kvm);
+	__pkvm_destroy_hyp_vm(host_kvm);
 	return ret;
 free_vm:
 	free_pages_exact(hyp_vm, hyp_vm_sz);
@@ -194,23 +205,19 @@ int pkvm_create_hyp_vm(struct kvm *host_kvm)
 {
 	int ret = 0;
 
-	mutex_lock(&host_kvm->lock);
+	mutex_lock(&host_kvm->arch.config_lock);
 	if (!host_kvm->arch.pkvm.handle)
 		ret = __pkvm_create_hyp_vm(host_kvm);
-	mutex_unlock(&host_kvm->lock);
+	mutex_unlock(&host_kvm->arch.config_lock);
 
 	return ret;
 }
 
 void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 {
-	if (host_kvm->arch.pkvm.handle) {
-		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
-					  host_kvm->arch.pkvm.handle));
-	}
-
-	host_kvm->arch.pkvm.handle = 0;
-	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
+	mutex_lock(&host_kvm->arch.config_lock);
+	__pkvm_destroy_hyp_vm(host_kvm);
+	mutex_unlock(&host_kvm->arch.config_lock);
 }
 
 int pkvm_init_host_vm(struct kvm *host_kvm)
-- 
2.43.0.429.g432eaa2c6b-goog

