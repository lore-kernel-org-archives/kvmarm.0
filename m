Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726B4C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 18:40:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A162D49EE0;
	Thu, 17 Feb 2022 13:40:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aZQJljEsbRPA; Thu, 17 Feb 2022 13:40:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAC0E49ED4;
	Thu, 17 Feb 2022 13:40:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3DCC49EC1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 13:40:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ikODuSxeJ4X for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 13:40:10 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EAE549EBE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 13:40:10 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 974E761B8F;
 Thu, 17 Feb 2022 18:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFE5C340EC;
 Thu, 17 Feb 2022 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645123209;
 bh=Dbjh2u64Nwrj1+UqHZeo6jHQzL9HuPf3gHIjesle38A=;
 h=From:To:Cc:Subject:Date:From;
 b=om424GyXiuXkTHcWTvWwS/vwSqes2iPpJ+Mc8fksnKsu3PIHl74qzxdfmtZE+fNuZ
 C0mmX4YNZRjugDMoJOLDF2Aei8iXg5TdSi7CTJxpO9HjpHTIrirtX7AEFJTJTvF30z
 UBq7pM/RZfoX5/1qT0Z4jQTIZsKPl40PO7ngsOOcWMjpwoGERGs8c5ABNG6vrsFrQo
 ugSRdd3OPZ/B0feEYK24KCavVn2vCAADI8TKbKEkS74VCJNwsUjOWmN04EqGkD0mxG
 Zk6oIx6KTq57w5/z/zCj20z9ikmZ6UCkgZdlQQhogXZbG+i17RWOo4b1X4ig2FkxhR
 +fAuwzJO9PH+Q==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/3] Plumb PSCI SYSTEM_RESET2 call for guests
Date: Thu, 17 Feb 2022 18:39:58 +0000
Message-Id: <20220217184001.11753-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Hi folks,

This small series exposes the PSCI SYSTEM_RESET2 call to guests, which
allows the propagation of a "reset_type" and a "cookie" back to the VMM.
Although Linux guests only ever pass 0 for the type ("SYSTEM_WARM_RESET"),
the vendor-defined range can be used by a bootloader to provide additional
information about the reset, such as an error code.

Cheers,

Will

--->8

Will Deacon (3):
  KVM: arm64: Bump guest PSCI version to 1.1
  KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest
  KVM: arm64: Indicate SYSTEM_RESET2 in kvm_run::system_event flags
    field

 Documentation/virt/kvm/api.rst    |  5 +++
 arch/arm64/include/uapi/asm/kvm.h |  7 ++++
 arch/arm64/kvm/psci.c             | 58 +++++++++++++++++++++++++------
 include/kvm/arm_psci.h            |  3 +-
 include/uapi/linux/psci.h         |  4 +++
 5 files changed, 66 insertions(+), 11 deletions(-)

-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
