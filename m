Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE652E499D
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267659; cv=none; b=T7z4nK8lt3ZxYtpsoAtKLko+ayz2uTdj5zkD7HPYq7e90ukg73G6DWYgapCEUbqPRJVFw5LJUI9uRuMBB2g3QnZk906ijZtMJv0Shao2fDotMA5FFAIOyq7UBHi2fkQN8r6s5DFhygoRq/b4hLBu8WaOS3F7Pp1CeKe4xktqkcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267659; c=relaxed/simple;
	bh=/cDVbhBcqq9YzXQlcb59HQN10toZNfmITuLlDFWLfKk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K5eJDbLs9tO2KS9GYPeJ5nA2Ic0D6ybV3iE6xZkY3x/m5qSQemhnXRU7eBakJ7wlkmESfOLhxuTiMArsgIh+mlcaZBIhFRhDroQJptF+VDbXUVEwBBMp06R925mbDr6Ne0jvpkslom4U+NlDe9bAywzinFGGyKoIqaD0BPjxV3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uP/6JusH; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uP/6JusH"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4f6ba526eso4272083f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267656; x=1753872456; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KlxcNDM8GfkNbLw4o3YWN94YEp3XYisy/OehMz9D7Lg=;
        b=uP/6JusHBEl4Qd85vXFrszljoY8QuMj07SKjeNFukdU/ObnuIi6NGL5LsT8C2HsPnh
         9hLm8IPWIjfGgXeV/kjRbddQG0O52T7yo+h2a9MuvHPzEZXiBmRBfKtG3wHO8DzeDhry
         nIN+yE6S32+oQzbkoJgRq55sswCbFwB6TP2T/owILMDQaf53XqdjdrseqFqhnzONi9sf
         7+eX4YtxseA8Bkl6gDJgVA6IsWq9HDnWvz4hMNe4MOvMznGoeCql01fuyy8RC3ckGjUE
         xS0kqRpUAe8k7E+1SejmBx9Qw6p2FOWkcJ5PCgG7n1OfIujbSapC6DdPo9eNkT9rxeSP
         ShjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267656; x=1753872456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KlxcNDM8GfkNbLw4o3YWN94YEp3XYisy/OehMz9D7Lg=;
        b=HNf127KHv3GbDNc4tsNvwhC9zFXwhtr6dk4St/TXMre3iip5Tq0r5pgmS56tUfqPRf
         ZqTago85NqKlZ9m7zu4czQlSfgUf76mx5ZCrmOl8SEPMp3XoPqoOjGsiPPu1S7sfjfdi
         D86dnVgOTdEIF1E43v0Fiiszp/zoavDWP8IfZhJKdl8IecldGlReAAwoXOnLGvTc9YWT
         bhAW7xqPBJi9Y5kmIo6108x8nn/wj5qeTDpq6Ja5MWMFu0rBEUUo/WFmiGy+Xm2Av7oY
         8UCUmVzDfdt0iCX0sMf2+3pv/FTOly0gFwOwUJ7+0ixwFXYbzKXwLUCTSkog5ergm3NY
         vqjA==
X-Forwarded-Encrypted: i=1; AJvYcCVkvoZOob5YrRjhqLjxNgTyU4ICAwm2SXjT6dXE1kmFqnsRYewgcViCKxJvqOR5aph9BfBF310=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfwBgyUvQU+xkPzbi3+qLCYDHqqcOiPNrtJMb/He+MlhEe2fUf
	Pb4Mj+LFVksafFuLg30tEtgQ1xdL0kMWdOS1ldi7BieJ46kP27vwox1aSQWChk8VeC6Jnb3C7BO
	snQ==
X-Google-Smtp-Source: AGHT+IGyaKsC329OBN9V1qxHlr9H7PRQZ93BDS0adc/MtT4FbbSuIMkwbSVam8vf8SbmIv3tftcMpfJ1jQ==
X-Received: from wrbcg16.prod.google.com ([2002:a5d:5cd0:0:b0:3a4:e199:883b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4201:b0:3b4:9dbd:eee9
 with SMTP id ffacd0b85a97d-3b768ef951bmr1536942f8f.36.1753267655654; Wed, 23
 Jul 2025 03:47:35 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:11 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-20-tabba@google.com>
Subject: [PATCH v16 19/22] KVM: arm64: Enable support for guest_memfd backed memory
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

Now that the infrastructure is in place, enable guest_memfd for arm64.

* Select CONFIG_KVM_GUEST_MEMFD in KVM/arm64 Kconfig.

* Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Ensure that
  guest_memfd-backed memory slots on arm64 are only supported if they
  are intended for shared memory use cases (i.e.,
  kvm_memslot_is_gmem_only() is true). This design reflects the current
  arm64 KVM ecosystem where guest_memfd is primarily being introduced
  for VMs that support shared memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 arch/arm64/kvm/mmu.c   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e0..bff62e75d681 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GUEST_MEMFD
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c82df80a835..85559b8a0845 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2276,6 +2276,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	/*
+	 * Only support guest_memfd backed memslots with mappable memory, since
+	 * there aren't any CoCo VMs that support only private memory on arm64.
+	 */
+	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
+		return -EINVAL;
+
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
-- 
2.50.1.470.g6ba607880d-goog

