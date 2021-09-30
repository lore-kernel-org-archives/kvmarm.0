Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F9AC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 09:47:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47B4B61131
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 09:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 47B4B61131
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5CA049F5F;
	Thu, 30 Sep 2021 05:47:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tu6-7J-1qXzj; Thu, 30 Sep 2021 05:47:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CB624B091;
	Thu, 30 Sep 2021 05:47:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D84D49F5F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 05:47:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OG0j9WB0bS9t for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 05:47:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1D87406E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 05:47:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14B2FD6E;
 Thu, 30 Sep 2021 02:47:19 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DD8C3F793;
 Thu, 30 Sep 2021 02:47:17 -0700 (PDT)
Message-ID: <acd37032-b07f-c30c-f65f-d40cd85d2e74@arm.com>
Date: Thu, 30 Sep 2021 10:48:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 1/5] KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing
 a virtual GICv3
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20210924082542.2766170-1-maz@kernel.org>
 <20210924082542.2766170-2-maz@kernel.org>
 <7fe293a6-16af-929f-33b1-aa89675197b0@arm.com> <87k0iztljq.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
In-Reply-To: <87k0iztljq.wl-maz@kernel.org>
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

On 9/29/21 17:04, Marc Zyngier wrote:
> Hi Alex,
>
> On Wed, 29 Sep 2021 16:29:09 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 9/24/21 09:25, Marc Zyngier wrote:
>>> Until now, we always let ID_AA64PFR0_EL1.GIC reflect the value
>>> visible on the host, even if we were running a GICv2-enabled VM
>>> on a GICv3+compat host.
>>>
>>> That's fine, but we also now have the case of a host that does not
>>> expose ID_AA64PFR0_EL1.GIC==1 despite having a vGIC. Yes, this is
>>> confusing. Thank you M1.
>>>
>>> Let's go back to first principles and expose ID_AA64PFR0_EL1.GIC=1
>>> when a GICv3 is exposed to the guest. This also hides a GICv4.1
>>> CPU interface from the guest which has no business knowing about
>>> the v4.1 extension.
>> Had a look at the gic-v3 driver, and as far as I can tell it does
>> not check that a GICv3 is advertised in ID_AA64PFR0_EL1. If I didn't
>> get this wrong, then this patch is to ensure architectural
>> compliance for a guest even if the hardware is not necessarily
>> compliant, right?
> Indeed. Not having this made some of my own tests fail on M1 as they
> rely on ID_AA64PFR0_EL1.GIC being correct. I also pondered setting it
> to 0 when emulating a GICv2, but that'd be a change in behaviour, and
> I want to think a bit more about the effects of that.
>
>> GICv4.1 is an extension to GICv4 (which itself was an extension to
>> GICv3) to add support for virtualization features (virtual SGIs), so
>> I don't see any harm in hiding it from the guest, since the guest
>> cannot virtual SGIs.
> Indeed. The guest already has another way to look into this by
> checking whether the distributor allows active-less SGIs.

Thank you for the clarification, the patch looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Thanks,
>
> 	M.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
