Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B8547A73
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 00:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556663; cv=none; b=PbDUjAmeBPJELHj7MvFpEdQESg8bPq20r294qTVIwqPqLAv7Rc9oIA37glJipz0srczIGZacBiTQjlEXvBCPGUNwhbqVqohneocbIm+TTmN9wYuXAwmkH60kJ8vmDzhfUqlPuRF1//dr5JGjPp+AjI5zVP5pgN5JZzrVk1PX3cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556663; c=relaxed/simple;
	bh=9wCSd3rSLA4oI57Um3yrK2ezfr59o98xEdgio1tOA1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=En1c3yrz/hVAhKrvR6n0skmEIVvD6pniDqD1Rwreg28VhqNcbKyOdup9bzeehcAT2WdilpuJefBCiFG+K3GYJkIckqGM3cI+py5199cH1pYvjbTIm3+vl2CGFLgT4CkPMfbkfTM4rVtwXkzGdT9/Jh0BbnwN6ZcPcHH5vmbNhXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LlwoYo97; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LlwoYo97"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2efa74481fdso4777878a91.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 16:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556662; x=1737161462; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9d0sb2aXj7DAHSi3NyOXr17347erebt+0rHoY2hViJM=;
        b=LlwoYo979af5ffpMkYugVhch+CNaIumHNn97j/oH/mzuyeLAThP6Ddc9X/hwyc8YyD
         u4mqrjoaXEVAGkFMg/6rQOiOhmeKUeGub048AvanGxuIw4tXv4P9gzEtbx/KkgYNdplx
         yieB6/bQhbpeOLwaoYMQCg8zQGLgdpvz+RzzcjHvELuC9s92PR7jXC9wq03+52QADYrD
         ZdavC8liEObywgTot6KcwMcF0T2Z9pSVUlI2ZzEsUCoAK6xyBmbk20WL7J3SSfOaNv2y
         vlmas3xJmPi8aVXUY7eUXS/FuEo4XWtjnpMNRKPQllnHS8HRK+FPypxWVu8sLLZJmRDp
         rTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556662; x=1737161462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9d0sb2aXj7DAHSi3NyOXr17347erebt+0rHoY2hViJM=;
        b=C4+6tGwtjpMhzHGNOOcNMP6bh+Vlt7kFcD5XUArKedoJevf7I2zggNv94AXCKqIivK
         4HCc01C80sm7rh6S5UCoQnWNBkOObvuXq3D/u74Mbl0pCQ7ZQc45f1HlosC0kRK9dqjX
         s+X67cNKejNKRZRD75PWlaKw0xq6LV+CamUwbULU9Jru56gfPjMxKVzfYUMMUKZ+ubQQ
         jWzwBU3bNuFMCeAkBkBWQ0VkO4DPTqhWm4xC/EXzIqy1WHGzgNsRVIVhM+s0LIiFKZEk
         jkRCxnliupfPCk944zDGjXqoLNVYD60aAN7kpj4tnMOKa7YvsOPiLFoy+pZi+Iot0N7t
         U2vQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/mOIOK16C7b0ZIowbi/Ct57mOyvBfYfCmNM5/9q4mtUBXevspz6RJiboesGI6TVZ3MGZWoT4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfTZvTt/1SNI/N+pN32jpgHnpA7Rjix08VTj7/SptlGr4LJMTI
	lTiiSJ15iZ3ToiPYlFaRoBUHmj4yXAYlUoRjcEj58qqEVoszO4q40LNj+p7g+5FDbvf+1T7TJZe
	RHQ==
X-Google-Smtp-Source: AGHT+IGlLX0aEPqXGbQsPjSqI3Z9q/GgP2EA9enACEq8PUpXduEFLRvRbXw1OHEj1+uEtI1vezl+E8v1zzM=
X-Received: from pjbnw2.prod.google.com ([2002:a17:90b:2542:b0:2f4:4222:ebba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c5:b0:2f4:423a:8fb2
 with SMTP id 98e67ed59e1d1-2f548eca27emr18806754a91.20.1736556661971; Fri, 10
 Jan 2025 16:51:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:46 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-7-seanjc@google.com>
Subject: [PATCH v2 6/9] KVM: selftests: Get VM's binary stats FD when opening VM
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

