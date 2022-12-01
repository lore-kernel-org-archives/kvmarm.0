Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5740AC4321E
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 11:53:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 958E940458;
	Thu,  1 Dec 2022 06:53:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b+P4iijirQKc; Thu,  1 Dec 2022 06:53:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B14F9403CD;
	Thu,  1 Dec 2022 06:53:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 046AA403C2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 06:53:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TehAXA37e0YL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 06:53:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4E2403A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 06:53:14 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EBF1D6E;
 Thu,  1 Dec 2022 03:53:19 -0800 (PST)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC77B3F73D;
 Thu,  1 Dec 2022 03:53:10 -0800 (PST)
Date: Thu, 1 Dec 2022 11:53:08 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 02/12] firmware: arm_ffa: Move comment before the field
 it is documenting
Message-ID: <20221201115308.gciyfttnhvz2wcuz@bogus>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-3-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221116170335.2341003-3-qperret@google.com>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Walbran <qwandor@google.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.linux.dev,
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

Hi Quentin,

On Wed, Nov 16, 2022 at 05:03:25PM +0000, Quentin Perret wrote:
> From: Will Deacon <will@kernel.org>
> 
> This is consistent with the other comments in the struct.
>
Not sure how that happened :). Anyways,

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

I am yet to look at the other patches and I would like to have a setup
to test it as well. So I will look at the other patches and test it later.
The reason for reviewing the first 2 patches moving the code out of the
driver is to check if they can be merged for v6.2 itself.

I may start pushing FF-A v1.1 changes for v6.3 and trying to avoid conflicts
or cross tree dependencies. I know it is quite late for v6.2 but these changes
are trivial and good to get it in for v6.2 if possible.

Will, thoughts ? If you agree, please take it via arm64 for v6.2. I don't
have any FF-A changes for v6.2 ATM, so there should be not conflicts.

--
Regards,
Sudeep
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
