Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F99628852D
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829738; cv=none; b=pRdMF/2e++K0hrlEeuf0fKnLeyFsd1e4RNYMd6xgNZ2ljFx7w1Msncvw8b8JCS/eIRjTXjZDb/ue31Fjh8MD4P4o7PWDAn6nKYEpEayq7SQG7/nP8BxHAAK2Ylxrz9/ExOhniueo2SsfP5RCVlFlNhoQ26ceKQBQAF0373I4G+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829738; c=relaxed/simple;
	bh=PIR7Q1NgOshHJlYu6rpDm4VPA1b0uXtS/tyXN6l8IzA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MZlSWE1vWlQKA7IFIK5J18g6ByYGNj4/ABOUy5G42Y54zdiuQH/8qov+8R3+ZdWFmtACArhNxP7ZF8FjpeMHvwIuyBoc9bBJX83HnSFILwJMHAMXpPeLw042f/9LHbozsqkkS/GTeuFy6GvkAS/T+f46V0ZAdF7LCnG75VRw2oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PmE+cCTM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PmE+cCTM"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-315af0857f2so5638641a91.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829736; x=1754434536; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gFnHmY/mnoB77L81qdmfXRRJ+itvZAH1/9yVsOU0ZkM=;
        b=PmE+cCTMOOF4KOmgIUgnZYuInWJRozGKrKkd1q3Vpnyf7nhdG7yIxDA2RDLfkewUoE
         7T2TdLQOAi9gzo+Bnr7tmUlDYOzVzOcw+JKbaVs4Lc1Ik2L5NjeDwKwaM93SEH31p5za
         N5n7Y4Lu9L7AVubb6/7Rlx/kj4Umh+xJC2EGQDT1bsCWHi93OcRXdD3WrqE+hm9Y88Qy
         d26Ho3piU4ykxqVOM9OfUSsr4d96KzQQkEH+NApVhX391Hqd9IL7VtbWSSSmXAYxzLBV
         SESpsOwjKiUNq32HjZzPWhQsMt5O9KeMEtSVv2gIT6xG9B/GDk6La+4VExl2Lnz3NdLZ
         n6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829736; x=1754434536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFnHmY/mnoB77L81qdmfXRRJ+itvZAH1/9yVsOU0ZkM=;
        b=UeByD0Ljcp2CAoAK7MbWOTktryVDHnoibq1aR58/U6VFPG0OYlR+6LIuP9TfCQ2CUI
         NnHUwUou44eTxavKbG9MPIS4Iynce30/issjDaJwYDcuTKiVx4U1SbfXPwd6XKO46+j4
         z5DQU8aa7Ab8tCX8ViaF790G3bVOBDAqKGcajCQGFKsycEQPdKjufuEWqhsTlNUf1C08
         1dprxIfGDsfvHxr2imZIPUu9x1fsi7hVlrgM1GIOmTidZGSIuW+wKPSFWiBf8UA8cSlR
         l3/MBPP5m3GEuoqGmex9RgnS76yGeTSDHb+7qiYVRq+iMVfQS9lpAajNkONUPe2Ybj7K
         DyvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVD2fRCoPADLcABAHJhFzEC0GyCxxsejSZDl/lBe7BaIjPiw96JKcaiKS5SQORmLNpylpl0I5o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdHC9c/jts5hbflRAOh1/b9j/psMQ0+vbS8JHEXhnBl+KL4ckG
	e1AAm7sRkUtwGplDRMYoRxPFNSpsKz2NDQ95uWdq4T8YhZyUmGA9yCOR7xijY9yeEs5/jnalR8q
	1URLHlQ==
X-Google-Smtp-Source: AGHT+IGW1K6V884yFJ/UsdufteHNa+YJReUfJU48NT0v+IzXl6w7knzHbQRXIxUuwcw5V5T6c1ZnGgjicS4=
X-Received: from pjbmf3.prod.google.com ([2002:a17:90b:1843:b0:31f:2efe:cece])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2885:b0:312:639:a058
 with SMTP id 98e67ed59e1d1-31f5de49d4dmr1634316a91.27.1753829736661; Tue, 29
 Jul 2025 15:55:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:35 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-5-seanjc@google.com>
Subject: [PATCH v17 04/24] KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies
 iff CONFIG_KVM_INTEL_TDX=y
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
KVM.  There is no need to enable KVM's private memory support just because
the core kernel's INTEL_TDX_HOST is enabled.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.50.1.552.g942d659e1b-goog

