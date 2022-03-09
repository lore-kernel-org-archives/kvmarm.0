Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E594C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 11:17:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8AB549EE4;
	Wed,  9 Mar 2022 06:17:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ibT9cEqD4gmS; Wed,  9 Mar 2022 06:17:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A67E749ED8;
	Wed,  9 Mar 2022 06:17:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9975149ED3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 06:17:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GJDGWiX1TLLM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 06:17:46 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8400349EB2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 06:17:46 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E5283B81FCB;
 Wed,  9 Mar 2022 11:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5F5C340E8;
 Wed,  9 Mar 2022 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646824663;
 bh=JlkIqCPe8EccB301HGf03mUUxO/iuY/OiZe+7CVnF2s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nWKcIX1WtcJWMTI3tqI2/IaDK7VQ+5erDN46fkvy68oBIyx2lNZcCSCW/wGoMd1fJ
 qBnqjW50tbhc57u+DxKm6lj7tgzKCKnH9Ki5KMrJMyCI5QQEe8KdoD/HnIfePk+1fW
 nFOIui2aLCxc5gpoMUqhyY0v086Bs+Y+RWi+hx+0PSEXeXdGyg2smYH5zc7taBbE3T
 rvzitDDefdRBmnPpvykjg/JmnNepJgIfpRj5c3Mrp2n0OUQyUfTS95x9YVuKrZDVSF
 Orxywajd/wTklVPvgMgZQyo9cjA6oW9AHo1inb9Txsn/nNfTdzFH8tkj7gNdx7ldfJ
 z5bXYW2ZXItqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nRuK5-00DIeD-G7; Wed, 09 Mar 2022 11:17:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2] Documentation: KVM: Update documentation to indicate
 KVM is arm64-only
Date: Wed,  9 Mar 2022 11:17:34 +0000
Message-Id: <164682464677.3740483.6091628911446790457.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220308172856.2997250-1-oupton@google.com>
References: <20220308172856.2997250-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 ricarkol@google.com, alexandru.elisei@arm.com, kvm@vger.kernel.org,
 james.morse@arm.com, pbonzini@redhat.com, suzuki.poulose@arm.com,
 reijiw@google.com, linux-arm-kernel@lists.infradead.org, pshier@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

On Tue, 8 Mar 2022 17:28:57 +0000, Oliver Upton wrote:
> KVM support for 32-bit ARM hosts (KVM/arm) has been removed from the
> kernel since commit 541ad0150ca4 ("arm: Remove 32bit KVM host
> support"). There still exists some remnants of the old architecture in
> the KVM documentation.
> 
> Remove all traces of 32-bit host support from the documentation. Note
> that AArch32 guests are still supported.

Applied to next, thanks!

[1/1] Documentation: KVM: Update documentation to indicate KVM is arm64-only
      commit: 3fbf4207dc6807bf98e3d32558753cfa5eac2fa1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
