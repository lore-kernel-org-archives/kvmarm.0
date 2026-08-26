Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0D03BB10C
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785518; cv=none; b=kY70sLfzE4cQfD6l4EU9PTCSHdF8vhzagGSX8LQ7yvTFW8OyhGY21XYubaMefUCwYDeFd0QAeCK7LHiWYzTzI2yOjncyxk5UJbBHcNIiG34TDjtoxcXZZMf5sP0bim3isWEyUS5udRUpzltuufi5i8hYZvftfsfm8LT07QHKNjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785518; c=relaxed/simple;
	bh=RtpwpC4+8FlGBnxPYsA9ZpkBEAbkRAXGvd07qy2rIzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RPbDw/3e5PxupjHbFhhIrQQf0NhF1JzUQz7bfXpVYz8ieVkBP5JE8NaTXk3OtJReG1f5p7++e+u2T3yKid6E6LHDzfI6Vd4M2hd17wVeT0kMufBbR7Y4bWaAFKm8lvtRgKQZPDTjiC3REfj6gmHxey6/jBwkVGK0dtV4MTzHBCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K2OuoO6m; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K2OuoO6m"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1c1cc5206so1580318a12.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785517; x=1788390317; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=94pyTmilRwp00Qy5PlO0fIgUZFKJ9TnrjxcqGpSFO84=;
        b=K2OuoO6mBjMS2d0Wlhf9UPpWFBnEU3PBQIMPRjX8r9InZ0tTMQrgUP5YISSQewxH5o
         jvJUqFNqcTNHgeb6QIdRNBTUCmh5CvPnijdzL+fMtIbohKegSUv/YI1mw3AFRkmVpiFF
         A3JsLsJA0nxYlNW6zIILmy5R5Zi499mxO0xQIc5tQFGQPIdQ030xhTfDUn7NCnbuF7uw
         T/Xz+PZXAMOpxpKw/LWBSD3GJVHh0CWu5bBsuAZVoF+q5pKLyJbde6ToV/+rDYQ20sP/
         ItYrUQb9q6CZUGVZI7XD3hiTNhTfTh4r45GxNjJfg6iPcUF7TRzj7rkRbaAdtRAvQuVK
         uP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785517; x=1788390317;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=94pyTmilRwp00Qy5PlO0fIgUZFKJ9TnrjxcqGpSFO84=;
        b=o0whaTGSOecoZ1i94Wo/bTH5UlpHZTPeAXQIO0VkFjwIO+BoJp50JY6Ac8J1U/3fya
         +JImuc2BjeoFKutM7u9/98EeJ6eI3ifGuTLPt6hxYWIYHtlCn9VJhVoE9S3xBFqTU3W5
         mXaEfIQzJOttvWrVwvFA5At8PVLxepUqpcZLf+JIeAhWw8jt0Q+BPlJYNQSC6tuR5naE
         RI1DGLyh84ZkkzVZ3dQ2e2as4Xt30rBpFL5PD+9Bmi2urYJi2+ktuxgbiWiXhlsRt6ly
         B/pvcX84BRzqMU7Ecxu+MlUDUtW+aiqz1LmEtLBWlremF2vT6C/PqPdaEv5SLR8jSNHm
         Rpeg==
X-Forwarded-Encrypted: i=1; AHgh+RrQ4QKQRAB7Kp/MDeszoM3PY2oVjSXzPtcZkiOWdvo7EMSJCxhtkDHIcxk9+UvlhDx8V8k11Q0=@lists.linux.dev
X-Gm-Message-State: AFuF++ley63e1zPUxUzp3Ny7cloKlsypfhhMsvzrAtCD5Ok92tBte9BR
	R5KMGspkV2h+M+8+39Yx6L+fX9PN8+PjV+zHRpD7rQ0hc7q9ddkq3Z4XHrwrta2RQaaKpGDCTXF
	SHtetiQ==
X-Received: from pgct13.prod.google.com ([2002:a05:6a02:528d:b0:c99:5634:7551])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7008:b0:3bf:7bf7:7913
 with SMTP id adf61e73a8af0-3cf8445170emr21857267637.14.1787785516420; Wed, 26
 Aug 2026 16:05:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:04:53 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-3-seanjc@google.com>
Subject: [PATCH 02/20] KVM: selftests: Bump the minimum GPA for page tables to 0x200000
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

Bump selftests completely arbitrary minimum GPA for page tables from
0x180000 to 0x200000 (LoongArch's minimum), so that LoongArch can use
vm_alloc_page_table() instead of open coding a rough equivalent.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 5a7a455b5387..70906a0d1003 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -175,7 +175,7 @@ static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
 
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
-#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
+#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x200000
 
 #define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
 #define DEFAULT_STACK_PGS		5
-- 
2.55.0.887.g758fc8c411-goog

