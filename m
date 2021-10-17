Return-Path: <SRS0=PgOR=PF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E378C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 10:11:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBD2A61039
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 10:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EBD2A61039
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C4584B12E;
	Sun, 17 Oct 2021 06:11:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w2Xmt+f5g4Dw; Sun, 17 Oct 2021 06:11:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76A744B13A;
	Sun, 17 Oct 2021 06:11:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF4C4B12E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Oct 2021 06:11:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DYE7UtyYUWDr for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Oct 2021 06:11:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 734EF4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Oct 2021 06:11:38 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 64660603E7;
 Sun, 17 Oct 2021 10:11:37 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mc38h-00HJ9I-1p; Sun, 17 Oct 2021 11:11:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/5] KVM: arm64: Assorted vgic-v3 fixes
Date: Sun, 17 Oct 2021 11:11:32 +0100
Message-Id: <163446547856.1611056.6126339357800795046.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010150910.2911495-1-maz@kernel.org>
References: <20211010150910.2911495-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 maz@kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 eric.auger@redhat.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
 joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
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

On Sun, 10 Oct 2021 16:09:05 +0100, Marc Zyngier wrote:
> Here's a bunch of vgic-v3 fixes I have been sitting on for some
> time. None of them are critical, though some are rather entertaining.
> 
> The first one is a leftover from the initial Apple-M1 enablement,
> which doesn't advertise the GIC support via ID_AA64PFR0_EL1 (which is
> expected, as it only has half a GIC...). We address it by forcefully
> advertising the feature if the guest has a GICv3.
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3
      commit: 562e530fd7707aad7fed953692d1835612238966
[2/5] KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors
      commit: df652bcf1136db7f16e486a204ba4b4fc4181759
[3/5] KVM: arm64: vgic-v3: Reduce common group trapping to ICV_DIR_EL1 when possible
      commit: 0924729b21bffdd0e13f29ea6256d299fc807cff
[4/5] KVM: arm64: vgic-v3: Don't advertise ICC_CTLR_EL1.SEIS
      commit: f87ab682722299cddf8cf5f7bc17053d70300ee0
[5/5] KVM: arm64: vgic-v3: Align emulated cpuif LPI state machine with the pseudocode
      commit: 9d449c71bd8f74282e84213c8f0b8328293ab0a7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
