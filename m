Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA5DC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 09:17:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDF3F20823
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 09:17:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXnRIYph"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDF3F20823
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66B8B4B17B;
	Mon, 25 May 2020 05:17:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kGfX0jJ2eC0n; Mon, 25 May 2020 05:17:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5391A4B181;
	Mon, 25 May 2020 05:17:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E97F4B17F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 05:17:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A1lqCUwClqlb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 05:17:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DACF4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 05:17:22 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 01ED020787;
 Mon, 25 May 2020 09:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590398241;
 bh=dvoIblhrB6r6q1w4YgHnKBzB3u8MDjy2EHOsa4SWZok=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=tXnRIYphXASv22/CWUBMA4CPRNsDbUMhgCnKjxTTC6dq9DDNazs1+GztuGsokQpEJ
 72QM5aF0JoA15SMnoO0AX6SPOL6GCj0SXNeERYxlYPaPRT7hQ4f+IaxJUF+lIYihOX
 pyq7Ce4X2AFg/w1e44/Sm5YB7VXDDhAc7W7i/lfo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jd9EU-00F730-Ux; Mon, 25 May 2020 10:17:19 +0100
MIME-Version: 1.0
Date: Mon, 25 May 2020 10:17:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>, Jianyong Wu
 <jianyong.wu@arm.com>
Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
In-Reply-To: <20200524021106.GC335@localhost>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
 <20200524021106.GC335@localhost>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <306951e4945b9e486dc98818ba24466d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: richardcochran@gmail.com, jianyong.wu@arm.com,
 netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
 steven.price@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
 Wei.Chen@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: justin.he@arm.com, Wei.Chen@arm.com, kvm@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, steven.price@arm.com, john.stultz@linaro.org,
 yangbo.lu@nxp.com, pbonzini@redhat.com, tglx@linutronix.de, nd@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On 2020-05-24 03:11, Richard Cochran wrote:
> On Fri, May 22, 2020 at 04:37:23PM +0800, Jianyong Wu wrote:
>> In general, vm inside will use virtual counter compered with host use
>> phyical counter. But in some special scenarios, like nested
>> virtualization, phyical counter maybe used by vm. A interface added in
>> ptp_kvm driver to offer a mechanism to let user choose which counter
>> should be return from host.
> 
> Sounds like you have two time sources, one for normal guest, and one
> for nested.  Why not simply offer the correct one to user space
> automatically?  If that cannot be done, then just offer two PHC
> devices with descriptive names.

There is no such thing as a distinction between nested or non-nested.
Both counters are available to the guest at all times, and said guest
can choose whichever it wants to use. So the hypervisor (KVM) has to
support both counters as a reference.

For a Linux guest, we always know which reference we're using (the
virtual counter). So it is pointless to expose the choice to userspace
at all.

> 
>> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
>> index fef72f29f3c8..8b0a7b328bcd 100644
>> --- a/drivers/ptp/ptp_chardev.c
>> +++ b/drivers/ptp/ptp_chardev.c
>> @@ -123,6 +123,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned 
>> int cmd, unsigned long arg)
>>  	struct timespec64 ts;
>>  	int enable, err = 0;
>> 
>> +#ifdef CONFIG_ARM64
>> +	static long flag;
> 
> static?  This is not going to fly.
> 
>> +		 * In most cases, we just need virtual counter from host and
>> +		 * there is limited scenario using this to get physical counter
>> +		 * in guest.
>> +		 * Be careful to use this as there is no way to set it back
>> +		 * unless you reinstall the module.
> 
> How on earth is the user supposed to know this?
> 
> From your description, this "flag" really should be a module
> parameter.

Not even that. If anything, the driver can obtain full knowledge of 
which
counter is in use without any help. And the hard truth is that it is
*always* the virtual counter as far as Linux is concerned.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
