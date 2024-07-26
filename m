Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9E517E447
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038018; cv=none; b=qYfDChjHWxIGIDj1x7GOgetjjtmZyAnOJ5wXAZQ8ULOpilY8VobttcFrBeqI/1Sc6oOvLyfO1qoc8bRgSRqanm5sZ47p+gSh+UsXDVhhgPg6+qEPTtQgpSPOaETA54imMd3ruI5gjuutdLEzwZz/Dcw9/CxuAMoXS3RCHcbV9AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038018; c=relaxed/simple;
	bh=ky85fUImU01pEWQgS+oW28QcwsVXcoLV2IyUFHjUgXc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=evEQ0ousZgNgPf/dG+NdPiMu+Vi+Q9+BBvffgOrLKnY6BSMbEBnYrZdxBuwhVd2wU2rLdvQwWZe/oVbCYSirD5Th5dm95RJH2HwRgEAv7LXnZHgJTkqiAp/51XpREFAaK/ZGhhvsyx2/D2TBlkBNrM9zrVm8aH18w2GcPtFIwrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QhX7fVtI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QhX7fVtI"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fee7c9e4a4so10495555ad.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038016; x=1722642816; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cQ8Ke99Gz78IcD45RWrPNlFRmlyo3xxXp4XhOasYhk0=;
        b=QhX7fVtIoO5XDjox5ae0C57EPnPJ5+zLmbutDGBKkT2XxbdzXv2BKnsMlTgvxhJ64w
         UCiraCPG0HyAQpCF5tgZwRvlzaEOI/Rtk6/6NzyMsK/+STbwCX1eKzeYsFdDWQxGb06c
         u0LgMcbzEppfrkNPOqAUQoNIBO1ZMw0D427k/Q5A/1O3Fvi14sTLRA+ht/eWZ8u7txzq
         y3MPm0J9WHUM3g0yIisoAoX7YUHMnvrHpBpFouR5/eig6cWjDMWRCQA1NKbDehoCzbKZ
         PYBBU8lytt8OEU7zT/ILHWIFJQvzbarcABFm3mK6MM18+N82A0Ti6FSh3v9GM8t75xmd
         ZGWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038016; x=1722642816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cQ8Ke99Gz78IcD45RWrPNlFRmlyo3xxXp4XhOasYhk0=;
        b=Lsb86YU9CBwcwcZTLH5lFTfgivEBc6YmP6pMTsOW9tOE4NyuCieSJ1JI3Nw1fPS5dQ
         prOArw0HIMmnOKhWUswBX1n3SoRedO2IPr6ybyJorHEi9uig87B/6i53bluTzOPP52UN
         zIXKrYVK+CYugapLJxAjG3JNWTuUx4zmUJh9Bc8gKJWa7+HVMdf1COing3pMHOnhuKkf
         LicdUQPiMpjq62jdX34+s/niHMavK5WWt81A0VAe7I1M86SDRXiFHpJk7JF9XnxINqXy
         e/phppc283iK4bcyPXfT4AicXBJhcPwgEIETNdVBYW4DY/m9kN0k51hV89syvvvGc6Qn
         qisg==
X-Forwarded-Encrypted: i=1; AJvYcCVlh1Fw8p+A6/lFj88uH7d0TtyRyj8efmXjXrlvgae/AbUtA9QaWU9zzi1kghsAkSndfQ+umkJqkzBbh1X/a/O5VAfbIT5R
X-Gm-Message-State: AOJu0YyVendpQLLpfNAnqEHOVIU90gP2HQnpmSjpXpyPfTwTxgw+Fp+N
	p94E/HRBXCb4zY2ceg2hcn8YN9ymJTltpJeBc4tenSYAUKp0qHMQnMcQ32w1DHt6PhKf/+gF1PN
	ddg==
X-Google-Smtp-Source: AGHT+IEYmoKPicLFNTjAfXc3rW7QIOSCWQtpI+t2ZFjfSCVkTMXBL3j4sNtxlzg5xGSYJWPU8sNID0rjz8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d481:b0:1fb:5f82:6a61 with SMTP id
 d9443c01a7336-1ff047b8ea6mr1156745ad.5.1722038015496; Fri, 26 Jul 2024
 16:53:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:37 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-29-seanjc@google.com>
Subject: [PATCH v12 28/84] KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
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

From: David Stevens <stevensd@chromium.org>

Migrate kvm_vcpu_map() to kvm_follow_pfn(), and have it track whether or
not the map holds a refcounted struct page.  Precisely tracking struct
page references will eventually allow removing kvm_pfn_to_refcounted_page()
and its various wrappers.

Signed-off-by: David Stevens <stevensd@chromium.org>
[sean: use a pointer instead of a boolean]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a5dcb72bab00..8b5ac3305b05 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -280,6 +280,7 @@ struct kvm_host_map {
 	 * can be used as guest memory but they are not managed by host
 	 * kernel).
 	 */
+	struct page *refcounted_page;
 	struct page *page;
 	void *hva;
 	kvm_pfn_t pfn;
@@ -1223,7 +1224,6 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 48b626f1b5f3..255cbed83b40 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3113,21 +3113,21 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
-{
-	if (dirty)
-		kvm_release_pfn_dirty(pfn);
-	else
-		kvm_release_pfn_clean(pfn);
-}
-
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
+	struct kvm_follow_pfn kfp = {
+		.slot = gfn_to_memslot(vcpu->kvm, gfn),
+		.gfn = gfn,
+		.flags = FOLL_WRITE,
+		.refcounted_page = &map->refcounted_page,
+	};
+
+	map->refcounted_page = NULL;
 	map->page = NULL;
 	map->hva = NULL;
 	map->gfn = gfn;
 
-	map->pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	map->pfn = kvm_follow_pfn(&kfp);
 	if (is_error_noslot_pfn(map->pfn))
 		return -EINVAL;
 
@@ -3159,10 +3159,16 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 	if (dirty)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
 
-	kvm_release_pfn(map->pfn, dirty);
+	if (map->refcounted_page) {
+		if (dirty)
+			kvm_release_page_dirty(map->refcounted_page);
+		else
+			kvm_release_page_clean(map->refcounted_page);
+	}
 
 	map->hva = NULL;
 	map->page = NULL;
+	map->refcounted_page = NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

