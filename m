Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F594158D66
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 08:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748362; cv=none; b=fmsCxm3Mnsmi0pIX9RXdmbMfWSgsqHg7buGlcTTOyB0rI21T9frSlvRuTzJL3Jo7BOFirmsSm5QUBdsP55/r5DSvnqKn5vG+mBaUikW0f2Npr3CZKtAuB2hZYDc9eHgv72yWlS+2UcyOnKz0HuLQojT5BJqOAisg8Lh6j32oF1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748362; c=relaxed/simple;
	bh=iiiPutiaBJgKluS4kN1J+0TxYRxwahlFzq4aFPJ1/3o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IH76Bfhhaz+lPi8/c7ub5OoPTYsHjzPRVvmjQi0oM5z2Z6BNBfuHtWJooGQ1zPnOrGIIpSFg/bihW8bZkjlFMYWkmoGfLNB9Ut/4sURTSFETVW7/d+V0ydbHUJyqgbysww4uskKM0BZdjktxpRKYmqMMeDxUDPMrnBSvAop74Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1lisNqDb; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1lisNqDb"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42808685ef0so48857485e9.2
        for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 01:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724748359; x=1725353159; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2R/uMuzBkAPSfO743QJi77GC+KNY5HWJMdAKzXDz1QI=;
        b=1lisNqDbmHu+xl4j/eKeecErXkaOHgUwgqFeE5ij/zXwjcSPX5IHU/kahejfHqxz9D
         8N1mM+ECIXnlMADdghBPlc6LpEJ9rhvTqoXAvDBpl8i2wn5Xsr9UMWbsE4c1sD36UZkw
         W3Fh5YzVHyXRR3eYR3vvb8Dr3PaJS6rWWwasJxAwQ5OCyf2gjzhBCa2zf3s2+Tf4R/hk
         xpvyuh1H8dt4GlV+hTSSHgu/bcB4lty7baGRLLKApuQRau7EEZVIiA1FLOlmNpUYz+Mc
         iSf85iQRRmjoQ8HrKAokzaj76FxoKB1mFBHTv6+zEkL7Uin4DxYv0LJb0WAVBx42id6w
         5q7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724748359; x=1725353159;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2R/uMuzBkAPSfO743QJi77GC+KNY5HWJMdAKzXDz1QI=;
        b=KZ1FsY0szwezgTAQgmPRBXjEsssIeGhrJoBQHukWXGmuZMOuOxp4+Hep90Mpb4/LFG
         jqxTAFNGCMDaVvOHneLEKo+2OARAQsVBUh1oAdNmYARolThQmxSMkltrz0yKlbivWLJM
         gToDdeWjsIf5dDKSTbjxnFmZMwjzNUt6afios4YtRtTYk6nC/ITpqarU07D0Pcjz9ML8
         kCUkNhiM8R1bUc7yZuGTjJEClQQEVHj1jdC/X3XEU7LflDJHGY6eeZatObd4FHc2DfC0
         051Xs/Co1pJPXnd2jKbkJOVqoA5vajQkxC5t9rx1Lr4UIFJEeYGr1MSBJ7yDH74R2PqI
         POHA==
X-Gm-Message-State: AOJu0YzmFRhglme9zJBw4TBoL841oadEgCabpy/W8v3KYqcr4Fmr8pV3
	/TanBJZ24jJ++uCfe8e5RqUvq7m9lhKqksN0crdGtYE2dD9zSSwdbA2E8HWdOLDHNiAkYrEIui/
	QU+/YSniL0HU5+GityCdKANU4SA==
X-Google-Smtp-Source: AGHT+IG8Nb0kiIV4KUtxyZ0hDxXhItC4j4vWNpP534O59ZbFZOpVJvQZLiNh/ZzymWNkZ/DziVSbfRy1whFpEi3GKAs=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:2296:b0:426:4920:2857 with
 SMTP id 5b1f17b1804b1-42b9ae488b8mr365075e9.8.1724748358550; Tue, 27 Aug 2024
 01:45:58 -0700 (PDT)
Date: Tue, 27 Aug 2024 08:45:43 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240827084549.45731-1-sebastianene@google.com>
Subject: [PATCH v9 0/5] arm64: ptdump: View the second stage page-tables
From: Sebastian Ene <sebastianene@google.com>
To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, 
	ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, 
	james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, rananta@google.com, 
	ryan.roberts@arm.com, sebastianene@google.com, shahuang@redhat.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi,


This series extends the ptdump support to allow dumping the guest
stage-2 pagetables. When CONFIG_PTDUMP_STAGE2_DEBUGFS is enabled, ptdump
registers the new following files under debugfs:
- /sys/debug/kvm/<guest_id>/stage2_page_tables
- /sys/debug/kvm/<guest_id>/stage2_levels
- /sys/debug/kvm/<guest_id>/ipa_range

This allows userspace tools (eg. cat) to dump the stage-2 pagetables by
reading the 'stage2_page_tables' file.
The output format has the following fields:
<IPA range> <size> <level> <access permissions> <mem_attributes>

Below is the output of a guest stage-2 pagetable dump running under Qemu.
After a VM is created, the following files are available:

