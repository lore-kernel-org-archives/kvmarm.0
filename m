Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2C019E998
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 22:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743804426; cv=none; b=igcWXVC5d7JBcO85GcAs44Gm8c7MQBD0tawy8D4o4F5IM0VxQdCWPqxWgMxjoTInNjm0BkRglIDM6g6lrmQbRAbrB78uqlVZaNvX/RrUbAt3GQPq9goFd+dLaRCZW1cEftwS0ZLAc34MLq01b7DxgZYdC/A0KimVroWpPR7SSW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743804426; c=relaxed/simple;
	bh=lic10qncMW0Yuj7ay3ptqbrzclOlFz0Wcn9Xa6mjD1M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VWkf7FaYc8w/zF4SRo6KbFuc79Yqq3/hQl2KrYAPhBcKSaKWYaoZso7vY33JO0asVSR9kWqoFnXsMo9i/1h9c5tEt584iJzadXkCofAjDNRVqtw5Tq7mYlwpJP0xyBMFPAq+Xk+GXKMqGa9t72HiH4Jip+yA1YL+g0bifvAmo0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NonAxNx2; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NonAxNx2"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-85ed07f832dso247601639f.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 15:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743804423; x=1744409223; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+ABQvf2myBmBVu0tO5Zf2gufLBIF2IPE6tPBCISSnfw=;
        b=NonAxNx2uvSY2ASzWBIe0vPWGOth45LAWgVGNyDBoEv1SQZTqvo5qQXhUdjv1xjjdn
         G9G5epDVxrvxnRmH8tYF2TUVmX9ks4UatIOcH/jF8u3wuivtVRlkwFgyJP1N4pnP0GyD
         JRYvYIf1IFOBC9KKpZ4BrEf1TKsNM5JQG/Y+D0jrQEzx+phs9fpXuBgRGNwWUhb4HGg5
         jNwZk6Fcvp1+d1/0lu8Toor3KAf64Yo659Dy5Boflt6uI2V2sxZVl2kA/TWEdhbV8ZVW
         5x/7+ipli6+d0wQQcpcLpa94kU/hkZ1vmfvB2KTMnKsgF/wzij/1r6QFIPHcro0OcWtZ
         dMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743804423; x=1744409223;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+ABQvf2myBmBVu0tO5Zf2gufLBIF2IPE6tPBCISSnfw=;
        b=fuP1zhP3ZC2nogF+3RmSOJkKL7kJz9av8nFbHBn8xzu+K6BOLjoUWuy+3DGsYpYCW/
         JG7VnPyFmppcrs+GtuF0OUI5anVr0C9jvpQ8JyEMpEzpw8MVs3nkiaYdqctUI7OgDJDt
         6RxGdX7Cn3C67ZiQmMGI2QozepxjYR5i1ydjZFkbMHNqqF2QNDG1FzDEpjtSTC1CMxdt
         hCPb8LuDcVyfKb01xnp6U9HSSZir4KKPZbM3noAukhF4eu9YKVd6zq/11hLLWHNdlb0H
         lnXERsc7EHLDbvzevsxmn5VcgMQVJCRD9GCqyQH7VZjIN8DSYNkivqH42f2nrWfYbMfr
         df6g==
X-Forwarded-Encrypted: i=1; AJvYcCWN6nheMUm+XvHiF2XR0uDF1aH1dzVvUB9/S2ZPE5h/kodX3u9kuAbON+dRuiH7q0vQaGqoRbI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+jpJ3IqXbscKaO2BIduwgbHxncBuzBiMXsmp8UoIzMvEqAudD
	2l+iWC7kifUw/nxBcmv9auGbjMEksaPwnfJ8/aiKO0ok8CZyyuF9Vc6WRK+RYtV/uYnYyb0GrV3
	W2pbgBQ==
X-Google-Smtp-Source: AGHT+IFV9Isc4fgBFHlpxTPEvIA2IWM9thB5QLOG0FR0uQ2WcHEpEv2w8WbCsDqt+JLpu7IkXXi3TGByiQPr
X-Received: from iobjk27.prod.google.com ([2002:a05:6602:721b:b0:855:9384:bf3d])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3a82:b0:85d:b054:6eb9
 with SMTP id ca18e2360f4ac-8612ab4b028mr139258039f.14.1743804423530; Fri, 04
 Apr 2025 15:07:03 -0700 (PDT)
Date: Fri,  4 Apr 2025 22:06:57 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404220659.1312465-1-rananta@google.com>
Subject: [PATCH 0/2] KVM : selftests: arm64: Explicitly set the page attrs to Inner-Shareable
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The series fixes a conflict in memory attributes in some implementations,
such as Neoverse-N3, that causes a data abort in guest EL1 with FSC
0x35 (IMPLEMENTATION DEFINED fault (Unsupported Exclusive or Atomic
access)).

Patch-1 is a cleanup patch that replaces numbers (and comments) to
using proper macros for hardware configuration, such as registers and
page-table entries.

Patch-2 fixes the actual bug and sets the page attrs to Inner-Shareable
by default for the VMs created in the selftests. More details are
presented in the commit text.

Raghavendra Rao Ananta (2):
  KVM: selftests: arm64: Introduce and use hardware-definition macros
  KVM: selftests: arm64: Explicitly set the page attrs to
    Inner-Shareable

 tools/arch/arm64/include/asm/sysreg.h         | 38 ++++++++++++
 .../selftests/kvm/arm64/page_fault_test.c     |  2 +-
 .../selftests/kvm/include/arm64/processor.h   | 29 +++++++--
 .../selftests/kvm/lib/arm64/processor.c       | 60 +++++++++++--------
 4 files changed, 96 insertions(+), 33 deletions(-)


base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557
-- 
2.49.0.504.g3bcea36a83-goog

