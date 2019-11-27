Return-Path: <SRS0=fvcu=ZT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7D6C432C0
	for <kvmarm@archiver.kernel.org>; Wed, 27 Nov 2019 09:13:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C94B2070A
	for <kvmarm@archiver.kernel.org>; Wed, 27 Nov 2019 09:13:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C94B2070A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1294A5A0;
	Wed, 27 Nov 2019 04:13:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id haU38zkRqD46; Wed, 27 Nov 2019 04:13:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 998084A95E;
	Wed, 27 Nov 2019 04:13:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8912D4A59B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Nov 2019 04:13:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YdmONQmLJirF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Nov 2019 04:13:28 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F67C4A536
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Nov 2019 04:13:28 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iZtNz-0005g6-Ld; Wed, 27 Nov 2019 10:13:23 +0100
To: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH] target/arm: Honor =?UTF-8?Q?HCR=5FEL=32=2ETID=33=20tr?=
 =?UTF-8?Q?apping=20requirements?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Wed, 27 Nov 2019 09:13:23 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <11f7be55-a53d-bab1-c2e6-edbca1abb554@linaro.org>
References: <20191123115618.29230-1-maz@kernel.org>
 <11f7be55-a53d-bab1-c2e6-edbca1abb554@linaro.org>
Message-ID: <1d254223a9dc031c902bdf976f472025@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: richard.henderson@linaro.org, qemu-devel@nongnu.org,
 peter.maydell@linaro.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, qemu-devel@nongnu.org,
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

On 2019-11-26 21:04, Richard Henderson wrote:
> On 11/23/19 11:56 AM, Marc Zyngier wrote:
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
> BTW, Peter, this appears to have been the bug that was causing me so 
> many
> problems on my VHE branch.  Probably *exactly* this bug wrt ptrauth,
> since that would also be included with -cpu max.
>
> I am now able to boot a kvm guest kernel to the point of the no 
> rootfs panic,
> which I wasn't before.
>
> I can only think that I mis-identified the true cause in Lyon.
>
> Anyway, thanks Marc!

Hehe, glad it fixed more than just my pet issue! :-)

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
