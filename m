Return-Path: <SRS0=ILOk=AQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125A1C433E0
	for <kvmarm@archiver.kernel.org>; Sun,  5 Jul 2020 18:18:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E00120720
	for <kvmarm@archiver.kernel.org>; Sun,  5 Jul 2020 18:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMwO1tF7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E00120720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 266004B1B2;
	Sun,  5 Jul 2020 14:18:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b3flnlUiF2kY; Sun,  5 Jul 2020 14:18:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B3E14B0E8;
	Sun,  5 Jul 2020 14:18:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 499E84B0E0
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 14:18:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RjG16zXqSieo for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2020 14:18:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 697454B0AD
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 14:18:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5521B20720;
 Sun,  5 Jul 2020 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593973091;
 bh=ZcyrfoWN8MHHgOfd7nwKxw3dttJq6mqbG1jYnjHLddQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fMwO1tF7X+Qe3aFk1yGRRfk0zU6kFp6AxXSN2NRPvaP6MYjEbP4+y2WQaKMRfXVFh
 Hw7lWfl8t5bqOFxXCYUhdI4/glZ8TV0VMcoZ70b3tW+XqWGw1kikGQzDNVBXc/8WwE
 c3Gn0NIzBL2kYtDE+MSTmycyMkPOKbFj2+9ssHiY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1js9DN-009Dpy-Rr; Sun, 05 Jul 2020 19:18:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: arm64: Change default caching mode for {PEND,
 PROP}BASER.outer
Date: Sun,  5 Jul 2020 19:18:03 +0100
Message-Id: <159397301833.254690.3043556347352831821.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701140206.8664-1-graf@amazon.com>
References: <20200701140206.8664-1-graf@amazon.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: graf@amazon.com, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 1 Jul 2020 16:02:06 +0200, Alexander Graf wrote:
> PENDBASER and PROPBASER define the outer caching mode for LPI tables.
> The memory backing them may not be outer sharable, so we mark them as nC
> by default. This however, breaks Windows on ARM which only accepts
> SameAsInner or RaWaWb as values for outer cachability.
> 
> We do today already allow the outer mode to be set to SameAsInner
> explicitly, so the easy fix is to default to that instead of nC for
> situations when an OS asks for a not fulfillable cachability request.
> 
> [...]

Applied to kvm-arm64/next-5.9, thanks!

[1/1] KVM: arm64: vgic-its: Change default outer cacheability for {PEND, PROP}BASER
      commit: 731532176716e2775a5d21115bb9c5c61e0cb704

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
