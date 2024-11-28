Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7270617597
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755365; cv=none; b=fzgk6lnB3KO7WcgExOqS27DgEufaBYXVBvcXR2de329pIcBC8Hvv4KxurXH4XaJTwzJ8XC3pNU2NxgjqF9i6fp5VatyjsMAZYxT/gXu3XhbmUjNmP2/abtkmII104vjdlCJx/pBBMJOkry6X1txqDw24hB8JgFoFSff3oDHNOvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755365; c=relaxed/simple;
	bh=UOHD8P5jAo/tu9DZeP+a1DmnkO+B67XGDTnvDmQDwR8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AfEw+zb96dbtqrvSPlTrWPbMsaxuMSXWSkK3TYZlAyA08b9VNpXOMsk5JDAAdUWrFGkXFvjUEg39Rav3+wW6Y3zPh2L+fl1Q5B93P3RqMJycmAlzEk90YAyyPVcfEKsEfqeGFQ6yV8FIJoa0W9Ks3bCpYD0c+l8F3uIjwHZ8ZJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RwWAi09C; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RwWAi09C"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2129bf203d9so3543265ad.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755364; x=1733360164; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ysvaIdmMpR/VmHKwcGzTb4HtexOKJ4Ghx7ZOeauEtvk=;
        b=RwWAi09C2ZWOVBdXM3rtI15h13TxRmO9S66akit1yYMEiJVPOS+S/y8DuqaQ6Idlgl
         4QMTJfLXXJWuHzGY3zP4SBF7UKrX98c/MfCxT+YttWWL7DvxmKclGH30Mq/lxcKNW2J2
         /iOYjCVm+rgjRMbvGZoj4OHhHUygbR+e0INsDar0EfQTnES+OUoHwFltb6Zia6l34BzI
         jiMsm2oPKFMEyZmp5hr6osWvghvRJ6Vegu+OIkSYtl4z33IwrNpvVv9OW00ji4iYkA2w
         ciZBvbqnTjS279VwBvr0xNxCGhIo3RCsVFaZtJBmiWSSLGMOiWM+O7HN16oX2Ys9+Ctb
         IGkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755364; x=1733360164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ysvaIdmMpR/VmHKwcGzTb4HtexOKJ4Ghx7ZOeauEtvk=;
        b=QGmLAFStMlQ9jQw57ylFhfgeAXR+QWPSWF6Mvwm52ZVPB1vu5WMGDxRT2v3JkI1VPk
         Ha2xfY7XJTOIBD3zfngzQAd3sPX9OBKQKHZvaqXMVeZjHC+auew5QBIn7/Q8WuBRLZNa
         /YIcwsavr3NckeQxKIM8l/hPFXXJsa8jKUheH75lAACcOVgSOYIP6gOiCcruch3Hrd8n
         34h6NSd7fVu3z8q1Vy8B5/0kynVD0JtD5/xT9+wvfsebXwsXvj2ccP0GILCMohTZh/Rr
         klllVkIcPqTVTX+JLl9yvXKM95uT1m+PjT8biY5KMCrQuSWzpr1gj118vIaNNovZPe/P
         ARig==
X-Forwarded-Encrypted: i=1; AJvYcCVrLkqGiQxQmxrEDKFUxT3+0/N88fTvBXINMjmIrYeV5wma7HwVicr4dbn0MNkaJSKtsn/xnRo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/yb86dkBrDqSURI0SpG7Czs+AMTZh9kDEtuuapZYXFl9uBG/a
	N8RxFAj6y8878NdVyqpM1dz3mG/Xdt/gwtq6j6OMnH8VLvsJCXKtHIMleI8UF83Fg37tmqo5Uuw
	qAA==
X-Google-Smtp-Source: AGHT+IE+ChL1KLorT8CIkfmIr19XCryd//IzNWr5z8aQi0CF/Qf3ZQTw4qD7deHM4fsaQ6e/45gZiVf87tA=
X-Received: from plbmb7.prod.google.com ([2002:a17:903:987:b0:211:b7e:ba7d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e84f:b0:212:618a:461f
 with SMTP id d9443c01a7336-21501b5aed2mr63134555ad.41.1732755363732; Wed, 27
 Nov 2024 16:56:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:39 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-9-seanjc@google.com>
Subject: [PATCH v4 08/16] KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly include ucall_common.h in the MMU stress test, as unlike arm64
and x86-64, RISC-V doesn't include ucall_common.h in its processor.h, i.e.
this will allow enabling the test on RISC-V.

Reported-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 5467b12f5903..fbb693428a82 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -15,6 +15,7 @@
 #include "test_util.h"
 #include "guest_modes.h"
 #include "processor.h"
+#include "ucall_common.h"
 
 static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
-- 
2.47.0.338.g60cca15819-goog

