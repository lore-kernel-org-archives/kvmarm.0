Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA6172630
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 00:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600656; cv=none; b=CBWOQlVhLU2kWWYDhVZHnotqRQtP2vJhSH3ZTmnIOLowxs/QhMVm3COOSDrP4AxdLoTCntg6SvOCK58labrvI5O2SKD+c0Xz679xJK/c/V+WyRKdNsSr7jmHjTYgIf72xh3R0RLCp3rGMshkRI0+s8aW7RfpoUAt8iEZujN1R6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600656; c=relaxed/simple;
	bh=fi0POvxipHtqzuBmBtdO+vOuVF1CdKjDHYYgzms+PmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OXrkaM0Jnfb0RK78J/k3x54fdajhMAc9LG5HQ4HbE4qARdzNgH+cEcgRwVBtct268A62NT8D16Q3JJIn2NBFjLASfil4GcHycRIxNZu2GC/9QxXZ3SaoXMaBB+DxLSFggjetYPg/Fri9nInFeGgWIvUwu9+RmHUV3Fkb0v8PruA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xnKPaihG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xnKPaihG"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311b6d25163so5171470a91.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 17:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600654; x=1750205454; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hBjwKNBikKgFeXvQ1q5Ivd9CecF6t6Q9MZtjOeYYky8=;
        b=xnKPaihG0XLd601jCT2ID5yzz/8xgKXx+oZAwOKr5FOMlCiCPQSsuN9Fqk/rcWASk/
         SvKP9VxKayJEc5ceie6IfF5aT9NQoM7cfpbvzmBmk5EbMOEhrInKHNZH4G+SaMpiMlc6
         CHe9cdJM7mBwHqkeuzBbvlneJR6bqP/ZknsMzKkUr34R6zZ+zAD1s+PVscJsY7X0QJ08
         yvt/Rwlr06dtZYAPIsIlW0vHIHe5rDmC8QgggFigIsBw0KmZmne4fPSSAxLQPlCI7+5x
         dlZZi8zfI4354OUaoV1p/lIZqJFNhF30mCrOmCEfySC3wdzrXFkEGYepK4lOFWfwq1gR
         mc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600654; x=1750205454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hBjwKNBikKgFeXvQ1q5Ivd9CecF6t6Q9MZtjOeYYky8=;
        b=ZSHMH0mjWABFK303BXcMNiIYHnNfX4XqeWyXp52rSXoTcyFcN9f+sNDGu2hSCYQCs4
         WFFThU+XAnU/dTF2ZZd1wPB/yS2p211DhQyepTVAm4fszkssyNGW1cIzsUgiIm6heMVg
         L6VbbC4WlWdoU7iXi0bLt5N9k49PZ6aubOwdJSFz5/sHopjwctcEm5G+M+N/8QqIefp9
         Potk3UPdzYTuHPf0Ruui74NKhRFnjo0umvtG7k9JovoaQmS9KilcVhxxmY1xvFa5l82d
         YUtNe/fQUj/xLMzRN7n1qEFHhhsDWkvmR0gyLXklgfJASlpEAdDPE2laAPxlKlaitqEZ
         EBUA==
X-Forwarded-Encrypted: i=1; AJvYcCWsnbeTWyDRReqTI4L3JbWqVnJ6HHYnd2ewzXw1kIrzEGTYkr6jYjgy34MKpmFq3qwz5yILonQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxr2MeN21iHPwQMgYNUKlQcgD4iIJ6ZTBgz+Hl5mnOuA3TKNcj1
	1/4bV6YNI1KZ9P/uQdNj9NrYDD8yxYnU/bg9l0WGdp99GlLFvgHTYO8PnsrtGbanXSRltqY7g/K
	H8tcc8g==
X-Google-Smtp-Source: AGHT+IED4B4s7Ytoor8mnhgXxSS0ZKiCE28nENLHgtxurTVkQjPNLlNungxBpASYaT+z3Y4fvBlDrrKUUDc=
X-Received: from pjh3.prod.google.com ([2002:a17:90b:3f83:b0:2fc:2c9c:880])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cc4:b0:312:26d9:d5b2
 with SMTP id 98e67ed59e1d1-313b1d9c310mr956755a91.0.1749600653718; Tue, 10
 Jun 2025 17:10:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:39 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-6-seanjc@google.com>
Subject: [PATCH 5/8] KVM: MIPS: Stop adding virt/kvm to the arch include path
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

Don't add virt/kvm to KVM MIPS' include path, the headers in virt/kvm are
intended to be used only by other code in virt/kvm, i.e. are "private" to
the core KVM code.  It's not clear that MIPS *ever* included a header from
virt/kvm, i.e. odds are good the "-Ivirt/kvm" was copied from a different
architecture's Makefile when MIPS support was first added.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 805aeea2166e..96a7cd21b140 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -4,7 +4,7 @@
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-ccflags-y += -Ivirt/kvm -Iarch/mips/kvm
+ccflags-y += -Iarch/mips/kvm
 
 kvm-$(CONFIG_CPU_HAS_MSA) += msa.o
 
-- 
2.50.0.rc0.642.g800a2b2222-goog

