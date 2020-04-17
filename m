Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D74BC2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 15:11:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9F0322240
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 15:11:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9F0322240
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 548954B1F1;
	Fri, 17 Apr 2020 11:11:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jrfjFZudxnNV; Fri, 17 Apr 2020 11:11:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 225C14B20D;
	Fri, 17 Apr 2020 11:11:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B0104B201
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 11:11:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q5R2ww1Wh7nM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 11:11:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D023E4B1F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 11:11:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A3C230E;
 Fri, 17 Apr 2020 08:11:29 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 935F53F73D;
 Fri, 17 Apr 2020 08:11:27 -0700 (PDT)
Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To: "Zengtao (B)" <prime.zeng@hisilicon.com>, Marc Zyngier <maz@kernel.org>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
 <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
 <86r1wus7df.wl-maz@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f55386a9-8eaa-944f-453d-9c3c4abee5fb@arm.com>
Date: Fri, 17 Apr 2020 16:11:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
Content-Language: en-US
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Ganapatrao Kulkarni <gkulkarni@marvell.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "andre.przywara@arm.com" <andre.przywara@arm.com>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 George Cherian <gcherian@marvell.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Anil Kumar Reddy H <areddy3@marvell.com>
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

On 4/16/20 2:38 AM, Zengtao (B) wrote:
> Hi Marc:
>
> Got it.
> Really a bit patch set :)
>
> BTW, I have done a basic kvm unit test
> git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
> The psci test failed for some reason, I can't understand why, this
> is only the test result.(find the patch by git bisect + kvm test)

Just a heads-up, a couple of fixes to kvm-unit-tests were merged last week, and
among them was one touching the psci code, e14e6ba56f6e ("arm/arm64: psci: Don't
run C code without stack or vectors"). It might be worth checking that you have
it, and if you don't, if applying it fixes the issue.

Thanks,
Alex
>
> My platform: Hisilicon D06 board.
> Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
> Could you help to take a look?
>
> Thanks 
> Zengtao 
>
>> -----Original Message-----
>> From: Marc Zyngier [mailto:maz@kernel.org]
>> Sent: Saturday, April 11, 2020 5:24 PM
>> To: Zengtao (B)
>> Cc: George Cherian; Dave.Martin@arm.com; alexandru.elisei@arm.com;
>> andre.przywara@arm.com; christoffer.dall@arm.com;
>> james.morse@arm.com; jintack@cs.columbia.edu;
>> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
>> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
>> suzuki.poulose@arm.com; Anil Kumar Reddy H; Ganapatrao Kulkarni
>> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
>> Virtualization support
>>
>> Hi Zengtao,
>>
>> On Sat, 11 Apr 2020 05:10:05 +0100,
>> "Zengtao (B)" <prime.zeng@hisilicon.com> wrote:
>>> Hi Marc:
>>>
>>> Since it's a very large patch series, I want to test it on my platform
>>>  which don't support nv, and want to make sure if this patch series
>>> affects the existed virtualization functions or not.
>>>
>>> Any suggestion about the test focus?
>> Not really. Given that the NV patches affect absolutely every
>> architectural parts of KVM/arm64, everything needs careful
>> testing. But more than testing, it needs reviewing.
>>
>> Thanks,
>>
>> 	M.
>>
>> --
>> Jazz is not dead, it just smells funny.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
