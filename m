Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574AB14F9DB
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 04:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992573; cv=none; b=NjEEUeRjGKV7eIstiJDFTAQPh36EO/yuW4x5Cd6AbJ60qeN4OehTkjYSwzphBGGlBrQQ/AAPdoYWaJBgwzOEXgQrojQjsuXhG6F2qXLFTParwUOmNg4H7SA355x2xHk+I4lO5VHG18YroxL9DOqHHzIHK3tpk88pR6Gib86yepU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992573; c=relaxed/simple;
	bh=SkdkZeFX/OYBPHicii+69oTq+aUN0l4hd2UZEocYL2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M8h99RS0Simtd1TaK3GMrG2WNhfTQ6F/rWCp3sPiUZ2tre1AOCZuR5CoMcVBYB28TGbvfpHkEa5pN1/V4b39IY50jlCyMQFQrguG0LAqGsvApO0vNk/ADs0qCWkMWIY2M02eHx36DZ16JP8cwx3G913cA4NF544S4Vf6divodpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JTwDvn2H; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JTwDvn2H"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-201ee593114so20429835ad.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 21:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992571; x=1725597371; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9rj6vLr2Zw9u+tL14LjoFTcNuQx6nMKbwDhD6S7zy4M=;
        b=JTwDvn2HMJEHFurCb2q1oLiuBMpMVKq5LCTQMk8lipoDguYgCfnMLCsz7gxJC9RvSu
         X5oGoJ2eZmlUd/Ur3gXgWAvYbZMHdDx/2SywTfkNdzjNlrFcsB60GxSIZvAUE4wJICT6
         /u/uYQQBKuyx1jM/R6Im4meeqlAaf04h2E1/YfBFk8r7w2g2WG+5Mv843ID2yhUmU7vF
         ZKrh8T+E7StuuDYfzrq+OBrbLMqZmqSmvpIlMFAAzOaiDGYeQNjsjuffdhneSowmT/8M
         dWbX7AUgGYme69m0tPWsCLYNE5Le6Dc0EqrXJmqWJf0QVuAs6y8B3LmliBJ1PxnaLjHR
         vhDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992571; x=1725597371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9rj6vLr2Zw9u+tL14LjoFTcNuQx6nMKbwDhD6S7zy4M=;
        b=Se9PwU1Z9YrVEKGTK0pjr+LVHOIHv2AFt28+cKxkoDxJV3H81AvWeuBWrtC7dhZlSf
         vk07ppkiQ5aYnSPqgIJRVLAeo4oFOMBR6Ch+oWVm+QETl3M6ks1NUQ4KjrhOi29Wg7VF
         gQVJt8W/7s/y32BrpNgihLjjfa273T4+wXYbFhS5ATHx2h9W41F+Zog0g+MVfpeKVxzu
         IginogE9ZGgRjbnjVF22wGVKXLY3s05e+CzvXJPjXVziVpFWy+yWDKmUyvT3+4hfYm6w
         J89JoN5J3mkP4pj/ym0g5D49RCO6f/rxYSjRdc6aT68yBLQkb9ogMIKz6Y2zUQp9mNz6
         LEsg==
X-Forwarded-Encrypted: i=1; AJvYcCXnMYiCMcROLFUYM5mS3hSulKl296LK4tktPbypQzfEgmVwgVdCHuobPHdmr8DCEJkj14PJK7s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXx8+7KL11yZpcTNtQXT8Zxo3QN4Tnqy0b6xDXBaWrOIW4NUgl
	ISJv9/mVUF8f+TEYolughdzGCz3VKMdfTsTXSt0PQtbh0UGzlaLL54qNmGA6eUz1y60jOh/cd6J
	S4w==
X-Google-Smtp-Source: AGHT+IFzNLMOWxStSOb6dz4OqO52HXYFy1OXZpfuDNQs7ORrcRcLluFbTSNdD7idfuIi2MeqpuxkFW/WSPs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:4303:b0:1f9:e5e4:494b with SMTP id
 d9443c01a7336-2050e9aaf54mr110245ad.2.1724992570417; Thu, 29 Aug 2024
 21:36:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:53 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-4-seanjc@google.com>
Subject: [PATCH v4 03/10] KVM: Rename symbols related to enabling
 virtualization hardware
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename the various functions (and a variable) that enable virtualization
to prepare for upcoming changes, and to clean up artifacts of KVM's
previous behavior, which required manually juggling locks around
kvm_usage_count.

