Return-Path: <SRS0=lGdW=ZR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7796C432C0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 17:49:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7DD2E20679
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 17:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DD2E20679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD62B4A610;
	Mon, 25 Nov 2019 12:49:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wOPx-wGn1pgZ; Mon, 25 Nov 2019 12:49:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFBE4A65C;
	Mon, 25 Nov 2019 12:49:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A3CF4A5C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 12:49:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bQwMyzzU3Xm9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Nov 2019 12:49:10 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF03C4A5A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 12:49:09 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iZIU0-0006sM-23; Mon, 25 Nov 2019 18:49:08 +0100
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] target/arm: Honor =?UTF-8?Q?HCR=5FEL=32=2ETID=33=20tr?=
 =?UTF-8?Q?apping=20requirements?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 25 Nov 2019 17:49:07 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <CAFEAcA87ceF_0ifLn1t9CxyEwJ-rwW8h4QauJGk+ATphJaWa6Q@mail.gmail.com>
References: <20191123115618.29230-1-maz@kernel.org>
 <CAFEAcA_MQpJ=8UFnP=Qnt+4GWMUO_AtJBBNz-bM2L2wf5htuaQ@mail.gmail.com>
 <4d8c4763da39d5bfb1800735f90d82d1@www.loen.fr>
 <CAFEAcA87ceF_0ifLn1t9CxyEwJ-rwW8h4QauJGk+ATphJaWa6Q@mail.gmail.com>
Message-ID: <15acc2b5111716b10ab7624a1ee45ce7@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: peter.maydell@linaro.org, qemu-devel@nongnu.org,
 kvmarm@lists.cs.columbia.edu, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-11-25 17:27, Peter Maydell wrote:
> On Mon, 25 Nov 2019 at 17:08, Marc Zyngier <maz@kernel.org> wrote:
>>
>> On 2019-11-25 16:21, Peter Maydell wrote:
>> > Missing .accessfn for ID_AA4PFR2_EL1_RESERVED ?
>>
>> Indeed, I oversaw that one. I'll fix it and repost it together with
>> the extra patches to handle TID1 and TID2.
>
> Given that rc3 (last chance, more or less, for bugfixes for 4.2)
> is tomorrow, I propose that I take this patch with the
> +              .accessfn = access_aa64idreg,
> line for ID_AA64PFR2_EL1_RESERVED squashed in. I think
> TID1/TID2 and the MMFR-from-aarch32 parts are less urgent ?

That'd be great, thank you.

TID2 is only a nice to have (it allows us to virtualize the cache
hierarchy, only a performance optimization for fairly stupid 32bit
guests), and TID1 is so far unused by Linux.

I also had a look at TID0, but couldn't find any of the Jazelle
stuff in QEMU...

>> > These are the AArch64 accessors for the aarch32 MVFR registers,
>> > but this trap bit is also supposed to trap aarch32 accesses to
>> > the MVFR registers, which are via the vmrs insn. That needs
>> > to be done in trans_VMSR_VMRS(); we can do that with a
>> > followup patch, since the mechanism there is completely different.
>>
>> Holy cow! I'm afraid that my newly acquired QEMU-foo is missing
>> a few key options. Does it mean we need to generate a trapping
>> instruction, as opposed to take the exception on access?
>
> We will need to generate a call to a helper function which
> does the access check (and possibly raises an exception).
> We can't determine at translate time whether the insn is
> going to cause an exception, because the TID3 bit is not one
> of the fairly limited set of information which we put into
> the TB flags and allow to be baked into the generated code.
> (In theory we could add it, but we don't have very many TB
> flags so we only do that for cases where the overhead of doing
> the check at runtime matters.)

Ah! I guess you're referring to the HELPER() stuff in the various
target/arm/*_helper.c files? If so, I think I see how to do it.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
