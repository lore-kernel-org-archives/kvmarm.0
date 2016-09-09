From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 2/8] arm64: KVM: Move GIC accessors to arch_gicv3.h
Date: Fri, 9 Sep 2016 17:32:38 +0100
Message-ID: <57D2E426.6000001@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-3-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36DA641267
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 12:24:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NiDnSEiPVO-9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2016 12:24:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 284A740FA2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 12:24:08 -0400 (EDT)
In-Reply-To: <1473350810-10857-3-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/09/16 17:06, Vladimir Murzin wrote:
> Since we are going to share vgic-v3 save/restore code with ARM keep
> arch specific accessors separately.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
