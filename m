Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF5215531C
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618296; cv=none; b=I45X4KzLYgX+0QIb5wb9klVBI82MlJfQgG/Hw9Zmx08E5m92DOzTJ4rSHdy8k4r7jW2RzA4QAThTCzum6zSwEjkWG890+s+OFI3MXWEjg+3OPk301X4QJCt6tBoTS+KLHyTimIjpRJKm66ogctPBn1vxw9PR2yNFSwH1HVBxVT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618296; c=relaxed/simple;
	bh=JOV+TEixxBnW38RYNc8zuei4nTFOo/1GSbfRHcogFxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YOfPA3O4mhbflnJssUDV2UjZFquhio182lhNObvWXxW+QFpHkO2Rwk4dRjX+xy4Lhamtfy/5V6qGw6nMj/6So9DxQTAipXfbTs8eo0atThAk1yA9EZlJefI1zPE+qylABUC8l+836MROQS5+mw/PkmqvbJl67Sf81nP1AFg0mbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gepo2dSY; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gepo2dSY"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33d6eb5e5a9so1634693f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618293; x=1709223093; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vD9o5ECbAgPC1ivE6LlVq7cfQ2iwgRwXzAnUeOE4gIQ=;
        b=gepo2dSY8fb7CdK16dQJlk+o+gdNKgA/jWQ1yiCUumUsFVHZbveitOFdElCpDCkSfi
         wOq8VtKdMi4jS7qPkYs4pqcRN9LwBocI+YwqXWqzwYA52TE47e+LvIEL44Dca/h25EF+
         QhqDSKt7sWp18Fy3QqjwDsLGM7AzTzBtuTx7FgdpdHBiWWeHWB1mmWIYBsON4UY49CkB
         GEY3LWchtt6tz0nKQC13CLHWa/kxirtdbD3Lco/8MhCe32qsOW605yZu5A+nHLplSIuV
         2f4P3hXsUKwEmQSxSm0NE8ssGRz7rfofSZ0DDxOl5xb5E3ZHfqTj+bH9B0LGif52ysDL
         RRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618293; x=1709223093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vD9o5ECbAgPC1ivE6LlVq7cfQ2iwgRwXzAnUeOE4gIQ=;
        b=GkxiQYHGP8XdDsDdHLNuvZJeTfKs3pjRVr1IANAtOs7cagsJs5znSudYfE6pcHBfyL
         hMvS8F1mTWCFEF+WEFUW7pakwRTIQMQbBX68vyop+/Ryt5gF7GJQJ/J54jh/InVs9vWH
         rcaV3/MzxH1KpLkZ78Gsbqnm/QObh6U30K6Nc6covgq7fRrVsxwn6U7Btd9INJHq10A8
         iyp34uFS8U4z+0hHp3wTy+Muv93HA1ghb+TNDErdmdysO+wLG9RoliNbFF6D/pSQ9h9a
         QG95Wh8fUrEOz1RpoBdSJuukKECty7GpF5qVGKnLTCM6eIDDf0n5TFDqkXUhgmnCKvBl
         oReg==
X-Forwarded-Encrypted: i=1; AJvYcCUBpFLoZ+VRGRjY6HhOvtdVS5toE4pofzNBrgywwJW74UNGVPDfebNELAiAfHjsD0z8aLV/uy+vnX2LItzSfDijUmyBtiGe
X-Gm-Message-State: AOJu0YyEFi6XcIp5NziurvkOkfgRzJGlTtHpY7Tfg1aRXugv3yNNL//d
	/n0/oMYEvPg4I1dFz16LDUVWGq6QycgbBA4Uxl/GcnNcHdOV+fm8HM0dd6GCcgLRBH3TzIEEUA=
	=
X-Google-Smtp-Source: AGHT+IFjuzbek5MC2iMiGgTGZbnIVe892XN4fprFxq4qMMBT6/xXDjSro1ZNWROfqjD/CCRCrpUqesTMRw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:a0f:b0:33d:3ad2:67b1 with SMTP id
 co15-20020a0560000a0f00b0033d3ad267b1mr32305wrb.4.1708618293417; Thu, 22 Feb
 2024 08:11:33 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:39 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-19-tabba@google.com>
Subject: [RFC PATCH v1 18/26] KVM: arm64: Skip VMA checks for slots without
 userspace address
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Memory slots backed by guest memory might be created with no
intention of being mapped by the host. These are recognized by
not having a userspace address in the memory slot.

VMA checks are neither possible nor necessary for this kind of
slot, so skip them.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4d2881648b58..6ad79390b15c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -973,6 +973,10 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 	phys_addr_t size = PAGE_SIZE * memslot->npages;
 	hva_t reg_end = hva + size;
 
+	/* Host will not map this private memory without a userspace address. */
+	if (kvm_slot_can_be_private(memslot) && !hva)
+		return;
+
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
 	 * between them, so iterate over all of them to find out if we should
@@ -2176,6 +2180,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva = new->userspace_addr;
 	reg_end = hva + (new->npages << PAGE_SHIFT);
 
+	/* Host will not map this private memory without a userspace address. */
+	if ((kvm_slot_can_be_private(new)) && !hva)
+		return 0;
+
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-- 
2.44.0.rc1.240.g4c46232300-goog

