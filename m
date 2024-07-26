Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFCA16DECF
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037997; cv=none; b=ey75+A29WDOshu3XCyh9dxszHJxLKCYNSnHCySZXP6+hTjLLpu1+wExMFVH0zii2IthbPSiXFod4MmxVh4E12x/l6wtzs63UfkGlOMWbPVIFJL8uRAhfxzFXPidWYtoXwT6/JYRNKlpANiE9QsGwMq+W+s1/Lf1zWEpqFH8s9oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037997; c=relaxed/simple;
	bh=ew26wDO2OFK9/ZL4S01JfkaAnmh//qDEW5lL4oKuI6U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NrsA0IkcNZma8WUL7GhofseUvYcC6X8R79LIFlXN+x7WHVmXU/cfcRCX+FoZ+06jOSP5ZimpdDNFvf3MRo4vh0yV4MKmjHs0YYY9kLZ8TT7Hyuciyt8hXbhNwk43Jet8Rv8xxv4Njf3PAfr1at/RSdn0bjhuenG6uJgpdJwZbe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LTTFbngX; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LTTFbngX"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc5e61f0bbso13358405ad.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037994; x=1722642794; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YtgPpIjPSqL3TzmlwlpLZvvahtPd8ef2dtbW1LnZzVw=;
        b=LTTFbngXnIq0Kz2rozRIlcTmpCRpRrG8iw708c5RpTI2wOj8Gye3Hbg2tJHpFEYRK1
         3NqKTWGkt5WChr5Jj7d2UdQayBM1yXp6+OqohR0/ltBrSGOvZLdieNXM1/EKKsd7hgs3
         CRKCUGyLCTX8dZ7xkbQ7vg9zHzSsdV5DuhmeXw3i+c4JM/ptNaoFMTRk40BTWUoBBkeo
         OHEwmCUVrKT6me8ELI+Y4vY58B77UcmrOXiesgJMQDxA1YWXDrdzMfGosc+W50Whib0D
         A7Njrzo0MQqEfY5jy5F3R4lsqnsoqli38+YmxxjpPQX8YmyEKl2NR/MLWxGJLYnGZUka
         tU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037994; x=1722642794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YtgPpIjPSqL3TzmlwlpLZvvahtPd8ef2dtbW1LnZzVw=;
        b=e2s5xUpet65blJ+KGKrRNz1JGvHSh4XlUGY7k+kDIlG4ARvWWxBD/kLW1N5zYVP0lo
         rioCwANh+UdmrpH4fdLpvl8S1Ud6lU8m46OeO81an2YVXx8UXwSjkNsYfYxyDy9tcKfE
         C++vayQReYdcCMn1zNVXxEfs6OD6x4DHvsFatNVu+O161QyC/QyCGs9I5os62bhyq8AR
         PVMVWUijV0+y1NbFe+nKjkuU8JcszMIw1/tRFHwTOBKj4W/qd9PIJmr74hMQMWtMHVkQ
         r2OLWxj3dQDXhEWOi2ICGbogRQOCzU8Nz8h3kh9D40oVkno9+9uFdzJA2+EOyUKrmdEU
         5HRg==
X-Forwarded-Encrypted: i=1; AJvYcCUZPuCYB3Kwil5zPuh+NbEjxdNvvrwDpI2mqKhbrvxAL+fkdNKuTcU+UuOXVqwkK13mUo/7OFhfutl334VlH51EXQSMXZG9
X-Gm-Message-State: AOJu0YzcfHNxqxn0SBFIe/nABoERQmLx12OZNSwrA8ju1LX9sYixigQS
	sJK4W36vGojwVRmkR8biI60eKWBb3QQH5QeiXPvsVz+mLIfsCwRpBK8LoGH/oPgKrkjK4hsqI4M
	gtg==
X-Google-Smtp-Source: AGHT+IHmoajaYWuB/CstqlwF+EMvaWyxqBn3H/lV1e3JQu2uS0IU9winjnCx9o/cN/zsyEDP3UE3pPbYXjw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e744:b0:1fe:d72d:13bc with SMTP id
 d9443c01a7336-1ff04822069mr906395ad.5.1722037993928; Fri, 26 Jul 2024
 16:53:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:27 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-19-seanjc@google.com>
Subject: [PATCH v12 18/84] KVM: Remove pointless sanity check on @map param to kvm_vcpu_(un)map()
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

Drop kvm_vcpu_{,un}map()'s useless checks on @map being non-NULL.  The map
is 100% kernel controlled, any caller that passes a NULL pointer is broken
and needs to be fixed, i.e. a crash due to a NULL pointer dereference is
desirable (though obviously not as desirable as not having a bug in the
first place).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 56c2d11761e0..21ff0f4fa02c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3092,9 +3092,6 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 	void *hva = NULL;
 	struct page *page = KVM_UNMAPPED_PAGE;
 
-	if (!map)
-		return -EINVAL;
-
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
@@ -3122,9 +3119,6 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_map);
 
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 {
-	if (!map)
-		return;
-
 	if (!map->hva)
 		return;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