Drop the "nolock" qualifier from per-CPU functions now that there are no
"nolock" implementations of the "all" variants, i.e. now that calling a
non-nolock function from a nolock function isn't confusing (unlike this
sentence).

Drop "all" from the outer helpers as they no longer manually iterate
over all CPUs, and because it might not be obvious what "all" refers to.

In lieu of the above qualifiers, append "_cpu" to the end of the functions
that are per-CPU helpers for the outer APIs.

Opportunistically prepend "kvm" to all functions to help make it clear
that they are KVM helpers, but mostly because there's no reason not to.

Lastly, use "virtualization" instead of "hardware", because while the
functions do enable virtualization in hardware, there are a _lot_ of
things that KVM enables in hardware.

Defer renaming the arch hooks to future patches, purely to reduce the
amount of churn in a single commit.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a5826e16a106..fbdd2e46e65b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -136,8 +136,8 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
+static int kvm_enable_virtualization(void);
+static void kvm_disable_virtualization(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1220,7 +1220,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = hardware_enable_all();
+	r = kvm_enable_virtualization();
 	if (r)
 		goto out_err_no_disable;
 
@@ -1263,7 +1263,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
+	kvm_disable_virtualization();
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
@@ -1360,7 +1360,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
-	hardware_disable_all();
+	kvm_disable_virtualization();
 	mmdrop(mm);
 }
 
@@ -5575,13 +5575,13 @@ static struct miscdevice kvm_dev = {
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
-static DEFINE_PER_CPU(bool, hardware_enabled);
+static DEFINE_PER_CPU(bool, virtualization_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
-static int hardware_enable_nolock(void)
+static int kvm_enable_virtualization_cpu(void)
 {
-	if (__this_cpu_read(hardware_enabled))
+	if (__this_cpu_read(virtualization_enabled))
 		return 0;
 
 	if (kvm_arch_hardware_enable()) {
@@ -5590,7 +5590,7 @@ static int hardware_enable_nolock(void)
 		return -EIO;
 	}
 
-	__this_cpu_write(hardware_enabled, true);
+	__this_cpu_write(virtualization_enabled, true);
 	return 0;
 }
 
@@ -5601,22 +5601,22 @@ static int kvm_online_cpu(unsigned int cpu)
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	return hardware_enable_nolock();
+	return kvm_enable_virtualization_cpu();
 }
 
-static void hardware_disable_nolock(void *junk)
+static void kvm_disable_virtualization_cpu(void *ign)
 {
-	if (!__this_cpu_read(hardware_enabled))
+	if (!__this_cpu_read(virtualization_enabled))
 		return;
 
 	kvm_arch_hardware_disable();
 
-	__this_cpu_write(hardware_enabled, false);
+	__this_cpu_write(virtualization_enabled, false);
 }
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	hardware_disable_nolock(NULL);
+	kvm_disable_virtualization_cpu(NULL);
 	return 0;
 }
 
@@ -5635,7 +5635,7 @@ static void kvm_shutdown(void)
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(kvm_disable_virtualization_cpu, NULL, 1);
 }
 
 static int kvm_suspend(void)
@@ -5651,7 +5651,7 @@ static int kvm_suspend(void)
 	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
-	hardware_disable_nolock(NULL);
+	kvm_disable_virtualization_cpu(NULL);
 	return 0;
 }
 
@@ -5660,7 +5660,7 @@ static void kvm_resume(void)
 	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
-	WARN_ON_ONCE(hardware_enable_nolock());
+	WARN_ON_ONCE(kvm_enable_virtualization_cpu());
 }
 
 static struct syscore_ops kvm_syscore_ops = {
@@ -5669,7 +5669,7 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-static int hardware_enable_all(void)
+static int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5712,7 +5712,7 @@ static int hardware_enable_all(void)
 	return r;
 }
 
-static void hardware_disable_all(void)
+static void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5723,12 +5723,12 @@ static void hardware_disable_all(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-static int hardware_enable_all(void)
+static int kvm_enable_virtualization(void)
 {
 	return 0;
 }
 
-static void hardware_disable_all(void)
+static void kvm_disable_virtualization(void)
 {
 
 }
-- 
2.46.0.469.g59c65b2a67-goog

