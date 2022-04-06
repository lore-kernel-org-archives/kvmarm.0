Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B418C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 13:22:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F20294B176;
	Wed,  6 Apr 2022 09:22:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fXPo5AiApxF5; Wed,  6 Apr 2022 09:22:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA0A14B1A2;
	Wed,  6 Apr 2022 09:22:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7F24B188
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 09:22:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O5CFYxni3eTG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 09:22:27 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CF114B176
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 09:22:27 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 45C4F614B3;
 Wed,  6 Apr 2022 13:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E9AC385A3;
 Wed,  6 Apr 2022 13:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649251345;
 bh=9k56kW2D3yicG0k9iNteeTEcYhgp9gswCX5undOXTec=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=h5RMe+y/iK5Bf8ceKwFEK8f3MKQ+MSL0H+2A+mmXgaUxv2GtFA0DsWYoCohjISAXc
 SkbwYe0gg4/a1Be7sRv6j8BBkGQh3/MIA6Nt6FGS05RsUtIsXvwU/a7XjbzJZIcbq9
 ZF0gAHFpVyYxBbXhukEB1oah7onpsMUp8szFmq3PYgejudzgEQ6f2tEsbNgoLAG1Rv
 BBroAqOZyZX3LuRMfCkMbnQO7U5K4aF3wuo++3GQEz8B+hTNTiGzEPLBuLboEzzZLS
 aeg0tI6kTD576yfnXwUPXwpDMAzHhWXPB0WK1AyRLH2oDgp5sU40OvGZSkrlS6Xx49
 1n2XyUCuJWqVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nc5c7-002AfM-Fu; Wed, 06 Apr 2022 14:22:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2] KVM: arm64: Don't split hugepages outside of MMU write
 lock
Date: Wed,  6 Apr 2022 14:22:20 +0100
Message-Id: <164925133305.3716042.2193504931691635811.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401194652.950240-1-oupton@google.com>
References: <20220401194652.950240-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 reijiw@google.com, alexandru.elisei@arm.com, pshier@google.com,
 linux-arm-kernel@lists.infradead.org, jingzhangos@google.com,
 kvm@vger.kernel.org, suzuki.poulose@arm.com, james.morse@arm.com,
 ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
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

On Fri, 1 Apr 2022 19:46:52 +0000, Oliver Upton wrote:
> It is possible to take a stage-2 permission fault on a page larger than
> PAGE_SIZE. For example, when running a guest backed by 2M HugeTLB, KVM
> eagerly maps at the largest possible block size. When dirty logging is
> enabled on a memslot, KVM does *not* eagerly split these 2M stage-2
> mappings and instead clears the write bit on the pte.
> 
> Since dirty logging is always performed at PAGE_SIZE granularity, KVM
> lazily splits these 2M block mappings down to PAGE_SIZE in the stage-2
> fault handler. This operation must be done under the write lock. Since
> commit f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission
> relaxation during dirty logging"), the stage-2 fault handler
> conditionally takes the read lock on permission faults with dirty
> logging enabled. To that end, it is possible to split a 2M block mapping
> while only holding the read lock.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't split hugepages outside of MMU write lock
      commit: f587661f21eb9a38af52488bbe54ce61a64dfae8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
