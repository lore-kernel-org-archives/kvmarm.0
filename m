Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E28C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 10:23:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43031207CB
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 10:23:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+Dno3Nf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43031207CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5FD34B214;
	Wed, 27 May 2020 06:23:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EWeX5aSits+r; Wed, 27 May 2020 06:23:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AF854B203;
	Wed, 27 May 2020 06:23:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B614B1C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 06:23:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HJq5kTawQzHe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 06:23:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A9DD4B18E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 06:23:00 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C1D99207CB;
 Wed, 27 May 2020 10:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590574978;
 bh=A4o6AQ11xM15anYtwypBhO8P5vfetakTLxp99W90wuY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=H+Dno3NfR/xe7QlwfmZtVqOewiqZuMfqzkYeg2HKsHD5yaLjIA0pGWcPaFAbK0GCu
 9ixtmldbrA9onTT7Xr+rexmfko5Ubp5dYvU8QreAd+rguINSFD7MnOg4bTKXOhvEAX
 AkhphrVvfFfS5dbJsmyB1Z+eedNXsX37mvNbz64A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jdtD7-00FfKg-6n; Wed, 27 May 2020 11:22:57 +0100
MIME-Version: 1.0
Date: Wed, 27 May 2020 11:22:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 19/26] KVM: arm64: Make struct kvm_regs userspace-only
In-Reply-To: <0a38305f-77f8-11b0-cb74-2bec07ce0a0a@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-20-maz@kernel.org>
 <0a38305f-77f8-11b0-cb74-2bec07ce0a0a@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8f1665abb0bd6f018cb8af53ec203b76@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>,
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

On 2020-05-26 17:29, James Morse wrote:
> Hi Marc,
> 
> On 22/04/2020 13:00, Marc Zyngier wrote:
>> struct kvm_regs is used by userspace to indicate which register gets
>> accessed by the {GET,SET}_ONE_REG API. But as we're about to refactor
>> the layout of the in-kernel register structures, we need the kernel to
>> move away from it.
>> 
>> Let's make kvm_regs userspace only, and let the kernel map it to its 
>> own
>> internal representation.
> 
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index 23ebe51410f06..9fec9231b63e2 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -102,6 +102,55 @@ static int core_reg_size_from_offset(const struct 
>> kvm_vcpu *vcpu, u64 off)
>>  	return size;
>>  }
>> 
>> +static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct 
>> kvm_one_reg *reg)
>> +{
>> +	u64 off = core_reg_offset_from_id(reg->id);
>> +
>> +	switch (off) {
> 
>> +	default:
>> +		return NULL;
> 
> Doesn't this switch statement catch an out of range offset, and a
> misaligned offset?
> 
> ... We still test for those explicitly in the caller. Better safe than 
> implicit?

Indeed, this is not supposed to happen at all. Maybe I should just fold
validate_core_offset offset there, and make this NULL value the error
case.

> 
>> +	}
>> +}
> 
> With the reset thing reported by Zenghui and Zengtao on the previous
> patch fixed:
> Reviewed-by: James Morse <james.morse@arm.com>
> 
> (otherwise struct kvm_regs isn't userspace-only!)

Indeed!

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
