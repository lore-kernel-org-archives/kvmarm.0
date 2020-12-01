Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113DFC64E7A
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 11:50:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3ABEA2085B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 11:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4VW9Sgn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ABEA2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D464C1DA;
	Tue,  1 Dec 2020 06:50:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LcU9ngtpM6qt; Tue,  1 Dec 2020 06:50:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54D1F4C1DC;
	Tue,  1 Dec 2020 06:50:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9574C1DC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 06:50:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RYUxVgznY-c6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 06:50:04 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FBAA4C1DA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 06:50:04 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9726820770;
 Tue,  1 Dec 2020 11:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606823402;
 bh=UE/XVXCsi7+x/uyIjMjMl6em1uv7ikjqa7mp1FXveyA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=S4VW9Sgn7iW1ndWIZxYcNhZNcYzrdu4YLpAlGR+L9NWq1kn48g6Y4AjQsLMUboqDi
 px82TrnsP+fOea64waKx9MDPGYbxyC/mmTjMV2SDQGdhlKvlPPX3OrDSqCpOMwmDfU
 pi97M7j6fHneG9TEh+N29owEJN700T5yy5JzU9kQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kk4AS-00F1ps-IO; Tue, 01 Dec 2020 11:50:00 +0000
MIME-Version: 1.0
Date: Tue, 01 Dec 2020 11:50:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
In-Reply-To: <9b80d460-e149-20c8-e9b3-e695310b4ed1@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
 <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
 <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
 <2ad38077300bdcaedd2e3b073cd36743@kernel.org>
 <9b80d460-e149-20c8-e9b3-e695310b4ed1@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <274dafb2e21f49326a64bb575e668793@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com,
 alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com,
 cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Neo Jia <cjia@nvidia.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On 2020-12-01 11:40, Shenming Lu wrote:
> On 2020/12/1 18:55, Marc Zyngier wrote:
>> On 2020-11-30 07:23, Shenming Lu wrote:
>> 
>> Hi Shenming,
>> 
>>> We are pondering over this problem these days, but still don't get a
>>> good solution...
>>> Could you give us some advice on this?
>>> 
>>> Or could we move the restoring of the pending states (include the 
>>> sync
>>> from guest RAM and the transfer to HW) to the GIC VM state change 
>>> handler,
>>> which is completely corresponding to save_pending_tables (more 
>>> symmetric?)
>>> and don't expose GICv4...
>> 
>> What is "the GIC VM state change handler"? Is that a QEMU thing?
> 
> Yeah, it is a a QEMU thing...
> 
>> We don't really have that concept in KVM, so I'd appreciate if you 
>> could
>> be a bit more explicit on this.
> 
> My thought is to add a new interface (to QEMU) for the restoring of
> the pending states, which is completely corresponding to
> KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES...
> And it is called from the GIC VM state change handler in QEMU, which
> is happening after the restoring (call kvm_vgic_v4_set_forwarding())
> but before the starting (running) of the VFIO device.

Right, that makes sense. I still wonder how much the GIC save/restore
stuff differs from other architectures that implement similar features,
such as x86 with VT-D.

It is obviously too late to change the userspace interface, but I wonder
whether we missed something at the time.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
