Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3D4C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 09:47:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 468F84A500;
	Thu,  7 Apr 2022 05:47:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5vrUNCNgvM8U; Thu,  7 Apr 2022 05:47:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D5694B089;
	Thu,  7 Apr 2022 05:47:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CCFA4A500
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 05:47:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fAa1+YVYJZvb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 05:47:29 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88B214A104
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 05:47:29 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id AD86061B2F;
 Thu,  7 Apr 2022 09:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19C5C385A6;
 Thu,  7 Apr 2022 09:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649324847;
 bh=a1rcu+ZyNJxwI9Cq12YBB5U8M9DoLNGZ6tMOngy1Uts=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=nq+nbf4bbvlPu8AB1otp6PpdlKL7EKwFRFQcS7UPzQat2B3ofEDE00oPx5/vLy1QV
 /hg27ARJwvSKKmNMiv4RQJjZSeMHIZJYvUrrslu4s9gsjzghlpKadKTw1QQ1Ai+zWw
 8VMwliMufL589lExQpKzmKU2vmOoroe+0PubQLduZmhf47/PGCcf3rNzf2Qesm3Jq9
 1SbaUC1hi2a2E4mkXWTpl6Y/G3OEGbm84i2B1cMS/TU0kpFuOhv+UPGzIEotmNXp6p
 EQaw4KFnN1jzHBNyXcagNi0SyFWMl6L9ONv86mXKLRylxAZo0vY5aspEHWIo1H+MYR
 LOX0rJsNztn2g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1ncOjd-002RDg-E9; Thu, 07 Apr 2022 10:47:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: selftests: get-reg-list: Add KVM_REG_ARM_FW_REG(3)
Date: Thu,  7 Apr 2022 10:47:20 +0100
Message-Id: <164932482949.4015708.16602569255075798343.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316125129.392128-1-drjones@redhat.com>
References: <20220316125129.392128-1-drjones@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Wed, 16 Mar 2022 13:51:29 +0100, Andrew Jones wrote:
> When testing a kernel with commit a5905d6af492 ("KVM: arm64:
> Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated")
> get-reg-list output
> 
> vregs: Number blessed registers:   234
> vregs: Number registers:           238
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: selftests: get-reg-list: Add KVM_REG_ARM_FW_REG(3)
      commit: 02de9331c4d0c6bddac9c5fa66d91f70adf8612b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
