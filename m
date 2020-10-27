Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF4DC55178
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 11:08:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D4A922265
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 11:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMlyud2Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D4A922265
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A467B4B565;
	Tue, 27 Oct 2020 07:08:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bESmOYZGj4Rc; Tue, 27 Oct 2020 07:08:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B31B4B52C;
	Tue, 27 Oct 2020 07:08:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8A034B4FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 07:08:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z96KVfDyPjCA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 07:08:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C755C4B4B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 07:08:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8589021655;
 Tue, 27 Oct 2020 11:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603796897;
 bh=hN0qy1y7mET6+8oBNyv6KDyBxf+wqltkkA89flTvk2g=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=RMlyud2QvQfcVq+rDgM86g3QNRieFI/7Rw11vGogACyi2THdd68p5C5TfD92/QQN6
 m5OTG9uyCFeOf0korrVWCqoBEWA8zoij9zbHBkggbW922lqwYcnvafLSTHtJPZ2bH0
 jO9D82+RWqGYQBV11sRc7SMMODdHYlhozByn0+74=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kXMpr-004fCh-7M; Tue, 27 Oct 2020 11:08:15 +0000
MIME-Version: 1.0
Date: Tue, 27 Oct 2020 11:08:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 03/11] KVM: arm64: Make kvm_skip_instr() and co private to
 HYP
In-Reply-To: <a2b942e5-651b-4733-4332-98b33fc6689b@arm.com>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-4-maz@kernel.org>
 <a2b942e5-651b-4733-4332-98b33fc6689b@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <3ae9d792ea381ba42874ebe5f7c08347@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, ascull@google.com, will@kernel.org,
 qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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

On 2020-10-27 10:55, Suzuki K Poulose wrote:
> On 10/26/20 1:34 PM, Marc Zyngier wrote:
>> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
>> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
>> to increment PC post emulation is now signalled via a flag in the
>> vcpu structure.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>

[...]

>> +static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
>> +{
>> +	if (vcpu_mode_is_32bit(vcpu)) {
>> +		kvm_skip_instr32(vcpu);
>> +	} else {
>> +		*vcpu_pc(vcpu) += 4;
>> +		*vcpu_cpsr(vcpu) &= ~PSR_BTYPE_MASK;
>> +	}
>> +
>> +	/* advance the singlestep state machine */
>> +	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
>> +}
>> +
>> +/*
>> + * Skip an instruction which has been emulated at hyp while most 
>> guest sysregs
>> + * are live.
>> + */
>> +static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
>> +{
>> +	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
>> +	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
>> +
>> +	__kvm_skip_instr(vcpu);
> 
> Did you mean kvm_skip_instr() instead ?

Damn. How embarrassing! Yes, of course. I should have thrown my TX1 at 
it!

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
