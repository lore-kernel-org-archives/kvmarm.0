Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239FE172BC4
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038000; cv=none; b=nh+Pf0aCB7ttbNK4kPds63ZGeWae63ZDMpFZLLvb+heONik+3JcBFCod4jU5sk8zCbZ46y4m3F89j2Vc9xxyH3geVuTMd9RNWJrodfrldm5t1hgxW5WqcrkmY4sJkXeyNf4tgdUyvHeUFHlcnBRvJXspGs3T86qGy1saT3w/NYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038000; c=relaxed/simple;
	bh=QpaOetglmizJZZ+b98sQ2qGQfzOr00nbj07HtFuO9j4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g35Ef+iKoZ0MKThiERE2bZBVAeKlcoV+Ji9VmTRcNFNdX0feFzbmxDHHWkBo95t+0aR9irD2VGeeo/gLTIiB5f4YwAEhD+FizA8B9k85VKRjSSi9V54J1Xq1oGVjKsFMWL7d/iU0kjy3BxJBinSMvZZgARLZEryMleTt5060cZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HGGBCfdR; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HGGBCfdR"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-654d96c2bb5so6795497b3.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037998; x=1722642798; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=F7WgJlT5NNtid7p2jwFbPV8b+lTnD+3vJbPsQDaWDdo=;
        b=HGGBCfdROAg94oG1AI9n2+hJ2UoGCBRfIm6HxylohfvBxpMzbqPolgORO/DLPYfzjo
         dbC5zvPyTxtqGgFFaalibYGUaafXYxcrpLv59HxDXjnjI0yzXWHvWubam5uAXlvcHx1s
         1KATzZGHraqBYVHvcjwT98zdpzWEf8oRDuxRdcH5208DlmJyUKD2oJOKPDxekRNPSuLL
         CAydvwryOSZBxZQWzA9Zwg/XdU0qJWjgljSDate+LxVlin/O7sOAwv9LsD03gOyynybG
         UcXB+weMvkqfb+zOvZnubmRrkd4vt2MopJFD7qJbSl3zK8oOHqhF2qGIazU0Nt4fYGjo
         VYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037998; x=1722642798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F7WgJlT5NNtid7p2jwFbPV8b+lTnD+3vJbPsQDaWDdo=;
        b=Wiq+A0takxNx/nqtesTinR6+ximCVPFX2YrJmDTeZJcrFhNtBEUncWISO8N3NerajS
         THYPGTgTYETi8AyW3dfK+sBeVFEeCwzLTdoTyjTLc9GXmyByNwARazUlQtZ6YKO+QJia
         2LXrZxpgRVF1LKN2ucR5dczLWVFWXXIwTUkyhbWWJKrIBAxKSPvgqb7scF6oX5df58GS
         rZ5kRp1glQC4ivooXvszqF0F0y4w4aW7GbL6qXR5U2N92EyCAlu6gu56Wo9ZQU8lrp1w
         uD2w6X+uqZXYoQYF0Fjw8lYZrzjNkHc49pxijkAU6ykTnMNdwSHlXjx5gDEK8uOvE2+k
         O6vA==
X-Forwarded-Encrypted: i=1; AJvYcCVbZgEbJWkcB8J8CWOEgsGM5rm2U1Snn62ffxuQWow6VKXWeH1/AY4w+gHHD0BMPLnUO2O7RJUfV9xNJlcQsipPS2vSGylD
X-Gm-Message-State: AOJu0YyVmEBo9xm1PXgvJcpHQTLmIVhPjHINfBiowUsBTP+wqnTQZfcD
	3lbDn4eTT8APXWjaneS98p2LlKbgVqeDJtEL4vD0eKQ3+uIJ/tXQBZgV5efC36VucUQzssgIHRV
	Oig==
X-Google-Smtp-Source: AGHT+IHz6CGF/LJ/2Irg7XXoFs/UlO9MjKavvm7YGPRddocT798mRWwGF7hDBEuQel+TJyAfnYN45In/DfE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120b:b0:e0b:4dd5:397e with SMTP id
 3f1490d57ef6-e0b5455c058mr1734276.7.1722037998118; Fri, 26 Jul 2024 16:53:18
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:29 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-21-seanjc@google.com>
Subject: [PATCH v12 20/84] KVM: Use NULL for struct page pointer to indicate
 mremapped memory
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

Drop yet another unnecessary magic page value from KVM, as there's zero
reason to use a poisoned pointer to indicate "no page".  If KVM uses a
NULL page pointer, the kernel will explode just as quickly as if KVM uses
a poisoned pointer.  Never mind the fact that such usage would be a
blatant and egregious KVM bug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 4 ----
 virt/kvm/kvm_main.c      | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f42e030f69a4..a5dcb72bab00 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -273,16 +273,12 @@ enum {
 	READING_SHADOW_PAGE_TABLES,
 };
 
-#define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
-
 struct kvm_host_map {
 	/*
 	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
 	 * a 'struct page' for it. When using mem= kernel parameter some memory
 	 * can be used as guest memory but they are not managed by host
 	 * kernel).
-	 * If 'pfn' is not managed by the host kernel, this field is
-	 * initialized to KVM_UNMAPPED_PAGE.
 	 */
 	struct page *page;
 	void *hva;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67a50b87bb87..3d717a131906 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3088,7 +3088,7 @@ void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
 
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
-	map->page = KVM_UNMAPPED_PAGE;
+	map->page = NULL;
 	map->hva = NULL;
 	map->gfn = gfn;
 
@@ -3114,7 +3114,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 	if (!map->hva)
 		return;
 
-	if (map->page != KVM_UNMAPPED_PAGE)
+	if (map->page)
 		kunmap(map->page);
 #ifdef CONFIG_HAS_IOMEM
 	else
-- 
2.46.0.rc1.232.g9752f9e123-goog

