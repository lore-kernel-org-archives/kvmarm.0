Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CFC21C19E
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661174; cv=none; b=Pb5M5P7Og/VaPxbLO66a9zbsFV4Ze0CNCvQyN7Wb8+WqKGRZawt6fPXSEU12vIr6KIS2t64BbFuM7R7yR90mMcbE/hH8hIIc2MRaYM6I64N980iff1tjO0OIi7umcwe7b+KJ9JVS/PnqlaDNZIUbY5BLoPlPczBImSZehbJUgd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661174; c=relaxed/simple;
	bh=Z5xAV/JEgL1zrSHNWBCq2Gg3U16HqziHPgrjQtnPeVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KaBJjvoAag4lf9V9vRg8/UCNUAhD2UojQW2ggbX7gIu1Y+gCJ/j2y4nFK4PDggWvWY3tHF68fDKkP+8xOP46B2MSBJzFqrgz4ES//E1uF7gky/1hhRJEsbMcoqvsIqpkavKRkYaR2imJ+O+1VJTB/P3HYPxn205NXDAzKWmMRQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jKm50r45; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jKm50r45"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc5bso1885768a91.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661172; x=1761265972; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=33cozUgZY2qVcRUHL7b8tITs99/x6FMYwOKO1Eer8GQ=;
        b=jKm50r45dDeqZwuqs2ZAfE9BApXpVKATtOxyLMRaGTWi8osTveoa3Tof6kfb577Ejc
         EVMmZiJXQQWFn4PKznlOA8MT7eFqrrXyoxLOXRdpChYbaixxmats9uIiZj4SA4vw7jzL
         Na3Kk9c8XDMg8ndPApiIHD6xKVYoO2ZkOQDxd/t1PVC3GbyXZpWDXJKfvJgznO/3DySk
         4iqaCT6v5sNsjI+LoHcl+NXiaIREEZMZUNdOzzpq9sUaiJwHvnOwe5uuN7VXYccaJ++S
         zoEcSu13No9zV6knM7Ca6xOT9DzLlBroHwbNh7AqXkl2HRdZMgvuh2ZFqeklLXSO/X/s
         2cvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661172; x=1761265972;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=33cozUgZY2qVcRUHL7b8tITs99/x6FMYwOKO1Eer8GQ=;
        b=WLCY3L6VGQVFurvE6OzNp3WfbYnbeqJJbswmyHNnyXpMBKLfGokxvoKAF2OPK9sol3
         mObWFnabGrvNVyDpDaF6lyTojnDR3/GxkGgRi8yLJgJOUMeor7iXJiiTjxE2cAmRr/xb
         8UvXsMB3MErzTm1+p4vuAUSB+mvioWkKRDRyExEmr6QWv7j/l6+7cgD2fKMIDtMbCzuk
         djNZEDqCx1V8tH+pDwLo8kYnzyuumDi6mqII9bC2G83y9odh7ELVm0npgsh7wTtC18bw
         YgAHe40fe8DkPy8icB+f4AwIlB0lCY+fZuVPByXK8Jf4kvoIYQ+JnWkwwigWWNRS3Rgt
         eG6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUpmXlaU6xYWqAuSYse2kBkCoYulNjs/YpHsPuAamsU7v1pQmWaRZgNyh5rafILPJx/WuTEa8I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0rP+vzTC2+azDPGL5AwOIhVBzDW2BbbIseMqhhsS/jiIm7KwK
	05a3Hh236JaBI9X3v6JqL/6rxj4+aD/OFP77kr1yo+S7q340Gp7JFwv4XuM9bs8SjPdP5MDETn9
	924gE2A==
