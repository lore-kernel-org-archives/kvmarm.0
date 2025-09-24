Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EF12D7804
	for <kvmarm@lists.linux.dev>; Wed, 24 Sep 2025 15:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758727220; cv=none; b=ZlMNyWmoFXKjkjFrfm7p1sV7STGotbzaBkxGU1iAn15YY463cG9gLtqJE/JnEcqFm13uuqHbGc/T1BYRoIriZuUzUcEfO3LLGhSpWPlZNlvhneVL1Xv/5ZaUyiDcc6fdJVuRpK6cyIaMK42cfMYjfIjfsafPVMJRPuLjojodEvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758727220; c=relaxed/simple;
	bh=qHJFbsYgS91YYDoS3pNiLv0mtvxMAELdSxOXkcm25+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gtu5KvemJdeLEUlo+Nep7qvWvlGfybAbKdddkfUEfsnA5wTXOnF7rOdkdooGNsqu/kFs4e8Wycse1P/AMO+853S8Q1H6YkLXsamh6lQZbL8qDtmkNbUle6uz2au3SagU1WRDuFwmWJDIgR6UUdcaFOw6WfMOliT692CRrQdUhFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=campus.lmu.de; spf=pass smtp.mailfrom=campus.lmu.de; dkim=pass (2048-bit key) header.d=lmu.de header.i=@campus.lmu.de header.b=HxQEGW2Q; arc=none smtp.client-ip=129.187.255.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=campus.lmu.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=campus.lmu.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lmu.de header.i=@campus.lmu.de header.b="HxQEGW2Q"
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4cX0fy3XKnzyTM;
	Wed, 24 Sep 2025 17:11:22 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=lmu.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lmu.de; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=
	lm-postout21; i=@campus.lmu.de; t=1758726681; bh=T6LxtLsJSjh5VFa
	qIEo/5wr5RrqvMX416qBvYTVfg0E=; b=HxQEGW2QLMQxARGwSZU1TNXRNbiDlou
	BMJUwogj9SQS+zAwVFesU+rm6J8ESrh5EeQb8FBQenIY3bu5DTO6JKqOyT9QT7oe
	qE0uVSVfDHNlHPRF0cEqwhQIZ+q6CQc14tIb0t3gUZUvCGMT4voVbA7OTed58ZVQ
	Fp7eMjDT1tZPZda+E2TBcGOZatLAYcCYmVqmKrnab+3B5t+QAK4LMD2QJRboE0eN
	z8BGvqbGKfXfsZrfVv9wyzvaAwKUaiKNE2Gwir3zQLPYBd3x3XjwH276/NO8/IjR
	rA8M46iav7Dn7yNPKX1XTaZ8lp6Gh7wTu+F3GTcn8f0k6MkbGN5w2vw==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.886
