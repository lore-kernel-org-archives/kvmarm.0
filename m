Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3326FB650
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:29:57 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d74829dd58fso2521872276.1
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212196; x=1694816996; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XIpmIJLaTkwi74h1riRreKSmTmxguF7fM+nkkiCilQs=;
        b=0Ahzy7kl5K1M18DI7JlDyEHnQvy5rydVggEtqxOl+yFy76uo2WJHVmcEDHGx3xWPd/
         UOeGDtsprzLwJI0DItombtvb0EoltUIPZWP8lEYZydWyDkoBK+WUs5GxQI6M7Z1YI/4d
         3BF5NtptgeGV6ZPUk75a9R1+Mx4mN6cXTymSj5MioXv5QFhg42iR3E8YR7kV/cLFrJBE
         6PsECk7pXirfuLYJfmsp2aohzi6EQjHtiZqCTkfAMlZ309rclfLXxKQCdPghxRP/sNWB
         fcM9iT0zoGpQdePA0FNhIrZxKC7v3dE7In8Uf84mqLKoFPZgJsxSsI7+P6BjpCepj8kq
         dxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212196; x=1694816996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIpmIJLaTkwi74h1riRreKSmTmxguF7fM+nkkiCilQs=;
        b=mPJHihF7ZfFr/qLxqin+lI4ipeJIsx/d0Uis5ZldDw/GQJzATJtLgUGtD9tmRm4WJi
         MDLlaKwxoUA336zf3qz2GsZywn3KGuoyxIgSNuBGlk/It51KNugGyG0GZIDH7wcxTbEm
         0VT/cZvjS/Ap9KL/mRtlSSe/CIbLPwtOY0FdaYQnlT5z/eEWTgi8mfobhCXdDi1B6Cmc
         Zk0nd5JRJgyQGJFYisx+QqndA3WpWRdirIh9TmtkpBeGzT2RCf4dciAyY6MqBPMEOGw8
         bxOGz67ivhe49cYvjmyfUEXVc6SCyhP5SyUj7waj+vRMt8SPHC6qd8vGw1PudxAFv/87
         Zc6A==
X-Gm-Message-State: AOJu0YwdgK+kSm18bmwlcTxRk4sN9sNXSJjrEEKadTzNBkxRtwGewF9R
	snOjaZ5y5voTtV3oCTun8+kc78Y5Un5uCw==
X-Google-Smtp-Source: AGHT+IEe7UramIvSlKRs0rA75cYHBcDpS4lm5Q6muAmcukOws4HAJpGyE1NyjeXOcZg1PL2GEmXXUQtyP3Ilwg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:a2c8:0:b0:d77:984e:c770 with SMTP id
 c8-20020a25a2c8000000b00d77984ec770mr85787ybn.5.1694212196358; Fri, 08 Sep
 2023 15:29:56 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:55 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-9-amoorthy@google.com>
Subject: [PATCH v5 08/17] KVM: Allow hva_pfn_fast() to resolve read faults
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
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
index 13aa2ed11d0d..a7e6320dd7f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2508,7 +2508,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 }
 
 /*
- * The fast path to get the writable pfn which will be stored in @pfn,
+ * The fast path to get the pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
@@ -2522,10 +2522,9 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
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
2.42.0.283.g2d96d420d3-goog

