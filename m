Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EB1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 19:57:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B504B49B0A;
	Tue, 28 Dec 2021 14:57:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tauWrML08IQM; Tue, 28 Dec 2021 14:57:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 851E049B13;
	Tue, 28 Dec 2021 14:57:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA22349B0A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 14:57:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DZ-yGID3h0GI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 14:57:20 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A678243C8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 14:57:20 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 63CE8B811E3;
 Tue, 28 Dec 2021 19:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D950C36AE9;
 Tue, 28 Dec 2021 19:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1640721438;
 bh=PNFxoZGfYdP2MXz1NJMDhoC7Z1nsRwgaat7iMZbyVMA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=NEO3RZ8mesY8ORpmpCN5d8gSdQfyDxYB8ZS1w/Jg/Nn3Q03nlt2NuRo9qFbEbMGbi
 NW8wOZoA0PGTUfhow5HUcwIBdu47aZcVvgiPgWYNi4nhGqExc8y6/T5e2eKNPLYqWW
 pAuH83YOJEOkqDRehRDy6uvf46i97l/N02UAxXTzwsvZn3LikNSWX8Ve1KOF/o+WmB
 38gKUHCnd9A0ArsLqP53exoqa8MzkD1I1CPVG80rFwL5DbG7xlAwRZltOex/zi/yM6
 OFyktD2M9D5kB/EEn+WBW1/WwmSkX3p4okzaX2vEpbf/tVPR4iga/I7giOHoQkVMNh
 ukhRqRK6fMScA==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n2Iay-00Em7M-3z; Tue, 28 Dec 2021 19:57:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger@redhat.com, drjones@redhat.com, kvm@vger.kernel.org,
 Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 00/17] KVM: selftests: aarch64: Test userspace IRQ
 injection
Date: Tue, 28 Dec 2021 19:57:12 +0000
Message-Id: <164072141023.1027791.3183483860602648119.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
References: <20211109023906.1091208-1-ricarkol@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger@redhat.com, drjones@redhat.com, kvm@vger.kernel.org,
 ricarkol@google.com, shuah@kernel.org, oupton@google.com, reijiw@google.com,
 james.morse@arm.com, jingzhangos@google.com, suzuki.poulose@arm.com,
 rananta@google.com, pbonzini@redhat.com, pshier@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

On Mon, 8 Nov 2021 18:38:49 -0800, Ricardo Koller wrote:
> This series adds a new test, aarch64/vgic-irq, that validates the injection of
> different types of IRQs from userspace using various methods and configurations
> (when applicable):
> 
>     Intid        Method     |       |          Configuration
>                             |       |
>                IRQ_LINE     |       |
>     SGI        LEVEL_INFO   |       |
>     PPI    x   IRQFD        |   x   | level-sensitive  x  EOIR + DIR
>     SPI        ISPENDR      |       | edge-triggered      EOIR only
>     bogus      ISACTIVER    |       |
>                             |       |
> 
> [...]

Applied to next, thanks!

[01/17] KVM: selftests: aarch64: move gic_v3.h to shared headers
        commit: 33a1ca736e74839d08948973d30f6def820b8b14
[02/17] KVM: selftests: aarch64: add function for accessing GICv3 dist and redist registers
        commit: 745068367ccbf33d69cf4acf7b1a3d5478978e8e
[03/17] KVM: selftests: aarch64: add GICv3 register accessor library functions
        commit: 17ce617bf76a7c1d3b553ed01607706434b9ed59
[04/17] KVM: selftests: add kvm_irq_line library function
        commit: 227895ed6d03b46fa619614a41a3b8e1074d6151
[05/17] KVM: selftests: aarch64: add vGIC library functions to deal with vIRQ state
        commit: e95def3a904dea467309bbe382a9032d301ba9cd
[06/17] KVM: selftests: aarch64: add vgic_irq to test userspace IRQ injection
        commit: 50b020cdb7f72077e16133f1d88c9359cf415a53
[07/17] KVM: selftests: aarch64: abstract the injection functions in vgic_irq
        commit: e1cb399eed1eda29568b17bdb75d16cee1fc3da4
[08/17] KVM: selftests: aarch64: cmdline arg to set number of IRQs in vgic_irq test
        commit: e5410ee2806d74a749fa39ca6fdb73be2f88611f
[09/17] KVM: selftests: aarch64: cmdline arg to set EOI mode in vgic_irq
        commit: 8a35b2877d9a15fa885cea744f1e578e035856fe
[10/17] KVM: selftests: aarch64: add preemption tests in vgic_irq
        commit: 0ad3ff4a6adc4922808ef8b2f91880c25195f509
[11/17] KVM: selftests: aarch64: level-sensitive interrupts tests in vgic_irq
        commit: 92f2cc4aa7964d4d13681eeb38582bb989b01b98
[12/17] KVM: selftests: aarch64: add tests for LEVEL_INFO in vgic_irq
        commit: 6830fa915912587a7aa304bade01b366cf0b9214
[13/17] KVM: selftests: aarch64: add test_inject_fail to vgic_irq
        commit: 90f50acac9ee9f81192098c22b2cbf2491a40263
[14/17] KVM: selftests: add IRQ GSI routing library functions
        commit: 88209c104e9b3e95502c0e924fb1cd8bd5a01d82
[15/17] KVM: selftests: aarch64: add tests for IRQFD in vgic_irq
        commit: 6a5a47188caca7be4bbe28cdb31d5df09868ed5c
[16/17] KVM: selftests: aarch64: add ISPENDR write tests in vgic_irq
        commit: bebd8f3f869361e0249efe423ba76a0d991ce3e6
[17/17] KVM: selftests: aarch64: add test for restoring active IRQs
        commit: 728fcc46d2c2292d1ac73f3491b8f4332066fdad

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
