Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DB62066E1
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 20:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455810; cv=none; b=fPCvBpObaunN0TZcXZjSddMsioAHNbAnpL7Qgkpyu0hFoNCL2wTKC7wc50J2sFfNv5+IWuH0WTH5f57V3t2Ybtv5dwcxdsWaxsfT7q1OHwJWMuw4qqoy+KsvkwysokbtHieBxMSa7mhItuGfaNiShWGlikzGF8G1AsaUnwVH6CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455810; c=relaxed/simple;
	bh=CDB0cv1aSXnhbWgtnZoFSntC80Trm0mVRdwCoCUf0ZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LmtB3MLy6BHlmBDuvCnEg50rK3QfYRa0Uv4qSiVupVwNwUUwcTLAqcH9O16VNfMlSzKsS1pGPdc2YbW4iFoeJlHXE3wpZxfxglx/StAQg+6thCrLserE5VE7t7C3TqMcEah+Xu2WSyYbn/+VqUhgHf29LikS5AFH/nbVlv9PrN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bM/5oiHw; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bM/5oiHw"
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-7b6eabd51cfso218249585a.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 12:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455805; x=1737060605; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A6d9SLIy3ba7m9amfCG873jUIu7Rw+T0rUlSTA7+tzA=;
        b=bM/5oiHwCxVD2tonjLzAGjJ9FE8rKmr9GVKbp8iLnodibqAJkSwKmALq4MT9Rdhc9X
         yVmQyJYG1O+YlWxWN+pyy3T1Y7vmAv0qpGx7RWIJuaGeArEFvjw0xZg9YLLdqyxU+u5A
         Mw46CNIYE2axCDJmcDInn837ML9ZCXZIRnomea5qCU2hLLUg3RNGao1cV8+adqWSKmZQ
         Gz/lXV88UD9680rdCD8+60JafEMx4tpA9HNInh27owTnO/qu/f6wm19xxjxndicfOg82
         o1G/a8h0TXC2GmR0N/dxpy+ao/SRX9vhMp863GHRjU0n2Ps6367LPiuGv/NtIXEtADI8
         B/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455805; x=1737060605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A6d9SLIy3ba7m9amfCG873jUIu7Rw+T0rUlSTA7+tzA=;
        b=lDXW6jiaKpGbNGZujNu0DZWfql0NF2S0O9hVQ3KFJI7YVTxuT4bbCZ2/Hd0L+xvMQG
         nWmOzUHMC33LkeIR3DCpstX/sKv48vKVXUyZV80QFjOf6hpXPp1C1t2uWxaCrNCRs842
         C88G2W5Uhnzm6gsQcTy+n51lQKBH6SLW0rjuYc20wotzs+vMGBM2K+1YFqu+nnTomUK/
         f9Om6VAa7vX353CIrQ8TEBhQBPs+qUawFkwRMxzv35W0FwQvKn/TNRegEAjAqPAPxzmP
         Ssf7ArC3ovwAVEFkmwluEvvMzz9JzAZcR8EqI9lRmFhhjVfc2lKacNopy8D9J9POAiHp
         AwSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZOu9vAraQhvi33I7knK0pugyppOuQqPd5D+5Kyw5h3qhQcMhQGxLU9vP4SWCw0+hkYJgb32w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwkMUPu+hfB8g2ObxLAdPLgQjRGcJHqGN//W5Zigk1wvPmrsmqq
	JAXztIUo6dbAOgLHLWLVPdd+Um/KK9vHnE3A17qN5LmTCs8bbhjnjhiEiGNUzcHS/M2mJQkQA/J
	gsE3R5jpW37zv7hl+dg==
X-Google-Smtp-Source: AGHT+IGuiGH+ZZwCsi1PGFRN10vipIun+GV8y4B9awYjMBGGjqu8CtE272hh3gh4o7UZqaJM/jxBCOqhOtlKtS/V
X-Received: from qkpr8.prod.google.com ([2002:a05:620a:2988:b0:7b6:e6cf:180e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:240d:b0:7b1:e0f:bf9b with SMTP id af79cd13be357-7bcd97afd59mr1217697485a.45.1736455805434;
 Thu, 09 Jan 2025 12:50:05 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:28 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-13-jthoughton@google.com>
Subject: [PATCH v2 12/13] KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd
 toggle tests
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Make sure KVM_MEM_USERFAULT can be toggled on and off for
KVM_MEM_GUEST_MEMFD memslots.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index adce75720cc1..1fea8ff0fe74 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -556,6 +556,35 @@ static void test_add_overlapping_private_memory_regions(void)
 	close(memfd);
 	kvm_vm_free(vm);
 }
+
+static void test_private_memory_region_userfault(void)
+{
+	struct kvm_vm *vm;
+	int memfd;
+
+	pr_info("Testing toggling KVM_MEM_USERFAULT on KVM_MEM_GUEST_MEMFD memory regions\n");
+
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
+
+	test_invalid_guest_memfd(vm, vm->kvm_fd, 0, "KVM fd should fail");
+	test_invalid_guest_memfd(vm, vm->fd, 0, "VM's fd should fail");
+
+	memfd = vm_create_guest_memfd(vm, MEM_REGION_SIZE, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_GUEST_MEMFD,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT,
+				   KVM_MEM_GUEST_MEMFD | KVM_MEM_USERFAULT,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_GUEST_MEMFD,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	close(memfd);
+
+	kvm_vm_free(vm);
+}
 #endif
 
 int main(int argc, char *argv[])
@@ -582,6 +611,7 @@ int main(int argc, char *argv[])
 	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
 		test_add_private_memory_region();
 		test_add_overlapping_private_memory_regions();
+		test_private_memory_region_userfault();
 	} else {
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");
 	}
-- 
2.47.1.613.gc27f4b7a9f-goog

