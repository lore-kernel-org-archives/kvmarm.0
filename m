Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECF7C47089
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 15:50:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 866A0401AD;
	Thu,  1 Dec 2022 10:50:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8-uL9EfJuqrt; Thu,  1 Dec 2022 10:50:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47CD64038C;
	Thu,  1 Dec 2022 10:50:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9528040298
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 10:50:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4jhbRMwdOb7L for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 10:50:06 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 608EF401AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 10:50:06 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id CCD67B81F5E;
 Thu,  1 Dec 2022 15:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCE1C433C1;
 Thu,  1 Dec 2022 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1669909803;
 bh=LUT1bQztocCXvyDRR6quaBkfdm6TJC4VK3CcqENBpls=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=k0Z59nYHBrf584E9ogu8bxEUVrMHyFuQbzRH/g/hRi5fj+xjVT93zwZm2RbI4G2VA
 tvoMPjvOv2YXsQd8/iPu8/T1ExoPhhxCDDNBOISmlRWgebFQ4ftKQtnkIWLxFtxhda
 KYmycqreGvAfFEYwW98LiDTjAgO1CgwO6cXo69jdqYO/Fh8/nC16dL5NdosdKlHJh2
 wHozbBGE1I+upsM6V32hFdxebJPPOhEeRL87+HHM0Ll4vMMsomliXoflBOWze60DMF
 dmYtHRApxQCgNTDWJd+jdk2Wyaokq2PGxqIDjgNpvhzrzIkCVM7B2/PrsdU5/847/b
 DKYFPCDnCP8gA==
Date: Thu, 1 Dec 2022 15:49:56 +0000
From: Will Deacon <will@kernel.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH 02/12] firmware: arm_ffa: Move comment before the field
 it is documenting
Message-ID: <20221201154956.GA28682@willie-the-truck>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-3-qperret@google.com>
 <20221201115308.gciyfttnhvz2wcuz@bogus>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221201115308.gciyfttnhvz2wcuz@bogus>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Andrew Walbran <qwandor@google.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
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

On Thu, Dec 01, 2022 at 11:53:08AM +0000, Sudeep Holla wrote:
> On Wed, Nov 16, 2022 at 05:03:25PM +0000, Quentin Perret wrote:
> > From: Will Deacon <will@kernel.org>
> > 
> > This is consistent with the other comments in the struct.
> >
> Not sure how that happened :). Anyways,
> 
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> 
> I am yet to look at the other patches and I would like to have a setup
> to test it as well. So I will look at the other patches and test it later.
> The reason for reviewing the first 2 patches moving the code out of the
> driver is to check if they can be merged for v6.2 itself.
> 
> I may start pushing FF-A v1.1 changes for v6.3 and trying to avoid conflicts
> or cross tree dependencies. I know it is quite late for v6.2 but these changes
> are trivial and good to get it in for v6.2 if possible.
> 
> Will, thoughts ? If you agree, please take it via arm64 for v6.2. I don't
> have any FF-A changes for v6.2 ATM, so there should be not conflicts.

You're asking me to merge my own patches? Of course I can do that :D

Cheers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
