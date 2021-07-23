Return-Path: <SRS0=3CJn=MP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EAAC4338F
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 15:49:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31A3E60EB6
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 15:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 31A3E60EB6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A303A4B162;
	Fri, 23 Jul 2021 11:49:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wmxJKi6TBXk5; Fri, 23 Jul 2021 11:49:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919664B14F;
	Fri, 23 Jul 2021 11:49:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A45EA4B14C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 11:49:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H+XXTuiLjCeP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jul 2021 11:49:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DB2C4B0FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 11:49:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4649139F;
 Fri, 23 Jul 2021 08:49:46 -0700 (PDT)
Received: from [10.57.8.76] (unknown [10.57.8.76])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0262A3F73D;
 Fri, 23 Jul 2021 08:49:44 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] kvm/arm: Align the VMID allocation with the arm64
 ASID one
To: Will Deacon <will@kernel.org>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-4-shameerali.kolothum.thodi@huawei.com>
 <20210721163138.GD11003@willie-the-truck>
 <f7d708704fb84380af85298a98f7a48c@huawei.com>
 <20210722095010.GA12012@willie-the-truck>
 <43b32e77-52b1-8524-63a1-c99578c2dd1d@arm.com>
 <20210722153814.GA12566@willie-the-truck>
From: Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <53f9359d-d3ac-5a3c-1e29-9fb7e9fda22c@arm.com>
Date: Fri, 23 Jul 2021 16:49:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210722153814.GA12566@willie-the-truck>
Content-Language: en-US
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 Linuxarm <linuxarm@huawei.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

Hi Will,

On 7/22/21 4:38 PM, Will Deacon wrote:
> Hi Vladimir,
> 
> On Thu, Jul 22, 2021 at 04:22:26PM +0100, Vladimir Murzin wrote:
>> On 7/22/21 10:50 AM, Will Deacon wrote:
>>> As an aside: I'm more and more inclined to rip out the CnP stuff given
>>> that it doesn't appear to being any benefits, but does have some clear
>>> downsides. Perhaps something for next week.
>>
>> Can you please clarify what do you mean by "it doesn't appear to being any
>> benefits"? IIRC, Cortex-A65 implements CnP hint and I've heard that some
>> payloads seen improvement...
> 
> Has anybody taped that out? I'd have thought building an SMT design in 2021
> is a reasonably courageous thing to do.

As you said three can be niche for that...

> 
> The issue I'm getting at is that modern cores seem to advertise CnP even
> if they ignore it internally, maybe because of some big/little worries?

Should we employ CPU errata framework for such cores to demote CnP?

> That would be fine if it didn't introduce complexity and overhead to the
> kernel, but it does and therefore I think we should rip it out (or at
> least stick it behind a "default n" config option if there are some niche
> users).

"default n" still better then no code at all :)

Cheers
Vladimir

> 
> There are also open questions as to exactly what CnP does because the
> architecture is not clear at all (for example TTBRx_EL1.CnP is permitted
> to be cached in a TLB).
> 
> CHeers,
> 
> Will
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
