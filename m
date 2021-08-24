Return-Path: <SRS0=IXmk=NP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C46AC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 15:36:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCBA561357
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 15:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BCBA561357
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 411AC4B13C;
	Tue, 24 Aug 2021 11:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1hnF407yic5s; Tue, 24 Aug 2021 11:36:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F11D64B15E;
	Tue, 24 Aug 2021 11:36:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F71E4B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 11:36:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 28iCJRx38wts for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Aug 2021 11:36:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E53C44B13C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 11:36:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CBC631B;
 Tue, 24 Aug 2021 08:36:46 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B10A3F766;
 Tue, 24 Aug 2021 08:36:45 -0700 (PDT)
Subject: Re: [PATCH] arm64: Do not trap PMSNEVFR_EL1
To: Mark Brown <broonie@kernel.org>
References: <20210824132459.562923-1-alexandru.elisei@arm.com>
 <20210824151015.GB4393@sirena.org.uk>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <95ae126a-8fc2-1db1-a1fd-d6811644f507@arm.com>
Date: Tue, 24 Aug 2021 16:30:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210824151015.GB4393@sirena.org.uk>
Content-Language: en-US
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Mark,

On 8/24/21 4:10 PM, Mark Brown wrote:
> On Tue, Aug 24, 2021 at 02:24:59PM +0100, Alexandru Elisei wrote:
>
>> Commit 31c00d2aeaa2 ("arm64: Disable fine grained traps on boot") zeroed
>> the fine grained trap registers to prevent unwanted register traps from
>> occuring. However, for the PMSNEVFR_EL1 register, the corresponding
>> HDFGRTR_EL2.nPMSNEVFR_EL1 field must be 1 to disable trapping. Set the
>> field to 1 if FEAT_SPEv1p2 is detected.
> Oh, that's a shame :/  I wonder why this feature is different to the
> others, I just had a quick check and didn't see any other issues but...
>
>> Based on v5.14-rc7. Also, we could write 1 << 62 to HDFGRTR_EL2 uncondit=
ionally
>> since the field is RAZ/WI if !FEAT_SPEv1p2. I don't have a strong prefer=
ence for
>> either approaches, but I chose this implementation because it's clearer =
(even
>> though it's more verbose and it's one extra trap on NV).
> Yes, the explicit feature check is both clearer and more conservative -
> it's unlikely to have a practical impact but =

>
>> At this point, I am inclined to think it's a model bug because reading w=
orks,
>> but writing causes a hang and that looks very suspicious to me. I'm goin=
g to
>> open a model bug internally and see what comes of it.
> ...are you sure this isn't that the same issue also exists with the
> equivalent field HDFGWTR_EL2 - glancing at the XML it appears to have
> the same issue?  One of the fine grained aspects of fine grained traps
> is that there's separate read and write traps!

Yes, you are right, when I read the MSR PMSNEVFR_EL1, <Xt> pseudocode I mis=
sed the
fact that for writes the trap is controlled by HDFG*W*TR_EL1, not by
HDFG*R*TR_EL1. I set=A0 the nPMSNEVFR_EL1 bit in HDFGWRTR_EL1, and Linux do=
esn't
hang anymore when I try to write to the register. Will send v2 shortly.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
