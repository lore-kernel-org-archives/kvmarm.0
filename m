Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537251A38EB
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717005921; cv=none; b=Jq6YvdZrXxKV8OFbhsW2VcGYW42btzEq6BEX3b1u0wn1xOyLQ4SOJlfksngym18MKof7EDZgyJLTBrYHCc4hd04yh8dj/UfSjliIkmrkGf304xoEgLp9JQybkhjNTPkKPvsUL6QlzT15q8Iz5hZpc8tM4QPVaX2P10ixyjvZ2fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717005921; c=relaxed/simple;
	bh=rClDOFeTBM3INZgvPf3xqhdotKn3Xjpsol6JPcgeiiY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dGAh8HlmrxGkIY0NCcXfz5uF7/gCPxg7qsz7A5QOWLsgjAkxwsQ7o68a2fjL/gdw0mtfttZE3SRVeRbIcaiIDK3ZlomOg3yIlH0VPlD8lWxOYfuviniAbw6qnG0ai4s5BWveV+5+eT977KY2r7L7AyPdEcKWaTD5EdgJb80yfgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PN3rQ1Ip; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PN3rQ1Ip"
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-4e4effa67adso21177e0c.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 11:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717005918; x=1717610718; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nPLVZGS8AMw+CagEZYqGOZQVma0bD0XI55fQjmFacis=;
        b=PN3rQ1Ip2Z+yoa+7rulz9cSmBBCWCo/1Z8LMWqMPHT1pg2U2izoIojtq5WDUXgy6JU
         HhkD7nX/Jp27mxeiqu+DC4xRkUSumSdXcMGFGVFni0UhRWPxnHBujfAzdx8iSgp0PC+w
         QpCAOuOB0Qwf31hB+Iu59Vze7K6vBSA25ftCE6dZuqN7ft1UKbx9uhaqlMb+rAwTy+/I
         +7Ez+QXOix+tyc8pxsiCNQsFfI9LF6DPgsG4Z1otGG0zsGhHzlxVfDvKLso/4OSTeqEX
         Zn5OXmaroi00LSubIQtgcgUJyq7G107GmnMEIAUgyZu5/E5nrGxTGr9p8N7HuH+bDFKn
         b12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717005918; x=1717610718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nPLVZGS8AMw+CagEZYqGOZQVma0bD0XI55fQjmFacis=;
        b=jpcD08xYir6sv+3nguYchPwWrNzHL0ifKD5yCGv0ZmuvPSnSSkj2yidq7LTPoI0TkN
         fVq4gJbUXtuP/OY+PFVYueUgobA4MZIe1yf6tuc15fX4uU4r12nCJWix0zXE+d6kHFOn
         9MAPg2d+WMpVeuK5fRwqXuCbFyKV+tGtJLl20/IKMTvNswi+OiJlfwLfU8PtBfvmp9Yv
         WYsD/u5w+C20hS7VOX5b9VqgFa12p+XLxc1Dw521+E6tkYQyRG9B1S2iaF1JV4Ci9dQO
         /l3LGAchZU3YkEIcr1KMSG5Yp0HelSy3QA2/xNgxVPIfeo3PQ42myFTxSOAQ94odKYzd
         O6cw==
X-Forwarded-Encrypted: i=1; AJvYcCX6QGKLg5kGjrxvcPjSU1GVN9/yev8VH8xhP7mShfturM/QlvQTTobO7Exdp98cnJDXNhuft+Ts1fKKoPzOQjNYTM6eD1PT
X-Gm-Message-State: AOJu0YxJaXQiBLYAoZZhKY9oH1ayA6lQi4yY1h9P/T6Y3oL14n36hYzl
	2pSp1iozo4BOZQlJSfPojOyQ7ZGosvNoxmEdMZN30HcecfBjYzVjUJivRZpW61v7tH9PKmSAxNL
	j8emvmtua9yzPAanaLQ==
X-Google-Smtp-Source: AGHT+IHYErK4IEAw4AodIy6/uS9D/1KylfkBeNLUgQvcCMlB4bZF6bJgSfUsGpPUaVK45i5PNzhTyn3VxbK8rZqg
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6122:2006:b0:4d8:797b:94e0 with
 SMTP id 71dfb90a1353d-4e4f0112182mr502860e0c.0.1717005918294; Wed, 29 May
 2024 11:05:18 -0700 (PDT)
Date: Wed, 29 May 2024 18:05:04 +0000
In-Reply-To: <20240529180510.2295118-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529180510.2295118-2-jthoughton@google.com>
Subject: [PATCH v4 1/7] mm/Kconfig: Add LRU_GEN_WALKS_SECONDARY_MMU
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Houghton <jthoughton@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Add this option so that one building the kernel can choose whether or
not they want to support walking the secondary MMU.

We want users to be able to blindly enable all lru_gen features to have
the best possible performance most of the time. Walking the secondary
MMU is mainly useful for be able to do proactive reclaim, and it is
possible that doing this can harm VM performance.

This option should be enabled by users who run VMs and also care to do
proactive aging/reclaim with MGLRU.

With this config option enabled, a user can still disable the
new functionality at runtime through sysfs.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index b4cb45255a54..3ac4b1dbf745 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1222,6 +1222,14 @@ config LRU_GEN_STATS
 
 	  This option has a per-memcg and per-node memory overhead.
 
+config LRU_GEN_WALKS_SECONDARY_MMU
+	bool "Walk secondary MMUs when aging"
+	depends on LRU_GEN && LRU_GEN_WALKS_MMU
+	help
+	  This option allows multi-gen LRU to walk secondary MMU page tables
+	  when aging. This allows for proactive reclaim, but this can reduce
+	  overall performance (e.g. for a KVM VM).
+
 config LRU_GEN_WALKS_MMU
 	def_bool y
 	depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
-- 
2.45.1.288.g0e0cd299f1-goog

