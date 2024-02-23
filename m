Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E15EF9D9
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 00:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648993; cv=none; b=aVbIjnGaWDwVD+ntXJRIGoFyCulTA5V0pHP803ggttCEYsRd3ipLeNdGfzVmr+EQDZ1sJJBIv8fIZ6P8/0+dxRXU9eQli8+3qyCLyKIQDAp6MbU8SDMNdvMM+d8zwVy47GEN2iw5enAfNQtHFM4oJEKr/DAoTtfm2VfCYCJSeok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648993; c=relaxed/simple;
	bh=S9zU+8ciTEx2zWEcC5twkkb3JnOr+rQWNF5dvxUiK+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NXE7b7bHg38rDNW/Y+vF73yeX4vsgifL+w8uKBk/5FNVF9SL12KyEtGkjommZSa3XrCtCey5JZ9WTnWCwXE5lnH3dgyFpUsYi4MvnYbCavtQsDVEO9HSbJ5SdfLNKGghnRmGo6aFwYvxUTek8RqmpVMAxXXpMnnwe5roorfYimU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ybk5zpf8; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ybk5zpf8"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60853aafd93so7206977b3.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648991; x=1709253791; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eb0yDEaAWass5g0hMAU4JrW6cOWG3HVfWM81wBHq82s=;
        b=Ybk5zpf8onYY4GMenKG0tCfrW/qP3ZwJ+M2VZ4yvsNCXhQeBLVs/idXnZhSf8RQHea
         myW8I72fRD+mN365Goo7vh5C/33MzuvP7eDHWKkthhc/qvZ4xV8kNNQtn4kGhLyx0DpE
         wPQAJBWmIZ9zwCpDzVnNQkMCc56OccxDiBBvVLIVi42nXeGqlqBy4tN88zyXy/YNg+oL
         b0PnZCSCoGqOPK2hoyTFrhgWiu38wYRQqf88A3NFCRPPwqHZ+AgCPKtg4o0ZAwId6mga
         57ywF2dzp2SdD2XfBc0NFnvByf5OxwdsXEjwl1Eb+zbLnTKFUc69PgPizedtZH65P8YC
         OKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648991; x=1709253791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eb0yDEaAWass5g0hMAU4JrW6cOWG3HVfWM81wBHq82s=;
        b=do7URQC6KKI/+zZbAMfBBjhZnWP8Ew6lRLM5bv/gVzOpmY1EjYca8wuYRpf718x1o5
         FfvFdKL3RBY4dA631rmO5ROkFBFspzHz4pHlaqcKQNFYUK1IHq4dGw5xrHuQ5qfALwpw
         al+Begp+oDklpCvf522kuwn5D0H1l3AeCrhtLNdktvhKRNi+MrYjXh9uI7TSoiuGxz0w
         6YSJSmPYnHy9OyItq/2riTv70RQABAxMBgXaaPJTJquKN1mwx4OH8tmzYyj2OGaSTo2l
         Iy09qOWEOkUfCyf5Q6zBeJK+gP6/rIMKCQv3Uu0b3KY7GMnal3mk74JGYPhFxKFTWhrH
         oLmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEdZ2pV4WJ7gy0k/JgiJ0mhpFKkoVjtcaIjqmSmYu8n/tGovB87Q01baUP67ijx0UbnXrJajG6KitM0+T8YLXOvwk1UPZV
X-Gm-Message-State: AOJu0YygIsR/9hUvEblQBZH32Q2k+AfVbQjIwaNa28Gs7gXZOemUA/bX
	DJ17MuR7TR7kMcg3BlBGApSZZjJ4D8ZDARe4Qf8YaWxTTd3LbRQ9kpqpw3F3Wnm2IKfnLuY/dCV
	NPg==
X-Google-Smtp-Source: AGHT+IEvW2bccUqWBEeaPsTnJwBxNY/mUnw/8/lv9jsw5DgwqMPifxEtIyNZjQiEUvn62uClAIUzEpQ2hsE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:dc7:48ce:d17f with SMTP id
 w7-20020a056902100700b00dc748ced17fmr187858ybt.10.1708648991200; Thu, 22 Feb
 2024 16:43:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:52 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-6-seanjc@google.com>
Subject: [PATCH v9 05/11] KVM: selftests: Add support for protected vm_vaddr_* allocations
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

From: Michael Roth <michael.roth@amd.com>

Test programs may wish to allocate shared vaddrs for things like
sharing memory with the guest. Since protected vms will have their
memory encrypted by default an interface is needed to explicitly
request shared pages.

Implement this by splitting the common code out from vm_vaddr_alloc()
and introducing a new vm_vaddr_alloc_shared().

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a82149305349..cb3159af6db3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -590,6 +590,9 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_mi
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			    enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
+				 vm_vaddr_t vaddr_min,
+				 enum kvm_mem_region_type type);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
 				 enum kvm_mem_region_type type);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ea677aa019ef..e7f4f84f2e68 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1431,15 +1431,17 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type)
+static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
+				     vm_vaddr_t vaddr_min,
+				     enum kvm_mem_region_type type,
+				     bool protected)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size,
-					      vm->memslots[type]);
+	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages,
+						KVM_UTIL_MIN_PFN * vm->page_size,
+						vm->memslots[type], protected);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1459,6 +1461,20 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 	return vaddr_start;
 }
 
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			    enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type,
+				  vm_arch_has_protected_memory(vm));
+}
+
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
+				 vm_vaddr_t vaddr_min,
+				 enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, false);
+}
+
 /*
  * VM Virtual Address Allocate
  *
-- 
2.44.0.rc0.258.g7320e95886-goog

