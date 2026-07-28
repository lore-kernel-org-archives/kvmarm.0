Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED8C42FCBE
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 12:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785240705; cv=none; b=lYKvpqWmT6BwXPvHUETAJZRLZC4/XQuvULHpJ+Aa7m6o4RUER2wg6GDT8UYmFClGS8HbS7R8J6tgUT5KaYDZu4OuyFlOw3P3oDdYSuJkqzdnWKCys0DqletKe7e0Wgz0HlJnGqRIL6PFO6ULadDFbTnFIeAnuix6DbDxDhmYjv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785240705; c=relaxed/simple;
	bh=uhNhjrYfeoJ0RgBmj8M12XW7rqqRdz9J9G2SNbgfxlU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XRRhyIRD9XkxQRwrY45iU1RQC73Mg1KtZXAnZ7HXuwRl+0KAu3v+PGqMRX2y1GLfYosp9+yfcfFbg5K6LShiVqANSSlhpSR/a3Yp55Tm8Xn/Eyy828yWnMaJlpBMQHJpTILyeOnRIIkmAv7e+0CdzeG+Q1SoZJealhL/ycsfMpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JXdiQcZM; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JXdiQcZM"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49544a639e9so20026795e9.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 05:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240701; x=1785845501; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A3x31jTyX9GVbaN5Ccntk2NfcOSeaYrewYI0sLHeraw=;
        b=JXdiQcZM3sOWu0BvagzcS/xBZV/V34I4nHTi8R4dK803H0xY0kcvhej6Wz6HNg2EzD
         P84kLJltcfBa3T3s70tOlln90A6MLQca17CRNpGXvrfd2tBUAmdcNCvVddyhbyRmsT3g
         wGj34rR7XKU5hiK3v6kJJ1JItta1W26Ub0c1/Bg9umOSLi9BtMr2iGUA+axFbvjDLDll
         y+pVHYTmIWvNe/O53AyQII8pmXe6/bdL1v4/6k2Y2BjDD9kf/9L4X6g0bR+Pa88Fnxhl
         5prrY089PQTYr+GyThl4+0AFq4LX7kvWgeNvsP92K8ljDfsDJbK5eJUm0x2Ox0z3HaI/
         a0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240701; x=1785845501;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A3x31jTyX9GVbaN5Ccntk2NfcOSeaYrewYI0sLHeraw=;
        b=XnagJ4eh9y58Hibmrm4NJbiQ61FJuFoymT8LP1/OMxFL1rawCyAbE8e/lAC/wgsiBX
         BL1ycayUeTBWx07CA1XrnYduYYP5ve602vRVOb68+vo9fe8EB14WifiheJeQMWdjyIF9
         9ZbY7Br/TQbyUh54DuxoG/m17reT+27eWGH00LgM4QmTrCmHwexyNtReXk0SMmNKtCWQ
         2fCbgFuTIbYzXgWuX/2shyGDhubbHrCt/Ljg6JUM6XrtJeEEc34z6NRtv9eqLoUX8xE+
         ycjxw++KBKCTuHUVu2LFq+lRUsgJ02FRlhpO89tzVEnTEtrRQ26iIu7BBdzQyryyrkiL
         N6iA==
X-Forwarded-Encrypted: i=1; AHgh+RqvyRS30azqkzh0+nuCO4tyrNLElqycH7pDw+J798eM8e/m44Vl27SXrJgGwbNFfdyxwleUHfU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxx/o8rnqysxalH/L4KNZvsE5DQTVEp8tX1L5Cdj3slKO70ZiZY
	tl56sjQTmdb6nNCwuoz4WJkSrIc+Eag3TnndC/dAXsFji/nBr9FEtdVbijjmdo3MPMptDQCeeZE
	o3NSXE/O0BwReGVuwrg==
X-Received: from wmbdx8.prod.google.com ([2002:a05:600c:63c8:b0:493:f434:c988])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f16:b0:495:607e:5ee7 with SMTP id 5b1f17b1804b1-496c6435aeamr21806975e9.17.1785240701228;
 Tue, 28 Jul 2026 05:11:41 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:27 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-1-tarunsahu@google.com>
Subject: [PATCH v4 00/11] liveupdate: kvm: Guest_memfd preservation
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Hello,

