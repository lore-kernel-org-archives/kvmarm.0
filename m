Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C5DC4332E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 11:20:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A987D2076E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 11:20:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="clI/ORQw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A987D2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 506534A51E;
	Fri, 20 Mar 2020 07:20:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QxFhQjrEX2Bm; Fri, 20 Mar 2020 07:20:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B92644AF1F;
	Fri, 20 Mar 2020 07:20:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69A314A4FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 07:20:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1H3d+bjGHq-I for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 07:20:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 533C34A4AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 07:20:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 295E220754;
 Fri, 20 Mar 2020 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584703207;
 bh=Fht9Bm+/mYo7KEXWQ1/nQ2VCA8zoKCq/hHDNDTuxjm0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=clI/ORQwfpfhrnfMm5AIOneqPE/E+/tdWg4GgU6mywyMitPwxnn9AHUKVNzrFU/bi
 cKkABgDTJVz4pUJ1Qs/n57po0+9Ar5rg3pdhhhmpeCRhfTBMcc2geRr/qvHxaFngo4
 FjY8oUuRIVVYwYBxhtPJ7+8EZ5F+wBMhtZLSpmIg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jFFh7-00EDxA-CV; Fri, 20 Mar 2020 11:20:05 +0000
MIME-Version: 1.0
Date: Fri, 20 Mar 2020 11:20:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <02350520-8591-c62c-e7fa-33db30c25b96@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
 <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
 <e60578b5-910c-0355-d231-29322900679d@redhat.com>
 <dfaf8a1b7c7fd8b769a244a8a779d952@kernel.org>
 <02350520-8591-c62c-e7fa-33db30c25b96@redhat.com>
Message-ID: <242f066aaa5f76861e7fe202944073b9@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, lorenzo.pieralisi@arm.com,
 jason@lakedaemon.net, kvm@vger.kernel.org, suzuki.poulose@arm.com,
 linux-kernel@vger.kernel.org, rrichter@marvell.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, yuzenghui@huawei.com, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
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

Hi Eric,

On 2020-03-20 11:09, Auger Eric wrote:
> Hi Marc,

[...]

>>>> It means that userspace will be aware of some form of GICv4.1 
>>>> details
>>>> (e.g., get/set vSGI state at HW level) that KVM has implemented.
>>>> Is it something that userspace required to know? I'm open to this 
>>>> ;-)
>>> Not sure we would be obliged to expose fine details. This could be a
>>> generic save/restore device group/attr whose implementation at KVM 
>>> level
>>> could differ depending on the version being implemented, no?
>> 
>> What prevents us from hooking this synchronization to the current 
>> behaviour
>> of KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES? After all, this is already 
>> the
>> point
>> where we synchronize the KVM view of the pending state with userspace.
>> Here, it's just a matter of picking the information from some other 
>> place
>> (i.e. the host's virtual pending table).
> agreed
>> 
>> The thing we need though is the guarantee that the guest isn't going 
>> to
>> get more vLPIs at that stage, as they would be lost. This effectively
>> assumes that we can also save/restore the state of the signalling 
>> devices,
>> and I don't know if we're quite there yet.
> On QEMU, when KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES is called, the VM is
> stopped.
> See cddafd8f353d ("hw/intc/arm_gicv3_its: Implement state 
> save/restore")
> So I think it should work, no?

The guest being stopped is a good start. But my concern is on the device 
side.

If the device is still active (generating interrupts), these interrupts 
will
be dropped because the vPE will have been unmapped from the ITS in order 
to
clean the ITS caches and make sure the virtual pending table is up to 
date.

In turn, restoring the guest may lead to a lockup because we would have 
lost
these interrupts. What does QEMU on x86 do in this case?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
