Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29142FD5A7
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769661; cv=none; b=mAeFMpx0luYPfMGUEe0rV0BlhYQS83rzm4zNFihXVEgXe07SXR/iuf7oekOQ+15PhDBna43pv0MFtzUmM2/gT42IqbhORZO90vKSu6c01t5Gpl1aW4euls/7sxgxH8WPIpROVVwlEz+2rot99scek//XBf3souU5BX58tz1OVXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769661; c=relaxed/simple;
	bh=eCkEMmkV7zuOHj76xDUG2iiUIlXUTmKzU3RtBkBbfBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EZ1Xk7UyEPb2pdb9pV3/VsrcPMpobFXfGFGACesgz9VHaHg1zw1Qq2Vat5ugztZektBwJOYkP5QqqQuBXoFmNqsFR+dmAutgwQ5N5Ws6nThGDlZ2w+gLWiAFc4Zpp/m4FUOF70Lfqa+H3v4pMxsbAcbC7fvvwrBZoswDWzVjI0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2OmxhSDl; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2OmxhSDl"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4562985ac6aso12235305e9.3
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769658; x=1753374458; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EsHZSymGf6YpoJB6CYjmGKtG3qfnN0nRO5q9kqA6+Ic=;
        b=2OmxhSDlrwS6fICg3WGuAHX50YWo3yIEEIsVfWN4hA1TLE0UzIpvpFhkfDmgtga7x8
         xhIDhqB1NMfCsQbFK6GuzxB14oRQbrLkeYHC8Kxwa70vKvKDuSdpSM5qc/Aw41gHogkl
         uXmNs12vXcOvVvYsQT7Vyyh95kmRMaYOGr8zEO6HUEk9nZ/eGjcOnYKUGP/x9Jzcq/zT
         nHkekCygJnIyQbYtAV4bZq1J53wW7mhuTBBUuf5mh6ZWVuDTaei86W+Ie+loTLbQ2ULC
         tJzE8iPsdnU4PJFYsUODU/VGblDw1wCNhd8fyQcuD3hDy9k//X2KFTBtd8Hg14K4hXAm
         1F4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769658; x=1753374458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EsHZSymGf6YpoJB6CYjmGKtG3qfnN0nRO5q9kqA6+Ic=;
        b=h12J2vpjjHhtDESMFQwsktdZIY6ssoe+veATgsoXzm9MahSlXz4TUaD6cHITWwhPJB
         6Mt4y7cafqbCSzD26UpqnQuxO033fsV/w/ObM5bskFb86i6+U6MGU3DnsCLhT46F8XsX
         HkMwrL+IDkfCZpMQ3+AO92GjUCnCyE9KjI8QE7ykTzeWEzZp6HTRUdJPQSR14ZGJ+z1G
         kKroR+Bl8Xirv3948RtLanG4uM4iOAZ1OQph6CT+UHcIUKH2KkvyS+2SvTHjREGnHMOO
         TFCwAEzvDPSByXBU5Ec/9JoQ+zMJs3j79ekCbSKWdtUAP87E6FLR3pR+VeDYL6FyJnf5
         jVfA==
X-Forwarded-Encrypted: i=1; AJvYcCWfjL6f4IbCkh2mJB0Qa0aCGTZWV4fHYMr8iBh4YSQAy1KGAAUquv92FCnwgvYxnDb7LLAOg4s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBik1jPKLhn/K67voo4HMIBy3AOOOTd4uiJo39tpLAU69b1IUk
	V/XjCSudsVByKPZpvr29EhAeQkutwkLBx2gBV4bO0vizPMK53BBG7fV4zqyj8tcI1kE/FqediP3
	CPA==
X-Google-Smtp-Source: AGHT+IHF5lWSGh9WVYXpPoz50NAiXW+TxYfluQK9b17X5f+I+q79c8QlWYxgL++Ahdcq7iS1BIfk280OVw==
X-Received: from wmby19.prod.google.com ([2002:a05:600c:c053:b0:456:1b6f:c878])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ed3:b0:43c:fe5e:f03b
 with SMTP id 5b1f17b1804b1-4562e3cac86mr80404015e9.30.1752769658462; Thu, 17
 Jul 2025 09:27:38 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:16 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-7-tabba@google.com>
Subject: [PATCH v15 06/21] KVM: Fix comments that refer to slots_lock
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
index 162e2a69cc49..46bddac1dacd 100644
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

