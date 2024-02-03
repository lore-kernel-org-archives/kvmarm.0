Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E240625
	for <kvmarm@lists.linux.dev>; Sat,  3 Feb 2024 00:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918962; cv=none; b=KadqzqqNpeJxJH3+Kn8HNgyfWsTC5Eml6WNesWGvh7mHkkyaV9h1ynSO2ItNGOIpTRvfM706Qy34+ItKabdxTqdihkkkni3mKv9hzz46Z56Z8b2farS7gmA+GCH6n6nGH4QSEsUG40PaYMM2usgd0k1ho7mrScYIYUDaM/TIiPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918962; c=relaxed/simple;
	bh=x1BTam7mSj4YBuat3i1LceUOU7iyCLkuBarnLQ8SIT8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nwZL0ydx0klgqXDr6O865vZ1AHoJrut0YzFuW7/6y3pPAYiwURdgjxuaZBeR1X6DtA00cvdFMz9eS11YWQ2Dffp1vHSOsG52+7SakMIT562KFq5Xw/YlxasgyZXMnQneFxP1GOKwipgjmf7RMubCbBrXcc8oCNZ52+Lc0irVd3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J4Ciu+JF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J4Ciu+JF"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so2914633a12.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 16:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918961; x=1707523761; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tvzfq6Tb+/LmzZGCY47OcGl4Yg3FqwT4x8FVTh6/pw0=;
        b=J4Ciu+JFZiERrGEaRa5IKK9Rk3itI31jEUJw3TqqQM2Lt6y6kwM0+3QZau7uFFm39V
         xYcPvDfwswa+rCo0IUwjWMxGR6pQXJwRc02qmpj2x9lHvHzTYQLFhsD4Se5B5FYvESsO
         G8rQ4yZUeF4BZsWZz1bnNr+QCcQEVZHvCAWbYWAFJ8piZHTTpeAhbt4FgrFc7RqsZ3/h
         J7r03gAjEuyim2nOKa0+thBva2teIhsQrGB5M1QRRu8icmTR4B0kS2hrTZAB/22kd+Ov
         gqDgGAUvYdyzkbus09VTSA2mni1e0UjR1m9+daJzWBDARHF2MKr5J2g2k9sUT0K4wrTT
         MfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918961; x=1707523761;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tvzfq6Tb+/LmzZGCY47OcGl4Yg3FqwT4x8FVTh6/pw0=;
        b=fuT9FyrhLyYYRaZEjxa+3WSYCNBCK791ZvuE3Zywdi3cCp1OpwkmZXMZTKyt+MOYY2
         W/iv07CfycKfyIJYfNRluyfWxt8b2ZmnCX0+6NWTBJ5DzZDaRe6wg873Tzdrpn3zpK2u
         4icVULSNzOlJhP7KSQuOBRWMl+3KverbGFZAelaziUBvK9V4Sfm4aTZiNW3p1OYksnYY
         x3qQygpyT5Sy/BCLm7bjwkDsh4gsGeWFQOI1dC9vjNpOOvEbzkBgfNlWOKCpWyzVsqlc
         Ph2YZ3UfyGYo3rWCgLnk1T3eJBiimWSo7smLecb1Y+HTSYkJCtyi4wYmeskAS9pFZ23P
         kW4w==
X-Gm-Message-State: AOJu0Yxgttx4Mg/JHwnJW3pp2qAyOoX/ZfmxvYC5GlK2SwWCLDIvRsja
	kTV7lzrwNzVS6GkCQNQlthorDIsvRbjtpnvr3pqY3UppPO+PZcr6vkfHlJm8KAbZyZcrAlBUz5s
	YWg==
X-Google-Smtp-Source: AGHT+IEqzXCmN6ReYMmNGcuC8mmtBhOi0vEe5B/tBx3edOgmg4Vw4BtLnbB387naOpc+iWQYiMA/3I2Kvpo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:670b:0:b0:5d7:9b27:8ad4 with SMTP id
 u11-20020a65670b000000b005d79b278ad4mr18346pgf.3.1706918960728; Fri, 02 Feb
 2024 16:09:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:06 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-1-seanjc@google.com>
Subject: [PATCH v8 00/10] KVM: selftests: Add SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a basic SEV smoke test.  Unlike the intra-host migration tests, this
one actually runs a small chunk of code in the guest.

