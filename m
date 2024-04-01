Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A47E56B89
	for <kvmarm@lists.linux.dev>; Mon,  1 Apr 2024 23:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014199; cv=none; b=MQ4JB5Jpr5hTY5TMh0W/5GVkOC88Cj2atL3yex8ob0yyGvsis4LOPvlrvRRSPyKIgdbfFUfjt0flV3Xf54zIQjXmPLZYpteq1zTawbR0HQtT5QFfkXV1X+z8HeNqejAHZk08zVO+BFdvupn6oQM6JWF3dftFDTyZpPGV1YfSV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014199; c=relaxed/simple;
	bh=LIU3srPkuAU2Il0Ayu4Wz3ZF0a3r6V03GyttaxoyE9Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WAKSLWHGjbbCcaL2cgaznW14qdGZEAcmhLGU8lyhwn2NxFa/p7M1WllSRGHlDnAQprARgEuTGFzcwITD2t7q8KXJY0+aeavmfTbEHFbAXXkVq5qXXRGhD4N8c0bbPfHHpcX3sH8g3XlsNpJ4iybeL5QkUGvOWMKgWyUkDfYthM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZJ5k4KU1; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZJ5k4KU1"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a4ee41269so83563807b3.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Apr 2024 16:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014196; x=1712618996; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3wg9CCGpIdLpfDRqh60QLQofCQe0biAtvSj1Gdo5bk8=;
        b=ZJ5k4KU1kOYY0g55WDBNXkY7C9ttBj3FhiE5zv5QoOVMZwW/iR38VdOjdchVvUrvAU
         ByrLKROKuXjmZq/bCy3r3tQB/HoEhL4ygCJHAlMfLf+iOy8T8AXoGJQHFqsJ/azaVW5C
         ZdfZW9NzPva1JRLJPosN5H8+a7Eugq3e4H2MM7zuQlzIYYf2jcTAFudpkycJGznlCVwA
         T+MivKmpBVYTACU8pwPJjJ9dE/79QC0Gml/Y8KgFpUVdXCAA6bASkkbbKJ8IgXDo4uzf
         KWM2JANCci/JE6DIw25vi1XPN/SljVX/BIqw7P5cQMYCEHp5eT2L9hNepBJ1pJbTBAVU
         +UzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014196; x=1712618996;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wg9CCGpIdLpfDRqh60QLQofCQe0biAtvSj1Gdo5bk8=;
        b=PwlbbeMaCjSnbJSeQ8/Ewtx4DXVr1xAFZNzva8h7OjaEa5bRrpU6k7uddMPIsEA4BP
         nvZsYDnhF5YUrqv0pwkIZ6BSBNyrnhxkOs05n3CDxGZ2yI9PaeGyinQBknoqxH5G7CFs
         o08hqm5272HFgW72PkgPOwoCFtRGRxdOXfSPi0sY90gk5Q4goxeI810r6wS8vGHLfHKG
         S7i8vaa0N9QopALIMMgWpHNAOd8nV6GXtfxXLX0Uqj0jDTo+Zd7o9uy7fxbTd0y4sg/n
         0dBLvMSDQMAC6aw7tWoJdYNxB/Egdzqid6gwZHQKOVmgOJn3/nbOiXqdrSZ8XQD6pzR0
         fcVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXY2Uiyz2rqiCMvabzpkyUyEgoLaT0jSA8vL+6y1yYWRN4b8ESgoTtxISUfgBUP+tQrkGvKw05/2sQP+IuWlvJKg8CtasQd
X-Gm-Message-State: AOJu0YzwLKrotxi1Exo7wnM+HQnusbT7/8wXRfTpTKEhpRV7cUxCOKzK
	o+oduurDqffjArG43zIy5zw+Hbln9jodVRXf2EIOTQYT8AfWc43gkuuFYDvYHd/XwgE/dq3P5dF
	YkP7RQb7KiHl+dIRyfA==
X-Google-Smtp-Source: AGHT+IGQKV963bGOmZkg1qJdb4wkJ3JL7Okh/SQUhgB3vOnWcX/gauefdkact4kTuSTRZOisDp+cn6EF/9Mo2eKk
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:f83:b0:614:e20c:d423 with SMTP
 id df3-20020a05690c0f8300b00614e20cd423mr823185ywb.10.1712014196503; Mon, 01
 Apr 2024 16:29:56 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:39 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-1-jthoughton@google.com>
