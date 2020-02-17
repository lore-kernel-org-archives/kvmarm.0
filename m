Return-Path: <SRS0=AIE7=4F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DBCC34021
	for <kvmarm@archiver.kernel.org>; Mon, 17 Feb 2020 13:41:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E34712070B
	for <kvmarm@archiver.kernel.org>; Mon, 17 Feb 2020 13:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0y+9BYPb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E34712070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E1DC4AF52;
	Mon, 17 Feb 2020 08:41:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hXdpNr9fa2+2; Mon, 17 Feb 2020 08:41:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6172C4AF56;
	Mon, 17 Feb 2020 08:41:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 594824AF54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 08:41:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7pBEldorkj+C for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Feb 2020 08:41:23 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E9144AF52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 08:41:23 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 06D192070B;
 Mon, 17 Feb 2020 13:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581946882;
 bh=tbdEvdf/iPgFcEmtTo5xRVHBll2cVJBNEUT7VMieH2o=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=0y+9BYPbqi6vSSbFz5DTxlY+Gpnead5nMhaRnAy62noKXvukNSdoeYwrZGh4kDn1c
 RQzqtxoaWV6Lf7AmhPCrvYe74cvfzZK5sGsf7DkvThIEfx8MF0nya9HeOnIFftJDNa
 fSfx4YvR9b+0VfE9GUQm8iP6eCT5vQMoUT3Jx204=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j3geG-005vjd-1f; Mon, 17 Feb 2020 13:41:20 +0000
MIME-Version: 1.0
Date: Mon, 17 Feb 2020 13:41:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 09/94] KVM: arm64: nv: Support virtual EL2 exceptions
In-Reply-To: <20200217125240.GC47755@lakrids.cambridge.arm.com>
References: <20200211174938.27809-1-maz@kernel.org>
 <20200211174938.27809-10-maz@kernel.org>
 <20200217125240.GC47755@lakrids.cambridge.arm.com>
Message-ID: <6ad311202c1be408236899853f66c74a@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 Dave.Martin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

On 2020-02-17 12:52, Mark Rutland wrote:
> On Tue, Feb 11, 2020 at 05:48:13PM +0000, Marc Zyngier wrote:
>> From: Jintack Lim <jintack.lim@linaro.org>
>> 
>> Support injecting exceptions and performing exception returns to and
>> from virtual EL2.  This must be done entirely in software except when
>> taking an exception from vEL0 to vEL2 when the virtual 
>> HCR_EL2.{E2H,TGE}
>> == {1,1}  (a VHE guest hypervisor).
>> 
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/kvm_arm.h     |  17 +++
>>  arch/arm64/include/asm/kvm_emulate.h |  22 ++++
>>  arch/arm64/kvm/Makefile              |   2 +
>>  arch/arm64/kvm/emulate-nested.c      | 183 
>> +++++++++++++++++++++++++++
>>  arch/arm64/kvm/inject_fault.c        |  12 --
>>  arch/arm64/kvm/trace.h               |  56 ++++++++
>>  6 files changed, 280 insertions(+), 12 deletions(-)
>>  create mode 100644 arch/arm64/kvm/emulate-nested.c
> 
> [...]
> 
>> +static void enter_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
>> +				enum exception_type type)
>> +{
>> +	trace_kvm_inject_nested_exception(vcpu, esr_el2, type);
>> +
>> +	vcpu_write_sys_reg(vcpu, *vcpu_cpsr(vcpu), SPSR_EL2);
>> +	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
>> +	vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
>> +
>> +	*vcpu_pc(vcpu) = get_el2_except_vector(vcpu, type);
>> +	/* On an exception, PSTATE.SP becomes 1 */
>> +	*vcpu_cpsr(vcpu) = PSR_MODE_EL2h;
>> +	*vcpu_cpsr(vcpu) |= PSR_A_BIT | PSR_F_BIT | PSR_I_BIT | PSR_D_BIT;
>> +}
> 
> This needs to be fixed up to handle the rest of the PSTATE bits.
> 
> It should be possible to refactor get_except64_pstate() for that. I
> *think* the only differences are bits affects by SCTLR controls, but
> someone should audit that -- good thing we added references. :)

Absolutely. It is on my list of things to fix for the next drop. Also,
("arm64: KVM: nv: Honor SCTLR_EL2.SPAN on entering vEL2") should be
folded in there (or simply dropped if we can reuse the EL1 stuff).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
