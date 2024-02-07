Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E13FC0A
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707317359; cv=none; b=uo75MVEhAq+PAGiEHSryG+W9jiiILHpbx+DxytCQIPKcS8amMRmVG939EdAMosezICRfdRE6raQw6Rj679FKKuReJ/5TuoiKnLDGDV6OdHk34gXCFRI7Sko01yTCLPDqC45kfv0REMPyaTNwpNSboGkuPcswLQnGmra+D+kJgIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707317359; c=relaxed/simple;
	bh=krJX2wO8be7NQJXlSD1F9IfkFfrvInq26sVU2TNKHxs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IpvZbSx+TT8XwA97qBakMBKe/SV47B8hcRgPlwwt27ljp5wm4N8Kz1PxxrPKFcC6mv2qlvfN00QRgRPUkOSgkZ4jEZ4LmYzBI0dTz+99ZTdYcs8sl+animrptaSc+Tjl27/imLzHPZADvwx7OV3/2dl9g26/HCzv3GWSOQndYv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s7RYJU1g; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s7RYJU1g"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6cd10fd4aso974158276.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 06:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707317357; x=1707922157; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TvegWWdI0OwCbkhac2nall+6RkPi+o6vdVPfpeCUajU=;
        b=s7RYJU1gMSy/LOjIpIE1IYYhkKwdxhIg4fcxbBQHSUsb6zm7oybt5NO6xHgQUCi+pt
         DBuMMjqSLOn/q2LNt0k0V5FJD7wQqIrtlMTLd13JO8xkbE74U+6g4YU/FOTMLL63YRWN
         HU/g11EnfPXAqmM+1KcMH77NozCDjXXIVEW8wwksd5+pmh+2RzWsj8yUWhqspieAOhXc
         pzmTAAyGWO0t4SaJFMN4dsEURJTKb0vd8yaMfNhbXCDjXG77hYVT6FsgKOU6wnQJUT1r
         uQUY5T5uYw3C+3Ci1giLXozZ0rD6mk47wyr297uvYkqgGpSYx/3IRfy540km99wJwM7E
         s3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707317357; x=1707922157;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TvegWWdI0OwCbkhac2nall+6RkPi+o6vdVPfpeCUajU=;
        b=F9yroEVsBxBgQgPkZnwJ1k9zXCSeJTgDYEvN4qQiQMYs/bDubXZXX+W+S9NicseaoM
         lpG5fk4whZHBvNPI0coI4+OelzF+RgBRBxH7h7unjGWL+cxUf00LSBtx/QdzR1wKV4mg
         lwChfVvvT4jjmtcswqkU5Xu6+yXMVXR6SwS+V0Qzy0UUMMZpx/3Gt9mB10kZ/YJ4j5JJ
         beBGvbui3bVDJtAtgVLt0gjJcdxbpubaYScjeflrXl3hnGMUC6UYTywUYWB8l9tqHJ3h
         GJXT5/8O7S/V5NgnPclA/1Al0F//uRtocc8iuyruceWsoQ3R+depvB/QlSpZHTYxW6FD
         Wr6A==
X-Gm-Message-State: AOJu0YyubH6UVQwHUg+QqmwVMXaBePyXnToae0rcvparsAhkObWZ2KmF
	Rwb4E0fhE9dYx+pRh1lOKbOJR+h25U/7TMNATGXWAMqRFQn/+tBm52H02SByLd2IJObXa/bA/i2
	Bc5v8R8mB4MsZtIxxoiHNkOG0Zw==
X-Google-Smtp-Source: AGHT+IHsVGJFxNmDhsKxmS2lrYPhk6GujJhV1UK7jEEId4g4rPm9A+7WF09PvN/kfQINfrelSokR/4V2F8FfP1X7dG0=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:118f:b0:dc6:c623:ce6f with
 SMTP id m15-20020a056902118f00b00dc6c623ce6fmr158528ybu.13.1707317356952;
 Wed, 07 Feb 2024 06:49:16 -0800 (PST)
Date: Wed,  7 Feb 2024 14:48:29 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240207144832.1017815-2-sebastianene@google.com>
Subject: [PATCH v5 0/4] arm64: ptdump: View the second stage page-tables
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

Link to v4:
https://lore.kernel.org/all/20231218135859.2513568-2-sebastianene@google.com/

Link to v3:
https://lore.kernel.org/all/20231115171639.2852644-2-sebastianene@google.com/

Changelog:
 v4 -> current_version:
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

Sebastian Ene (4):
  arm64: ptdump: Expose the attribute parsing functionality
  arm64: ptdump: Use the mask from the state structure
  KVM: arm64: Register ptdump with debugfs on guest creation
  KVM: arm64: Initialize the ptdump parser with stage-2 attributes

 arch/arm64/include/asm/ptdump.h |  42 +++++-
 arch/arm64/kvm/Kconfig          |  13 ++
 arch/arm64/kvm/Makefile         |   1 +
 arch/arm64/kvm/debug.c          |   7 +
 arch/arm64/kvm/kvm_ptdump.h     |  20 +++
 arch/arm64/kvm/ptdump.c         | 235 ++++++++++++++++++++++++++++++++
 arch/arm64/mm/ptdump.c          |  49 ++-----
 7 files changed, 327 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ptdump.h
 create mode 100644 arch/arm64/kvm/ptdump.c

-- 
2.43.0.594.gd9cf4e227d-goog

