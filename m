Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5515217F42
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741347264; cv=none; b=Pxu/rJlWRy0fjHNvAu6xR7Ed5o8cVh2BKSVtc8qFwuvLvbbgy1E/qJahnBO8Zn4254ZiH0yE0g3Hv4tNK4Bzf5s/mHZu0RMifBfgGBjRmZhGuEupUq0xRe2Je95pLPyBTM8fUn4R5ot4i7v7LPEGmTWCwwWoobOuUDzqqxHqGKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741347264; c=relaxed/simple;
	bh=Ypd4dYU1ILWbsSeqw6wcgbXkF8nETMXbg0ZC/3Szgp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tO7c8xtTge9fThnNz0sEY7/5erqpSa4PgaZ16s/JzY6jyUmLrJg15i3zNwmksJgN+NRtuyBXLtkmFWfUv9GMQmGJioAUkOTzC9+Ew1HXSe4lzqhsfrHPlsZZmrjQfrlrBNAxEHdhZs9tRiEg/QUy7GAz4upiEN6/X5lHpKOE8VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XIj/C7fE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XIj/C7fE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bbfc1681eso7716365e9.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 03:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741347261; x=1741952061; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QuT8+oUGsBynEgnzcW+tCpFVQN9FB8Rfc7b2wdhbmiU=;
        b=XIj/C7fE1W/yJFTDW2WzuSbrr8bPQ7E/gzXRqasPWJcErdqyYUNrx9SseiH+ajv8ZG
         0hnbfOYu89KGmEmCgXAHDP46pFfA4HOP+Nxn4CvBH+px3eAW+2fS9DB/KszrKTNmS79n
         DioGTClo8zkjWTTTe0g04WWacp66rjEJgEWJ/+VAtOT7JhCsNNxKPu9EuqN6nq67vu8M
         /0Foue+09fuvCpFsIOxa5PDt+C1LwSNTL1PTvebYBPXBepndTlhxVyQ9J1WWeDO7C8MO
         gdwKcgbeQscDEcqsy5xQLQnnCXjZJRCy3rLUAHfBBUWhOx13jkFmPHqA8YHDRudnmgNx
         Hunw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741347261; x=1741952061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QuT8+oUGsBynEgnzcW+tCpFVQN9FB8Rfc7b2wdhbmiU=;
        b=I7iOy+CTTkTzpDBlDz7ETQQLucujs3M8BBBLRpFoaqL6tj+N602REPbpcj1rK9d2ej
         8HkNE9wSv5LEvao2uRGCwvDvRSmK/IXJ47sbS7brZvYaa008YSXDRPzvyniyAkE+A/QN
         +Z3WSGizr6B0Bp6ynveHzygxZgAOAGh2rrdxKKQsd9sAzhGw5P/1PUxFU/U4C6ZC4Nkx
         y8Ml+FgDMtSt1PNtyy8PHw638A7ZXvhNkGrhkoABLwzxwDbrSaRoGHLq54akwsnmRMWz
         wmL8DcPR5FEeJkvqNExygA0ZqM3z37QbppiOZDEO2tCyDfWfWVe48YB7v5cllRc5yG/C
         NxnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDfUjopTIihUPhx18zgDFhD4WnHTas8+QiSPlsZUGI5GoB5Ph+kiPCE7j46FMFXmVlWWYthZE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdsvSF4p8u+76botfacb+0gFhjkCp+e8S2KhiGFkErFInVEz7H
	IxsZMuW5JYQlEP5BtNosGgNtqvnOUQl04Sx4Lu6rA41nADZAxpx+xvBoOFG65uV2PECERitKKv2
	utLGyIPObuIHKfyfj3g==
X-Google-Smtp-Source: AGHT+IE5ohZTOn+0c6BjasjJlIh0P0Oc4mdAIR1nvzh8MTc0ThPVpUeGzQhz5Qwx85rHnQz0WNel/HDvkjZrlgFj
X-Received: from wmbhc5.prod.google.com ([2002:a05:600c:8705:b0:439:64f9:d801])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d01:b0:439:84d3:f7ee with SMTP id 5b1f17b1804b1-43c64db0d9cmr17578165e9.24.1741347261332;
 Fri, 07 Mar 2025 03:34:21 -0800 (PST)
Date: Fri,  7 Mar 2025 11:34:10 +0000
In-Reply-To: <20250307113411.469018-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250307113411.469018-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250307113411.469018-3-vdonnefort@google.com>
Subject: [PATCH v3 2/3] KVM: arm64: Distinct pKVM teardown memcache for stage-2
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
2.49.0.rc0.332.g42c0ae87b1-goog

