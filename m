Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC63CF05E
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720027; cv=none; b=f+TCKN0mVIMVMTkMFe3oP1hAPcTcaRfmqjQs+u2macFhSW0Q/jtl530CiR3zBFep8+n5543JWfXg4hQwnUwQDz5djd2lhd4hd8UOTvuXMUBwXzmysR044bZaVIrLXYHfDwlXU0EvKfEyN67dly1yqTlQvAcKaZ+zpuvYlLC+sLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720027; c=relaxed/simple;
	bh=R4RRKP6Jjw+CLrer43S+NrH1h/WG+T88j7VztPPNMaU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ta5ayhvcI7JnMocjUxT+eH+KI/xgk00RIkyMziDG/W1VIQ+HYuFvep0RP9Loi+CRw2kh4FKlmhSj9yZr0oqYEJHUzWYCKQu4sN8CtvJbWLISLwljlEKHIs/rGQPepiD2Ji+llZDMwIBN8evaifZlT6aQncR01U3hnXkpKmXNQHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GO/P060p; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GO/P060p"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f803658d5so4244771b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720023; x=1777324823; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U5TkYNL94NKu0U/OFCNswNWigEfxOEAkzVOSoJlSIOI=;
        b=GO/P060pZe5l8DdJsmelDfGnXz36oVqGBVnDgI3iNjdAtxmZK/+R/3TD5qt8MVQ+by
         j337IebNzkDKC5A2YJAvJgcr6WBwsK9Ff1yyRQqp4ZzCuOuVy6miMXWWx1ASCyxwS0Te
         FxeRDeCdWcSuwoi3pBZjZnVd1h5FRxWgjCB+kbgBaIJ3naM/bB+UgTfggb5v9X/a5+gB
         85+1sdBHyEnik8a/HbLTaXfTDLXgwfAIE6xsfd+BKUphYJfN6+3u77YTx5TPscwxTOpl
         4qRLbY1YSCXwpZllWmcKRmFUUZ+BNgBJ5mYymvtT+/XvT1iJNuUw5GjfULkpdzQJkver
         FvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720023; x=1777324823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5TkYNL94NKu0U/OFCNswNWigEfxOEAkzVOSoJlSIOI=;
        b=iwEU95A6UztD2CJKaHAkWIraPGInkOFuqNo8F6KYX5tKSx9xyxi+Yl/pNKpCWAoSJr
         0FwLmv7JX76YikDY7gBP3dKYpCVUZf1To1tG9beOB5eMiMQSLOnobzuS5Ea9scF7ZT7n
         edj2YVauExabHdW8QQluQPAAnq2fKgNfuONf1geEhJeKrCMjA5+13J/xeHCaW5FX13rx
         cxcy8/YwcReAexQGcNFi3QRWpU33kvgOHQzRAgAbLUpq11KxO/I5DlR2NTbsUhHUCQvR
         x2wIuymBOOn5YHnhSPAsXNkAVcY60FIxnYkFvYLCyLEugjZqvN+Ls8xbZ0+eQz2HW6Tf
         hCRA==
X-Forwarded-Encrypted: i=1; AFNElJ9OZtSdgPIshkg5e+H9T/+Zaz7v+NHCTS5uK1zQ+Ayh0buTnbRhqlpN7H/WoxBXxdj1luT4vYw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlA8RD/QqbZjT4R/l0M/7Mnun2NhA1DqzyLzjJUnaW2wQSNTpw
	DaN2If2/F8wPX1L2HsJTicUN1Y3QlZwd1k1AMwImIXY7O/jfDhWquyZnofoS7ZOydzCezxRTEkV
	UjLtM/A==
X-Received: from pfve12.prod.google.com ([2002:a05:6a00:1a8c:b0:82f:6a57:a9aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cc7:b0:82f:5051:f024
 with SMTP id d2e1a72fcca58-82f8c8ca07fmr16761487b3a.27.1776720023205; Mon, 20
 Apr 2026 14:20:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:19:54 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-10-seanjc@google.com>
Subject: [PATCH v3 09/19] KVM: selftests: Use s16 instead of int16_t
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Use s16 instead of int16_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/int16_t/s16/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/guest_sprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index 8d60aa81e27e..2a3ab9c168f0 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -288,7 +288,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 		else if (qualifier == 'h') {
 			num = (u16)va_arg(args, int);
 			if (flags & SIGN)
-				num = (int16_t)num;
+				num = (s16)num;
 		} else if (flags & SIGN)
 			num = va_arg(args, int);
 		else
-- 
2.54.0.rc1.555.g9c883467ad-goog

