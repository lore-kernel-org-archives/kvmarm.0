Received: from mail-lf1-f73.google.com (mail-lf1-f73.google.com [209.85.167.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0E0313294
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 08:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946950; cv=none; b=AsoUi/v1LZc0eQcuJEEfuTlX3oeoDKwE4MGOiYD30ntvp0We1QgpiYurHR0aQVEpIkC+brvvDVn5d//r4M7oFktNpu+pUFVZaUpMl2bimJJtnsAQoFENmRp8gmbciZvvfiJhVyFv1ohvJvN98DVMvBsX4wyt/nczG2fcn1irhbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946950; c=relaxed/simple;
	bh=lFYklkr6Riz3yTMFrVODIzDh0TCEJHS01mgdHAqzi7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CLuM+1CP8o6steov2PtO571iXtKGnneEUJNJzqBaUBFGmJN3kquxlPYvWckyi+tnYu7kmEAeWdfy7v7gknp4+8z8fXctKoDNXmOLFRZvRq6u8fS7XyoHS+uU4X2SKsKsI4wyi8YjCxUPqb8lUtWFxQfWNSLvoi7QlgvWmVWwcnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PaTR0BNh; arc=none smtp.client-ip=209.85.167.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PaTR0BNh"
Received: by mail-lf1-f73.google.com with SMTP id 2adb3069b0e04-59b796a0e40so1232358e87.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 00:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946942; x=1768551742; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NqG3laPI6vEHEXOM9R+vgmhZHRmAA+/4qmyfh5dJ4MI=;
        b=PaTR0BNhmxGFGXNSfX02x76c9WZQaNUNna66udW8mihh9sfYBPBnzK5yaz8MTx9DPH
         IHjMjjzszKPnU/NjmoNImCXhM6YAruTfeZiHqMlwP3A0vMTY7HBalaf5oosFp6nuX9c/
         WwzKCrdvhyckkuvBTowOxSGngvtJSfldyjf3A5FU80uGwpNQkQighCzcBrxDZSpDIMT5
         5HAUhH5Zsh8VSAs9heAccC24qXKUfLTr2n3mdhl08dNLYxwTTEg58g6lFokvemVP16cD
         2gGHgT4xQWhaNsEByf2RgCcpiz5gvfiQPva65Vd6KXkkLuBKkZxe/S3K2cgJ7c/FMd4E
         Wvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946942; x=1768551742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NqG3laPI6vEHEXOM9R+vgmhZHRmAA+/4qmyfh5dJ4MI=;
        b=UVpwl4XGHHGpI9YCEdPk5pAl2MLn0EGpU4/z7UE6dSHiZaHDqKHgE7xIFyYoyNQoBw
         rJs9UidB3J6pzyXWFtK1a2bCl17eGch5qwhK+SRsA9QtA6V+r74DFjVT51QzDAmkoMtY
         zZBZi3WmY8dEytawlf2YvhdpyeffgbKp/o5AFmXUJGf506alIKt74VqdmqKKg+e5/TvE
         hG766eI6t8q4YMfPMmZeQYT9xN7iJCOYHpl8FaiKJMx89SiterAgpjNoxh0kLsCTQj6m
         k5qr2axTN5IGWfP982LFjEnypQgfrp5oAcN+aY0w3wBAAF8iQ0hWaKkI3V++Ulm3UM/v
         diNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdcEv2QUwTAA612kM7XTEQfnPpsLChPARDIC5t8SjdjTV3j0oYrYDnhtsVknPyjp+Nrj0erRo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqipDm085nhE3Q5Vlj5BP+e96OcbxPlIUfCPsYct77jsG5vlY2
	OSOJgRd7Ot7bseJfOyt51e91ZIPWrEYDN8DF8q4OMU+yhf0cnoyClhhG/wnjz+P0hL1kdSO+31l
	Aww==
X-Google-Smtp-Source: AGHT+IEPiBQu8APfXNA3IWNbMpdOagfDDvRFnwb8uKkQFHMSY7VPVHw12O3QIkHoI1cD4SsInszAzyQFrA==
X-Received: from ljdv18.prod.google.com ([2002:a05:651c:4212:b0:37f:dca2:6c99])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6512:3c8d:b0:595:81ce:ff83
 with SMTP id 2adb3069b0e04-59b6f03a0b4mr2586927e87.25.1767946941603; Fri, 09
 Jan 2026 00:22:21 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:15 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-3-tabba@google.com>
Subject: [PATCH v4 2/5] KVM: arm64: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The implementation of `page_align()` in `processor.c` calculates
alignment incorrectly for values that are already aligned. Specifically,
`(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
boundary even if `v` is already page-aligned, potentially wasting a page
of memory.

Fix the calculation to use standard alignment logic: `(v + vm->page_size
- 1) & ~(vm->page_size - 1)`.

Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/arm64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 5b379da8cb90..607a4e462984 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -23,7 +23,7 @@ static vm_vaddr_t exception_handlers;
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
-	return (v + vm->page_size) & ~(vm->page_size - 1);
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
 }
 
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.52.0.457.g6b5491de43-goog

