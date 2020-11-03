Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EFDC2D0A3
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 18:29:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A6AE20786
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 18:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A6AE20786
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC3694B33C;
	Tue,  3 Nov 2020 13:29:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uqZavLQWfVnL; Tue,  3 Nov 2020 13:29:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 946204B5A5;
	Tue,  3 Nov 2020 13:29:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6B4B4B33C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 13:29:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A7mtad9WHmXI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 13:29:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B63C4B2F7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 13:29:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1DE91474;
 Tue,  3 Nov 2020 10:29:27 -0800 (PST)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFAFD3F718;
 Tue,  3 Nov 2020 10:29:26 -0800 (PST)
Subject: Re: [PATCH 0/8] KVM: arm64: Kill the copro array
To: Marc Zyngier <maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <d1d98b83-7d58-1ab4-f429-0f297071c34a@arm.com>
Date: Tue, 3 Nov 2020 18:29:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On 02/11/2020 19:16, Marc Zyngier wrote:
> Since the very beginning of KVM/arm64, we represented the system
> register file using a dual view: on one side the AArch64 state, on the

> other a bizarre mapping of the AArch64 state onto the Aarch64
> registers.

Now that would be bizarre!

mapping of the AArch32 state onto the Aarch64 registers?


> It was nice at the time as it allowed us to share some code with the
> 32bit port, and to come up with some creative bugs. But is was always
> a hack, and we are now in a position to simplify the whole thing.
> 
> This series goes through the whole of the AArch32 cp14/15 register
> file, and point each of them directly at their 64bit equivalent. For
> the few cases where two 32bit registers share a 64bit counterpart, we
> define which half of the register they map.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
