Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9A5C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:55:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF6E724199
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:55:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJc+yO30"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF6E724199
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CD854B559;
	Tue, 17 Nov 2020 13:55:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XxmYWMkkqJIr; Tue, 17 Nov 2020 13:55:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 394614B78C;
	Tue, 17 Nov 2020 13:55:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4F84B787
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:55:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Id-L3bl4K9fn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:55:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 621CB4B559
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:55:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 158B224181;
 Tue, 17 Nov 2020 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605639309;
 bh=Y038uP7ZmK0OgVTrSPxcTbp4HJmlOnmzfn1DGhUpwzY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gJc+yO30XfLbM5fHLoIjw2WFot+3s9M7MQwMQX4e8ZXlGvcevLiPtBnK6ROzAYe6T
 vuhsgzTSamnbCG5jRvECoiUvMziSPV1N7aBYKRVRE7MxnfFsqHbmPzHI4N/yCFNeiZ
 BMq7xIHyCl2MbnVIc7DRm6opaL2oGtsKELm/Bz4g=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kf68A-00BSb2-Rv; Tue, 17 Nov 2020 18:55:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Drop the reporting of
 GICR_TYPER.Last for userspace
Date: Tue, 17 Nov 2020 18:55:01 +0000
Message-Id: <160563920752.4179306.18040812749709622838.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117151629.1738-1-yuzenghui@huawei.com>
References: <20201117151629.1738-1-yuzenghui@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

On Tue, 17 Nov 2020 23:16:29 +0800, Zenghui Yu wrote:
> It was recently reported that if GICR_TYPER is accessed before the RD base
> address is set, we'll suffer from the unset @rdreg dereferencing. Oops...
> 
> 	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
> 			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;
> 
> It's "expected" that users will access registers in the redistributor if
> the RD has been properly configured (e.g., the RD base address is set). But
> it hasn't yet been covered by the existing documentation.
> 
> [...]

Applied to kvm-arm64/fixes-5.10, thanks!

[1/1] KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace
      commit: 23bde34771f1ea92fb5e6682c0d8c04304d34b3b

I have added a Cc stable, as this definitely wants to be backported.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
