Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C76DC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 10:07:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F129F4BD93;
	Fri, 15 Jul 2022 06:07:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id axZTk+uxVjkK; Fri, 15 Jul 2022 06:07:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C02F64BD84;
	Fri, 15 Jul 2022 06:07:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E28D4BD81
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:07:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y1-lTkgKyptB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 06:06:59 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03C204BD7D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:06:58 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 35550CE2E8A;
 Fri, 15 Jul 2022 10:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A744C34115;
 Fri, 15 Jul 2022 10:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657879611;
 bh=N6XR6hU9xbp0IA+LXBFd/F2FgKNUufttOOOMm1SU3Q4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=UoNAH789eMR64DTe+ttG2yQlzTFq3gbMozTd8BkU/iLEoU6DysqkPwzEji9ast5bQ
 +EyNVkNAQuH5VsDSqSgPb66le8PeGAF7gW+OGytvi/C2qevoTGwAOO8zId7FzVCWEB
 QeFDU68BBgp+QuL/LJ+pBbdJrMoNXTmatnigdGgxZY1ExEJveZMdAEOgaMyGKoa4GL
 rrDj5GLL1bzu8BD7+m+AqcRK37dZwP/pATBmRYEWo2NY77fr7UtiZZOzGmVkmvHsS4
 KuTDioF+oeRADMGFOt+qRl+Pqoa/mF1YMH7zZuCBVUgHoKHDWpXOAnZdq7NGoyUFH0
 QBelhk+NsCh9w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oCIDh-007edL-Bz;
 Fri, 15 Jul 2022 11:06:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: selftests: Add support for GICv2 on v3
Date: Fri, 15 Jul 2022 11:06:46 +0100
Message-Id: <165787958336.3532416.361922683569453134.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714154108.3531213-1-maz@kernel.org>
References: <20220714154108.3531213-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, oliver.upton@linux.dev, alexandru.elisei@arm.com,
 ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Oliver Upton <oliver.upton@linux.dev>
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

On Thu, 14 Jul 2022 16:41:08 +0100, Marc Zyngier wrote:
> The current vgic_init test wrongly assumes that the host cannot
> multiple versions of the GIC architecture, while v2 emulation
> on v3 has almost always been supported (it was supported before
> the standalone v3 emulation).
> 
> Tweak the test to support multiple GIC incarnations.

Applied to next, thanks!

[1/1] KVM: arm64: selftests: Add support for GICv2 on v3
      commit: 6a4f7fcd750497cb2fa870f799e8b23270bec6e3

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
