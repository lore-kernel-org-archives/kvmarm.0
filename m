Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC45156230
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037971; cv=none; b=YHogEMs7q6HjwJuWLRAInGo41JZ9+kv5QkGfPRKGMw2AjFxYwfEuADOlxOaV3aMIDCzWgpTdhhe1/2H+TwFV3QJJa1T6k7y9MwZXISr10wL87Qf6fnk7sqQISAX6N4AvYqnqaMYGMSKLFyljpfd702Sa8zhY3yfEsYj8DRFpJIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037971; c=relaxed/simple;
	bh=o0JBLF6HQjluB3iIirHhfso1PE7Zf/Ht0oB2KRN4Rqk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ip2AhWifjsNqABzKNabkiNRILui063f5qfGFSGV2Y67SW6OWjvKIYw5bt8ejNT+g8RMkePrxmoI/OuuTNicD71h2yZ5sGpNThg9k0v4F1OsPfK1XRZMqz5SS2P5UPi83mmPWHz/iL25kKjARQuSnJcXz7HvQbS0glwhCYBZdIHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z65s61vJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z65s61vJ"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d14709555so1472814b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037968; x=1722642768; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1PAT6v4tn5ltatT/kjen/UunIT1fRhHnj971W9WBYQU=;
        b=Z65s61vJ0G6iPLo8B4wgMvYgspN4WetZvJrFZTXnj3B9uXnyEBUoSNdCf5F0CcPpSW
         xB+vHmU51KSE7WjU/QT/la7xOhDRzCOVKgX8v7a4xDYZ7l1l4OPccDhH8+D/n2ghFuTl
         nQYbdfyzU94LydsZzJAKofL8Ols5Iue9l009z4uvtwsyaFOaN/VV2/AUaK6DxyboUJ4V
         JpnZBKIpmps2DR2p08CkOkm7W5WrynljpZtnsAIa7YgZD2UiTAD1KMPMhBrJCPJLUBdm
         PEY0Y6kFGEVkldgGzgGYgnIKcDwtie4+TK+nIPmjFVxEn92RSnEDfvKxxksF1WZPMLd7
         VdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037968; x=1722642768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1PAT6v4tn5ltatT/kjen/UunIT1fRhHnj971W9WBYQU=;
        b=rMppow8mV4thu/8vP1i7e36K6xm82jqwlFHbat+BN5LbVu0F5TFB4oTeWau/VW5DCI
         Op5Xq81pQYpYW87d0q38wXmySuxUzYpVLVaofgZuyWr1Upz5uw/or7eZK2JPpYCWYa2t
         EvVBNhDSzYaA46PttPv56M1m3Wdxr4ycE9Wicu7dvW9tWYsQ/nS6ClVo75Ywp6jlL2ul
         sxMkl12D5l40VTS7dCDC1dpU3fIWndFukN/HyKhtvbfHKGcnhVuXW7akJGbhxOrMN2Kv
         FB157o03pum8AMKudLxKBBzSynNxhEOfOE6yEK9b5Z/Ml/mt5yqDNGDjlZeicODJ4/wG
         JGiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg6H/riFmNPCzDAEeq23lPnUhvEXOfM2C5ytZHKbx3n35G+1b+4tOi8AtV2NTM+gqqBfg3zSmA/QmxXYPvOPtN8lg/U64Z
X-Gm-Message-State: AOJu0YzlA1rKP4rzXxSOrLKJwnprPiaYQz0bc2mVieU/uPIfpi8LjF9+
	BomDh9EJZy/G4K6dfg1S7kaLVNuILtsJZ9CRNfspJkE83CiIlboD8ec1kt0IZ6AsWEQySxWNSIf
	VKg==
X-Google-Smtp-Source: AGHT+IGybwcUaaDWGaRnVlNYMzL2lybkBwi+pdiFBv1toqDzA479d7SifMoC4AbRMiwOqaRTolCzzwjRN5U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:731c:b0:70d:13c2:1d08 with SMTP id
 d2e1a72fcca58-70ecedb0dfamr2514b3a.3.1722037967857; Fri, 26 Jul 2024 16:52:47
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:14 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-6-seanjc@google.com>
Subject: [PATCH v12 05/84] KVM: Add kvm_release_page_unused() API to put pages
 that KVM never consumes
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

Add an API to release an unused page, i.e. to put a page without marking
it accessed or dirty.  The API will be used when KVM faults-in a page but
bails before installing the guest mapping (and other similar flows).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3d9617d1de41..c5d39a337aa3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1201,6 +1201,15 @@ unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 				      bool *writable);
+
+static inline void kvm_release_page_unused(struct page *page)
+{
+	if (!page)
+		return;
+
+	put_page(page);
+}
+
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

