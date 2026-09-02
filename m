Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411614ACC90
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367324; cv=none; b=Z7CgWeAXNsMhYfzuWF6WWhglzJIgweSUBHmwOPTk8ojz/v+iH7pa2uqmxcFyeMa//vl5cWwUX2itwB/5QKjO/r7pXFxYOWTezjm5uvUExnCwYsc1s1oOZk6sRwzdyZyZ+138px3Zv8b0QQ8PB0r/+Pi2yreFiEhnKQUc9mC9STk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367324; c=relaxed/simple;
	bh=x3gHoQm6151eyOz2sxvBb0hZCS6dwBM8KBP69Q1Eww0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MSt4T+4U3FIxNMZni/vjivNg6l8T+I6ZbANTyz5SWZlbJMObmUOhMwvdNOHBua29FUGla9qp1rRK5rTrHNlqC2Ft4yHfY21HVUkKTivq9wvmmVhzkiJoRRwzt5z+W63OQdHcTxu/4H5MUU8oB2Rs4pjudzWeyAxtQ+p7DtkZaP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h+q5prT/; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h+q5prT/"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-385d2703b64so39071a91.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367307; x=1788972107; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ff1nydjVZ5E7b5LVcCvqITlv5jcgKgSL4KOLnEEEgvQ=;
        b=h+q5prT/IblHR5abIODcDNNF60XBaXZVhxyJmdDSK3g92d4G2HMt9NbH+vjYgTm12x
         V78vyjwsJLldMogWykviSN84jrq37N6Ns+kwiUYWUXN+FkJnZ71Bpz6+jvE5YCadpBBd
         UVT3w4ySB9ASg64rApLhd1V/OL6rWP5A4srJ4ZHre9oNLLNBBQ57d4IXdaPxNN9yc83c
         pzm/skviw6Pthb/lhkTwoVphoT+myRBHDBKf1IDwHNrENB/51zXviV3Ujk5YM3kwntRE
         pexuUYJ93RWek14glsu8QhJl7JRWOw8CsPxlEuDtFS6yS6+grq/sPEvYZq1TLHicFeSO
         fR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367307; x=1788972107;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ff1nydjVZ5E7b5LVcCvqITlv5jcgKgSL4KOLnEEEgvQ=;
        b=ewtaXo69Sd6VubujpPdejkojv7zoHCNCyMT3GtjH6M1DJwLmuVNSfLlwhrekbIwTHI
         pOm1z8OECCFlv4sBNe32SaN39I0Od6pplIHmb3QEr9W9spHDC+JH0yz0KbfF9Q4qluB8
         Meho1cHc3URjE9aHK8YAVVH28kol80dlFfg5qD3VYBxOGlFcVjnT1CAXi0lH4QAkDICM
         odpIKzEkkNAjaYPBBYTOsUDRimMkb/OqzUrdSVp8pohhReDZPkzd1b8+H+hMPMzJleJ3
         ZHey94hYo0wsTHLWG/z6uzDeqdWJ6p617jpmYA8TpW8C+S4DE+ocfNfLCGaVqhs2993Z
         J9Ig==
X-Forwarded-Encrypted: i=1; AKwUvBzXdWd/yYPyoLPOzSW78QviQGHrXQ3CXryLLNn78r8kejzhf80QM/WVX8Vie9KUzCocZzOvh1M=@lists.linux.dev
X-Gm-Message-State: AFuF++mAmal9QIrQ9nPOigwOuXh157NeXx3c6vSIDHwJMfu9Ul5T+Xx2
	6yDhiSsMDJOqnJgHbGaJd09AxP6FymeLHaoodbytP22HqvkxfdHwQ0KIju2u3v39GZ+6C8bth5U
	wBCqN8Q==
X-Received: from pjc15.prod.google.com ([2002:a17:90b:2f4f:b0:380:cd24:3a7d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dcd:b0:398:9bd3:d6d1
 with SMTP id 98e67ed59e1d1-39b083af6fdmr384502a91.11.1788367306328; Wed, 02
 Sep 2026 09:41:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:21 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-19-seanjc@google.com>
Subject: [PATCH v2 18/20] KVM: selftests: Use TEST_ASSERT(), not assert(), in vm_get_mem_region()
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

Use a proper selftests TEST_ASSERT() in vm_get_mem_region() so that bad
input is guaranteed to fail the test, and with the standard error message
format.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c9ef2e5c9971..c166fce4599c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -200,7 +200,8 @@ memslot2region(struct kvm_vm *vm, u32 memslot);
 static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
 							     enum kvm_mem_region_type type)
 {
-	assert(type < NR_MEM_REGIONS);
+	TEST_ASSERT(type < NR_MEM_REGIONS,
+		    "Invalid memory region type '%u'", type);
 	return memslot2region(vm, vm->memslots[type]);
 }
 
-- 
2.55.0.966.g6673acef38-goog

