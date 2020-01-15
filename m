Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D69C33CB1
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 13:51:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27846214AF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 13:51:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAyFnhrY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27846214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D24C64B165;
	Wed, 15 Jan 2020 08:51:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 54dcQ4hDlgPu; Wed, 15 Jan 2020 08:51:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9713A4B159;
	Wed, 15 Jan 2020 08:51:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B5DC4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 08:51:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SfiDmrQtB8rp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 08:51:01 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5603F4B133
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 08:51:01 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4CC8F222C3;
 Wed, 15 Jan 2020 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579096260;
 bh=zgFuK23PelupfMFWwsdmgHynqFy4M+em1nBsFleJZmg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=LAyFnhrYoxuHERN9eMwwCXKbcwce1ikeoXzQMYJ74XKiwgWrr6oFP5V8F0t9Iz2LZ
 VekcCt7rJD5+YiS3BH8kQejmTn5hHK22RyMp4//taH94ffYDsAnEhnnaEPVVrmzOc+
 FlCFXOQ9i6ZZd+WPBBXL6pPuOGqDNxX12lmgIV3k=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1irj4U-0000G6-KS; Wed, 15 Jan 2020 13:50:58 +0000
MIME-Version: 1.0
Date: Wed, 15 Jan 2020 13:50:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: Re: [Question about KVM on arm64] Consider putting VINVALL to
 deactivation
In-Reply-To: <bf470803-8e1c-d1c3-d5ac-731536196543@hisilicon.com>
References: <bf470803-8e1c-d1c3-d5ac-731536196543@hisilicon.com>
Message-ID: <37126a877e1160ed50ee6d95a03d1574@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhangshaokun@hisilicon.com, tangnianyao@huawei.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 fanhenglong@huawei.com, wanghaibin.wang@huawei.com, lizixian@hisilicon.com,
 wangwudi@hisilicon.com, jiayanlei@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: wangwudi <wangwudi@hisilicon.com>, Lizixian <lizixian@hisilicon.com>,
 jiayanlei@huawei.com, fanhenglong@huawei.com, kvmarm@lists.cs.columbia.edu,
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

Hi Shaokun,

On 2020-01-14 14:20, Shaokun Zhang wrote:
> Hi Marc,
> 
> On activation, VMAPP command is followed by a VINVALL, which could be
> quite expensive for the start-up of virtual machine. If a vpeid is 
> allowed
> successfully, it is not used in system.

How expensive? This is exactly similar to what happens on a physical 
machine
where we perform an INVALL on MAPC. And yet you don't complain about 
that.

Please provide numbers.

> We may consider put VINVALL to deactivation to ensure all cache of 
> certain
> vpeid is invalid, to simplify activation. We consider start-up may be 
> more
> common and more time-consuming-sensitive than shutdown process.

In my world, they cost the same thing, and happen just as often. Also, I 
want
guarantees that on VMAPP, there is no stale information even if this is 
the
first time we're using this VPEid (who knows what happens over kexec, 
for
example).

> Do you think it's all right?

I don't, for the reasons stated above. You also provide no numbers 
showing
how bad the overhead is, so I'm left guessing.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
