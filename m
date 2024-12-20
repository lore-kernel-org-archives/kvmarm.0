Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D044A17C20F
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 01:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658762; cv=none; b=FhwZvG3d8048lRN2SfOhHvnzLybAEFAfryFB/sBU1GQSl6TqVH2cEqQclpqcpmu8+RA0aIQWh0ywUq3ODN5WhYORldOQxYAvG580c5Z5K9C/uOem1sBlKjA8BJmA4orcOP5om95YRH3QxayEb+rv00LHmkU378ZXmhm+lphjvPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658762; c=relaxed/simple;
	bh=9wCSd3rSLA4oI57Um3yrK2ezfr59o98xEdgio1tOA1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QCobldvoJLns7WZNFz3my9RI9hsaiuGDn2peHp3TgCk9BXLFNxU3cbUtX1eDtfUsdU+idInC6GaHHoYWr9dguQ1qbBGi/9Ckxs9eQ6snL3dc5CwSQFUhGKa6SKVNvuikd53drdlpFXOrD8jSy6lUmCsQIG4a6Er6EwOb4sk2p4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l6HH22UF; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l6HH22UF"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-728eda1754eso1968896b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658759; x=1735263559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9d0sb2aXj7DAHSi3NyOXr17347erebt+0rHoY2hViJM=;
        b=l6HH22UFUO8HjBs0b8t/Rg4i+jxiR+NelBs0DVDI9FVUqLRLINlQeGsa0Qlnge6q1z
         RV28xtKjA+8yFfJnxAgftxUufNDzyQLxWSNFnugTGDnv7+TVBPctNqFi0tY6NAENBpPn
         /3UlH/7wgMO3hXOU4Qb4RpgUrfKaghsoX+syL0PynaL+4+jYzMGhuxXUIgzTO/P5CghN
         GrNd9TL3sIoqFlfEsnWvmnr3U+Fnbdf4A4Fx6wwO/p500rJ5Lkqe+FyKts6BE8oj4ggZ
         +2ld9fdqGKFMuusLM2IE6MxUuJL59saYELyfqlMvuqc2KXwn05Dtira3R1ECDKhd5M1L
         7o5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658759; x=1735263559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9d0sb2aXj7DAHSi3NyOXr17347erebt+0rHoY2hViJM=;
        b=jBVsdUD7XZ7gfXcxrzCqMTbrzcoOrZbJsRDhelOw6JtNbyvh2of8WY+gYmsQ2fecJb
         Z8j594tDiBuT3R8nEDB/ioPdWenDh72HC5QmHC58OBw0Fyz112+hDwqVbnXplgJE8FZ2
         nnEjTVnMUnl565MLIfWWUoujbg2dM+uUQ7VC/56o+g+NgriSp7US1gkLYUnjbwDdGoH8
         DxsB7tC3odB770jSuhePL4SwQ9XAg4g8HeslGaNPW6jaYxDtdyKjXFNnppWYltKEO8/J
         +1xw9nGrK3SLThbfBtaCY8irQlHdlQMmdtC1cVCBxDAKOqAvzOAVgXOG0g2vhFrbXjQR
         OzdQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/BpvkJ55h+EEa7MCiaXPdjIsHrwA2w2nm1GLNfvh1fqz1+i01mgYO5CfYKjl1VUM8ewAcXnU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcNdxnp/R8AI/xRD8WM8n/AQKKzz792yRb/nP5YUTAVNxi/csW
	6Av9r2Rrwbi50S9sT7OvePj+ZI77zp4v4rwa2sMEMu+NxLwM4EJFznGr3Dhx8Ff+X4kQM9VTNsC
	3zQ==
X-Google-Smtp-Source: AGHT+IFCVSOEBNw3Lv/7iuAoV97N3pDi0VWzw4l+AQLpoLja8FzKhTyc8mSa5fPmEkzN6L6pcIM/EKjTQ3o=
X-Received: from pfbby5.prod.google.com ([2002:a05:6a00:4005:b0:725:e39e:1055])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cc2:b0:71e:4cff:2654
 with SMTP id d2e1a72fcca58-72abdd6eb8cmr1219933b3a.6.1734658759224; Thu, 19
 Dec 2024 17:39:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:04 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-7-seanjc@google.com>
Subject: [PATCH 6/8] KVM: selftests: Get VM's binary stats FD when opening VM
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Get and cache a VM's binary stats FD when the VM is opened, as opposed to
waiting until the stats are first used.  Opening the stats FD outside of
__vm_get_stat() will allow converting it to a scope-agnostic helper.

Note, this doesn't interfere with kvm_binary_stats_test's testcase that
verifies a stats FD can be used after its own VM's FD is closed, as the
cached FD is also closed during kvm_vm_free().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c88f5e7871f7..16ee03e76d66 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -196,6 +196,11 @@ static void vm_open(struct kvm_vm *vm)
 
 	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, (void *)vm->type);
 	TEST_ASSERT(vm->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm->fd));
+
+	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
+		vm->stats.fd = vm_get_stats_fd(vm);
+	else
+		vm->stats.fd = -1;
 }
 
 const char *vm_guest_mode_string(uint32_t i)
@@ -661,14 +666,17 @@ static void kvm_stats_release(struct kvm_binary_stats *stats)
 {
 	int ret;
 
-	if (!stats->desc)
+	if (stats->fd < 0)
 		return;
 
-	free(stats->desc);
-	stats->desc = NULL;
+	if (stats->desc) {
+		free(stats->desc);
+		stats->desc = NULL;
+	}
 
 	ret = close(stats->fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+	stats->fd = -1;
 }
 
 __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
@@ -2231,7 +2239,6 @@ void __vm_get_stat(struct kvm_vm *vm, const char *name, uint64_t *data,
 	int i;
 
 	if (!stats->desc) {
-		stats->fd = vm_get_stats_fd(vm);
 		read_stats_header(stats->fd, &stats->header);
 		stats->desc = read_stats_descriptors(stats->fd, &stats->header);
 	}
-- 
2.47.1.613.gc27f4b7a9f-goog

