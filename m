Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0857D657B0
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 07:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462116; cv=none; b=n/niFSxxfey4frVrP6Y5mSgz8oKPCqCeKHVLgSiYK/0HLlar34yUXSZywmmL+a5FUKFyC+bq3BKovya433R9YEkVprBYeXi5eSBBNQbKRk7vVCgxfpybLGd4LabLx5ciIqBHdYUkhlYFhbUsY9/PofHjhdmiUQWNWuqH2ysxTv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462116; c=relaxed/simple;
	bh=gY3xf0Lz5rDmuy2ZJ6dOxAu27NqM0PPCRNJY9WhIKWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ljcil/u2Y+bHp68rgvu5S53a3z76+F4nsuEjOM+odLk9YkCOProcBsswvjESrm/XgZ+e70wTq/t8me6BHgh+lDTkNCmO8nzph1i04pmoqhGNbOfhzILXoDJcTb5z52OryAm6hH960U4gnrzJWsRAkh0K8eSOOe59iPAoC6RU/Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RH1sKGNk; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RH1sKGNk"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d7393de183so4741435ad.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 23:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462114; x=1708066914; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZI6d9cux97L7dUT4TQMpq+dvoK2aI/bTyxDjBMmG0M=;
        b=RH1sKGNk0sJsQGoEtEre1f/QsnKz3N8eze834tybcRRgjacrZct66+K97baE90bbR7
         ICYcpWDaD5fX0akMxOk2+KKQf/stXXdXb9WuoEyCLO3fIoSpuZ8l98IVa41bW7bzehUt
         g2DY+HmPMcvL5d7SrbpznhaLxhKxw03Nl9HTXC0cZnRh0n+8vzK7Hn+p9jm3fOKADMgH
         kCplZMMMDoX696fsZKrX/qc2PXZHo94zhyQ8IjrSSpF5/k3DZ2Q2p2bK/a/qJEFbtB3i
         eB6M51TGxwwF4Qu6sLTy2XRetPEF5zlfhyR+bCI1Cu6g99Ob4Wiqd4WEQNOu5hC+r+WO
         Q3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462114; x=1708066914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZI6d9cux97L7dUT4TQMpq+dvoK2aI/bTyxDjBMmG0M=;
        b=bWEvj3PBP+84OCmHRSDfQKrnLDlZ2X6eKSMDDglH1L5XD0LogsdduRHwYQfoTlLLr/
         DXl2fXdzx7zHiu7kKQYHAMGxciWo5j7eN6awmFht3fdJrAlVfSRPmljzHNnQS1n3dtla
         en8yP87VfR5l623+pkvQYB6oxSuMYi0GXRIhjC9KTLn207nBQmxzuF5dY3ODhgO5utwQ
         boEa67YZD1IkUTmjL9eOIV6EacA4V8qJC3o922S1slhETTcr599qT7gWrLN91c7vPJbl
         s7AWXFtSYwX2uAoOp/W1b0m7qE05Q/+O3wXq9zZ0JIqB9bM3WM8SPd/k1hBEpzfZgVjB
         MxsQ==
X-Gm-Message-State: AOJu0Yx4iRD9GhSZAMMowWESFdwgVLATh8qlLHCTj5v2RUQlUrDMcplJ
	/4pyJvyAXnGi7f6TMhAI4Mh3qAAAK+NGXrxqLC92bhLqZxeRSHK4
X-Google-Smtp-Source: AGHT+IHZRJNVGE1nRp4CsG243g7N5RxTDUHurXHV9jgjH8FEhvyBctWgR3dk3ZSZYU5s1toRaGxOVQ==
X-Received: by 2002:a17:902:6503:b0:1d9:a609:dd96 with SMTP id b3-20020a170902650300b001d9a609dd96mr591187plk.41.1707462114175;
        Thu, 08 Feb 2024 23:01:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWeYPIvgSE2lAHsViOQ/LpTx47391Fz3bpGJ589w2egJPbjUjq85ZVYSEyRf6FY+QZ9VfxhQy7NlooFf3bg10JLQ9VCFNlzq+3YvXyU5KDDMHyaV9JY5oDbQ81EJsRCNqSRRhiqJjD0KqRKrpJefva/gBYT4U91Kb/XVK/pwNjW/PPokJ/rCp0OtV2BJGSFZEqwHj6Wb3rAHNXuXwd/TOlUfFgsV0wA2Ji2Vllh6jtx0TYw7Pt9PtDeoTjnQi0jBwGBb4ig7ICoKVddJdour7JIcNSx1s+6g4fztyQUXdpEm/xpYrahxb8lzH7qxQdrWHia7kG/rB4+r4iqgMSq6z0G/qmM3pLc+lmnI8bgkxaiQnCnt3y/0vq0PO6YUEXUzjdmOBzckaCxeLC72BWLaSOowU8btDpixf0GqlKmHXyIWAGqWzwvlQpq6wqIYPETCQyc9jK6yj0/uhG6J3+nPU0SkKhET9JfWPvHZIuHGxLTHwhiOKj5Jw5uTT+wN/tC1udxD3Wp+w/mk45v2ekyfkDatVvRH+p28o/ehHOB7Kv7OQxROZjamJS1
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:01:53 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v3 0/8] Multi-migration support
Date: Fri,  9 Feb 2024 17:01:33 +1000
Message-ID: <20240209070141.421569-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

I did look into doing a better job at handling timeouts in places
where the migration script can hang (the timeout command only kills
the qemu process, but there are other places the bash script itself
can still timeout). There are ways it might be possible (along the
lines of starting ( sleep N ; kill ) subshell in the backround), but
it's very tricky to handle all the details. Existing script has
timeout issues already, so this series doesn't add a fundamentally
new type of problem here.

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

 arm/Makefile.common          |   1 +
 arm/selftest-migration.c     |   1 +
 arm/sieve.c                  |   2 +-
 arm/unittests.cfg            |   6 ++
 common/selftest-migration.c  |  34 +++++++
 common/sieve.c               |  51 ++++++++++
 lib/migrate.c                |  20 +++-
 lib/migrate.h                |   2 +
 powerpc/Makefile.common      |   1 +
 powerpc/selftest-migration.c |   1 +
 powerpc/unittests.cfg        |   4 +
 riscv/sieve.c                |   2 +-
 s390x/Makefile               |   1 +
 s390x/selftest-migration.c   |   1 +
 s390x/sieve.c                |   2 +-
 s390x/unittests.cfg          |   4 +
 scripts/arch-run.bash        | 182 ++++++++++++++++++++++++++---------
 x86/sieve.c                  |  52 +---------
 18 files changed, 261 insertions(+), 106 deletions(-)
 create mode 120000 arm/selftest-migration.c
 create mode 100644 common/selftest-migration.c
 create mode 100644 common/sieve.c
 create mode 120000 powerpc/selftest-migration.c
 create mode 120000 s390x/selftest-migration.c
 mode change 100644 => 120000 x86/sieve.c

-- 
2.42.0

