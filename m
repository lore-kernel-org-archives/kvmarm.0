Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9357D28466F
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267641; cv=none; b=YG3fhtgc18grzot6AKEy4r7GTFjmT5c6+9RMaSMz1XkWl5yahO4d2QnQn/Qc1tsbgmeXYMmVWo2ynVR8SU4NyKf7Z2wlmF94QA4rkgYcK8AUi/l1KB/O6XnJcxhQK8f81NVEJeQDMmaMR4Bl3PQRdNm4cRqUcRytB5Qi/LeTQNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267641; c=relaxed/simple;
	bh=c/XS5ewtaGuLKhzHP+5yEB/GdDuoY/+4kh1Qi+4FNro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MDN1u32Yrw27pAIP2n0nawQw/7BnlPbLdgPd3ObLFxjp9SPPehJquYkSiF/csyuvgGUEi5/x6wLsLQQw73tl1kuouLZar8Xmpqh76taYTMYbMHL+e7mPODgZxlIm8Y8BQkGjyJW0yc3pFlMuLJGD2meB5e8PuTxEOlX0vVJA37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T9wazPSU; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T9wazPSU"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b6162a7abdso1909416f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267637; x=1753872437; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=irM8qZtZs2OxjIAk0ctgU1D+7CU3BEq0B4YUNMOwj2s=;
        b=T9wazPSUrJbAy8Ew6K80kEHI9jKLsuw2pte1bjpQE9G4NIxcd2rZVVgDHmlUttiXo+
         JhTNTLeJqzC6AcyJiILMu2nbXb6hbbKd0kdP5Wxne88HKWun9c8GSxqz4f70Y+gPbtMZ
         sQzVT+5DlVRdcGdbyOKrzWqobXf3zcjiPy0p2aH+veVlM2EmipUjN8jsbl+q4DMQCwOv
         Z3DXOg3/Wr+MfDFFjRhAAaQWdXntSH4l5K5Ezh4IJMhcgvmTlAcfrkRMNCF6vnIzxfpk
         5b7BmpTYxS51YYVd7RGIci/iJtwkbNKubqlbNaT+Scx59w9dcSDEkuxjWMfFORnT3cFg
         44yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267637; x=1753872437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=irM8qZtZs2OxjIAk0ctgU1D+7CU3BEq0B4YUNMOwj2s=;
        b=VRsJv8++uuM+/VGiVn6YShI5co0L32RUQWeQDXX7z9Ok25Z3/DW0sDWeNiKH3QLfUg
         DGK30zw+XCtCpveIbfJrsstGah4L+9NSQcX2G0u+EqdhD19DWIknMfPTRoA1WtDibpPm
         Zhc3CMxLhX06fZB6XwHp/QSIbNTIz7FocxEniogd1BsLPVZu6Cq4pRyzPgJPtvh6LlvM
         I0UGovbfFQOZ4derpMBGEjNNUm++mov+SLomOGr599gM79FuWHzBNgAM+SbVWdTd6ToE
         XiQrfzt+W7rjJpCaZgit5P0H4yo2m1xsfWSUeAO44LOzaQHGb54oN4+QFDnJq4FYZIh/
         FQJw==
X-Forwarded-Encrypted: i=1; AJvYcCUM1C7FqyzgiudfO2ZoBcRBYRmwzIvQNM9ieTctFaT63chHfRIlO3uNt96YjGiajYMPL8hGaSo=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywl3muhMPHNiTI8OPwlcPFu9tdetDZF7cGHr+c23XmoZ2V2xzQX
	SciWWB0wxvCEFSTGBsW7Xpu50oclqa2dvNaqRkkMfWGFCCd8UQYrJLZqZa6ILStecfcyQGAbrcm
	afA==
X-Google-Smtp-Source: AGHT+IG5Z3A6R2I6Yt40IaTyInl4VZ3bw90RL9tNJeKgjFFghyeEaG3W+L0zG4oREWZmzmC9PH6Pnqlt3w==
X-Received: from wmbjg14.prod.google.com ([2002:a05:600c:a00e:b0:456:365f:428b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2312:b0:3b4:5a9d:8323
 with SMTP id ffacd0b85a97d-3b768ee082emr1858112f8f.7.1753267636987; Wed, 23
 Jul 2025 03:47:16 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:54 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-3-tabba@google.com>
Subject: [PATCH v16 02/22] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
i.e. gate them on at least one vendor module being enabled and thus on
kvm.ko actually being built.  Depending on just KVM allows the user to
select the configs even though they won't actually take effect, and more
importantly, makes it all too easy to create unmet dependencies.  E.g.
KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.

Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
helps communicate to the user that nothing "interesting" is going on, e.g.

  --- Virtualization
  <M>   Kernel-based Virtual Machine (KVM) support
  < >   KVM for Intel (and compatible) processors support
  < >   KVM for AMD processors support

Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2c86673155c9..9895fc3cd901 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -74,7 +74,7 @@ config KVM_WERROR
 	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
 	# Building KVM with -Werror and KASAN is still doable via enabling
 	# the kernel-wide WERROR=y.
-	depends on KVM && ((EXPERT && !KASAN) || WERROR)
+	depends on KVM_X86 && ((EXPERT && !KASAN) || WERROR)
 	help
 	  Add -Werror to the build flags for KVM.
 
@@ -83,7 +83,7 @@ config KVM_WERROR
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
-	depends on KVM && X86_64
+	depends on KVM_X86 && X86_64
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -169,7 +169,7 @@ config KVM_AMD_SEV
 config KVM_IOAPIC
 	bool "I/O APIC, PIC, and PIT emulation"
 	default y
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
 	  for full in-kernel APIC emulation.
@@ -179,7 +179,7 @@ config KVM_IOAPIC
 config KVM_SMM
 	bool "System Management Mode emulation"
 	default y
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides support for KVM to emulate System Management Mode (SMM)
 	  in virtual machines.  This can be used by the virtual machine
@@ -189,7 +189,7 @@ config KVM_SMM
 
 config KVM_HYPERV
 	bool "Support for Microsoft Hyper-V emulation"
-	depends on KVM
+	depends on KVM_X86
 	default y
 	help
 	  Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
@@ -203,7 +203,7 @@ config KVM_HYPERV
 
 config KVM_XEN
 	bool "Support for Xen hypercall interface"
-	depends on KVM
+	depends on KVM_X86
 	help
 	  Provides KVM support for the hosting Xen HVM guests and
 	  passing Xen hypercalls to userspace.
@@ -213,7 +213,7 @@ config KVM_XEN
 config KVM_PROVE_MMU
 	bool "Prove KVM MMU correctness"
 	depends on DEBUG_KERNEL
-	depends on KVM
+	depends on KVM_X86
 	depends on EXPERT
 	help
 	  Enables runtime assertions in KVM's MMU that are too costly to enable
@@ -228,7 +228,7 @@ config KVM_EXTERNAL_WRITE_TRACKING
 
 config KVM_MAX_NR_VCPUS
 	int "Maximum number of vCPUs per KVM guest"
-	depends on KVM
+	depends on KVM_X86
 	range 1024 4096
 	default 4096 if MAXSMP
 	default 1024
-- 
2.50.1.470.g6ba607880d-goog

