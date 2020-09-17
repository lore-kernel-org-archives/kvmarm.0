Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C723C43461
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 15:22:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8D2B20708
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 15:22:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xns1Dv9X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8D2B20708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3955A4B40E;
	Thu, 17 Sep 2020 11:22:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4k5udiP54xHU; Thu, 17 Sep 2020 11:22:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 329094B3B0;
	Thu, 17 Sep 2020 11:22:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682E84B3A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 11:22:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zku9ycw6yaGH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 11:22:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A24DD4B378
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 11:22:33 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 504DC206CA;
 Thu, 17 Sep 2020 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600356152;
 bh=gElyZbLcQqZUaL8dZ0GbnW5+S8Tvr1ZdxP0AVl2q5Hs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=xns1Dv9XW5XwbUDwsOI+cjNgcdInHcNDflXBsk/Iizf158GXkze8flP+2NxmjwZDn
 xsLLIHQGyY23DfWtXTj1/E9y27tPsRuZTSmwY16JEXjG5DX+ndd/nwCt/+fGIA+TO2
 ZCWFr5UEUEeFMTRfLLngkjheDyNcWHU7490BOrNE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kIvjy-00CfsP-At; Thu, 17 Sep 2020 16:22:30 +0100
MIME-Version: 1.0
Date: Thu, 17 Sep 2020 16:22:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>, catalin.marinas@arm.com
Subject: Re: [PATCH] arm64: paravirt: Initialize steal time when cpu is online
In-Reply-To: <20200916154530.40809-1-drjones@redhat.com>
References: <20200916154530.40809-1-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <895a5f7fd70acc23bb1b21eb7d9c6f9e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, steven.price@arm.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

+ Catalin,

On 2020-09-16 16:45, Andrew Jones wrote:
> Steal time initialization requires mapping a memory region which
> invokes a memory allocation. Doing this at CPU starting time results
> in the following trace when CONFIG_DEBUG_ATOMIC_SLEEP is enabled:
> 
> BUG: sleeping function called from invalid context at mm/slab.h:498
> in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: 
> swapper/1
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
> However we don't need to initialize steal time at CPU starting time.
> We can simply wait until CPU online time, just sacrificing a bit of
> accuracy by returning zero for steal time until we know better.
> 
> While at it, add __init to the functions that are only called by
> pv_time_init() which is __init.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Fixes: e0685fa228fd ("arm64: Retrieve stolen time as paravirtualized 
guest")
Cc: stable@vger.kernel.org

Catalin, any chance you could queue this if you are OK with it?

Thanks,

       M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
