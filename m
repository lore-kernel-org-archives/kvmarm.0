Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17D0C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 13:17:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 451BE20760
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 13:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XouGZJhO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 451BE20760
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB8D4B2C1;
	Wed, 10 Jun 2020 09:17:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G+VKlEmbcvZk; Wed, 10 Jun 2020 09:17:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 077CA4B2BF;
	Wed, 10 Jun 2020 09:17:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0CB34B2AE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 09:17:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aIn54nLbizvi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 09:17:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC5624B29D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 09:17:23 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DCB96206F4;
 Wed, 10 Jun 2020 13:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591795043;
 bh=r/1LOWK/aXaczjCrUxr4u2GIs8uHwZD+wzaFjRrloug=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=XouGZJhOk0iO7+/ZpOzCe80kTvuL/yLvI17Mlph88uIwkE9yM3yciHO1l1hDDMKa3
 FToE0Ab262xddP0GUp6PFbgn171Co6o7O/97fngnfayEr9lONO3p3I+pLPiqwHqk7U
 GPrIShQvi0saBgYbdAaFJPDmgYWO1EbxlG5vgz8s=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jj0bZ-001nNx-D3; Wed, 10 Jun 2020 14:17:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 0/3] KVM: arm64: aarch32 ACTLR accesses
Date: Wed, 10 Jun 2020 14:17:08 +0100
Message-Id: <159179498629.1496132.2497129458490530920.b4-ty@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529150656.7339-1-james.morse@arm.com>
References: <20200529150656.7339-1-james.morse@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, 29 May 2020 15:06:53 +0000, James Morse wrote:
> Hello!
> 
> Changes since v1:
>  * Patches 2 & 3 have been swapped.
>  * Copy access_vm_reg() to swizzle 32bit offets back to 64bit
>  * Peek at the encoding to tell ACTLR and ACTLR2 apart...
> 
> [...]

Applied to kvm-arm64/32bit-fixes, thanks!

[1/3] KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
      commit: 7c582bf4ed84f3eb58bdd1f63024a14c17551e7d
[2/3] KVM: arm64: Add emulation for 32bit guests accessing ACTLR2
      commit: ef5a294be8d0e17b91d23be905f69368b0d3952e
[3/3] KVM: arm64: Stop save/restoring ACTLR_EL1
      commit: e8679fedd026eb3b4655af83829d9036e32c9b97

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
