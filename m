Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB64211713
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137898; cv=none; b=X10GonHpKfFnUKdSKvfVniM+l21VpLhEzMFFiyeks8fZTtmLqMGOD2Y9MRhoP8bAyvT6EyfwTg5WiuYQtzGh+ymyF7wZ++Kvfc4Sj9G4cDM15QB68G8Tj+5KXca/SDjkoXc63e0pJtsJd2GpznjwodDQlEea635R2r7El5UTjjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137898; c=relaxed/simple;
	bh=x+fQBWn0/0ardBRy78HzYroQyc4L59a6RPCtPgDdFMw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lKYNfztK6ZoyRS+iwGedhZRW70xSQ1S0k3zecOvP5bq5jgdKxd3xLFhtkDbpat0Bf4ytOOw0DzMmLWwzSYMVmH+9bauJOmJzsN3X4Y8ac9ykqdECFZH4Mb4Zshc5BbXDhvlt3lIMjMGUfO50Xnq58vBQewGryvh5D2D+Udui0gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J1fuQFGb; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J1fuQFGb"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4eec544c6so575861f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 08:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137895; x=1749742695; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bX7rVYDFpCzF6sNW2Lfy2882XEAhzLwmJkPHB1Upz9o=;
        b=J1fuQFGbQRoyfJz0vdaXr5gPC5ZGLU4QFEWTSmDVEQ/2hYogxkY0PBnCnAG8qT+23l
         yc8mib2opw3Q4keza5q0UEU68jjXJ55PYMGKydAXF+zQO+tnjHm0TNsN02KSJtCndBQg
         1wDFf/Wnuwp3pst0KyT1i8sJvcEZN2CNZ5HxiEvKXdw6YdVjHcHKcyFLnbdn8hTN5E/j
         TyMJJYrz2Ug4qsjQKVFgAYl2B965i5Mj8KBc1IsBmAVu/ssC1L1h2DEswQTCsFo/X1U3
         IA2BK1PI1rNndFoFjrHlRHc9dbQCZ2vgfIwBhrmpWtecgXXYiMKNGiBxXTE8Lp6uWcbp
         VKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137895; x=1749742695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bX7rVYDFpCzF6sNW2Lfy2882XEAhzLwmJkPHB1Upz9o=;
        b=CMCazPW9IfYttiG/eggSpUjysgC7RHfMhKYJxxI8Ng2xQfWPE2z+/BKlge19j5mlRj
         ekovat3OORJKHQJ/QMTumSkXm2jsbS1hYViwAZNiDNpisf0++JQrmVcaGGsDe/X6asxg
         ri1L4LxcVhUmJVRvVnI41q9fFCRXRuGPHVBVJMHULC4Bb72B072KoKhjt1VtynnSe8Ns
         73PErWy39Eyqa9OAzKw3CGMAsMFwLy2NFscMucRSp809/K6tQD3vjparHlRRZTAMqkzx
         kxezZ3ajRH3Q6Egpo/gkN9S2zMxGkJf4kqfqNvokjBmlpFfiaVf5DxsOIfZ+o0N7ujHz
         +MHw==
X-Forwarded-Encrypted: i=1; AJvYcCXb4uZrf9+QwnDQg+6+/F6sjwCvSxYxOO4hHIgLHG68g1AYoPWUnMG2FA0l0bc/9YksAckCO7Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqgbABTZgnd4i7chVM5S3WsKSWwYRUABveKbOEI/PW3GqDXlHW
	rEYqjc5jT17G0evgo6Zap7OIYbRkVox5j83hYYKMukgOcfg1pQ7G/UsGr9+gBAsw86InJ42rE6x
	gfA==
X-Google-Smtp-Source: AGHT+IGx/NxvkfS2OFg1baPqeoVFV4d0bcEnAR0ITEv4+pM80ouDhmtSHUvc8cTeZfEpmvTkRzfFHQzWbQ==
X-Received: from wmbji6.prod.google.com ([2002:a05:600c:a346:b0:442:f4a3:b8f5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f53:0:b0:3a4:e002:5f97
 with SMTP id ffacd0b85a97d-3a51d8ef871mr6732462f8f.1.1749137894915; Thu, 05
 Jun 2025 08:38:14 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:48 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-7-tabba@google.com>
Subject: [PATCH v11 06/18] KVM: Fix comments that refer to slots_lock
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
index d9616ee6acc7..ae70e4e19700 100644
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
index 2468d50a9ed4..6289ea1685dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -333,7 +333,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.49.0.1266.g31b7d2e469-goog

