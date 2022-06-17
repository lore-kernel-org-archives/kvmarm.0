Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B9FC43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 08:50:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99BAE4B297;
	Fri, 17 Jun 2022 04:50:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pY4Rq8eIv6+B; Fri, 17 Jun 2022 04:50:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 599564B249;
	Fri, 17 Jun 2022 04:50:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B8054B1A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 04:50:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 116Ymm2LmZUF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 04:50:49 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B58B64B133
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 04:50:49 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2159CB827CB;
 Fri, 17 Jun 2022 08:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFD8C3411B;
 Fri, 17 Jun 2022 08:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655455846;
 bh=c/802ysll8Uki8K7DNXXeYK+6Hshm0ZRzMFKDT/R5y0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=l34oNkGtiMK10v/6Eb56qZkXkJYA9qFULLpSaVeXUwh77j4GpjR8jNUa1rSyqA6Cs
 j9BhdySQZ6r1wg5g0HnThfGCOsSoA7lm+5/GlsOA6IKEV/bVhJnMjeKV69XHUasWup
 52u5ShSQSjAbQJ8kF1oktqnmI0gmCmAZ9VA+Fbt80XTxNHYdqyAi2blnuObrMOWRRF
 mvazN7SxrJQLe1g7S6+pKVx5XW4qYoi3kzbXbfernlFx0/nVJprWzuSRMOC0z9CdEv
 9bMq8/ek4bi2KSoiEbYSFConEq/8vXB67YSZ9fQGuc978KJGJkitHEgcyrCbzIPuwu
 UAu9QFZK3Le2Q==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o27gi-001FiI-VG;
 Fri, 17 Jun 2022 09:50:45 +0100
MIME-Version: 1.0
Date: Fri, 17 Jun 2022 09:50:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] KVM: arm64: Prevent kmemleak from accessing pKVM memory
In-Reply-To: <Yqw/PI6jF5HZTvxB@google.com>
References: <20220616161135.3997786-1-qperret@google.com>
 <165545408679.771055.5076080259874437048.b4-ty@kernel.org>
 <Yqw9dou3qgpAKQkZ@kernel.org> <Yqw/PI6jF5HZTvxB@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <fa3b5bb1caeaaf98b8a754504c3c9be1@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qperret@google.com, rppt@kernel.org, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, james.morse@arm.com, will@kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 2022-06-17 09:45, Quentin Perret wrote:
> On Friday 17 Jun 2022 at 11:38:14 (+0300), Mike Rapoport wrote:
>> On Fri, Jun 17, 2022 at 09:21:31AM +0100, Marc Zyngier wrote:
>> > On Thu, 16 Jun 2022 16:11:34 +0000, Quentin Perret wrote:
>> > > Commit a7259df76702 ("memblock: make memblock_find_in_range method
>> > > private") changed the API using which memory is reserved for the pKVM
>> > > hypervisor. However, it seems that memblock_phys_alloc() differs
>> > > from the original API in terms of kmemleak semantics -- the old one
>> > > excluded the reserved regions from kmemleak scans when the new one
>> > > doesn't seem to. Unfortunately, when protected KVM is enabled, all
>> > > kernel accesses to pKVM-private memory result in a fatal exception,
>> > > which can now happen because of kmemleak scans:
>> > >
>> > > [...]
>> >
>> > Applied to fixes, thanks!
>> >
>> > [1/1] KVM: arm64: Prevent kmemleak from accessing pKVM memory
>> >       commit: 9e5afa8a537f742bccc2cd91bc0bef4b6483ee98
>> 
>> I'd really like to update the changelog to this:
>> 
>> Commit a7259df76702 ("memblock: make memblock_find_in_range method
>> private") changed the API using which memory is reserved for the pKVM
>> hypervisor. However, memblock_phys_alloc() differs from the original 
>> API in
>> terms of kmemleak semantics -- the old one didn't report the reserved
>> regions to kmemleak while the new one does. Unfortunately, when 
>> protected
>> KVM is enabled, all kernel accesses to pKVM-private memory result in a
>> fatal exception, which can now happen because of kmemleak scans:
>> 
>> $ echo scan > /sys/kernel/debug/kmemleak
>> [   34.991354] kvm [304]: nVHE hyp BUG at: [<ffff800008fa3750>] 
>> __kvm_nvhe_handle_host_mem_abort+0x270/0x290!
>> ...
>> 
>> Fix this by explicitly excluding the hypervisor's memory pool from
>> kmemleak like we already do for the hyp BSS.
> 
> Looks good to me, thanks.

Now updated. Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
