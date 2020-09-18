Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74ED1C43464
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 15:57:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA520238A0
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 15:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="r7OmBssu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA520238A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B66D4B1E3;
	Fri, 18 Sep 2020 11:57:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CMYi3eYE9olX; Fri, 18 Sep 2020 11:57:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCD704B1EF;
	Fri, 18 Sep 2020 11:57:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B297A4B1D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 11:57:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WOWSO6U39ewq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 11:57:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D01C04B1CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 11:57:10 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EB3862388B;
 Fri, 18 Sep 2020 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600444630;
 bh=2EcilAACSbcT3KfzwvAMLm256NPLtnuVhaE7x3Kd5wU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=r7OmBssupkefNfijGMbXJiT+4FuYHSElNGvtA0F8+A60+dddq7CKHQ8z7LDTpH4uD
 aNbEkyy6Een/oh4BVqfJIyOwjMOuQI1qozPRPWnb0BL4JMadHzxgLuB9gGTZEExOBH
 9waVyD/LFsZBoCLU1Gg9P+rT+vyyrpMPujpxoihM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kJIl2-00D3F2-Fl; Fri, 18 Sep 2020 16:57:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Will Deacon <will@kernel.org>, Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH -next] KVM: arm64: vgic-debug: convert to use
 DEFINE_SEQ_ATTRIBUTE macro
Date: Fri, 18 Sep 2020 16:56:59 +0100
Message-Id: <160044458392.1301915.930807383105035280.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916025023.3992679-1-liushixin2@huawei.com>
References: <20200916025023.3992679-1-liushixin2@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 catalin.marinas@arm.com, james.morse@arm.com, suzuki.poulose@arm.com,
 julien.thierry.kdev@gmail.com, will@kernel.org, liushixin2@huawei.com,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org
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

On Wed, 16 Sep 2020 10:50:23 +0800, Liu Shixin wrote:
> Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.

Applied to next, thanks!

[1/1] KVM: arm64: vgic-debug: Convert to use DEFINE_SEQ_ATTRIBUTE macro
      commit: cb62e0b5c8db778cd29e63c2f844f36caf6859ed

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
