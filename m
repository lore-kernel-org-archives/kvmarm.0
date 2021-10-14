Return-Path: <SRS0=kePE=PC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64E7C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 16:06:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2473C61181
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 16:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2473C61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 833EF4B11F;
	Thu, 14 Oct 2021 12:06:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6cXBJQysAbb8; Thu, 14 Oct 2021 12:06:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ACC44B120;
	Thu, 14 Oct 2021 12:06:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AEBC4B116
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 12:06:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MshUENuv8aYe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Oct 2021 12:06:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D8584B10E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 12:06:13 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 63A3F61056;
 Thu, 14 Oct 2021 16:06:12 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mb3FC-00GmGg-5G; Thu, 14 Oct 2021 17:06:10 +0100
MIME-Version: 1.0
Date: Thu, 14 Oct 2021 17:06:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v9 17/22] KVM: arm64: pkvm: Handle GICv3 traps as required
In-Reply-To: <20211014094613.tnx4xwyqrxj4jmnq@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-7-maz@kernel.org>
 <20211014094613.tnx4xwyqrxj4jmnq@gator.home>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <cba80f95c5df69d9bcea8c6dc30cfbf7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org,
 james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, pbonzini@redhat.com, oupton@google.com,
 qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
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

On 2021-10-14 10:46, Andrew Jones wrote:
> On Wed, Oct 13, 2021 at 01:03:41PM +0100, Marc Zyngier wrote:
>> Forward accesses to the ICV_*SGI*_EL1 registers to EL1, and
>> emulate ICV_SRE_EL1 by returning a fixed value.
>> 
>> This should be enough to support GICv3 in a protected guest.
> 
> Out of curiosity, has the RVIC work / plans been dropped?

ARM has dropped the architecture, and it makes no sense
to move KVM to support non-architectural stuff.

Which means we will eventually have to harden the guest itself
to cope with the fact that it cannot trust the interrupt controller.

Yes, this is crap.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
