Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED65C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 17:25:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E6FA4B1FB;
	Wed, 20 Apr 2022 13:25:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bjjYvVzFWWEW; Wed, 20 Apr 2022 13:25:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3911B4B1DB;
	Wed, 20 Apr 2022 13:25:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E4D4B091
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 13:25:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ImowsooU+z3c for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 13:25:41 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C25DE4A193
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 13:25:41 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1CE3061ACC;
 Wed, 20 Apr 2022 17:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BC6C385A1;
 Wed, 20 Apr 2022 17:25:37 +0000 (UTC)
Date: Wed, 20 Apr 2022 18:25:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 02/10] arm64: Add RV and RN fields for ESR_ELx_WFx_ISS
Message-ID: <YmBCDRHYvIfCyvAh@arm.com>
References: <20220419182755.601427-1-maz@kernel.org>
 <20220419182755.601427-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220419182755.601427-3-maz@kernel.org>
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

On Tue, Apr 19, 2022 at 07:27:47PM +0100, Marc Zyngier wrote:
> The ISS field exposed by ESR_ELx contain two additional subfields
> with FEAT_WFxT:
> 
> - RN, the register number containing the timeout
> - RV, indicating if the register number is valid
> 
> Describe these two fields according to the arch spec.
> 
> No functional change.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
