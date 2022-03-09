Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7754C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 18:21:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC8549EDE;
	Wed,  9 Mar 2022 13:21:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HXOWwYOhUGPt; Wed,  9 Mar 2022 13:21:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 413EB412AF;
	Wed,  9 Mar 2022 13:21:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6017F40C67
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 13:21:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f1XwwUgI8EKH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 13:21:56 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CEBF40C10
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 13:21:56 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 17961B8228D;
 Wed,  9 Mar 2022 18:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0924C340E8;
 Wed,  9 Mar 2022 18:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646850113;
 bh=n3AyNeYYT3qBzCWc5lurogmCZWeFbHCnBBPEUTN0SrQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=u4iR61NJk3P0p+1AwRoueA5eNLnCvAUenoprX3ZjQUqdEUWCcYyEHr/6U91WsLeO0
 kiD2nZL2xxF0zz1FxQYHKRJ50UyWHqLVNKLJpLofV+UHZrz8wmbAb7k99mp0xAUcQ3
 FW0uz5NVv9xevbICNV7g4EMq4cgb0Ra3JnvC8AWKtKrA7HnJT9Lz0QzwXuVSiIdbRK
 RmOBqeI6twUWmLtO4zrIblQpJmV3dWfyNK4iSAcGbf6u0NPDbDIFStTA6iXWJKTKPA
 bxTQBkhRZb5/kMdJqIzcsZF+TljMHXns2xtbUfslLhcI+dDScdS3BziS+PJ2M0vLDV
 vd/B6imrM6Yvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nS0wZ-00DPIy-Dt; Wed, 09 Mar 2022 18:21:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: arm64: Really propagate PSCI SYSTEM_RESET2 arguments
 to userspace
Date: Wed,  9 Mar 2022 18:21:48 +0000
Message-Id: <164685007520.3991344.854111174165770865.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309181308.982-1-will@kernel.org>
References: <20220309181308.982-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 qwandor@google.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, Andrew Walbran <qwandor@google.com>
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

On Wed, 9 Mar 2022 18:13:08 +0000, Will Deacon wrote:
> Commit d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the
> guest") hooked up the SYSTEM_RESET2 PSCI call for guests but failed to
> preserve its arguments for userspace, instead overwriting them with
> zeroes via smccc_set_retval(). As Linux only passes zeroes for these
> arguments, this appeared to be working for Linux guests. Oh well.
> 
> Don't call smccc_set_retval() for a SYSTEM_RESET2 heading to userspace
> and instead set X0 (and only X0) explicitly to PSCI_RET_INTERNAL_FAILURE
> just in case the vCPU re-enters the guest.

Applied to next, thanks!

[1/1] KVM: arm64: Really propagate PSCI SYSTEM_RESET2 arguments to userspace
      commit: 9d3e7b7c82fd9d40240867ef4c45388cd05031f3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
