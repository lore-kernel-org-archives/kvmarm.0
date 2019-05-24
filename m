Return-Path: <SRS0=CdlU=TZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EC0C46460
	for <kvmarm@archiver.kernel.org>; Sat, 25 May 2019 09:11:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B0B92168B
	for <kvmarm@archiver.kernel.org>; Sat, 25 May 2019 09:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B0B92168B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=techsingularity.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B41EC4A4F4;
	Sat, 25 May 2019 05:11:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WTPrvhj-CGAl; Sat, 25 May 2019 05:11:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C55ED4A4F6;
	Sat, 25 May 2019 05:11:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 932294A321
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 11:51:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4i5fHpZdazdu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 May 2019 11:51:58 -0400 (EDT)
Received: from outbound-smtp15.blacknight.com (outbound-smtp15.blacknight.com
 [46.22.139.232])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 354844A319
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 11:51:58 -0400 (EDT)
Received: from mail.blacknight.com (unknown [81.17.254.26])
 by outbound-smtp15.blacknight.com (Postfix) with ESMTPS id EBA371C2AFC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 May 2019 16:51:56 +0100 (IST)
Received: (qmail 32091 invoked from network); 24 May 2019 15:51:56 -0000
Received: from unknown (HELO techsingularity.net)
 (mgorman@techsingularity.net@[37.228.225.79])
 by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated);
 24 May 2019 15:51:56 -0000
Date: Fri, 24 May 2019 16:51:55 +0100
From: Mel Gorman <mgorman@techsingularity.net>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] mm, compaction: Make sure we isolate a valid PFN
Message-ID: <20190524155155.GQ18914@techsingularity.net>
References: <20190524103924.GN18914@techsingularity.net>
 <1558711908-15688-1-git-send-email-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1558711908-15688-1-git-send-email-suzuki.poulose@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Sat, 25 May 2019 05:11:04 -0400
Cc: mhocko@suse.com, kvm@vger.kernel.org, marc.zyngier@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cai@lca.pw,
 akpm@linux-foundation.org, kvmarm@lists.cs.columbia.edu
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

On Fri, May 24, 2019 at 04:31:48PM +0100, Suzuki K Poulose wrote:
> When we have holes in a normal memory zone, we could endup having
> cached_migrate_pfns which may not necessarily be valid, under heavy memory
> pressure with swapping enabled ( via __reset_isolation_suitable(), triggered
> by kswapd).
> 
> Later if we fail to find a page via fast_isolate_freepages(), we may
> end up using the migrate_pfn we started the search with, as valid
> page. This could lead to accessing NULL pointer derefernces like below,
> due to an invalid mem_section pointer.
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008 [47/1825]
>  Mem abort info:
>    ESR = 0x96000004
>    Exception class = DABT (current EL), IL = 32 bits
>    SET = 0, FnV = 0
>    EA = 0, S1PTW = 0
>  Data abort info:
>    ISV = 0, ISS = 0x00000004
>    CM = 0, WnR = 0
>  user pgtable: 4k pages, 48-bit VAs, pgdp = 0000000082f94ae9
>  [0000000000000008] pgd=0000000000000000
>  Internal error: Oops: 96000004 [#1] SMP
>  ...
>  CPU: 10 PID: 6080 Comm: qemu-system-aar Not tainted 510-rc1+ #6
>  Hardware name: AmpereComputing(R) OSPREY EV-883832-X3-0001/OSPREY, BIOS 4819 09/25/2018
>  pstate: 60000005 (nZCv daif -PAN -UAO)
>  pc : set_pfnblock_flags_mask+0x58/0xe8
>  lr : compaction_alloc+0x300/0x950
>  [...]
>  Process qemu-system-aar (pid: 6080, stack limit = 0x0000000095070da5)
>  Call trace:
>   set_pfnblock_flags_mask+0x58/0xe8
>   compaction_alloc+0x300/0x950
>   migrate_pages+0x1a4/0xbb0
>   compact_zone+0x750/0xde8
>   compact_zone_order+0xd8/0x118
>   try_to_compact_pages+0xb4/0x290
>   __alloc_pages_direct_compact+0x84/0x1e0
>   __alloc_pages_nodemask+0x5e0/0xe18
>   alloc_pages_vma+0x1cc/0x210
>   do_huge_pmd_anonymous_page+0x108/0x7c8
>   __handle_mm_fault+0xdd4/0x1190
>   handle_mm_fault+0x114/0x1c0
>   __get_user_pages+0x198/0x3c0
>   get_user_pages_unlocked+0xb4/0x1d8
>   __gfn_to_pfn_memslot+0x12c/0x3b8
>   gfn_to_pfn_prot+0x4c/0x60
>   kvm_handle_guest_abort+0x4b0/0xcd8
>   handle_exit+0x140/0x1b8
>   kvm_arch_vcpu_ioctl_run+0x260/0x768
>   kvm_vcpu_ioctl+0x490/0x898
>   do_vfs_ioctl+0xc4/0x898
>   ksys_ioctl+0x8c/0xa0
>   __arm64_sys_ioctl+0x28/0x38
>   el0_svc_common+0x74/0x118
>   el0_svc_handler+0x38/0x78
>   el0_svc+0x8/0xc
>  Code: f8607840 f100001f 8b011401 9a801020 (f9400400)
>  ---[ end trace af6a35219325a9b6 ]---
> 
> The issue was reported on an arm64 server with 128GB with holes in the zone
> (e.g, [32GB@4GB, 96GB@544GB]), with a swap device enabled, while running 100 KVM
> guest instances.
> 
> This patch fixes the issue by ensuring that the page belongs to a valid PFN
> when we fallback to using the lower limit of the scan range upon failure in
> fast_isolate_freepages().
> 
> Fixes: 5a811889de10f1eb ("mm, compaction: use free lists to quickly locate a migration target")
> Reported-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
