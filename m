Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7874633
	for <kvmarm@lists.linux.dev>; Sat, 18 Feb 2023 03:23:28 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id cv11-20020a056a0044cb00b005a8534314aeso1520307pfb.17
        for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 19:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676690608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V+h39w+M5y7yM65vTe8AIma457bKn0boXmudJkmUO64=;
        b=OOGQDAozfJPxU4cPh+eNsnFORVxhBseQ4po+PMVYCaaHrMa27a9eZwz2HjcuIdNgVh
         slYOm4TsOONQCaqTOCU64Vyqjc6wA23716ZiGacc/GuZx9D+Ze+sZX3iXZOiGOJPfzWw
         DEoYq/LLYfSROStk+2ZwCOK08p6EUsCQQomIY0RjEmXUx1ogiu0aDnkPstrbqkFIAsIO
         MmTUzMho1a89tjVA6XSHJPzknQsAy9d3/oybmTkcrgybl1jryNlrmOncv1u6qAqxxR1C
         WAcxMZX5PvwwVrEDyVwVNABO4a3hoCllU8GjbsW9Wy5fF9tXx1SQaV4ccNARUsNP0pKc
         brWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676690608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V+h39w+M5y7yM65vTe8AIma457bKn0boXmudJkmUO64=;
        b=HFbowx8Maa09sqVV5s4pjAIKXDi8Jpin5azoLjLpjd76OBDBLEPJbPEjQYR1KFYC/7
         QTorENq5q/WOqO6+68ycZ45Vr5VO7IBc8l31D630ClOmUP2O5ySVr+lkZORz3UTiVjXa
         LZQWM0CudwpUGwNmCR6V3eA3CWNwbRYDKCWgT8/qU5AjnsC1j0lRXWTBBOi/WtkxoLhk
         lhzVWvw64t5U/Nq7B6k4lepVvkfT1VHIN/kcatprQOjcbSmmHamw2Wb8xUdVs2ArmOdK
         5X/TrhCtaXcJws0srmAeqZHnFe7/M14nipN4No/UCey45u3mViv09SK0CGJAg5h5kY5X
         7MxA==
X-Gm-Message-State: AO0yUKXQNBIx30aeQReTjpQl+ylGOyz74i6ImJuouzcxuKxDzgCnf74G
	Ucell2RoFehDOZO//OzPm2CBt1mJ9PewZA==
X-Google-Smtp-Source: AK7set+NggMflM6BNmRBHhGqrUcGVQByOp77BaqX2/+UoO+KkK/O0C3um/TDX+sbYIPuNVsMZ/613iCYuJMYfA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7207:b0:19c:2b30:f22e with SMTP
 id ba7-20020a170902720700b0019c2b30f22emr354082plb.11.1676690608082; Fri, 17
 Feb 2023 19:23:28 -0800 (PST)
Date: Sat, 18 Feb 2023 03:23:09 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-8-ricarkol@google.com>
Subject: [PATCH v4 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..8c5530e03a78 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -991,6 +991,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
+bool kvm_are_all_memslots_empty(struct kvm *kvm);
+
 #define kvm_for_each_memslot(memslot, bkt, slots)			      \
 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
 		if (WARN_ON_ONCE(!memslot->npages)) {			      \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..3940d2467e1b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4604,7 +4604,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return -EINVAL;
 }
 
-static bool kvm_are_all_memslots_empty(struct kvm *kvm)
+bool kvm_are_all_memslots_empty(struct kvm *kvm)
 {
 	int i;
 
-- 
2.39.2.637.g21b0678d19-goog

