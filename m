Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A833F2E632
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 03:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486104; cv=none; b=RFDYrFelUC0VQIpt140tZ3GeVQOF1BuvdqdI8ckV2P/ziwlZrCjPTWqp3kD3MxdotD44rksNGkaIbulnfpTTtOUB003guaZivL9OPuEX9f7CiHMUnK0rlMTJmgY9Gpc1s1lSMHKjjP9bZpZj5BIVF40WLRk73XiPKdtiWTzcy7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486104; c=relaxed/simple;
	bh=00EYudbANOSaxNSrkwurD81lMrDxfKTUqVgu1v5tMY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oWxC3DgP/dY/N1wHlsc6rXYfQtUKTSagcpwxuHsOFnjnMYAmqf8/LW5ZHRe4OjuRlvQkpF7ZW7G6bw8Ma16mQ1M6u6RTvNg/DYwkBifM5kMPYNQsqgJZ9usLx8ymR06SzOsBFi01gUrfv6WYiAHCaoDGhIW568oiSFisUo4AzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RkkCLfUr; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkkCLfUr"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dbb47852cdso1066305ad.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 19:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486101; x=1709090901; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ig+g0BUZSXifjVBy73OzZ9fIB5v/6NjxVeJ9J0qwojE=;
        b=RkkCLfUrPXORzzV1QHeJ/siRAvg4hITmnM57iASbbutUHeRjMV8JJq+Ebbgi9kTKDP
         6PmNBHIkqlGSqo0NdIq7UTysTA7H4yYsanYR0Yvqk3g2pMu9r3RCzMEcdnPk9A05C+zS
         p+66nZH9QPdaTEdgl2v7aO0HGoALHgqd+3jBxqNtHazaPQP5pD5E8TmL1rrcbZxw6w/B
         xhs/nTO8WEx35G6PfoXK9WgUBUPZivDOdoXw1q0201OfIuUuz2Oxn6g4Qrg6v4hC9Dry
         WRNNs1Sv2kzTwt+CiQ/snbVGOtO20dvXCgighEKnNgk3Vkphdnzd1JicJp7GvqkxdTsA
         Rw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486101; x=1709090901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ig+g0BUZSXifjVBy73OzZ9fIB5v/6NjxVeJ9J0qwojE=;
        b=vHhv//NwgMwem8m9KPS+omUCwinIM9O7dIZ56pBqeCWu9vMHehq24hHRQN9zDwcsZf
         RVXDrL9ZIYD+ygYkbpjCQBnAH+R6gGZV1PSblTq0138U5vg3C3/4ZzH1Rh2DepSqUDQB
         dBe0q+0h8ATkl5707LhtG2k97uwZtAeK0eUlNGBz04yxtDKBNN5Mk/rEMSH3pmXgPSRT
         H+g/MoEPMY5zlANKtof0IAxRuxYNX2ScKOUwWV/OS9YDG0XQpclI5mo4DZdoTsVqPfbp
         J4eXlPaF3CsHRzW7WY+u9aMisz4EkgSKOMpl4jBF+iMTKoy97H1aM1ityCeXfwW83PVC
         bqeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLACVILaSw5K0KgVPTj9L2yaVBCoWa16iBleUMpQVvTm2oka5U8QeyHIfzNTTKaBa6RCyvM3Vj1wbNgSl+pCNNvgpi9Q5C
X-Gm-Message-State: AOJu0Yz86Fe0K4teI9NsoM/mpqhDPHmEDkiTFc+qwTU/m8eiUOL1qSe6
	3+qrCiFgL5zwiokjkaqWfz9oCrIPeu71jF6y7KURaI7vAjxwUax8
X-Google-Smtp-Source: AGHT+IENcbmlmxPUUYa5IPoB3qyzTiAzkVoX3rrNvUBxi29LRyMCLlj6+/WkLPi+Nhs8BmfBMPXIdQ==
X-Received: by 2002:a17:902:b902:b0:1d9:8ddf:5fa0 with SMTP id bf2-20020a170902b90200b001d98ddf5fa0mr14621025plb.62.1708486100817;
        Tue, 20 Feb 2024 19:28:20 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:20 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 0/8] Multi-migration support
Date: Wed, 21 Feb 2024 13:27:49 +1000
Message-ID: <20240221032757.454524-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that strange arm64 hang is found to be QEMU bug, I'll repost.
Since arm64 requires Thomas's uart patch and it is worse affected
by the QEMU bug, I will just not build it on arm. The QEMU bug
still affects powerpc (and presumably s390x) but it's not causing
so much trouble for this test case.

I have another test case that can hit it reliably and doesn't
cause crashes but that takes some harness and common lib work so
I'll send that another time.

Since v4:
- Don't build selftest-migration on arm.
- Reduce selftest-migration iterations from 100 to 30 to make the
  test run faster (it's ~0.5s per migration).

Since v3:
- Addressed Thomas's review comments:
- Patch 2 initrd cleanup unset the old variable in the correct place.
- Patch 4 multi migration removed the extra wait for "Now migrate the
  VM" message, and updated comments around it.
- Patch 6 fix typo and whitespace in quiet migration support.
- Patch 8 fix typo and whitespace in migration selftest.

Since v2:
- Rebase on riscv port and auxvinfo fix was merged.
- Clean up initrd cleanup moves more commands into the new cleanup
  function from the trap handler comands (suggested by Thomas).
- "arch-run: Clean up temporary files properly" patch is now renamed
  to "arch-run: Fix TRAP handler..."
- Fix TRAP handler patch has redone changelog to be more precise about
  the problem and including recipe to recreate it.
- Fix TRAP handler patch reworked slightly to remove the theoretical
  race rather than just adding a comment about it.
- Patch 3 was missing a couple of fixes that leaked into patch 4,
  those are moved into patch 3.

Thanks,
Nick

Nicholas Piggin (8):
  arch-run: Fix TRAP handler recursion to remove temporary files
    properly
  arch-run: Clean up initrd cleanup
  migration: use a more robust way to wait for background job
  migration: Support multiple migrations
  arch-run: rename migration variables
  migration: Add quiet migration support
  Add common/ directory for architecture-independent tests
  migration: add a migration selftest

 arm/sieve.c                  |   2 +-
 common/selftest-migration.c  |  29 ++++++
 common/sieve.c               |  51 ++++++++++
 lib/migrate.c                |  19 +++-
 lib/migrate.h                |   2 +
 powerpc/Makefile.common      |   1 +
 powerpc/selftest-migration.c |   1 +
 powerpc/unittests.cfg        |   4 +
 riscv/sieve.c                |   2 +-
 s390x/Makefile               |   1 +
 s390x/selftest-migration.c   |   1 +
 s390x/sieve.c                |   2 +-
 s390x/unittests.cfg          |   4 +
 scripts/arch-run.bash        | 177 +++++++++++++++++++++++++----------
 x86/sieve.c                  |  52 +---------
 15 files changed, 240 insertions(+), 108 deletions(-)
 create mode 100644 common/selftest-migration.c
 create mode 100644 common/sieve.c
 create mode 120000 powerpc/selftest-migration.c
 create mode 120000 s390x/selftest-migration.c
 mode change 100644 => 120000 x86/sieve.c

-- 
2.42.0

