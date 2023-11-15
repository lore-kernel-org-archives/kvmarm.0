Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD082836D
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 17:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T2d+DlyO"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-da0737dcb26so8902892276.3
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 09:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700068613; x=1700673413; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jvaWmO0FnVQSvQa+hPtEgtYlB7ewMwZZNTNrDNriGoM=;
        b=T2d+DlyOJoAwnuOIdpPO6WRjSHunS+bXmHN2HqVS64+GwRHa/0eTod1wPY+6EF8y/k
         bRJs0Oa3bbFbkI9cHCMMSuUH2ipx1X+yDVcJmkdjzVU0+rog5kh7hWfjFLs/x8Rg4gV+
         AVZ53+aqhDjMemojHMZR6FIXgPS1ww0g83+zf2iy0EJBIsod+sMVO9YIJK70BvjFNGYC
         gaxclPwdxDkHwl5LRwuG0I+Fcp0vVSdK6bglehtx0Cjm+a+0Tg8xR5tJuRU2J3yvQ6nH
         tYXRhJgCBgeHG6S2RZje6zr4GTrTrTgEIL3FshfpW8de3kBw2vq9jkCPnz85vyaElG/q
         dSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700068613; x=1700673413;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jvaWmO0FnVQSvQa+hPtEgtYlB7ewMwZZNTNrDNriGoM=;
        b=VYpp5tPD29lZQUp0BW0cnnixvsar7MZZnjjNUW3/33vNiS04rx0+rDDq6E/SDty01g
         /s2gBh/cZscsgY323q/1LtTA/OXS0nZTwtg3m51HH0UrKViHT7zqjUMklHyDu+aR1t3A
         pogqlCs0FUrHoU3OOKJi350T5jMZ7mEVYHSjipdJ2T4Irjfxij5GDz72OyEHu7j442O2
         qqIujmXraMb7XCioHpmhF29i1zg9VLhwDfjaXsi4OK0bErdzpMUhCgOVQEH8R8wxRF8/
         O/7mzgxqfTf4NwqVTEOsXPvz2WJQBpGtwlS1EUBjYAZJxjRqck1kWyUNwHicDx8liKwL
         hPBA==
X-Gm-Message-State: AOJu0Yxit1KkDn/NJLhnI+6q1hlWME+JRQEFJUn/wW0pA13nLkMeHcbh
	88qvwhRvYYEyGOxdtidMvphwm33w5T1rvZ3yTI4=
X-Google-Smtp-Source: AGHT+IGpTPHEt6mqVGX4OcHH3rw9Bhky+H2JiZ2u6YBAqgXzSwAP/9U1Wj0MXTkRRyqmx1wx/ooeavPE5/IIuxO7qck=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a25:24c7:0:b0:daf:660e:9bdb with SMTP
 id k190-20020a2524c7000000b00daf660e9bdbmr176609ybk.6.1700068613223; Wed, 15
 Nov 2023 09:16:53 -0800 (PST)
Date: Wed, 15 Nov 2023 17:16:30 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231115171639.2852644-2-sebastianene@google.com>
Subject: [PATCH v3 00/10] arm64: ptdump: View the second stage page-tables
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com, mark.rutland@arm.com, 
	akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	qperret@google.com, smostafa@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

This can be used as a debugging tool for dumping the second stage
page-tables.

When CONFIG_PTDUMP_STAGE2_DEBUGFS is enabled, ptdump registers 
'/sys/debug/kvm/<guest_id>/stage2_page_tables' entry with debugfs
upon guest creation. This allows userspace tools (eg. cat) to dump the
stage-2 pagetables by reading the registered file.

Reading the debugfs file shows stage-2 memory ranges in following format:
<IPA range> <size> <descriptor type> <access permissions> <mem_attributes>

Under pKVM configuration(kvm-arm.mode=protected) ptdump registers an entry
for the host stage-2 pagetables in the following path:
/sys/debug/kvm/host_stage2_page_tables/

The tool interprets the pKVM ownership annotation stored in the invalid
entries and dumps to the console the ownership information. To be able
to access the host stage-2 page-tables from the kernel, a new hypervisor
call was introduced which allows us to snapshot the page-tables in a host
provided buffer. The hypervisor call is hidden behind CONFIG_NVHE_EL2_DEBUG
as this should be used under debugging environment.

Link to the second version:
https://lore.kernel.org/all/20231019144032.2943044-1-sebastianene@google.com/#r

Link to the first version:
https://lore.kernel.org/all/20230927112517.2631674-1-sebastianene@google.com/

Changelog:

  v2 -> v3:
  * register the stage-2 debugfs entry for the host under
    /sys/debug/kvm/host_stage2_page_tables and in
    /sys/debug/kvm/<guest_id>/stage2_page_tables for guests.

  * don't use a static array for parsing the attributes description,
    generate it dynamically based on the number of pagetable levels

  * remove the lock that was guarding the seq_file private inode data,
    and keep the data private to the open file session.

  * minor fixes & renaming of CONFIG_NVHE_EL2_PTDUMP_DEBUGFS to
    CONFIG_PTDUMP_STAGE2_DEBUGFS

  v1 -> v2:
  * use the stage-2 pagetable walker for dumping descriptors instead of
    the one provided by ptdump.

  * support for guests pagetables dumping under VHE/nVHE non-protected

Thanks,

Sebastian Ene (10):
  KVM: arm64: Add snap shooting the host stage-2 pagetables
  arm64: ptdump: Use the mask from the state structure
  arm64: ptdump: Add the walker function to the ptdump info structure
  KVM: arm64: Move pagetable definitions to common header
  arm64: ptdump: Add hooks on debugfs file operations
  arm64: ptdump: Register a debugfs entry for the host stage-2 tables
  arm64: ptdump: Parse the host stage-2 page-tables from the snapshot
  arm64: ptdump: Interpret memory attributes based on runtime
    configuration
  arm64: ptdump: Interpret pKVM ownership annotations
  arm64: ptdump: Add support for guest stage-2 pagetables dumping

 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_pgtable.h          |  85 +++
 arch/arm64/include/asm/ptdump.h               |  27 +
 arch/arm64/kvm/Kconfig                        |  13 +
 arch/arm64/kvm/arm.c                          |   2 +
 arch/arm64/kvm/debug.c                        |   6 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   8 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  20 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 102 ++++
 arch/arm64/kvm/hyp/pgtable.c                  |  98 ++--
 arch/arm64/kvm/mmu.c                          |   2 +
 arch/arm64/mm/ptdump.c                        | 483 +++++++++++++++++-
 arch/arm64/mm/ptdump_debugfs.c                |  64 ++-
 13 files changed, 852 insertions(+), 59 deletions(-)

-- 
2.43.0.rc0.421.g78406f8d94-goog

