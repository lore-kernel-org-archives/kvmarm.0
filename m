Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA00AC388F2
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 10:50:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FDA62231B
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 10:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="S82MY1bZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FDA62231B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73BD44B2A7;
	Mon,  2 Nov 2020 05:50:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iEEYTaZZGoDx; Mon,  2 Nov 2020 05:50:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9C184B4B6;
	Mon,  2 Nov 2020 05:50:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67DCC4B435
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 05:50:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1yrxslEFvGFL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 05:50:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FFE44B2A7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 05:50:09 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CC3942225E;
 Mon,  2 Nov 2020 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604314208;
 bh=+htN31sDu1zMSLBbjRPJx7cpi7upvixa/IKLQcRYJWs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=S82MY1bZxUYrH8xKoNglT8q8OmYf4bjYX83gPvS8Tzt2qG4jQ6qvEvIsF2HMiCjie
 UZJiDZlLwR9GD3Jdj6yPGVk9dQyWXPKJJJA30+SjWUN45grU0YvADvUdlPZWSrqFnH
 ePl78qFWjvFS7bsEwArAoHN0ZY29/nBAMZIpdeDU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZXPY-006dBj-Ov; Mon, 02 Nov 2020 10:50:05 +0000
MIME-Version: 1.0
Date: Mon, 02 Nov 2020 10:50:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: VM live migration failed from Linux v5.9 to Linux v5.10-rc1
In-Reply-To: <20201102102930.GA3226@willie-the-truck>
References: <5ade34aa-e725-93e8-7b28-83fb25dcf896@huawei.com>
 <87blgieddu.wl-maz@kernel.org> <20201102102930.GA3226@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <511aa7301bbead28f74aa4fb460a4e8e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, liangpeng10@huawei.com,
 kvmarm@lists.cs.columbia.edu, xiexiangyou@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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

On 2020-11-02 10:29, Will Deacon wrote:
> On Sat, Oct 31, 2020 at 01:25:17PM +0000, Marc Zyngier wrote:

[...]

>> +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>> +			       const struct sys_reg_desc *rd,
>> +			       const struct kvm_one_reg *reg, void __user *uaddr)
>> +{
>> +	const u64 id = sys_reg_to_index(rd);
>> +	int err;
>> +	u64 val;
>> +	u8 csv2;
>> +
>> +	err = reg_from_user(&val, uaddr, id);
>> +	if (err)
>> +		return err;
>> +
>> +	/*
>> +	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
>> +	 * it doesn't promise more than what is actually provided (the
>> +	 * guest could otherwise be covered in ectoplasmic residue).
>> +	 */
>> +	csv2 = FIELD_GET(0xfUL << ID_AA64PFR0_CSV2_SHIFT, val);
>> +	if (csv2 > vcpu->kvm->arch.pfr0_csv2)
>> +		return -EINVAL;
>> +	vcpu->kvm->arch.pfr0_csv2 = csv2;
> 
> We might need to be careful here, as this means the guest can now see a
> value of '2' and expect to use the SCXTNUM registers. I haven't checked
> what we do with those, but we never advertise them in the current code
> afaict.

I think a guest can already see CSV2=2 if supported on all the physical
CPUs (the current logic only overrides CSV2 if it is zero). Pretty easy
to fix (just cap it to 1), but we should definitely add the switching
capability to support CSV2=2.

I'll have a look at an additional patch address this.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
