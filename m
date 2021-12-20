Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E822C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 20 Dec 2021 14:05:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 026084B4A9;
	Mon, 20 Dec 2021 09:05:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9HLuGdsoN3MV; Mon, 20 Dec 2021 09:05:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0D44B4B2;
	Mon, 20 Dec 2021 09:05:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DB4C4B4B2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Dec 2021 09:05:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QvBpSfHvA37M for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Dec 2021 09:05:32 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 470CB4B4A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Dec 2021 09:05:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 1FD62CE10DB;
 Mon, 20 Dec 2021 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D577C36AEA;
 Mon, 20 Dec 2021 14:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1640009127;
 bh=vB8KcdNfjcnpEkzVQLqvdZ/M+EZxqGO0H04VqIuatEY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nlGtV5AydQWpOAh5PjHlggT27o0YWSkMuqsFOC7UfaBt2ShrqTY33cfXSV8MkPkGF
 KqOkgUQgsdM0jTd21RZaqfkYiFQDv5dJFfLmDlg1X/Er7jSQBQlcICUcoqIQgwJay1
 3CHF9yVoSOHPzIzcJs88jpkoIwim979ezOzRsX3gMvSUxLEtOWdaurVujjeRLtk9fc
 qB3k1YFqT6kzwWRsTAnOOwYvQPLbOfg1m0XFDAerZJq5WGEVk3Ygfx8kt/1cDfCaMg
 fDmc5ShIonsca4vtkvHKb0e3nevFrUkbsqumyeEyW5mjIzktaq9Q7covlFD8kl2R4V
 CzRNG3gOv2prw==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mzJI5-00DId5-Je; Mon, 20 Dec 2021 14:05:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: arm64: Use defined value for SCTLR_ELx_EE
Date: Mon, 20 Dec 2021 14:05:22 +0000
Message-Id: <164000911220.1759644.14598110992335540231.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208192810.657360-1-tabba@google.com>
References: <20211208192810.657360-1-tabba@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tabba@google.com, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, kernel-team@android.com
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

On Wed, 8 Dec 2021 19:28:10 +0000, Fuad Tabba wrote:
> Replace the hardcoded value with the existing definition.
> 
> No functional change intended.

Applied to next, thanks!

[1/1] KVM: arm64: Use defined value for SCTLR_ELx_EE
      commit: 500ca5241bf8054c8a973e54cb28629614f43178

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
