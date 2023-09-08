Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A61AB64D
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:29:52 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d7ec9300c51so2483819276.3
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212191; x=1694816991; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QprTGpxfsgvH1yfhYL4R5BCfHsypk0V8kYldvoTmsTo=;
        b=GFu44nlHvefIlFhDXWXqv6c4mKguxSjPoMarTpA0LG0u0KXTM+Ut/37mYfXfJZNNyS
         TK5d4jALrEkJh4tJRBPXRtyi5yL+nLN48dzEcATfSKt0UyEKPALjuZub+5wGgVfiVVfJ
         +Ym2DVui6o/OYg+aU7zpsUcxdFyie8f0nBglnrO3+pGseS8istDzd2xjPhDhJvaVleDt
         6QXzTK1OQkn7bzca1gMitKnSN+KxAwAqQT0vKtonlLpQRnJw1o1egMGQptey/6ImMTbh
         St3Iie29FRIg+a4Y0qsGStnfg+knMW0yiocwtA7vZ+p4Yrmbe0SZqJ0StLaQv/I6BZqJ
         GeNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212191; x=1694816991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QprTGpxfsgvH1yfhYL4R5BCfHsypk0V8kYldvoTmsTo=;
        b=cbsK9ANYwohH5OTDre6J0NN1SyFZNo0D6ca7mGkYbdj2xiq8a2MGBRo7+PjoDJZBCM
         h4wcq3X7JDaW3pCflDoBis3RK0R2W9oB6jGDJ06Ibjb5wIUzuqVp6Lv+dMykv3G3A6om
         gvBzbvRzl5n2hVyF5xZWD5YpO8DVWqY2/aD8iu3N6ejsBG9G2HVXYIorTlJ7mHG+WxYa
         ZsvnNDomisSIknQPfzpSN7jJEJYADJQvCY553oHvAeyne5Y5zijGnEywim4pHugFFNCi
         J9ZvRL+vaUZXfxPnqi1B7D5f4I4fe0KUqWzgzfXMDdq8d91pgD1CHp6io5k/rrl3evTp
         AkYA==
X-Gm-Message-State: AOJu0YyrmZovSBqNgimxf46sj57X7fiQILq9VH56QeUfhevAf2XlGXcc
	cy8WWlgJe4uSzFRT1tm6bhOUdQBcCr2IWg==
X-Google-Smtp-Source: AGHT+IHIr/vLEv+gPrXhAif3UXfspI7EvM71lsU0z0Vz6t4qHW13LUdBjj766mWb+KiW3puYslbOWzUwEl4Icw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1682:b0:d7b:8d0c:43f1 with SMTP
 id bx2-20020a056902168200b00d7b8d0c43f1mr90723ybb.9.1694212191262; Fri, 08
 Sep 2023 15:29:51 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:50 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-4-amoorthy@google.com>
Subject: [PATCH v5 03/17] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
duplicate the "if (writable)" block. Fix this by bringing all
kvm_is_error_hva() cases under one conditional.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 12837416ce8a..8b2d5aab32bf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2741,15 +2741,13 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (hva)
 		*hva = addr;
 
-	if (addr == KVM_HVA_ERR_RO_BAD) {
-		if (writable)
-			*writable = false;
-		return KVM_PFN_ERR_RO_FAULT;
-	}
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
+
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+
 		return KVM_PFN_NOSLOT;
 	}
 
-- 
2.42.0.283.g2d96d420d3-goog

