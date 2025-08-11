Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198C8223DFF
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907595; cv=none; b=cz5B1n5TkRLShsCLHhCbgBbnOFXJDAFysH9VQGtjj+cxbySKMQMbqpKFl8MzTNqHerRjCty3qr7EJVvjKtm8R+PIjDmsfF4JossgDg7mMItAI4/xSZWxc3+pv3tX2d7wVo5RFBBW0QRS2NR5S70yLpiILMq8EdBGH+LdGp10mCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907595; c=relaxed/simple;
	bh=VIiJRBp4Dj9AaocmkgwgkZRgSnp1HxtOu/mpamFWnIk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eCDZQbyvfvInEUk5d/AyN6NugtL9WOUTPQ379W7buhzuXni3C0hKG2YK3m8WZ/8M92wgvQIrSiencYlMaocMEM0JJa6B4+oleK0Ajrj4yhq/IiTwfiSac9Bv/5fFjGfZ05Ppq3SUiNryvD2yUVlaL/qPaAiekhAewDI7n2/XfJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U2zDX3Xf; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U2zDX3Xf"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-459dbbf43c0so26220065e9.1
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907592; x=1755512392; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yuBm1h3wroC42vqlXGAbcWne6RUxZXNPSJiuZlBFSj4=;
        b=U2zDX3XfdCXh8SIVXH4rLBOpK/wZgHaXzsFYJhWezRdpaa/AvwieRsjwxpE7zQdDdi
         ThViKsg3lFnSL/Nq3IrXYxxtC8rUTaK+B5thjyrm08uMTP6qo2Ce4j120gfzJ/O1+LY9
         ysJJshi7Jg3V5OXS0V1jZH7F8TNpEBw0IIqZ05ixCxwjFz3XfM7whYGderRyDtsX7R5+
         e4CTZOBGEd9+VdvUiUt2ZwIJ5G2SKel+qisR+gyrxbsP8QZu5m4HtETk4DN6l/vRmTTP
         XbzQHqRVnv48fTt6fpgDahj5dK4CYLNnZ3WLkqfnjQmB0Ct9h49+TIoUgaww0fubanuL
         BukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907592; x=1755512392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuBm1h3wroC42vqlXGAbcWne6RUxZXNPSJiuZlBFSj4=;
        b=CWABXFtWXgnYxWXk9lxKS5mP3JoGTdazdHLZLTA0Khk0sdnaWz3Cfsgu1GYG6OEqHx
         OJ39mdJdCQLL8JFU+WEWeW0pJ1eKwcnasVo8N7wWI4aEhNwaAe+aEM/2/CDgEn141civ
         Bmvv54kN7d/MOGgs/YAvJ3UPD1y2FNu1V2ItVjlidn6ECHsApaRl3kIdODmyzx+PtDhZ
         toQImH8dk/JyOYkjlpO3BsPNWp4VUIqUZQJ/xstvxKJbk/ssuXSEn9BxJfgeCNFKsdhj
         4mpkjQCwMlDkJh4aFVm5KpWxlGUNPHNEx37pPSoSBbjkQ3aMzdoWQtJr/PlzI7vODNYV
         aG2Q==
X-Gm-Message-State: AOJu0Yws3I+wYdOuLX7OTENTGb8vah/Ey687+/IGSzD9iKwlaSfjutNc
	7PJNx4eywH+WN2WdyMn4q2Gd7MBTkv15rGMfi4RaiujNmpQj7PZhHKVbmsapqP4S4JOtkJlk3/m
	C4cYPnFHlXvWNoIF0/6y9IgRJ5YynD0PZo04K+Ued1CSg7hqTkxYv3Bf9VBcHhiNm+DMLno6X8D
	cmd4OL1OJAKiQ7AsIZ/aACYmxpUESSqnI=
X-Google-Smtp-Source: AGHT+IGgAXr8Vu5j/m5Mih/8asRCVtQBczhT59Yr+HqAtCz+LbSVevgoZdNhQ4lc2Sd+FmQscO1xwRyYHA==
X-Received: from wmbbi20.prod.google.com ([2002:a05:600c:3d94:b0:459:ddb6:d66c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4c84:b0:459:dd4e:4435
 with SMTP id 5b1f17b1804b1-459ede7d688mr98802995e9.5.1754907592323; Mon, 11
 Aug 2025 03:19:52 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:43 +0100
In-Reply-To: <20250811101947.3637632-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250811101947.3637632-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-5-tabba@google.com>
Subject: [PATCH v2 4/8] KVM: arm64: Decouple hyp VM creation state from its handle
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Currently, the presence of a pKVM handle (pkvm.handle != 0) is used to
determine if the corresponding hypervisor (EL2) VM has been created and
initialized. This couples the handle's lifecycle with the VM's creation
state.

This coupling will become problematic with upcoming changes that will
allocate the pKVM handle earlier in the VM's life, before the VM is
instantiated at the hypervisor.

To prepare for this and make the state tracking explicit, decouple the
two concepts. Introduce a new boolean flag, 'pkvm.is_created', to track
whether the hypervisor-side VM has been created and initialized.

A new helper, pkvm_hyp_vm_is_created(), is added to check this flag. All
call sites that previously checked for the handle's existence are
converted to use the new, explicit check. The 'is_created' flag is set
to true upon successful creation in the hypervisor (EL2) and cleared
upon destruction.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/kvm_pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  1 +
 arch/arm64/kvm/pkvm.c             | 11 +++++++++--
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a4289c2f13f5..bc57749e3fb9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -253,6 +253,7 @@ struct kvm_protected_vm {
 	struct kvm_hyp_memcache teardown_mc;
 	struct kvm_hyp_memcache stage2_teardown_mc;
 	bool is_protected;
+	bool is_created;
 };
 
 struct kvm_mpidr_data {
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ea58282f59bb..08be89c95466 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -18,6 +18,7 @@
 
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
+bool pkvm_hyp_vm_is_created(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index abe173406c88..969f6b293234 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -407,6 +407,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
 	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
 	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
+	hyp_vm->kvm.arch.pkvm.is_created = true;
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 }
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 7aaeb66e3f39..45d699bba96a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -87,12 +87,13 @@ void __init kvm_hyp_reserve(void)
 
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
-	if (kvm->arch.pkvm.handle) {
+	if (pkvm_hyp_vm_is_created(kvm)) {
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
 					  kvm->arch.pkvm.handle));
 	}
 
 	kvm->arch.pkvm.handle = 0;
+	kvm->arch.pkvm.is_created = false;
 	free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
 	free_hyp_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
 }
@@ -165,6 +166,7 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 		goto free_vm;
 
 	kvm->arch.pkvm.handle = ret;
+	kvm->arch.pkvm.is_created = true;
 	kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
@@ -176,12 +178,17 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 	return ret;
 }
 
+bool pkvm_hyp_vm_is_created(struct kvm *kvm)
+{
+	return READ_ONCE(kvm->arch.pkvm.is_created);
+}
+
 int pkvm_create_hyp_vm(struct kvm *kvm)
 {
 	int ret = 0;
 
 	mutex_lock(&kvm->arch.config_lock);
-	if (!kvm->arch.pkvm.handle)
+	if (!pkvm_hyp_vm_is_created(kvm))
 		ret = __pkvm_create_hyp_vm(kvm);
 	mutex_unlock(&kvm->arch.config_lock);
 
-- 
2.50.1.703.g449372360f-goog

