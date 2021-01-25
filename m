Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2886FC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 13:56:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6371C22C9E
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 13:56:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6371C22C9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4B234B5F8;
	Mon, 25 Jan 2021 08:56:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SVx-LdeBwfyv; Mon, 25 Jan 2021 08:56:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C72654B4F2;
	Mon, 25 Jan 2021 08:56:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40C1A4B4D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 08:56:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YJ2UeqWwsQOT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 08:56:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E8544B3A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 08:56:02 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0DE1522C9C;
 Mon, 25 Jan 2021 13:56:01 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l42LW-009t5S-S6; Mon, 25 Jan 2021 13:55:59 +0000
MIME-Version: 1.0
Date: Mon, 25 Jan 2021 13:55:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 13/21] arm64: Allow ID_AA64MMFR1_EL1.VH to be
 overridden from the command line
In-Reply-To: <b43570e9-585d-3229-df2f-9af9777b55ec@arm.com>
References: <20210125105019.2946057-1-maz@kernel.org>
 <20210125105019.2946057-14-maz@kernel.org>
 <b43570e9-585d-3229-df2f-9af9777b55ec@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <9923965b870d71eee0fa828059185f33@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
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

On 2021-01-25 13:15, Suzuki K Poulose wrote:
> On 1/25/21 10:50 AM, Marc Zyngier wrote:
>> As we want to be able to disable VHE at runtime, let's match
>> "id_aa64mmfr1.vh=" from the command line as an override.
>> This doesn't have much effect yet as our boot code doesn't look
>> at the cpufeature, but only at the HW registers.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Acked-by: David Brazdil <dbrazdil@google.com>
>> ---
>>   arch/arm64/include/asm/cpufeature.h |  2 ++
>>   arch/arm64/kernel/cpufeature.c      |  5 ++++-
>>   arch/arm64/kernel/idreg-override.c  | 11 +++++++++++
>>   3 files changed, 17 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/include/asm/cpufeature.h 
>> b/arch/arm64/include/asm/cpufeature.h
>> index 4179cfc8ed57..b0ed37da4067 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -818,6 +818,8 @@ static inline unsigned int get_vmid_bits(u64 
>> mmfr1)
>>   	return 8;
>>   }
>>   +extern struct arm64_ftr_override id_aa64mmfr1_override;
>> +
>>   u32 get_kvm_ipa_limit(void);
>>   void dump_cpu_features(void);
>>   diff --git a/arch/arm64/kernel/cpufeature.c 
>> b/arch/arm64/kernel/cpufeature.c
>> index 4b84a1e1dc51..c1d6712c4249 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -557,6 +557,8 @@ static const struct arm64_ftr_bits ftr_raz[] = {
>>     #define ARM64_FTR_REG(id, table) ARM64_FTR_REG_OVERRIDE(id, table, 
>> &no_override)
>>   +struct arm64_ftr_override id_aa64mmfr1_override;
> 
> Does this need to be ro_after_init ?

Could do, together with the other two override targeting system 
registers.

> Otherwise, looks good to me:
> 
> Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
