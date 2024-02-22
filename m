Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF9D1534F8
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618262; cv=none; b=kr+Hy4c25yP+6iQB/a5A5MLJ6RvkQP8gKzEvFonRKNouFtDmYtDQ60EndY15pVTM+3MJxhYw2KioPYQoCO+mrP7MOTbdRVPXJLda6POnNmrRD3ILn7QsZzTZZ9LZhF1HGwbHvjv5t8zPxJ9NreCSLLB5G7BSUuk7BNrGEvQdcCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618262; c=relaxed/simple;
	bh=X9b1S6yNSBLD+mqNBTikNYnbyUMFTya7TpTup5Rt/FI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RcTz8ctBfwriaxUvEtOcnAzsoN4o/TFs4raLOwF/WSrQO8fJ02OShmVKMLWOjpjambbJ/nfqwlCPvDmpk1KYYdlCvl3b1VAwOr27w3Co/LYRCeT2SFVLEnNovuNASUFRsCsxj0r+P7dvt8MvaEYUBfoiNBJqpc5DcZBdgPJm44s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qSJF+wPK; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qSJF+wPK"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607e8e8c2f1so132460187b3.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618260; x=1709223060; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s0Rj06sprumtF573AfEP0GeSqajU1zMKKEjxpZroPas=;
        b=qSJF+wPKL/KuKBwRpUlsc7Ua4Wy+AcqyEiHSxktJWgi74v5iQXCInEfGWYZHYAodqe
         xkxNU1weMxl0ALp/7MY+UY6ClvYje5C8su6aZnG0rQpEItN/pVxB1A4+Ahny+nW+JZVF
         LT9CbE7TUjg4hWoObYbR8TyPAj1I78aE/fawTAF8b/IICJZX7uSpt21BEPpxgSNdAoxz
         sb2+yMy5lLoOupVxVeVvdUF/nHJNd7SJcUK0W+WlZIrhF8+zLdBazS+42PzfDWf3qwGG
         kSu0gMbG8DGDos7KqXmC30pftyuhHKieIkoG81Z8QkTnM/6RdKfFx2NnwWQ96FO9KGGY
         ElCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618260; x=1709223060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0Rj06sprumtF573AfEP0GeSqajU1zMKKEjxpZroPas=;
        b=t814OzZ7BNRSLqs1Ejo1TWHigjdzrzBtbFjymM4LkFO0oeqyq9PEfC/xr0sHvB0ZJK
         Y5sA/q8GY26zDqKUJRqY7HfCKDn/BmIBVxN0hW5q0A/UncCfvNlPstKvIdYwjnJAb3hL
         JxBddS9V/u0720VUsAUfqSpbmSz5ZDIKOl+c7QrY3tPQYP6g2PYzqNbU+s63E+VkzGjd
         HxQ15D3z3GTVthfTGEf0hO66aDaLrIW+afCAdU4XeKou1CvHChmiWeHDrJANcsTQqNeH
         ama3+U6bXq5M5DPSUjzpWff8lwoTZgZ4sHO/Y+vMPc35JO39h5qhWnd2vzssSj69eTkt
         xemA==
X-Forwarded-Encrypted: i=1; AJvYcCU0Eese9FZDaLCCZ2T7QErUkCx8ah3cTRk2+3x58xGKW+UWY5nMGNvqaek2g8QFzFyuKF5zYlxDy4zGNWELv5lU7LOr0sCv
X-Gm-Message-State: AOJu0YyDr7FWHyVrUcgTuxkzCCvqzYh/+fGJULjdrgoOsQdZh43oERYA
	l/GJUbRFZtvoWbQ8VmVtKZwN852ELLdOFkcYLfRH/KArdTXEob+6B2gRA1xmZE0lTQjLyOR1aA=
	=
X-Google-Smtp-Source: AGHT+IFWb1sqSDVpFuZ3W8sqoZxZFPSTBJOjR01PwIQfs5Me2aRJCpsMpzSOCXlcfJYvEs2Ca8Gd5XNO5w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:a014:0:b0:608:a89e:be89 with SMTP id
 x20-20020a81a014000000b00608a89ebe89mr174469ywg.3.1708618260297; Thu, 22 Feb
 2024 08:11:00 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:25 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-5-tabba@google.com>
Subject: [RFC PATCH v1 04/26] KVM: Don't allow private attribute to be set if
 mapped by host
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

Guest private memory should never be mapped by the host.
Therefore, do not allow setting the private attribute to guest
memory if that memory is mapped by the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  7 ++++++
 virt/kvm/kvm_main.c      | 51 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fad296baa84e..f52d5503ddef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2408,11 +2408,18 @@ static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn)
 	return !(kvm_get_memory_attributes(kvm, gfn) &
 		 KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE);
 }
+
+bool kvm_is_gmem_mapped(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 #else
 static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
 }
+
+static inline bool kvm_is_gmem_mapped(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+{
+	return false;
+}
 #endif /* CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE */
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fba4dc6e4107..9f6ff314bda3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2516,6 +2516,48 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 		KVM_MMU_UNLOCK(kvm);
 }
 
+#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE
+bool kvm_is_gmem_mapped(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+{
+	struct kvm_memslot_iter iter;
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), gfn_start, gfn_end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t start, end, i;
+
+		start = max(gfn_start, memslot->base_gfn);
+		end = min(gfn_end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(start >= end))
+			continue;
+
+		for (i = start; i < end; i++) {
+			struct page *page;
+			bool is_mapped;
+			kvm_pfn_t pfn;
+			int ret;
+
+			/*
+			 * Check the page_mapcount with the page lock held to
+			 * avoid racing with kvm_gmem_fault().
+			 */
+			ret = kvm_gmem_get_pfn_locked(kvm, memslot, i, &pfn, NULL);
+			if (WARN_ON_ONCE(ret))
+				continue;
+
+			page = pfn_to_page(pfn);
+			is_mapped = page_mapcount(page);
+			unlock_page(page);
+			put_page(page);
+
+			if (is_mapped)
+				return true;
+		}
+	}
+
+	return false;
+}
+#endif /* CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE */
+
 static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 					  struct kvm_gfn_range *range)
 {
@@ -2565,6 +2607,15 @@ static int __kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	if (kvm_range_has_memory_attributes(kvm, start, end, attributes))
 		goto out_unlock;
 
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE) && userspace) {
+		/* Host-mapped memory cannot be private. */
+		if ((attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE) &&
+		    kvm_is_gmem_mapped(kvm, start, end)) {
+			r = -EPERM;
+			goto out_unlock;
+		}
+	}
+
 	/*
 	 * Reserve memory ahead of time to avoid having to deal with failures
 	 * partway through setting the new attributes.
-- 
2.44.0.rc1.240.g4c46232300-goog

