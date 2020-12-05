Return-Path: <SRS0=IuVk=FJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353D1C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  5 Dec 2020 18:22:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0BC02332A
	for <kvmarm@archiver.kernel.org>; Sat,  5 Dec 2020 18:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0BC02332A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E27234B0DC;
	Sat,  5 Dec 2020 13:22:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2dKyQmokeNdD; Sat,  5 Dec 2020 13:22:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2B0B4B154;
	Sat,  5 Dec 2020 13:22:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F9594B14F
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Dec 2020 13:22:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zo8+Gh8ewpeY for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Dec 2020 13:22:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4666E4B0DC
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Dec 2020 13:22:08 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 052B323138;
 Sat,  5 Dec 2020 18:22:07 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1klcC4-00GNe7-SK; Sat, 05 Dec 2020 18:22:05 +0000
MIME-Version: 1.0
Date: Sat, 05 Dec 2020 18:22:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
In-Reply-To: <a82cf9ff-f18d-ce0a-f7a2-82a56cbbec40@linaro.org>
References: <20201204073126.6920-1-zhukeqian1@huawei.com>
 <20201204073126.6920-3-zhukeqian1@huawei.com>
 <a82cf9ff-f18d-ce0a-f7a2-82a56cbbec40@linaro.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <ef43679b6710fc4320203975bc2bde98@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: daniel.lezcano@linaro.org, zhukeqian1@huawei.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, tglx@linutronix.de,
 catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, sean.j.christopherson@intel.com,
 julien.thierry.kdev@gmail.com, broonie@kernel.org, akpm@linux-foundation.org,
 alexios.zavras@intel.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
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

Hi Daniel,

On 2020-12-05 11:15, Daniel Lezcano wrote:
> Hi Marc,
> 
> are you fine with this patch ?

I am, although there still isn't any justification for the pos/lsb
rework in the commit message (and calling that variable lsb is somewhat
confusing). If you are going to apply it, please consider adding
the additional comment below.

> 
> 
> On 04/12/2020 08:31, Keqian Zhu wrote:
>> ARM virtual counter supports event stream, it can only trigger an 
>> event
>> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 
>> changes,
>> so the actual period of event stream is 2^(cntkctl_evnti + 1). For 
>> example,
>> when the trigger bit is 0, then virtual counter trigger an event for 
>> every
>> two cycles.

"While we're at it, rework the way we compute the trigger bit position 
by
  making it more obvious that when bits [n:n-1] are both set (with n 
being
  the most significant bit), we pick bit (n + 1)."

With that:

Acked-by: Marc Zyngier <maz@kernel.org>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
