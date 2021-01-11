Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6F8C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 21:05:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D96C122D03
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 21:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D96C122D03
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FC754B413;
	Mon, 11 Jan 2021 16:05:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@mg.codeaurora.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nh9p2Gk3DsMn; Mon, 11 Jan 2021 16:05:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FE394B3F4;
	Mon, 11 Jan 2021 16:05:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B7A04B2F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 15:38:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EzpmHj4QIBLC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 15:38:51 -0500 (EST)
Received: from m43-15.mailgun.net (m43-15.mailgun.net [69.72.43.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 520264B2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 15:38:49 -0500 (EST)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org;
 q=dns/txt; 
 s=smtp; t=1610397531; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Ees3o6e/XkCpCJVrzGN7Ici92EyC8KlYvYm+4z3SO9w=;
 b=enlwoyZZ5UYLpWWCGhmbpqRHrI+/BryAYDFTZLhRh2IOjXTL2gB5k7otj9scxjif4p1H+smy
 +q8LaBOoSCnkh4wUvSroY0nU2mJW0hXv6DeBfoLO7kw42+6QaAV6ts+MrBKPvqsDKHNcEd+R
 YSK7RhRdzZdYX/XDARD4j8Kl7Gs=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiM2ZhNCIsICJrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1IiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5ffcb7568fb3cda82f483026 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Jan 2021 20:38:46
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
 id 983F4C43464; Mon, 11 Jan 2021 20:38:45 +0000 (UTC)
Received: from [192.168.1.11] (cpe-70-95-74-122.san.res.rr.com [70.95.74.122])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
 bits)) (No client certificate requested)
 (Authenticated sender: sramana)
 by smtp.codeaurora.org (Postfix) with ESMTPSA id EE9AAC433CA;
 Mon, 11 Jan 2021 20:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EE9AAC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org;
 dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org;
 spf=fail smtp.mailfrom=sramana@codeaurora.org
Subject: Re: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-10-maz@kernel.org> <20210111184154.GC17941@gaia>
From: Srinivas Ramana <sramana@codeaurora.org>
Message-ID: <de9d8631-4ff9-9d0c-e4eb-5ce0eeb0ecea@codeaurora.org>
Date: Mon, 11 Jan 2021 12:38:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111184154.GC17941@gaia>
Content-Language: en-US
X-Mailman-Approved-At: Mon, 11 Jan 2021 16:05:15 -0500
Cc: Prasad Sodagudi <psodagud@codeaurora.org>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Catalin,

On 1/11/2021 10:41 AM, Catalin Marinas wrote:
> Hi Marc,
>
> On Mon, Jan 11, 2021 at 01:27:59PM +0000, Marc Zyngier wrote:
>> Add a facility to globally override a feature, no matter what
>> the HW says. Yes, this is dangerous.
> Yeah, it's dangerous. We can make it less so if we only allow safe
> values (e.g. lower if FTR_UNSIGNED).
>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index 9a555809b89c..465d2cb63bfc 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -75,6 +75,8 @@ struct arm64_ftr_reg {
>>   	u64				sys_val;
>>   	u64				user_val;
>>   	const struct arm64_ftr_bits	*ftr_bits;
>> +	u64				*override_val;
>> +	u64				*override_mask;
>>   };
> At the arm64_ftr_reg level, we don't have any information about the safe
> values for a feature. Could we instead move this to arm64_ftr_bits? We
> probably only need a single field. When populating the feature values,
> we can make sure it doesn't go above the hardware one.
>
> I attempted a feature modification for MTE here, though I dropped the
> entire series in the meantime as we clarified the ARM ARM:
>
> https://lore.kernel.org/linux-arm-kernel/20200515171612.1020-24-catalin.marinas@arm.com/
>
> Srinivas copied it in his patch (but forgot to give credit ;)):

Sorry about that. I did mention that its taken from your patch-set in my 
cover letter. But missed your signed-off-by in the patch.

https://lore.kernel.org/linux-arm-msm/6dfdf691b5ed57df81c4c61422949af5@misterjones.org/T/#m1ae76e6096c07ab5f1636a4e383a3fd6cfb4665f

Since we can ignore my patch with the mechanism added by Marc, I am not 
re-sending this. Thanks.

>
> https://lore.kernel.org/linux-arm-msm/1610152163-16554-3-git-send-email-sramana@codeaurora.org/
>
> The above adds a filter function but, instead, just use your mechanism in
> this series for idreg.feature setting via cmdline. The arm64_ftr_value()
> function extracts the hardware value and lowers it if a cmdline argument
> was passed.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
