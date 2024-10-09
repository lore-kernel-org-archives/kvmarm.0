Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC4A20408E
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489016; cv=none; b=QsMkrex9sphPTMAlo/5nEvpjCLyQ5K1sPWiWKpFQi2wSeZZkFtLGYV+B3mCDyxBxJmr6v3lfLHRbqIDICQDNsXh8UvBv2RS1eMbyVzbobYumUifO6e7KoDiY044IzkElug5ZZC+bWMEFH1MfQUfupY0ZWf35JTQSiaKzJ2GDuFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489016; c=relaxed/simple;
	bh=n7uJjw0M+CvpEDCyIwANzPoenH4vXh1rKtEVamrxwhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E5qF+Js0M5kju2talYoEqFGC0fhU4gzhVKpbjIALGV1a1YfBLdWSr5nM4dQikH3cTL4WwcronNzEZDpBw4115nnQBfHubCI8RWbpTd7L0kMQ60xOfXAo1eJXSzW0bd+wx5VNxU4FLHetqIelTsfn+Oiqq87jtP5+i/1wm4eJRqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=foc/Bis6; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foc/Bis6"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e000d68bb1so13384707b3.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489014; x=1729093814; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pKnU0Kp/o5z6vCl+SnuNv4XsTANtPNd0KXgSeGLrrD0=;
        b=foc/Bis6demFGq+4dVccYoSv4/BbSvb+6VPBu1UxFmagSM8zy82f4T02JBSaGFq2LZ
         WiUVbLNPbs71iDtg19hf5///zj40CJHto/Vo7R1Ep+RTpVCmUl/ng8op7fH/lmoOUqJP
         yXR0PaElDzGL41Hu5s/BrTe2lIPnzmudxpWTpLICCJO7hw8Oae8WVe90dor5F9kx2i1m
         fyPlRZSCYsxta3j1dlvIT9NKqHMyg818a7W4Kocw+zju0HCKi5euR2B96W3/sJbbLMN+
         FBzONV3B6vlcpxDMEUajj1C4Hvt/VgP/H7Uty66hU/JbfSjwW8D8HhZMBhE2RnadvLf5
         o+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489014; x=1729093814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pKnU0Kp/o5z6vCl+SnuNv4XsTANtPNd0KXgSeGLrrD0=;
        b=HaC2jkZFWVpN2vD3LI2QK6/biVv96zxovxlduUy0xrqkfMTYF/EeGsA+Tg19Qnu6bp
         P7XdW6UNPSIkR6EAuMeMVeEuHRantjeltAZ9xo0h+bsieYyH96PuXjWVheku5uvh4mRU
         VhJHrnoUwCn+Suxq2ZgefWRK9pcr1f7gdhltrd4Ii3e30ojxWRFzqd0Gz71IVlrKruDx
         nyU1G7EAZGCUN+8SxQIkoFc2B5YNDn49MQ5IDvMXsXO4YJyEwqQyQtKNgRa6DHtC62Wn
         1aBI48ynxLdJ1AUQ9Pj/G92uGFZVFWRRdKQeyiXYq/QTD1fYNs6poAYWYoOa26Hivqxy
         /RPA==
X-Forwarded-Encrypted: i=1; AJvYcCWNll+JYxYwjeVWI7+4Vf2Rr/qmQZj9AntnO3UfFEU/4A7kxcMvJXRS77Qir5plsuRkJTnkFLg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwROjicX0IkeSUvi7XjwuORJyJ1522XfSuVa4fL9lEI9KwODSpD
	C/rrjO19rCooteVG5GQ60u9M9RmpImb1m1++uBCA05HdYVb4fQw80bVcXm6cB1bjIvFFVQGGZZd
	HKA==
X-Google-Smtp-Source: AGHT+IFl4KKTDXOPETiRWWIkjcYQuDw12IfhMjxBQcTnANGnaD3TD9lTchjjvx4T5v8klQyshc757dwsFY8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2b86:b0:68e:8de6:617c with SMTP id
 00721157ae682-6e32f279e6fmr2237b3.5.1728489013701; Wed, 09 Oct 2024 08:50:13
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:48 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-10-seanjc@google.com>
Subject: [PATCH v3 09/14] KVM: sefltests: Explicitly include ucall_common.h in mmu_stress_test.c
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
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
2.47.0.rc0.187.ge670bccf7e-goog

