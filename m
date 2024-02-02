Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD4B17BA1
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 06:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857082; cv=none; b=R5msUqsRJflA7eyqTPotTtvHluWmsxa5SAjBE09FhpaMqojIRz1Nwonwej2dnsXJbzniN7KITfM11iIjsnlEf/zJtUCl4Kovk0wKwLqCz9RufCTu8YXM2siMS5TPc6YrClVokKVBtpzhs+UZ518rXteOc1y117UmmdrBXcn3iEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857082; c=relaxed/simple;
	bh=vCQQxqZeil0+LAP1vgV7VJsaQr3zxDKFtbKnoHbEAHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k/9cya2H6mCNOvyAJ95LV3qE+zJ6Ik7OviBHd2X1UaNSC/6EJn9FBaKTJ8D+rw4R4fDQihh9pH/dNuuJVVTQlkLz7nYY/tKcmaUgGCnlpEaFMAKKW+VGIBsdV6dEhRRWJEuHdKhNori+h0aYBF5xMhvJHEw8yaKOnRJIVllJowc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nc4N5Rvp; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nc4N5Rvp"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d958e0d73dso3877595ad.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 22:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857080; x=1707461880; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L/vDd2wgYFMcjNJFhzb4jvCxGWjleUG2mUvo4O12Bto=;
        b=nc4N5RvpF/+W5aKRl33/Pr67TfHnNimZMHe/ztz1bbZImvn3IhN0D0VJbBWDLHrKfu
         gFmtE7mjjV+gnUYyE1TMwsnAp1CC98QPXR5S2zqRG7c3gecBE3j6lHm4NG+L65pdPrFF
         kzZqrtZelpr0sGcMi7tNJXoRVeBCa/jjg29ubgx0OyWpNPfJwj7BWf0K3kOAZY6diNE4
         ZIbW+NCnxHdBLY1bjJM3zFHmlyTKOz1vYNub8g55FtE+vy5Z7AaEK83+Q0hPlHg4RUXl
         36AeLzdmIUjU907Via8f8DWl4OIOsSIy22CNNUvd1Rkuq1TMxTyRKP6S8iEEA769Vxjv
         frVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857080; x=1707461880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/vDd2wgYFMcjNJFhzb4jvCxGWjleUG2mUvo4O12Bto=;
        b=VFKzblut+O695bMmfI/f3OOBO8WDoRlL1iptZzHCONbaELdbJ9TErV1MbRg/d/7gBR
         UeexWgtP0ge9QXHzRGUPy6M0mHuSF+x1yYiszR/icQgm8ZFRe2gpJI/AkiBW1WgYGK68
         bSpmo1yf4iXVp9q5E4fhhxk7bN04jjaIJ9PWKUIZUlFTnYO+ynuW3+8JY/EL2B8N+HOx
         AI5ejjjsubMa/iPiYez0G+gdMYYgspaUn8eZbxqpWSoPNhscrHdBdv4Dg0bmEiKKqlSs
         EB8/4ChRiJuRhqEp2lR0AFVour8F0cQxrprJkWryKIqjUcIllIs5z1uJO/xv+EC2AGeY
         KIPQ==
X-Gm-Message-State: AOJu0YwQJeI8E2p4ZVL730k+tEtglFgtW5s01P0hcWa7NhJCwCXPhB8g
	0H9scWBpOhGeBByousoZpF9cebnPmO9L7ETfoFY+6FjgrRM/B0QO
X-Google-Smtp-Source: AGHT+IGvWMO95PcN7pxJxhTwc5bvzblFArUoEi14KMGjTdeCja7Ua1kX5fGYBB4wx1ubSAWO93T2uQ==
X-Received: by 2002:a17:902:d511:b0:1d3:f344:6b01 with SMTP id b17-20020a170902d51100b001d3f3446b01mr2424651plg.3.1706857080038;
        Thu, 01 Feb 2024 22:58:00 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUPuBFBBUlP1POmXUq/7h79MjiGh3Fb+mUy8N0UtV29d36M8bpCkahEq2fBI12IF+E2V3w2wkb1AY1J5N5Mq6dcaLElXt9euCwD1asMtGBMENTsh3t5qRBApH9FJ27tgAzBxPBOWVbeN6j11hEQBnq8Kq/gtoGDRUHPovJP7hSkwpRmKAtFnJj23Xwc80WxpIBcbcOUV3n5D1fLgw24RKKZeuGdKUg0zDQ0L3JhuH8IaHVQ49tNvfe15pQylzqD8MMSviLW6EJpNB/DoyUOkkoK5tsxuSw9lHUNsmEnp5VL/preOc20OLi5OINKuq2J+OPc47YeqUuthIys4aGZ8sl2UvynTs6wt6kBRSRWWEMGuqCzVn6rWU8ff3+rbGssrIqWwuoXklN4c8qymt7QvGw4skVzrFDlYLKgqcIbW5+3RKwhZhhZkKJUBIFnhKxaSc4pKaDkzsHezYbgD6ndnKL66CEeMswERnvxbjl1AddT5WEz4nIAsiOt0WXb67q+R7UCUihOY5LvYpI=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:57:59 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 0/9] Multi-migration support
Date: Fri,  2 Feb 2024 16:57:31 +1000
Message-ID: <20240202065740.68643-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There were not many comments on the previous post last year, so
this a rebase and resend. No significant change to migration patches,
but this rebases on Marc's better fix for cleaning auxinfo. So that
s390 patch is dropped, but added a minor fix for it instead :).

Multi migration works fine. And arm now has a reason to implement a
a getchar that can run more than 15 times.

Thanks,
Nick

Nicholas Piggin (9):
  (arm|powerpc|s390x): Makefile: Fix .aux.o generation
  arch-run: Clean up temporary files properly
  arch-run: Clean up initrd cleanup
  migration: use a more robust way to wait for background job
  migration: Support multiple migrations
  arch-run: rename migration variables
  migration: Add quiet migration support
  Add common/ directory for architecture-independent tests
  migration: add a migration selftest

 arm/Makefile.common         |   3 +-
 arm/sieve.c                 |   2 +-
 arm/unittests.cfg           |   6 ++
 common/selftest-migration.c |  34 +++++++
 common/sieve.c              |  51 ++++++++++
 lib/migrate.c               |  20 +++-
 lib/migrate.h               |   2 +
 powerpc/Makefile.common     |   3 +-
 powerpc/unittests.cfg       |   4 +
 s390x/Makefile              |   3 +-
 s390x/sieve.c               |   2 +-
 s390x/unittests.cfg         |   4 +
 scripts/arch-run.bash       | 181 ++++++++++++++++++++++++++----------
 x86/sieve.c                 |  52 +----------
 14 files changed, 260 insertions(+), 107 deletions(-)
 create mode 100644 common/selftest-migration.c
 create mode 100644 common/sieve.c
 mode change 100644 => 120000 x86/sieve.c

-- 
2.42.0

