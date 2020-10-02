Return-Path: <SRS0=jAo2=DJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85E8C4727F
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 08:20:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E9DE2072E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Oct 2020 08:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+DPBeGH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E9DE2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10BDE4B4DC;
	Fri,  2 Oct 2020 04:20:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pj1-xaVc2bPA; Fri,  2 Oct 2020 04:20:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D31544B5FE;
	Fri,  2 Oct 2020 04:20:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C7164B4DC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 04:20:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oap0TCGnRJjy for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2020 04:20:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B63FB4B5E3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2020 04:20:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A8A8D207F7;
 Fri,  2 Oct 2020 08:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601626813;
 bh=nNjOEAmXenV7kByqYczREIpR5MzajAytxxtfDgky/b0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Q+DPBeGHoTMPbUfdsfcn7j4RvdBEomDvKcjosTJ+vKLcyQhu7cOr4fDs13Xb3twX0
 ef8G6rIVcTBjwe9ZbdeTRiZGSbtCUVZHFoxMPS70c6oDW7oIcZPew1JqlQEy/h/0cs
 adHpIMHvPuanQP0MBym48WngG9cb+s868hTpj8LM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kOGIW-00GeG7-2n; Fri, 02 Oct 2020 09:20:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, David Brazdil <dbrazdil@google.com>,
 Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Pass level hint to TLBI during stage-2
 permission fault
Date: Fri,  2 Oct 2020 09:20:01 +0100
Message-Id: <160162675379.1930042.14641926420921373250.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930131801.16889-1-will@kernel.org>
References: <20200930131801.16889-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, dbrazdil@google.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, dennis@kernel.org, catalin.marinas@arm.com,
 tj@kernel.org, kernel-team@android.com, cl@linux.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

On Wed, 30 Sep 2020 14:18:01 +0100, Will Deacon wrote:
> Alex pointed out that we don't pass a level hint to the TLBI instruction
> when handling a stage-2 permission fault, even though the walker does
> at some point have the level information in its hands.
> 
> Rework stage2_update_leaf_attrs() so that it can optionally return the
> level of the updated pte to its caller, which can in turn be used to
> provide the correct TLBI level hint.

Applied to next, thanks!

[1/1] KVM: arm64: Pass level hint to TLBI during stage-2 permission fault
      commit: b259d137e91d80bf92eac453ffab179eb7941ede

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