This is v4 of guest_memfd preservation during liveupdate. As per
the discussion from bi-weekly guest-memfd meeting, This series
will be go to linux via kvm tree. And Planning to get it merged
in upcoming merge window. (7.2-rc1 for release in 7.3)

The changes are rebased on:
	kvm/next + liveupdate/next (merge) + [4] + [5]
	Where,
	[4]: luo: APIs to retrieve file internally from session
	[5]: selftests: liveupdate sefltests library
Here is the github repo:
	https://github.com/tar-unix/linux/tree/gmem-pre

Patches [4] and [5] are prequisite of this series and they are
rebased/merged on liveupdate/next. kvm/next is behind few patches
from liveupdate/next, hence direct cherry-pick of [4] and [5] is
not possible. On Linux 7.2 they will be aligned. If we
succeed in merging it before I can request liveupdate maintainer
to provide the tag.

Steps to test:
1. Compile Kernel with CONFIG_LIVEUPDATE_GUEST_MEMFD=y
2. boot kernel with command line: kho=on liveupdate=on
3. run the following kselftest
	$ .selftests/kvm/guest_memfd_preservation_test --s 1
	$ <kexec> --reuse-cmdline
	$ .selftests/kvm/guest_memfd_preservation_test --s 2

NOTE: Assert the following:
	$ ls /dev/liveupdate
	$ ls /dev/kvm
	$ dmesg | grep liveupdate # (should have kvm_vm_luo &&
		# guest_memfd_luo handler registered)

V4 <- V3
1. Split the refactoring patch into multiple patches [2, 3, 4]
2. Updated commits msg as per the kvm documentation and suggestions
3. Removed KHOSER_PTR and using raw pointer, as series [3] not yet
   decided to go in the next cycle
4. Implemented more tests in guest_memfd_preservation_test
   allocation during frozen gmem_inode, non-guest_memfd preservation
5. Moved the vm_create_from_fd to kvm_util.c from the
   guest_memfd_preservation_test.c
5. Minor updates as per the suggestions

V3 <- RFC V2 [2]
1. Finalize the design
2. resolve sashiko reported bugs
3. Use of KHOSER_PTR instead of raw serialized_data as per [3]

RFC V2 [2] <- RFC V1 [1]
1. Removed mem_attr_array as it is not needed for fully-shared
2. Removed pre-faulted condition
3. Added vm_type preservation for ARM64.
4. Removed liveupdate_get_file_incoming api patch as it is sent
   separately [4] by Samiullah.


**GUEST MEMFD PRESERVATION**
Below is the cover letter of the series which explains the design.

SCOPE:
1. Fully Shared Guest_memfd
2. Guest_memfd backed by PAGE_SIZE pages

Any VM whose memory is backed by such guest_memfd and satisfy the
above conditions can be preserved across liveupdate.

To Add support for liveupdate of any subsystem, we need to implement
the following calls: (e.g: subsystem: guest_memfd)

guest_memfd_luo_can_preserve: used by luo subsystem to filter the
			      guest_memfd files
guest_memfd_luo_preserve: triggered from userspace by PRESERVE ioctl
			  If can_preserve says the file is preservable
			  by guest_memfd_luo_preserve
guest_memfd_luo_retrieve: triggered from userspace by RETRIEVE ioctl,
 			  recognised by the passed token from userspace.
			  Used in new kernel after kexec.
guest_memfd_luo_unpreserve: triggered from userspace when a session is
			    closed, which inherently calls unpreserve of
			    all preserved files.
guest_memfd_luo_freeze: triggered just before kexec automatically in
			kernel. no userspace involvement.
guest_memfd_luo_finish: triggered by userspace when all files are
			retrieved and want to finish the session
			retrieval.

*PART A: KVM VM preservation*
Introdcued the kvm_luo.c to preserve the vm_file during liveupdate.
Currently it only preserve vm_type. This can be expanded to preserve
more details in future as need arises for example data related to
cocoVM (SEPT etc.).

	int kvm_fd = open("/dev/kvm", O_RDWR);
	int vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
	preserve_arg = {
    	.size = sizeof(preserve_arg),
	    .fd = vm_fd,
	    .token = VM_TOKEN,
	};
	ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg);

This VM_TOKEN is used by guest_memfd preservation. guest_memfd
preservation save this token (fetched internally by luo apis [4]) to
associates the guest_memfd with its vm_file. On retrieval, guest_memfd
retrieves the vm_file using this token and use its struct kvm to
retrieve itself.

