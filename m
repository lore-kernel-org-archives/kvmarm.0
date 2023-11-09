Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CD538DFB
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SwQTJ7kH"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d99ec34829aso1610745276.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563829; x=1700168629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh+5PdZyMdvOdt4VU0TI3yfX/lCMTr3N0qAkuDtTShY=;
        b=SwQTJ7kHvlOBD1UHpx3IE4S+qdaJE1aUYAXvjqp6mZmKohbg+enOkffKVIU9+Ussfi
         /BKCNddVd52fz2bMzd/Yns73a1gKojh7iXyXvBV/zRJDXvgTgZaE0mejGsEwPrxTnCRu
         Y8t/t65nNuqhC/mkHejG7NAUiFcKbDpmisvzq7yOYLMbjXhqHlRQAqF/19WeFdzrLdZy
         piZsuPICIKlJytNmCCBiMbX1g5WvQSU9qoqKUnUWN691U98GaG5cHBrQNmOFX69lOih5
         imLn98DMKoFAhlDos4TRmsBrqd6e27jZ+Vuc37Xz9tFei1813tc0UKJBj/sUpZIWS51c
         xVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563829; x=1700168629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh+5PdZyMdvOdt4VU0TI3yfX/lCMTr3N0qAkuDtTShY=;
        b=QTetbFfQjznc3JkLoBHDT4mjt4xNtAIz7o1iwIujaHZe4dLZZ9NzXLQrpsMgF+iMq4
         WE/5YX33+PMNLELiWqVFV8tEi+uUoCDxvOTf8X8AE0G7X05KiwoYYw6URs/v5jV8KeMw
         ba0ozKsqiGlWyQvYIxXaQOIE8wpw/Y/d7HXm5MsQDjkGUG41FDdkF7SwnRp1UvRzkey+
         KCoA0IoXjOb4w2v+1L/rTou+3Nn4UN1+VG1rgk/ShW8Bb3/4susFDYddrfLpapEyf1m5
         8oImRC4l267lBab8ni+Xu+++d0yCCSjhmR0064tsaFOciyKiIYtUXIHV8Dj+2jHqFF6X
         H70Q==
X-Gm-Message-State: AOJu0YwsEhlTwmLnL5wnzOfGbPP5OSPwcum3UiLMSf9yUjh9SDxzXYJ0
	0kmxqa/f6GJwqQVpg6OWU9iDEp+6t6YEyQ==
X-Google-Smtp-Source: AGHT+IEuA2Q5awcM86dll/dLoA1R4aMXnRfBkF4bbpGUOJqZbuvX3Eb5LoClktTK56YlYoIiH1cKlOvlGRBPTg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:244f:0:b0:d9a:3a14:a5a2 with SMTP id
 k76-20020a25244f000000b00d9a3a14a5a2mr153578ybk.13.1699563828968; Thu, 09 Nov
 2023 13:03:48 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:16 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-6-amoorthy@google.com>
Subject: [PATCH v6 05/14] KVM: Try using fast GUP to resolve read faults
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

hva_to_pfn_fast() currently just fails for faults where establishing
writable mappings is forbidden, which is unnecessary. Instead, try
getting the page without passing FOLL_WRITE. This allows the
aforementioned faults to (potentially) be resolved without falling back
to slow GUP.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 88946d5d102b..725191333c4e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2811,7 +2811,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 }
 
 /*
- * The fast path to get the writable pfn which will be stored in @pfn,
+ * The fast path to get the pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
@@ -2825,10 +2825,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 	 * or the caller allows to map a writable pfn for a read fault
 	 * request.
 	 */
-	if (!(write_fault || writable))
-		return false;
+	unsigned int gup_flags = (write_fault || writable) ? FOLL_WRITE : 0;
 
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (get_user_page_fast_only(addr, gup_flags, page)) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)
-- 
2.42.0.869.gea05f2083d-goog

