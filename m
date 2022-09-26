Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3CAC32771
	for <kvmarm@archiver.kernel.org>; Mon, 26 Sep 2022 09:59:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C18C4B08F;
	Mon, 26 Sep 2022 05:59:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2x6g-NHV39WR; Mon, 26 Sep 2022 05:59:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEC484B77A;
	Mon, 26 Sep 2022 05:59:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E69854B08F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 05:59:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VQUXBZ52OJIH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 05:59:51 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E88F408F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 05:59:51 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 7EDF2CE10D9;
 Mon, 26 Sep 2022 09:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7643CC433D6;
 Mon, 26 Sep 2022 09:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664186384;
 bh=JkqwGO41jubzZ7FENPY93uExAipCGViKwp9CWUpcYec=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oQZ8GcxQRwTvaC9P7g6BCyFH/8e7160/hRnWMTBbxuq3tCdNYKdHF907yaJKkL6Kw
 ZTJWJc1wz8KkgDcuFr/czYUsGeb2W2YmosFwu2B/Cxor4DH7nG4Rk9ohqbc5Zp1vvs
 SnB9453ofpP6KyOV/UZfcaNb/DRMGhz9XUloVr2UYg1njQbC9mA/J5V0vBsERzwKX4
 swIPOxfDQVKyb6eu1cBujSicjfWn7vz2T+901VzOqop0RpF40KAl5ueZDDvQ8oaj/F
 K3sIFHN6ZeqN/wct/3mv1rmq8zRdp6LS+/k79gfiCVZO2TmBb2JtQWQJZSa5vPc7Px
 S0HXlAFCru6gQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ocktq-00CcjO-82;
 Mon, 26 Sep 2022 10:59:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Elliot Berman <quic_eberman@quicinc.com>
Subject: Re: [PATCH v5] KVM: arm64: Ignore kvm-arm.mode if
 !is_hyp_mode_available()
Date: Mon, 26 Sep 2022 10:59:39 +0100
Message-Id: <166418635574.3586576.7130049081458859826.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920190658.2880184-1-quic_eberman@quicinc.com>
References: <20220920190658.2880184-1-quic_eberman@quicinc.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, will@kernel.org, suzuki.poulose@arm.com,
 quic_eberman@quicinc.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Tue, 20 Sep 2022 12:06:58 -0700, Elliot Berman wrote:
> Ignore kvm-arm.mode if !is_hyp_mode_available(). Specifically, we want
> to avoid switching kvm_mode to KVM_MODE_PROTECTED if hypervisor mode is
> not available. This prevents "Protected KVM" cpu capability being
> reported when Linux is booting in EL1 and would not have KVM enabled.
> Reasonably though, we should warn if the command line is requesting a
> KVM mode at all if KVM isn't actually available. Allow
> "kvm-arm.mode=none" to skip the warning since this would disable KVM
> anyway.

Applied to next, thanks!

[1/1] KVM: arm64: Ignore kvm-arm.mode if !is_hyp_mode_available()
      commit: b2a4d007c347b4cb4c60f7512733c3f8300a129c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
