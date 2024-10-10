Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C471F7060
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584737; cv=none; b=GM/0nI/XavX0jQ2yqXnsNAe3tZNjW4FLgWQtRpHFJ8Awbq4zOcayp0FMzzqZndPtbWJeKPGPnNYjUYjXGQ301klG08JoaY822crzP3jaXYrtFh2822mlzNUSiAgcPYNCWL6dJ8NP9Qs3AVFYFC/JGfniko0b62Ce1Vk0BaiJwkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584737; c=relaxed/simple;
	bh=KvCWyyHWjrlulYIoOxtt/Dqt8bcDl+mOtHXiCiz5pRo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oyzqa8IVmkttopyw/qz7u07fCv6L+ayZuUcDRj3nhftXph6440cZbImweBtRSq1GxcC0RcldlQLs+ujlzZNG1/KtcHcLLwfikFuFRlGB87Rb2mST0D54iWjPszjb4Ss3KZnqyZZsu3PEeAeiNRANKYh/vYHPGmrNsDIX6hPIAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d+GXRwz7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d+GXRwz7"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e28d7928d8so1637417a91.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584735; x=1729189535; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LNPEWcjaz+dEwpcBQF1ZcKP3HAxUc/LzxURpjzN7wyY=;
        b=d+GXRwz7Co2WRnrKVYU20S3azm6+oiK+kDYw7NQbDHfXgsqO2jn9Xo7U/T3WsKMY7H
         YJjDiKsGc1fLAYHYT5/gv255byqUe/2fvqcaaPomuizPoCtdfpy3a7zXnGhr72sxUDPc
         0hqcQJulC/Z760XvYHUk+qWKPiJRudd+XcNTlmb2qSoCrO8LrgooiWHWlzMz0LH0ABFJ
         jS9M9ieil3zGvWXVcPOsw94ZSiVqlDYNlsarINN1gSYnjOrAZ6Qk9Y8a4wTczE4tv4M9
         rEEOIEM5Lr4smWaaSH+VeIV0sSX+Mk+DbeOr7faBMU3aLlF6DWv4Bn5U2VnYkGk8/wG+
         ywfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584735; x=1729189535;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LNPEWcjaz+dEwpcBQF1ZcKP3HAxUc/LzxURpjzN7wyY=;
        b=oz2RYOOOYAb5gpJc4p302EUeAUriOE+UXRVpYzharofAI/A85/V4hQl265TYVlwK+u
         6A3y9wO8G/yr7TLSy/Sm22EWEJMmYgGjk8q2HcQZPg601MPJhVI9r6YnkrrqJsGWX5pw
         mK9tOvtCJAlBLp8d9Z9WBGDU0Jy/V6v6/XOn+jELrZYcADLd9EgKAA3JdDoWWgN3R8P6
         zx4bAVDYEJSbkcbs7EKucT58mGL8TStDwHR4KvZrGHmE2UJHgCIhX+qFnFuObjU3OzRh
         jPxCvX/L1Nwr67SD5DNUO6MFyprSjRWoyLxFB1Rj29LCuBlojSmSY65dq668It1QTWOh
         wfsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU35ODEL4bO0pa+cSmEOnjp5L2Lvz2na84gOUDvVgQsYotrTeA3aAhhhzpc1XwkUFO+jTOxDdY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRcH4NRwGbjCcD4eEmGSkYiyzWLHckylqF67knTIeIAUXpROK5
	DVnrJn731mg8zbO3OuBQUwi8aOG9vUVBOBbZEA1pvZIyjrLDeUWFia6I8U58mb+NmgMdlGobcav
	WdQ==
X-Google-Smtp-Source: AGHT+IEnZEGZphhdHlQgb0iOcJfNRdGKMtxwSRuFd5MkDGpZIOhDcg8ohYIeF4ySSwO5bqKUu8yK4lYjZ+4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8595:b0:2e2:d600:3862 with SMTP id
 98e67ed59e1d1-2e2f0d9dbfemr89a91.8.1728584735013; Thu, 10 Oct 2024 11:25:35
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:22 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-21-seanjc@google.com>
Subject: [PATCH v13 20/85] KVM: Remove pointless sanity check on @map param to kvm_vcpu_(un)map()
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

Drop kvm_vcpu_{,un}map()'s useless checks on @map being non-NULL.  The map
is 100% kernel controlled, any caller that passes a NULL pointer is broken
and needs to be fixed, i.e. a crash due to a NULL pointer dereference is
desirable (though obviously not as desirable as not having a bug in the
first place).

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 52629ac26119..c7691bc40389 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3071,9 +3071,6 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, st=
ruct kvm_host_map *map)
 	void *hva =3D NULL;
 	struct page *page =3D KVM_UNMAPPED_PAGE;
=20
-	if (!map)
-		return -EINVAL;
-
 	pfn =3D gfn_to_pfn(vcpu->kvm, gfn);
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
@@ -3101,9 +3098,6 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_map);
=20
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool =
dirty)
 {
-	if (!map)
-		return;
-
 	if (!map->hva)
 		return;
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

