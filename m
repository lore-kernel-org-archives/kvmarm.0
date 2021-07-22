Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E0AC6377D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 15:22:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EB8A60FDA
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 15:22:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EB8A60FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B132E402DB;
	Thu, 22 Jul 2021 11:22:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sxKhAKzYgdf7; Thu, 22 Jul 2021 11:22:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF1C74029F;
	Thu, 22 Jul 2021 11:22:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08D8F4029F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 11:22:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rpaA+h4ZHfUI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jul 2021 11:22:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C10DE4029C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 11:22:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCA88106F;
 Thu, 22 Jul 2021 08:22:28 -0700 (PDT)
Received: from [10.57.7.91] (unknown [10.57.7.91])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E3563F694;
 Thu, 22 Jul 2021 08:22:27 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] kvm/arm: Align the VMID allocation with the arm64
 ASID one
To: Will Deacon <will@kernel.org>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-4-shameerali.kolothum.thodi@huawei.com>
 <20210721163138.GD11003@willie-the-truck>
 <f7d708704fb84380af85298a98f7a48c@huawei.com>
 <20210722095010.GA12012@willie-the-truck>
From: Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <43b32e77-52b1-8524-63a1-c99578c2dd1d@arm.com>
Date: Thu, 22 Jul 2021 16:22:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210722095010.GA12012@willie-the-truck>
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

On 7/22/21 10:50 AM, Will Deacon wrote:
> As an aside: I'm more and more inclined to rip out the CnP stuff given
> that it doesn't appear to being any benefits, but does have some clear
> downsides. Perhaps something for next week.

Can you please clarify what do you mean by "it doesn't appear to being any
benefits"? IIRC, Cortex-A65 implements CnP hint and I've heard that some
payloads seen improvement...

Cheers
Vladimir 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
