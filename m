Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F723CFF6E
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682551; cv=none; b=ROAArTMRez5kGmgYFSCVlSVfmwqjqh95ys2VTcqxJII7PW0hO2jWaSblfQX9NQV2iHjlXGipSogVHq3ozs0Yq5dvlzbjycc526jqVHSbGhiZqntXxPZu7hfcvKpI5DEAy9WUqNfI7UCx0CUyer731vAnIxywAKjJYjp4iv7TA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682551; c=relaxed/simple;
	bh=ZKEWj50MRz8/DTqbCH4vOeWYqo9VuNf8xP835LwJ8AU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hK4ZmaBLxBdnkr7wbOvR3isojCg2UfdhYL0fxA08LWHICNFa5vBn9qcAG6kZM2z4dz6HhnQeExegRzx4zMOqALRXvNUBtBo7Xa3PgG//8yxoAWuTEyDhgA2NyAZ8EHZuXfhUwmFEtRx6lBDp0n4zJueiePFcuYA8oypwv3WjQus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CXfyLUT2; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CXfyLUT2"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b41d45be4so1078599f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682540; x=1774287340; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B0JuPFNs4DpwbGKwjvMOJ2DY/fNaxhc2eTovF8AJup0=;
        b=CXfyLUT2kB9cjWH4FWFvHlZonOFEVpspEiirtR7ky1gjPCRLkyuiHD9u4MjfL10jKF
         oV/5raCJBJF3xNDxQi4H140yLvyR2nLd003XeI0WMmpQ+QRv2KIfFVIzEiL7nkrmV4pm
         sWMyZXz1YTcP6NHu7YFxTMw3vUXUAXd+OZUrIgiG042GhnRpxD4fmPfgowmHCicO+9ZH
         W6vIr2QTyM2pB/R13CZi9A7amq5vHaJV68yRrUSr0iIqMeiv3cTV4vj0gSrsDuQqAqWT
         XR/j//DiOxNuR1ubZKdc0aD1MEQ/FFOANRA2+JtrcgM38rxh7naNbZ2bQsbYMeR7CTuM
         w9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682540; x=1774287340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B0JuPFNs4DpwbGKwjvMOJ2DY/fNaxhc2eTovF8AJup0=;
        b=MZQja6GwqdNVi7zq/iB6mqtFsljHiD5gIQFSBSEayVceKOOFN83zawD28LNcBVV528
         UZy9T0kxaloZBD3vxHAdJLy0SQ5LMPj+5Q4gNbVy9pdbAFwgstBprmwQhNytJFwub8mO
         oeUcupdasmTAFA+m9JmtodgtCnvILpba06kAAFAZsJQ3pH7mGXpeZa+Medr1rnOX+rEO
         kHe+lswAje2jCuLGYhqdJWApryWsbp2NZ/AItmM2A/RHXL6K/DYDhyGKyc6HwfvOQsuj
         /K5M7ePu9ME2GVH9auEqDIOYFEZUdUxsI6HABCSLOKkt+mNSTH+MhgG48Hi9jNQIboBF
         EZOA==
X-Forwarded-Encrypted: i=1; AJvYcCUFNb+XwkvnJPgg47sqOf6jhp7sDIL9InJZXUO0/FlAz2jn6Swc86Ac+B54xMn8BieSSlrF1RQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDl+lImzGJ0HEFmd5iWnxauZlOS3IzdP40U/Aan6vl+gd0JiYJ
	1+VVU4YUP5gpBD9cMpKngK1agyibOymE8DKPvQYWjoxuvg9PnHdvzluPmE+H9EM++8Q2MCirIhK
	Mkw==
X-Received: from wmbfl19.prod.google.com ([2002:a05:600c:b93:b0:483:27fd:cf2b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3e1a:b0:485:3428:774c
 with SMTP id 5b1f17b1804b1-4856eab522emr8252635e9.4.1773682539787; Mon, 16
 Mar 2026 10:35:39 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:31 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-10-456875a2c6db@google.com>
Subject: [PATCH 10/10] KVM: arm64: Use guard(mutex) in pkvm.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate manual mutex_lock() and mutex_unlock() calls managing
kvm->arch.config_lock to use the guard(mutex) macro.

This eliminates manual unlock calls on early return paths, ensuring
the mutex is safely released during early pKVM host-side VM initialization.

Change-Id: I902ab100f2deb4de7d6fbf0340d4aec30cf49e56
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d7a0f69a9982..4a4a9d0699c8 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -190,33 +190,28 @@ bool pkvm_hyp_vm_is_created(struct kvm *kvm)
 
 int pkvm_create_hyp_vm(struct kvm *kvm)
 {
-	int ret = 0;
+	guard(mutex)(&kvm->arch.config_lock);
 
-	mutex_lock(&kvm->arch.config_lock);
 	if (!pkvm_hyp_vm_is_created(kvm))
-		ret = __pkvm_create_hyp_vm(kvm);
-	mutex_unlock(&kvm->arch.config_lock);
+		return __pkvm_create_hyp_vm(kvm);
 
-	return ret;
+	return 0;
 }
 
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 {
-	int ret = 0;
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
 
-	mutex_lock(&vcpu->kvm->arch.config_lock);
 	if (!vcpu_get_flag(vcpu, VCPU_PKVM_FINALIZED))
-		ret = __pkvm_create_hyp_vcpu(vcpu);
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
+		return __pkvm_create_hyp_vcpu(vcpu);
 
-	return ret;
+	return 0;
 }
 
 void pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
-	mutex_lock(&kvm->arch.config_lock);
+	guard(mutex)(&kvm->arch.config_lock);
 	__pkvm_destroy_hyp_vm(kvm);
-	mutex_unlock(&kvm->arch.config_lock);
 }
 
 int pkvm_init_host_vm(struct kvm *kvm)

-- 
2.53.0.851.ga537e3e6e9-goog

