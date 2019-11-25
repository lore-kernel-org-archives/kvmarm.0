Return-Path: <SRS0=lGdW=ZR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB604C432C3
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 17:08:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6333E20674
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 17:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6333E20674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B615A4A5BD;
	Mon, 25 Nov 2019 12:08:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7IJLs0LBdaXJ; Mon, 25 Nov 2019 12:08:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E0C04A534;
	Mon, 25 Nov 2019 12:08:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEEA24A51E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 12:08:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vzm+weYfVhMf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Nov 2019 12:08:18 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 725004A4F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 12:08:18 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iZHqS-0006PU-07; Mon, 25 Nov 2019 18:08:16 +0100
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH] target/arm: Honor =?UTF-8?Q?HCR=5FEL=32=2ETID=33=20tr?=
 =?UTF-8?Q?apping=20requirements?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 25 Nov 2019 17:08:15 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <CAFEAcA_MQpJ=8UFnP=Qnt+4GWMUO_AtJBBNz-bM2L2wf5htuaQ@mail.gmail.com>
References: <20191123115618.29230-1-maz@kernel.org>
 <CAFEAcA_MQpJ=8UFnP=Qnt+4GWMUO_AtJBBNz-bM2L2wf5htuaQ@mail.gmail.com>
Message-ID: <4d8c4763da39d5bfb1800735f90d82d1@www.loen.fr>
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

On 2019-11-25 16:21, Peter Maydell wrote:
> On Sat, 23 Nov 2019 at 11:56, Marc Zyngier <maz@kernel.org> wrote:
>>
>> HCR_EL2.TID3 mandates that access from EL1 to a long list of id
>> registers traps to EL2, and QEMU has so far ignored this 
>> requirement.
>>
>> This breaks (among other things) KVM guests that have PtrAuth 
>> enabled,
>> while the hypervisor doesn't want to expose the feature to its 
>> guest.
>> To achieve this, KVM traps the ID registers (ID_AA64ISAR1_EL1 in 
>> this
>> case), and masks out the unsupported feature.
>>
>> QEMU not honoring the trap request means that the guest observes
>> that the feature is present in the HW, starts using it, and dies
>> a horrible death when KVM injects an UNDEF, because the feature
>> *really* isn't supported.
>>
>> Do the right thing by trapping to EL2 if HCR_EL2.TID3 is set.
>>
>> Reported-by: Will Deacon <will@kernel.org>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>> There is a number of other trap bits missing (TID[0-2], for 
>> example),
>> but this at least gets a mainline Linux going with cpu=max.
>
> I guess this ought to go into 4.2, given that it gets recent
> Linux guest kernels to work.
>
>
>> @@ -6185,11 +6221,13 @@ void register_cp_regs_for_features(ARMCPU 
>> *cpu)
>>              { .name = "ID_AA64PFR0_EL1", .state = 
>> ARM_CP_STATE_AA64,
>>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 0,
>>                .access = PL1_R, .type = ARM_CP_NO_RAW,
>> +              .accessfn = access_aa64idreg,
>>                .readfn = id_aa64pfr0_read,
>>                .writefn = arm_cp_write_ignore },
>>              { .name = "ID_AA64PFR1_EL1", .state = 
>> ARM_CP_STATE_AA64,
>>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 1,
>>                .access = PL1_R, .type = ARM_CP_CONST,
>> +              .accessfn = access_aa64idreg,
>>                .resetvalue = cpu->isar.id_aa64pfr1},
>>              { .name = "ID_AA64PFR2_EL1_RESERVED", .state = 
>> ARM_CP_STATE_AA64,
>>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 2,
>> @@ -6198,151 +6236,188 @@ void register_cp_regs_for_features(ARMCPU 
>> *cpu)
>>              { .name = "ID_AA64PFR3_EL1_RESERVED", .state = 
>> ARM_CP_STATE_AA64,
>>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 3,
>>                .access = PL1_R, .type = ARM_CP_CONST,
>> +              .accessfn = access_aa64idreg,
>>                .resetvalue = 0 },
>
> Missing .accessfn for ID_AA4PFR2_EL1_RESERVED ?

Indeed, I oversaw that one. I'll fix it and repost it together with
the extra patches to handle TID1 and TID2.

>
>>              { .name = "ID_AA64ZFR0_EL1", .state = 
>> ARM_CP_STATE_AA64,
>>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 4,
>>                .access = PL1_R, .type = ARM_CP_CONST,
>> +              .accessfn = access_aa64idreg,
>>                /* At present, only SVEver == 0 is defined anyway.  
>> */
>>                .resetvalue = 0 },
>
>>              { .name = "MVFR0_EL1", .state = ARM_CP_STATE_AA64,
>>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 3, .opc2 = 0,
>>                .access = PL1_R, .type = ARM_CP_CONST,
>> +              .accessfn = access_aa64idreg,
>>                .resetvalue = cpu->isar.mvfr0 },
>
> These are the AArch64 accessors for the aarch32 MVFR registers,
> but this trap bit is also supposed to trap aarch32 accesses to
> the MVFR registers, which are via the vmrs insn. That needs
> to be done in trans_VMSR_VMRS(); we can do that with a
> followup patch, since the mechanism there is completely different.

Holy cow! I'm afraid that my newly acquired QEMU-foo is missing
a few key options. Does it mean we need to generate a trapping
instruction, as opposed to take the exception on access?

I'd very much appreciate some guidance here.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
