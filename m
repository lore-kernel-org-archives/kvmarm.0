Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51521C750
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:19:58 +0000 (UTC)
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-75b3b759217so319060085a.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722797; x=1688314797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FXT5aMAcAtW/D2yhSA+7CF5prLM3G5exI8idyNJeqlQ=;
        b=MrEIIigb/YWqQ92xzazuzi8enjhLzSd+deyqUfxtAuxGcNqxPI1zoRqcgcPsZY0in6
         qI3YYemk7dYSuAVwReP578ivZLe/S+Vb2LcuohJjUFeOTbSYeRByh+dDUtwGlWd7bqiJ
         DaF+LJTYubD/Il4ugc/2AikpfHGkcDTqSnLD7Au/SIooTtUGWzqZ8jw3NAlmur2U5N5F
         Gi8UEFQVo81bXlMd3kDzyQgcnjMyuxHFAHBtWhXgkIj1fL4mmWbKeGkw5tRZomR5ScUp
         oRXjUOSbG4XMo5NR2eWkCn9pKDfIrWQE8UmzWf7SrW9kbXzhzgVc13lSDq1ZHIf25HIU
         1OEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722797; x=1688314797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXT5aMAcAtW/D2yhSA+7CF5prLM3G5exI8idyNJeqlQ=;
        b=DmqGjQSmYrVmefhTHCHLgxpE9V8aMCbQ56mSS17A9TIo7PBEprNnLwv6wDEgWGP43b
         f05SyVIFB748k2d1pBD1GPLPjuzjY7JW/ioUEOwJaSBCIqaoQFrf1Is4zpBidtw2ouQl
         +Ab1J/HyibR0FVWwjd5OZLg5FvMgmTG2kObkGB2vP/Hu4q1osiNRNhazVePX6uUWx9Fm
         SwXVmr32GQTqhdVbEcRcvkeN+xAgeptfX5V3HPDw0Q0HdlbmRI8iHuxz4dNPs4oyXCLM
         TBzB/FgA51g1mgjjSxX3noL/fslrvesrD3Qzw2HWxltnH5ofBBInygefmlASm84tfeDf
         gD4Q==
X-Gm-Message-State: AC+VfDya+7Nu/JhkkrwPQOhruM5qQjsqP9/hqqvvNyQpru7uGdtlmmKA
	PxZH4Mvv785Xx3J5MY+y63J/TD1LfUT/dQ==
X-Google-Smtp-Source: ACHHUZ59szArc2J5yzRQ+OH/b4av8GVrQhCDas0t1JFvDETpn96b9hqdXPaAc3D2wV6P4OkT5+sVUxvqNLjTZg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:620a:3950:b0:75b:3839:7176 with SMTP
 id qs16-20020a05620a395000b0075b38397176mr3883333qkn.13.1685722797500; Fri,
 02 Jun 2023 09:19:57 -0700 (PDT)
Date: Fri,  2 Jun 2023 16:19:12 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-8-amoorthy@google.com>
Subject: [PATCH v4 07/16] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
duplicate the "if (writable)" block. Fix this by bringing all
kvm_is_error_hva() cases under one conditional.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b9d2606f9251..05d6e7e3994d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2711,16 +2711,14 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
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
-		return KVM_PFN_NOSLOT;
+
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+		else
+			return KVM_PFN_NOSLOT;
 	}
 
 	/* Do not map writable pfn in the readonly memslot. */
-- 
2.41.0.rc0.172.g3f132b7071-goog

