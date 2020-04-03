Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A250C43331
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 14:01:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D2FF2077D
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 14:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D2FF2077D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F5C74B16A;
	Fri,  3 Apr 2020 10:01:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zGDup1Gpuv7G; Fri,  3 Apr 2020 10:01:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 039194B0E8;
	Fri,  3 Apr 2020 10:01:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EDB44B0E8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 10:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gcmGENlNguSO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 10:01:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 977E74B0E7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 10:01:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2141431B;
 Fri,  3 Apr 2020 07:01:17 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18FC13F52E;
 Fri,  3 Apr 2020 07:01:15 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: arm64: PSCI fixes
To: Marc Zyngier <maz@kernel.org>
References: <20200401165816.530281-1-maz@kernel.org>
 <23107386-bbad-6ee1-c1cc-03dd70868905@arm.com> <20200403122024.60dcec10@why>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <427aa7ff-2033-0851-8748-3da49b795fcc@arm.com>
Date: Fri, 3 Apr 2020 15:01:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200403122024.60dcec10@why>
Content-Language: en-US
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

Hi,

On 4/3/20 12:20 PM, Marc Zyngier wrote:
> Hi Alexandru,
>
> On Fri, 3 Apr 2020 11:35:00 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Hi,
>>
>> On 4/1/20 5:58 PM, Marc Zyngier wrote:
>>> Christoffer recently pointed out that we don't narrow the arguments to
>>> SMC32 PSCI functions called by a 64bit guest. This could result in a
>>> guest failing to boot its secondary CPUs if it had junk in the upper
>>> 32bits. Yes, this is silly, but the guest is allowed to do that. Duh.
>>>
>>> Whist I was looking at this, it became apparent that we allow a 32bit
>>> guest to call 64bit functions, which the spec explicitly forbids. Oh
>>> well, another patch.
>>>
>>> This has been lightly tested, but I feel that we could do with a new
>>> set of PSCI corner cases in KVM-unit-tests (hint, nudge... ;-).  
>> Good idea. I was already planning to add new PSCI and timer tests, I'm waiting for
>> Paolo to merge the pull request from Drew, which contains some fixes for the
>> current tests.
>>
>>> Marc Zyngier (2):
>>>   KVM: arm64: PSCI: Narrow input registers when using 32bit functions
>>>   KVM: arm64: PSCI: Forbid 64bit functions for 32bit guests
>>>
>>>  virt/kvm/arm/psci.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 40 insertions(+)
>>>  
>> I started reviewing the patches and I have a question. I'm probably missing
>> something, but why make the changes to the PSCI code instead of making them in the
>> kvm_hvc_call_handler function? From my understanding of the code, making the
>> changes there would benefit all firmware interface that use SMCCC as the
>> communication protocol, not just PSCI.
> The problem is that it is not obvious whether other functions have
> similar requirements. For example, the old PSCI 0.1 functions are
> completely outside of the SMCCC scope (there is no split between 32 and
> 64bit functions, for example), and there is no generic way to discover
> the number of arguments that you would want to narrow.

You're right, there's really no way to tell if the guest is using SMC32 or SMC64
other than looking at the function IDs, so having the PSCI code do the checking is
the right thing to do.

Thanks,
Alex
>
> Thanks,
>
> 	M.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
