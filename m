Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B6D74E0F
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708441895; cv=none; b=Vt5aNgpzsfwTysuAsoI8yoL2n0anjsdhOzA7td8c3fSw4FUrFCzY8hgRgv4NWvcog/nno7KMW82F92d56MhRg41/yrg4CGinH3yo5AFqrqMuTJSmSaYkyUkJNehRGAoiVKV6amFwvErw9fTLJiUnD7HEtICfvtIGTjB+0WuQbqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708441895; c=relaxed/simple;
	bh=4j0AEdcx9mCGsF7IUdM5SYFWq0DI9pYHWcnCN7aVjB0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IOFOfxG0z6FkFFAf1AeONMwvBzRXCsRUSqX74bthpwt12Vc4Nbyg76LwedOzOkVA5DfaLZZbPOcMCklBi/Jks3XLjxTbkbEKtsgYDnfCxsE+dLgF8BiYvaMCGUizTk8lemZgLCN3rZ2ld4AipyY3uaZSSw1Y1DOsyTva31jt3X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aZbqI7L0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aZbqI7L0"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-607a628209eso98887647b3.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 07:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708441892; x=1709046692; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HntEjy9yxWmWWTXkuNNpSjp1N7kZ7Hb0rp6LmAC2dFs=;
        b=aZbqI7L0NAOKZy00eIkMTNOOSvCRiYt73rqJMeiFYQa30+ewXXqzDaqhqttaCphJUr
         UrGoLYtZAgLGwn4xGqPmSj40MPmErkbGtKI2wvWHzIL/v6HqdXrDgvBB9XB0v2PHKUGQ
         uyHGOnE2cG2RApya8JcoKeauGePmtqYCXUsUTLwSWCq2n75t/nB+ZmXq5SQdW0pvzJzt
         +XXE6/IvStyAVG+awqkKH1972+Xe4Qwb9XA9Iy3gJyjkIGBrnppHQjVW9Exp3ta2X1Rv
         FywgFGmUExNLCIhEprp1zg1kaNMMCW1AOEGgxyXoiTTMTMUNT4YQhxVqVqzksJX3yRcE
         Fd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708441892; x=1709046692;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HntEjy9yxWmWWTXkuNNpSjp1N7kZ7Hb0rp6LmAC2dFs=;
        b=cG9M1luGWbG7Qzr7SlBnXrCXBroYV1WWE5CJot/thJ3hVIawZ2SNd2oRIRSYvKoQ7Z
         TFaeXUi9HfwX93qpSRfDI84qzRlU/1w7/zk/UctfGXF6RSTTXUQcHijyUWQsgY2lyABM
         1ETvbx6cMSUZCe+lF3hvwAkE7zqF/XsNfWFlnu/ljxC2sZMqvcq/epo+tdn1QPL6VbjO
         oGn/85EjgHFdy8VdMYA9rnk79zUzZDICV2Ve0m+Xyw1/npAbMeN5x8SNn5FUmZN5YPR4
         TewBVSv6j/Jfcbszpc5+JPGywDR3RhlKj8HkfOBhCHRRPtQT78fTOT7WaMea5pjwI/Fg
         yvQw==
X-Gm-Message-State: AOJu0YysYL+3B8xhXUL/VEwauDdd3sBqviverdH9H04sXaAIspkgdL+I
	H1Wc5z9nDgbDPsZRgdL444CGxiuRQzOUKIAKEypSmXCzEUgFgDLWwt1rRcnL43IamwsLFIBjy9z
	kAC5AthIlbXx0VA3wd6pqsc4pmw==
X-Google-Smtp-Source: AGHT+IHawj15gJxsvtR7YjJHEveUJ4WwPausjIgV44eHILmnRZ0cyOqUs/m7BsqWzl/SQPAk6PdNzK5cvmg0Wu4bYlg=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a0d:d7d1:0:b0:608:22f1:c8e4 with SMTP
 id z200-20020a0dd7d1000000b0060822f1c8e4mr1953137ywd.6.1708441892365; Tue, 20
 Feb 2024 07:11:32 -0800 (PST)
