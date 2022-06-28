Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7056C43334
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jun 2022 09:13:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CB2D4B57B;
	Wed, 29 Jun 2022 05:13:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jsa9nyMM61bc; Wed, 29 Jun 2022 05:13:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 265BF4B4A2;
	Wed, 29 Jun 2022 05:13:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C97C4B494
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 18:09:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VOMov4Wt+cNX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2022 18:09:44 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B72C24B32C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 18:09:44 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 h18-20020a170902f55200b0016a4a78bd71so7563268plf.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2022 15:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=j7vQtUkT6qRG3QKeX4UpMqnVZiZTqDS8DcvKPJ9fshM=;
 b=GzxwozEneycpYxfYkAxZnBbfe2kKbiWaUb3au/3inz+96+E7+zLStOmquVbMClhDJN
 mymnRTDsodttIg6bONJTV+Qf5sR0A/4Eufj9q5UkrnT+X4ZTX9KUSPZals5kueYPLHS3
 5ZKToqFOZmswpxTUHknfNDUsMGF7F/uaQqn/NEHMx2U6nUHbDS6x4NydE1vgoQf5Vtt0
 6DmHVpPjAhtY1SKXtzIeH1gmnX+GXgSguGwom5FHISPhcwC8dDainyvR7TPw7gTaHg5e
 aUNIUtPDYqw7Y7eMijqWWljoO7q9a0HYG+8ZpKEazP1QJOUU4M542v67wi7XPxaE8BoY
 dfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=j7vQtUkT6qRG3QKeX4UpMqnVZiZTqDS8DcvKPJ9fshM=;
 b=ky3ZTNmdJ8NwrYA4vi1bAyUEQCzXKKZNAYRvU/HAVWoopwQ11NPkJRRUTxOZTrpdlM
 4qKE+P6Ixpus1U8T9002RcWSGtqQ2UPBm4IJGj2oxgkB2qlYw38uzZw078S/3eOnWwuk
 pdMlITa6wMkTBPFD2wtP0clTRwGfYS/R26U8tCHSIXfphtLoBEZLisyltlPY9xkYLN6Q
 po+9juXaCG7WZjEa8YGjWQSIyYlX+7so60ee+DeP/5ETS/TBfdHozv1Sa7lNN4VnNxWy
 4pI+rhhsQbAPjhgQ3qubbp5BPRYr2NLc6WDBYhse245Gwl4rbDW5klCnO8LZZs9809+s
 OE5g==
X-Gm-Message-State: AJIora+kHq6ZMKMzQxoSpYEdxCi92Dx86iyaZIAYcMRC4z0LLeoZbcs6
 kkd1tZ7tavAJUvRlwTislRIp3q57al/9dfFo
X-Google-Smtp-Source: AGRyM1tAsY26pwu8BYVe36xK0WPC+OOzu0ciBh5fVZFr2DkYJV+K61VKlr8YtnVAaRLZuPtKG1T6lcJUgBOER+dp
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a17:902:d212:b0:16b:9cf9:6523 with SMTP
 id t18-20020a170902d21200b0016b9cf96523mr932471ply.33.1656454183407; Tue, 28
 Jun 2022 15:09:43 -0700 (PDT)
Date: Tue, 28 Jun 2022 22:09:34 +0000
Message-Id: <20220628220938.3657876-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v6 0/4] KVM: mm: count KVM mmu usage in memory stats
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
X-Mailman-Approved-At: Wed, 29 Jun 2022 05:13:43 -0400
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
 include/linux/kvm_host.h                | 10 +++++++
 include/linux/mmzone.h                  |  1 +
 mm/memcontrol.c                         |  1 +
 mm/page_alloc.c                         |  6 ++++-
 mm/vmstat.c                             |  1 +
 12 files changed, 89 insertions(+), 7 deletions(-)

-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
