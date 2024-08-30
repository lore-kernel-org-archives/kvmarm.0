Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2DF158D98
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 04:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992582; cv=none; b=jzdrrDOwmASjCncGtLvRFnyzE75flPF3xRPO2dbZe7DPLK/zWYy2UUf+/SYmfu7AB/2XZ4BlEimIFVoZHV0HhFI4dqnWVVAs1WXNTg+AhchGcRrZh6NWci5Vp+AlVHAIJbBCmbCXjvRDPCw2dAq/lkn0Q7vTepDL2+WRSytr3MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992582; c=relaxed/simple;
	bh=392W/re5MIy5UXdOM6F4WZEJKenEvqqKwB+NDONGozc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pG/+8qO/CiC7Rxrkf1LsdBv/Nki6TOK2DSOrzKFA1CdpR7SswZSP7uXr7loZUFPFb1mR06Sp9qWfINtfAO5K6+/GT+SwTGptgg5G5/FoSzeH+M8AkD+VRBm38rN1kGS2nceyvmJvY9BE7/hmt7y0C8hkTlntlwCf5tjmAzfUpVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Beeb6vvL; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Beeb6vvL"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2039405b567so12569415ad.3
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 21:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992579; x=1725597379; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M2s+onp5tR3Lhbit2H5d49uth+heyyaX98MlcrFx54Y=;
        b=Beeb6vvLcxBv4J7qmT2tm4stgcEphX8xMWi/NN5CN1p0uNYBZfbqD5Q0v1E8+kvi3k
         3gReRbzeybvgMLkaLlAwVv3BW89ktgM55MLZlguNwuvnlx6CtE/CaWcQl2r0M31tJg4n
         S1yeTICG/EudLdJSEzIIsRVTOvT97yYg9CmkTcRtFX4B8HraYYTR+JP+INUy+KfDCZEy
         muS8r0huq5XAxTWfrqXcDW7aK79iE5XdnHjfjelXEBzWHUf22MBnacNsVEeKvbMXwh41
         Zo+RH8nOG+bG096iurC6TDwkBhIK7zAe3ilD3eP9MVHIS4aqdrR9hRWfgnSj0Io1v9ut
         VTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992579; x=1725597379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M2s+onp5tR3Lhbit2H5d49uth+heyyaX98MlcrFx54Y=;
        b=HqW5QamY9iV15W9DgJfDljT6mPKVN0zoisqWHv0DJKAZKupstoQPe+63MVpvrsxVT1
         4MtT1qdKipyYN9h0K5IW4uAMW5iffTvfGuvryjN0erOMGU0UrWlHEQolDqvT56/vrgXZ
         rdQMpNIY1gOG8I6JfWsNKf2Aidq7zvJc/YgaOBMatqlEO9kIizfAMx6bKV/ws0Bhv6ak
         8zxI98g8IktF1CArdExCxFK3IoXUcgf/Y+hRmlbS3GC1R+SUYm/fFkKI4gX2uN7l+YBX
         VOIO704goWgTX1zmvZ4u40LLE/aFWvyOc1FmGVICgumXTo5mbMwKILFubBX29SrK5n9c
         spIg==
X-Forwarded-Encrypted: i=1; AJvYcCVGfyAFJCljugzl14152F4xanRoiRqC0nmWeSGcav5eddmt9vXz2BoYs91NgZpRgcBVn3U8wNw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKTYY+zEiX6Yf2fSvzOe+oOhKrL2MvSR5dYSIpotq0dH3DGccH
	zgpjgRht+4M+J8wwu0x78kpwUweUiJ8LnbJiY6dzAUdOXG8TDSHkuyXWS7+LarWGQqXnKwDCZip
	K7w==
X-Google-Smtp-Source: AGHT+IHsUVl4EvyuChNsDlGcFLHLP8TQ15E11S1rfoAfjJIcPKgkB6hh3D01h9rTMbJijEqYHxNp/J3BFZg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c411:b0:205:32b5:b541 with SMTP id
 d9443c01a7336-20532b5b641mr369845ad.3.1724992578679; Thu, 29 Aug 2024
 21:36:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:57 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-8-seanjc@google.com>
Subject: [PATCH v4 07/10] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
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

