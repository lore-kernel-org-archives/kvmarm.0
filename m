Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC8EC32771
	for <kvmarm@archiver.kernel.org>; Mon, 26 Sep 2022 09:59:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 182674B808;
	Mon, 26 Sep 2022 05:59:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XYFdnFJpN2OO; Mon, 26 Sep 2022 05:59:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDD344B7CF;
	Mon, 26 Sep 2022 05:59:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 274F64B77A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 05:59:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ektErnl2X3O4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 05:59:43 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23A084B6F9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 05:59:43 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DCA5260687;
 Mon, 26 Sep 2022 09:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5C5C433D6;
 Mon, 26 Sep 2022 09:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664186381;
 bh=eCpY4n3issMeWQsobrL6g/X1gThPUqDZbWkHDnM9yGg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WWi1kHDL02YJgyXGqkboRWbJozijlRJm8v/NNCTDPTM88j3XiCQ/KFA0yjVhmHuSd
 RycXEa7bXNN++Z7y4my7KUZ0v1tkcW3qRzIQ3zsedWSNkx01Kjw42BMnifyC12Byoj
 IKQ6bcC1lRWOohBI/FtCWe0VyVcsya3Zn8YQDxXTjh7lC+Kl0D2thRMwN/gjxUtl4i
 ckF2ohatoJMu24o9xiZZLFkyS9QmupjZIRHSmOHOV4jBX95pYw04kAl0tGiSxEIMyp
 XYCc2EOrLPSBRWdeHvw0vd4SQWEUrkUsergmXO8RD5CJjDt6VGrHElLxnKYQMtlp/g
 NIt4MAK7iKE5w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ocktm-00Ccj6-WB;
 Mon, 26 Sep 2022 10:59:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Remove duplicate check in
 update_affinity_collection()
Date: Mon, 26 Sep 2022 10:59:29 +0100
Message-Id: <166418635574.3586576.10515374575365980142.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923065447.323445-1-gshan@redhat.com>
References: <20220923065447.323445-1-gshan@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, gshan@redhat.com,
 linux-kernel@vger.kernel.org, eric.auger@redhat.com, oliver.upton@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, yuzhe@nfschina.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: yuzhe@nfschina.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 will@kernel.org
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

On Fri, 23 Sep 2022 14:54:47 +0800, Gavin Shan wrote:
> The ITS collection is guranteed to be !NULL when update_affinity_collection()
> is called. So we needn't check ITE's collection with NULL because the
> check has been included to the later one.
> 
> Remove the duplicate check in update_affinity_collection().

Applied to next, thanks!

[1/1] KVM: arm64: vgic: Remove duplicate check in update_affinity_collection()
      commit: 096560dd13251e351176aef54b7aee91c99920a3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
