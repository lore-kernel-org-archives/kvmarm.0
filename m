Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D20DC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 17:48:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B697723120
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 17:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B697723120
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFAB74B1A7;
	Tue, 12 Jan 2021 12:48:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GMDwoqSBTdMl; Tue, 12 Jan 2021 12:48:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7337F4B1C8;
	Tue, 12 Jan 2021 12:48:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDAD64B13C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 12:48:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WFaa3INJStfE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 12:48:37 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE96A4B10B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 12:48:37 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 93C2D23107;
 Tue, 12 Jan 2021 17:48:36 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kzNmU-0072aN-89; Tue, 12 Jan 2021 17:48:34 +0000
MIME-Version: 1.0
Date: Tue, 12 Jan 2021 17:48:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 8/9] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
In-Reply-To: <fe0a3415-0c7b-be13-6438-89e82fe4c281@arm.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-9-eric.auger@redhat.com>
 <fe0a3415-0c7b-be13-6438-89e82fe4c281@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <1a06be3153927f1051fcbc87f0e52e98@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, eric.auger@redhat.com,
 eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, shuah@kernel.org,
 pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

On 2021-01-12 17:28, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 12/12/20 6:50 PM, Eric Auger wrote:
>> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
>> reporting of GICR_TYPER.Last for userspace") temporarily fixed
>> a bug identified when attempting to access the GICR_TYPER
>> register before the redistributor region setting but dropped
>> the support of the LAST bit. This patch restores its
>> support (if the redistributor region was set) while keeping the
>> code safe.
> 
> If I understand your patch correctly, it is possible for the 
> GICR_TYPER.Last bit
> to be transiently 1 if the register is accessed before all the 
> redistributors
> regions have been configured.
> 
> Arm IHI 0069F states that accesses to the GICR_TYPER register are RO. I 
> haven't
> found exactly what RO means (please point me to the definition if you 
> find it in
> the architecture!), but I assume it means read-only and I'm not sure 
> how correct
> (from an architectural point of view) it is for two subsequent reads of 
> this
> register to return different values. Maybe Marc can shed some light on 
> this.

RO = Read-Only indeed. Not sure that's documented anywhere in the 
architecture,
but this is enough of a well known acronym that even the ARM ARM doesn't 
feel
the need to invent a new definition for it.

As for your concern, I don't think it is a problem to return different 
values
if the HW has changed in between. This may need to be documented though.

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
