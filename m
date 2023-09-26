Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B7838DD6
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 18:19:47 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-30e3ee8a42eso7087580f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 11:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695752386; x=1696357186; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DGKOexKeYx3KIrtoFBMpiZrvvlVOfn3NLusWWIToTBE=;
        b=iCEpE5O/8eb4d+lM9JUQbaVXsBrboml5Div+O1u/R9CsfGXlBkoZCYytRKyYRF9RBG
         dhDPcQdVaz17xiUFMup+upfFZ6mougWVhaq+bZ7umH9o6drF2ITHfqQNkZ+36N9yoc+d
         cH0cTu9LDGaTG4HReBkTShnq0IyfWPGnUOYOxO0bEan5tjzwcHXeNz2cwiEG8pYlCkJK
         /uHiag/XBi2dzO6GYowziYQkiljrhkKtv9s2IUv1DZokwPrqkddgV12PjO+rvT0p0Wye
         oF0yFVh+9uL/ReNAcXvSo2u5gDbEwkKYXqHB+b9XRyfncU5AcVaTb4b0Dysm8cRJB7D5
         wiig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695752386; x=1696357186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DGKOexKeYx3KIrtoFBMpiZrvvlVOfn3NLusWWIToTBE=;
        b=lCzh1X14rckTQM3WUOked42azFNG/vtjj/LK3JUKVBl1O4zJAC9QUmFrXlWNlM4pye
         8vLH3RDS5UcbcuTAD72u0ns5vL0Evqa5tNVHr3HcYb78BqcD9ki2buiSZQsnmxhg9nu3
         ZlhGI0kzlrWvMBXOhB/mpe66+fsznyhLxZZGgwJzT3D2NZEq5TFUTDqrdWXy6Oq346vd
         auh4iT2W6gl5JTG1qfjhtSvUywQSnpczITY5O9XyrkY+J0YbvkfOxSiOz2XXGJLqFZ8I
         Wh9FXXkn1b22CV4YYwEWCO3eT4xdKM6GmAB6nOBN14CX7cS+4HMImPtGt2bD1ZC9xReH
         2myQ==
X-Gm-Message-State: AOJu0YyHP9eL4hFJitIxdNawVSJ9NYTSx+d6UEnpRLp2Pry8NnEyHzwW
	GmNQb7FoNiMvJZSenZrGe8woROSHpaXdoujD
X-Google-Smtp-Source: AGHT+IEqc0pyzkMuy8FapsV9SHMmWLYEASvTHx0NsjF40Te7/goAR7lbuc+BSqE3nTWIs3RuYvucpCcOwRI5yu9u
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a5d:6446:0:b0:31f:b4a3:db12 with SMTP
 id d6-20020a5d6446000000b0031fb4a3db12mr55390wrw.6.1695752385720; Tue, 26 Sep
 2023 11:19:45 -0700 (PDT)
Date: Tue, 26 Sep 2023 19:19:31 +0100
In-Reply-To: <20230926181932.1650692-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926181932.1650692-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230926181932.1650692-2-vdonnefort@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: Do not transfer page refcount for THP adjustment
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org, willy@infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

With folios, GUP affects a refcount common to all pages forming the THP.
There is therefore no need to move the refcount from the tail to the
head page. Under the hood it decrements and increments
the same counter.

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

