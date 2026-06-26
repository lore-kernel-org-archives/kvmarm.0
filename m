Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C511B3C1979
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509745; cv=none; b=Q9FITRq2EOagmK9LV3VbuysUngPKbJ3+qHbjeJqmleCoLnAkHWxqXpVjrzF3vCavmSaJYtX8wjn2l/DsFqTLOWR2BXJFZeQfodcbpn3PPWYoxHnt7CdVj+/YFf4/dPzS9fAL26/lQrkncbkgPmSCYdEzB3w/WlwXCSPCQlCenQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509745; c=relaxed/simple;
	bh=b+6vXwlbFetE4gcCaUQZiIdwXOPNKHYqQd9n96GIV8k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cvfYJ7YM5ThE8mP851QldICVtV8vfZuJsCqaWm3GgIU7vT17nRJyScqgs2cO6ooI7gPQfafi4e3CYIQd0mPJJKN2rS4Ibm0hnxh5ZPBUdsXPyXsmNCvtexuPAk8loXQJfQMqG5UIOrJjImn8haA0E7/42Nx4/V71nlBDT8GO3yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u6OHSsIQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u6OHSsIQ"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c6a9bbcc53so13154055ad.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509743; x=1783114543; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qCGL317mUr/viDiHdvHr/Nh+V34QOpSJDtpLpPCiKc0=;
        b=u6OHSsIQmJAiin1fioZvHz/VYcBLRrRdSmajCnnsfRsU/eTUi2WduTreQL91qz4Inb
         km2EukJscYLABi2/wHJLXt6z09ldwqph6sErw0VtqwYjr3/vmJIyrDWMCDmuaMPB+99W
         Xa7QCMXgKCcRQNKdKGsckYwOolJCLoXyE5qG1ntUwOaFSvnIC/T3G/EUNEjQ9/0H9B51
         A2PrBGS+WdhRHFDtggtlwkjLZ8ZHA9Qx9elsWU5ybSijfK0RMkJ54YYUfXIojXOKVf1o
         QI9tARei0XXvtzH/MO0bpE2+e9OU9VrtE80QScS1PNiMQWE/lOwvNxlFjin3rWiJwJLU
         ntFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509743; x=1783114543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qCGL317mUr/viDiHdvHr/Nh+V34QOpSJDtpLpPCiKc0=;
        b=NhsHc8O3qRfj1i/4qdn75uvtKKmfRkLZVBLF6uAYpWbUNhauyeK+3Rp0eZPBuCIv33
         4BzJIm0K4na9ZlyKaM6VDrj0i46QTEzexwEYnabPZwWZIPAfxLdTDUkPFJXUzocpe6AX
         oxJr+Q+zajVTkOjqlgyrHXwA/ZyNdd1QpyKpALm9WsFslHa7L+NvyP5tbjOW1OQ9EkBQ
         yflROMbBnBNSLDdSRPfqWtbsY6x77P7VzryXFD/YnDt5FA/Kn0/qr54m1MvMCsH408/G
         njiaQt1PdsORhTwTJDEaxHMxPkLhdAQ+PiCEj5qqa6eRqi3uBEr7DGLmfVGR4l/gPUhW
         zgOA==
X-Forwarded-Encrypted: i=1; AHgh+RppxsWxzltd3KD90ir4W9EQ2xfT9dbE2WBOG7Z7MFrojUI9SSKfvJs4tr7g8j0KTB99m73j1LQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyWr7PpSbJ/t2mdWTKbyPvhun15JbDO2hCWdW93p28DSCypmsb
	N4eAdyRgEd6fEIeh1PfzKA6L9bolaPBLOzFLN5aCZFKpYyqLyoLyVMZ3oQSkW6ifuwXQzCLxB/x
	pTvYbpw==
X-Received: from plbv21.prod.google.com ([2002:a17:903:44d5:b0:2c7:f68a:7995])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce87:b0:2c0:3400:5c34
 with SMTP id d9443c01a7336-2c7fc75a558mr80368325ad.3.1782509742779; Fri, 26
 Jun 2026 14:35:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:18 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-6-seanjc@google.com>
Subject: [PATCH v8 05/20] KVM: selftests: Seed libc's RNG before using it to
 generate a seed for KVM's pRNG
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

Seed the RNG used by random() using the de facto standard method of
srand(time(0)), so that a different seed is actually used in each test run.
E.g. without seeding the RNG, literally every test on x86 will use
0x6b8b4567 to seed the KVM RNG.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1016865d3f7a..277166ab1aa9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -15,6 +15,7 @@
 #include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <time.h>
 #include <unistd.h>
 #include <linux/kernel.h>
 
@@ -2284,6 +2285,7 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	sigaction(SIGILL, &sig_sa, NULL);
 	sigaction(SIGFPE, &sig_sa, NULL);
 
+	srandom(time(0));
 	kvm_seed_rng(random());
 
 	kvm_selftest_arch_init();
-- 
2.55.0.rc0.799.gd6f94ed593-goog

