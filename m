Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D89579D2
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 00:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556656; cv=none; b=gV/rvOz94M3kdUVpSFUXNZcIRFCpCSKgd5DbaRiPcKtJRrfu4PrXGNYVApY6NJHjGmx+4/AWKvCUz+0+Vi3DSYFE3+2xYW+zH59zQGuFnfWfpRgZngH6PIIsFX1wFCE5VkSQdhgqe/I/0V6zc0E8cuYrdTtbz0gKv5CV6ts+ggo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556656; c=relaxed/simple;
	bh=vUAkr3IX2LE4GH/mlPkbcxzVyqeoUOtvVrlhcSINMSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TMKPwQCVQ/IChCr5DdnovqqAhZz3slhqvcBtv2EtVvW1Zlbj3JQ7qFsk1Wx05bnMrYzYXmLZx8Zx2FW2qeynalWVfIrgs8xGeAN1HPpr1axAwdRSEu/g/bDlHXL9ixT5VIZQUvsU5qaREsEwxm3BRlJXCEHZ1QambZoiC1gu/LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dTEnU9X8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dTEnU9X8"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef91d5c863so4756924a91.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 16:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556653; x=1737161453; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OYKvlAfMuP2ktBfEDhDytfcvSdR/S4IqDZKQdTsYjuw=;
        b=dTEnU9X8kSCFSYZkADWY32Mn+hfStpk+qi1KImPSXIvi/HmWtX4bw6Sj7vQgLoBJZg
         42xCUrbIv3J445M325fFkK6mlPPMkppmc95zE8LwwKZ1WxBwy9ijlXvEckrOA+7rBcBg
         RGYUlCz6GcDZ22vi8bwnrVUMmegOEcslXJgH39fmJAGUsqCObr4qWD7b2Wsekse9nnAC
         EG8R8a6Ut141o+WO9VXHHiYfUjoVejwS/eyJZCzMHnyPB4Q91NtMkwr9PiqodLxQdSIa
         wNX20eDuHbBv3HKojXcG+PedI12N8i+pn/wBl4udkijq0jSec/DkGKyDHqzSWifoXZYx
         OpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556653; x=1737161453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYKvlAfMuP2ktBfEDhDytfcvSdR/S4IqDZKQdTsYjuw=;
        b=PlE229PyfuYpkbZg1cAR4nLy29ril/CPPfqiN+Dp74AXrQ5BTagi8DzZBQ1+nfEOtf
         CqUl8uMdKBDVVaIiuo24iork+/nQJnGUc+pIpceeDt7YBoodolecm77WRAjCGGx9ZScd
         oYg1GTAP6vkSFONIIxTbxrUclY0Kfq3lUtZi+uy2TgFZ8rEbsDnHwrVUVL+ptD0GSm5Y
         Q76oxNkYo/oEjMNsuTOTC6qL3YUINM2KxDZkZpH0IKbW2rQX44kkrX8qh99r31vmPrg1
         Y1YjffsVBgpEfh9GJcgXCdVbKZyXWIi4N8D+EZuIwBKVo0LesgOmn55wvyGMxV1ydtK2
         aNdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV+EwSnxEovo6GHSxrI/yuIkBne8evUApugpWAltlaq3FIlz14WNIezeR/cZ7iOg9uMklGJ24=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxk7QoxAVMHYIf3J8Mor8XlzZsVX2FWJAO1qP48RHKkPz27WJUx
	9HIjVlvG/2aAc98Mk1gLMb+Qyrisk4oDrcxhwVJfBFme5wChy6bKgE9oN4kDhw5oxu9oPR+a5KA
	2pQ==
X-Google-Smtp-Source: AGHT+IHC7L4dio3zRElUKJK6ZXLcnIeUcETaJFiIoDB9K4Jc3JVwsDgdf+5YQVS28IyDhPWQi08akvDOKi0=
X-Received: from pjbqi14.prod.google.com ([2002:a17:90b:274e:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f0e:b0:2f4:49d8:e718
 with SMTP id 98e67ed59e1d1-2f548eac0bfmr19303629a91.9.1736556653508; Fri, 10
 Jan 2025 16:50:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:41 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-2-seanjc@google.com>
Subject: [PATCH v2 1/9] KVM: selftests: Fix mostly theoretical leak of VM's
 binary stats FD
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

When allocating and freeing a VM's cached binary stats info, check for a
NULL descriptor, not a '0' file descriptor, as '0' is a legal FD.  E.g. in
the unlikely scenario the kernel installs the stats FD at entry '0',
selftests would reallocate on the next __vm_get_stat() and/or fail to free
the stats in kvm_vm_free().

Fixes: 83f6e109f562 ("KVM: selftests: Cache binary stats metadata for duration of test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 33fefeb3ca44..91d295ef5d02 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -749,7 +749,7 @@ void kvm_vm_free(struct kvm_vm *vmp)
 		return;
 
 	/* Free cached stats metadata and close FD */
-	if (vmp->stats_fd) {
+	if (vmp->stats_desc) {
 		free(vmp->stats_desc);
 		close(vmp->stats_fd);
 	}
@@ -2218,7 +2218,7 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 	size_t size_desc;
 	int i;
 
-	if (!vm->stats_fd) {
+	if (!vm->stats_desc) {
 		vm->stats_fd = vm_get_stats_fd(vm);
 		read_stats_header(vm->stats_fd, &vm->stats_header);
 		vm->stats_desc = read_stats_descriptors(vm->stats_fd,
-- 
2.47.1.613.gc27f4b7a9f-goog

