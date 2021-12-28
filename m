Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307BDC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 11:09:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A576849F13;
	Tue, 28 Dec 2021 06:09:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WOPheMpUSAIp; Tue, 28 Dec 2021 06:09:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF6549EF5;
	Tue, 28 Dec 2021 06:09:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A59BA49EEA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 06:09:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JcCNe5EsfRoA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 06:09:28 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5600F49EBF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 06:09:28 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E38DD611BE;
 Tue, 28 Dec 2021 11:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56181C36AE8;
 Tue, 28 Dec 2021 11:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1640689766;
 bh=4ozBu/wuqoCiWwR5g/CP2633fxv3KVzUov3ND3kb660=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EAgKt2TVph6SNzapxtC/JQ38Gm4vs/AjU1xzXlP2KGn3d3g/9FxNMm8zliTrAviYS
 aUrePIAPrGCdrtV/9ZvX6VuNEVFHsXd8DGFPzFn90s36BSIxIp1QR7OkC3mEBBZKBH
 JGsLAMgbU3o0ZTMIrBMoqLqCvCDLzTWnob39NVInUz2xPzNumhUFS+Pf5giUgbnVrO
 wze7ZbtUKLtTCqRpkCTWg+Vdy99hEv2EAokXJRtYieQ15eqV7QLCgltsZvqtOhEIDC
 +EhEpjHeaRoSMXL66w9O/qeobmuilb38+Ynt1OWOLtBH0AG81rMUxXHvzPMFnoEZn8
 UKaLY9/94HuUQ==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n2AM8-00EhvK-Cz; Tue, 28 Dec 2021 11:09:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/6] KVM: arm64: Selftest IPA fixes and 16kB support
Date: Tue, 28 Dec 2021 11:09:17 +0000
Message-Id: <164068975016.1006964.13562930728851260092.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227124809.1335409-1-maz@kernel.org>
References: <20211227124809.1335409-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
 alexandru.elisei@arm.com, kvm@vger.kernel.org, suzuki.poulose@arm.com,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, 27 Dec 2021 12:48:03 +0000, Marc Zyngier wrote:
> Now that the common variety of fruity arm64 systems makes a pretty
> remarkable KVM host, I have decided to run the collection of selftests
> on it.
> 
> Nothing works. Oh no!
> 
> As it turns out, the tests have a notion of "default mode" (40bit PA,
> 4kB), which cannot work in general on arm64 because there no such
> thing as an IPA size that would be valid everywhere (apart from the
> minimal 32bit), nor a guaranteed to be supported page size.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: selftests: arm64: Initialise default guest mode at test startup time
      commit: cb7c4f364abd09abd1865fa049ef492fb43e6bf3
[2/6] KVM: selftests: arm64: Introduce a variable default IPA size
      commit: 357c628e1248dd53f5c43a768246a83478a7f489
[3/6] KVM: selftests: arm64: Check for supported page sizes
      commit: 0303ffdb9ecffac4654b16bbf69ba84d131eb8b7
[4/6] KVM: selftests: arm64: Rework TCR_EL1 configuration
      commit: 2f41a61c54fb6410202b2cc08be80ae9554d599d
[5/6] KVM: selftests: arm64: Add support for VM_MODE_P36V48_{4K,64K}
      commit: e7f58a6bd28bfd2e4f60312abf48f07de2c4121c
[6/6] KVM: selftests: arm64: Add support for various modes with 16kB page size
      commit: aa674de1dc3d2bdf2c67ad195dc81977972323c6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
