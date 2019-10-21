Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D172CA9EAF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 13:59:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD28C214B2
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 13:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD28C214B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10B9B4A9F3;
	Mon, 21 Oct 2019 09:59:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f5bfnMWKsYcS; Mon, 21 Oct 2019 09:59:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CC644A9D9;
	Mon, 21 Oct 2019 09:59:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 016B44A9B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 09:59:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FUz1hN6GVn5w for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 09:59:27 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8D044A9AE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 09:59:27 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iMYDV-0004zv-5h; Mon, 21 Oct 2019 15:59:25 +0200
To: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 0/2] Improve handling of stage 2 aborts without
 instruction decode
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 21 Oct 2019 14:59:24 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191021133707.GA2652@e113682-lin.lund.arm.com>
References: <20191011110709.2764-1-christoffer.dall@arm.com>
 <865zkjzpbf.wl-maz@kernel.org>
 <20191021133707.GA2652@e113682-lin.lund.arm.com>
Message-ID: <3ba9db99efaadd8c9372708358da0ac6@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: christoffer.dall@arm.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, graf@amazon.com, berrange@redhat.com,
 xypron.glpk@gmx.de, stefanha@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: =?UTF-8?Q?=22Daniel_P=2E_Berrang=C3=A9=22?= <berrange@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>,
 Stefan Hajnoczi <stefanha@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-10-21 14:37, Christoffer Dall wrote:
> On Sun, Oct 20, 2019 at 11:25:24AM +0100, Marc Zyngier wrote:
>> Hi Christoffer,
>>
>> On Fri, 11 Oct 2019 12:07:04 +0100,
>> Christoffer Dall <christoffer.dall@arm.com> wrote:
>> >
>> > When a guest accesses memory outside the memory slots, KVM usually
>> > bounces the access back to userspace with KVM_EXIT_MMIO.  However, 
>> on
>> > arm/arm64 systems, certain load/store instructions did not provide
>> > decoding info for the hypervisor to emulate the instruction, and 
>> in this
>> > case KVM has rather rudely returned -ENOSYS and printed a not 
>> overly
>> > helpful error message:
>> >
>> >   load/store instruction decoding not implemented
>> >
>> > This patch series improves the error message and allows userspace 
>> to be
>> > notified of this event instead of receiving -ENOSYS, and also 
>> allows
>> > userspace to ask KVM to inject an external abort to the guest, 
>> which it
>> > can use for any memory access that it either cannot handle.
>> >
>> > One remaining case which this patch set does not address is if the 
>> guest
>> > accesses an in-kernel emulated device, such as the VGIC, but using 
>> a
>> > load/store instruction which doesn't provide decode info.  With 
>> these
>> > patches, this will return to userspace for it to handle, but 
>> there's no
>> > way for userspace to return the decoding information to KVM and 
>> have KVM
>> > complete the access to the in-kernel emulated device.  I have no 
>> plans
>> > to address this limitation.
>>
>> You had some pending comments on patch 2, and you seem to indicate
>> that you would respin the series. Do you have plans to do so in the
>> coming days? I'd like to put that series into -next, but I can 
>> either
>> wait for your respin, or queue it as it is and apply fixes on top.
>>
>
> I think those for v2 and this is v3 which should address those 
> concerns.
> Did I miss something or manage to confuse mysel here?

Gah! No, it looks like the mistake is mine. I've mixed the two series 
in my
Inbox, and the result is a total brain-fart. Ignore me.

I'll queue these patches ASAP.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
