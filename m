Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8963C191491
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038125; cv=none; b=f6UNSUftQWtaAgoPk+YOgtXAtPmj3FIACLeBewRRqbaaSQyXfk1jXu1wRPPnrfErM+g72rZKG6jicLms/TEWXcbg7BaZ4Ac6ov467vldrZebg626sL+UgTOo/cev73ZDmWLDxuQXE97ytY82VmpiOdnrKpVRuuf0Pe7xMwoHRcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038125; c=relaxed/simple;
	bh=rI1deqx8R2FAT3yDZksFCzznTBxsLeNOCK4lgbhIK5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JobpXpu1jMCoFCNUGfAVGz01Cn31Czy/Xxhq3KAidkp6SVIZVwcOwd76MTIGRypWj0/LgzbSZIwAN/mYWDL93YqiVqYT9kG8ID+RgrF44+o4fenhitdIqmlj8Xrf/Uv6h2da7UYfFnLfYbhBQDlK5Ly6ID2V5nLz7MZyaR1Ub3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=23IaIzGC; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="23IaIzGC"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd8a1a75e7so9884355ad.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038124; x=1722642924; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4JkhtJX/rWB1cBzt9zuFqY6FqfPwx7EIf6/sG5QRcB4=;
        b=23IaIzGCDmNQBqQbx9z65L/HDe8h3AYpqOnfCg+gGNz17C2AgSeOWEC3qwFT1hiSF5
         VmNJCyWJmIrHs6WywotBaNtqllvly8JTGBSMqQo+6/9c6Mkg858n6/aSQ+97JnjwaaQu
         jX3Sosrr+znQ7SqcsubfjIUNWK51BTECi+scgpuiT1Cr3+auokR7vvodKFJZ0fQ9MaFs
         v4eh0zV+vyM+Ncg9AL0j8orrGHGGSe0CK88FedhIXpg9GF5cGWp7UAwqRq7zZsFh/IHf
         Ez+VIbmJ2mC4n6vaW4D0RVrbwKiEQngqS56eNEapPnNbq8JgommPMG6hk4mg0oP7EP+R
         zoFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038124; x=1722642924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4JkhtJX/rWB1cBzt9zuFqY6FqfPwx7EIf6/sG5QRcB4=;
        b=M2hiikXsWDG/m9NS0qgIN8iXMX2YXCekvvVuFKL4dA3WYF938+fmUMOo360uPeBEc5
         NjDoFeYG8FbOUMPGew9Md70dlnCzB8zDhoTX8Pd3wamgRdMPwyc6SkoFvfptrAej16Ms
         8R4E86KGGAduOnNUWe5N8rkKwaoDbXQmI9vQvpALQQ41r3U2ANgOGAMAjS+thiZbUI+t
         Ucb7iTOduehpRWlJXi778ZwhBcihQOCJRQ53lnUFsgMxUUDZYBjVOOJ5uKP3+G1kIc8c
         tahFxppRipRmfaFUuWXk3GSgBTMuiYOITvxvyhEgKwuz7MMKwsW3a/9c+hDVqTEEinUv
         0kUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUFALtqgnMQcr0g/DJGlgi6GwyM2A6w97Y5PgUgfYKjxdNFlbD8vkNnT5Zw9ixLzvZ4hAEcAArfX8kBy23Mk0VD/7Y2Qko
X-Gm-Message-State: AOJu0YzZPrcV1bWpgb/PfBXUr/yguqTLy/6+DVr6HHU/usbIixOQMypc
	uLOUV8OIaBqbmq52f24UeytImF8JbX2lfVo+CoWdebO/yxunVBlOwLmDmPgriCfH9S/QfjRP84V
	A7A==
X-Google-Smtp-Source: AGHT+IFPQa1UjlYj7+Kv/jUhsXC3P8YtU5HtBxuA0lRTgUmwYvAf/3a7bhqWFsOX8QFlAkrWz2XoripRfzc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea03:b0:1fb:7f2c:5652 with SMTP id
 d9443c01a7336-1ff04893401mr182655ad.7.1722038123783; Fri, 26 Jul 2024
 16:55:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:29 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-81-seanjc@google.com>
Subject: [PATCH v12 80/84] KVM: Make kvm_follow_pfn.refcounted_page a required field
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
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Now that the legacy gfn_to_pfn() APIs are gone, and all callers of
hva_to_pfn() pass in a refcounted_page pointer, make it a required field
to ensure all future usage in KVM plays nice.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5dcf3561b829..030a08d4b21d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2844,8 +2844,7 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *page,
 		pfn = page_to_pfn(page);
 	}
 
-	if (kfp->refcounted_page)
-		*kfp->refcounted_page = page;
+	*kfp->refcounted_page = page;
 
 	return pfn;
 }
@@ -3001,6 +3000,9 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp)
 
 	might_sleep();
 
+	if (WARN_ON_ONCE(!kfp->refcounted_page))
+		return KVM_PFN_ERR_FAULT;
+
 	if (hva_to_pfn_fast(kfp, &pfn))
 		return pfn;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

