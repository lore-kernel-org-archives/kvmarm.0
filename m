Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584D87E777
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563007; cv=none; b=qn1Wpe8cKrKo44QWtPcXfQeOfzibumBu4BlLpsW1mEsxpbAHHKnwur5PU3yX7R5wiWc1x2IeQd7UJlhubPud5jd83JRHKrQd1W862wgOENSnilki7ujG2yw9uFBZuMGkm11ZqoJJQGvY0dAHBifiB0sTuKEPNhUpl00emkRPfrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563007; c=relaxed/simple;
	bh=S4jV/8eYOhGDWL6g6A7riEff5ftAxPJaEFHHPj7QQDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gxIO8HJRXcmvxbwkX46Vt8i86LOww+taydWfaOQrP4xh31vJ4nL2ulFc/nW/U5LvPs1Mjp/X9402XVwENJG5Ea9DNKeCNF9wLHal1YTSmVWdLOsOORFKtHXO4sb+Dd3OiTmTloWcjbhtG2h6I8aXOxa4iwFUOV+p9VmII56DIIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=firaHySY; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="firaHySY"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ecc23e6c9dso413845ad.2
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 04:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563006; x=1715167806; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3fmFcqT8F5hSXNzxYTaKRltCUOtWspR7LmgtxcvUq6o=;
        b=firaHySYE9xxpOR0EabTvNoEazWHe6UTGH/X43GxiSXx1XDmhVz5MIoHdzINEYWOpf
         Yyc1d00rXWqxBBWAEUmOEk05zMVgqQVkXYlEqaOrmMQEcuO6FQPo316Zso6EEJOMlwwu
         AOqSUszRtl5BUqV7b3XCcn1M/tmmDPn0J3JY0q1RCXF7dDOtwzbZ4MvcVAEArse6R2fL
         DVMWrugW8VdSg/6dCXbH8nvz+X+hS/AgcQgDTA8f9QJeQGmKc0aGGA1d9m2bWfX/rytw
         LvSmrkUE+AwuyGfycP8o27w5kjMxmw/nfhZr60Z3eVrHQtkYLDLTJosBPuQQ1rCXRG8a
         jMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563006; x=1715167806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3fmFcqT8F5hSXNzxYTaKRltCUOtWspR7LmgtxcvUq6o=;
        b=fYdjGch+KJh9dnOh6KyMCR7wDEHc9JV+VHEfrKnJSemOPj9//i3ttLhj7oUw959Idz
         2MScojCN/z2GWEX+bRSuMnHqI7AF+rlRlmpLOPwERkCvBncZSwNznj0CYNGksoGhAGrP
         k1CSQLCUP0MM/vhqMR/8Ko5KisDPFgDQkO5X1GGmWy8Qu6TaJv8VSIlN9+h73K6o7h/S
         ZeePsldC06DPCmMK+P1iXYj+nYjHvcF8XBss0XSQEf1nM0EgfIG7aohwCf6YfvydaxMq
         YeGkHotfLGjRn/vtPhSg3k/JAiAa94osGWxBcH/bslkd1TvftL/Fi6NGuRF4zLyvtj9b
         KHzA==
X-Forwarded-Encrypted: i=1; AJvYcCUGkRohQ1LIxxWPbIt3TxLDaU4EvyYKv5mFwKTjLIVlHVEukXsbWmJuYvxF8pt//v7+jJRyPQvmad5bs6ERsMZPFBqO+rmh
X-Gm-Message-State: AOJu0YzRSqKibzrQChzj80hmn/pP+WAkQg/CA4sTTiwNVtjud427mBrR
	N2snPZjGn6ZZPIwFkODKq/Upy1xgfWG294k9qJ8cFfPADRO3nKuw
X-Google-Smtp-Source: AGHT+IEkpQzYXzXYbs/gHLYdwxpBH/OK++tJH0WUUPJ3AyO4M069a98H6ricGGv8iuSezFZMDa/htA==
X-Received: by 2002:a17:902:e841:b0:1eb:156f:8d01 with SMTP id t1-20020a170902e84100b001eb156f8d01mr1930616plg.40.1714563005516;
        Wed, 01 May 2024 04:30:05 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:05 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
Date: Wed,  1 May 2024 21:29:29 +1000
Message-ID: <20240501112938.931452-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is based on upstream directly now, not ahead of the powerpc
series.

Since v2:
- Rebased to upstream with some patches merged.
- Just a few comment typos and small issues (e.g., quoting
  `make shellcheck` in docs) that people picked up from the
  last round.

`make shellcheck` passes with no warnings for me after this series.
(You should be able to put patch 1 at the end without conflicts if
you prefer to only introduce the shellcheck Makefile target when the
tree is clean.)

Thanks,
Nick

Nicholas Piggin (5):
  Add initial shellcheck checking
  shellcheck: Fix SC2155
  shellcheck: Fix SC2124
  shellcheck: Fix SC2294
  shellcheck: Suppress various messages

 .shellcheckrc           | 30 ++++++++++++++++++++++++++++++
 Makefile                |  4 ++++
 README.md               |  3 +++
 configure               |  2 ++
 run_tests.sh            |  3 +++
 scripts/arch-run.bash   | 33 ++++++++++++++++++++++++++-------
 scripts/common.bash     |  5 ++++-
 scripts/mkstandalone.sh |  2 ++
 scripts/runtime.bash    |  6 +++++-
 9 files changed, 79 insertions(+), 9 deletions(-)
 create mode 100644 .shellcheckrc

-- 
2.43.0

