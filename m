Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDCEC43219
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:37:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 634F94B08B;
	Tue,  8 Feb 2022 12:37:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gME3WnNiO1aa; Tue,  8 Feb 2022 12:37:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E02BC4B13D;
	Tue,  8 Feb 2022 12:37:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5843B4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4h16Sshor-fP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:37:29 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E6914B133
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:29 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C87ADB81CB8;
 Tue,  8 Feb 2022 17:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D042C004E1;
 Tue,  8 Feb 2022 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644341847;
 bh=hLB0sYIRDmT6QfVgnPvR4+VTSPDkVrSFX6+peUwAxY0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SkWC+SEy7c5UGHjmleu74zI2RWFnEVHs4muVZ+Tx0KoeLTEf4oT6HikkvXbK1/NSB
 HUtJElm4OmrRmKT+EAitvOd/fCEyOqZa58hrwagzTF+dJdeNXKXuNZjRvqyypcmFbd
 gXUw7u3x4G+2/yBjhARDonZyBn8MpUb+pkojwyY5ZvIE3brS+IQHPxyTXjQjQHAcM/
 E6qi6nfwxxLcPFNHw8U23TZguW2UGX2bOkOpyeyxKSnb2+4BMEJ1ZFax87SKwBtbvX
 FtJYVgGoUSBSNRPLKcVZDD7T3brcLiD9TzqsGAOxAAgTuVzmeKPNVDB2jnKIWN8W6Y
 /79yiNWS4ebTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nHUQf-006Ksa-Mk; Tue, 08 Feb 2022 17:37:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 0/6] KVM: arm64: Emulate the OS Lock
Date: Tue,  8 Feb 2022 17:37:24 +0000
Message-Id: <164434147326.3931943.9332144598963779018.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
References: <20220203174159.2887882-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 drjones@redhat.com, james.morse@arm.com, reijiw@google.com,
 suzuki.poulose@arm.com, ricarkol@google.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, pshier@google.com,
 mark.rutland@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
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

On Thu, 3 Feb 2022 17:41:53 +0000, Oliver Upton wrote:
> KVM does not implement the debug architecture to the letter of the
> specification. One such issue is the fact that KVM treats the OS Lock as
> RAZ/WI, rather than emulating its behavior on hardware. This series adds
> emulation support for the OS Lock to KVM. Emulation is warranted as the
> OS Lock affects debug exceptions taken from all ELs, and is not limited
> to only the context of the guest.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
      commit: e2ffceaae50883c5064641167078e5720fd8b74a
[2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
      commit: d42e26716d038d9689a23c193b934cdf0e2a2117
[3/6] KVM: arm64: Allow guest to set the OSLK bit
      commit: f24adc65c5568a8d94e2693f5441de80f1ffe0d3
[4/6] KVM: arm64: Emulate the OS Lock
      commit: 7dabf02f43a1670d13282463fc0106f01dfd6f9c
[5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
      commit: d134998838ac217a8427c1ddc83cf48888bb3fa3
[6/6] selftests: KVM: Test OS lock behavior
      commit: 05c9324de1695b5e61dceca6d2ef0ab8c0f2f26b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
