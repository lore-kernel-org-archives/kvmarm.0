Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FA41891CF
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038089; cv=none; b=eSSItl7Oxo4+qww9ldC7435ZgyAMOC5u5d2RqDr/M4F4bMlUwpNI3WcEc9+yIQaISLASaHfvzmZ21yig+iocgs697QS8y8tHAwtdaYqpBYXtlsW4Fo0LuwDdPE1s3n5PNeGcqRV7F2t7DC7gQ7nHVFEGKHqBKZLmuJ5fidqvCH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038089; c=relaxed/simple;
	bh=W0AdvWeEkFlf//sy1P86MoI9zdYmxDa3lMGHJD2jZgo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SlS9h7p23HzV5yb+9R1vCuC+FEKQEgj5pxsXqrccRDvtGmqYGzSfhbQqK37pUCPRZ3Sfh31L0sRPpeYNbEziui5DmaJp26dpzD+E0wy47SOYerR4d7DcGwcU8QuMv2tqoE89cHSHvfdNr7JFB9shUCVX7vEGmb2GZwwStrFwTq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ubVniMYv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ubVniMYv"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c96e73c886so1496053a91.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038087; x=1722642887; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oFlnnuKhNT9l8QiAImtf2ecgGSNucZgQMIB0EjCSaJA=;
        b=ubVniMYvELRlJJ3YBgbaYIwb4zMCZ3IaBeuir9ry/QPfEnP7t5egpp/F1easEfy9U2
         oQGTR/v1ob4AIx90VHsMJnkHDat+vjSbAwpXRWEZr546976k0d/ekmNyls+uhCioeUaE
         5xbcgsLFAgCU2FPClB+xPqVN68vZ+1Sl/pXhrpgKNtvuFn06qLgRN4MuI+EIrZIdd2/9
         ZICwtHsXLsI57HZOkD762v/WQMCtB/UQKQ1w+ayF4SWhgUrospJRniQH5uqPeYyc8btK
         01/hwZghmN+1hzjq6zlBlKx/Sziu2c4G1LrdxwkQfvDP98PK5cJYw2op3RwrpMFHjRI2
         yZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038087; x=1722642887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oFlnnuKhNT9l8QiAImtf2ecgGSNucZgQMIB0EjCSaJA=;
        b=tKNJF7gxbbDX33jx+flW91EqIwzTLWp/SpHv/XKrTxE0Jd8aJI9YbAz4RM7+6d+1ag
         iKVR4uh3k2JrCnPcgHvJATq9Hf0R+cjmk34Y7POtSyC6EqiFpPDo2ASzm2pm7sltxFUE
         8OkXn8N8TeCcM97Fe2qpVMx1g/TtQYvZj3b9uqlieqobr2XNzfXRlThICeXMp0ni87JN
         rx3yADb0VYoMQ1uHHHF9y9GUPQggbBVx72NwypSO2ZPBcbT/ER/rtA8iswwhiBFldyzd
         Z8QjZbrBTf1kXeFC5uAvxla3/XqRHi9uNsDWvqkPofd8C4TjMJ6JYNdj2Tqe4UIgMrmK
         jFtQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7uOOkJvTNIWbedQ/s3KMldsNrSQve7pXPC8axzY8rIm+kSjRGcRGRGHJD/fD9cDQiYxqI43TWslVzi7nObXOQJ/SKiCzm
X-Gm-Message-State: AOJu0YxQQcxN5WRrUdPrJRPdb10uGaK1rwJstctoJzideYqADSLvGVTc
	DN2KGxDsXaoT/bU5FJvQSJUSlWnxLe7RyINa1ttGlhCKPt0K7lBhX1A27fBbkYTBXqnFyBL8U6B
	Ckg==
X-Google-Smtp-Source: AGHT+IHpYPU/r0yyvqEOzDrNXs+L4GUiZCI45y4AH9hPwSk8nxMjnSbjsFMJ0nzRNCC8+VosuScTVNX7UfA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f8e:b0:2c9:9a89:a2ae with SMTP id
 98e67ed59e1d1-2cf7d4317d2mr2552a91.0.1722038086790; Fri, 26 Jul 2024 16:54:46
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:11 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-63-seanjc@google.com>
Subject: [PATCH v12 62/84] KVM: PPC: Book3S: Mark "struct page" pfns
 dirty/accessed after installing PTE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Mark pages/folios dirty/accessed after installing a PTE, and more
specifically after acquiring mmu_lock and checking for an mmu_notifier
invalidation.  Marking a page/folio dirty after it has been written back
can make some filesystems unhappy (backing KVM guests will such filesystem
files is uncommon, and the race is minuscule, hence the lack of complaints).
See the link below for details.

This will also allow converting Book3S to kvm_release_faultin_page(),
which requires that mmu_lock be held (for the aforementioned reason).

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_host.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_host.c b/arch/powerpc/kvm/book3s_64_mmu_host.c
index bc6a381b5346..d0e4f7bbdc3d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -121,13 +121,10 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 
 	vpn = hpt_vpn(orig_pte->eaddr, map->host_vsid, MMU_SEGSIZE_256M);
 
-	kvm_set_pfn_accessed(pfn);
 	if (!orig_pte->may_write || !writable)
 		rflags |= PP_RXRX;
-	else {
+	else
 		mark_page_dirty(vcpu->kvm, gfn);
-		kvm_set_pfn_dirty(pfn);
-	}
 
 	if (!orig_pte->may_execute)
 		rflags |= HPTE_R_N;
@@ -202,8 +199,11 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	}
 
 out_unlock:
+	if (!orig_pte->may_write || !writable)
+		kvm_release_pfn_clean(pfn);
+	else
+		kvm_release_pfn_dirty(pfn);
 	spin_unlock(&kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
 	if (cpte)
 		kvmppc_mmu_hpte_cache_free(cpte);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