X-Spam-Level:
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id w1gLyyBlciFZ; Wed, 24 Sep 2025 17:11:21 +0200 (CEST)
Received: from spacestation.cable.virginm.net (oxfd-27-b2-v4wan-164230-cust474.vm42.cable.virginm.net [86.22.133.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4cX0fr09PgzyS8;
	Wed, 24 Sep 2025 17:11:15 +0200 (CEST)
From: Patrick Roy <patrick.roy@campus.lmu.de>
To: 
Cc: Patrick Roy <roypat@amazon.co.uk>,
	pbonzini@redhat.com,
	corbet@lwn.net,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	song@kernel.org,
	jolsa@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	jannh@google.com,
	pfalcato@suse.de,
	shuah@kernel.org,
	seanjc@google.com,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	xmarcalx@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.co.uk,
	derekmn@amazon.co.uk,
	tabba@google.com,
	ackerleytng@google.com
Subject: [PATCH v7 00/12] Direct Map Removal Support for guest_memfd
Date: Wed, 24 Sep 2025 16:10:40 +0100
Message-ID: <20250924151101.2225820-1-patrick.roy@campus.lmu.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

From: Patrick Roy <roypat@amazon.co.uk>

[ based on kvm/next ]

Unmapping virtual machine guest memory from the host kernel's direct map is a
successful mitigation against Spectre-style transient execution issues: If the
kernel page tables do not contain entries pointing to guest memory, then any
attempted speculative read through the direct map will necessarily be blocked
by the MMU before any observable microarchitectural side-effects happen. This
means that Spectre-gadgets and similar cannot be used to target virtual machine
memory. Roughly 60% of speculative execution issues fall into this category [1,
Table 1].

This patch series extends guest_memfd with the ability to remove its memory
from the host kernel's direct map, to be able to attain the above protection
for KVM guests running inside guest_memfd.

Additionally, a Firecracker branch with support for these VMs can be found on
GitHub [2].

For more details, please refer to the v5 cover letter [v5]. No
substantial changes in design have taken place since.

=== Changes Since v6 ===

- Drop patch for passing struct address_space to ->free_folio(), due to
  possible races with freeing of the address_space. (Hugh)
- Stop using PG_uptodate / gmem preparedness tracking to keep track of
  direct map state.  Instead, use the lowest bit of folio->private. (Mike, David)
- Do direct map removal when establishing mapping of gmem folio instead
  of at allocation time, due to impossibility of handling direct map
  removal errors in kvm_gmem_populate(). (Patrick)
- Do TLB flushes after direct map removal, and provide a module
  parameter to opt out from them, and a new patch to export
  flush_tlb_kernel_range() to KVM. (Will)

[1]: https://download.vusec.net/papers/quarantine_raid23.pdf
[2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[RFCv1]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.co.uk/
[RFCv2]: https://lore.kernel.org/kvm/20240910163038.1298452-1-roypat@amazon.co.uk/
[RFCv3]: https://lore.kernel.org/kvm/20241030134912.515725-1-roypat@amazon.co.uk/
[v4]: https://lore.kernel.org/kvm/20250221160728.1584559-1-roypat@amazon.co.uk/
[v5]: https://lore.kernel.org/kvm/20250828093902.2719-1-roypat@amazon.co.uk/
[v6]: https://lore.kernel.org/kvm/20250912091708.17502-1-roypat@amazon.co.uk/


Patrick Roy (12):
  arch: export set_direct_map_valid_noflush to KVM module
  x86/tlb: export flush_tlb_kernel_range to KVM module
  mm: introduce AS_NO_DIRECT_MAP
  KVM: guest_memfd: Add stub for kvm_arch_gmem_invalidate
  KVM: guest_memfd: Add flag to remove from direct map
  KVM: guest_memfd: add module param for disabling TLB flushing
  KVM: selftests: load elf via bounce buffer
  KVM: selftests: set KVM_MEM_GUEST_MEMFD in vm_mem_add() if guest_memfd
    != -1
  KVM: selftests: Add guest_memfd based vm_mem_backing_src_types
  KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing
    selftests
  KVM: selftests: stuff vm_mem_backing_src_type into vm_shape
  KVM: selftests: Test guest execution from direct map removed gmem

 Documentation/virt/kvm/api.rst                |  5 ++
 arch/arm64/include/asm/kvm_host.h             | 12 ++++
 arch/arm64/mm/pageattr.c                      |  1 +
 arch/loongarch/mm/pageattr.c                  |  1 +
 arch/riscv/mm/pageattr.c                      |  1 +
 arch/s390/mm/pageattr.c                       |  1 +
 arch/x86/include/asm/tlbflush.h               |  3 +-
 arch/x86/mm/pat/set_memory.c                  |  1 +
 arch/x86/mm/tlb.c                             |  1 +
 include/linux/kvm_host.h                      |  9 +++
 include/linux/pagemap.h                       | 16 +++++
 include/linux/secretmem.h                     | 18 -----
 include/uapi/linux/kvm.h                      |  2 +
 lib/buildid.c                                 |  4 +-
 mm/gup.c                                      | 19 ++----
 mm/mlock.c                                    |  2 +-
 mm/secretmem.c                                |  8 +--
 .../testing/selftests/kvm/guest_memfd_test.c  |  2 +
 .../testing/selftests/kvm/include/kvm_util.h  | 37 ++++++++---
 .../testing/selftests/kvm/include/test_util.h |  8 +++
 tools/testing/selftests/kvm/lib/elf.c         |  8 +--
 tools/testing/selftests/kvm/lib/io.c          | 23 +++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 61 +++++++++--------
 tools/testing/selftests/kvm/lib/test_util.c   |  8 +++
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +
 .../selftests/kvm/set_memory_region_test.c    | 50 ++++++++++++--
 .../kvm/x86/private_mem_conversions_test.c    |  7 +-
 virt/kvm/guest_memfd.c                        | 66 +++++++++++++++++--
 virt/kvm/kvm_main.c                           |  8 +++
 30 files changed, 290 insertions(+), 94 deletions(-)


base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
2.51.0

