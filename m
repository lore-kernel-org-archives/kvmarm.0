Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036F2C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 10:12:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B33A4B11F;
	Thu,  9 Dec 2021 05:12:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hj58aOoxyvOx; Thu,  9 Dec 2021 05:12:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E9584B0DB;
	Thu,  9 Dec 2021 05:12:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 512424B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 05:12:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MiObI4jB9ZM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 05:12:37 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2667B49F8F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 05:12:37 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9C604B82416;
 Thu,  9 Dec 2021 10:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84348C004DD;
 Thu,  9 Dec 2021 10:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639044752;
 bh=5CVuyzSpwPK5TmWLQ6fBTGjSuL2lka26uX4aq31y1Bs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ThThVIeoFPj3DMZpyWlvdzqY+FnkqnUfV5IvxLRr4hbTmRLTbsc6wLmL/p0Hh/rHV
 rMuMUq0lRg9KHKaJgJQIp1GQn3YxlUJvToDgw7MiufeocpGwfUYrNebta1o5g6L+Pm
 AXfOmtuB8m75iquG2rVJX0cZN03fvzPTBz6ZTEE2cgFdOEWgrwiz9XOA9xQcUoVYNX
 iP325P9UhQ7HdcPVCtQa/slAvxHWWBJeF4jhO0XLD/nIIkPOR1VMdehp1GVT3Nuw2w
 pCZEQfjxBp0mYuWkdPSefQuonUsfnhs8X3fRL0JoaWFeKO2AA3Nk7+VasMnJsFSSLV
 Rh6H90IoEEVYw==
Date: Thu, 9 Dec 2021 10:12:27 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 02/15] KVM: arm64: Provide {get,put}_page() stubs for
 early hyp allocator
Message-ID: <20211209101226.GB1833@willie-the-truck>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-3-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211201170411.1561936-3-qperret@google.com>
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

On Wed, Dec 01, 2021 at 05:03:56PM +0000, Quentin Perret wrote:
> In nVHE protected mode, the EL2 code uses a temporary allocator during
> boot while re-creating its stage-1 page-table. Unfortunately, the
> hyp_vmmemap is not ready to use at this stage, so refcounting pages
> is not possible. That is not currently a problem because hyp stage-1
> mappings are never removed, which implies refcounting of page-table
> pages is unnecessary.
> 
> In preparation for allowing hypervisor stage-1 mappings to be removed,
> provide stub implementations for {get,put}_page() in the early allocator.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/early_alloc.c | 5 +++++
>  1 file changed, 5 insertions(+)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
