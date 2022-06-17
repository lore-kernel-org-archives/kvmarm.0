Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970ECC43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 08:21:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A80E4B1D3;
	Fri, 17 Jun 2022 04:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3ari1gazv8CG; Fri, 17 Jun 2022 04:21:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A0E412AF;
	Fri, 17 Jun 2022 04:21:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4108F412AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 04:21:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AumbMrDWae5X for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 04:21:16 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3936C411BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 04:21:16 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D93A9B827CA;
 Fri, 17 Jun 2022 08:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847C9C3411B;
 Fri, 17 Jun 2022 08:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655454073;
 bh=W2Ginzv0iaA6XSuuFMDWgNtEDCY4cfJBuvI+BxE8JME=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=t4+zHCvGZjfjXcYFtoD9CeeZln8e39/Qx/aPuTg8H9kW+eXrylGP8+xVKeu9uZpTl
 XTlSTYddmtf9DGCqqHg7x2W//pCgOvCeSeJFX57H+Q2BFBoAlZuMWm8R07pdrNwzqx
 I0sFdPyPZlR9j/50EK8WMfA+RXuH1rkmdJGjVSgFv6ZBTtyrB1MyNankaJiDep6WfW
 Z5j93PRNVfq8DgcePG7T1EFA5ZjglC9k8D7n2xzQAf4xky6tnHd3QBF9EtaxPiyQ1U
 mKmjqSu+57Cz5z04ax7aYjGBNxSguOFJ4JfM2e2lcEyiKBeBE6GSSWVMS7hThUKUGe
 YhXHnY2JrP00Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o27E7-001F60-8g;
 Fri, 17 Jun 2022 09:21:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: arm64: Add Oliver as a reviewer
Date: Fri, 17 Jun 2022 09:21:08 +0100
Message-Id: <165545405829.771018.16969597411109895074.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220616085318.1303657-1-maz@kernel.org>
References: <20220616085318.1303657-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com,
 kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

On Thu, 16 Jun 2022 09:53:18 +0100, Marc Zyngier wrote:
> Oliver Upton has agreed to help with reviewing the KVM/arm64
> patches, and has been doing so for a while now, so adding him
> as to the reviewer list.
> 
> Note that Oliver is using a different email address for this
> purpose, rather than the one his been using for his other
> contributions.

Applied to fixes, thanks!

[1/1] KVM: arm64: Add Oliver as a reviewer
      commit: 8507e0b6edb3ac24cdf86f7cfba74eaeee00bf27

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
