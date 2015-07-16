From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 03/13] arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
Date: Thu, 16 Jul 2015 19:04:41 +0100
Message-ID: <20150716180441.GR26390@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
 <1436372356-30410-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E66D258B3A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 13:52:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RrxdSqDAn6Ul for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jul 2015 13:52:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E8858B34
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 13:52:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1436372356-30410-4-git-send-email-marc.zyngier@arm.com>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 05:19:06PM +0100, Marc Zyngier wrote:
> Add a new ARM64_HAS_VIRT_HOST_EXTN features to indicate that the
> CPU has the ARMv8,1 VHE capability.
> 
> This will be used to trigger kernel patching in KVM.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Will Deacon <will.deacon@arm.com>

Will
