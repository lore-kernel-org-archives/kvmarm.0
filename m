Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B334AA581
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367328; cv=none; b=TX6GOu0Ea1jqylglF/nrwx4Fi+x915Kgmlrq3uBUeeMzoJ2HUl0yrAJciFJyzj+4IQvkiVlPqY6CQR7ABHEehBRlsG2i1rUe4CJgFxRb5CQ5I/Iq4TWddWHp74bDbSemdX4MRTbxss88Dz8WFuvdlDtraH6hkHG1V6C/xroyun0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367328; c=relaxed/simple;
	bh=OA10wlnKKQ7EEM6YlvfJ4xQQrgVCfQ10w2yj5EgWY/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PLIn5lYXkiTNacHG9Y7zsTxOrkHcHKBd58E2f9s4DwSI3ZpIoLpaiKrAijUlIsLxSgRrp9bpthBLDc0BT9+WffJqti9eyS615BbUosEVBmR5QmmzpWJtrGwDVONnrZRY3RYTCwjCKLbfolyYBpyP/RKBwG80AW0qOWo/1rTfWkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rtZY6NOi; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rtZY6NOi"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1c62f0d60so1832602a12.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367304; x=1788972104; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NSZqPcNxcDapPNldInB7JTSEZaOXSqhsga2ZRaSmlrM=;
        b=rtZY6NOidTPC0HnUKYESlDZMMIUkHY+r8nKKkFlzG58qDkLWXqMQybXPzRSyTVJWIa
         4wQa8pfwOYfghJiNQzUep7JxF+km0WYW2MmdrbxxUztODTuvpPGPR2ksfJVU1DaQPSUi
         P4uxHQ0i0dE9i6O9/Ihu1A18Sd2QLLgtk7T8LChIPJCMh2PwM3hqjQTaWR1JTo/9LpQA
         Q8uhtTsoMk/B2GRlpaZW75z3Xvp3vS1Gww5B02HVDDBXB4G4huq+78T+aft5d3Ffmc8L
         nUaacpDIc4Xk9Q9EVhjUrc37jbNpFAG82OcygdXRe0nBPF4yFqEOWYoAUdmvGKtsFyz6
         T8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367304; x=1788972104;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NSZqPcNxcDapPNldInB7JTSEZaOXSqhsga2ZRaSmlrM=;
        b=XW7dXTL0Th8LfKu7x0yg7W4KVzajpVxnGn1mLNpwPLa3TyId8Ujqeira42GZvrRkAV
         cX/bAn15Vkugm9TKjagbZN1yY/LSDorp8ImY/FMVfvmw4jIp1Z1YqDMXJLT9QYq/aOvk
         81k0JxeU/rRP2eYBFvp5ViMW50sQolk7xm4MdOezXRvPKY9R4UhorqYNeBk+IBR48txS
         TJ8lxDHjama+zviSUn25c3VaVxt4FNp5fbVLcqFFLBmuZm7mHYc9EvxgJGTW/9ODMy93
         oZ8qd0lHT0DwYyySANA1jNM5KysLyWaCxmR4C7J4IN/kjZzvuwpTpeYtsx7P8T23DZkw
         i7rA==
X-Forwarded-Encrypted: i=1; AKwUvBx8owTbi9GxywyKeGRF2fq6ou14owGRPPmK398zLS8BJHx4b6nF1gjRHLvuQivFsXWPMMYTTlw=@lists.linux.dev
X-Gm-Message-State: AFuF++m2OaTipPik102LBqFErqlewDVomobIEPKX7Ntfk/sevmnx6jjD
	jrsdNd3E/pM2ZpBgkZ8HVpSvFESMNIH1YqouP9UsxL+7HKkLry+iK/plUlq8Xf7yf/QX6V3ioJe
	QezTnwg==
X-Received: from pfbgv8.prod.google.com ([2002:a05:6a00:4e88:b0:853:9149:8801])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:238b:b0:85c:c8db:8e4b
 with SMTP id d2e1a72fcca58-85ed23dea9emr8785308b3a.6.1788367303872; Wed, 02
 Sep 2026 09:41:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:19 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-17-seanjc@google.com>
Subject: [PATCH v2 16/20] KVM: selftests: Use TEST_EXTRA region in set memory
 region test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use the TEST_EXTRA region/memslot in the "set memory region" test instead
of a custom memslot, so that the primary vm_phy_pages_alloc() APIs can be
reworked to take a region type instead of a raw memslot.

For all intents and purposes, no functional change intended, as
vm_override_mem_region() is barely more than a wrapper for
vm_userspace_mem_region_add().

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index dffe9654f45b..9d21594e2f81 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -116,9 +116,9 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 
 	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP,
-				    MEM_REGION_GPA, MEM_REGION_SLOT,
-				    MEM_REGION_SIZE / getpagesize(), 0);
+	vm_override_mem_region(vm, MEM_REGION_TEST_EXTRA, VM_MEM_SRC_ANONYMOUS_THP,
+			       MEM_REGION_GPA, MEM_REGION_SLOT,
+			       MEM_REGION_SIZE / getpagesize());
 
 	/*
 	 * Allocate and map two pages so that the GPA accessed by guest_code()
-- 
2.55.0.966.g6673acef38-goog

