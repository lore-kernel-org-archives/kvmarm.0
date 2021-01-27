Return-Path: <SRS0=cUgw=G6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ECCC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 17:01:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F2D164DA6
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 17:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F2D164DA6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5F134B1C7;
	Wed, 27 Jan 2021 12:01:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SphIr-9wsTGo; Wed, 27 Jan 2021 12:01:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 825C64B2CE;
	Wed, 27 Jan 2021 12:01:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 098064B2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 12:01:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8XxKKjtBA7DB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jan 2021 12:00:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1384B2CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 12:00:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F1F41FB;
 Wed, 27 Jan 2021 09:00:55 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA0F53F66E;
 Wed, 27 Jan 2021 09:00:53 -0800 (PST)
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
To: Marc Zyngier <maz@kernel.org>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <59700102-5340-b5ec-28e2-d95ee3e59c6b@arm.com>
 <1b594e7b1f47e372ea84f759507db0b9@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <cd3d33ff-6217-6a7f-3110-fe728d6c11be@arm.com>
Date: Wed, 27 Jan 2021 17:00:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1b594e7b1f47e372ea84f759507db0b9@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On 1/27/21 2:35 PM, Marc Zyngier wrote:
> Hi Alex,
>
> On 2021-01-27 14:09, Alexandru Elisei wrote:
>> Hi Marc,
>>
>> On 1/25/21 12:26 PM, Marc Zyngier wrote:
>>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>>> pretty easy. All that is required is support for PMMIR_EL1, which
>>> is read-only, and for which returning 0 is a valid option as long
>>> as we don't advertise STALL_SLOT as an implemented event.
>>
>> According to ARM DDI 0487F.b, page D7-2743:
>>
>> "If ARMv8.4-PMU is implemented:
>> - If STALL_SLOT is not implemented, it is IMPLEMENTATION DEFINED
>> whether the PMMIR
>> System registers are implemented.
>> - If STALL_SLOT is implemented, then the PMMIR System registers are
>> implemented."
>>
>> I tried to come up with a reason why PMMIR is emulated instead of being left
>> undefined, but I couldn't figure it out. Would you mind adding a comment or
>> changing the commit message to explain that?
>
> The main reason is that PMMIR gets new fields down the line,
> and doing the bare minimum in term of implementation allows
> us to gently ease into it.
I think I understand what you are saying - add a bare minimum emulation of the
PMMIR register now so it's less work when we do decide to support the STALL_SLOT
event for a guest.
>
> We could also go for the full PMMIR reporting on homogeneous
> systems too, as a further improvement.
>
> What do you think?

I don't have an opinion either way. But if you do decide to add full emulation for
STALL_SLOT, I would like to help with reviewing the patches (I'm curious to see
how KVM will detect that it's running on a homogeneous system).

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
