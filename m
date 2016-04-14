From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 10/17] kvm-arm: arm64: Introduce hyp page table empty
 checks
Date: Thu, 14 Apr 2016 15:45:25 +0100
Message-ID: <570FAD05.7070901@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
 <1460640065-27658-11-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABB1649BC9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 10:43:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pi7WoJAlKFfB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 10:43:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6EFD49BB3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 10:43:45 -0400 (EDT)
In-Reply-To: <1460640065-27658-11-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 14/04/16 14:20, Suzuki K Poulose wrote:
> Introduce hyp_pxx_table_empty helpers for checking whether
> a given table entry is empty. This will be used explicitly
> once we switch to explicit routines for hyp page table walk.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
