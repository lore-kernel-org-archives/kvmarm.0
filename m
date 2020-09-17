Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184CFC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 17:26:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 397F4221EC
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 17:26:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 397F4221EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 619624B39D;
	Thu, 17 Sep 2020 13:26:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i1XHqTOLeH12; Thu, 17 Sep 2020 13:26:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49D254B39E;
	Thu, 17 Sep 2020 13:26:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEDE74B39E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 13:26:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6YW7H65eE5MT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 13:26:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A5624B39D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 13:26:06 -0400 (EDT)
Received: from localhost.localdomain (unknown [31.124.44.166])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 309D22078D;
 Thu, 17 Sep 2020 17:26:04 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] arm64: paravirt: Initialize steal time when cpu is online
Date: Thu, 17 Sep 2020 18:26:02 +0100
Message-Id: <160036355620.29709.16011755396424469575.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200916154530.40809-1-drjones@redhat.com>
References: <20200916154530.40809-1-drjones@redhat.com>
MIME-Version: 1.0
Cc: maz@kernel.org, Will Deacon <will@kernel.org>, steven.price@arm.com
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

On Wed, 16 Sep 2020 17:45:30 +0200, Andrew Jones wrote:
> Steal time initialization requires mapping a memory region which
> invokes a memory allocation. Doing this at CPU starting time results
> in the following trace when CONFIG_DEBUG_ATOMIC_SLEEP is enabled:
> 
> BUG: sleeping function called from invalid context at mm/slab.h:498
> in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/1
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.9.0-rc5+ #1
> Call trace:
>  dump_backtrace+0x0/0x208
>  show_stack+0x1c/0x28
>  dump_stack+0xc4/0x11c
>  ___might_sleep+0xf8/0x130
>  __might_sleep+0x58/0x90
>  slab_pre_alloc_hook.constprop.101+0xd0/0x118
>  kmem_cache_alloc_node_trace+0x84/0x270
>  __get_vm_area_node+0x88/0x210
>  get_vm_area_caller+0x38/0x40
>  __ioremap_caller+0x70/0xf8
>  ioremap_cache+0x78/0xb0
>  memremap+0x9c/0x1a8
>  init_stolen_time_cpu+0x54/0xf0
>  cpuhp_invoke_callback+0xa8/0x720
>  notify_cpu_starting+0xc8/0xd8
>  secondary_start_kernel+0x114/0x180
> CPU1: Booted secondary processor 0x0000000001 [0x431f0a11]
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: paravirt: Initialize steal time when cpu is online
      https://git.kernel.org/arm64/c/75df529bec91

-- 
Catalin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
