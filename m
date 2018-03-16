From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 00/26] KVM/arm64: Randomise EL2 mappings (variant 3a
 mitigation)
Date: Fri, 16 Mar 2018 17:46:45 +0000
Message-ID: <20180316174644.klbpmuhyod5qea3r@armageddon.cambridge.arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5D0F40672
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 13:39:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iacvcIIIU1hc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Mar 2018 13:39:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34E49405D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 13:39:11 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180314165049.30105-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 14, 2018 at 04:50:23PM +0000, Marc Zyngier wrote:
> Whilst KVM benefits from the kernel randomisation via KASLR, there is
> no additional randomisation when the kernel is running at EL1, as we
> directly use a fixed offset from the linear mapping. This is not
> necessarily a problem, but we could do a bit better by independently
> randomizing the HYP placement.

For the rest of the patches in this series:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Some points for a future series:

- in bpi.S, drop the __smccc_workaround_1_hvc_start/end as HVC PSCI
  conduit for hyp doesn't make much sense (could pass NULL instead to
  __install_bp_hardening_cb())

- maybe move bpi.S under arch/arm64/kvm/ if it doesn't cause other
  dependency issues in cpu_errata.c

Thanks.

-- 
Catalin
