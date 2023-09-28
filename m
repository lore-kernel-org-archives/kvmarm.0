Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1FD374FC
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 17:32:15 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a22f833405so9341447b3.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 10:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695922335; x=1696527135; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0OrolHEhppSNqHfijRmLo8eiKiIO9HbxQQbiWJh4bXs=;
        b=F1lFFlvOIMhux0r60GuoNniMff+nNCwAKFLktleuo8I+AU6JLHccKCCniU/vLcKT+p
         vDN/cQVRQVs099fqDXnyQisj8CmZLK/0JuIV769SNvtJnOG1tPzOwaG50Q//nixQ8Dmy
         htuAeI8nvms2a+B08f/BGvzf4VeZqNFTgFjXDU/i9Y+IKsCq/4vnY8JGkDBZ78h8HYrZ
         z/9ZS9iXmgBS2nrMaqWs7MpLIYoD/bMPeEDmVdUt/tdSs5aGiq7V5vNMDN3fT2i7NURT
         t9RUB4kfC098hhhZIOfsnIsKGR9mYss2v5y7MlkOpmmhNvHTi1PSkSCJwbFkQdbR/KTo
         bWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695922335; x=1696527135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0OrolHEhppSNqHfijRmLo8eiKiIO9HbxQQbiWJh4bXs=;
        b=e42SJDH0cM0NnkpkOIwHuJBuIfqFC+M1TOKsLerkevnxpq4y/pwS6Hswt3tdQNVCUh
         c91Qzluy2oYSErC2zgmEjJvRD3oPEOmEZSOqIgLzytXWhnlRlo74aZQpjxqwsgcobYyF
         yLT/0pceaSQdp8GnlWGoeqHbP7HjwVU4nJdbED+tLGIF3ED6ncAN9QZnIel1RGfPFo4R
         /yjJX0LT3twf1aXIajmOsKpgBPL2bonHIiq3ToP99EneVa1mftBsIvRKlSde6yCgpNdP
         Pr+IdZQCcefYht2LHWdC3eYx7nF32R9TCq0CUJpZu8yMY8jG3AWt7QC1QpAX2+n26+cq
         bNpQ==
X-Gm-Message-State: AOJu0YxlXgwKQ59b2dcReydDIZLd9kGPl0uvFd4gQ/P6OHCMRadcIOiZ
	kXE4KVhuyoO0Jqs6vylAsK3gdthVK8+qhcJU
X-Google-Smtp-Source: AGHT+IF/Fa0Mh0oBH5WiyhZSx/am6vHeFH1SjUosji1bp+q9vgUSK9otdQ/l0ZJOkJ52EUgq+NqoKxRy+7XU3Ds2
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a81:7e07:0:b0:59b:c811:a709 with SMTP
 id o7-20020a817e07000000b0059bc811a709mr29487ywn.0.1695922335176; Thu, 28 Sep
 2023 10:32:15 -0700 (PDT)
Date: Thu, 28 Sep 2023 18:32:03 +0100
In-Reply-To: <20230928173205.2826598-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230928173205.2826598-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230928173205.2826598-2-vdonnefort@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: Do not transfer page refcount for THP adjustment
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org, willy@infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

GUP affects a refcount common to all pages forming the THP. There is
therefore no need to move the refcount from a tail to the head page.
Under the hood it decrements and increments the same counter.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 587a104f66c3..de5e5148ef5d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1295,28 +1295,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		if (sz < PMD_SIZE)
 			return PAGE_SIZE;
 
-		/*
-		 * The address we faulted on is backed by a transparent huge
-		 * page.  However, because we map the compound huge page and
-		 * not the individual tail page, we need to transfer the
-		 * refcount to the head page.  We have to be careful that the
-		 * THP doesn't start to split while we are adjusting the
-		 * refcounts.
-		 *
-		 * We are sure this doesn't happen, because mmu_invalidate_retry
-		 * was successful and we are holding the mmu_lock, so if this
-		 * THP is trying to split, it will be blocked in the mmu
-		 * notifier before touching any of the pages, specifically
-		 * before being able to call __split_huge_page_refcount().
-		 *
-		 * We can therefore safely transfer the refcount from PG_tail
-		 * to PG_head and switch the pfn from a tail page to the head
-		 * page accordingly.
-		 */
 		*ipap &= PMD_MASK;
-		kvm_release_pfn_clean(pfn);
 		pfn &= ~(PTRS_PER_PMD - 1);
-		get_page(pfn_to_page(pfn));
 		*pfnp = pfn;
 
 		return PMD_SIZE;
-- 
2.42.0.515.g380fc7ccd1-goog

