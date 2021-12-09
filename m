Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF55C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 11:09:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36A144B0DB;
	Thu,  9 Dec 2021 06:09:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cAP7-8rkgREZ; Thu,  9 Dec 2021 06:09:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C4874B0DD;
	Thu,  9 Dec 2021 06:09:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE5D4B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 06:09:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UK3YRDVYtrMj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 06:09:39 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F6304B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 06:09:39 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B05A1B8240D;
 Thu,  9 Dec 2021 11:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E3FC004DD;
 Thu,  9 Dec 2021 11:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639048176;
 bh=VP6MRp/SOq7XOhf3FZQo/PNQmsVcRMAIn1+Uf+bBfs0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=uo1FZGUEHBNoxenzO8hUgEHTwU9ArYp4ZEjisLJDdO55swq8JpFB7qUNaICQdqh6a
 8S2bVDYrLtrS+t3qLYI4ut6IoVJAzUeaEDo+jIo1jgsIo/58Ocj+26BtQz1yOzHF43
 jGfiO0rmu7O7lJdQH6q6zaQpjg2PT2kvf70C1GqzUzbovI8YDszICqGGacfH1ONfra
 fZhJm9/ZkEWiOAUM+WK3lqKPFFqh0iKiDJF11LVf/4tDsZ8JcLzXT6xX4Lk/WNrC+5
 d+fSAbJkZdjNcPdu4R7V+ltg1COBunKbwn7W+vFtTrhLsHuU92cLfe+sIlQEwvcdxS
 ZvW/z6e/nPq7g==
Date: Thu, 9 Dec 2021 11:09:31 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 04/15] KVM: arm64: Fixup hyp stage-1 refcount
Message-ID: <20211209110930.GA1912@willie-the-truck>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-5-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211201170411.1561936-5-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Dec 01, 2021 at 05:03:58PM +0000, Quentin Perret wrote:
> In nVHE-protected mode, the hyp stage-1 page-table refcount is broken
> due to the lack of refcount support in the early allocator. Fix-up the
> refcount in the finalize walker, once the 'hyp_vmemmap' is up and running.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/setup.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
