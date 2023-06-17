Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F067FA
	for <kvmarm@lists.linux.dev>; Sat, 17 Jun 2023 01:49:54 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1b51780bed0so11237775ad.3
        for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 18:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966594; x=1689558594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bBnVoG0dGS8HTBN+3H6jiV3bbfD0jHuG3w6ZkOnSA/c=;
        b=m6wN6nNjJrKG1RjDZ0IS5eBwL1sYAM497YtCBU8l5cuoQ6gmIcX/HJAifPvY3FKSui
         xvJIhG/22EJmaTta+LJdxYzJGA+d6gOqwYP61Yas87mTPS6K+cKUQxV5qaPTAQ2t8+cy
         UX/m8kWykMhscVYPYJOOLrgyNtsf7Sqdth6xPXdOXf42IHaayoa8hjpcpKGAKIVx9yX1
         NkOX3C/EAdYAUXx/rhWh+r3C+EmCsXUxZFrUfD1CmaDxQVECALchMBYYIHiSsWLoTWAK
         1If6GyNvKLYBu+PESn1VtQNCNhY69yFjpUk199q0YwT8mKaWVe9l+yDRpGjwSoopqtus
         pg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966594; x=1689558594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bBnVoG0dGS8HTBN+3H6jiV3bbfD0jHuG3w6ZkOnSA/c=;
        b=VSKevAoUy/fbuOBOViaulKMRB1TeWdMwBPtRj3u1cO27deNup+D1Cmzen/6TvC9e8u
         DPs4+mulb9OLr4Ta7vS5yknBxQBOSib/52fZ0dEAkiaHYwYmt6CfNcXuzXwud5sdNzlK
         wcXJkpJm0E/GHHlvjGmf9gjHgrR+KgKXR2nYIC0SGdG4iS833661foNLnoOSHPVDqj+T
         mAlKwMPDU/F9TJip9pmH4ED80sPqg+PR4e8CcizWE13KFaE78aMtE8/1xsuLZ5j08uGL
         xVsew57WTDPAZfIqrpAZq4k99ilNPOBAA1BFHRGesG+UWEGCQc43U3yFlIQe061y1gkx
         jrqg==
X-Gm-Message-State: AC+VfDwIIU7uIPhrb7ZusoO2RsFawOI+hrbkvx6EM6TJxBTkVwxZ7oJB
	b9bIeKMBl8kLhChUvGvTPUI=
X-Google-Smtp-Source: ACHHUZ4cpPfFsO9W/eGdzgAztY0CAcJJ7yKSdodSvhnGM+FkRCdbajIl++ZLnxd673THR+rxqjLazg==
X-Received: by 2002:a17:903:2341:b0:1ad:f138:b2f6 with SMTP id c1-20020a170903234100b001adf138b2f6mr4392591plh.16.1686966594076;
        Fri, 16 Jun 2023 18:49:54 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:49:53 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 0/6] arm64: improve debuggability
Date: Sat, 17 Jun 2023 01:49:24 +0000
Message-Id: <20230617014930.2070-1-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

My recent experience in debugging ARM64 tests on EFI was not as fun as I
expected it to be.

There were several reasons for that besides the questionable definition
of "fun":

1. ARM64 is not compiled with frame pointers and there is no stack
   unwinder when the stack is dumped.

2. Building an EFI drops the debug information.

3. The addresses that are printed on dump_stack() and the use of GDB
   are hard because taking code relocation into account is non trivial.

The patches help both ARM64 and EFI for this matter. The image address
is printed when EFI is used to allow the use of GDB. Symbols are emitted
into a separate debug file. The frame pointer is included and special
entry is added upon an exception to allow backtracing across
exceptions.

Nadav Amit (6):
  arm: keep efi debug information in a separate file
  lib/stack: print base addresses on efi
  arm64: enable frame pointer and support stack unwinding
  arm64: stack: update trace stack on exception
  efi: Print address of image
  arm64: dump stack on bad exception

 arm/Makefile.arm        |  3 ---
 arm/Makefile.arm64      |  1 +
 arm/Makefile.common     |  8 ++++++-
 arm/cstart64.S          | 13 ++++++++++
 lib/arm64/asm-offsets.c |  3 ++-
 lib/arm64/asm/stack.h   |  3 +++
 lib/arm64/processor.c   |  1 +
 lib/arm64/stack.c       | 53 +++++++++++++++++++++++++++++++++++++++++
 lib/efi.c               |  3 +++
 lib/stack.c             | 31 ++++++++++++++++++++++--
 10 files changed, 112 insertions(+), 7 deletions(-)
 create mode 100644 lib/arm64/stack.c

-- 
2.34.1

