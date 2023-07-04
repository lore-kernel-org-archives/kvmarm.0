Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D93E17E6
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 07:52:07 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-66869feb7d1so2688742b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 00:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688457126; x=1691049126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qee/VKQzM1LmZxAkmmj2aucWtJOH/l94Gljx+K2KDa8=;
        b=k+iMyiIZ/rvkyJFLnpCxfPh2kihs9hKp7WCZMgRJ/KWcfxGthOuSTxsh7ufzJA/Bf/
         mzh6BZEJrCQrd57esW6bSICX4N5fXXviTpScCU4T+p1S9Ex1CyHnmwVooY7ZQFENwzJz
         zEkI3p/OBQ13cxCJNgSaA3m+7cI5QWfuYcJr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688457126; x=1691049126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qee/VKQzM1LmZxAkmmj2aucWtJOH/l94Gljx+K2KDa8=;
        b=iXpH+K2u9f8vAj9qIkj5IXYe4k+NCTbKEKasSNHpxj684OXA1kY1gzFqzgp6AYPOGb
         MkXjUGUylKC4X459pS2zd0kCA+e6lHZRxVyhI2+/xifpxXsGJ8Klp1HxBcLFCPpzcbOI
         04rikm1uXmAkL7sILRLTclZsDd9LmEUVfI5gfdU0HTl4BS8BC7W0iu6i0S4sRmfOf0Vk
         uk8U8oUrbSVODYb7qm1kItPZL35RyGLNpolCAj776Pjkfjj222KyxTW59SGGkjl6Q+E5
         Jc6D8+C26wqvY0q9qmRaGKM/Kq3cI2d8cREZ+36D3dparpeAG/1GhDELgnCBYng4Ka3L
         D7yw==
X-Gm-Message-State: AC+VfDz/Bk8PsvbG9KhQ0UINYDgo/JfbrXrhYoCX0r0O+jFO9nmqbIk5
	/q55wQextl6FFfqK8VCbqzf65g==
X-Google-Smtp-Source: ACHHUZ6+9ouW33wDPBoDXHeV/P1AI/Ns1TtvrKGhlPJ4FwNyTE2MhXe7ejlBjshhe6QIZRhVgVHIEg==
X-Received: by 2002:a05:6a20:8f0c:b0:117:a2f3:3c93 with SMTP id b12-20020a056a208f0c00b00117a2f33c93mr13849232pzk.2.1688457126666;
        Tue, 04 Jul 2023 00:52:06 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:a11b:bff7:d8ae:bb0])
        by smtp.gmail.com with UTF8SMTPSA id jm23-20020a17090304d700b001b51b3e84cesm16610112plb.166.2023.07.04.00.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 00:52:06 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Peter Xu <peterx@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v7 8/8] KVM: remove __gfn_to_pfn_memslot
Date: Tue,  4 Jul 2023 16:50:53 +0900
Message-ID: <20230704075054.3344915-9-stevensd@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
In-Reply-To: <20230704075054.3344915-1-stevensd@google.com>
References: <20230704075054.3344915-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

All callers have been migrated to __kvm_follow_pfn.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 virt/kvm/kvm_main.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0f7b41f220b6..5b5afd70f239 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2712,39 +2712,6 @@ kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
 }
 EXPORT_SYMBOL_GPL(__kvm_follow_pfn);
 
-kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva)
-{
-	kvm_pfn_t pfn;
-	struct kvm_follow_pfn foll = {
-		.slot = slot,
-		.gfn = gfn,
-		.flags = FOLL_GET,
-		.atomic = atomic,
-		.allow_write_mapping = !!writable,
-	};
-
-	if (write_fault)
-		foll.flags |= FOLL_WRITE;
-	if (async)
-		foll.flags |= FOLL_NOWAIT;
-	if (interruptible)
-		foll.flags |= FOLL_INTERRUPTIBLE;
-
-	pfn = __kvm_follow_pfn(&foll);
-	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
-		*async = true;
-		pfn = KVM_PFN_ERR_FAULT;
-	}
-	if (hva)
-		*hva = foll.hva;
-	if (writable)
-		*writable = foll.writable;
-	return pfn;
-}
-EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
-
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-- 
2.41.0.255.g8b1d071c50-goog

