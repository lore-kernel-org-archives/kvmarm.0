Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146E117BB5
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 09:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706087439; cv=none; b=dViKxJ/BakLmhnSzL4DK1P7h/K0AtorPcDZkn7F7YNAIawyUEZEliyUtob4PphTQ7KRr64P2QslCAhOD32FBsn2wZUyxAeluNxOxouUCewjqmbMWYSkTx6MUaAbmX5ji1vuOIWe+4dRtvn1HeNjlchPZuMckHTgh030HigTR5Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706087439; c=relaxed/simple;
	bh=VbIlhMmrk27yNKtV56v+KJ/TtRK0LOiHjDYn+JraBwI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DryksBd2EA9uGuXP3HwOkcv0Onne7Hqd0i5v3hfBLMBu79/9KmjdfJN0sCxSMX9nIPvYuFC61AgxttmzOqU6FQNtMgijZF+JinVWH84gKx59Bzar06dmy5Gbn6q7NkjlZdm5idAcPDfVPWfYcT7EzjUXH4hor3OjD3exjwAvI8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z6yojuwm; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z6yojuwm"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e8810b5f3so51281855e9.3
        for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 01:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706087436; x=1706692236; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=azYCHPhWGygUAZtVjzOnMMNYpv2pTJPs25+3mFpcg14=;
        b=z6yojuwmmSmJgBUFabA/tNCY+AZkRJ8PMZjEfWOXqUNRSjdISv4JwZOSu2d30Ef9IK
         R8kzNozvcKFN/i/sZ7x2IQcr+8hkybGUDF9Ph8d0Ee9nCyavh566XRqoS0GEOAGmK829
         0NsqLyGc7HyxYghk75rBv3FPscv1YaPQutNJwbxtr+bOw7/eGU2oYAWhdeimtTXCiti2
         xJPG23fJkaxIEmzn1/qVTJqIBkD0GQSw0BNZEv0AkX+9zqK8m/wrSD7nne1TWiGTgB4Q
         3XLYXPNfZCmg25e+ngKTdeeyOxa56j53YzqSA4o0maEWlPBwCcNldfgIMlDJNqUEjA5W
         RWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706087436; x=1706692236;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=azYCHPhWGygUAZtVjzOnMMNYpv2pTJPs25+3mFpcg14=;
        b=PArgp8cczQk6TkWT2VJTuLPVf7Iy1lNAUOkCybhOkggNgWaiZcR9/7qAygc//O2P3V
         0g5mclayuyVeD2keNuArSQW6LWfOtgL8RtL8Yt7oPwtIycuIySAttEDRP7kiF8+cE0pZ
         oWf3WkvAGhbOkAIpvh/7IliWIXJG5ifopAhIs/2JRPzhSvN2TtB8Db1p2P0NlLarCfl0
         xjyUs9uBnoKOFwm4o0U8t/qy56QgMIbz0wC28ztku62/nuLjNq5JSoZ6i5YTrsMFXlU8
         JB+b68Qxi4NkHfbid4n39TBmOYhbDQbPSuBDqquOUsaxagLQzR9bPDYq8Kx/+bJe0Fe9
         RIEg==
X-Gm-Message-State: AOJu0Ywd5r7BloXHf2gsOqofnJxEgEAzM0LErks/Jfjz4PAnU3coTgyc
	QMeZq4ibZHF9UXorxs3Jl9wBwbsZ9cPAjQE4HHbM3zIaxUygTUcsDwCNDbZNN2J0HSFA8Tx/vcF
	m0IgH9LOQ0p44YfaS4onU22u0Gg==
X-Google-Smtp-Source: AGHT+IHQu8PSyX8X6hBs0OxdOvH6yTQqd8GMOA0f4B5GP1tHJaIbkkEvv2xekuxmDaroKhS0ZGfjPA1hyZX71dbNPJg=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:518e:b0:40e:c602:e37d with
 SMTP id fa14-20020a05600c518e00b0040ec602e37dmr8947wmb.0.1706087436115; Wed,
 24 Jan 2024 01:10:36 -0800 (PST)
Date: Wed, 24 Jan 2024 09:10:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240124091027.1477174-2-sebastianene@google.com>
Subject: [PATCH v2] KVM: arm64: Fix circular locking dependency
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
kvm->lock. The rule is violated by the pkvm_create_hyp_vm() which acquires
the kvm->lock while already holding the vcpu->mutex lock from
kvm_vcpu_ioctl(). Avoid the circular locking dependency altogether by
protecting the hyp vm handle with the config_lock, much like we already
do for other forms of VM-scoped data.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
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

