Return-Path: <SRS0=o2N9=YC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BB4ECE58E
	for <kvmarm@archiver.kernel.org>; Wed,  9 Oct 2019 13:42:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD915218AC
	for <kvmarm@archiver.kernel.org>; Wed,  9 Oct 2019 13:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD915218AC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2637A4A8C2;
	Wed,  9 Oct 2019 09:42:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OzQkpAD54-Vz; Wed,  9 Oct 2019 09:42:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 152904A8B7;
	Wed,  9 Oct 2019 09:42:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34B9B4A8B7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Oct 2019 09:42:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qJ3tJiHVlSE6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Oct 2019 09:42:19 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E12FF4A8B6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Oct 2019 09:42:17 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id E295C36A5D818A856480;
 Wed,  9 Oct 2019 21:42:13 +0800 (CST)
Received: from [127.0.0.1] (10.133.216.73) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 9 Oct 2019
 21:42:03 +0800
Subject: Re: [RFC PATCH 00/12] Add SDEI support for arm64
To: Peter Maydell <peter.maydell@linaro.org>
References: <1569338511-3572-1-git-send-email-guoheyi@huawei.com>
 <CAFEAcA_ztr0_Bu9d__dSr9oH75s2DSd5=6NZvVMrxuDTxf31mw@mail.gmail.com>
From: Guoheyi <guoheyi@huawei.com>
Message-ID: <84e1a629-bdd3-faaf-e12f-17930945adf4@huawei.com>
Date: Wed, 9 Oct 2019 21:42:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_ztr0_Bu9d__dSr9oH75s2DSd5=6NZvVMrxuDTxf31mw@mail.gmail.com>
X-Originating-IP: [10.133.216.73]
X-CFilter-Loop: Reflected
Cc: Marc
 Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>,
 Dave Martin <Dave.Martin@arm.com>, qemu-arm <qemu-arm@nongnu.org>,
 kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2019/9/30 21:15, Peter Maydell wrote:
> On Tue, 24 Sep 2019 at 16:23, Heyi Guo <guoheyi@huawei.com> wrote:
>> As promised, this is the first RFC patch set for arm64 SDEI support.
> Hi; for the benefit of possible reviewers who aren't familiar
> with every corner of the arm ecosystem, could you provide a
> summary of:
>   * what is SDEI ?
SDEI is for ARM "Software Delegated Exception Interface". AS ARM64 
doesn't have native non-maskable interrupt (NMI), we can rely on higher 
privileged software to change the pc of lower privileged software on 
certain events occur, to emulate NMI mechanism, and SDEI is the standard 
interfaces between the two levels of privileged software. It is based on 
SMC/HVC calls.

In virtualization situation, guest OS is the lower privileged software 
and hypervisor is the higher one. Major interfaces provided by SDEI include:
1. interrupt bind: guest OS can request to bind an interrupt to an SDEI 
event.
2. register: guest OS can request to register a handler to an SDEI 
event, so hypervisor will change pc of guest to this handler when 
certain event occurs.
3. complete: guest OS notifies hypervisor that it has completed the 
event handling, so hypervisor will restore the context of guest when it 
is interrupted.
>   * what do KVM and QEMU want/need to do with it ?
KVM is supposed to pass SMC/HVC calls to qemu, and qemu will serve the 
SDEI requests after parsing SMC/HVC calls. qemu also takes the 
responsibility to trigger the events. If an interrupt is requested to be 
bound to an event, qemu should not inject the interrupt to guest any 
more; instead, it should save the context of VCPU and change the PC to 
event handler which is registered by guest, and then return to guest.

To make the conversion of interrupt to SDEI event transparent to other 
modules in qemu, we used qemu_irq and qemu_irq_intercept_in() to 
override the default irq handler with SDEI event trigger. I saw 
qemu_irq_intercept_in() should be only used in qemu MST, but it seemed 
fit to override interrupt injection with event trigger after guest 
requests to bind interrupt to SDEI event.
>   * what is this patchset trying to solve ?
This patchset is trying to implement the whole SDEI framework in qemu 
with KVM enabled, including all SDEI v1.0 interfaces, as well as event 
trigger conduit from other qemu devices after interrupt binding.

I will also provide the above context in the cover letter of v2 RFC.

Thanks,

Heyi

>
> That would provide some useful context for trying to
> review the patchset.
>
> thanks
> -- PMM
>
> .
>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
