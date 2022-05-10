Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2C1C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 10:05:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F73C49E1A;
	Tue, 10 May 2022 06:05:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7q-DAaGcza5R; Tue, 10 May 2022 06:05:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9572F49F0F;
	Tue, 10 May 2022 06:05:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 430A349E1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 06:05:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m-pMbpNMb0Br for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 06:05:06 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6BD349B07
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 06:05:06 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5EE50616DB;
 Tue, 10 May 2022 10:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A90C385C6;
 Tue, 10 May 2022 10:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652177104;
 bh=MOo8nsiLJfqxrIWRjZulpDT7AErX6Kq8hkthnCTA5uU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=jy9sOx5IhAIDejPVKVF2+Bd/T0Py/5wx8+Po+Ecv0CR8BCrEvcq4NXAPEFAm802Ty
 8cRLHqys6IkXu4/djRBMoMkQByyOaFyW7LcnB56PnnqYCrewDk0t6vAPt0ilmAqrP9
 bNMqa/zDBvxt0x7TuFwji5mwsLRZamsLaTtuQqGt1cN7zj1bUdASCaiZelDL/z3VNI
 p6Pj8oL0tYCYRKw+uLngJYl8jq0JkOQqTFSh+zQdDgfqqYgwiiEl9uEIIUab3OLN22
 s6YnDdfn2O6lVXVwCwlbEjUqg8hcgBeNsxeTbQ0nkjXTKMo0wGcRneJRpqWIfMrr3l
 ymPB75JvnFwsw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1noMjm-00ACgV-4r; Tue, 10 May 2022 11:05:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Minor pKVM cleanups
Date: Tue, 10 May 2022 11:04:59 +0100
Message-Id: <165217709150.1535314.2127016424159834600.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220509162559.2387784-1-oupton@google.com>
References: <20220509162559.2387784-1-oupton@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, james.morse@arm.com,
 alexandru.elisei@arm.com, kvm@vger.kernel.org, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, will@kernel.org, linux-kernel@vger.kernel.org,
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

On Mon, 9 May 2022 16:25:57 +0000, Oliver Upton wrote:
> I was reading through some of the pKVM stuff to get an idea of how it
> handles feature registers and spotted a few minor nits.
> 
> Applies cleanly to 5.18-rc5.
> 
> Oliver Upton (2):
>   KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
>   KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
      commit: 4d2e469e163ec79340b2f42c2a07838b5ff30686
[2/2] KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
      commit: 249838b7660ac04a67bfb017364a7f01029370a0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
