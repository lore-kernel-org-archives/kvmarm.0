Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE0628727F
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 19:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753817634; cv=none; b=NT+u7JAtRC8ZPCJHM7YFm0sL7kXAooozFcM4UDgztC+ZC0jqdvtM0HJH3jxMIGEemCWLtR47UbwFVIEXqIJAKWGbtwWcBoQgMfwl3KJOuSWzLDkmk23xikL8MMUN9RGOUdkd0DZ1BYqI9u96RTK+g5XBb9UVL5BWUub0iONGgOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753817634; c=relaxed/simple;
	bh=X6kSoWARgQhTBHyJo7xEWPtfNUe15LYs+m14KA9l8uM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jUxugBWf63p4X/bYN2qgTH1R3xBSfbNQ6ROfBjVTP2S+QoZBY9VOdoIrLFH6Ph38vSe6b7FLk2TIKFUbP7eiEeyJP0PMMDVuUfnrsqvhOJ+MfK6w73nF7QthgPe6BQrpqO3rrcYznLFxeC8tcEj/SMQ6WzkGZDnCR4xQdg+1GSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uZ/bcyok; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uZ/bcyok"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ebadfb7f2so152821a91.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753817632; x=1754422432; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZdHlnZ98+ZVsmpjhh1EatY5FQnyPvSy7oQ52FgoL3AU=;
        b=uZ/bcyokOriBfMUVp6CYg7p5h1eMMR3Pzr/hf5V2DJGkVFDy+fwM8PR9P0sZSl26wX
         ekN0w4Fljz2lqvwpTBpSzcJmcUgwWFdXIXdyQwiuUX4t5bKAmJMJUGcQid/RlHHBIt1X
         vOmw8YAY7dM+A0h5d6crbnINbKMIVYLGtWn+CI14Y2og8m/bUp8F9RG4kP/nzVvNA2QL
         uT4P8GAosBZmfa0YfziOIpUxYvhkBQVyH8jBtRbk1/beuEpgoHX3C9oG2jx9KeTjUNtD
         68cGZKGwoWBY8v16cQyX3p/Yla7u0AYIELThcSgCsrP1gzetIJedxAYNobSz7JiYhb6m
         hxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753817632; x=1754422432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZdHlnZ98+ZVsmpjhh1EatY5FQnyPvSy7oQ52FgoL3AU=;
        b=BbTAm1ssXekAPi9km2mpFu5RCcbnHL5IlEanOLGbXp8mOQDkojCEKdh9OcHl+OiFEs
         GkQ8ZWg8/SXZm42ZJu3ebYd3LVCUbM/MgnVtFYcbvi81EXqjRDTCad4ID16c3SnUQTpj
         a1BgJH4w5CTfWctQ/HUAcf/+VJGD8hCvwCUYV6Th550PnH07u+5l4sJ/vGHwa4kM1ghW
         2+Bfb7MT933DUYMCKc7HXqC82AIjASTLhdbOj3uq/gZRgqaQUhkKWSrPO00RdMzqGQgl
         Q4J7lCtT31glgFeDaKZRJoeW/nfJPT2z1KOcQKL+WVUTKDLpBw9YTsaOoyUTWbZ8zNSo
         iF3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWWWItipCbNN6ImhcqMz59Mz63zeCGW5M6zZtSHmTQ1IjY3ETBujwT9EkQsQZ/cN9iAXitFR3o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxdhgc6awCGbU5d7z0kOaAg0KI/e7Cq+ueN9PBd85iwYSiM11UG
	jS8ZfjxOKZAiI1ohfe09VOfVBgp09pGK+VMGrJyCI+P43GT35P88lLc2Hk4rh412OWmaEYFsJar
	nripQ1A==
