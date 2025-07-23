Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A9924BC09
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267641; cv=none; b=UVIhFdIpCzk5xTdAHkX14f9wPy0C2QZ40comjsssoIklLIB/DapueKIK3BCyROWRut1dYrX5yDx+ZQzUcX/UDJCx5lg5h4x5qY1YxsqI3BoJ29iAR9wU/hpOu+TqLhgbC2vZMche/qM5dQIVy2V0lJTLPJDfHwxdV3z22IRCar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267641; c=relaxed/simple;
	bh=EH1IJuXG8Ao7tj1busmw6p1cNiHU5gyF41SXMJEr5/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l8XYO20BzAROYLZoANyYzcq2vxGY+sEjkSKw6xLrAO2eJo6jz8rFxrvKW3eSFERGdZZ0f5j1yG4YNd6FqqT9tgVOqMmSA7EK//cMnhFBSOuvv4ASw0oRog2psRIP7NvZrn8JhxJCnkD+9H0PQaD1kFvEQW43kEPtkFaCTs2Vcx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WveJw4Xs; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WveJw4Xs"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a52bfda108so3147506f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267638; x=1753872438; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzfZi60oZ9UO8raD765xxT1ZFhO1WsdtivBMYCkRGQ0=;
        b=WveJw4XsCaU/2Ct8qez2ixs05fO+YnjmvNJIaK+H5NLm+eT343u3/eq+W9LLVL0fpH
         ++qNPe2ATeGY76L1Yuzt13IDusmwSaoNJMQbddc+S8ONGv28wmYsKxCCng9SpNA/p2Pk
         BMkwV5RIS3zaZaM7Nt2w3n/LF7Tosv0J+HnSHrE3AQ7Opf1cneJoQ6IFDw8WvmLnFzgr
         nvjfVxEsbAqBuS/N0nMtOEauiLhFttWvr6JTJl6iqyvlnZOiIQ8NppQz/7HytluueBZ9
         j6YPBvX3t9d7N6r2FGMQYIHsOItqTcfmv/Sfj9v5Bqk1ym3z46FJmkTCm+kefnspWPK8
         bYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267638; x=1753872438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tzfZi60oZ9UO8raD765xxT1ZFhO1WsdtivBMYCkRGQ0=;
        b=rr3LMJD92crXoKeCFuGIk9A1hfAp5VNToA0KJEd69HAXuAS3Nb3rTtqDGEZf8OtNqJ
         BRbexVka37fp42lMakqup5+qpG77aGgluhQnA/I0c/LjMkGXOMvPYNnHCQ5DZQkIrJRn
         Oout+N5NdJcuImm80UW/fGGtfn+Il/HW5jNJkQN/G5KaYiNhRMmuQgqYeNxqVcKG/HWm
         jSIHp8Z4IPTIAaRvL1beoNxfU2b1qM3UaLLr167hSEDqOK+ebeIcuGG1gUjCnA/SLHnJ
         WKjMn6Wie+sX3Tu4tUZ9K4UwiTSoli7miDxT20pxwd53UjTQzLjamTiBB7tLiTja9UNZ
         +0sQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHb0EWLT4SxL/Gn5rTt5k7zv7Xp0A8jU/oP4na/ULk8QPvW6RACSIyzV5qPo+cRfpzYOp2yKg=@lists.linux.dev
X-Gm-Message-State: AOJu0YysRjTF8MnOnk1oUqd9VCa44ry0pWA+cWcKkiFMUqCZzw2opQ2J
	RICf5jUcMtE7R7z1jIxRt8kwh14F2l48qiO+r/IFfHMNlUbuLqGcrLm6JAEqfLs6vAtkNMnWoc6
	rgQ==
X-Google-Smtp-Source: AGHT+IEo+s/VxPokXQ2vXolGdtsGLlmgFDoyNvmXKyvht3UuZi1/vOjCI4q8w/CILxGvMZbP18VFTQSgFQ==
X-Received: from wmbhc10.prod.google.com ([2002:a05:600c:870a:b0:453:6ee6:e62a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26c9:b0:3a4:e393:11e2
 with SMTP id ffacd0b85a97d-3b768ef9646mr2055449f8f.34.1753267637872; Wed, 23
 Jul 2025 03:47:17 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:55 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-4-tabba@google.com>
Subject: [PATCH v16 03/22] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly
 from KVM_SW_PROTECTED_VM
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

Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
conditionally selecting it from KVM_X86.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9895fc3cd901..402ba00fdf45 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,6 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
@@ -84,6 +83,7 @@ config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
-- 
2.50.1.470.g6ba607880d-goog

