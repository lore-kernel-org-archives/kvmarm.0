From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 20/26] arm64: KVM: Move BP hardening vectors into
 .hyp.text section
Date: Fri, 16 Mar 2018 16:24:58 +0000
Message-ID: <20180316162457.67xkrist66vtp4mv@armageddon.cambridge.arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-21-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BDC9402E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 12:17:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gpYQ+C3x7dSa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Mar 2018 12:17:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 870834028A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 12:17:24 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180314165049.30105-21-marc.zyngier@arm.com>
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

On Wed, Mar 14, 2018 at 04:50:43PM +0000, Marc Zyngier wrote:
> There is no reason why the BP hardening vectors shouldn't be part
> of the HYP text at compile time, rather than being mapped at runtime.
> 
> Also introduce a new config symbol that controls the compilation
> of bpi.S.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
