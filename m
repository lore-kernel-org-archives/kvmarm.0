Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DB0C433FE
	for <kvmarm@archiver.kernel.org>; Sun, 13 Nov 2022 10:21:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CDA54B85B;
	Sun, 13 Nov 2022 05:21:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iEDzPHs2Jvg5; Sun, 13 Nov 2022 05:21:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65C4D4B85D;
	Sun, 13 Nov 2022 05:21:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4CF24B859
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Nov 2022 05:21:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 40NctvAMahQ9 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Nov 2022 05:21:06 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DB844B7D8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Nov 2022 05:21:06 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D826C60B37;
 Sun, 13 Nov 2022 10:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5F7C433C1;
 Sun, 13 Nov 2022 10:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668334865;
 bh=bAJllN46EPAoI4gsSpHJ8M3EPpj3jJg9OxPG1MEqQGU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=f/2fqifuG1M7A6Z1OoNTm5evuC9kytJ96vnnCcLxjISUV6M2tb8Q3ZHZq/krY1zFF
 XtLIOQvUqtszAZNN7M9LKtvS8CUK6rA0xfahPNnR28FVoEF8ueWSvaRGtTjQDpueoV
 HZGZ39sWZWiJJ+WOlbg+W9xZGHhfVrMcCo77eAfHn9BB6Bm9+Ki18QppuaHEOnRHmb
 0+RrUPSoyh/cZE+q3P6fo8HvOBUEVt5rjQnQhHU/uln1tGhYsBydlswsLY84WXPHtK
 +FJmq+apzfdcgphjmNNKZoDYXAh52892zNWfandT7T5pOVGe6J6jKwMlplFWd0Jobw
 dh4QEhWOb1Y9g==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ouA6o-005mZw-T8;
 Sun, 13 Nov 2022 10:21:02 +0000
MIME-Version: 1.0
Date: Sun, 13 Nov 2022 10:21:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v3 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
In-Reply-To: <CAAeT=FyR_4d1HzDjNEdVhsdgzRuBGuEwGuoMYY0xvi+YAbMqSg@mail.gmail.com>
References: <20221107085435.2581641-1-maz@kernel.org>
 <20221107085435.2581641-12-maz@kernel.org>
 <CAAeT=FyR_4d1HzDjNEdVhsdgzRuBGuEwGuoMYY0xvi+YAbMqSg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <136ee516118c97b8f3e4792b8ec9752a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 oliver.upton@linux.dev, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On 2022-11-08 05:38, Reiji Watanabe wrote:
> Hi Marc,
> 
> On Mon, Nov 7, 2022 at 1:16 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
>> the PMUver field can be altered and be at most the one that was
>> initially computed for the guest.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 40 
>> ++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 39 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 7a4cd644b9c0..47c882401f3c 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1247,6 +1247,43 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu 
>> *vcpu,
>>         return 0;
>>  }
>> 
>> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>> +                              const struct sys_reg_desc *rd,
>> +                              u64 val)
>> +{
>> +       u8 pmuver, host_pmuver;
>> +       bool valid_pmu;
>> +
>> +       host_pmuver = kvm_arm_pmu_get_pmuver_limit();
>> +
>> +       /*
>> +        * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
>> +        * as it doesn't promise more than what the HW gives us. We
>> +        * allow an IMPDEF PMU though, only if no PMU is supported
>> +        * (KVM backward compatibility handling).
>> +        */
>> +       pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), 
>> val);
>> +       if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > 
>> host_pmuver) ||
>> +           (pmuver != 0 && pmuver < ID_AA64DFR0_EL1_PMUVer_IMP))
> 
> Nit: Since this second condition cannot be true (right?), perhaps it 
> might
> be rather confusing?  I wasn't able to understand what it meant until
> I see the equivalent check in set_id_dfr0_el1() (Maybe just me 
> though:).

Ah, that's just me being tainted with the AArch32 version which
doesn't start at 1 for PMUv3. I'll drop it.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