Subject: [PATCH v3 0/7] mm/kvm: Improve parallelism for access bit harvesting
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

This patchset adds a fast path in KVM to test and clear access bits on
sptes without taking the mmu_lock. It also adds support for using a
bitmap to (1) test the access bits for many sptes in a single call to
mmu_notifier_test_young, and to (2) clear the access bits for many ptes
in a single call to mmu_notifier_clear_young.

With Yu's permission, I'm now working on getting this series into a
mergeable state.

I'm posting this as an RFC because I'm not sure if the arm64 bits are
correct, and I haven't done complete performance testing. I want to do
broader experimentation to see how much this improves VM performance in
a cloud environment, but I want to be sure that the code is mergeable
first.

Yu has posted other performance results[1], [2]. This v3 shouldn't
significantly change the x86 results, but the arm64 results may have
changed.

The most important changes since v2[3]:

- Split the test_clear_young MMU notifier back into test_young and
  clear_young. I did this because the bitmap passed in has a distinct
  meaning for each of them, and I felt that this was cleaner.

- The return value of test_young / clear_young now indicates if the
  bitmap was used.

- Removed the custom spte walker to implement the lockless path. This
  was important for arm64 to be functionally correct (thanks Oliver),
  and it avoids a lot of problems brought up in review of v2 (for
  example[4]).

- Add kvm_arch_prepare_bitmap_age and kvm_arch_finish_bitmap_age to
  allow for arm64 to implement its bitmap-based aging to grab the MMU
  lock for reading while allowing x86 to be lockless.

- The powerpc changes have been dropped.

- The logic to inform architectures how to use the bitmap has been
  cleaned up (kvm_should_clear_young has been split into
  kvm_gfn_should_age and kvm_gfn_record_young) (thanks Nicolas).

There were some smaller changes too:
- Added test_clear_young_metadata (thanks Sean).
- MMU_NOTIFIER_RANGE_LOCKLESS has been renamed to
  MMU_NOTIFIER_YOUNG_FAST, to indicate to the caller that passing a
  bitmap for MGLRU look-around is likely to be beneficial.
- Cleaned up comments that describe the changes to
  mmu_notifier_test_young / mmu_notifier_clear_young (thanks Nicolas).

[1]: https://lore.kernel.org/all/20230609005943.43041-1-yuzhao@google.com/
[2]: https://lore.kernel.org/all/20230609005935.42390-1-yuzhao@google.com/
[3]: https://lore.kernel.org/kvmarm/20230526234435.662652-1-yuzhao@google.com/
[4]: https://lore.kernel.org/all/ZItX64Bbx5vdjo9M@google.com/

James Houghton (5):
  mm: Add a bitmap into mmu_notifier_{clear,test}_young
  KVM: Move MMU notifier function declarations
  KVM: Add basic bitmap support into kvm_mmu_notifier_test/clear_young
  KVM: x86: Participate in bitmap-based PTE aging
  KVM: arm64: Participate in bitmap-based PTE aging

Yu Zhao (2):
  KVM: x86: Move tdp_mmu_enabled and shadow_accessed_mask
  mm: multi-gen LRU: use mmu_notifier_test_clear_young()

 Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
 arch/arm64/include/asm/kvm_host.h             |   5 +
 arch/arm64/include/asm/kvm_pgtable.h          |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/mmu.c                          |  23 ++-
 arch/x86/include/asm/kvm_host.h               |  20 ++
 arch/x86/kvm/mmu.h                            |   6 -
 arch/x86/kvm/mmu/mmu.c                        |  16 +-
 arch/x86/kvm/mmu/spte.h                       |   1 -
 arch/x86/kvm/mmu/tdp_mmu.c                    |  10 +-
 include/linux/kvm_host.h                      | 101 ++++++++--
 include/linux/mmu_notifier.h                  |  93 ++++++++-
 include/linux/mmzone.h                        |   6 +-
 include/trace/events/kvm.h                    |  13 +-
 mm/mmu_notifier.c                             |  20 +-
 mm/rmap.c                                     |   9 +-
 mm/vmscan.c                                   | 183 ++++++++++++++----
 virt/kvm/kvm_main.c                           | 100 +++++++---
 18 files changed, 509 insertions(+), 128 deletions(-)


base-commit: 0cef2c0a2a356137b170c3cb46cb9c1dd2ca3e6b
-- 
2.44.0.478.gd926399ef9-goog

