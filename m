From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Remove unused gpa_end variable
Date: Wed, 20 Feb 2019 11:03:26 +0000
Message-ID: <20190220110326.72c4f73f@why.wild-wind.fr.eu.org>
References: <1550568141-22796-1-git-send-email-zhangshaokun@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E10F4A37D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 06:03:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mINkggLe+3Wa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Feb 2019 06:03:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7E364A319
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 06:03:32 -0500 (EST)
In-Reply-To: <1550568141-22796-1-git-send-email-zhangshaokun@hisilicon.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 19 Feb 2019 17:22:21 +0800
Shaokun Zhang <zhangshaokun@hisilicon.com> wrote:

> The 'gpa_end' local variable is never used and let's remove it.
> 
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Applied to -next.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
