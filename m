Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14434C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 18:10:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4404820678
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 18:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUtZu1Rn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4404820678
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA90E4B767;
	Mon,  9 Nov 2020 13:10:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h2Iny0DDtw3S; Mon,  9 Nov 2020 13:10:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE3A4B97E;
	Mon,  9 Nov 2020 13:10:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 594D04B6DA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 13:10:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I5zaUMsJO9es for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 13:10:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3725A4B619
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 13:10:09 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E735F20678;
 Mon,  9 Nov 2020 18:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604945408;
 bh=nYCGURReaUreeGBHrXbl9iNHp3A/C4AwY6eb8qAExsQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=KUtZu1RnUQqSxMBLI3fAWGVI5lMwBSpHUy5touvUvB0NURtA38bMOPugtz9BGhOQy
 vb35Fbvo9bPZjR3ZxgiiFfPdpk/Rha9GnYZk8knuTKFTryuOAjbfrxWFBSytOqzZZC
 sXJIhflIuW0amm+u+oHEvdGvGrD89NPunTQZb7cY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcBcD-009BeV-RM; Mon, 09 Nov 2020 18:10:05 +0000
MIME-Version: 1.0
Date: Mon, 09 Nov 2020 18:10:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v1 17/24] kvm: arm64: Add __hyp_pa_symbol helper macro
In-Reply-To: <20201109165933.GA447754@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-18-dbrazdil@google.com>
 <20201109165933.GA447754@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <1951645a457232caeca323bec2af5408@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: qperret@google.com, dbrazdil@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, dennis@kernel.org, tj@kernel.org, cl@linux.com,
 mark.rutland@arm.com, lorenzo.pieralisi@arm.com, ascull@google.com,
 qwandor@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

On 2020-11-09 16:59, Quentin Perret wrote:
> Hey David,
> 
> On Monday 09 Nov 2020 at 11:32:26 (+0000), David Brazdil wrote:
>> Add helper macro for computing the PA of a kernel symbol in nVHE hyp
>> code. This will be useful for computing the PA of a PSCI CPU_ON entry
>> point.
>> 
>> Signed-off-by: David Brazdil <dbrazdil@google.com>
>> ---
>>  arch/arm64/kvm/hyp/nvhe/psci.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>> 
>> diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c 
>> b/arch/arm64/kvm/hyp/nvhe/psci.c
>> index b0b5df590ba5..7510b9e174e9 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/psci.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/psci.c
>> @@ -20,6 +20,16 @@ s64 hyp_physvirt_offset;
>> 
>>  #define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
>> 
>> +#define __hyp_pa_symbol(sym)					\
>> +	({							\
>> +		extern char sym[];				\
>> +		unsigned long kern_va;				\
>> +								\
>> +		asm volatile("ldr %0, =%1" : "=r" (kern_va)	\
>> +					   : "S" (sym));	\
>> +		kern_va - kimage_voffset;			\
>> +	})
>> +
> 
> Could this be simplified to __hyp_pa(hyp_symbol_addr(sym))? That would
> avoid the dependency on kimage_voffset.

I'm going to move away from evaluating kimage_voffset at runtime anyway,
see [1].

Thanks,

         M.

[1] https://lore.kernel.org/r/20201109175923.445945-1-maz@kernel.org
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
