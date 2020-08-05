Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2327C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 14:33:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 70EB22313E
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 14:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70EB22313E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C91C54B81A;
	Wed,  5 Aug 2020 10:33:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TzRv2uCZ7l3B; Wed,  5 Aug 2020 10:33:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A812F4B692;
	Wed,  5 Aug 2020 10:33:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 765814B61C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 10:33:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LfiVipdbRx-5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 10:33:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 551994B5FA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 10:33:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3A5A1424;
 Wed,  5 Aug 2020 07:33:24 -0700 (PDT)
Received: from [192.168.0.57] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD2773F7D7;
 Wed,  5 Aug 2020 07:33:23 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
To: Andrew Scull <ascull@google.com>, kvmarm@lists.cs.columbia.edu
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
From: James Morse <james.morse@arm.com>
Message-ID: <0cbb075a-ab5b-92a2-35bb-c3abb292ac84@arm.com>
Date: Wed, 5 Aug 2020 15:33:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730151823.1414808-2-ascull@google.com>
Content-Language: en-GB
Cc: will@kernel.org, maz@kernel.org, catalin.marinas@arm.com,
 kernel-team@android.com
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

Hi Andrew,

On 30/07/2020 16:18, Andrew Scull wrote:
> The ESB at the start of the vectors causes any SErrors to be consumed to
> DISR_EL1. If the exception came from the host and the ESB caught an
> SError, it would not be noticed until a guest exits and DISR_EL1 is
> checked. Further, the SError would be attributed to the guest and not
> the host.

Yup, this happens because the world has moved underneath this code:

Previously any v8.2 RAS capable system would have been crazy to turn off VHE, so v8.0 and
v8.1 systems had a nop here instead, and v8.2 systems had VHE, so there were no 'from the
host' EL2 vectors.


> To avoid these problems, use a different exception vector for the host
> that does not use an ESB but instead leaves any host SError pending. A
> guest will not be entered if an SError is pending so it will always be
> the host that will receive and handle it.
> 
> Hyp initialization is now passed the vector that is used for the host
> and the vector for guests is stored in a percpu variable as
> kvm_get_hyp_vector() is not suitable for calling from nVHE hyp.

> Fixes: 0e5b9c085dce ("KVM: arm64: Consume pending SError as early as possible")

Surely this can only happen if you had turned VHE off?


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