X-Google-Smtp-Source: AGHT+IFFe8P3g6K0zh0qtvZDIKe8VSkXT7Rqbzi2+TCDvK005OkWz+Mz8UVq7jUspvUvHpMWKrpsZ+VbdgQ=
X-Received: from pjbqc14.prod.google.com ([2002:a17:90b:288e:b0:31c:32f8:3f88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c2:b0:313:b1a:3939
 with SMTP id 98e67ed59e1d1-31f5ddcd3c6mr813328a91.15.1753817631999; Tue, 29
 Jul 2025 12:33:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 12:33:38 -0700
In-Reply-To: <20250729193341.621487-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729193341.621487-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: Reject ioctls only if the VM is bugged, not simply
 marked dead
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
Content-Type: text/plain; charset="UTF-8"

Relax the protection against interacting with a buggy KVM to only reject
ioctls if the VM is bugged, i.e. allow userspace to invoke ioctls if KVM
deliberately terminated the VM.  Drop kvm.vm_dead as there are no longer
any readers, and KVM shouldn't rely on vm_dead for functional correctness.
The only functional guarantees provided by kvm_vm_dead() come by way of
KVM_REQ_VM_DEAD, which ensures that vCPU won't re-enter the guest.

Practically speaking, this only affects x86, which uses kvm_vm_dead() to
prevent running a VM whose resources have been partially freed or has run
one or more of its vCPUs into an architecturally defined state.  In these
cases, there is no (known) danger to KVM, the goal is purely to prevent
entering the guest.

As evidenced by commit ecf371f8b02d ("KVM: SVM: Reject SEV{-ES} intra host
migration if vCPU creation is in-flight"), the restriction on invoking
ioctls only blocks _new_ ioctls.  I.e. KVM mustn't rely on blocking ioctls
for functional safety (whereas KVM_REQ_VM_DEAD is guaranteed to prevent
vCPUs from entering the guest).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/vgic/vgic-init.c                     |  2 +-
 include/linux/kvm_host.h                            |  2 --
 tools/testing/selftests/kvm/x86/sev_migrate_tests.c |  5 +----
 virt/kvm/kvm_main.c                                 | 10 +++++-----
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index eb1205654ac8..c2033bae73b2 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -612,7 +612,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	mutex_unlock(&kvm->arch.config_lock);
 out_slots:
 	if (ret)
-		kvm_vm_dead(kvm);
+		kvm_vm_bugged(kvm);
 
 	mutex_unlock(&kvm->slots_lock);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 627054d27222..fa97d71577b5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -854,7 +854,6 @@ struct kvm {
 	u32 dirty_ring_size;
 	bool dirty_ring_with_bitmap;
 	bool vm_bugged;
-	bool vm_dead;
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
@@ -894,7 +893,6 @@ struct kvm {
 
 static inline void kvm_vm_dead(struct kvm *kvm)
 {
-	kvm->vm_dead = true;
 	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_DEAD);
 }
 
diff --git a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
index 0a6dfba3905b..0580bee5888e 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -87,10 +87,7 @@ static void test_sev_migrate_from(bool es)
 		sev_migrate_from(dst_vms[i], dst_vms[i - 1]);
 
 	/* Migrate the guest back to the original VM. */
-	ret = __sev_migrate_from(src_vm, dst_vms[NR_MIGRATE_TEST_VMS - 1]);
-	TEST_ASSERT(ret == -1 && errno == EIO,
-		    "VM that was migrated from should be dead. ret %d, errno: %d", ret,
-		    errno);
+	sev_migrate_from(src_vm, dst_vms[NR_MIGRATE_TEST_VMS - 1]);
 
 	kvm_vm_free(src_vm);
 	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..f1f69e10a371 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4408,7 +4408,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
 
-	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
@@ -4651,7 +4651,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 	void __user *argp = compat_ptr(arg);
 	int r;
 
-	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -4717,7 +4717,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
 {
 	struct kvm_device *dev = filp->private_data;
 
-	if (dev->kvm->mm != current->mm || dev->kvm->vm_dead)
+	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -5139,7 +5139,7 @@ static long kvm_vm_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
-	if (kvm->mm != current->mm || kvm->vm_dead)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
@@ -5403,7 +5403,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 	struct kvm *kvm = filp->private_data;
 	int r;
 
-	if (kvm->mm != current->mm || kvm->vm_dead)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 
 	r = kvm_arch_vm_compat_ioctl(filp, ioctl, arg);
-- 
2.50.1.552.g942d659e1b-goog

