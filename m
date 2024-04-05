Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C894179BD
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307668; cv=none; b=dKpeSmpHwLxibCYeB42lNEmvwgjBzmvhCOB/q5LDi8s4793UeGBbX2yXtrfyQZgmQrm8/7lPvbIUEdXSJI4f09KgKVKpTR9rPiPZBxuqMA5EvvSVt1XXWWE5/o426H8vQZb1hSt6H++o95O/1cPSVLIT4gf3QhxbUsFHWRXijYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307668; c=relaxed/simple;
	bh=2DLlYhed/nh73dIMIHSWhwKFVemru08OyxDmfqOJgKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EVS0XRD31OZvZ0DUHhHGSHtxuECeavMauLVw37b+tNay4yOs00rBH7t3AZaxQbpEukHqLnkbzob89JqoGbI3u5VdhrtpVtQx0H3urst+Rr2xFIhFJs5qfnvEYKgA3zcFsvIkVl1rxZVtVbWEfiewPIy7EZv73QbzQBQra/qpSF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9mSVK9d; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9mSVK9d"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ed04c91ffcso52994b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307666; x=1712912466; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wI4DwimW0m+Dm8ZQCp4DenGm21I2AM0p3NfyF7YdsYM=;
        b=O9mSVK9dmuMxybFGhjGnwLdP5fWPzwTu8zvhbINHzlwn1xiMtLHbIbw1OozLxG9Hn0
         m3u80MbuDbv0mX1T22nLGLT+vzZw2rT1GHsH6Mzm1qdYpqohRbXVavyQi6Tv+0gVV488
         5BZvDgje9oPHwj4RtCcqatCQ6HpSTjoU8WhEWHDBTYV5FmNZqO+G1pDkE20+08voU8zY
         FCLnl7XKhBFWgzP6NWy7oi6WbSzu9VDO8Wb35VD7N8bJUBksNQ7oPpn+A9c8fa7jLGxY
         93/f5ntsPPLVoHc7db/RUuHm5eupbhr385ui9xH2HBW/P+dm+Aawfr25zcu8Vn1Lgoaz
         anYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307666; x=1712912466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wI4DwimW0m+Dm8ZQCp4DenGm21I2AM0p3NfyF7YdsYM=;
        b=woV+AzjR8wZwgtO98afUl5RchoJ+JRexO2FLEb+FQX9dty+30Qq9lKCU5dXsoQzG3t
         PwOFomBSd3BudV7yw3V4zQlhm2BX5lDzsP2spJJOjpHysFcrAuDcFV806cN/+P+1ftid
         tFMIzj9JoS5FUDBs9hgNyNx8NCWItXyaxUv6ZRRjTmAKTBY704N+eZt6SPsEj98NlGk2
         uOZSnMpnVYPOACT2/xuOgBdAdZiijtANigEtnNuoJ/CqEyCeZUCE7FbaRZYiaRxOGNiu
         oHFxEK/uXFNKmQ7+ujMOWtzLhmea39cEo7Tg/v4e30AABnPliL+k7HevGRykAFcYId+C
         T7lA==
X-Forwarded-Encrypted: i=1; AJvYcCWctUnK+ycj+wPO6ZjZuaKgdq1b5vUoeJ0zlk6FOlOVKjtx0PwdHh2lijq/s99tzSTcAeXL190W5bLG1pVlwbOyTg4u068u
X-Gm-Message-State: AOJu0Yzha7XpG8OLnnGisFf6aDi6RHotJUPKUDV9ZOQRuEZ8CwXBTHP6
	40i0Hdstn8fTNIVhgLoftNv5eR/hKvMdxQGp36WvFwMBW7Cix5AK
X-Google-Smtp-Source: AGHT+IGlcBi2VUkohcnGRD3fzDjABuKFi3W10RhRfQ1OuAg3W7+E3pA6bb2h+PqEKmLJKinBlGe9vA==
X-Received: by 2002:a05:6a20:2d28:b0:1a3:57b4:ed1c with SMTP id g40-20020a056a202d2800b001a357b4ed1cmr1173245pzl.25.1712307666319;
        Fri, 05 Apr 2024 02:01:06 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:05 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
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
Subject: [kvm-unit-tests RFC PATCH 00/17] add shellcheck support
Date: Fri,  5 Apr 2024 19:00:32 +1000
Message-ID: <20240405090052.375599-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I foolishly promised Andrew I would look into shellcheck, so here
it is.

https://gitlab.com/npiggin/kvm-unit-tests/-/tree/powerpc?ref_type=heads

This is on top of the "v8 migration, powerpc improvements" series. For
now the patches are a bit raw but it does get down to zero[*] shellcheck
warnings while still passing gitlab CI.

[*] Modulo the relatively few cases where they're disabled or
suppressed.

I'd like comments about what should be enabled and disabled? There are
quite a lot of options. Lots of changes don't fix real bugs AFAIKS, so
there's some taste involved.

Could possibly be a couple of bugs, including in s390x specific. Any
review of those to confirm or deny bug is appreciated. I haven't tried
to create reproducers for them.

I added a quick comment on each one whether it looks like a bug or
harmless but I'm not a bash guru so could easily be wrong. I would
possibly pull any real bug fixes to the front of the series and describe
them as proper fix patches, and leave the other style / non-bugfixes in
the brief format.  shellcheck has a very good wiki explaining each issue
so there is not much point in rehashing that in the changelog.

One big thing kept disabled for now is the double-quoting to prevent
globbing and splitting warning that is disabled. That touches a lot of
code and we're very inconsistent about quoting variables today, but it's
not completely trivial because there are quite a lot of places that does
rely on splitting for invoking commands with arguments. That would need
some rework to avoid sprinkling a lot of warning suppressions around.
Possibly consistently using arrays for argument lists would be the best
solution?

Thanks,
Nick

Nicholas Piggin (17):
  Add initial shellcheck checking
  shellcheck: Fix SC2223
  shellcheck: Fix SC2295
  shellcheck: Fix SC2094
  shellcheck: Fix SC2006
  shellcheck: Fix SC2155
  shellcheck: Fix SC2235
  shellcheck: Fix SC2119, SC2120
  shellcheck: Fix SC2143
  shellcheck: Fix SC2013
  shellcheck: Fix SC2145
  shellcheck: Fix SC2124
  shellcheck: Fix SC2294
  shellcheck: Fix SC2178
  shellcheck: Fix SC2048
  shellcheck: Fix SC2153
  shellcheck: Suppress various messages

 .shellcheckrc           | 32 +++++++++++++++++++++++++
 Makefile                |  4 ++++
 README.md               |  2 ++
 arm/efi/run             |  4 ++--
 riscv/efi/run           |  4 ++--
 run_tests.sh            | 11 +++++----
 s390x/run               |  8 +++----
 scripts/arch-run.bash   | 52 ++++++++++++++++++++++++++++-------------
 scripts/common.bash     |  5 +++-
 scripts/mkstandalone.sh |  4 +++-
 scripts/runtime.bash    | 14 +++++++----
 scripts/s390x/func.bash |  2 +-
 12 files changed, 106 insertions(+), 36 deletions(-)
 create mode 100644 .shellcheckrc

-- 
2.43.0