# cat /sys/kernel/debug/kvm/256-4/stage2_levels 
4
# cat /sys/kernel/debug/kvm/256-4/ipa_range 
44
# cat /sys/kernel/debug/kvm/256-4/stage2_page_tables 
---[ Guest IPA ]---
0x0000000000000000-0x0000000001000000          16M 2
0x0000000001000000-0x0000000001020000         128K 3
0x0000000001020000-0x0000000001021000           4K 3   R W X AF    
0x0000000001021000-0x0000000001200000        1916K 3
0x0000000001200000-0x0000000040000000        1006M 2
0x0000000040000000-0x0000000080000000           1G 0
0x0000000080000000-0x0000000081200000          18M 2   R W   AF BLK
0x0000000081200000-0x0000000081a00000           8M 2   R W X AF BLK
0x0000000081a00000-0x0000000081c00000           2M 2   R W   AF BLK
0x0000000081c00000-0x0000000082200000           6M 2   R W X AF BLK
0x0000000082200000-0x0000000082400000           2M 2   R W   AF BLK
0x0000000082400000-0x0000000082800000           4M 2   R W X AF BLK
0x0000000082800000-0x0000000082a00000           2M 2   R W   AF BLK
0x0000000082a00000-0x0000000082c00000           2M 2
0x0000000082c00000-0x0000000083200000           6M 2   R W X AF BLK
0x0000000083200000-0x0000000083400000           2M 2
0x0000000083400000-0x0000000083a00000           6M 2   R W X AF BLK
0x0000000083a00000-0x000000008fe00000         196M 2
0x000000008fe00000-0x0000000090000000           2M 2   R W   AF BLK
0x0000000090000000-0x0000000099400000         148M 2
0x0000000099400000-0x0000000099600000           2M 2   R W X AF BLK
0x0000000099600000-0x000000009b600000          32M 2
0x000000009b600000-0x000000009be00000           8M 2   R W X AF BLK
0x000000009be00000-0x000000009c000000           2M 2   R W   AF BLK
0x000000009c000000-0x00000000c0000000         576M 2

Changelog:
v8 -> current:
 * squashed the last 3 patches and separated the Kconfig change as the
   last patch.
 * updated the commit message of the 3rd patch
 * printing level numbers instead of names as suggested by Mark
 * fixed one return code to ERR_PTR(-ENOMEM) as spotted by Vincent
 * dropped a barely empty header 'kvm_ptdump.h'
 * general cosmetic changes 

v7 -> v8:
 * applied Will's feedback and prefixed the exported structure names
   with ptdump_
 * dropped PTE_CONT and PTE_NG attribute parsing from Oliver's
   suggestion
 * fixed spurious BLK annotation reported by Vincent
 * repurposed `stage2_levels` debugfs file to show the number of the
   levels
 * tried changing the order of the patches:
   "5/6 Initialize the ptdump parser with stage-2 attributes" before
   exposing the debugfs file but ended up keeping the same order
   as this depends on the later one.

 v6 -> v7:
 * Reworded commit for this patch : [PATCH v6 2/6] arm64: ptdump: Expose
   the attribute parsing functionality
 * fixed minor conflicts in the struct pg_state definition
 * moved the kvm_ptdump_guest_registration in the
 * kvm_arch_create_vm_debugfs
 * reset the parse state before walking the pagetables
 * copy the level name to the pg_level buffer

 v5 -> v6:
 * don't return an error if the kvm_arch_create_vm_debugfs fails to
   initialize (ref.
https://lore.kernel.org/all/20240216155941.2029458-1-oliver.upton@linux.dev/)  
 * fix use-after-free suggested by getting a reference to the
   KVM struct while manipulating the debugfs files
   and put the reference on the file close.
 * do all the allocations at once for the ptdump parser state tracking
   and simplify the initialization.
 * move the ptdump parser state initialization as part of the file_open
 * create separate files for printing the guest stage-2 pagetable
   configuration such as: the start level of the pagetable walk and the
   number of bits used for the IPA space representation.
 * fixed the wrong header format for the newly added file
 * include missing patch which hasn't been posted on the v5:
   "KVM-arm64-Move-pagetable-definitions-to-common-heade.patch" 

 
Links to previous versions:
v8:
https://lore.kernel.org/all/20240816123906.3683425-1-sebastianene@google.com/  
v7:
https://lore.kernel.org/all/20240621123230.1085265-1-sebastianene@google.com/
v6:
https://lore.kernel.org/all/20240220151035.327199-1-sebastianene@google.com/
v5:
https://lore.kernel.org/all/20240207144832.1017815-2-sebastianene@google.com/

Thanks,
Sebastian

Sebastian Ene (5):
  KVM: arm64: Move pagetable definitions to common header
  arm64: ptdump: Expose the attribute parsing functionality
  arm64: ptdump: Use the ptdump description from a local context
  KVM: arm64: Register ptdump with debugfs on guest creation
  KVM: arm64: Introduce the PTDUMP_STAGE2_DEBUGFS config

 arch/arm64/include/asm/kvm_host.h    |   6 +
 arch/arm64/include/asm/kvm_pgtable.h |  42 +++++
 arch/arm64/include/asm/ptdump.h      |  42 ++++-
 arch/arm64/kvm/Kconfig               |  17 ++
 arch/arm64/kvm/Makefile              |   1 +
 arch/arm64/kvm/arm.c                 |   1 +
 arch/arm64/kvm/hyp/pgtable.c         |  42 -----
 arch/arm64/kvm/ptdump.c              | 247 +++++++++++++++++++++++++++
 arch/arm64/mm/ptdump.c               |  66 ++-----
 9 files changed, 373 insertions(+), 91 deletions(-)
 create mode 100644 arch/arm64/kvm/ptdump.c

-- 
2.46.0.295.g3b9ea8a38a-goog

