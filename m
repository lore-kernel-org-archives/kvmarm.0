Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28020C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 10:32:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BDE649EFF;
	Thu,  3 Feb 2022 05:32:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HTMnJoyqtbKV; Thu,  3 Feb 2022 05:32:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEEDE49EF8;
	Thu,  3 Feb 2022 05:32:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0689449ED3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 05:32:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id djuD8f4OEf3g for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 05:32:54 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 937954101F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 05:32:54 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id ED68461523;
 Thu,  3 Feb 2022 10:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AB8C340E4;
 Thu,  3 Feb 2022 10:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643884373;
 bh=Ft7nCrMqt04kuaIdbmCLs6sluBNcLSff7icrquTcPHQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Zgjnmilo/S3DuppZmtVd7iAdfqEDD2v9cafHK3EPFMexMVnYOIGZNfRxlMZBeTx7n
 sqvkRx6C0AAtxiooiMKI6sADpGnfTaIvUCmLaZYOQv5jUFBRRWFED/V6RFg6ahwVRq
 5p9Tp4v0OhuXbu4qq+wgAxEymMUfg+fWHZTMJOK7GjG6b8fiEHtjktyNHVg0aFwX3h
 I9KFO3toDxszHhacXU88qz5L1uPdyfModJulHZ9wrQrIU1KBNn+7ljs9jtlbHbLx+v
 GTeImzEcdribhObauMJ+fGO4zON1NKliWlLzkcZ3TmFTYX6bOrl+TVvdVBEM768lVV
 7SsWRwWUgqJdg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nFZQ2-00570p-P8; Thu, 03 Feb 2022 10:32:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/4] KVM: arm64: A510 errata workaround and fixes for
 fixup_guest_exit()
Date: Thu,  3 Feb 2022 10:32:45 +0000
Message-Id: <164388432684.2564391.325135343914416227.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127122052.1584324-1-james.morse@arm.com>
References: <20220127122052.1584324-1-james.morse@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, catalin.marinas@arm.com,
 anshuman.khandual@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>
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

On Thu, 27 Jan 2022 12:20:48 +0000, James Morse wrote:
> Changes since v1:
>  * Moved the SPSR_EL2 fixup into a helper called earlier
>  * Use final cap
>  * Dropped the IS_ENABLED() check

Applied to fixes, thanks!

[2/4] KVM: arm64: Avoid consuming a stale esr value when SError occur
      commit: 1c71dbc8a179d99dd9bb7e7fc1888db613cf85de
[3/4] KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs
      commit: 1229630af88620f6e3a621a1ebd1ca14d9340df7
[4/4] KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata
      commit: 1dd498e5e26ad71e3e9130daf72cfb6a693fee03

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
