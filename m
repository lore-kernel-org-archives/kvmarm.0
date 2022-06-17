Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B635AC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 08:38:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18FC64B24A;
	Fri, 17 Jun 2022 04:38:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U59PrfqZGVlP; Fri, 17 Jun 2022 04:38:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC5244B232;
	Fri, 17 Jun 2022 04:38:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3D84B287
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 04:38:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QTULgDgcjswg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 04:38:27 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BBA44B1CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 04:38:27 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 7AC76B827CA;
 Fri, 17 Jun 2022 08:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602D8C3411B;
 Fri, 17 Jun 2022 08:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655455104;
 bh=/+PA0s6iDokI32NSUKyXUB8BkzRNE2/BPEMG8iwbzJo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lzhXz8zt15gWuroBUz4xp7oQIAyE2Zg7k0+EuLpVXGyzcayS5RLRo4utGjS2qT7Dy
 vZVNLx9AI4uoL3jm1N+xkt6pzKuDQ4n37PcWbOpIMDgcjt8g9IGect8wXJ2r1uk6gN
 ZcMijsDAlGeFKXDRQwAyc+uQj2mQk+qOKHFWpzHdERbvHu55fL2JxvFQQCcjB6ZsgN
 r42QoQ2bPbWgQlVapm7YHnn7gc79lQ/r1sr8/D2jAHFJXCHAdazY+kHfzMqXRxGqKb
 z6zabU/HjuYTH08Un3rRyqRTKm5VzO57zZpaxBeDlUbKH6UQE6z6FD2evVHpL1DdOB
 EHylArov6qpuA==
Date: Fri, 17 Jun 2022 11:38:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Prevent kmemleak from accessing pKVM memory
Message-ID: <Yqw9dou3qgpAKQkZ@kernel.org>
References: <20220616161135.3997786-1-qperret@google.com>
 <165545408679.771055.5076080259874437048.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <165545408679.771055.5076080259874437048.b4-ty@kernel.org>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
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

On Fri, Jun 17, 2022 at 09:21:31AM +0100, Marc Zyngier wrote:
> On Thu, 16 Jun 2022 16:11:34 +0000, Quentin Perret wrote:
> > Commit a7259df76702 ("memblock: make memblock_find_in_range method
> > private") changed the API using which memory is reserved for the pKVM
> > hypervisor. However, it seems that memblock_phys_alloc() differs
> > from the original API in terms of kmemleak semantics -- the old one
> > excluded the reserved regions from kmemleak scans when the new one
> > doesn't seem to. Unfortunately, when protected KVM is enabled, all
> > kernel accesses to pKVM-private memory result in a fatal exception,
> > which can now happen because of kmemleak scans:
> > 
> > [...]
> 
> Applied to fixes, thanks!
> 
> [1/1] KVM: arm64: Prevent kmemleak from accessing pKVM memory
>       commit: 9e5afa8a537f742bccc2cd91bc0bef4b6483ee98

I'd really like to update the changelog to this:

Commit a7259df76702 ("memblock: make memblock_find_in_range method
private") changed the API using which memory is reserved for the pKVM
hypervisor. However, memblock_phys_alloc() differs from the original API in
terms of kmemleak semantics -- the old one didn't report the reserved
regions to kmemleak while the new one does. Unfortunately, when protected
KVM is enabled, all kernel accesses to pKVM-private memory result in a
fatal exception, which can now happen because of kmemleak scans:

$ echo scan > /sys/kernel/debug/kmemleak
[   34.991354] kvm [304]: nVHE hyp BUG at: [<ffff800008fa3750>] __kvm_nvhe_handle_host_mem_abort+0x270/0x290!
...

Fix this by explicitly excluding the hypervisor's memory pool from
kmemleak like we already do for the hyp BSS.


> Cheers,
> 
> 	M.
> -- 
> Marc Zyngier <maz@kernel.org>
> 

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
