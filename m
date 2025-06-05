Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5081EF080
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 15:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137917; cv=none; b=b3JxPc4tGaslTiVYVHk2fqkZyqu9vqSKmTlOQ7Ta+bl7K3dUHJBGoWmxUJ2k9PhsCLwjWpmFi93X8URZIX48qEUeNJpCgk+FYGY/GpXJJcfwLIINr+9meVWvFm2yO2W9NBQoCgJvgcGhbmFRNKUyp5UVkFVO/VhDHyte1oxhKSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137917; c=relaxed/simple;
	bh=BK3VzOi6x3EKu5QuZepEQ0F5haIyPLKoEu+JnsSG2Yg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rFJryvbVg7MsSDFk3FOO4c839sXTJ4KIA4WmZNtqXZZFtGA/+kcgMtcpxyKBnPuzwVa+O60Y3W0wZoJ0i1XHt2tla9icU5CidbcQ0wquQ0OGraQNbTsNOj+A8IzoS4ggO0y3XOiYKt1cLr+7u7HaAwIxvQYgwxU6aJyiIfH5fu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ruV2+kmi; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ruV2+kmi"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450d50eacafso6410765e9.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 08:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137914; x=1749742714; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sdTi36595hf+KxJmYyJWjfbB0V6sDCqPIzT+xc3Ya54=;
        b=ruV2+kmiDH5oYJOd1eEHtxJXimgShuIDymQk1OFAZMPMMi6g8xtAC3bOKYPirDRAso
         cf8jGqX+f5dKT4gvbz68XHo2Cl0Yg/EW1saNOf4tcwKBCsSGen5rcSw+T6JN/WJcDcZB
         yMHIZVfM4IrVnq4/j1qGUbb3YM2uCI1gOm/t6JOycyx/COQhxZ0JJ5E2msPQpON8EPOg
         XxfJBzLzK+t7XGfGB+ljBheVYHLNk7RkT0vpmkBtmVQO58xK0HFoCqs+xEA4BTmNvXYX
         e52mfJBRH2peWz7lv6IyShZIC9xaN3i88zRi+7v5t+Y1etvYr3R93o9YSdDAZ7l0rHB2
         zfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137914; x=1749742714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sdTi36595hf+KxJmYyJWjfbB0V6sDCqPIzT+xc3Ya54=;
        b=LDUHdARlyZS/NGTgtZZGnxZFW6/AaAwcU8NNMA+miNDOgCo4KlcgfcrfN5jE+wxza7
         Pv59lI5Dylw5J2d5iyBxGEy71swLPeTLOoiViKh1weQROr2jftsi/Ujz2qicyrh/Kxp4
         3uU6AiwU7jszmx7zauS/A/d/RooN6Rm/5JPginwDTIX5vVeK8DncLP3rL6HI2jB6x7GP
         PA0kmlSqDcVKobfI+D+Zezux+fyXmK6ZhIqOh9dsHyMvuxdh6L4BbiadCPH/57vr5CxP
         nEcMa/X8xPiZcisgTQlZuF4y+OQCMEiFbPoOMnnuVnL9fBT3Ri+6k07ZqzHxTkSVMtPb
         mGBA==
X-Forwarded-Encrypted: i=1; AJvYcCX0iwNUhV32yym49pH4QjTEV3TeWm+OFz5X2Eqzvb03Xd3Dyz52JIweDvzOpRJK7/RdSS/1Da8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkmB1fFi+PUkQ1TXAVe7ekXzrw2Dpcq4zD19AB1PobTlpFQ6Lg
	GDyAIqMt0VFGylDXBbpwKTdQPljOSX1ya49Q2xT6rfOJfXhbuaar4WZ36I2VSvVGRnVE7RBsFm8
	V+w==
X-Google-Smtp-Source: AGHT+IHjMKXCvTmBxoiQUc3S0//vqXVb77uBJR4SvhxKOwINqq6jYrFaYhNl/XwH/tFcftUafwOB/rmHeg==
X-Received: from wmbhc7.prod.google.com ([2002:a05:600c:8707:b0:442:f482:bba5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e89:b0:44b:eb56:1d45
 with SMTP id 5b1f17b1804b1-451f0aa7ff9mr75040805e9.15.1749137913905; Thu, 05
 Jun 2025 08:38:33 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:57 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-16-tabba@google.com>
Subject: [PATCH v11 15/18] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
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

Enable the host mapping of guest_memfd-backed memory on arm64.

This applies to all current arm64 VM types that support guest_memfd.
Future VM types can restrict this behavior via the
kvm_arch_gmem_supports_shared_mem() hook if needed.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 arch/arm64/kvm/Kconfig            | 1 +
 arch/arm64/kvm/mmu.c              | 7 +++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 08ba91e6fb03..8add94929711 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1593,4 +1593,9 @@ static inline bool kvm_arch_has_irq_bypass(void)
 	return true;
 }
 
+#ifdef CONFIG_KVM_GMEM
+#define kvm_arch_supports_gmem(kvm) true
+#define kvm_arch_supports_gmem_shared_mem(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 096e45acadb2..8c1e1964b46a 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_SHARED_MEM
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f14925fe6144..19aca1442bbf 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2281,6 +2281,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with shared memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	if (kvm_slot_has_gmem(new) && !kvm_gmem_memslot_supports_shared(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.49.0.1266.g31b7d2e469-goog

