Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8905C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 15 May 2022 10:57:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9B749E42;
	Sun, 15 May 2022 06:57:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hwehSrVY-CAS; Sun, 15 May 2022 06:57:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 479074B187;
	Sun, 15 May 2022 06:57:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE68E49E42
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 06:57:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JPi4J4FeyFA1 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2022 06:57:45 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0F4E49E36
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 06:57:45 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 37E6A60F35;
 Sun, 15 May 2022 10:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CADBC385B8;
 Sun, 15 May 2022 10:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652612264;
 bh=IngVGMhyvDcAzEJp+1IFX4F6pqTo8h56mNttrbT3H00=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SdGFlznuXAJsVUYKNJE3ZqwqeibHiRkAYY033FqE68YCP2VMtGgyjIjOs+mBVV0YD
 MIG52lVoWkQqibIpArm/pzd2Uki2slpHmtcTfnlkGeNkxWJU5PgD5prAfH97eU3k4l
 /PQX3VekdlSxWC/1RHvoBJfRIn+qChr5hu8bbnRJWQKg3cJeSp7FXwm6vVflWqZw51
 XNXSP+p+nmz6DAUzUEoNNTdsO9g3+HjrOBV/CXV181/ToKaZ0bxkP4oaQhTBGHkPBl
 UsQcQu1wikNdniipRXezA66kPBTTP3b6pS3MlVf7HEP5zclK83zwvexO5cP1Ipeorp
 sDnu1DPqH/eBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nqBwU-00BPnt-0t; Sun, 15 May 2022 11:57:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: Do not communicate host pmu event
 changes by accessing hyp data
Date: Sun, 15 May 2022 11:57:39 +0100
Message-Id: <165261223450.3678424.17937450491948923943.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510095710.148178-1-tabba@google.com>
References: <20220510095710.148178-1-tabba@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, tabba@google.com,
 will@kernel.org, kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com
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

On Tue, 10 May 2022 09:57:06 +0000, Fuad Tabba wrote:
> This series changes the way KVM communicates host pmu event changes to the
> hypervisor in nvhe and protected mode. Instead of accessing hyp data directly
> from the host, the data is passed to hyp via the loaded vcpu. This provides
> more isolation between the host and the hypervisor, and allows us to use pmu in
> protected mode.
> 
> This series is based on kvmarm/next (8c22fd2d4cfa).
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Wrapper for getting pmu_events
      commit: 3cb8a091a7016be0ee5420ff6c1928972e3ce23e
[2/4] KVM: arm64: Repack struct kvm_pmu to reduce size
      commit: e987a4c60f9755b2f7a19bf1b5ef2eb74c90579b
[3/4] KVM: arm64: Pass pmu events to hyp via vcpu
      commit: 84d751a019a9792f5b4884e1d598b603c360ec22
[4/4] KVM: arm64: Reenable pmu in Protected Mode
      commit: 722625c6f4c5b6a9953d6af04c7bb1a6e12830b3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
