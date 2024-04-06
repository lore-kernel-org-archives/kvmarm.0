Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D711FBA55
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407133; cv=none; b=nGkh1z8tsGauaAf+jVPbghGZgfoe8V6Da1HLjJn2NvLi+pbvpp+n9EquQKvU12eBafVoOz961Eo1JXBVTyc7k18bCgG2G7aZGF9GzvJ5yUO5Us+2eHgid26V0vtHREulwEJBGC7sBpMbzN3+SRJewiS4FzcvpTQjiq3YiBqVMOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407133; c=relaxed/simple;
	bh=w46SXyYEMeeZD6g32zT8PhnLM/MxhZO53g/IEoHjQog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JlU61ifElROR9IjRSmpqnymwgpxQjdx0PIpcwwp9mDBgmDVumf6CKunjkoa71u7DtjK/ejIJ/s80YSbihpUc3ImN/GOqdfLJVqkra3Mbco/zXnBIJaXgaeYZmqJyUzyAgAAoackC2Vmpjwa8rnYIqfGKwPOiwJ/PSsJbIcVAY2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M0VHlPJ6; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M0VHlPJ6"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5cfd95130c6so2202934a12.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407131; x=1713011931; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7w2kaMdOJquHBKIGt0eh7rBKhuP+nEorD/7bYdg9VOI=;
        b=M0VHlPJ600YiVQ4rTDK/VGDzzQdkf78YIOvFZoS+3jtXSPcwXURUELRZlNG7LCtLW0
         gZWbzIz/5tGGl0GHAAEY38jDKJV5k9pbXOHNJ0nVfF8g8zfIwF+l57P8B3WTdBjuFVs/
         5jGgkjWtbsaFhDaUpULz2Gr1psDysVQHjc1fzQCEXNaNuDRMcRDbaGUAy8ks226ZMyxa
         7qAfd4bCMeGeafLzrLtlbvBmAIUkkf8lF67hYaO1L5zQl0OHPJ5KS7NHznRJNQ6ggl97
         Zzz7Kk7dJkBfG0RtGnQlYWOGJYt1bdS8fEFhjTA934TuS8NEHzuZUPDmoRHnZxyoD+Qb
         L+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407131; x=1713011931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7w2kaMdOJquHBKIGt0eh7rBKhuP+nEorD/7bYdg9VOI=;
        b=f7s1lHD/bpqcUOWa1yWewhZO435J0uTk3Fj75IKdrfMCluv3HyBCegOJrI1DSKrMXC
         RMRWtRJupqpIE4De3DAW/1G0Xwba2qKTUiQIOxLR/GJDLOer6C7tIAjDqv8fssb7uwhj
         78pDQOiPMyuj/LrSbxqq+8itmFsX8eCRsT8TxlxC7CDmlcJ8Lop4NFUFr6cZjdFtX3Fo
         jIRwM7pwHbWu2Y9sKtGLWivKyjfFLp9IH6xwPmRDr/LHewbjQhxT4SFOIjhpU3eC/9F/
         j8i9cGQC3cjxHoJNsRqKttb02JpbtJlIX9ynLdQVGBsXf4k0t4bermrANKbqGh/0zfX2
         S8bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbRrrQwQagEJbYUDhzkuVPzqQWifPpOg9J2S4aCKwACOzmf4+/krdlCiCJSqKyaGwTaxgrbTB9+BOKlZVH33JJtN4DHb8N
X-Gm-Message-State: AOJu0YyWYr9JwdbaHudFJKBGGZgZE24gLMxXeGjbOVHsF4LU48HW1nbD
	uU6VwTvcfElKp5YfjHQkRy8W+BWXWRhVYIfc0i1UZeq+sUb77G34
X-Google-Smtp-Source: AGHT+IH4r6r9YbNAgX9HgtfYp0aid5yQ4Qc22A3fJ45yWlgo2AyKwwzLl2pM3GDnNTbmVtMVsPs95w==
X-Received: by 2002:a05:6a20:4324:b0:1a7:5103:5520 with SMTP id h36-20020a056a20432400b001a751035520mr1027830pzk.43.1712407131082;
        Sat, 06 Apr 2024 05:38:51 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:38:50 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 00/14] add shellcheck support
Date: Sat,  6 Apr 2024 22:38:09 +1000
Message-ID: <20240406123833.406488-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tree here

https://gitlab.com/npiggin/kvm-unit-tests/-/tree/shellcheck

Again on top of the "v8 migration, powerpc improvements" series. I
don't plan to rebase the other way around since it's a lot of work.
So this is still in RFC until the other big series gets merged.

Thanks to Andrew for a lot of review. A submitted the likely s390x
bugs separately ahead of this series, and also disabled one of the
tests and dropped its fix patch as-per review comments. Hence 3 fewer
patches. Other than that, since last post:

* Tidied commit messages and added some of Andrew's comments.
* Removed the "SC2034 unused variable" blanket disable, and just
  suppressed the config.mak and a couple of other warnings.
* Blanket disabled "SC2235 Use { ..; } instead of (..)" and dropped
  the fix for it.
* Change warning suppression comments as per Andrew's review, also
  mention in the new unittests doc about the "check =" option not
  allowing whitespace etc in the name since we don't cope with that.

Thanks,
Nick

Nicholas Piggin (14):
  Add initial shellcheck checking
  shellcheck: Fix SC2223
  shellcheck: Fix SC2295
  shellcheck: Fix SC2094
  shellcheck: Fix SC2006
  shellcheck: Fix SC2155
  shellcheck: Fix SC2143
  shellcheck: Fix SC2013
  shellcheck: Fix SC2145
  shellcheck: Fix SC2124
  shellcheck: Fix SC2294
  shellcheck: Fix SC2178
  shellcheck: Fix SC2048
  shellcheck: Suppress various messages

 .shellcheckrc           | 30 ++++++++++++++++++++++++
 Makefile                |  4 ++++
 README.md               |  3 +++
 arm/efi/run             |  4 ++--
 configure               |  2 ++
 riscv/efi/run           |  4 ++--
 run_tests.sh            | 11 +++++----
 scripts/arch-run.bash   | 52 ++++++++++++++++++++++++++++++-----------
 scripts/common.bash     |  5 +++-
 scripts/mkstandalone.sh |  4 +++-
 scripts/runtime.bash    | 14 +++++++----
 11 files changed, 105 insertions(+), 28 deletions(-)
 create mode 100644 .shellcheckrc

-- 
2.43.0

