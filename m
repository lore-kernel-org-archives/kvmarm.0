Return-Path: <SRS0=jAo2=DJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3A6C47425
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 08:20:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B7EE20708
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 08:20:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="01oagkzb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B7EE20708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B77874B5FC;
	Fri,  2 Oct 2020 04:20:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a7Hnv1fejGKI; Fri,  2 Oct 2020 04:20:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 977664B5F1;
	Fri,  2 Oct 2020 04:20:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A714B5E7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 04:20:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X9vbZ7sjCk74 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2020 04:20:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A14B4B5E0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 04:20:13 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6B55420719;
 Fri,  2 Oct 2020 08:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601626812;
 bh=eCXSiU2FIhwyMUdAzE/HQoSwO9e7c1WQEH8tvyiMQns=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=01oagkzbJzHnhjV2zf9J7vsHUTejgJ/cLcBOFBC4wrj7b06/ce6VUwjqoJKa3ScTy
 1CQlS3SP/MqGvCIhyFVjDz6/4pZfMM5aJgDUKGB7Wh3oxLHAhHq2Dl0/Dxlr9uPwJx
 aAO/Wp2r1hBVGU4D0kVg+mRrSDqAuWNAtXGDeZ0Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kOGIU-00GeG7-Q0; Fri, 02 Oct 2020 09:20:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, David Brazdil <dbrazdil@google.com>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 0/6] Fix new html build warnings from next-20201001
Date: Fri,  2 Oct 2020 09:19:59 +0100
Message-Id: <160162675379.1930042.15447480570555160964.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601616399.git.mchehab+huawei@kernel.org>
References: <cover.1601616399.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, dbrazdil@google.com,
 linux-doc@vger.kernel.org, mchehab+huawei@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 dennis@kernel.org, catalin.marinas@arm.com, will@kernel.org, tj@kernel.org,
 kernel-team@android.com, cl@linux.com, pbonzini@redhat.com, kuba@kernel.org,
 netdev@vger.kernel.org, geert+renesas@glider.be, kvm@vger.kernel.org,
 linux-i2c@vger.kernel.org, andrew@lunn.ch, linux-gpio@vger.kernel.org,
 anton.ivanov@cambridgegreys.com, davem@davemloft.net,
 bgolaszewski@baylibre.com, jdike@addtoit.com, ap420073@gmail.com,
 erosca@de.adit-jv.com, richard@nod.at, drjones@redhat.com, wsa@kernel.org,
 linus.walleij@linaro.org, tglx@linutronix.de, linux-um@lists.infradead.org,
 alexandru.elisei@arm.com, sblbir@amazon.com, corbet@lwn.net,
 mathieu.poirier@linaro.org, uli+renesas@fpond.eu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andrew Lunn <andrew@lunn.ch>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, linux-i2c@vger.kernel.org,
 Christoph Lameter <cl@linux.com>, Eugeniu Rosca <erosca@de.adit-jv.com>,
 Will Deacon <will@kernel.org>, Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Geert Uytterhoeven <geert+renesas@glider.be>, Jonathan Corbet <corbet@lwn.net>,
 Richard Weinberger <richard@nod.at>,
 Bartosz Golaszewski <bgolaszewski@baylibre.com>,
 Jakub Kicinski <kuba@kernel.org>, kernel-team@android.com,
 Jeff Dike <jdike@addtoit.com>, Balbir Singh <sblbir@amazon.com>,
 linux-um@lists.infradead.org, linux-gpio@vger.kernel.org,
 Dennis Zhou <dennis@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Mathieu Poirier <mathieu.poirier@linaro.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Ulrich Hecht <uli+renesas@fpond.eu>, "David S. Miller" <davem@davemloft.net>,
 Taehee Yoo <ap420073@gmail.com>
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

On Fri, 2 Oct 2020 07:49:44 +0200, Mauro Carvalho Chehab wrote:
> There are some new warnings when building the documentation from
> yesterday's linux next. This small series fix them.
> 
> - patch 1 documents two new kernel-doc parameters on a net core file.
>   I used the commit log in order to help documenting them;
> - patch 2 fixes some tags at UMLv2 howto;
> - patches 3 and 5 add some new documents at the corresponding
>   index file.
> - patch 4 changes kernel-doc script for it to recognize typedef enums.
> 
> [...]

Applied to next, thanks!

[2/6] KVM: arm64: Fix some documentation build warnings
      commit: 030bdf3698b7c3af190dd1fe714f0545f23441d0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