v8:
 - Undo the kvm.h uAPI breakage.
 - Take advantage of "struct vm_shape", introduced by the guest_memfd
   selftests, to simply tracking the SEV/SEV-ES subtypes.
 - Rename the test to "sev_smoke_test" instead of "sev_all_boot_test",
   as the "all" is rather nonsensical, and the test isn't booting anything
   in the traditional sense of the word.
 - Drop vm->protected and instead add an arch hook to query if the VM has
   protected memory.
 - Assert that the target memory region supports protected memory when
   allocating protected memory.
 - Allocate protected_phy_pages for memory regions if and only if the VM
   supports protected memory.
 - Rename kvm_host.h to kvm_util_arch.h, and move it to selftests/kvm where
   it belongs.
 - Fix up some SoB goofs.
 - Convert the intrahost SEV/SEV-ES migration tests to use common ioctl()
   wrappers.

V7
 * https://lore.kernel.org/all/20231218161146.3554657-1-pgonda@google.com
 * See https://github.com/sean-jc/linux/tree/x86/sev_selftests_for_peter.
 * I kept is_pt_protected because without it the page tables are never
 readable. Its used for the elf loading in kvm_vm_elf_load().

V6
 * Updated SEV VM create function based on Seanjc's feedback and new
   changes to VM creation functions.
 * Removed pte_me_mask based on feedback.
 * Fixed s_bit usage based on TDX
 * Fixed bugs and took Ackerly's code for enc_region setup code.

V5
 * Rebase onto seanjc@'s latest ucall pool series.
 * More review changes based on seanjc:
 ** use protected instead of encrypted outside of SEV specific files
 ** Swap memcrypt struct for kvm_vm_arch arch specific struct
 ** Make protected page table data agnostic of address bit stealing specifics
    of SEV
 ** Further clean up for SEV library to just vm_sev_create_one_vcpu()
 * Due to large changes moved more authorships from mroth@ to pgonda@. Gave
   originally-by tags to mroth@ as suggested by Seanjc for this.

V4
 * Rebase ontop of seanjc@'s latest Ucall Pool series:
   https://lore.kernel.org/linux-arm-kernel/20220825232522.3997340-8-seanjc@google.com/
 * Fix up review comments from seanjc
 * Switch authorship on 2 patches because of significant changes, added
 * Michael as suggested-by or originally-by.

V3
 * Addressed more of andrew.jones@ in ucall patches.
 * Fix build in non-x86 archs.

V2
 * Dropped RFC tag
 * Correctly separated Sean's ucall patches into 2 as originally
   intended.
 * Addressed andrew.jones@ in ucall patches.
 * Fixed ucall pool usage to work for other archs

V1
 * https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/

Ackerley Tng (1):
  KVM: selftests: Add a macro to iterate over a sparsebit range

Michael Roth (2):
  KVM: selftests: Make sparsebit structs const where appropriate
  KVM: selftests: Add support for protected vm_vaddr_* allocations

Peter Gonda (5):
  KVM: selftests: Add support for allocating/managing protected guest
    memory
  KVM: selftests: Explicitly ucall pool from shared memory
  KVM: selftests: Allow tagging protected memory in guest page tables
  KVM: selftests: Add library for creating and interacting with SEV
    guests
  KVM: selftests: Add a basic SEV smoke test

Sean Christopherson (2):
  KVM: selftests: Extend VM creation's @shape to allow control of VM
    subtype
  KVM: selftests: Use the SEV library APIs in the intra-host migration
    test

 tools/testing/selftests/kvm/Makefile          |   2 +
 .../kvm/include/aarch64/kvm_util_arch.h       |   7 +
 .../selftests/kvm/include/kvm_util_base.h     |  50 ++++++-
 .../kvm/include/riscv/kvm_util_arch.h         |   7 +
 .../kvm/include/s390x/kvm_util_arch.h         |   7 +
 .../testing/selftests/kvm/include/sparsebit.h |  56 +++++---
 .../kvm/include/x86_64/kvm_util_arch.h        |  23 ++++
 .../selftests/kvm/include/x86_64/processor.h  |   8 ++
 .../selftests/kvm/include/x86_64/sev.h        | 110 +++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  67 +++++++--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  48 +++----
 .../testing/selftests/kvm/lib/ucall_common.c  |   3 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  32 ++++-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 128 ++++++++++++++++++
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |  67 +++------
 .../selftests/kvm/x86_64/sev_smoke_test.c     |  58 ++++++++
 16 files changed, 570 insertions(+), 103 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_smoke_test.c


base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb
-- 
2.43.0.594.gd9cf4e227d-goog

