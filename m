From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] arm64: KVM: Fix outdated comment about VTCR_EL2.PS
Date: Mon, 2 Mar 2015 10:52:24 -0800
Message-ID: <20150302185224.GF10137@lvm>
References: <1424883340-29940-1-git-send-email-marc.zyngier@arm.com>
 <1424883340-29940-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E95EC4775C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 13:46:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bfr86xBT+c6w for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 13:46:40 -0500 (EST)
Received: from mail-qa0-f45.google.com (mail-qa0-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A15F74770F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 13:46:40 -0500 (EST)
Received: by mail-qa0-f45.google.com with SMTP id j7so24372137qaq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 10:52:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1424883340-29940-4-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 25, 2015 at 04:55:40PM +0000, Marc Zyngier wrote:
> Commit 87366d8cf7b3 ("arm64: Add boot time configuration of
> Intermediate Physical Address size") removed the hardcoded setting
> of VTCR_EL2.PS to use ID_AA64MMFR0_EL1.PARange instead, but didn't
> remove the (now rather misleading) comment.
> 
> Fix the comments to match reality (at least for the next few minutes).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
