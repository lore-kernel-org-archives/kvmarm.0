Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF8FC3F6B0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 00:46:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCA6A4CF13;
	Mon, 22 Aug 2022 20:46:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CzG1gUtfwSyp; Mon, 22 Aug 2022 20:46:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB1714CF14;
	Mon, 22 Aug 2022 20:46:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C46214CF10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:46:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Acrs7rbqbqLg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Aug 2022 20:46:44 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D34D4CF0F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 20:46:44 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 q14-20020a6557ce000000b0041da9c3c244so5429075pgr.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 17:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
 bh=+5ILiONNT2Raf8lvKVWoFP9Lx9r+QT/j1xkxXvfLAg4=;
 b=o+XzIuiX0mVrmTljlwxKQE5BPa7fWhxeXonBF2ujsHDIIkmrP/BArjGG8vKGXZzxHZ
 aGCyHZQGHV5fEhDCrdkCSs+rAYyXOsbuGhwIvEGUIpM+alq9pj57H5dboCmNEc09TK0z
 c6heO/8eSor/4/h1izel8Myn9DtJfj72/a/q7U1fFyl1Dno74zfJPMJQRSCl7AkmFpA2
 YVxX7c0VRywxlO0x4/jEhIDRhafho11s7qXBSJr3SCWVNdlEtnYGvZenzxKVAARYwX+f
 oi9flWWlqVqqz3XGywpOOfYXa3KiMvQtqdVJT3SmOpYgrc6NAr9neqgsbzx2bpt4Hix/
 1rNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc;
 bh=+5ILiONNT2Raf8lvKVWoFP9Lx9r+QT/j1xkxXvfLAg4=;
 b=fpYo/u/242nMlc+1+84lh5soHfESPIxs6ZjGS17NR4Aulqn5jnNRX4mjqcZoVqATby
 hEm1Ng1i7E6eEoiIsOFe7i9cxBFQjIJ76RTAts1HItEJJeXgZ9qgUi5EQ+9GsK8LAte3
 l74zJdbteeDSnhgIHvaRZDWOYPL7SgL5MaWxxqMMf6tONTr9FzFd12TZppJICVd3atho
 xkA+Ar6nY8178+grZ/E4KRGka/UiZr0CtnuJ7xWUwz4CajmH+cBR3vCpCrNoE0kfAHZE
 3tpWESOel+EeIUQo20BneAxVC1QuToYwGFChPiB8LRL+4/f/m7ybUMgfWIWwcz/+wZbn
 E5Qg==
X-Gm-Message-State: ACgBeo1VZRz2tU7n93cUbx7i3CyIsWQuahraAwnZAF3lhSgcEeBBwSgN
 2xGuZGHl8kkt8bMDRvcNUoRjzw/yjc19HOAx
X-Google-Smtp-Source: AA6agR7n4HaZkWJXrjZPxJF0LYP1shjmb62PXEmeLlBFj/2/BudXQckF9s5n2JZ4jSwiCza7N/CifAgyNs456d/H
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a17:90b:4c8c:b0:1fa:c44f:473a with SMTP
 id my12-20020a17090b4c8c00b001fac44f473amr840678pjb.195.1661215603362; Mon,
 22 Aug 2022 17:46:43 -0700 (PDT)
Date: Tue, 23 Aug 2022 00:46:35 +0000
Message-Id: <20220823004639.2387269-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v7 0/4] KVM: mm: count KVM mmu usage in memory stats
From: Yosry Ahmed <yosryahmed@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Huang@google.com,
 Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add NR_SECONDARY_PAGETABLE memory stat and use it to account KVM mmu
usage as the first type of accounted secondary page tables. This stat
can be later extended to account for other types of secondary pages
tables (e.g. iommu page tables).

Rationale behind why this is useful and link to extended discussion in
the first patch.

---

Changes in V7:
- Rebased on top of kvm/queue.
- Fixed doc spaces in proc.rst (Sean).
- Commit message s/kvm/KVM (Sean).
- Example of NR_SECONDARY_PAGETABLE s/KVM shadow pagetables/KVM pagetables
  (Sean).
- Added comment that kvm_account_pgtable_pages() is thread-safe (Sean).
- Collected Acks and Reviewed-by's from Sean and Marc (Thanks!).

Changes in V6:
- Rebased on top of kvm/queue and fixed conflicts.
- Fixed docs spaces and tabs (Sean).
- More narrative commit logs (Sean and Oliver).
- Updated kvm_account_pgtable_pages() documentation to describe the
  rules of using it more clearly (Sean).
- Collected Acks and Reviewed-by's by Shakeel and Oliver (Thanks!)

Changes in V5:
- Updated cover letter to explain more the rationale behind the change
  (Thanks to contributions by Sean Christopherson).
- Removed extraneous + in arm64 patch (Oliver Upton, Marc Zyngier).
- Shortened secondary_pagetables to sec_pagetables (Shakeel Butt).
- Removed dependency on other patchsets (applies to queue branch).

Changes in V4:
- Changed accounting hooks in arm64 to only account s2 page tables and
  refactored them to a much cleaner form, based on recommendations from
  Oliver Upton and Marc Zyngier.
- Dropped patches for mips and riscv. I am not interested in those archs
  anyway and don't have the resources to test them. I posted them for
  completeness but it doesn't seem like anyone was interested.

Changes in V3:
- Added NR_SECONDARY_PAGETABLE instead of piggybacking on NR_PAGETABLE
  stats.

Changes in V2:
- Added accounting stats for other archs than x86.
- Changed locations in the code where x86 KVM page table stats were
  accounted based on suggestions from Sean Christopherson.

---

Yosry Ahmed (4):
  mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.
  KVM: mmu: add a helper to account memory used by KVM MMU.
  KVM: x86/mmu: count KVM mmu usage in secondary pagetable stats.
  KVM: arm64/mmu: count KVM s2 mmu usage in secondary pagetable stats

 Documentation/admin-guide/cgroup-v2.rst |  5 ++++
 Documentation/filesystems/proc.rst      |  4 +++
 arch/arm64/kvm/mmu.c                    | 36 ++++++++++++++++++++++---
 arch/x86/kvm/mmu/mmu.c                  | 16 +++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c              | 12 +++++++++
 drivers/base/node.c                     |  2 ++
 fs/proc/meminfo.c                       |  2 ++
 include/linux/kvm_host.h                | 13 +++++++++
 include/linux/mmzone.h                  |  1 +
 mm/memcontrol.c                         |  1 +
 mm/page_alloc.c                         |  6 ++++-
 mm/vmstat.c                             |  1 +
 12 files changed, 92 insertions(+), 7 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
