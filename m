Return-Path: <SRS0=tVNh=FB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCB1C2D0E4
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 12:03:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0DF8A21D93
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 12:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6NBfDar"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DF8A21D93
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5329D4BF02;
	Fri, 27 Nov 2020 07:03:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vPs3TqVrcQRd; Fri, 27 Nov 2020 07:03:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 908544BEF4;
	Fri, 27 Nov 2020 07:03:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AB054BEEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 07:03:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WAJwZXP+XTcR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2020 07:03:03 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 711394BEE3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 07:03:03 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2D05E21D81;
 Fri, 27 Nov 2020 12:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606478582;
 bh=4sB99oBXhvHTV00UC3ptz0ypl0NZkS0T3hnJifr3krs=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=g6NBfDarpQ5BKdfQHldm7VaEb6QxdLMzlNYsxZz6c82TQYASaRtlAv753PmY08q2O
 1jOBkmyz/pEcIVno7oGkgUuE3NrD35Ac/+o6x+ml8HlgQiwd6kRvc80fGL8kptahsF
 A7J1y5o5dOwp6Tv7xJ12sfxPFLXA84SO+yGdNT84=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kicSq-00E3C5-6B; Fri, 27 Nov 2020 12:03:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: julien.thierry.kdev@gmail.com, Alexandru Elisei <alexandru.elisei@arm.com>,
 james.morse@arm.com, kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] KVM: arm64: Refuse to run VCPU if PMU is not initialized
Date: Fri, 27 Nov 2020 12:02:55 +0000
Message-Id: <160647856089.4184.2157570047282558486.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126144916.164075-1-alexandru.elisei@arm.com>
References: <20201126144916.164075-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: julien.thierry.kdev@gmail.com, alexandru.elisei@arm.com,
 james.morse@arm.com, kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org
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

On Thu, 26 Nov 2020 14:49:16 +0000, Alexandru Elisei wrote:
> When enabling the PMU in kvm_arm_pmu_v3_enable(), KVM returns early if the
> PMU flag created is false and skips any other checks. Because PMU emulation
> is gated only on the VCPU feature being set, this makes it possible for
> userspace to get away with setting the VCPU feature but not doing any
> initialization for the PMU. Fix it by returning an error when trying to run
> the VCPU if the PMU hasn't been initialized correctly.
> 
> [...]

Applied to kvm-arm64/pmu-undef, thanks!

[1/1] KVM: arm64: Refuse to run VCPU if PMU is not initialized
      commit: 9bbfa4b565379eeb2fb8fdbcc9979549ae0e48d9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
