Return-Path: <SRS0=K0wf=4N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95916C35E0D
	for <kvmarm@archiver.kernel.org>; Tue, 25 Feb 2020 19:45:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D60221556
	for <kvmarm@archiver.kernel.org>; Tue, 25 Feb 2020 19:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlAG4Obz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D60221556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DF654B0D1;
	Tue, 25 Feb 2020 14:45:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mblLtOqayRYA; Tue, 25 Feb 2020 14:45:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7242D4B07E;
	Tue, 25 Feb 2020 14:45:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37A234B07E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Feb 2020 14:45:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C1HKb4lNwQNH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Feb 2020 14:45:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DAF84B078
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Feb 2020 14:45:09 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D6E1F2084E;
 Tue, 25 Feb 2020 19:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582659908;
 bh=Nj5eGcXxyq9FnFZMfH7juRDhSHO1VgSMIrQjWtUxLn8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=IlAG4Obz3PchfypDD708rExwBwE8cN7Zb9TRW43BV8yBwUbOw1SG3pVS4jKhcUEfs
 Zq8EsYhwA62Wkl862PGh5g3ox767G98NOPHNJ+jTL4s8KzmRdkSWWsdoTEjlq0IZQN
 XJ/aF0pQe0zMPC/F0O/4v9baF14IWkzC4VdPyCwo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j6g8g-007uWl-5Q; Tue, 25 Feb 2020 19:45:06 +0000
MIME-Version: 1.0
Date: Tue, 25 Feb 2020 19:45:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] irqchip/gic-v3-its: Clear Valid before writing any bits
 else in VPENDBASER
In-Reply-To: <6ce5c751-6d17-b9ee-4054-edad7de075bf@huawei.com>
References: <20200224025029.92-1-yuzenghui@huawei.com>
 <bb7cdb29eda9cf160bcf85a58a9fc63d@kernel.org>
 <6ce5c751-6d17-b9ee-4054-edad7de075bf@huawei.com>
Message-ID: <d8d9fbeddfe59574c457b2f803d0af6c@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 wanghaibin.wang@huawei.com, jiayanlei@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Yanlei Jia <jiayanlei@huawei.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Hi Zenghui,

On 2020-02-25 02:06, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/2/25 7:47, Marc Zyngier wrote:
>> Hi Zenghui,
>> 
>> On 2020-02-24 02:50, Zenghui Yu wrote:
>>> The Valid bit must be cleared before changing anything else when 
>>> writing
>>> GICR_VPENDBASER to avoid the UNPREDICTABLE behavior. This is exactly 
>>> what
>>> we've done on 32bit arm, but not on arm64.
>> 
>> I'm not quite sure how you decide that Valid must be cleared before 
>> changing
>> anything else. The reason why we do it on 32bit is that we cannot 
>> update
>> the full 64bit register at once, so we start by clearing Valid so that
>> we can update the rest. arm64 doesn't require that.
> 
> The problem came out from discussions with our GIC engineers and what 
> we
> talked about at that time was IHI 0069E 9.11.36 - the description of 
> the
> Valid field:
> 
> "Writing a new value to any bit of GICR_VPENDBASER, other than
> GICR_VPENDBASER.Valid, when GICR_VPENDBASER.Valid==1 is UNPREDICTABLE."
> 
> It looks like we should first clear the Valid and then write something
> else. We might have some mis-understanding about this statement..

So that's the v4.0 version of VPENDBASER. On v4.0, you start by clearing
Valid, not changing any other bit. Subsequent polling of the leads to
the PendingLast bit once Dirty clears. The current code follows this
principle.

>> For the rest of discussion, let's ignore GICv4.1 32bit support (I'm
>> pretty sure nobody cares about that).
>> 
>>> This works fine on GICv4 where we only clear Valid for a vPE 
>>> deschedule.
>>> With the introduction of GICv4.1, we might also need to talk 
>>> something else
>>> (e.g., PendingLast, Doorbell) to the redistributor when clearing the 
>>> Valid.
>>> Let's port the 32bit gicr_write_vpendbaser() to arm64 so that 
>>> hardware can
>>> do the right thing after descheduling the vPE.
>> 
>> The spec says that:
>> 
>> "For a write that writes GICR_VPENDBASER.Valid from 1 to 0, if
>> GICR_VPENDBASER.PendingLast is written as 1 then 
>> GICR_VPENDBASER.PendingLast
>> takes an UNKNOWN value and GICR_VPENDBASER.Doorbell is treated as 
>> being 0."
>> 
>> and
>> 
>> "When GICR_VPENDBASER.Valid is written from 1 to 0, if there are 
>> outstanding
>> enabled pending interrupts GICR_VPENDBASER.Doorbell is treated as 0."
>> 
>> which indicate that PendingLast/Doorbell have to be written at the 
>> same time
>> as we clear Valid.
> 
> Yes. I obviously missed these two points when writing this patch.
> 
>> Can you point me to the bit of the v4.1 spec that makes
>> this "clear Valid before doing anything else" requirement explicit?
> 
> No, nothing in v4.1 spec supports me :-(  The above has been forwarded
> to Hisilicon and I will confirm these with them. It would be easy for
> hardware to handle the PendingLast/DB when clearing Valid, I think.

v4.1 changes the way VPENDBASER works in a number of way. Clearing Valid 
allows
a "handshake": At the point of making the vPE non-resident, to specify 
the
expected behaviour of the redistributor once the residency has been 
completed.
This includes requesting the doorbell or telling the GIC that we don't 
care to
know about PendingLast.

This is effectively a relaxation of the v4.0 behaviour. I believe the 
current
state of the driver matches both specs (not using common code though).

Thanks,

         M.

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
