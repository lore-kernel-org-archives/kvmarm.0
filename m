Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355C813D539
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 00:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600658; cv=none; b=HohzWABHSiNg5UUXaQB7E4lUNKKqyyeMcNkyHghfUlwdTCrUIyj4gsWj86x6BXZPlr6Wywo3rRe61bdTBn1EhlqDAvy47Qh6hQNUxTJfKTJS93Bv2FrWge8GX1zHxSCYSVP61/NHCqi3Qsio1W20vgWl5DwCJjZIKIgn3W37+ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600658; c=relaxed/simple;
	bh=tIVAjv0R6pUZqeCBUMOqA6Hwa6RH3vUVAalxmKoMGQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PNU5lhQwfqIzfXG6ZIH7sxfupq/gFJ6vagm0/Acav72cZKvjbTaOEbvNkoV2IzahJ0C8ZVewqaX0sTXMGDVKfq2spsoy/GONYE9E24XKtDhayMvc0PTL81aYINNNzA33pO0aRbRqDoyqLP3wUVhurFLXpJ2yqY3xRGZSuwd/seY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AL73jBm6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AL73jBm6"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c38df7ed2so4326014a12.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 17:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600655; x=1750205455; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zss/ktKZQOB/zxYHcr8l4OJbiGy6+R3+c8NDOsBeWew=;
        b=AL73jBm69MRquzqAqPoIYKmtzZjdl9dUQNh/OMwJeuNxehUEhsutJZE/YH1UDWnhOy
         UovYwVhEn/JPfIUdfcRuRtqDClwiYKr8FBXXxipedXPoY9b28gDQQ32JtkS3XG4ZSayD
         y7Mphz2uKna5SLkXKvvm8c599PBpPr7UrIFDuxKbObpNeo3kar6UvvjY8famlyq7q8VA
         V+QxvIpNW4cBpb7dUBh3uxGAP/pMnQnxinoMIt6lRIZpYQggFMI8CstfcoIFRkbRuCYW
         ZJoTX0NvyvwhaGGH8Fqdzt045efNqTcJrClSlKcjsnVkVkXSD54YswViRtAHOFEvjRmS
         YfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600655; x=1750205455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zss/ktKZQOB/zxYHcr8l4OJbiGy6+R3+c8NDOsBeWew=;
        b=mU74bS5jwGLUkmMzXieVy2vGkHyaz/QQVzaBsLx7sD+giAlvwUuG+FKIH+IVy2yp/0
         XL6ljpBF119GAmmdWlL+k+v6iLmPVmmGyUT3cEineC+mZ7M89GCz43TgFDzxaE/8ifn1
         OZN8/2T6LRyiN5nwihIs7S3wTc9MWwmuKtYJf4AOJJHjR7Slw+XDBKpO5e5YnfZAFWTi
         xvyaWf3FRXrGYnwGE1MltS0gSRBR4do16qBPb3bfpiOwGnm1kLEIFApDVOVI+xGKuAtJ
         Kvk76RAkRvArY+cHOJI5gPJxH2tOVvBhrjB0O3WhVI+KXtKYyVlHvrr0AZdOnP11Xeu5
         Ylvg==
X-Forwarded-Encrypted: i=1; AJvYcCV4umpYC5sKEmYuwsx8wP/9ZOgA2gSefYZx9gdk/At5aQ6HVgHUotyQAvDUJ1oRbPf1hDDmKrk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNNj98BInGs29tXKLG7ibDILzwc2LgaOuLIfYZGPQSK6SF42Na
	hrbW/gDQ3SmKp4LFqD6Me4BdN4ZU0vzWTlLXfh26v3aQ/9GXke1XZzVwS8J72/+xTI6VU+6U2WK
	Xn15yHA==
X-Google-Smtp-Source: AGHT+IFPf4zAcxMmKYyJF/0q0QWOeyyNBeEfAEV8gqM1cGbYGy338sgO6izo7nZMoEiNEzX0yDZpDSCyFlg=
X-Received: from pjbpx2.prod.google.com ([2002:a17:90b:2702:b0:313:230:89ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384d:b0:311:f30b:c21
 with SMTP id 98e67ed59e1d1-313af243a50mr1534626a91.26.1749600655513; Tue, 10
 Jun 2025 17:10:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:40 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-7-seanjc@google.com>
Subject: [PATCH 6/8] KVM: PPC: Stop adding virt/kvm to the arch include path
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Don't add virt/kvm to KVM PPC's include path, the headers in virt/kvm are
intended to be used only by other code in virt/kvm, i.e. are "private" to
the core KVM code.  It's not clear that PPC *ever* included a header from
virt/kvm, i.e. odds are good the "-Ivirt/kvm" was copied from a different
architecture's Makefile when PPC support was first added.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 4bd9d1230869..1a575db2666e 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -3,7 +3,7 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
+ccflags-y := -Iarch/powerpc/kvm
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-- 
2.50.0.rc0.642.g800a2b2222-goog

