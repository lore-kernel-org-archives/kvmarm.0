Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C5FC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 14:07:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66F2E49F0F;
	Fri, 18 Mar 2022 10:07:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xnecMtis6rjL; Fri, 18 Mar 2022 10:07:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C9DC49F02;
	Fri, 18 Mar 2022 10:07:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0475849EEA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 10:07:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eZSPywdaPSSW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 10:07:26 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D92BB49EBF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 10:07:26 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3440F61A39;
 Fri, 18 Mar 2022 14:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953BEC340E8;
 Fri, 18 Mar 2022 14:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647612445;
 bh=C3OQt/00TuxMRT85jYxLnQpTSKyb+BvUMIF15Qmze5E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=JZOI6CxP9H5taRrXVzzRPxfzZWcCotG7UiXtDahIEn8LzrU8lw9ulCnGuKH3ftYFT
 bzS7pnDJxxw9cPt9uSmta2JYM21Cs0CPkrvhOcLT0j414yDVHGI/KFM5A8UttMpnnJ
 +xdaylg85g/H0r6rtlt0hYZ71rIcFfEtcxcnRn9vGWJPxWdxwsWpEp1LqJP9DIGdq5
 YlEWcC5OzOUvACmsn6fw99UhLx1CjThJ1ElLquOQVOA46lm0pi3VS9uDOmQWW+WIvw
 56UhSPk1QcnCtsN/Nl4UNv2RvZJlMVEoMn6XEHS2DzH9V++Wdy1uGzfh9SkrDrKhCQ
 9n8WMpBLURQJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nVDGF-00FSSq-2K; Fri, 18 Mar 2022 14:07:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: (subset) [PATCH v4 00/15] KVM: arm64: PSCI SYSTEM_SUSPEND +
 SYSTEM_RESET2 bugfix
Date: Fri, 18 Mar 2022 14:07:20 +0000
Message-Id: <164761240231.2295955.10089198303947734980.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
References: <20220311174001.605719-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 wanpengli@tencent.com, jmattson@google.com, pbonzini@redhat.com,
 vkuznets@redhat.com, pshier@google.com, atishp@atishpatra.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, joro@8bytes.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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

On Fri, 11 Mar 2022 17:39:46 +0000, Oliver Upton wrote:
> **NOTE** Patch 2 is a bugfix for commit d43583b890e7 ("KVM: arm64:
> Expose PSCI SYSTEM_RESET2 call to the guest") on kvmarm/next. Without
> this patch, it is possible for the guest to call
> PSCI_1_1_FN64_SYSTEM_RESET2 from AArch32.
> 
> The PSCI v1.0 specification describes a call, SYSTEM_SUSPEND, which
> allows software to request that the system be placed into the lowest
> possible power state and await an IMPLEMENTATION DEFINED wakeup event.
> This call is optional in v1.0 and v1.1. KVM does not currently support
> this optional call.
> 
> [...]

Applied to next, thanks!

[01/15] KVM: arm64: Generalise VM features into a set of flags
        commit: 06394531b425794dc56f3d525b7994d25b8072f7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
