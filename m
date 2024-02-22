Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E88B15098A
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618257; cv=none; b=aZP8zr26GqaxPJ6bFSi858pEleblfYdbcIAXxtVoYGjxeCVJWCKC5kCc2RwjK/RsOhI4SAe3lIQcRFFwrquVcs1nh8vGqawe09hiFT+mt0qO3ztguhAt6hftonDWhOFDZV75eBZItBv+LscqtwaOfXSXmCBszDF5ohjlilBWw9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618257; c=relaxed/simple;
	bh=L5WT52gMMJoNFswLSJnRNRF/xTYkLi12ITiLgSSDiDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l27ILMQ/4lmPWtcI1H0IHmOiUuoClQp+RtY8grnp2k6tkpubEc0MmX4zinmI0fBeGAGECs8gtSM4zAdddEG0fAyLUt1A1UKNEUff1ELSg/Xp6O0P69i9vGTqeA542yw5U6wwzLghiK0W07+LypUTrK+KJBpBtuzbssfHWZR8f8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sIlLlCMg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sIlLlCMg"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64e0fc7c8so11276436276.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618255; x=1709223055; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5YmtKJX2F3rSkV1iqMOa4w31T6JycNyoitnxkU4chz4=;
        b=sIlLlCMgS9vydX0nCoa+tKSlXQp1oR9AIVe0br+CUwbEu/JuLq7Pzh97MXxV822+rC
         ewe9ezQjjiWHJCBUmNaAzFKh6fVgzYriK5M1mt9NCE767zK/JDc7R2+MUKCPIH45Axwe
         bhInTLlDR1crOpWdb6DPMbhqt4pcD3X0DfUycAByw4HXQP8zes4LTDvD/27yKawQOfpj
         iaU0YTMYCNBGlens76zG7N48OYCXoevp74waIpbRO+nlMDxbNRd3dz+iJ2ZfSPOvB6Rl
         zIyKBawuOW+oa8hUXQnnGgb5zGfR8L9H7uZEgLx8szLvS0E49e4+2WbQYolAKsJfFTuM
         Rq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618255; x=1709223055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YmtKJX2F3rSkV1iqMOa4w31T6JycNyoitnxkU4chz4=;
        b=fqst2BQrgh5qRWlKFig/jJT0IkmCnOK0B74wdqDkrmzbZvv6lToKgty/jelY7P/O9Q
         8c6Dvd5Dryo2CkE2f7O/hlIv6Gd8EoY1WYkgBNBIigEnsLe0TLXI0GYo5ns69zeFpvNp
         3Ptlrxv+0mmf2IYjM9OVjv63pECfz4oPXks0+SyjcrpGu+toQdBPcxgtFHtg14dy/Jok
         mE+c97xpjhU5dovkdU8qM/1RmrlyoYTFXjtVpYVlTrTYOn5hdZrbgiTI957JhCIaLJSn
         L/KZqxj/TKqPQcYVJOCQ32plD1xf2iQkhbKxbTp7qHq90pmkt6AW3rUbv9BgzJVVuOIJ
         lDsw==
X-Forwarded-Encrypted: i=1; AJvYcCUpGoGdw5NTOBU1v/+Ww0iKKKciUImZ5m3SEiOtYuEufiJduC7dsuw/w/6neL8GZ8+5b053c6whJ3zHzEJ1ZATRw58GwHZ/
X-Gm-Message-State: AOJu0Yw+MCekuQi/AvcWkNGhKebV55i63fHe7QBIorOPxJIBUjWh74nx
	OFfJz1suuKfAHktdzMvaXiVbfvCYkXTpPJ1k3ZokQDLAt+wPiO9uHnGs8F5QZfr5IiBvMaVjYA=
	=
X-Google-Smtp-Source: AGHT+IEJ5uDx0DBdRtl2OUTBaLLNNcO1acG4EdiHb1aZlJ2UWKKk0H2LLLVqC/b2Z95QlvaYQ480iTjpKQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1146:b0:dce:5218:c89b with SMTP id
 p6-20020a056902114600b00dce5218c89bmr123764ybu.5.1708618255038; Thu, 22 Feb
 2024 08:10:55 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:23 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-3-tabba@google.com>
Subject: [RFC PATCH v1 02/26] KVM: Introduce kvm_gmem_get_pfn_locked(), which
 retains the folio lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Create a new variant of kvm_gmem_get_pfn(), which retains the
folio lock if it returns successfully.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 +++++++++++
 virt/kvm/guest_memfd.c   | 21 ++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4cacf2a9a5d5..b96abeeb2b65 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2381,6 +2381,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+int kvm_gmem_get_pfn_locked(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2389,6 +2391,15 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+static inline int kvm_gmem_get_pfn_locked(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, kvm_pfn_t *pfn,
+					  int *max_order)
+{
+	KVM_BUG_ON(1, kvm);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0f4e0cf4f158..7e3ea7a3f086 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -482,8 +482,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }
 
-int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+int kvm_gmem_get_pfn_locked(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem;
@@ -523,10 +523,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	r = 0;
 
 out_unlock:
-	folio_unlock(folio);
+	if (r)
+		folio_unlock(folio);
 out_fput:
 	fput(file);
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn_locked);
+
+int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+{
+	int r;
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, pfn, max_order);
+	if (r)
+		return r;
+
+	unlock_page(pfn_to_page(*pfn));
+	return 0;
+}
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
-- 
2.44.0.rc1.240.g4c46232300-goog

