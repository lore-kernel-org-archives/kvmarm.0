Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E128C4332F
	for <kvmarm@archiver.kernel.org>; Sat,  1 Oct 2022 09:18:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78CD840AEA;
	Sat,  1 Oct 2022 05:18:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VrP9cOc0t66C; Sat,  1 Oct 2022 05:18:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DB340B59;
	Sat,  1 Oct 2022 05:18:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9458640AEA
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Oct 2022 05:18:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aVxPEe0e1Bv9 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  1 Oct 2022 05:18:42 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E484408F4
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Oct 2022 05:18:42 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 826E160B4F;
 Sat,  1 Oct 2022 09:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F69C433D6;
 Sat,  1 Oct 2022 09:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664615919;
 bh=2rogGG85HQXuD7WibeMAU+YBXmWNjHZnGMq/xPogXoY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qvjoaMOBB+Kv0oI1Nl9I1Ld8FdNCf8olrDdCMMiwlybjRtn/uQb9tKjfcCbxlajKP
 H/4YJpJtYRPiJ/6mEQEothYZBhzkPzalbnxiSfPJShr5DuARt4oGt9vSs+EQd20p9L
 FYX3xoy2PGCq0EeSTk9YdxCHPGmuIGDXiGzoX49iLyOwtV2kUYiuUU8umij0eUGyoe
 aeVK8FsBedk0AI/ndMGhcI8X7p9G1oeUXGDuvMabdcA3REehvuWEzTNwqGF6EUe+fO
 zsc1/YSHil3yVEx6JkybkDXlSkAUmwdahoI3rKUODIYbfw0fCqSpu2C8ZwXOkHXujp
 oFqPC9aZP3CGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oeYdp-00DwbH-8I;
 Sat, 01 Oct 2022 10:18:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: arm64: Advertise new kvmarm mailing list
Date: Sat,  1 Oct 2022 10:18:34 +0100
Message-Id: <166461590369.3900755.9396637331085967058.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001091245.3900668-1-maz@kernel.org>
References: <20221001091245.3900668-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, will@kernel.org, alexandru.elisei@arm.com,
 james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 mark.rutland@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
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

On Sat, 1 Oct 2022 10:12:45 +0100, Marc Zyngier wrote:
> As announced on the kvmarm list, we're moving the mailing list over
> to kvmarm@lists.linux.dev:
> 
> <quote>
> As you probably all know, the kvmarm mailing has been hosted on
> Columbia's machines for as long as the project existed (over 13
> years). After all this time, the university has decided to retire the
> list infrastructure and asked us to find a new hosting.
> 
> [...]

Applied to kvm-arm64/misc-6.1, thanks!

[1/1] KVM: arm64: Advertise new kvmarm mailing list
      commit: ac107abef197660c9db529fe550080ad07b46a67

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
