Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E1D184F
	for <kvmarm@lists.linux.dev>; Sun,  9 Apr 2023 06:30:18 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 10-20020a25000a000000b00b5f1fab9897so2941590yba.19
        for <kvmarm@lists.linux.dev>; Sat, 08 Apr 2023 23:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021817; x=1683613817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ft5inxy0lJvedl+lPTjf7i3whkyMGzHS4NcUWxPl25Y=;
        b=QV7wzIU5pCtht+TkpvyOKA/ql54F5l/+2fagC3lddXH27BxlHiXuW/gG7zO5iVMQgi
         iTCsuDMFi/upLr0XubVqPWLAYt0YXJOncS2Habgixny/UvIiwLJdPOAdBl/IlRGTw4aR
         9AjS8dUUAP8FOR8o/bvK58RnrRbsYNrr6PPm1JitfQ8Xd7UDMlpuno0/zyJkWaNab6Fv
         WeT/p+2VP9XESL0Cqq6WLxiDuL6ecmZGINKAGSn/PCzYl2LAs+0RjJZVBC958rnhZ/jS
         bU2rgQAZNG0sETQG+i/xXDrWRo23sxMb9Yytu+RMFXJ8qbtLwPT1MtEZ4Vxj1dI6gsYl
         k71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021817; x=1683613817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ft5inxy0lJvedl+lPTjf7i3whkyMGzHS4NcUWxPl25Y=;
        b=VwVk5Faf+KfjEcdSNonflIKgV5yBmo3jxbNT+nDXHlMPVUuLhVFSEmGyTuw7XrvH6o
         VLr43WJr9iEFWujxBMXpfBDNaNqysUTiOkt9bmXCN9N/4LUbvHxZmd7pBY6y6Y6wMFwV
         OAVhOVDxDptYzZWNdcc0DUAVjB5Er+FRCZMNjClX7XZ1vFY/JubiXDPcih0MkJ8H6LjF
         2h7Wbr9w9U2tubMBVgNjwSW9Nv5SVhIgMPxMJl6KLZDmqM+oaHGUxP5L9fWL17yidwZ1
         NcRZPCL2L+C4hsbSJbl4wk4/RdAMZqxnuYU7vKVMTks/MN+/C7H6w+x8U0Wp6uVOEoJw
         yT/w==
X-Gm-Message-State: AAQBX9ezidGbDnzsIMdnFRFkNHCDmu8LNZh957Ic3TEKW57BxtDSXGIf
	SOd3xuEp4Gw9Nm6qgNy6j1ZJ4cngzheDuw==
X-Google-Smtp-Source: AKy350bL5vb7HvZVGmm/f6AMNzePowoZYI1Dyh1rBEB9ygsfZ74CWgH3j3bf/PvtU11XBlL3GA068hTaFrv/PQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:7e47:0:b0:541:8ce6:b9ad with SMTP id
 p7-20020a817e47000000b005418ce6b9admr3979422ywn.2.1681021817250; Sat, 08 Apr
 2023 23:30:17 -0700 (PDT)
Date: Sun,  9 Apr 2023 06:29:55 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-9-ricarkol@google.com>
Subject: [PATCH v7 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Export kvm_are_all_memslots_empty(). This will be used by a future
commit when checking before setting a capability.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0ec..c6fa634f236d9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -990,6 +990,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
+bool kvm_are_all_memslots_empty(struct kvm *kvm);
+
 #define kvm_for_each_memslot(memslot, bkt, slots)			      \
 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
 		if (WARN_ON_ONCE(!memslot->npages)) {			      \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331e..897b000787beb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4596,7 +4596,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return -EINVAL;
 }
 
-static bool kvm_are_all_memslots_empty(struct kvm *kvm)
+bool kvm_are_all_memslots_empty(struct kvm *kvm)
 {
 	int i;
 
-- 
2.40.0.577.gac1e443424-goog

