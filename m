Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1E0EAED
	for <kvmarm@lists.linux.dev>; Sat,  3 Feb 2024 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918974; cv=none; b=fZERaWS0ZV1DYnGSk1K3bWMB+gVuMF1PKPZne/Vqt0mgj63UwmmLFVkrSKwUoHUFBRmw4WhIJaMbtUV4va2E3lkgrv48hQocCPjmM1rip/OOIBMuunLFtbXCAEIi7LGQ0mfe8ExdFS0i9U8ntHOqN958y69MIyXsN+zAKnFY5Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918974; c=relaxed/simple;
	bh=D8mb0FRK9gpBnBRXkQEG+PB9Dag5X8x5Fbzx9RXG+Rg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SRk4pbz6DUHQ9B1mb7MntX64PU/+Wn6852aQ8zPT9iH191/hgaX9chfJ4eY2cLLCGmwczPU0BwbLxf9elKuGApHoWIPgBde9kSmnuH4A9o72ta9321HpzcPpZ/1uzm2wraG0dQZnjSEdzkHpsRWQi2gsD71kCqDx5u17bX/ot1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sDXY4u8W; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sDXY4u8W"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d98231a1f7so7326235ad.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 16:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918973; x=1707523773; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uGdQAEk26j5OxpYXu3PaMK7EeL8Au0IOP5m2/Y3bZT0=;
        b=sDXY4u8WEE6lEmQCEpRzM1eB0tgN2Vzqod3vPPGhdyL2qFSGNyPUwOuk6brNhvMYTv
         JkrS8ROvNrYZ10CrEtm43a761XZ78JlM6AJYbBKlOJBOM3uxp7iOoRkZ9pCMTtegECID
         /ZZMG6NFo9opyc3AV+DXx1GFqBa+48NxSwJcG25yBlmpHWnEkya35mxZS4cGRkNPx6Wn
         9lZW5lz8Zu9Nj4gSVPp8CDeYgCedWiiq2wqCixFOGKNPl6gqEFCMvJ0lYCivCCQjT87q
         2FxAAUnf4XB1NIfVLn9ZOye+FGYmMnwHLZO/wR2K5ezYiFUkC9rpMJMM4nuoCi79J6is
         89QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918973; x=1707523773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uGdQAEk26j5OxpYXu3PaMK7EeL8Au0IOP5m2/Y3bZT0=;
        b=DNtN/AKdD7v8qkP7AR57YwEoDI2Bvwypw3jWLGdmgqxux0SU12xVVKMNbAS2uwmQbC
         y8sy/nF2qwmD9UxGK0KGdk1q5cVgL19Bz7B99zEnvqELf/UpO+CkkPEv1O4Nh68vHt/3
         yrSlb3K1Fohmbr9obhftq2g8LM9UnIRvixLqDKIiZgM2NXueEuT/G1Sp29CWFsaNUkur
         2pw9dGyxZKnzJBo+hFYnTjqSR0YWcgWrJcReWmv13MPVszaFwLrKnYmDwT01ACT6rfvd
         jo29R0Tseido7lEhZQRK8WD5WVYbRqT0g2IQE5snIPT3bQzenGBhJrF4hBBErTNMTpCA
         XzZA==
X-Gm-Message-State: AOJu0Yx1TGG/IzI3v87/8umC/E3srT4yzbtTU3sUMDCCdqswBuHOUKlq
	Oypop8YpYGF8+kstzkyeOatWz9iOSGoKSe9c9F7mKnqzyJoW6ClZYQuArpRmuvarLzkP8z6ASoF
	O5A==
X-Google-Smtp-Source: AGHT+IFjC15kDw5iExzgefryGqdvDfKmWm4cQaCALbm/PwXRZkCDFthW43qe2jb3I/GBr57667GkOb1b5Sk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e80c:b0:1d9:855b:629f with SMTP id
 u12-20020a170902e80c00b001d9855b629fmr3990plg.11.1706918972726; Fri, 02 Feb
 2024 16:09:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:12 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-7-seanjc@google.com>
Subject: [PATCH v8 06/10] KVM: selftests: Explicitly ucall pool from shared memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Allocate the common ucall pool using vm_vaddr_alloc_shared() so that the
ucall structures will be placed in shared (unencrypted) memory for VMs
with support for protected (encrypted) memory, e.g. x86's SEV.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 816a3fa109bf..f5af65a41c29 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -29,7 +29,8 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = __vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR, MEM_REGION_DATA);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
+				      MEM_REGION_DATA);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.43.0.594.gd9cf4e227d-goog

