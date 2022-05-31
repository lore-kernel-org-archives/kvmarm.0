Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F335C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 31 May 2022 16:57:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E6A94B416;
	Tue, 31 May 2022 12:57:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id isQOz4J+T1pg; Tue, 31 May 2022 12:57:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 634324B3D3;
	Tue, 31 May 2022 12:57:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 816584B3B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 12:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IDL8TK2F4PWi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2022 12:57:19 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 410F34B3AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 12:57:19 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id BAFC060C91;
 Tue, 31 May 2022 16:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BE0C34114;
 Tue, 31 May 2022 16:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654016237;
 bh=OAsO/LDcILzsEYb7Ai+a+cFkwhmI78SSd8v+OAbhhmE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=cw6Cl91tM514+EB8xrik4iPkzjJgRrMM1pZnMZo55VT8zieiuYdS66MhIrmbBp9Jm
 XODXUoxP068OSfkzpTu8v9a6/DL6imlDZ6pwnUVUMQkaSQYcN4mnLj8lTOXdRvSxBr
 bhKt5PZddhw1LkFrsWtcHWxtzzIAYxZ/BQRrTreRFXnK7aJdYIUIR1ITugUWJhM3QS
 OtesMoaNRwMPuVS73YThb5ZAzhlBuBtIt7BYTrh2zJjdF9Q52mpTLU+nvoOav0rLQf
 HqXkQ5gNqshdEX3zIEqCIlHw6xTLNrdEecGsH93r4aoaUlyLk18peKdzTJxDHfA3cq
 EYFAj7IKjzfmw==
Date: Tue, 31 May 2022 17:57:11 +0100
From: Will Deacon <will@kernel.org>
To: Qian Cai <quic_qiancai@quicinc.com>
Subject: Re: [PATCH] KVM: arm64: Fix memory leaks from stage2 pagetable
Message-ID: <20220531165710.GB25631@willie-the-truck>
References: <20220526203956.143873-1-quic_qiancai@quicinc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220526203956.143873-1-quic_qiancai@quicinc.com>
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

On Thu, May 26, 2022 at 04:39:56PM -0400, Qian Cai wrote:
> Running some SR-IOV workloads could trigger some leak reports from
> kmemleak.
> 
> unreferenced object 0xffff080243cef500 (size 128):
>   comm "qemu-system-aar", pid 179935, jiffies 4298359506 (age 1629.732s)
>   hex dump (first 32 bytes):
>     28 00 00 00 01 00 00 00 00 e0 4c 52 03 08 ff ff  (.........LR....
>     e0 af a4 7f 7c d1 ff ff a8 3c b3 08 00 80 ff ff  ....|....<......
>   backtrace:
>      kmem_cache_alloc_trace
>      kvm_init_stage2_mmu

Hmm, I can't spot a 128-byte allocation in here so this is pretty cryptic.
I don't really like the idea of papering over the report; we'd be better off
trying to reproduce it.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
