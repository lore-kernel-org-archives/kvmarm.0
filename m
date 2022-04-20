Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCD1C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 17:24:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FFD40B85;
	Wed, 20 Apr 2022 13:24:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0nPLyY-q8DDX; Wed, 20 Apr 2022 13:24:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7CE940B7D;
	Wed, 20 Apr 2022 13:24:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD32C408AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 13:24:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wsnPq2qgOiC1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 13:24:39 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCA4E4038C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 13:24:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 7D306B81E61;
 Wed, 20 Apr 2022 17:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399F0C385A1;
 Wed, 20 Apr 2022 17:24:35 +0000 (UTC)
Date: Wed, 20 Apr 2022 18:24:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 00/10] arm64: Add initial support for FEAT_WFxT
Message-ID: <YmBBz8yKPAWSHAJo@arm.com>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Apr 19, 2022 at 07:27:45PM +0100, Marc Zyngier wrote:
> A potential addition to this series would be to remove the event
> generation from the counters, and rely on the timeout where it
> matters (spinlocks?). Feedback welcome.

I think we still need to keep the event generation around, at least for
hardware bugs we don't know about. I don't think user-space rely on it
though, people tend to come up with weird delays like isb ;). But yes,
the WFET should be handy when it turns up in hardware.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
