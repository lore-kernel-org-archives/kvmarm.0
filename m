Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8904FC33CB1
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 13:59:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C8AB222C3
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 13:59:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ytuEmCKm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C8AB222C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A69724B0EE;
	Wed, 15 Jan 2020 08:59:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JbhJWgUpZt0C; Wed, 15 Jan 2020 08:59:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D61634B10B;
	Wed, 15 Jan 2020 08:59:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 591544B0EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 08:59:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iiM17QEjCm8g for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 08:58:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34F964B090
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 08:58:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1EF70222C3;
 Wed, 15 Jan 2020 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579096738;
 bh=/G/weRCXbYPuSwrN2fOcmc9IMAtSW0V+wjMZcxSDxn8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ytuEmCKm0MYbr4DkGoe+3o7uNRCJlGbBzyN9FYICsCn4CppE/loxARmvmoz3h42Zd
 eH2gDh7+8+YPfaMiBYxAqP1E00+AMdDHCoZK7X6psiKuA0FLaczA+NAMD1rlE7dpjT
 O23E6godf3BYjzVUVq+n0cB/xaE4WRfxm0dcYl64=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1irjCC-0000PM-CF; Wed, 15 Jan 2020 13:58:56 +0000
MIME-Version: 1.0
Date: Wed, 15 Jan 2020 13:58:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: linmiaohe <linmiaohe@huawei.com>
Subject: Re: [PATCH] KVM: arm64: get rid of var ret and out jump label in
 kvm_arch_vcpu_ioctl_set_guest_debug()
In-Reply-To: <ab61de3a04a74f74866683b062d0bab2@huawei.com>
References: <ab61de3a04a74f74866683b062d0bab2@huawei.com>
Message-ID: <728a5ea123bf6f55b1653e4ccac76175@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linmiaohe@huawei.com, pbonzini@redhat.com,
 rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, christoffer.dall@arm.com, catalin.marinas@arm.com,
 eric.auger@redhat.com, gregkh@linuxfoundation.org, will@kernel.org,
 andre.przywara@arm.com, tglx@linutronix.de,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
 gregkh@linuxfoundation.org, pbonzini@redhat.com, tglx@linutronix.de,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On 2020-01-14 02:20, linmiaohe wrote:
> Friendly ping :)

Friendly reply:

>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> The var ret and out jump label is not really needed. Clean them up.
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>  arch/arm64/kvm/guest.c | 11 +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c index 
>> 2fff06114a8f..3b836c91609e 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -834,14 +834,10 @@ int kvm_arch_vcpu_ioctl_translate(struct 
>> kvm_vcpu *vcpu,  int kvm_arch_vcpu_ioctl_set_guest_debug(struct 
>> kvm_vcpu *vcpu,
>>  					struct kvm_guest_debug *dbg)
>>  {
>> -	int ret = 0;
>> -
>>  	trace_kvm_set_guest_debug(vcpu, dbg->control);
>> 
>> -	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK) {
>> -		ret = -EINVAL;
>> -		goto out;
>> -	}
>> +	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
>> +		return -EINVAL;
>> 
>>  	if (dbg->control & KVM_GUESTDBG_ENABLE) {
>>  		vcpu->guest_debug = dbg->control;
>> @@ -856,8 +852,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct 
>> kvm_vcpu *vcpu,
>>  		vcpu->guest_debug = 0;
>>  	}
>> 
>> -out:
>> -	return ret;
>> +	return 0;

I don't think there is anything wrong with the existing code.
It may not be to your own taste, but is in keeping with a lot
of the KVM code.

If you were making changes to this code, I wouldn't object.
But on its own, this is just churn.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
