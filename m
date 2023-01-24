Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5397B7C
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 00:48:16 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id u19so35024224ejm.8
        for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 16:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p1c4BU7Z0e7Xmn1hlnHvwwA4elfE64zTujm193HBwzk=;
        b=j5Kwcgzizm9lP21t3W6lTYQWJ9VlwohAsSKoXjuDQgzhJNIlB9XYXhhO+KH0m2ltS4
         VTW9ieydWdtFTOrbDojpD4Sj5Tcf/XF6rEd4SSara0OaYgpcQa/wiELwXy7kQANH38Kt
         WubcX6B6IKTjsaOgkU+qvyIoPxQPpfO5ecoc4LbRvt42WL6y/8frveMXXq3aTmcr95ug
         9GGyxRMIb4v4SE7zAw/mfEFWuO3fjc+T/4O96J65bQfJkFHTywA9FYUu0QHIhJjvjCS+
         XyeIplpvCIIi/heN3jmthxl26X67IPPM/z0lm9ORdnJufKegLbU4XMUEcwMK1elV48O1
         7+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p1c4BU7Z0e7Xmn1hlnHvwwA4elfE64zTujm193HBwzk=;
        b=WisRk9oqUSdd0jk/z3qLIV7bwNtrafGvKwIC7Esf9GfPQ7N/N15ZWQW5NPan69p52A
         mQxQocwj1Qumo3901oPGL5UXfUFM+RqKn1IjIFeW+/176B9jLTTcRd6XqCzG4gQI1o6q
         iSIBZnKgQxDpyQoYPQ/TpMQRIuNi+rx+7UcS3EVjUsKhcQGtjw64pQw5v9eqQCzaMJ0h
         smt0MX800Msh4LgN1ZJSvP6XSeNByoOBZixBjlvglBErVwgy6yRPlvOjRRM69A1oD0eK
         MfM0zZ4ve5eMfK1u0fTs/mcRbi0hNnUPhjSYUmGjfg0ESG3mbmukcABasgA4wGKKhMil
         tKkQ==
X-Gm-Message-State: AFqh2kp/4iCxBUIl1+L1DLfsAe1yaySlN2Khsttkng7jCftjM6qrGgm6
	O/MQRXHx1XiiECUpR+g9rgSMJ2+pMrRStjyUuWOlVA==
X-Google-Smtp-Source: AMrXdXuVq/5eb8yCODE2gD7zeGUuaVjP6SnynEx6YAuv0yejsgx08yD924YkHRixSEtJlurUX4SCYLSwE8PdKmlqT1s=
X-Received: by 2002:a17:906:606:b0:877:60aa:7090 with SMTP id
 s6-20020a170906060600b0087760aa7090mr1626120ejb.451.1674521294296; Mon, 23
 Jan 2023 16:48:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 23 Jan 2023 16:48:02 -0800
Message-ID: <CANgfPd-zjCcV08qPVpbvqT+aYaaaWsdGuDbiFyYS9HM-KaDKug@mail.gmail.com>
Subject: Re: [PATCH 0/9] KVM: arm64: Eager Huge-page splitting for dirty-logging
To: Ricardo Koller <ricarkol@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Implement Eager Page Splitting for ARM.
>
> Eager Page Splitting improves the performance of dirty-logging (used
> in live migrations) when guest memory is backed by huge-pages.  It's
> an optimization used in Google Cloud since 2016 on x86, and for the
> last couple of months on ARM.
>
> Background and motivation
> =========================
> Dirty logging is typically used for live-migration iterative copying.
> KVM implements dirty-logging at the PAGE_SIZE granularity (will refer
> to 4K pages from now on).  It does it by faulting on write-protected
> 4K pages.  Therefore, enabling dirty-logging on a huge-page requires
> breaking it into 4K pages in the first place.  KVM does this breaking
> on fault, and because it's in the critical path it only maps the 4K
> page that faulted; every other 4K page is left unmapped.  This is not
> great for performance on ARM for a couple of reasons:
>
> - Splitting on fault can halt vcpus for milliseconds in some
>   implementations. Splitting a block PTE requires using a broadcasted
>   TLB invalidation (TLBI) for every huge-page (due to the
>   break-before-make requirement). Note that x86 doesn't need this. We
>   observed some implementations that take millliseconds to complete
>   broadcasted TLBIs when done in parallel from multiple vcpus.  And
>   that's exactly what happens when doing it on fault: multiple vcpus
>   fault at the same time triggering TLBIs in parallel.
>
> - Read intensive guest workloads end up paying for dirty-logging.
>   Only mapping the faulting 4K page means that all the other pages
>   that were part of the huge-page will now be unmapped. The effect is
>   that any access, including reads, now has to fault.
>
> Eager Page Splitting (on ARM)
> =============================
> Eager Page Splitting fixes the above two issues by eagerly splitting
> huge-pages when enabling dirty logging. The goal is to avoid doing it
> while faulting on write-protected pages. This is what the TDP MMU does
> for x86 [0], except that x86 does it for different reasons: to avoid
> grabbing the MMU lock on fault. Note that taking care of
> write-protection faults still requires grabbing the MMU lock on ARM,
> but not on x86 (with the fast_page_fault path).
>
> An additional benefit of eagerly splitting huge-pages is that it can
> be done in a controlled way (e.g., via an IOCTL). This series provides
> two knobs for doing it, just like its x86 counterpart: when enabling
> dirty logging, and when using the KVM_CLEAR_DIRTY_LOG ioctl. The
> benefit of doing it on KVM_CLEAR_DIRTY_LOG is that this ioctl takes
> ranges, and not complete memslots like when enabling dirty logging.
> This means that the cost of splitting (mainly broadcasted TLBIs) can
> be throttled: split a range, wait for a bit, split another range, etc.
> The benefits of this approach were presented by Oliver Upton at KVM
> Forum 2022 [1].
>
> Implementation
> ==============
> Patches 1-3 add a pgtable utility function for splitting huge block
> PTEs: kvm_pgtable_stage2_split(). Patches 4-8 add support for eagerly
> splitting huge-pages when enabling dirty-logging and when using the
> KVM_CLEAR_DIRTY_LOG ioctl. Note that this is just like what x86 does,
> and the code is actually based on it.  And finally, patch 9:
>
>         KVM: arm64: Use local TLBI on permission relaxation
>
> adds support for using local TLBIs instead of broadcasts when doing
> permission relaxation. This last patch is key to achieving good
> performance during dirty-logging, as eagerly breaking huge-pages
> replaces mapping new pages with permission relaxation. Got this patch
> (indirectly) from Marc Z.  and took the liberty of adding a commit
> message.
>
> Note: this applies on top of 6.2-rc3.
>
> Performance evaluation
> ======================
> The performance benefits were tested using the dirty_log_perf_test
> selftest with 2M huge-pages.
>
> The first test uses a write-only sequential workload where the stride
> is 2M instead of 4K [2]. The idea with this experiment is to emulate a
> random access pattern writing a different huge-page at every access.
> Observe that the benefit increases with the number of vcpus: up to
> 5.76x for 152 vcpus.
>
> ./dirty_log_perf_test_sparse -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2
>
>         +-------+----------+------------------+
>         | vCPUs | 6.2-rc3  | 6.2-rc3 + series |
>         |       |    (ms)  |             (ms) |
>         +-------+----------+------------------+
>         |    1  |    2.63  |          1.66    |
>         |    2  |    2.95  |          1.70    |
>         |    4  |    3.21  |          1.71    |
>         |    8  |    4.97  |          1.78    |
>         |   16  |    9.51  |          1.82    |
>         |   32  |   20.15  |          3.03    |
>         |   64  |   40.09  |          5.80    |
>         |  128  |   80.08  |         12.24    |
>         |  152  |  109.81  |         15.14    |
>         +-------+----------+------------------+

