Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3C953B5
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 16:59:06 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id bk3-20020a17090b080300b0023098d62104so1846451pjb.7
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 08:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iOpp/S8Rtelv3h2rWZJqIJdgZzud+NaCm9qMEIp1MnI=;
        b=sKfiuMTpfyXaq12seZrzSDjLQ086gfmqtdv4cF7ki165PqRcS4JuSmFzlwgwD8G5xk
         UmH8vLp6oybFNKOXyHV8rZBBZuWWr/XEbTmtMZk4fa4it2miA63L77htcx57jNOkjjjC
         fjVc3EiLaA6BzAWlOd5aGzYvA87cTEexWkjcATvLpehYjZ/4ng5onMRqBqjTPXRibHU8
         5d1hueXAYquDsbUKDj303ZwOwYZqTCZu5l/TS0/CdHSfNHiszcROETa7jQ3MTibzwOHM
         A9dz4+r0LX57xxL5TDp/i1AN5WGxB4UDieKQBexLxjfqzoEzPu6Hrg6Hd3iktEMwx/uT
         lBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iOpp/S8Rtelv3h2rWZJqIJdgZzud+NaCm9qMEIp1MnI=;
        b=3dlF5/h9e0HaHelqrXWjhfLSneMOkrrTHsi47gbWyUKtM4m00efwefNJ2OkZpVLzFR
         BsdNK1tU1z2owa+zpBnKYvvq3AVbi0TzqCa7Kvpx0IvEuOo0o3ejddHCh3elpBYprgkh
         71rnKqtVPa0/lySUvT9gIW4QSqSOTQ39KSoA/io4P3fZ8pnDlNbRxf44LGKgARei9GAe
         S5nslctgzBLYbH7u5YxRn0nqMrxhyr36SPbkpqK6Arx8zLsbgW/RR+MvVaI8YzQjGRAv
         rA6DaS28JZrFzcA7oRtj+aTki6M3JK2SVdiPAW9paM9PXOE+c1X+W9CLNX/4dtwGC/eo
         NrDA==
X-Gm-Message-State: AO0yUKVp+NzuOuDuV9uQIBQWYIja49iJ3T8NU8Ix7gCYlattSPRN+tti
	Y+drADp5n6J8B6etIyCT2rou6/A4IfeLvQ==
X-Google-Smtp-Source: AK7set+9BMru5C7ajdZ/QFnYvf0vq6OsZXfNWB4URhHpoB1VV9dRbuBfGMCP/U4V0dUdFkxQcatVyOKOpOVTJQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a65:45c9:0:b0:477:31bc:348f with SMTP id
 m9-20020a6545c9000000b0047731bc348fmr3202793pgr.72.1675702746208; Mon, 06 Feb
 2023 08:59:06 -0800 (PST)
Date: Mon,  6 Feb 2023 16:58:46 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-8-ricarkol@google.com>
Subject: [PATCH v2 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
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
2.39.1.519.gcb327c4b5f-goog

