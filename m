Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944551E1E01
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606932; cv=none; b=p3pSo+7fmCbDbtMNn8qLg+WMZJxeW1cmWkI6nhGhWSdOAw2GqzOyFYvSp6YDZl9uo8uLLuRocN1oiPt7AFQaYpOzQiYesz3yhHzSBQhtWW9cXir4wgckmNvTDMvIl4ZQfsMV4a0fkv4+MJktHMEx4wxWDh9aIkHqDR+KOWyx8Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606932; c=relaxed/simple;
	bh=eSNif6f3pnWcOf2VRMm6i0cDDafYvrUektBzAWYDhaA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=buvnG73Ae+lhEqSpcywAl0iH9rKiJLkpnOcl7BFn1l6OH5gFi0xyqMNJZDFuLUQ3p+ULDblFQLoxsQ04gjX3Xs19bXYpCpfWiDpmlTJEL/pk4Dme6KMtUwxa8fdJX5qBmpY48uE+INO+qE40GgN5gif5gtRkR6ye+LzerlLsr1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4lQVfLQd; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4lQVfLQd"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e082a05744so198794a12.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606929; x=1741211729; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BlVLEjSuR40DJq8DeUp7Tn/A3CFsKq1qRgCr3BfZnrg=;
        b=4lQVfLQdSQGIF82Q5o/SsulvlGxEk4MVwgXu13pJ748OeNAznb5RzZKNUTA5lzsPlh
         cPPNQRj8wPHclnAsTqA8P2f1GVusZUgWaWRySEamMNgHwulDBlD7Jrsyk23NbLFQgYyb
         r8ZeLw5T8+k5T4SspjaSKF6GuIeowifZmQ2Q7q/0fkhjy27x1myvYvBCOmTWboOnqSLq
         FUAsW3KHLUujYy3fbpRWZ2HgOr0p5RN43hzxGSr8ZhELRhGEB4b7rATy+Z0Z8G2lFACM
         C0703qbOHi734OUUMLXrhDPpiihjc5yEKHeiH3zJwTv1/I5rPfNkdqeziy37qpGXJjQI
         huWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606929; x=1741211729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BlVLEjSuR40DJq8DeUp7Tn/A3CFsKq1qRgCr3BfZnrg=;
        b=FtB/CpuJUzZcKF+JtRB5lgyS6Nz5vdC6hm7oIisoWPSVqS5q4Nrbri9GCsl3oQm7Hn
         wpE+DLPZp1IOeMokTujRB8ZRlF8LvCye+ZnPPl+ww7/J98I7q3qQHiVCz/tqTZuRdkem
         9a8BMxNRa5E4bv8IbXUk9AzYT2E+AaaJ1hli5tPi0hynhhh8MbTWcYPB90DSHMVu/xU7
         F3nvpV8W3vTHAKZSqUjpcsGK2Yupwkyb7OYPcu6uFab6hWbulvBQdlthQXm/+NIZfueO
         Kn5v7dDBFmEP6oqHqkZpf6GyKDJ+FQE1ovjeibYbO5Km9OEBcJNQPnPc2tvknLRUIJOo
         Guig==
X-Gm-Message-State: AOJu0Yy0wmSA7r4mwZ1Hav0Moej3sOTQN75opfh0H/69+T0+PaWPiigc
	bSYc3zaypJ95Q41k4vdBk3EgGHVhj/gqC14lpax1cqOIbIkro9cnZSVx1UXoLwss/SsTveRayVz
	xG2lijF+u4apIvOo+zpy9Nm1s/1yFQn0D5v/r3HWkcJZICIuvcAoAEXOZOHxNctRxwcx0B3uY9O
	WrjEvNB++8GtZPAt3HD9yUGr8OonU=
X-Google-Smtp-Source: AGHT+IEddKLeb5DU9aLaMmqh8NRm6HKFBbipNbn6fg8v8hDnY6472Y5nLiUu15PYKstb25+YBP5pSMprRQ==
X-Received: from edwj18.prod.google.com ([2002:a05:6402:11d2:b0:5e4:befa:4839])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3583:b0:5e0:9ffa:1348
 with SMTP id 4fb4d7f45d1cf-5e0b70cb619mr23003688a12.2.1740606929001; Wed, 26
 Feb 2025 13:55:29 -0800 (PST)
Date: Wed, 26 Feb 2025 21:55:19 +0000
In-Reply-To: <20250226215520.1759218-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250226215520.1759218-4-tabba@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
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
2.48.1.711.g2feabab25a-goog

