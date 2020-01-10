Return-Path: <SRS0=Qg2m=27=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D933C33CA4
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 10:35:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF0192077C
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 10:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xr/aOlKn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF0192077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 828444B1CE;
	Fri, 10 Jan 2020 05:35:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sbr7T75xNDbN; Fri, 10 Jan 2020 05:35:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598974B1B2;
	Fri, 10 Jan 2020 05:35:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 887B64B19A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 05:35:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JrE3GZb-GimL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jan 2020 05:35:05 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57D524B17B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 05:35:05 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 388AD20721;
 Fri, 10 Jan 2020 10:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1578652504;
 bh=O6NFD8wrjXHYKqN+wmpbS8vPepwh3hMeCNx2Yl2KWXE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=xr/aOlKnna+8ImgwYVYrX/FO51itRz4WR2ANaPtBOe7Ev2SwQbYcJxsSK3Hu4vyNj
 ZEJTTwb/4LBdTHTkmxMi/DH30avrAgkjBuFWaYkiuUl4AnKAcRt0Xqlv3UBKxr+8+T
 UvesEDS8NdT707Y/g6A9bWM7gZwjffQyYxVKKfBU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1iprd8-0007Js-6n; Fri, 10 Jan 2020 10:35:02 +0000
MIME-Version: 1.0
Date: Fri, 10 Jan 2020 10:35:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <Jianyong.Wu@arm.com>
Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
In-Reply-To: <HE1PR0801MB16765B52E5DCD8EA480EDABFF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-8-jianyong.wu@arm.com>
 <ca162efb3a0de530e119f5237c006515@kernel.org>
 <HE1PR0801MB1676EE12CF0DB7C5BB8CC62DF4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ee801dacbf4143e8d41807d5bfad1409@kernel.org>
 <HE1PR0801MB16765B52E5DCD8EA480EDABFF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Message-ID: <a85deebc23c1fa77e6f70b6eaef22a34@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com,
 Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com,
 Steven.Price@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, Justin.He@arm.com,
 nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Justin He <Justin.He@arm.com>, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, Steven Price <Steven.Price@arm.com>,
 john.stultz@linaro.org, yangbo.lu@nxp.com, pbonzini@redhat.com,
 tglx@linutronix.de, nd <nd@arm.com>, will@kernel.org,
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

Hi Jianyong,

On 2020-01-10 10:15, Jianyong Wu wrote:
> Hi Marc,

[...]

>> >> > +	ktime_overall = hvc_res.a0 << 32 | hvc_res.a1;
>> >> > +	*ts = ktime_to_timespec64(ktime_overall);
>> >> > +	*cycle = hvc_res.a2 << 32 | hvc_res.a3;
>> >>
>> >> So why isn't that just a read of the virtual counter, given that what
>> >> you do in the hypervisor seems to be "cntpct - cntvoff"?
>> >>
>> >> What am I missing here?
>> >>
>> > We need get clock time and counter cycle at the same time, so we can't
>> > just read virtual counter at guest and must get it from host.
>> 
>> See my comment in my reply to patch #6: *Must* seems like a very 
>> strong
>> word, and you don't explain *why* that's better than just computing 
>> the
>> total hypercall cost. Hint: given the frequency of the counter (in the 
>> few MHz
>> range) vs the frequency of a CPU (in the multiple GHz range, and with 
>> an IPC
>> close enough to 1), I doubt that you'll see the counter making much 
>> progress
>> across a hypercall.
>> 
> Sorry, I will avoid to use those strong words.
> 
> It's really the case that the hypercall won't across cycle in general.
> But sometimes, kernel preempt
> may happen in the middle of the hypercall which we can't assume how
> long before schedule back. so it's better capture them
> together at the same time.

Fair enough. Please document the rational, as I guess others will ask
the same questions.

Then the problem to solve is that of the reference counter, as you so 
far
assume the virtual counter. I guess you need to be able to let the guest
select the reference counter when calling the PTP service.

[...]

> By the way, does nested virtualization diff between arm64 and arm32?

There is no nested virt for 32bit (it is explicitly forbidden by the
architecture).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
