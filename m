From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: add active register handling to GICv3
 emulation as well
Date: Tue, 5 May 2015 13:57:07 +0200
Message-ID: <20150505115707.GA19385@cbox>
References: <1429815713-13684-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D3A4F967
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2015 07:48:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3AxIbXv3egE8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2015 07:48:26 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E3F24F964
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2015 07:48:25 -0400 (EDT)
Received: by lbcga7 with SMTP id ga7so126374358lbc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2015 04:57:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1429815713-13684-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 23, 2015 at 08:01:53PM +0100, Andre Przywara wrote:
> Commit 47a98b15ba7c ("arm/arm64: KVM: support for un-queuing active
> IRQs") introduced handling of the GICD_I[SC]ACTIVER registers,
> but only for the GICv2 emulation. For the sake of completeness and
> as this is a pre-requisite for save/restore of the GICv3 distributor
> state, we should also emulate their handling in the distributor and
> redistributor frames of an emulated GICv3.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Applied to queue, thanks!
-Christoffer