PART B: Guest_memfd preservation
Introduce guest_memfd_luo.c to preserve the guest_memfd file during
liveupdate. Currently it only preserve guest_memfd files that have:

1. INIT_SHARED flag ensures intially all the memory is shared
2. !kvm_arch_has_private_mem() which ensures no shared pages can be
   converted to private after [6] lands.

Preservation first freezes the gmem_inode introduced in PATCH [07/11]
and preserve each allocated folios from guest_memfd page_cache using
KHO.

luo_freeze (not the gmem_inode freeze PATCH[07/11]) call update the
vm_token which is preserved across kexec.

Retrieval retrieves the vm_file using vm_token and create the
guest_memfd with vm_file->kvm and populate the preserved folios
to guest_memfd page_cache.

Added the Documentation for VMM on guest_memfd preservation guidelines
To know more about, PATCH[10/11] can be referred which has the more
detailed documentation.

Future Plan:
	1. Make preservation immune to new allocation and fallocate
	calls so that we can remove freeze call
	2. In future, When IOMMU will use guest_memfd and can allocate
	page tables for DMA in that area, Later it will be a problem if
	other user of guest_memfd do punch hole before preservation,
	that will make the pages to be lost after preservation. This
	will be taken care of when IOMMU will add support for
	guest_memfd.
	3. guest_memfd preservation for private pages + in-place
	conversion.
	4. In future, when guest_memfd will have hugetlb page support,
	add support its preservation.

[1]: https://lore.kernel.org/all/cover.1779080766.git.tarunsahu@google.com/
[2]: https://lore.kernel.org/all/cover.1780667929.git.tarunsahu@google.com/
     https://lore.kernel.org/all/c054ba0fb2639932bbe354420d3f4f84cce84905.1780676742.git.tarunsahu@google.com/
[3]: https://lore.kernel.org/all/20260622184851.2309827-1-tarunsahu@google.com/
[4]: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/commit/?h=next&id=f4d2e4f0d12d88155cd1128ed3294f7827bf4c5d
[5]: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/commit/?h=next&id=2f3f53a3735a7e67bbe9e580cb49372bf9261967
     https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/commit/?h=next&id=df1a0d068d481b7d175c5af3970043206409a062
[6]: https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com/

Tarun Sahu (11):
  liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
  KVM: Introduce kvm_create_vm_file() helper
  KVM: Export kvm_uevent_notify_vm_create()
  KVM: Track weak reference to vm_file in struct kvm
  KVM: LUO: Support VM preservation across live updates
  KVM: guest_memfd: Move internal definitions to internal header
  KVM: guest_memfd: Add support for freezing mappings
  KVM: guest_memfd: Add support for preservation via LUO
  docs: liveupdate: Add documentation for VM and guest_memfd
    preservation
  KVM: selftests: Split ____vm_create() and add vm_create_from_fd()
  KVM: selftests: Add guest_memfd_preservation_test

 Documentation/core-api/liveupdate.rst         |   1 +
 Documentation/liveupdate/vmm.rst              | 107 ++++
 MAINTAINERS                                   |  14 +
 include/linux/kho/abi/kvm.h                   | 106 ++++
 include/linux/kvm_host.h                      |  14 +
 kernel/liveupdate/Kconfig                     |  15 +
 tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
 .../kvm/guest_memfd_preservation_test.c       | 357 ++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  49 +-
 virt/kvm/Makefile.kvm                         |   1 +
 virt/kvm/guest_memfd.c                        | 185 +++++--
 virt/kvm/guest_memfd.h                        |  44 ++
 virt/kvm/guest_memfd_luo.c                    | 515 ++++++++++++++++++
 virt/kvm/kvm_luo.c                            | 195 +++++++
 virt/kvm/kvm_main.c                           |  94 +++-
 virt/kvm/kvm_mm.h                             |  15 +
 17 files changed, 1640 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/liveupdate/vmm.rst
 create mode 100644 include/linux/kho/abi/kvm.h
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c
 create mode 100644 virt/kvm/guest_memfd.h
 create mode 100644 virt/kvm/guest_memfd_luo.c
 create mode 100644 virt/kvm/kvm_luo.c


base-commit: a204badd8432f93b7e862e7dac6db0fe3d65f370
-- 
2.55.0.229.g6434b31f56-goog

