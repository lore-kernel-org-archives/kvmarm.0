From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v6 11/26] KVM: arm64: Fix HYP idmap unmap when using 52bit
 PA
Date: Fri, 16 Mar 2018 16:47:33 +0000
Message-ID: <149b8fa3-fdfc-4b3d-948d-066df5f721cd@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-12-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 244204070F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 12:40:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IzSxu8Jywjxt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Mar 2018 12:39:57 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBA00402DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 12:39:57 -0400 (EDT)
In-Reply-To: <20180314165049.30105-12-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/03/18 16:50, Marc Zyngier wrote:
> Unmapping the idmap range using 52bit PA is quite broken, as we
> don't take into account the right number of PGD entries, and rely
> on PTRS_PER_PGD. The result is that pgd_index() truncates the
> address, and we end-up in the weed.
> 
> Let's introduce a new unmap_hyp_idmap_range() that knows about this,
> together with a kvm_pgd_index() helper, which hides a bit of the
> complexity of the issue.
> 
> Fixes: 98732d1b189b ("KVM: arm/arm64: fix HYP ID map extension to 52 bits")
> Reported-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---

Looks good to me, FWIW:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
