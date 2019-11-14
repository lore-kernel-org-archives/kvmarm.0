Return-Path: <SRS0=Zv6D=ZG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FB1C432C3
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 14:50:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9EC392070E
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 14:50:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EC392070E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD18C4AF09;
	Thu, 14 Nov 2019 09:50:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vmBTjzcSB96V; Thu, 14 Nov 2019 09:50:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 404854AF1D;
	Thu, 14 Nov 2019 09:50:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C7A4AF01
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 09:50:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ygjHAdvrVVDR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Nov 2019 09:50:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 752D54ACBE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 09:50:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFFED328;
 Thu, 14 Nov 2019 06:50:25 -0800 (PST)
Received: from [10.1.32.172] (e121487-lin.cambridge.arm.com [10.1.32.172])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A1423F52E;
 Thu, 14 Nov 2019 06:50:24 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping
 GICD_CTLR.DS
To: Andre Przywara <andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-10-andre.przywara@arm.com>
 <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
 <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
 <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
From: Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <90cdc695-f761-26bd-d2a7-f8655ce04463@arm.com>
Date: Thu, 14 Nov 2019 14:50:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On 11/14/19 2:17 PM, Andre Przywara wrote:
> On Thu, 14 Nov 2019 13:39:33 +0000
> Vladimir Murzin <vladimir.murzin@arm.com> wrote:
> 
>> Hi,
>>
>> On 11/12/19 4:42 PM, Alexandru Elisei wrote:
>>> Are we not testing KVM? Why are we not treating a behaviour different than what
>>> KVM should emulate as a fail?
>>
>> Can kvm-unit-tests be run with qemu TCG?
> 
> Yes, it does that actually by default if you cross compile. I also tested this explicitly on TCG: unlike KVM that actually passes all those tests.
> If you set the environment variable ACCEL to either tcg or kvm, you can select this at runtime:
> $ ACCEL=tcg arm/run arm/gic.flat -smp 3 -append irq

Great! Then, IMO, it is absolutely valid to test this functionality!

Thanks
Vladimir

> 
> Cheers,
> Andre
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
