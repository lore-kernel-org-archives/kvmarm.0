Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4E01FAC4B
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584756; cv=none; b=s1yd5t/zpG7Og3gvrPEPSymK7/AcmbGFNbKS5G7ID6XZrC3wQIQAvbsCE0v4I2Y/wyKa6HzH7ccUk4s2NvaZH+tZ57TURMzcYZB8XlVINMZKHPVFodwQV6xaNnI8qQ+FwRCQ+YujIKMUDrTVvEk6zo3JffKJAiYNXMuzpVrIwpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584756; c=relaxed/simple;
	bh=DZ/5QhAqV/AFQ+a9ItmswBEEvilydxqWBCs3ItnJewM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RNypRQUAsmfDmT6sQAf9TrApwMcj+FKF5DjIeykPwE342Tb3JZQdT/hOLXrO+PWMKManbbwTucuKPKrrx3Ms82I2NlH9TGguliLMzRo/B/N441ds+mDCxdaZCmzdm2jIQQl2NDsE6SM4Ft1IjWubSnRnGuZQnrwMz2IOQIfyIdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s5HCNEVU; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s5HCNEVU"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e29142c79d6so715122276.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584753; x=1729189553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXVCtJlFVF227JmXan6PsTRYgw7//koA3Av9lMmMw70=;
        b=s5HCNEVUhb7njiqIGoVjLEzzGhYCYHVCmt8yuWf+RHbRXqwKRB65ITVMX7ASicmw77
         aAeCwURvjUv2VhhmzUEDcdH0hGn6R/E/XAwKUZ0Ee8A3NvBoRw4GHYz1vflLLNPYEyNd
         baGXQvUHTh6EEaO4p7qWw8SKVptAbAhxci34RK9pyKb5kQnnmQqDle1WwhiGmayu/R8J
         +U+7l2WQNynC7JQ/X9aNTRsJGfpzfe6pzeQGRpmBjjCPNaWLXg6K5Ruy0pZ946SPxzMK
         KIsQEgKGCqSjXzr82aWiYt4l8Ak3KIAI3Xi9MX7wvg3S3gfP/VMbG8GGPRwbZMmCxlzb
         n5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584753; x=1729189553;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nXVCtJlFVF227JmXan6PsTRYgw7//koA3Av9lMmMw70=;
        b=aIOlZGqLeLwxCjb9O95vOJpjWXqc1Egh2pXQ1dkPPEY4bm7iL3r/+QbAm9yVq09vyp
         WRJpPXcjnfGFB1yY/DeudN5clzg4u4TXZhxD/YtffHe3vhYrP3uNyz7Vr7xq/7GauaFg
         2LfAjFp/NoSKARwzJUKh8IqH55jfmkZPK7vgHU8nlSCKh7EV4iEC+Ugt5eyAiWFW2RoE
         k2kuBkywwaCkib2SjCoDUHQeB6EjtzUn/7Wj20KBzf4EzsG1oD1XtpKnhkiDDHIj42Df
         0zUDYKaT2yKnSwHkUzgaSpc0hFG3QD1+96czYwWycMr5z1jvr5AU1J07IWbXJM2M5KPu
         Ikcw==
X-Forwarded-Encrypted: i=1; AJvYcCVPBZYEBp3+z/ZOexih+Lt2YffEoHaaNdqQ6I2T5C2AcHqReY3VuCAYUSTM3CTbpGVxYnn7/PQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIA0ZWWxw3Nu5HtNm7hFEnO4sD9kVaZZ+OEDCqGM4M8+P0MCXL
	YzIr7YDXD8q1serEX/5qBRRKNP1vNehnXy10sP5nZvgjazeWIr5+xaazd6RATeICGbBbkPKZ/sp
	utA==
X-Google-Smtp-Source: AGHT+IFqzRS1xOg2oJDncuDOdOtR7gITdwbfvBFuJ4xWEWgDQEplutdiZUKmbH0mIVak18Oaak6LM032atM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:b205:0:b0:e25:17cb:352e with SMTP id
 3f1490d57ef6-e28fe43f3f5mr4095276.9.1728584753336; Thu, 10 Oct 2024 11:25:53
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:31 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-30-seanjc@google.com>
Subject: [PATCH v13 29/85] KVM: pfncache: Precisely track refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Track refcounted struct page memory using kvm_follow_pfn.refcounted_page
instead of relying on kvm_release_pfn_clean() to correctly detect that the
pfn is associated with a struct page.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 067daf9ad6ef..728d2c1b488a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -159,11 +159,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_c=
ache *gpc)
 	kvm_pfn_t new_pfn =3D KVM_PFN_ERR_FAULT;
 	void *new_khva =3D NULL;
 	unsigned long mmu_seq;
+	struct page *page;
+
 	struct kvm_follow_pfn kfp =3D {
 		.slot =3D gpc->memslot,
 		.gfn =3D gpa_to_gfn(gpc->gpa),
 		.flags =3D FOLL_WRITE,
 		.hva =3D gpc->uhva,
+		.refcounted_page =3D &page,
 	};
=20
 	lockdep_assert_held(&gpc->refresh_lock);
@@ -198,7 +201,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cac=
he *gpc)
 			if (new_khva !=3D old_khva)
 				gpc_unmap(new_pfn, new_khva);
=20
-			kvm_release_pfn_clean(new_pfn);
+			kvm_release_page_unused(page);
=20
 			cond_resched();
 		}
@@ -218,7 +221,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cac=
he *gpc)
 			new_khva =3D gpc_map(new_pfn);
=20
 		if (!new_khva) {
-			kvm_release_pfn_clean(new_pfn);
+			kvm_release_page_unused(page);
 			goto out_error;
 		}
=20
@@ -236,11 +239,11 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_c=
ache *gpc)
 	gpc->khva =3D new_khva + offset_in_page(gpc->uhva);
=20
 	/*
-	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
+	 * Put the reference to the _new_ page.  The page is now tracked by the
 	 * cache and can be safely migrated, swapped, etc... as the cache will
 	 * invalidate any mappings in response to relevant mmu_notifier events.
 	 */
-	kvm_release_pfn_clean(new_pfn);
+	kvm_release_page_clean(page);
=20
 	return 0;
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

