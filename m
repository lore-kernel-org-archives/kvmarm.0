Return-Path: <SRS0=iQbv=4Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD73CC3F2D2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 19:16:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69312246AC
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 19:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="azovb8xM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69312246AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB1C74AFF6;
	Fri, 28 Feb 2020 14:16:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IN0s-MGWEiTz; Fri, 28 Feb 2020 14:16:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC3444AFF7;
	Fri, 28 Feb 2020 14:16:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9238C4AFF2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 14:16:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sh2j-T85cxs1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Feb 2020 14:16:45 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B29F4AFE9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 14:16:45 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5C70A222C2;
 Fri, 28 Feb 2020 19:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582917404;
 bh=BXqh6cgD9aYcDmgFUDG8alw4aMlNGdIq216e0sMu2gM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=azovb8xMoPOm9v0m36JKUAew5EbZKIOZskp+O30F2ob5dQBTXCBqaC5WreLropVNE
 GoAajw3AT0SgCfMFadO6XqzXVgsMYURzBXNc+O3uc1HgMkdK1zBUWAkFZh4lONfI8g
 /wHZmAzy0v2oOUnxfCBGczDdZQULv5EcILGuyIZk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j7l7q-008pqH-Kw; Fri, 28 Feb 2020 19:16:42 +0000
MIME-Version: 1.0
Date: Fri, 28 Feb 2020 19:16:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 16/20] KVM: arm64: GICv4.1: Allow SGIs to switch
 between HW and SW interrupts
In-Reply-To: <6798eb13-a7e9-2a92-91b2-9b657962ea79@huawei.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-17-maz@kernel.org>
 <6798eb13-a7e9-2a92-91b2-9b657962ea79@huawei.com>
Message-ID: <7aa668a5920b8deb8c2ee2fec3ef69b3@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
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

Hi Zenghui,

On 2020-02-20 03:55, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/2/14 22:57, Marc Zyngier wrote:
>> In order to let a guest buy in the new, active-less SGIs, we
>> need to be able to switch between the two modes.
>> 
>> Handle this by stopping all guest activity, transfer the state
>> from one mode to the other, and resume the guest.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> [...]
> 
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index 1bc09b523486..2c9fc13e2c59 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -540,6 +540,8 @@ int vgic_v3_map_resources(struct kvm *kvm)
>>   		goto out;
>>   	}
>>   +	if (kvm_vgic_global_state.has_gicv4_1)
>> +		vgic_v4_configure_vsgis(kvm);
>>   	dist->ready = true;
>>     out:
> 
> Is there any reason to invoke vgic_v4_configure_vsgis() here?
> This is called on the first VCPU run, through kvm_vgic_map_resources().
> Shouldn't the vSGI configuration only driven by a GICD_CTLR.nASSGIreq
> writing (from guest, or from userspace maybe)?

What I'm trying to catch here is the guest that has been restored with
nASSGIreq set. At the moment, we don't do anything on the userspace
side, because the vmm could decide to write that particular bit
multiple times, and switching between the two modes is expensive (not
to mention that all the vcpus may not have been created yet).

Moving it to the first run makes all these pitfalls go away (we have the
final nASSSGIreq value, and all the vcpus are accounted for).

Does this make sense to you?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
