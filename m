Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B439BECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 12:47:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3672D4C469;
	Fri,  9 Sep 2022 08:47:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OQ9UPsAFC0mB; Fri,  9 Sep 2022 08:47:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06A674C625;
	Fri,  9 Sep 2022 08:47:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 899FF4C566
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 08:47:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l7cWIZbn4dQG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 08:47:38 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 557164C469
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 08:47:38 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4469B61FD9;
 Fri,  9 Sep 2022 12:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012B9C433D7;
 Fri,  9 Sep 2022 12:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1662727657;
 bh=8Iwo+623tVRzD2r3vitAeyrtiK1yPqT3anVJSO2QxeU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=HVMWq27rMWjzFRjQBSNAD3qRkTHd7Y0T6effGiKvHeS8XFp2qBogFa96RrHaXuD4N
 ydUipwlHUvfHcKeE4v0ZAdfdtD+zqnKJGbLhwXRRPEMTRRbWtNOMp5A8vqqBv2CLc9
 +NC6pQ3udz//0LQNMphNEw3QxFY+5Kni2XA99rKRVtW8xcTu7RwUqtc9GqBMMQy7v7
 PZBy/SsvEogbP9A6d6qbMBYsmj/vHK5XLK4qibz99ycfSwDr4Olzod7NxZ6b3t0oIT
 EmPyzHkuMih687aiVYMJF9IkXJq2slByeQv56EWavPfEnLPs2yYACqvOPppCWjiqfI
 UjCT1NnFUeEWg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oWdPy-009BXu-Pl;
 Fri, 09 Sep 2022 13:47:34 +0100
MIME-Version: 1.0
Date: Fri, 09 Sep 2022 13:47:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Report Protected KVM cap only if KVM is
 enabled
In-Reply-To: <Yxs1H3+iI8Y7+Zbu@arm.com>
References: <20220902040122.346654-1-quic_eberman@quicinc.com>
 <Yxs1H3+iI8Y7+Zbu@arm.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <485617e0d3635c1961ab30c1ad930c81@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, quic_eberman@quicinc.com,
 will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 dbrazdil@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Elliot Berman <quic_eberman@quicinc.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On 2022-09-09 13:44, Catalin Marinas wrote:
> On Thu, Sep 01, 2022 at 09:01:22PM -0700, Elliot Berman wrote:
>> If "kvm-arm.mode=protected" is present on kernel command line, but the
>> kernel doesn't actually support KVM because it booted from EL1, the
>> ARM64_KVM_PROTECTED_MODE capability is misleadingly reported as 
>> present.
>> Fix this by adding a check whether we booted from EL2.
>> 
>> Cc: Will Deacon <will@kernel.org>
>> Cc: David Brazdil <dbrazdil@google.com>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
>> ---
>>  arch/arm64/kernel/cpufeature.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/kernel/cpufeature.c 
>> b/arch/arm64/kernel/cpufeature.c
>> index 8d88433de81d..866667be0651 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -1974,7 +1974,7 @@ static void cpu_enable_mte(struct 
>> arm64_cpu_capabilities const *cap)
>>  #ifdef CONFIG_KVM
>>  static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities 
>> *entry, int __unused)
>>  {
>> -	return kvm_get_mode() == KVM_MODE_PROTECTED;
>> +	return is_hyp_mode_available() && kvm_get_mode() == 
>> KVM_MODE_PROTECTED;
>>  }
>>  #endif /* CONFIG_KVM */
> 
> Could we not fix this in early_kvm_mode_cfg()?

That's be indeed preferable.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
