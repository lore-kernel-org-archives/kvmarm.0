Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFFA9C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 15:05:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD3649EF2;
	Wed,  2 Mar 2022 10:05:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uHSToM5X1AfF; Wed,  2 Mar 2022 10:05:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B9140AEB;
	Wed,  2 Mar 2022 10:05:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9725949EDF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 10:05:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DvlCjRhbRcB5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 10:05:41 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ACB249ECF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 10:05:41 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 21829B82025;
 Wed,  2 Mar 2022 15:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB0FC004E1;
 Wed,  2 Mar 2022 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646233538;
 bh=eQqM5ysabFFKHeuhGo8OOZSK8/fVAPxIy4eE2d8L/Qc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Y0unoGP5KBZHjT18Xi4Joegb2P4+OYaIInZRRjtkiJId0CqMBeJ86fykX45+klNiI
 v7M6RbTrcu0Z3VztSEEWo5NuVbXi7zU3IyKhEyUd1Dtdz7dmgignO6DdRk3AkfqKjI
 epTAgmWd55N8ffkJB3QhJEo/5taaeUT+U5xQj6BE56Jy48tj7HLDxZ05A2L6qSlvVt
 rju/dFCIiATLhuVXTODeDqqVQpBFDnxge1DGsyRm0Os1rPY1Sx3XnGNBHcH8AUhGII
 8to4ZmKe6hzTK4WuM9ITE1wtJvmhWXQUISx2dvTSmdrkprSX77NtKX9V/+TIZj52Nm
 StkdWAdsDB8qA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nPQXo-00BiLN-F6; Wed, 02 Mar 2022 15:05:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] KVM: arm64: Enable Cortex-A510 erratum 2077057 by default
Date: Wed,  2 Mar 2022 15:05:32 +0000
Message-Id: <164623350047.1159363.1531648833145192400.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220225184658.172527-1-broonie@kernel.org>
References: <20220225184658.172527-1-broonie@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, broonie@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, 25 Feb 2022 18:46:58 +0000, Mark Brown wrote:
> The recently added configuration option for Cortex A510 erratum 2077057 does
> not have a "default y" unlike other errata fixes. This appears to simply be
> an oversight since the help text suggests enabling the option if unsure and
> there's nothing in the commit log to suggest it is intentional.

Applied to next, thanks!

[1/1] KVM: arm64: Enable Cortex-A510 erratum 2077057 by default
      commit: 4c11113c1a3d10f5b617e5d2b9acd8d1d715450f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
