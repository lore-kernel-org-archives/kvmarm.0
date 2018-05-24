From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 2/4] arm64: KVM: Avoid marking pages as XN in Stage-2 if
 CTR_EL0.DIC is set
Date: Thu, 24 May 2018 16:52:39 +0100
Message-ID: <20180524155239.htgvfp2xjwztshvh@armageddon.cambridge.arm.com>
References: <20180517103548.5622-1-marc.zyngier@arm.com>
 <20180517103548.5622-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D37464A0C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 11:42:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XZPUv8oGz+CL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 May 2018 11:42:01 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A498A4A0D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 May 2018 11:42:01 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180517103548.5622-3-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 17, 2018 at 11:35:46AM +0100, Marc Zyngier wrote:
> On systems where CTR_EL0.DIC is set, we don't need to perform
> icache invalidation to guarantee that we'll fetch the right
> instruction stream.
> 
> This also means that taking a permission fault to invalidate the
> icache is an unnecessary overhead.
> 
> On such systems, we can safely leave the page as being executable.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
