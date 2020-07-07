Return-Path: <SRS0=EuCB=AS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75E1C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 11:49:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7734E20739
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jul 2020 11:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZAo+Yhj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7734E20739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08BDE4B156;
	Tue,  7 Jul 2020 07:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XJkECkaiwMVK; Tue,  7 Jul 2020 07:49:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF2654B110;
	Tue,  7 Jul 2020 07:49:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC2594B110
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 07:49:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FDqF0rrG9aZx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2020 07:49:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5192D4B10C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2020 07:49:24 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0E822206DF;
 Tue,  7 Jul 2020 11:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594122563;
 bh=HsLqdAohKiqT7umIeVpFcBHJCRP29j3lOXD0jVG2vMs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=NZAo+YhjSP+fOdA4tk5sYKDs87kiGkgUk9icZPb+wAZDGHI9ZVYZEcZD/Lnz9nHQd
 3b3zmFjK9AWcRgaNSW9y0xyQEf7YAvJ8Ca1gKkRB9lKVqRA54DW5UCIopV7dyvrSQZ
 PM6PyfY04RyR6SNRdlvhlvXys18OkoUdP3GNaFqw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jsm6D-009jPD-ES; Tue, 07 Jul 2020 12:49:21 +0100
MIME-Version: 1.0
Date: Tue, 07 Jul 2020 12:49:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 00/17] KVM: arm64: Preliminary NV patches
In-Reply-To: <c5cd34b2-3360-e634-fe0f-9bbb91275235@arm.com>
References: <20200706125425.1671020-1-maz@kernel.org>
 <c5cd34b2-3360-e634-fe0f-9bbb91275235@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <336e9d1e8d2566d131e4326d71ddd161@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com,
 Dave.Martin@arm.com, jintack@cs.columbia.edu, gcherian@marvell.com,
 prime.zeng@hisilicon.com, ascull@google.com, will@kernel.org,
 mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-07-07 12:24, Alexandru Elisei wrote:
> Hi,
> 
> On 7/6/20 1:54 PM, Marc Zyngier wrote:
>> Hi all,
>> 
>> In order not to repeat the 90+ patch series that resulted in a
>> deafening silence last time, I've extracted a smaller set of patches
>> that form the required dependencies that allow the rest of the 65 NV
>> patches to be added on top. Yes, it is that bad.
>> 
>> The one real feature here is support for the ARMv8.4-TTL extension at
>> Stage-2 only. The reason to support it is that it helps the hypervisor
>> a lot when it comes to finding out how much to invalidate. It is thus
>> always "supported" with NV.
>> 
>> The rest doesn't contain any functionality change. Most of it reworks
>> existing data structures and adds new accessors for the things that
>> get moved around. The reason for this is that:
>> 
>> - With NV, we end-up with multiple Stage-2 MMU contexts per VM instead
>>   of a single one. This requires we divorce struct kvm from the S2 MMU
>>   configuration. Of course, we stick with a single MMU context for 
>> now.
>> 
>> - With ARMv8.4-NV, a number of system register accesses are turned
>>   into memory accesses into the so-called VNCR page. It is thus
>>   convenient to make this VNCR page part of the vcpu context and avoid
>>   copying data back and forth. For this to work, we need to make sure
>>   that all the VNCR-aware sysregs are moved into our per-vcpu sys_regs
>>   array instead of leaving in other data structures (the timers, for
>>   example). The VNCR page itself isn't introduced with these patches.
>> 
>> - As some of these data structures change, we need a way to isolate
>>   the userspace ABI from such change.
>> 
>> There is also a number of cleanups that were in the full fat series
>> that I decided to move early to get them out of the way.
>> 
>> The whole this is a bit of a mix of vaguely unrelated "stuff", but it
>> all comes together if you look at the final series. This applies on
>> top of David Brazdil's series splitting the VHE and nVHE objects.
>> 
>> I plan on taking this early into v5.9, and I really mean it this time!
>> 
>> Catalin: How do you want to proceed for patches 2, 3, and 4? I could
>> make a stable branch that gets you pull into the arm64 tree, or the
>> other way around. Just let me know.
>> 
>> Thanks,
>> 
>> 	M.
>> 
>> * From v2:
>>   - Rebased on top of David's el2-obj series
> 
> I tried to apply the patches on top of v5.8-rc1, but I get a conflict
> on the very
> first patch. I guess it's because I don't have the el2-obj series. Is 
> that v4 of
> "Split off nVHE hyp code" patches from David Brazil?

You need the slightly amended version (kvm-arm6/el2-obj-v4.1 from my 
tree).
Otherwise, just pick kvmarm/next, which has everything put together
in one scary lot.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
