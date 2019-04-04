From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v12 2/8] arm64: KVM: encapsulate kvm_cpu_context in
 kvm_host_data
Date: Thu, 4 Apr 2019 17:14:16 +0100
Message-ID: <20190404161416.GC27577@fuggles.cambridge.arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
 <20190328103731.27264-3-andrew.murray@arm.com>
 <20190404160954.GB27577@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9179A4A42E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 12:14:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NIosyHgUNrrY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 12:14:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B75E4A34E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 12:14:21 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404160954.GB27577@fuggles.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 05:09:58PM +0100, Will Deacon wrote:
> On Thu, Mar 28, 2019 at 10:37:25AM +0000, Andrew Murray wrote:
> > The virt/arm core allocates a kvm_cpu_context_t percpu, at present this is
> > a typedef to kvm_cpu_context and is used to store host cpu context. The
> > kvm_cpu_context structure is also used elsewhere to hold vcpu context.
> > In order to use the percpu to hold additional future host information we
> > encapsulate kvm_cpu_context in a new structure and rename the typedef and
> > percpu to match.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  8 ++++++--
> >  arch/arm64/include/asm/kvm_asm.h  |  3 ++-
> >  arch/arm64/include/asm/kvm_host.h | 16 ++++++++++------
> >  arch/arm64/kernel/asm-offsets.c   |  1 +
> >  virt/kvm/arm/arm.c                | 14 ++++++++------
> >  5 files changed, 27 insertions(+), 15 deletions(-)
> 
> As per usual, I'll need an Ack from Christoffer and/or Marc on this one :)

Actually... given that most of this series is now firmly in KVM territory,
it probably makes more sense for the kvm/arm tree to take this on a separate
branch, which I can also pull into the arm64 perf tree if I run into
conflicts on the non-kvm parts.

Will
