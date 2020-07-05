Return-Path: <SRS0=ILOk=AQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28102C433DF
	for <kvmarm@archiver.kernel.org>; Sun,  5 Jul 2020 17:51:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D167521556
	for <kvmarm@archiver.kernel.org>; Sun,  5 Jul 2020 17:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYZ/AFe6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D167521556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F2BE4B14F;
	Sun,  5 Jul 2020 13:51:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yScTVT8+NjUH; Sun,  5 Jul 2020 13:51:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 499364B15C;
	Sun,  5 Jul 2020 13:51:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71FE54B14F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 13:51:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fBC0j2NSEw2d for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2020 13:51:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85D9E4B154
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2020 13:51:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B499E2074F;
 Sun,  5 Jul 2020 17:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593971471;
 bh=xYUBWSZ5y348JHgNGMQGL3gkp+BO4/wWySnOgsqBJ4g=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZYZ/AFe60/hNBAlQ3D1tfwJhceMeV8o7bltMDkta1sUiNSeALM6tbe2aIP+tH+o7l
 PTpqLOBdmEpKiQGHVIIUG4hCpCyVhpAfaX2etRyipysCR1I8KmvPfwr6Z67uM2khL8
 EonZIwx+qqfmE6Xsw4c5UDQDXmRQA2KOcK1IiNeY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1js8nG-009DUh-8a; Sun, 05 Jul 2020 18:51:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 David Brazdil <dbrazdil@google.com>, James Morse <james.morse@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 0/5] KVM: arm64: Remove the target table
Date: Sun,  5 Jul 2020 18:51:02 +0100
Message-Id: <159397135631.253877.2545914791017021362.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622113317.20477-1-james.morse@arm.com>
References: <20200622113317.20477-1-james.morse@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, dbrazdil@google.com, james.morse@arm.com,
 catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
 linux-kernel@vger.kernel.org, android-kvm@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: android-kvm@google.com, kernel-team@android.com,
 linux-kernel@vger.kernel.org
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

On Mon, 22 Jun 2020 11:33:12 +0000, James Morse wrote:
> KVM's target_table indirection is a relic from 32bit where different
> CPUs had different reset values for ACTLR. All 64bit CPUs have the
> same behaviour here, but we support different targets, that all map
> to the same behaviour.
> 
> This series removes the indirection and the fiddly handling of two
> tables.
> 
> [...]

Applied to kvm-arm64/next-5.9, thanks!

[1/5] KVM: arm64: Drop the target_table[] indirection
      commit: 6b33e0d64f8501b51d32069e08d3ed68c58c25b4
[2/5] KVM: arm64: Tolerate an empty target_table list
      commit: 04343ae312ef0d80d601ea1b784b6b039ae9c82a
[3/5] KVM: arm64: Move ACTLR_EL1 emulation to the sys_reg_descs array
      commit: af4738290d9dfe3787f60e40f709a4f78a115943
[4/5] KVM: arm64: Remove target_table from exit handlers
      commit: dcaffa7bf911578a6d69165d712501996c587fbe
[5/5] KVM: arm64: Remove the target table
      commit: 750ed56693803e992ed09ac9c46e07226dd4d350

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
