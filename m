Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1B8C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 08:49:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A964B222E8
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 08:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bm6hrdaB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A964B222E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E46034B7E5;
	Tue, 17 Nov 2020 03:49:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id StyMrvXgAo4s; Tue, 17 Nov 2020 03:49:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6664B855;
	Tue, 17 Nov 2020 03:49:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 637F14B800
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 03:49:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O9+p5iaVBLjY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 03:49:11 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B4174B7E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 03:49:11 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 12F842225E;
 Tue, 17 Nov 2020 08:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605602950;
 bh=htTADclsiKM9iBHnxQjBA65269s1iebyH+Dc/3nPf/c=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Bm6hrdaBW1+9GYWeb8yj32XrGY8JRUNXvZRnbRi02xVt+vea9fAYWvxRa4cSBzoFt
 stNdlBNaJij5KDipXG0YUqdLNxNs68rxAz/0KST/CXOYdD69UTXwbUKhTlvc48doyL
 ny0ZsGdJBhbrKtMtoqNVPXjpNIUihWlxXwjnnOi8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kewfj-00BH7x-Vo; Tue, 17 Nov 2020 08:49:08 +0000
MIME-Version: 1.0
Date: Tue, 17 Nov 2020 08:49:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Forbid invalid userspace
 Redistributor accesses
In-Reply-To: <7e58200c-814e-3598-155a-9a7e6cc24374@huawei.com>
References: <20201113142801.1659-1-yuzenghui@huawei.com>
 <20201113142801.1659-2-yuzenghui@huawei.com>
 <724c43702b52aac0d3c9beb9604d1bfb@kernel.org>
 <584b7ff1-ecf2-b0ec-cea3-ccc29902f43a@huawei.com>
 <cc45285fe491aff5c28a24f94c124508@kernel.org>
 <7e58200c-814e-3598-155a-9a7e6cc24374@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <c20865a267e44d1e2c0d52ce4e012263@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, zhukeqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

Hi Zenghui,

On 2020-11-16 14:57, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/11/16 22:10, Marc Zyngier wrote:
>>> My take is that only if the "[Re]Distributor base address" is 
>>> specified
>>> in the system memory map, will the user-provided 
>>> kvm_device_attr.offset
>>> make sense. And we can then handle the access to the register which 
>>> is
>>> defined by "base address + offset".
>> 
>> I'd tend to agree, but it is just that this is a large change at -rc4.
>> I'd rather have a quick fix for 5.10, and a more invasive change for 
>> 5.11,
>> spanning all the possible vgic devices.
> 
> So you prefer fixing it by "return a value that doesn't have the Last
> bit set" for v5.10? I'm ok with it and can send v2 for it.

Cool. Thanks for that.

> Btw, looking again at the way we handle the user-reading of GICR_TYPER
> 
> 	vgic_mmio_read_v3r_typer(vcpu, addr, len)
> 
> it seems that @addr is actually the *offset* of GICR_TYPER (0x0008) and
> @addr is unlikely to be equal to last_rdist_typer, which is the *GPA* 
> of
> the last RD. Looks like the user-reading of GICR_TYPER.Last is always
> broken?

I think you are right. Somehow, we don't seem to track the index of
the RD in the region, so we can never compute the address of the RD
even if the base address is set.

Let's drop the reporting of Last for userspace for now, as it never
worked. If you post a patch addressing that quickly, I'll get it to
Paolo by the end of the week (there's another fix that needs merging).

Eric: do we have any test covering the userspace API?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