Date: Tue, 20 Feb 2024 15:10:29 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240220151035.327199-1-sebastianene@google.com>
Subject: [PATCH v6 0/6] arm64: ptdump: View the second stage page-tables
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, gshan@redhat.com, james.morse@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev, 
	rananta@google.com, ricarkol@google.com, ryan.roberts@arm.com, 
	shahuang@redhat.com, suzuki.poulose@arm.com, will@kernel.org, 
	yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

This is the first part of the series which enables dumping of the guest
stage-2 pagetables. The support for dumping the host stage-2 pagetables
which is pKVM specific will be part of a follow-up series as per the
feedback received in v4. 

When CONFIG_PTDUMP_STAGE2_DEBUGFS is enabled, ptdump registers 
'/sys/debug/kvm/<guest_id>/stage2_page_tables' entry with debugfs
upon guest creation. This allows userspace tools (eg. cat) to dump the
stage-2 pagetables by reading the registered file.

Reading the debugfs file shows stage-2 memory ranges in following format:
<IPA range> <size> <descriptor type> <access permissions> <mem_attributes>

Below is the output of a guest stage-2 pagetable mappings running under
Qemu:

---[ IPA bits 33 start lvl 2 ]---
0x0000000000000000-0x0000000080000000           2G PGD
0x0000000080000000-0x0000000080c00000          12M PGD      R W AF        BLK
0x0000000080c00000-0x0000000080e00000           2M PGD   XN R W AF        BLK
0x0000000080e00000-0x0000000081000000           2M PGD      R W AF        BLK
0x0000000081000000-0x0000000081400000           4M PGD   XN R W AF        BLK
0x0000000081400000-0x000000008fe00000         234M PGD
0x000000008fe00000-0x0000000090000000           2M PGD   XN R W AF        BLK
0x0000000090000000-0x00000000fa000000        1696M PGD
0x00000000fa000000-0x00000000fe000000          64M PGD   XN R W AF        BLK
0x00000000fe000000-0x0000000100000000          32M PGD
0x0000000100000000-0x0000000101c00000          28M PGD   XN R W AF        BLK
0x0000000101c00000-0x0000000102000000           4M PGD
0x0000000102000000-0x0000000102200000           2M PGD   XN R W AF        BLK
0x0000000102200000-0x000000017b000000        1934M PGD
0x000000017b000000-0x0000000180000000          80M PGD   XN R W AF        BLK

Link to v5:
https://lore.kernel.org/all/20240207144832.1017815-2-sebastianene@google.com/

Link to v4:
https://lore.kernel.org/all/20231218135859.2513568-2-sebastianene@google.com/

Link to v3:
https://lore.kernel.org/all/20231115171639.2852644-2-sebastianene@google.com/

Changelog:
 v5 -> current:
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


 v4 -> v5:
 * refactorization: split the series into two parts as per the feedback
   received from Oliver. Introduce the base support which allows dumping
   of the guest stage-2 pagetables.
 
 * removed the *ops* struct wrapper built on top of the file_ops and
   simplify the ptdump interface access.
 
 * keep the page table walker away from the ptdump specific code

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

Sebastian Ene (6):
  KVM: arm64: Move pagetable definitions to common header
  arm64: ptdump: Expose the attribute parsing functionality
  arm64: ptdump: Use the mask from the state structure
  KVM: arm64: Register ptdump with debugfs on guest creation
  KVM: arm64: Initialize the ptdump parser with stage-2 attributes
  KVM: arm64: Expose guest stage-2 pagetable config to debugfs

 arch/arm64/include/asm/kvm_pgtable.h |  42 +++++
 arch/arm64/include/asm/ptdump.h      |  42 ++++-
 arch/arm64/kvm/Kconfig               |  13 ++
 arch/arm64/kvm/Makefile              |   1 +
 arch/arm64/kvm/debug.c               |   8 +
 arch/arm64/kvm/hyp/pgtable.c         |  42 -----
 arch/arm64/kvm/kvm_ptdump.h          |  20 ++
 arch/arm64/kvm/ptdump.c              | 270 +++++++++++++++++++++++++++
 arch/arm64/mm/ptdump.c               |  49 +----
 9 files changed, 405 insertions(+), 82 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ptdump.h
 create mode 100644 arch/arm64/kvm/ptdump.c

-- 
2.44.0.rc0.258.g7320e95886-goog