X-Google-Smtp-Source: AGHT+IHi1bmDhBVE/1dfVFfxtUsGZvUIPpndhcsCAkXUuWnb62NCix+r2iPcIxi5145AtUHJ60DhAmmul/g=
X-Received: from pjut11.prod.google.com ([2002:a17:90a:d50b:b0:33b:beb0:be7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380f:b0:32e:8931:b59c
 with SMTP id 98e67ed59e1d1-33bcf90c0cdmr1921084a91.27.1760661171886; Thu, 16
 Oct 2025 17:32:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:20 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-3-seanjc@google.com>
Subject: [PATCH v3 02/25] KVM: Rename kvm_arch_vcpu_async_ioctl() to kvm_arch_vcpu_unlocked_ioctl()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename the "async" ioctl API to "unlocked" so that upcoming usage in x86's
TDX code doesn't result in a massive misnomer.  To avoid having to retry
SEAMCALLs, TDX needs to acquire kvm->lock *and* all vcpu->mutex locks, and
acquiring all of those locks after/inside the current vCPU's mutex is a
non-starter.  However, TDX also needs to acquire the vCPU's mutex and load
the vCPU, i.e. the handling is very much not async to the vCPU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c       | 4 ++--
 arch/loongarch/kvm/vcpu.c  | 4 ++--
 arch/mips/kvm/mips.c       | 4 ++--
 arch/powerpc/kvm/powerpc.c | 4 ++--
 arch/riscv/kvm/vcpu.c      | 4 ++--
 arch/s390/kvm/kvm-s390.c   | 4 ++--
 arch/x86/kvm/x86.c         | 4 ++--
 include/linux/kvm_host.h   | 4 ++--
 virt/kvm/kvm_main.c        | 6 +++---
 9 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 785aaaee6a5d..e8d654024608 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1828,8 +1828,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
-long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
-			       unsigned long arg)
+long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
+				  unsigned long arg)
 {
 	return -ENOIOCTLCMD;
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 30e3b089a596..9a5844e85fd3 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1471,8 +1471,8 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq)
 	return 0;
 }
 
-long kvm_arch_vcpu_async_ioctl(struct file *filp,
-			       unsigned int ioctl, unsigned long arg)
+long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
+				  unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct kvm_vcpu *vcpu = filp->private_data;
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a75587018f44..b0fb92fda4d4 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -895,8 +895,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
-			       unsigned long arg)
+long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
+				  unsigned long arg)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2ba057171ebe..9a89a6d98f97 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -2028,8 +2028,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
-long kvm_arch_vcpu_async_ioctl(struct file *filp,
-			       unsigned int ioctl, unsigned long arg)
+long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
+				  unsigned long arg)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index bccb919ca615..a4bd6077eecc 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -238,8 +238,8 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-long kvm_arch_vcpu_async_ioctl(struct file *filp,
-			       unsigned int ioctl, unsigned long arg)
+long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
+				  unsigned long arg)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 16ba04062854..8c4caa5f2fcd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5730,8 +5730,8 @@ static long kvm_s390_vcpu_memsida_op(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-long kvm_arch_vcpu_async_ioctl(struct file *filp,
-			       unsigned int ioctl, unsigned long arg)
+long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
+				  unsigned long arg)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca5ba2caf314..b85cb213a336 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7240,8 +7240,8 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	return 0;
 }
 
-long kvm_arch_vcpu_async_ioctl(struct file *filp, unsigned int ioctl,
-			       unsigned long arg)
+long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
+				  unsigned long arg)
 {
 	return -ENOIOCTLCMD;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7186b2ae4b57..d93f75b05ae2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1557,6 +1557,8 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg);
+long kvm_arch_vcpu_unlocked_ioctl(struct file *filp,
+				  unsigned int ioctl, unsigned long arg);
 vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
@@ -2437,8 +2439,6 @@ static inline bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_NO_POLL */
 
-long kvm_arch_vcpu_async_ioctl(struct file *filp,
-			       unsigned int ioctl, unsigned long arg);
 void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
 
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b7a0ae2a7b20..b7db1d5f71a8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4434,10 +4434,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		return r;
 
 	/*
-	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
-	 * execution; mutex_lock() would break them.
+	 * Let arch code handle select vCPU ioctls without holding vcpu->mutex,
+	 * e.g. to support ioctls that can run asynchronous to vCPU execution.
 	 */
-	r = kvm_arch_vcpu_async_ioctl(filp, ioctl, arg);
+	r = kvm_arch_vcpu_unlocked_ioctl(filp, ioctl, arg);
 	if (r != -ENOIOCTLCMD)
 		return r;
 
-- 
2.51.0.858.gf9c4a03a3a-goog

