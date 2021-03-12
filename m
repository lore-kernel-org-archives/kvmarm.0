Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85913C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:44:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EEA3B64FEE
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:44:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEA3B64FEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 764CE4B364;
	Fri, 12 Mar 2021 10:44:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YdoUVOnmhJWI; Fri, 12 Mar 2021 10:44:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF574B419;
	Fri, 12 Mar 2021 10:44:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2E044B36A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:44:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hYdHtr1HTbOD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 10:44:42 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB2964B364
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:44:42 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BF86864FDC;
 Fri, 12 Mar 2021 15:44:40 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lKjxu-001Fuj-NY; Fri, 12 Mar 2021 15:44:38 +0000
MIME-Version: 1.0
Date: Fri, 12 Mar 2021 15:44:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 2/2] KVM: arm64: Fix exclusive limit for IPA size
In-Reply-To: <20210311111500.uqy4lolxtp7t4xd4@kamzik.brq.redhat.com>
References: <20210311100016.3830038-1-maz@kernel.org>
 <20210311100016.3830038-3-maz@kernel.org>
 <20210311111500.uqy4lolxtp7t4xd4@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <7ce8f57d2bcc19a77993fc01845ac6cb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org,
 eric.auger@redhat.com, alexandru.elisei@arm.com, kernel-team@android.com,
 stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, stable@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

On 2021-03-11 11:15, Andrew Jones wrote:
> On Thu, Mar 11, 2021 at 10:00:16AM +0000, Marc Zyngier wrote:
>> When registering a memslot, we check the size and location of that
>> memslot against the IPA size to ensure that we can provide guest
>> access to the whole of the memory.
>> 
>> Unfortunately, this check rejects memslot that end-up at the exact
>> limit of the addressing capability for a given IPA size. For example,
>> it refuses the creation of a 2GB memslot at 0x8000000 with a 32bit
>> IPA space.
>> 
>> Fix it by relaxing the check to accept a memslot reaching the
>> limit of the IPA space.
>> 
>> Fixes: e55cac5bf2a9 ("kvm: arm/arm64: Prepare for VM specific stage2 
>> translations")
> 
> Isn't this actually fixing commit c3058d5da222 ("arm/arm64: KVM: Ensure
> memslots are within KVM_PHYS_SIZE") ?

Ah, yes, that's indeed better (more backport work... ;-)

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
