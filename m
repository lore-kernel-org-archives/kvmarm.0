Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CEC18DF9D
	for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435927; cv=none; b=Wg3dayEXGxuZMAPPHBpjcP1y7FPyOSLeEF1lbJyZtV8kyTt6oYUkAcImhwftaEY/gRj4vnMB988+ileNFb9q1ZLCwsIV87zQjwg8+AC+eUCvYm3WpE2Z1puy//i8kkEyW+IF6wwKsyaZjH1577zRPO792yFW1yr5Qg+6PSK/GN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435927; c=relaxed/simple;
	bh=ZrBbX4IAY4APFGl+VtF/V7zyXDLhlwab546mwGx9K9Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WhCRqAzqPjApKdw8dOINnoOxwTSvFFgjt/n1ny4YzDI6sMQ8noOIOxhvCdDG/m85SKQfOAktRSDknDhwtPvr1Y2Ntiscol1ZFFm+HPSO1X7zXtHLXw+DCiN9ivvnG8WBzblGoYUfzKhEuHsztiHytFXXVZCx1JAJ1o6so+uOqE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uEJSty82; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uEJSty82"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso1342036276.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724435925; x=1725040725; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aovTDxABZxi5GG8qaMnBrDvsDUlH3vVl2BH7R8uieXQ=;
        b=uEJSty821p0PCd4NvNNlil2RKKOGZ7moWUnyVPTPi2u0bPweYRk2i2gAMKDu76YJlg
         JpjyMC6ih46p1Zyycc086eSFVASlH4KcOuSn3nk+fwU/Hm2fX10e6feLvYrmdGKZV9KY
         +cQuG37rjlUq7hQN/+hQXfRU3ETLjWAK4deavRfmWOC/feEnAjd4mnX6eRaA3+CBgUOQ
         v5WnzchbocxAsW2gDgWH77cdTImxvlvEvekh9kwvznsmBmfAFJvvkeVPl6Oub/2WcHwi
         k5au2c41D2mteyeGRb/jS3DQWmVN4NRyQRB58GUe5FhFcuA/3jWgqTPFl5+NJjUIS0/j
         uQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724435925; x=1725040725;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aovTDxABZxi5GG8qaMnBrDvsDUlH3vVl2BH7R8uieXQ=;
        b=aQUX1NPhhGjgFRKwdBT8AAUmZna+PcNV/jzR5Sf3g/dMdaGM0vuz5MJhSp67xdz81F
         gg+xVCNMa6eyj5uwuCmvcUqwqnHuaEKPjv7g+Ssmqp+NcY47iWZl+UFEf7d2ggpYc5Gu
         h7IAU4RfaqHQYBalNu/u8B14AqQ9aUvhP/GcXD5IUt7mL73KOar8vd/6ny7s5Rs0gQSP
         SxkDERx7vyEya/fblJSl8HeUMFf1IceB/L/ARF5VSOucHIvIDfimXVI8RZZssPO/r9eF
         +nR9qLOqG/zx96wxMX9W1THfbl1hYDsN5oN1F0i6B9YUif4WO76h8kQ6zqq9YOs83VVn
         sv3A==
X-Forwarded-Encrypted: i=1; AJvYcCUZOGNGsVg9b5kcWR0+oer1U7G3KC2p8rOagNtv1WFsN+3WNwd1FHgD4ObYr0MHR4KVw63g3pU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9bCDDxlXrjT2wRSUYRxs51j3wEJCWkhCdF8Zr07zfOtDCyjH3
	FjOEpbpqbGlg6YMfrSWvhGwcgU2rZNTIaO5oRebTRBq2esaZxv3pUJ9cAz32aBs6hh8fUYqE4YB
	beCI15BfkMmMcUI2IOlwFnQ==
X-Google-Smtp-Source: AGHT+IFkyrdr/hjrrx1tXoTdyF02S4q2EiffbkYrsjU0HOMNyW6r1dKVSMDu0Wi5zJ/x2shxCnGRhHN1Em9j20Elhg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:7403:0:b0:e0b:df3f:7def with SMTP
 id 3f1490d57ef6-e176779f742mr80329276.2.1724435924660; Fri, 23 Aug 2024
 10:58:44 -0700 (PDT)
Date: Fri, 23 Aug 2024 17:58:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823175836.2798235-1-coltonlewis@google.com>
Subject: [PATCH v6 0/2] Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add arch_timer_edge_cases selftest to test various corner cases of the
ARM timers such as:

* timers above the max TVAL value
* timers in the past
* moving counters ahead and behind pending timers
* reprogramming timers
* timers fired multiple times
* masking/unmasking using the timer control mask

These are intentionally unusual scenarios to stress compliance with
the arm architecture.

v6:
* Remove unused headers
* Declare const variables as static
* Clarify by using INT32_{MIN,MAX}
* Remove silly enum magic value
* Instead of commenting a function should be called with IRQs disabled,
  just disable them in function
* Remove unnecessary loop in test_reprogram_timers()
* Lift some invariant assignments out of loops
* Add some comments around better explaining wm() (irq_wait_method)
  functions
* Fix typos

v5:
https://lore.kernel.org/all/20240809183802.3572177-1-coltonlewis@google.com/

v4:
https://lore.kernel.org/kvmarm/20240307183907.1184775-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvmarm/20231103192915.2209393-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvmarm/20230928210201.1310536-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20230516213731.387132-1-coltonlewis@google.com/

Colton Lewis (2):
  KVM: selftests: Ensure pending interrupts are handled in arch_timer
    test
  KVM: arm64: selftests: Add arch_timer_edge_cases selftest

 tools/testing/selftests/kvm/Makefile          |    1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1062 +++++++++++++++++
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   11 +-
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 .../selftests/kvm/include/aarch64/processor.h |    3 +
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +
 6 files changed, 1094 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

--
2.46.0.295.g3b9ea8a38a-goog
