Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7592DC33B
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267646; cv=none; b=S51xEJyg4ec1dSZOcdFGzPwpolhrPjbYKP3r6N60ySTfg4tOBpB9eE/TZqgXtZoNK0HpFGFfhU+qG1jKbaTkqdIoufHN4RLhSifKf552QBIs4wA+Nvpg1FABlN54uhqlPmMcr7z4s8kgeutlUIsM6lzzhtB+zGfRF8SzUy7/8uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267646; c=relaxed/simple;
	bh=KZ7kqW7WvlgvVKw/xfxfioYYfD44i99u6AqHghZDBzk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pfsAcAdT8eqJ0hdBAnjv9XLzcLGgdOriZ6NT1lOQQ8euo4A/KZoKCxYqpOGcKq0/xcfVXMSLnDx158fc3XdTihLjt7uXcBZYji+DsvLX9+BdWgOTMsDkqc5Tl2L7vELqwbin1/2jHWG/yi6Sgn8fG+gi331nQu5BiDMVdeaFDnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gBtIfGYP; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gBtIfGYP"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4ff581df3so417095f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267642; x=1753872442; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RA80cSFG8RloKjPCJxSK3bAiLUM98d+8AkAnyd7v+Q8=;
        b=gBtIfGYPMDyMKa3OuDhl4kDwjiWhGc2Q3PIKAXmeU3yxmfC+7Ycjj+tvhAtW7q4gsM
         jJvrDAJeQe25NaKLSok8aRiBvi2vSlPV6R7KB5ilvRysxLXK81tg8/uj6Mhpwsst+D3G
         zJOcahW7Mtu8HML008vd/HrLGYPitTEeOyN7djCFiarfDQH3o/o92Jv/qhkFLKrncU5U
         un1DVo63DcxdJqKeG31uhUK+UKIKVxVR2EXJY1q3oaLZNQ+xbAt1ag8Gtz+MacIlDWk6
         M3cYGjbLfm0Za5DrCTJuG+qmJlMv+13koH3zeQgkg1WQXMfZFV24xVB5xPkFMSRkQH3T
         x0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267642; x=1753872442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RA80cSFG8RloKjPCJxSK3bAiLUM98d+8AkAnyd7v+Q8=;
        b=haAuJUM1kRAe8eE5Wl3gTO4+yRaQGUFxaTShlLbzYZepzA/O5iEoiUrobBibwzVxxT
         riKmhRIJvH9NzVXsylax93ZNF/w9V4W8JpgB4QmBgl20P14HhN3EEh73SqcIEry9qX88
         Wg9iGUb6oDN67TN4aOMYRmgo1I6meJFeb+Nk/ft1N8KELjKkx20vlUJQjGyXkCCSNZQ+
         MLMuuhpMnyuLCO/3utykBeacwoc/3kK15+O5l6/+gKd11HLqw0vB0AcIHiLpnas/08z2
         +WRgB4btCeejLWmS4LyRyE2cURmOUzNVehabtMAkiG1/ZnKa0utuFHOSlVXsNu1Jwqt/
         brwA==
X-Forwarded-Encrypted: i=1; AJvYcCX2HX32vox6bR1+ClgplyojIte2dZZQFppg/IQ5DJKPjbtqiJwrOcTda/45zPYoolYENh/OUZs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTLC5nW61G+l6SU3WHiksocUoLRfg9aBsFAaozYjchr0zHJ1OF
	8m1nWcWBJblKzvKnnhRrLsT5qZBQqatAyybX25Y+HYt6GCv7Z7vkaPtEeLPoA0dNad5T/B/sgFa
	jtA==
X-Google-Smtp-Source: AGHT+IEHW8UPxyP3e+Y7vaygayrdzupiZRH2UQB8NKUanjQQg40Gzi7ntNOEJQk5x0u5UdSIscP/yEby6w==
X-Received: from wrae21.prod.google.com ([2002:adf:a455:0:b0:3a5:7aac:4306])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:188b:b0:3a4:f7dd:6fad
 with SMTP id ffacd0b85a97d-3b7694dfebcmr2129935f8f.14.1753267642329; Wed, 23
 Jul 2025 03:47:22 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:59 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-8-tabba@google.com>
Subject: [PATCH v16 07/22] KVM: Fix comments that refer to slots_lock
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c5e0a898652..5c25b03d3d50 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -860,7 +860,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25a94eed75fd..aa86dfd757db 100644
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
2.50.1.470.g6ba607880d-goog

