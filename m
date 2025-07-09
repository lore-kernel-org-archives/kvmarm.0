Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A3928F527
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058804; cv=none; b=Ig4L8WIgLC1b3owTXE4caPYduQNANXRR7cF/qmvLlm6Unm1hNVaJANaT6Z3i/TvMu1nuAwwyu/DaRElgegTo2fPPreXm3aPiO6zXJ5rwATgf8aRGn04PuoiiQZL1jfWGrOTBYXv0cU994uHsENJXuLPa5vjqr27+azskh10N0ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058804; c=relaxed/simple;
	bh=JCn1lTzYIPFyvHwsyJ2jgIYxGS7NbJ4eaQ8Duik+pXc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=THmCF6gcR0J3dPTlthMbYXQyFD6qe8ZWEFSheSzCrZb1PSi+5SRff5qj8L79qdqZFB0AxM2YYqheJA58fRlqA2k53fNS/gVBvfPoNR/pxUEEkEwlJQy7fehMM4Xmr5F7R/CiM1sM/v/DyOk1jinj0AE2Zuqg3Xt8LYFVXV0xfwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=COVfwneo; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="COVfwneo"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4537f56ab74so34422075e9.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058801; x=1752663601; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTgA0PsTgYLAc78e2afXwU8uZgXh4OcRxe9c8n26j1Q=;
        b=COVfwneoB3+5DXvorgFaZ1q947WJgmHHePzHto3kyf4lsjfdSJIMQzwD7G+ZX3POae
         Yp3qvNgvGoIC+24kWelAC3lJ3SIfi3c9AtDiXl0dA4HPs/rbUF4q92wUN4n0+X4J1lyw
         Ny46xnqWt9ny52hoW/g5gYW2az+PA2w6rtZuKYGP2c6nCQchwZszym9DwxHnoj/6m37l
         Dr6XthG7uS98EOWf1VLnTpCpibVFqwaT2rIks+DVPLnk+5GxOnBwYL8HsEZiemnwCyw0
         D8CiyMFPcbR21np65m5kZSWB49R00jCnzJrURkGhNuGK76urRAhcp/909ReI4Y5OE95J
         7E2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058801; x=1752663601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nTgA0PsTgYLAc78e2afXwU8uZgXh4OcRxe9c8n26j1Q=;
        b=Q57i1Nno8ueg2rdmgh568SSjNmn65xvTrTSNQbwIC0PZKdnoESLqAQd0m9jKwZ800W
         6EwvVTLxVVxNReyc1GnA4Ckc+QdH7zlpcrSNbmARQRkz7VmxvhTjH/Wfz5Ekl0e+8uoN
         m/xwsxPeP9oKF8INB7fgmv8i3dYYOgde+JHyAInImRzZSisY9dYkxhEhFQflcUNmPqar
         BP+RrbYopcDz69erUpJVMQJAb5CQKaiB/GqQU4jAsaLgNuQwHmSSUrtxDtcJj6opDIC1
         t9Z7UP+aeYUVBooYFu0n1CvDppSpE7KamEvH9MO7ulbe9/lFp4SH17zqAC32vu8us6E/
         Fqiw==
X-Forwarded-Encrypted: i=1; AJvYcCXMT0UFmkjRc3jvmWEQnRwQFRSTvbHxwqHeOZsz5dEJkI8eIKE82XlBnM1WwkHLjxaIsLYQjvs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzD+hDz4v4X2ryJZj6FFLWabLqXgr3fd3h0MRoCI57nP8hmKcdI
	MmEFREoO8R6trYO8bcnXehvN4RfKbZaJlwmnIBHvcBDAOjTyr9Y/Rc8BizN5cxgQui3kIKN/E1f
	vmg==
X-Google-Smtp-Source: AGHT+IHmepntDq11YXRLBIOku0QsI7xVin+WFrXXjJmGV1ZmT9B18wyRpgQ41zGx/IWpeOmqxXI7huyApw==
X-Received: from wmqd14.prod.google.com ([2002:a05:600c:34ce:b0:453:86cc:7393])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8705:b0:43c:f6c6:578c
 with SMTP id 5b1f17b1804b1-454d532c4b7mr19454575e9.15.1752058801425; Wed, 09
 Jul 2025 04:00:01 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:32 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-7-tabba@google.com>
Subject: [PATCH v13 06/20] KVM: Fix comments that refer to slots_lock
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
index ed00c2b40e4b..9c654dfb6dce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -870,7 +870,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index afbc025ce4d3..81bb18fa8655 100644
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
2.50.0.727.gbf7dc18ff4-goog