This is the average pass time I assume? Or the total or last? Or whole
test runtime?
Was this run with MANUAL_PROTECT or do the split during the CLEAR
IOCTL or with the splitting at enable time?

>
> This second test measures the benefit of eager page splitting on read
> intensive workloads (1 write for every 10 reads). As in the other
> test, the benefit increases with the number of vcpus, up to 8.82x for
> 152 vcpus.
>
> ./dirty_log_perf_test -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2 -f 10
>
>         +-------+----------+------------------+
>         | vCPUs | 6.2-rc3  | 6.2-rc3 + series |
>         |       |   (sec)  |            (sec) |
>         +-------+----------+------------------+
>         |    1  |    0.65  |          0.07    |
>         |    2  |    0.70  |          0.08    |
>         |    4  |    0.71  |          0.08    |
>         |    8  |    0.72  |          0.08    |
>         |   16  |    0.76  |          0.08    |
>         |   32  |    1.61  |          0.14    |
>         |   64  |    3.46  |          0.30    |
>         |  128  |    5.49  |          0.64    |
>         |  152  |    6.44  |          0.63    |
>         +-------+----------+------------------+
>
> Changes from the RFC:
> https://lore.kernel.org/kvmarm/20221112081714.2169495-1-ricarkol@google.com/
> - dropped the changes to split on POST visits. No visible perf
>   benefit.
> - changed the kvm_pgtable_stage2_free_removed() implementation to
>   reuse the stage2 mapper.
> - dropped the FEAT_BBM changes and optimization. Will send this on a
>   different series.
>
> Thanks,
> Ricardo
>
> [0] https://lore.kernel.org/kvm/20220119230739.2234394-1-dmatlack@google.com/
> [1] https://kvmforum2022.sched.com/event/15jJq/kvmarm-at-scale-improvements-to-the-mmu-in-the-face-of-hardware-growing-pains-oliver-upton-google
> [2] https://github.com/ricarkol/linux/commit/f78e9102b2bff4fb7f30bee810d7d611a537b46d
> [3] https://lore.kernel.org/kvmarm/20221107215644.1895162-1-oliver.upton@linux.dev/
>
> Marc Zyngier (1):
>   KVM: arm64: Use local TLBI on permission relaxation
>
> Ricardo Koller (8):
>   KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
>   KVM: arm64: Add helper for creating removed stage2 subtrees
>   KVM: arm64: Add kvm_pgtable_stage2_split()
>   KVM: arm64: Refactor kvm_arch_commit_memory_region()
>   KVM: arm64: Add kvm_uninit_stage2_mmu()
>   KVM: arm64: Split huge pages when dirty logging is enabled
>   KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
>   KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
>
>  arch/arm64/include/asm/kvm_asm.h     |   4 +
>  arch/arm64/include/asm/kvm_host.h    |  30 +++++
>  arch/arm64/include/asm/kvm_mmu.h     |   1 +
>  arch/arm64/include/asm/kvm_pgtable.h |  62 ++++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  10 ++
>  arch/arm64/kvm/hyp/nvhe/tlb.c        |  54 +++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 143 +++++++++++++++++++++--
>  arch/arm64/kvm/hyp/vhe/tlb.c         |  32 +++++
>  arch/arm64/kvm/mmu.c                 | 168 ++++++++++++++++++++++-----
>  9 files changed, 466 insertions(+), 38 deletions(-)
>
> --
> 2.39.0.314.g84b9a713c41-goog
>
