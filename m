Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB15BC43217
	for <kvmarm@archiver.kernel.org>; Mon, 21 Nov 2022 18:09:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5344640B91;
	Mon, 21 Nov 2022 13:09:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X23S8d+ZAktx; Mon, 21 Nov 2022 13:09:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4328A49F38;
	Mon, 21 Nov 2022 13:09:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6FB44B2A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2022 13:09:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eo9kre+Uor1V for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Nov 2022 13:09:10 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6074A43479
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Nov 2022 13:09:10 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E664CB81258;
 Mon, 21 Nov 2022 18:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11659C433C1;
 Mon, 21 Nov 2022 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1669054147;
 bh=/7KHXu25uYdxptbYApPiI4X6tmxB+JZaBclz27zxScA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=s/GpyKDjXOFYp5ugSCAdXo1NhlB2IPARJM3jRaplMsXTLpV8lxciaQnUUyxQquulK
 KzEe49FCFaD8LuZy5w40TIz8akrFGG53YphhnwI5jTjvzL+/8C9YHEIelrPhT2xilp
 CFcT+oCqfydITYFEx1ZK3OI+iuL03YCEyIygLd19LEeKPQQ8m2HuC9LebUr+2cA4i0
 /MoOm0DInv0d9t1r/8qvWSt0x+gJwsPr+mi9mVlqj1ORRgENAhZmHOZfClgfcbHTBE
 XmnydxyEqRfCurqpHdYQZDorzFQqvAhcZmuPCp/ecd0IWnHVtsC41IQui39XQPk8/f
 yyvZa3qp0B0/g==
Date: Mon, 21 Nov 2022 18:09:02 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v4 0/3] KVM: arm64: Fixes for parallel faults series
Message-ID: <20221121180901.GC7645@willie-the-truck>
References: <20221118182222.3932898-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221118182222.3932898-1-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
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

On Fri, Nov 18, 2022 at 06:22:19PM +0000, Oliver Upton wrote:
> Small set of fixes for the parallel faults series. Most importantly,
> stop taking the RCU read lock for walking hyp stage-1. For the sake of
> consistency, take a pointer to kvm_pgtable_walker in
> kvm_dereference_pteref() as well.
> 
> Tested on an Ampere Altra system with kvm-arm.mode={nvhe,protected} and
> lockdep. Applies on top of the parallel faults series picked up last
> week.
> 
> v3: https://lore.kernel.org/kvmarm/20221116165655.2649475-1-oliver.upton@linux.dev/
> 
> v3 -> v4:
>  - Return an error instead of WARN() in hyp for shared walks (Will)

For the series:

Acked-by: Will Deacon <will@kernel.org>

Thanks!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
