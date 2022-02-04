Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35545C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  4 Feb 2022 13:51:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CFB443C96;
	Fri,  4 Feb 2022 08:51:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q8Bel-T85p3A; Fri,  4 Feb 2022 08:51:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C874540D23;
	Fri,  4 Feb 2022 08:51:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47BF740CDE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 08:51:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ROZnTOEvhkXM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Feb 2022 08:51:29 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1512F40C67
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 08:51:29 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 669E261BF8;
 Fri,  4 Feb 2022 13:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF26C004E1;
 Fri,  4 Feb 2022 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643982688;
 bh=HBeQGeA56RJQC0kVdE6j6svl7AT/tnn/cVac/ZjQWy0=;
 h=From:To:Cc:Subject:Date:From;
 b=KhokMH1VHQQvia2HwWjHR5vlsBLwruWzSopNXvdG4M0qwRrQZ6iTqwy6dzo928gmT
 OCtas90A5XlB+0nZ+3JhtIyVYvF1U535QsO7qWWiSv1PMXQ9/KCoLPn/izeFAlrxMg
 uz4vxEALb4yCcbP0OmEizQoMYgSAexu6mfxpw9zdMokgkZt5clhwlFgeJIDGGB8g8n
 72N4cEdYxPOiCNmiRILjNyASOMOzlcsvx7hggfpkMRhk1mminwKTlhVPPTKgXjaURG
 DOylWpEjZWxCyXFxpXyp6It/RDQ7KjunHuI+IAUXMWOT5BVn/EDfdeih9x2afm6axW
 sbBDPbGOFk+PQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nFyzl-005PIR-N8; Fri, 04 Feb 2022 13:51:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.17, take #2
Date: Fri,  4 Feb 2022 13:51:20 +0000
Message-Id: <20220204135120.1000894-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, james.morse@arm.com,
 steven.price@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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

Paolo,

Here's a handful of fixes for -rc3, all courtesy of James Morse.

Please pull,

	M.

The following changes since commit 26291c54e111ff6ba87a164d85d4a4e134b7315c:

  Linux 5.17-rc2 (2022-01-30 15:37:07 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-2

for you to fetch changes up to 1dd498e5e26ad71e3e9130daf72cfb6a693fee03:

  KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata (2022-02-03 09:22:30 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.17, take #2

- A couple of fixes when handling an exception while a SError has been
  delivered

- Workaround for Cortex-A510's single-step[ erratum

----------------------------------------------------------------
James Morse (3):
      KVM: arm64: Avoid consuming a stale esr value when SError occur
      KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs
      KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata

 Documentation/arm64/silicon-errata.rst  |  2 ++
 arch/arm64/Kconfig                      | 16 ++++++++++++++++
 arch/arm64/kernel/cpu_errata.c          |  8 ++++++++
 arch/arm64/kvm/handle_exit.c            |  8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++++++++++--
 arch/arm64/tools/cpucaps                |  5 +++--
 6 files changed, 58 insertions(+), 4 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
