Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88685129EC8
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CdWF/FGe"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-40c2dd83bc4so25990635e9.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 05:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702907987; x=1703512787; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P8r4T7nvDO4uBvNXHdAFoty11B3AGf8jb80RWrKCDHk=;
        b=CdWF/FGewptabuOHvnJ+ImWUyka9DaP11B3yynlmQJkFdIbzBTP71GGwtPmAswPDgl
         0m6IjHNPCIX82AfdsCTB5XZUSvpRMtHEP1kWFm7UBaqPfPPkhZTrdtrobuFuoIQSs9Zc
         O73liDgQsrhOGfW+lqCp1cS5FL+dgCF7+DZSXULjbLndDsnshI3QwsRT4VcrVvKhDkrQ
         XojKOkShQrAh0FeNm8LWlaTskcKv63g7WOxrYZkEeTVeZYbmbl6b1kBd6FTwPTUaeuIJ
         5K3776/bbs5hhTfs7HS8ilHzFQJ08XXY/UWOQDBtO+S9w5nlvUGQKpcaSKpcHftqHmYk
         P2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702907987; x=1703512787;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P8r4T7nvDO4uBvNXHdAFoty11B3AGf8jb80RWrKCDHk=;
        b=dqsEVo/u+fKqwiepUka35yMf2UsSMeqgPLU0hcVzYJbOnLPPHerW49hQx0GoZYaJVD
         2eTHvefoKdB9qQcJAtqCs4JLNza0wP723O7Q0yLn2AXNmM6o9Ru8AvTrX1TEJVKPueam
         4PAbfJD9uC6Ga9Vh7YU1UX/xmLiNQhsl0ahC4bAAsx1G7vzMkxmGT4taJd9Iq9rBk+PX
         je/vpyB0wwebBO0BAaJWpuYGNXlWqCY4uLLy8PpedCQtfEoj1RxiTIfFooeENxxiiRLZ
         FDVxocW/ppwmBaBxmamutPO9tU3d+8qxu8GXaadFbk8Rfc9psIDxepNAYzA+fO1SmSw+
         CASg==
X-Gm-Message-State: AOJu0Yz60cQf3p586to/SKnE1OHnPk10uoruBRvr7IjFnhUg+1l/R0ns
	nbaBLYsIiFMXmgmdQA93ppcxqLOVbe1P3gvaDMw=
X-Google-Smtp-Source: AGHT+IGh1SOpBCEZN0uVflQ0cEhgKsbz2gBXoiY11ZQ7CD2sg8aW63UXfV3LhaVdXurCvs+8akIVUFrnqZUBKBaeib8=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:2109:b0:408:3b1a:f9cd with
 SMTP id u9-20020a05600c210900b004083b1af9cdmr303600wml.8.1702907986774; Mon,
 18 Dec 2023 05:59:46 -0800 (PST)
Date: Mon, 18 Dec 2023 13:58:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231218135859.2513568-2-sebastianene@google.com>
Subject: [PATCH v4 00/10] arm64: ptdump: View the second stage page-tables
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

Link to the third version:
https://lore.kernel.org/all/20231115171639.2852644-2-sebastianene@google.com/

Link to the second version:
https://lore.kernel.org/all/20231019144032.2943044-1-sebastianene@google.com/#r

Link to the first version:
https://lore.kernel.org/all/20230927112517.2631674-1-sebastianene@google.com/

Changelog:
  v3 -> current_version:
  * refactorization: moved all the **KVM** specific components under
    kvm/ as suggested by Oliver. Introduced a new file
    arm64/kvm/ptdump.c which handled the second stage translation.
    re-used only the display portion from mm/ptdump.c

  * pagetable snapshot creation now uses memory donated from the host.
    The memory is no longer shared with the host as this can pose a security
    risk if the host has access to manipulate the pagetable copy while
    the hypervisor iterates it.

  * fixed a memory leak: while memory was used from the memcache for
    building the snapshot pagetable, it was no longer giving back the
    pages to the host for freeing. A separate array was introduced to
    keep track of the pages allocated from the memcache.

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
  KVM: arm64: Add snapshot interface for the host stage-2 pagetable
  KVM: arm64: Add ptdump registration with debugfs for the stage-2
    pagetables
  KVM: arm64: Invoke the snapshot interface for the host stage-2
    pagetable
  arm64: ptdump: Expose the attribute parsing functionality
  arm64: ptdump: Use the mask from the state structure
  KVM: arm64: Move pagetable definitions to common header
  KVM: arm64: Walk the pagetable snapshot and parse the ptdump
    descriptors
  arm64: ptdump: Interpret memory attributes based on the runtime config
  arm64: ptdump: Interpret pKVM ownership annotations
  arm64: ptdump: Add guest stage-2 pagetables dumping

 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_pgtable.h          | 111 +++++
 arch/arm64/include/asm/ptdump.h               |  49 +-
 arch/arm64/kvm/Kconfig                        |  13 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/arm.c                          |   2 +
 arch/arm64/kvm/debug.c                        |   6 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  27 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  12 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 186 ++++++++
 arch/arm64/kvm/hyp/pgtable.c                  |  85 ++--
 arch/arm64/kvm/kvm_ptdump.h                   |  21 +
 arch/arm64/kvm/ptdump.c                       | 436 ++++++++++++++++++
 arch/arm64/mm/ptdump.c                        |  55 +--
 14 files changed, 897 insertions(+), 108 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ptdump.h
 create mode 100644 arch/arm64/kvm/ptdump.c

-- 
2.43.0.472.g3155946c3a-goog