Add an on-by-default module param, enable_virt_at_load, to let userspace
force virtualization to be enabled in hardware when KVM is initialized,
i.e. just before /dev/kvm is exposed to userspace.  Enabling virtualization
during KVM initialization allows userspace to avoid the additional latency
when creating/destroying the first/last VM (or more specifically, on the
0=>1 and 1=>0 edges of creation/destruction).

Now that KVM uses the cpuhp framework to do per-CPU enabling, the latency
could be non-trivial as the cpuhup bringup/teardown is serialized across
CPUs, e.g. the latency could be problematic for use case that need to spin
up VMs quickly.

Prior to commit 10474ae8945c ("KVM: Activate Virtualization On Demand"),
KVM _unconditionally_ enabled virtualization during load, i.e. there's no
fundamental reason KVM needs to dynamically toggle virtualization.  These
days, the only known argument for not enabling virtualization is to allow
KVM to be autoloaded without blocking other out-of-tree hypervisors, and
such use cases can simply change the module param, e.g. via command line.

Note, the aforementioned commit also mentioned that enabling SVM (AMD's
virtualization extensions) can result in "using invalid TLB entries".
It's not clear whether the changelog was referring to a KVM bug, a CPU
bug, or something else entirely.  Regardless, leaving virtualization off
by default is not a robust "fix", as any protection provided is lost the
instant userspace creates the first VM.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../admin-guide/kernel-parameters.txt         | 17 +++++++++
 virt/kvm/kvm_main.c                           | 35 +++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 09126bb8cc9f..1b52b1b7bbc4 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2648,6 +2648,23 @@
 
 			Default is Y (on).
 
+	kvm.enable_virt_at_load=[KVM,ARM64,LOONGARCH,MIPS,RISCV,X86]
+			If enabled, KVM will enable virtualization in hardware
+			when KVM is loaded, and disable virtualization when KVM
+			is unloaded (if KVM is built as a module).
+
+			If disabled, KVM will dynamically enable and disable
+			virtualization on-demand when creating and destroying
+			VMs, i.e. on the 0=>1 and 1=>0 transitions of the
+			number of VMs.
+
+			Enabling virtualization at module lode avoids potential
+			latency for creation of the 0=>1 VM, as KVM serializes
+			virtualization enabling across all online CPUs.  The
+			"cost" of enabling virtualization when KVM is loaded,
+			is that doing so may interfere with using out-of-tree
+			hypervisors that want to "own" virtualization hardware.
+
 	kvm.enable_vmware_backdoor=[KVM] Support VMware backdoor PV interface.
 				   Default is false (don't support).
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b000f221abfb..55779fbb37ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5572,6 +5572,9 @@ static struct miscdevice kvm_dev = {
 };
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+static bool enable_virt_at_load = true;
+module_param(enable_virt_at_load, bool, 0444);
+
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
@@ -5722,15 +5725,39 @@ static void kvm_disable_virtualization(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 }
+
+static int kvm_init_virtualization(void)
+{
+	if (enable_virt_at_load)
+		return kvm_enable_virtualization();
+
+	return 0;
+}
+
+static void kvm_uninit_virtualization(void)
+{
+	if (enable_virt_at_load)
+		kvm_disable_virtualization();
+}
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 static int kvm_enable_virtualization(void)
 {
 	return 0;
 }
 
+static int kvm_init_virtualization(void)
+{
+	return 0;
+}
+
 static void kvm_disable_virtualization(void)
 {
 
+}
+
+static void kvm_uninit_virtualization(void)
+{
+
 }
 #endif /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 
@@ -6475,6 +6502,10 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 
 	kvm_gmem_init(module);
 
+	r = kvm_init_virtualization();
+	if (r)
+		goto err_virt;
+
 	/*
 	 * Registration _must_ be the very last thing done, as this exposes
 	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
@@ -6488,6 +6519,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	return 0;
 
 err_register:
+	kvm_uninit_virtualization();
+err_virt:
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
@@ -6513,6 +6546,8 @@ void kvm_exit(void)
 	 */
 	misc_deregister(&kvm_dev);
 
+	kvm_uninit_virtualization();
+
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
-- 
2.46.0.469.g59c65b2a67-goog

