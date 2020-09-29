Return-Path: <SRS0=H5U9=DG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2566C4727C
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 17:49:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D0F7208B8
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 17:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwz05uUM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D0F7208B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B2DF4B21D;
	Tue, 29 Sep 2020 13:49:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sluvMPoMDwKF; Tue, 29 Sep 2020 13:49:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E7774B226;
	Tue, 29 Sep 2020 13:49:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A01A4B21C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 13:49:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vpbVGOdthvAQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2020 13:49:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AD994B217
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 13:49:15 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D85F1207F7;
 Tue, 29 Sep 2020 17:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601401754;
 bh=YaGpwYM4wHlLVZrnm0P7uWY9V+NN6+GoMAAn4esffgQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=nwz05uUMoXx4p9WCvb1j8pJ1aOL64KjEzq8nlGxVCFWzCUdEkXJeQ5m9m6ecVKr7m
 dSiVTTWIROrMfMbuLCf+jRSbCKn1+DzQv+0Vt0LRpjqjROJFs1K1Z2xfL/g1mWh4Q9
 QpbOm2G/Y1rXMxYXaqASjbWXrR6Lz99Ydjz7pLSs=
Date: Tue, 29 Sep 2020 18:49:08 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v4 10/10] kvm: arm64: Remove unnecessary hyp mappings
Message-ID: <20200929174908.GE14317@willie-the-truck>
References: <20200922204910.7265-1-dbrazdil@google.com>
 <20200922204910.7265-11-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200922204910.7265-11-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 22, 2020 at 09:49:10PM +0100, David Brazdil wrote:
> With all nVHE per-CPU variables being part of the hyp per-CPU region,
> mapping them individual is not necessary any longer. They are mapped to hyp
> as part of the overall per-CPU region.
> 
> Acked-by: Andrew Scull<ascull@google.com>

^^^ Missing space between "Scull" and "<".

> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h | 20 --------------------
>  arch/arm64/kvm/arm.c             | 16 ----------------
>  2 files changed, 36 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
