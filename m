Return-Path: <SRS0=99up=ZY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D82FC432C0
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 17:15:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDBC920672
	for <kvmarm@archiver.kernel.org>; Mon,  2 Dec 2019 17:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDBC920672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4E94AED5;
	Mon,  2 Dec 2019 12:15:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id spWkwclyQiXI; Mon,  2 Dec 2019 12:15:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 485D04AED3;
	Mon,  2 Dec 2019 12:15:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8266A4AED3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 12:15:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Enkh-ttHNIYr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Dec 2019 12:15:50 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 742C54AED2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Dec 2019 12:15:50 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ibpIa-0004dV-NV; Mon, 02 Dec 2019 18:15:48 +0100
To: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v2 3/5] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 02 Dec 2019 17:15:48 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <9909b304-9e52-6960-4397-b7d33159cebf@linaro.org>
References: <20191201122018.25808-1-maz@kernel.org>
 <20191201122018.25808-4-maz@kernel.org>
 <0bc7c461-6b92-2782-4aec-2f649f5bc8cf@linaro.org>
 <d2875338d734fca3e5263b94eaf52c18@www.loen.fr>
 <9909b304-9e52-6960-4397-b7d33159cebf@linaro.org>
Message-ID: <d69cc2d0d3f56b2c84d5c73bc5abd9ff@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: richard.henderson@linaro.org, qemu-devel@nongnu.org,
 kvmarm@lists.cs.columbia.edu, peter.maydell@linaro.org,
 edgar.iglesias@xilinx.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>, qemu-devel@nongnu.org,
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

On 2019-12-02 16:56, Richard Henderson wrote:
> On 12/2/19 4:45 PM, Marc Zyngier wrote:
>>> Annoying that there's a bug in the manual -- FPSID is listed as 
>>> group 0 in
>>> plenty of places, except in the pseudo-code for Accessing the FPSID
>>> which uses TID3.
>>
>> Are you sure? I'm looking at DDI0487E_a,
> ...
>> Or have you spotted a discrepancy
>> somewhere else (which would be oh-so-surprising...)?
>
> In DDI0487E_a, page G8-6028:
>
>> elsif EL2Enabled() && !ELUsingAArch32(EL2) && HCR_EL2.TID3 == '1' 
>> then
>>   AArch64.AArch32SystemAccessTrap(EL2, 0x08);
>> elsif EL2Enabled() && ELUsingAArch32(EL2) && HCR.TID3 == '1' then
>>   AArch32.TakeHypTrapException(0x08);
>> else
>>   return FPSID;
>
> within the summary documentation for FPSID.

Ah, that was too obvious for me to find ;-). Indeed, this looks totally
bogus. I'll try and poke a few people...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
