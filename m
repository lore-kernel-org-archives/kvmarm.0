Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3C179B7
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 04:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718167372; cv=none; b=sbxeMzE2BUWUys+1AukX0LD0PUUIZFwll03Oq40A7laXa9wXIDNu0GLgJPczVu2GFL43IJna5Z6WIWzLPg05OK0wFoJXmi93aInN+ikhnGq58cqxwzgtzLigzifuojWUiheezdmAkmWM3sWMH2tf6n8EtbG/2/lvkMM3Ic0bcZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718167372; c=relaxed/simple;
	bh=uybxDxR4RrOc+lmzdhnsTV2MydU3qxq3iFowjLn3ArI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QsxG4l6NXJk/b1LRmONh8FSn8xtRbc+fMZggCbnyrdpUo90caveRqa6IJXEy03ZVrMfVEV3jRJmTTVXww5Kq4G34r/fmWWxeN2Lv/rLd/ZeHzkDK53NUBg/tOZBLH3keoXfoZshLoZYO9Q52UXevpIvdoPTmGsDY98dfiX796Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgDB3j8U; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgDB3j8U"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f47f07acd3so58917865ad.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 21:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718167371; x=1718772171; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y8v3v+i8Ggw/AVGwDDCI9JHG5YYl3a/3EDerkme1e7c=;
        b=SgDB3j8UaBO8xlnBPKdYvc3kPwgJ/Ex9gzb0CVGn7IkbFYFWFMnSmBKsY/7qHvVoP5
         6IgPIQ6Ud1TbHVhNEd8YLh5YpOGhbgOB3X8eAwIHeCnEJNvbFWqHoB8dSjj4pmAtdKMX
         RvSXGah7jL9TKCPj5BJBkfQ4pCrWB+dMZ7XPsq5vDbYWP/5CzetlV1MoSFzf9DP+Xoxw
         p63IdURdNCxXnvh4dgFVj4yQ0O1+KsMpZe+qwQiDRoe4GUR3wS9KOFr92gRbedhhJ3UA
         ifUwHOsEl1zDsyarYVzbMRot6qTF9OqQ0m1Bll05tV1KtogM6bIPTL5VAtTP15IR7XMQ
         F+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718167371; x=1718772171;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y8v3v+i8Ggw/AVGwDDCI9JHG5YYl3a/3EDerkme1e7c=;
        b=czbsxtLlQ9vM+Pr3Ejm3Sp0uLxt5wNrXskS8dgC8XeLWeT+jC5SdZL1iRJNT/fTHo1
         N0oXYrlaxpJdzQ5x6IxA0GqCFIKnCve8E0UTZBRSpXIjvOJc4pDclbTVF5fVtxNHHvut
         xE/wnKpls1sh8aprcZsXhQCny84xzbvfQlwNy/cdw92ExoGVJYI7b2w2o8SIBCiEEyD5
         vLtuygMTsJAJtU5F715zQmU02Yt1eqUIh5cbXTc4Z8KE8mnR3O+XaG/Jm3CYTYSKEg6P
         qHJA2jXcCEsPG44+YC49mavDDSq6U3rClGH28jyjMhu+czJtEr/5EwWMHDv62Imd+ngk
         qkdA==
X-Forwarded-Encrypted: i=1; AJvYcCV6lwS1iwolMawRcELqDzf5U95ZgpeEjQkcchByV1oSHcBVMJ49GTN7RiTpckM8mz7Zitg/luQhbrEQsc/cwKfLZ4GNfTgy
X-Gm-Message-State: AOJu0Yw69zYYhK15NJ9BtXBUuyvf+kJESAUWRWlFR8Wq5ZzbZ34/HCix
	YFPTGW+mDezgW38Y3LkzYvTgACcWySXwSoNyluRjrKwMdr3gtmiP
X-Google-Smtp-Source: AGHT+IHpwHlh4iJRWgbNKg9wzqjgXtSTZ/ZgvwJw6UxQFuG3nQAI47SaA434g24rShYkZX8sK7hePg==
X-Received: by 2002:a17:903:234d:b0:1f7:3d0d:4c8 with SMTP id d9443c01a7336-1f83b569c9amr9508185ad.13.1718167370569;
        Tue, 11 Jun 2024 21:42:50 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f71017b639sm52957535ad.21.2024.06.11.21.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 21:42:49 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>,
	kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH] build: retain intermediate .aux.o targets
Date: Wed, 12 Jun 2024 14:42:32 +1000
Message-ID: <20240612044234.212156-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
in dependency chains that cause them to be made as intermediate files,
which get removed when make finishes. This results in unnecessary
partial rebuilds. If make is run again, this time the .aux.o targets
are not intermediate, possibly due to being made via different
dependencies.

Adding .aux.o files to .PRECIOUS prevents them being removed and solves
the rebuild problem.

s390x does not have the problem because .SECONDARY prevents dependancies
from being built as intermediate. However the same change is made for
s390x, for consistency.

Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/Makefile.common     | 2 +-
 powerpc/Makefile.common | 2 +-
 riscv/Makefile          | 2 +-
 s390x/Makefile          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f828dbe01..0b26a92a6 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -31,7 +31,7 @@ CFLAGS += -O2
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 
 # We want to keep intermediate files
-.PRECIOUS: %.elf %.o
+.PRECIOUS: %.elf %.o %.aux.o
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index b98f71c2f..16f14577e 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -30,7 +30,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 CFLAGS += -Wa,-mregnames
 
 # We want to keep intermediate files
-.PRECIOUS: %.o
+.PRECIOUS: %.o %.aux.o
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
diff --git a/riscv/Makefile b/riscv/Makefile
index 919a3ebb5..7207ff988 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -53,7 +53,7 @@ AUXFLAGS ?= 0x0
 KEEP_FRAME_POINTER := y
 
 # We want to keep intermediate files
-.PRECIOUS: %.elf %.o
+.PRECIOUS: %.elf %.o %.aux.o
 
 define arch_elf_check =
 	$(if $(shell ! $(READELF) -rW $(1) >&/dev/null && echo "nok"),
diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd64..d436c6e9a 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -85,7 +85,7 @@ CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -Wl,--build-id=none
 
 # We want to keep intermediate files
-.PRECIOUS: %.o %.lds
+.PRECIOUS: %.o %.aux.o %.lds
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
-- 
2.45.1

