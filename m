Return-Path: <SRS0=oQcH=CW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0FBC43461
	for <kvmarm@archiver.kernel.org>; Sun, 13 Sep 2020 17:05:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 829442076C
	for <kvmarm@archiver.kernel.org>; Sun, 13 Sep 2020 17:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sp5TlpQd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 829442076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CF74B352;
	Sun, 13 Sep 2020 13:05:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pf7jBmrczlim; Sun, 13 Sep 2020 13:05:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF23E4B36B;
	Sun, 13 Sep 2020 13:05:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A67914B35C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Sep 2020 13:05:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 916jPX8ck0li for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Sep 2020 13:05:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39FB54B315
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Sep 2020 13:05:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 295D120723;
 Sun, 13 Sep 2020 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600016731;
 bh=ClKUpKsdj2rQSZ3L0fqEYBYWgnov+Gpr27YAKLyRTnA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Sp5TlpQdfXNHrFyPAu/BntUl3ajcrNM5nLbpc/mA86RFuxJtRWXsG6Qf7t+wnyz/2
 c/p011rq02l6B+DKEFVJjF+l9rnyWfALPIHtYhfadr/XkBGkxIZMrP4i9mpPvaJnIF
 08OKRe3prSKtud2wGiZXg926yqZdiNXY2zoi3hFs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kHVRR-00BTQE-LS; Sun, 13 Sep 2020 18:05:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel@pengutronix.de, jason@lakedaemon.net, tglx@linutronix.de,
 s.hauer@pengutronix.de, shawnguo@kernel.org,
 Anson Huang <Anson.Huang@nxp.com>, festevam@gmail.com
Subject: Re: [PATCH V2 1/2] irqchip/imx-intmux: Use dev_err_probe() to
 simplify error handling
Date: Sun, 13 Sep 2020 18:05:16 +0100
Message-Id: <160001658182.6915.12925727924153070207.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1597126576-18383-1-git-send-email-Anson.Huang@nxp.com>
References: <1597126576-18383-1-git-send-email-Anson.Huang@nxp.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, alexandru.elisei@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel@pengutronix.de, jason@lakedaemon.net, tglx@linutronix.de,
 s.hauer@pengutronix.de, shawnguo@kernel.org, Anson.Huang@nxp.com,
 festevam@gmail.com, will@kernel.org, catalin.marinas@arm.com,
 Linux-imx@nxp.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, will@kernel.org, Linux-imx@nxp.com
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

On Tue, 11 Aug 2020 14:16:15 +0800, Anson Huang wrote:
> dev_err_probe() can reduce code size, uniform error handling and record the
> defer probe reason etc., use it to simplify the code.

Applied to irq/irqchip-next, thanks!

[1/2] irqchip/imx-intmux: Use dev_err_probe() to simplify error handling
      commit: c201f4325588a3b0109ba552a20bd4d4b1b5c6c8
[2/2] irqchip/imx-irqsteer: Use dev_err_probe() to simplify error handling
      commit: e0c45b107fc94c5a7a230b25cdbecab004ab1ed5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
