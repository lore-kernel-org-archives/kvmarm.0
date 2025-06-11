Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C9228BA95
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648827; cv=none; b=hMOVTmgKRYwVT6dsJEesUKTOJ6kLBq+Zez9vNbPAvV6EFEUfv7kzwR5juEVJXpS+7lB0PV1/E1Bp3cCpQhInOqQ5c8AuiEQZ/iqK0+6h3UejdRVi90NVz933yM2ASAyfGLSGTOB2vEiHsbsLcpwD/DJzDciKBbDWrubZonviXpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648827; c=relaxed/simple;
	bh=YGKWeS/02fp1ZvntQjnXiLE+15TL6ZwC9xQKq/URy3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SbYwvwuoNiEwfFe71j3umuGKJt/bDe4SnxibKxC7QxHDs0eOVCgt5FesuX1h8j7j4TSZIzSBhmdKqPAWIY6Cqg0xlqunEbrgl3NGJokfUb2JHMK1+t2y8/WFWUDh5z2V1VbLUkIF/PdM98FpFTJZZfRfakgTeJF/VifYMlMcxfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VUBHBKGb; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VUBHBKGb"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45311704d1fso20929455e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648824; x=1750253624; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8aR8d2ohKDYUtwqlUQwft9/8cX0oCVtZ+VCOgpKfhcs=;
        b=VUBHBKGbI6XfLxMbGUsg8Mk3U1GZZEmSreKFobvHbgDIKHxwzbyrb+3PSt+wO5+NzQ
         Nmn45ThZpfz5X0YEAUq/hrR//tWiXotZrmUj1iULeacnWKc3W2iEC6pjynOzOqLb4BoL
         F0Y6aOFCIcIMCJuTEZG35EuCz0BbyY5Jd3xEHD93wjzyeQNM922clvlFiuI4OH7fQl2w
         HnTXkWcgO+dCrqByNRF0IX4gwOrncgcYHqWwaSfpmjT05z//HkH+b9QgnW/RU9fJPVHR
         J52teqCS11ZIqbBdxM98glIMT3JdhYsQMT/l9EGUjolB4eWBwvn8fZdX4ibxa5ltq6zy
         3SBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648824; x=1750253624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8aR8d2ohKDYUtwqlUQwft9/8cX0oCVtZ+VCOgpKfhcs=;
        b=KWkf5BbiODiaMI0g+WBqxyHgRGFohmupLbSOcw1jFmaOYURNf3+Aw3S1oPjKCa22Ru
         Pf7uvIzLaiVjqi2WY9MuC1vllQVAc1uGOc0O9cKxx+BITrg5GzxMqcXPYkMudrhlcglN
         8/boR62nAktUXjjMTbI1SgTLOApqYlhwjOiXx3U1cmXqxWuUYDHL5dRivJPSKDbclpAU
         x29o0ijzEupKEr9pF20duiRELoTY/AfDpCr2FhP/A+r3PSZNVZ8IzQdYmK1CK+GzRUB+
         Av6VW6bV6pK3AgvgoWJhdNW40euq3IdOey4UyYRU3QmH/n8YyQVEfot6EBLULK9MDJgg
         /l/A==
X-Forwarded-Encrypted: i=1; AJvYcCWa4+Hc45D0uEK6iZPSKTzYFdw+d8lY/y3v2NhZHKxMnjbTBW6txTASKXBMq7ZHKey9H2ssfN4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwH18PnfUVzav45Yf/I9A7H+DPwUVH4a+5pAmcsuzbCwTOi5deX
	BxPWeFBQHsdoYIeiFna+qQdfgcTN3aWdoPciZ4A1KU9lOFzlmLbc3CdgW3hUvnBb1uoFVoRbDB1
	Cug==
X-Google-Smtp-Source: AGHT+IFCb8jHeuPCB7LEmI7avFCyTPGfgQduPiszdiF9PVCb/8oC0jpiLuFzDzkO8e+SWuappNsS6C6Y4A==
X-Received: from wmbez14.prod.google.com ([2002:a05:600c:83ce:b0:450:d422:69f9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b9b:b0:44a:b9e4:4e6f
 with SMTP id 5b1f17b1804b1-4532956d50bmr9767915e9.16.1749648824195; Wed, 11
 Jun 2025 06:33:44 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:18 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-7-tabba@google.com>
Subject: [PATCH v12 06/18] KVM: Fix comments that refer to slots_lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fix comments so that they refer to slots_lock instead of slots_locks
(remove trailing s).

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 76b85099da99..aec8e4182a65 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -859,7 +859,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6efbea208fa6..d41bcc6a78b0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -331,7 +331,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.50.0.rc0.642.g800a2b2222-goog

