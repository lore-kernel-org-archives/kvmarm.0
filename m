Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B33E44F9
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785545; cv=none; b=keX+V0WjoQXXyVNSL6YuCiXFKByAXxipKny6xyZEJBdHfskVDfECV+Ul5ViuHN9FRdl24u5u0Q3lOiDJquZTfSndbdmjRsd2uhk4nS6Ihru7nPelRhNCGU6+QNCjTB5JXOszBYiv5WFhenkG4nhdiTbPvQevTm0zGUF5Vf9eLso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785545; c=relaxed/simple;
	bh=lKXQlA+oesJrtxD7c4frkF+V9E3fuZX9xGPyHMdrXvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MU0mIanWmx5Zq/+7ZofECVfRKga1ypnzUmIwSF2YcVyy5HTuMHgtk4RMNNuIKzYA0msExgp//a8hF03qt/+C0aatINZH9hzFu8HAaa3z17S8s/qjZfbolKccjiz4lIXMXNUuslAulnESK+AzNPrhO0/oCtEYNyTT1NbgcmUI7pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ORdFqVKD; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ORdFqVKD"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c85798977dcso2110716a12.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785538; x=1788390338; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=heZN2DuvfOxZirlVdynH6v1916EkfGJKRv4e6fIVLjM=;
        b=ORdFqVKDcZ1C531QJKUhNHNOw4b3PMIa2lW1C1WcS+x1uL+BiqXjNZV7CWbM+c08Ar
         2ow41vypLvRQhkRbj6apOyAL5unbc5+RnuI6DNgoBPEe5vW2hlR5grsw5WGKpxiFBGWt
         QLL6K6WTmCE1eS4g2aGx7e1rXufl1wnZHn1GdplnctyqmIgW+e9GkI4tDrDfzi6mYBIW
         Bj3LZ+nXVjchGQts6TTGQEL2D9c19zB0RNrN99BxEVvx93Js69MUVbh4ivKBPA19IJwY
         u7cGJP/py8fG5GXUfWKH+nGOv1Sf1FQHUQz6KLucibuALoJXBDEf+X8dnuwj9UHRT7rJ
         Z4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785538; x=1788390338;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=heZN2DuvfOxZirlVdynH6v1916EkfGJKRv4e6fIVLjM=;
        b=sMw9UTfP8x+/mZqLhW5YdODfvY7hx4hRqaHktJnaxJ6HTZZWuBxYXZW2wJMAVKD4sl
         WaWYor3ZIi0WRa6cx1xKiUmkRppE7b7Hco3ikP/jf6+Lr+kVLUGXqIx+QvYIglrlW73n
         ROfUR4UKBubTlMZpFJ0EkA3rB74X9TzkzTF+xK9FxNiXwYTkUZYOugW/X+/cgB2eYoM8
         FWL1F98NCk/R9JLgRHPRbr5JdOYbQUdyjRo8OB3BJ2tIDj4y0h9ErZNtVoG6cLn+ElT8
         Vr3oqf5oFYcTXS2kkNWlh0PsQmfKlUvy8Hc97rOPui88o2R4pxW5Se+jtytUKLleMfv3
         dstw==
X-Forwarded-Encrypted: i=1; AHgh+RoYKfFTprWUoG74OL3ZWCyDpZCrC48UGzG8Q7Ls6vvtV7BrRaUoeiiMQRU57GqId8v4P/sir5g=@lists.linux.dev
X-Gm-Message-State: AFuF++mNWe+L/KeACBlhiQWmUmuh05lBJ3LCa7pTMN1sIzQN7iF7pZmw
	EXrcU/0eucLGFoRoMpsXyt0DJ4oefoallYMTxIVKSuz6FCJ+jUGAS0bfdNXhriKat2tErPqmOE2
	Jth3ZsQ==
X-Received: from pgce14.prod.google.com ([2002:a05:6a02:1ce:b0:c9e:3c0b:5818])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2013:b0:3d1:3c2:85b6
 with SMTP id adf61e73a8af0-3d103c28dfdmr4039415637.5.1787785538103; Wed, 26
 Aug 2026 16:05:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:05:09 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-19-seanjc@google.com>
Subject: [PATCH 18/20] KVM: selftests: Use TEST_ASSERT(), not assert(), in vm_get_mem_region()
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
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use a proper selftests TEST_ASSERT() in vm_get_mem_region() so that bad
input is guaranteed to fail the test, and with the standard error message
format.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 783f060faf9e..a0cd1b6598d4 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -198,7 +198,8 @@ memslot2region(struct kvm_vm *vm, u32 memslot);
 static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
 							     enum kvm_mem_region_type type)
 {
-	assert(type < NR_MEM_REGIONS);
+	TEST_ASSERT(type < NR_MEM_REGIONS,
+		    "Invalid memory region type '%u'", type);
 	return memslot2region(vm, vm->memslots[type]);
 }
 
-- 
2.55.0.887.g758fc8c411-goog

