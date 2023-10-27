Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5093F3C080
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 18:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mj98UO5e"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59b5a586da6so22562307b3.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430969; x=1699035769; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MfwjFnr1wNHEBMs743caMc0qlRTo5HMEnN08vNH/OXQ=;
        b=mj98UO5eoleSgxOHeTgHP2K9/S4aOk7B1IlDqDLXLWhPNtrsoFFkg1wNAsIgJ23cob
         E3t0ZlOHOKB9O32933/4K6NrYOHf883W1+5/+gyCdDij79FpNlx/R5J9wMtLwNXc4qcI
         2LorHYEXHqrQxvaGvPZvoT8qp1UtaScaObmQ0cNAMERnOvwnPVsHCp86PSqDy5InIqCA
         vl1XCC0BdZwNYpWq8LJ3QaJBxqrn+r6tFVQkONS8tYQzi/oCLTF/QeC57IfJEutBRmWO
         T05IZBBwFvuY5nC8Qr0jyzpxpvfwUC0BjIJRnMPw/5PuqMApS1nJqMIk1TW21sU+rGcT
         u+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430969; x=1699035769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MfwjFnr1wNHEBMs743caMc0qlRTo5HMEnN08vNH/OXQ=;
        b=km7tL0kIbKLkqD9q6UpZoKiy/lmd76O+j8uEsVNPioWK517PFqckKogrMm9aRVhNuR
         IsMu7+/3tabfO9tnOkLkUnHgBZBHseB5dQcAL1x2CEoqaatvS9lta2jLELnK2UuKTnkY
         JFkb+bdqiob7xgLkrr1zUu3HDuft1VUmWOq+cG5R/4qmmPRPFJYm27vJuTMnwrrr7F2w
         2f9nLmf+pEVK8ksyRQXiP8z0a3MfeaifysPrcMl55ddCKtG7nkEbAfi4noPQeU3DJrei
         kizMgNILFrw6NW96HCQEQGEDXbISakGSmOD6U5LJhtTgED+KHTDynHBmz2q6/1NuizFi
         Y5Ug==
X-Gm-Message-State: AOJu0YxtXFtyrnmxRHmby9JrhojNnqi+GeN7CPcP1iBKxVRTXgdbqMdK
	sdOqGD41pgNHSqqF2e4uK5h+Pc39Bkk=
X-Google-Smtp-Source: AGHT+IHtw6A7NuD1zDZw/j7xBoNpID5PTLHCLxD7YeudY/tlgoiYGQdJN9iuOebDV/xY0oQ2kV5qeLUK06Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca0f:0:b0:59b:e663:23b0 with SMTP id
 m15-20020a0dca0f000000b0059be66323b0mr102868ywd.4.1698430969394; Fri, 27 Oct
 2023 11:22:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 27 Oct 2023 11:21:54 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-13-seanjc@google.com>
Subject: [PATCH v13 12/35] KVM: Prepare for handling only shared mappings in
 mmu_notifier events
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add flags to "struct kvm_gfn_range" to let notifier events target only
shared and only private mappings, and write up the existing mmu_notifier
events to be shared-only (private memory is never associated with a
userspace virtual address, i.e. can't be reached via mmu_notifiers).

Add two flags so that KVM can handle the three possibilities (shared,
private, and shared+private) without needing something like a tri-state
enum.

Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 96aa930536b1..89c1a991a3b8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -263,6 +263,8 @@ struct kvm_gfn_range {
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
+	bool only_private;
+	bool only_shared;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb9376833c18..302ccb87b4c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -635,6 +635,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 * the second or later invocation of the handler).
 			 */
 			gfn_range.arg = range->arg;
+
+			/*
+			 * HVA-based notifications aren't relevant to private
+			 * mappings as they don't have a userspace mapping.
+			 */
+			gfn_range.only_private = false;
+			gfn_range.only_shared = true;
 			gfn_range.may_block = range->may_block;
 
 			/*
-- 
2.42.0.820.g83a721a137-goog

