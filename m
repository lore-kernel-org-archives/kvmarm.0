Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DD1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 31 May 2022 17:02:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4504B208;
	Tue, 31 May 2022 13:02:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FhJ46n4wHzT6; Tue, 31 May 2022 13:02:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B1C4B386;
	Tue, 31 May 2022 13:02:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B1C4B208
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 13:02:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Svg1mpAuiME0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2022 13:02:04 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D08334B205
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 13:02:04 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BE60F60DDE;
 Tue, 31 May 2022 17:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB68C385A9;
 Tue, 31 May 2022 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654016523;
 bh=djguEZZRDPP3prGCOje7q6bgq4eAd52mgC9VJE+UvZo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=u8LXi8TrTLqG5iEZu55P2t2fyZ7OD8tsnQ5PXBbTHF/LgZ7Gi/yTmdTg35xoBS1iF
 kPWVMEi0YCNM3eiemsEVp4EWCKCcBMPir39ZJGsRQAiXvhi47LZTtJIz5CnwwL+BCC
 itAMIVSohp4iS+gL8uhbPTelu0YU8Tmf5gErzxEd7PqW/ikfvH/Nd1XUPACMS3Imf9
 KytTjEIc588n91CXJVh98FTVqVQQZ2/k/hHrC/O9VTR0YgOVWOc6xBnSEYwTmVv49V
 L3TY/sY3bxouJIpPcwL6yYLVMiIsCRS3RfMNniPc4lETv9a6GNBVMmERdniNJycG7o
 FnXOpjXSYq6BQ==
Date: Tue, 31 May 2022 18:01:58 +0100
From: Will Deacon <will@kernel.org>
To: Qian Cai <quic_qiancai@quicinc.com>
Subject: Re: [PATCH] KVM: arm64: Fix memory leaks from stage2 pagetable
Message-ID: <20220531170157.GC25631@willie-the-truck>
References: <20220526203956.143873-1-quic_qiancai@quicinc.com>
 <20220531165710.GB25631@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220531165710.GB25631@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, May 31, 2022 at 05:57:11PM +0100, Will Deacon wrote:
> On Thu, May 26, 2022 at 04:39:56PM -0400, Qian Cai wrote:
> > Running some SR-IOV workloads could trigger some leak reports from
> > kmemleak.
> > 
> > unreferenced object 0xffff080243cef500 (size 128):
> >   comm "qemu-system-aar", pid 179935, jiffies 4298359506 (age 1629.732s)
> >   hex dump (first 32 bytes):
> >     28 00 00 00 01 00 00 00 00 e0 4c 52 03 08 ff ff  (.........LR....
> >     e0 af a4 7f 7c d1 ff ff a8 3c b3 08 00 80 ff ff  ....|....<......
> >   backtrace:
> >      kmem_cache_alloc_trace
> >      kvm_init_stage2_mmu
> 
> Hmm, I can't spot a 128-byte allocation in here so this is pretty cryptic.
> I don't really like the idea of papering over the report; we'd be better off
> trying to reproduce it.

... although the hexdump does look like {u32; u32; ptr; ptr; ptr}, which
would match 'struct kvm_pgtable'. I guess the allocation is aligned to
ARCH_DMA_MINALIGN, which could explain the size?

Have you spotted any pattern for when the leak occurs? How are you
terminating the guest?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
