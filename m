Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7771A26F476
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267642; cv=none; b=CwiITSADvhmv0ETqBeJTuYDsR+ZaHhZhJEIRplIRNcnIJMAZHnKvPeSlnvgChHD/4pXyqGWC3qfLnhmzWLey4vjyH9Rj49JuwiPUmJ05t934aA/XEvofIZSp26IU+DLpvw1+0KvRDwfYCPRKyUkWaqM27XrsPDWae87u9/ihQVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267642; c=relaxed/simple;
	bh=MUaS34HTErlUKtpqI7fAvxjXHwHA3Ggu+n8KjjwOUII=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LjgNGFPX/Na6a7zKCNjFUJnGnZO7BVCrBgf+CBV8JFmSGUVcSmsdvlVuCDmywiR09MhSPqko4AgFCcs+JKt+tuXokWitVNz4FhW1d4Lavyp00lUwUrY1Qg/1Ol1cJuofa9uXrAvnIH4Rh/nKVBTBvtHaPKDfcpXPlDVEY0Bq/wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n6smPxGt; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n6smPxGt"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45626532e27so43560275e9.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267639; x=1753872439; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ArQXXXEY7OXN72DRjey+Kc1kp56HNzq8gc9uHD9gj5A=;
        b=n6smPxGtiN1JgARGAV8AMq077Fc3BAusYnmVmozZGlUKKnRa9eEOB8H9HBKXnkLVVA
         xY1+oChEt15dIjAVFvphRbdsUAFjGVbnIM60Y2BcfND5H2bjTOyMnrt19Odf1h4eafoe
         udGGjXIIl9i1C+yUvR/DwOws/HdnEEuCMtTtGVRZTuGDni5LTai44JHCNA03NiSVinoK
         +t1a+88or9d6MO7WKTJUnhlND8qqI2Hp4dyIV6GPEhq6At4GecO5k4aUaPag95DoQOgA
         ZfGdmbJniN5J+EowPjZbqmOqA++QtpCrawPUtr/YUPtbu2sY70KYcEd29brIw+yCCQMF
         +RMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267639; x=1753872439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArQXXXEY7OXN72DRjey+Kc1kp56HNzq8gc9uHD9gj5A=;
        b=Ys4y6XPiLukH/5z5Y+5WLi6h8nejstByy9bjJNMMSz3NCw0DYS+2n4Yh5DYkmUYVFK
         TWi0okAK6f0XUUvhzRao5xC7LumduHxt7e6w3rwybnRv49hclqq66/r7ngSrflbyp9rj
         FkQTe1H+wruMF4N0hgOYozLMBqQzMUHsz7lnOuF6N7oNNZA35PwW+ZoZYlXlgEgJAsuK
         H4RwhkdkzvJ+/5uD1itiRNQ4z1SYCvaQ1gV91ophWvhYZEuxgXt88Nty2GEkDrKBtusn
         SkTzg5tXkV1G/MnHaKjSy51dnWlp+KnUpV9ZaoxwxEOOao9PqzdFzEopsnBwRM9ctYuG
         A2EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsEbG+dfpKOe1e73tQ/tOMGWKl8xITBOrqqtbyC6z8TMwapPoIb1ady/k1lb7b7j5JrkD0AI0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPrRQEoF/zeKm0cCSbfTPQRLTA0MlSjH4eMLAjUEGeQyVIGSXL
	zmoJqnUJ1AAOaUWBfFtijHg3vO2QBXd4/wlEPIcp1qKFKe8ZNWFumtryBMSgSXq9TlgZlOkOBHh
	/nA==
X-Google-Smtp-Source: AGHT+IFw9/gp4rUKGBmKsgikBacUJjpjGeakFJ8EOn8lPNZtvr6eyYajGoSHpKrwO0vxhCTQzHhdq7/1nA==
X-Received: from wmbes10.prod.google.com ([2002:a05:600c:810a:b0:456:2903:c96e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8717:b0:456:24aa:9586
 with SMTP id 5b1f17b1804b1-45868d4efa6mr17457625e9.21.1753267638782; Wed, 23
 Jul 2025 03:47:18 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:56 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-5-tabba@google.com>
Subject: [PATCH v16 04/22] KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies
 iff CONFIG_KVM_INTEL_TDX=y
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

Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
KVM.  There is no need to enable KVM's private memory support just because
the core kernel's INTEL_TDX_HOST is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 402ba00fdf45..13ab7265b505 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
-	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
-	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
@@ -135,6 +133,8 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
+	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
 	  confidential VMs on Intel processors.
-- 
2.50.1.470.g6ba607880d-goog

