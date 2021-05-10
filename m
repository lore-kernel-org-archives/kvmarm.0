Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6425C433ED
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 11:01:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E879B619A1
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 11:01:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E879B619A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2174B210;
	Mon, 10 May 2021 07:01:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OXy+VF8BNKGx; Mon, 10 May 2021 07:01:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4998B4B227;
	Mon, 10 May 2021 07:01:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 034274B21E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 07:01:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vk9uRzqAwcZ8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 07:01:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D41064B210
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 07:01:37 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ADDB26199C;
 Mon, 10 May 2021 11:01:36 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lg3fK-000N3U-Ho; Mon, 10 May 2021 12:01:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: alex.williamson@redhat.com, mst@redhat.com,
 Zhu Lingshan <lingshan.zhu@intel.com>, jasowang@redhat.com
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
Date: Mon, 10 May 2021 12:01:12 +0100
Message-Id: <162064445049.841205.6886190424187341445.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508071152.722425-1-lingshan.zhu@intel.com>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alex.williamson@redhat.com, mst@redhat.com,
 lingshan.zhu@intel.com, jasowang@redhat.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, cohuck@redhat.com,
 kvmarm@lists.cs.columbia.edu, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: stable@vger.kernel.org, cohuck@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Sat, 8 May 2021 15:11:52 +0800, Zhu Lingshan wrote:
> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
> 
> The reverted commit may cause VM freeze on arm64 platform.
> Because on arm64 platform, stop a consumer will suspend the VM,
> the VM will freeze without a start consumer

Applied to fixes, thanks!

[1/1] Revert "irqbypass: do not start cons/prod when failed connect"
      commit: 0b1c0157b7b0d66d2d749ec950c7f8799d4a2e0e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
