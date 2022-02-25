Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2F0C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 13:25:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D73A54B9ED;
	Fri, 25 Feb 2022 08:25:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IDK4WX8f5B53; Fri, 25 Feb 2022 08:25:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7A74BA21;
	Fri, 25 Feb 2022 08:25:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 423044B9ED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:25:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XMGt1fBNow4j for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 08:25:32 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D85124B8E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:25:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1864C61D53;
 Fri, 25 Feb 2022 13:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCBEC340E7;
 Fri, 25 Feb 2022 13:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645795531;
 bh=AenqWGwFPUwIWvO5JW0dieBXgTH2qTczoKrSpCVievs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=M2o18R+/4/kOiJJg2+CAvmAgoxEjLqp85lBMKzXdHrBlZi+wdEwQ6RpG45xm3BpMV
 PnYKBxnU5kElb6DhiAoetEDsoAELhsR3/mpua9wpq1FruMm8fJmqnbxtbdgCgyGflU
 /hcVEm3MiODPaHnXiKD8SkkIz7WkFU5aw0inQvEic34FowHogyeBuRY+FRxuBLG7MT
 ZrF2JXP2mIrt2i9zRRYPrkoMyZQ5x875Bgjfr6JOPJy3MNZeGP/88KPgQuPK0QWrWB
 5RN/PMnt73i1jAu2GMVrp4Ug50ZSVtE2Pn4OX8k6OWP88zuxMhQFPV65UCOSh5Mvj8
 Qk5tYvI0nDqtg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nNabB-00AX24-2C; Fri, 25 Feb 2022 13:25:29 +0000
MIME-Version: 1.0
Date: Fri, 25 Feb 2022 13:25:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: fix semicolon.cocci warnings
In-Reply-To: <20220225122922.GA19390@willie-the-truck>
References: <202202250442.6Y6h26na-lkp@intel.com>
 <20220224200724.GA16837@6c0ef8ecd909>
 <20220225122922.GA19390@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <5ba4356d4d526d72118664dd93d5f6f2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, lkp@intel.com, kbuild-all@lists.01.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
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

On 2022-02-25 12:29, Will Deacon wrote:
> On Fri, Feb 25, 2022 at 04:07:24AM +0800, kernel test robot wrote:
>> From: kernel test robot <lkp@intel.com>
>> 
>> arch/arm64/kvm/psci.c:372:3-4: Unneeded semicolon
>> 
>> 
>>  Remove unneeded semicolon.
>> 
>> Generated by: scripts/coccinelle/misc/semicolon.cocci
>> 
>> Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to 
>> the guest")
>> CC: Will Deacon <will@kernel.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: kernel test robot <lkp@intel.com>
>> ---
>> 
>> tree:   
>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git 
>> master
>> head:   d4a0ae62a277377de396850ed4b709b6bd9b7326
>> commit: d43583b890e7cb0078d13d056753a56602b92406 [7067/7915] KVM: 
>> arm64: Expose PSCI SYSTEM_RESET2 call to the guest
>> :::::: branch date: 18 hours ago
>> :::::: commit date: 3 days ago
>> 
>>  arch/arm64/kvm/psci.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> --- a/arch/arm64/kvm/psci.c
>> +++ b/arch/arm64/kvm/psci.c
>> @@ -369,7 +369,7 @@ static int kvm_psci_1_x_call(struct kvm_
>>  				ret = 0;
>>  			}
>>  			break;
>> -		};
>> +		}
> 
> Acked-by: Will Deacon <will@kernel.org>
> 
> but I really don't think this needs a Fixes: tag

The Fixes: really isn't warranted, there is a previous patch fixing
the same thing already[1], and there is *another* '};' typo in the
same file that the robot failed to pick on...

If you don't mind, I'll add your Ack to the original fix, and squash
the fix for the fix into it.

[1] 
https://lore.kernel.org/r/20220223092750.1934130-1-deng.changcheng@zte.com.cn
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
