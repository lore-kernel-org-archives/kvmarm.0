Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43531C2BA18
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 08:02:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE5E921582
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 08:02:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4CRYcBs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE5E921582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65D8B4B15C;
	Fri,  3 Apr 2020 04:02:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s940amCLP2Rb; Fri,  3 Apr 2020 04:02:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5809C4B15B;
	Fri,  3 Apr 2020 04:02:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 652394B15B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 04:02:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kKLdaWLk+cL2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 04:02:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 649B14B158
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 04:02:10 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4A45A2080C;
 Fri,  3 Apr 2020 08:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585900929;
 bh=VAs8ug0wumKZqSGb+BllMltelj99c60YkpCVImFIGs4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=J4CRYcBs4n7tf2rcgY9u12fxsdAWat8hQaLGWNTe1MOA8OawQpHxqtovX+6NJ3CI8
 /lSr3syulXGxjuMHMpKZJVqqbsk+oBt4JEMswVCoLxlkH0YFYDNiaZfGi/dQWrvZeH
 UbeFXnS42iO62kLMmuQdSWxId8aooEqLt+/VO/28=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jKHHD-000R05-FQ; Fri, 03 Apr 2020 09:02:07 +0100
MIME-Version: 1.0
Date: Fri, 03 Apr 2020 09:02:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: George Cherian <gcherian@marvell.com>
Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
In-Reply-To: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
Message-ID: <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gcherian@marvell.com, Dave.Martin@arm.com,
 alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com,
 james.morse@arm.com, jintack@cs.columbia.edu, julien.thierry.kdev@gmail.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com,
 areddy3@marvell.com, gkulkarni@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, Ganapatrao Kulkarni <gkulkarni@marvell.com>,
 kvm@vger.kernel.org, andre.przywara@arm.com, Dave.Martin@arm.com,
 linux-arm-kernel@lists.infradead.org, Anil Kumar Reddy H <areddy3@marvell.com>
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

Hi George,

On 2020-04-03 08:27, George Cherian wrote:
> Hi Marc,
> 
> On 2/11/20 9:48 AM, Marc Zyngier wrote:
>> This is a major rework of the NV series that I posted over 6 months
>> ago[1], and a lot has changed since then:
>> 
>> - Early ARMv8.4-NV support
>> - ARMv8.4-TTL support in host and guest
>> - ARMv8.5-GTG support in host and guest
>> - Lots of comments addressed after the review
>> - Rebased on v5.6-rc1
>> - Way too many patches
>> 
>> In my defence, the whole of the NV code is still smaller that the
>> 32bit KVM/arm code I'm about to remove, so I feel less bad inflicting
>> this on everyone! ;-)
>> 
>> >From a functionality perspective, you can expect a L2 guest to work,
>> but don't even think of L3, as we only partially emulate the
>> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
>> as well as anything that would require a Stage-1 PTW. What we want to
>> achieve is that with NV disabled, there is no performance overhead and
>> no regression.
>> 
>> The series is roughly divided in 5 parts: exception handling, memory
>> virtualization, interrupts and timers for ARMv8.3, followed by the
>> ARMv8.4 support. There are of course some dependencies, but you'll
>> hopefully get the gist of it.
>> 
>> For the most courageous of you, I've put out a branch[2]. Of course,
>> you'll need some userspace. Andre maintains a hacked version of
>> kvmtool[3] that takes a --nested option, allowing the guest to be
>> started at EL2. You can run the whole stack in the Foundation
>> model. Don't be in a hurry ;-).
>> 
> The full series was tested on both Foundation model as well as Marvell 
> ThunderX3
> Emulation Platform.
> Basic boot testing done for Guest Hypervisor and Guest Guest.
> 
> Tested-by:  George Cherian <george.cherian@marvell.com>

Thanks for having given this a go.

However, without more details, it is pretty hard to find out what you 
have tested.
What sort of guest have you booted, with what configuration, what 
workloads did you
run in the L2 guests and what are the architectural features that TX3 
implements?

The last point is specially important, as the NV architecture spans two 
major
revisions of the architecture and affects tons of other extensions that 
are
themselves optional. Without any detail on that front, I have no idea 
what the
coverage of your testing is.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
