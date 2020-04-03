Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297CDC43331
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 10:34:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5BBB20737
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 10:34:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5BBB20737
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A01F4B150;
	Fri,  3 Apr 2020 06:34:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Zv4iAE7Zp4t; Fri,  3 Apr 2020 06:34:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FFAD4B0E2;
	Fri,  3 Apr 2020 06:34:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5B64B0E2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 06:34:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tylb-EvpkEKB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 06:34:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 842234B0DC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 06:34:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD81D30E;
 Fri,  3 Apr 2020 03:34:37 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6CD23F71E;
 Fri,  3 Apr 2020 03:34:36 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: arm64: PSCI fixes
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20200401165816.530281-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <23107386-bbad-6ee1-c1cc-03dd70868905@arm.com>
Date: Fri, 3 Apr 2020 11:35:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401165816.530281-1-maz@kernel.org>
Content-Language: en-US
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

Hi,

On 4/1/20 5:58 PM, Marc Zyngier wrote:
> Christoffer recently pointed out that we don't narrow the arguments to
> SMC32 PSCI functions called by a 64bit guest. This could result in a
> guest failing to boot its secondary CPUs if it had junk in the upper
> 32bits. Yes, this is silly, but the guest is allowed to do that. Duh.
>
> Whist I was looking at this, it became apparent that we allow a 32bit
> guest to call 64bit functions, which the spec explicitly forbids. Oh
> well, another patch.
>
> This has been lightly tested, but I feel that we could do with a new
> set of PSCI corner cases in KVM-unit-tests (hint, nudge... ;-).

Good idea. I was already planning to add new PSCI and timer tests, I'm waiting for
Paolo to merge the pull request from Drew, which contains some fixes for the
current tests.

>
> Marc Zyngier (2):
>   KVM: arm64: PSCI: Narrow input registers when using 32bit functions
>   KVM: arm64: PSCI: Forbid 64bit functions for 32bit guests
>
>  virt/kvm/arm/psci.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
I started reviewing the patches and I have a question. I'm probably missing
something, but why make the changes to the PSCI code instead of making them in the
kvm_hvc_call_handler function? From my understanding of the code, making the
changes there would benefit all firmware interface that use SMCCC as the
communication protocol, not just PSCI.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
