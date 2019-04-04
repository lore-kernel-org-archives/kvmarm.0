From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v12 8/8] arm64: docs: document perf event attributes
Date: Thu, 4 Apr 2019 17:21:28 +0100
Message-ID: <20190404162128.GD27577@fuggles.cambridge.arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
 <20190328103731.27264-9-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A4454A46F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 12:21:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dFKOHKHYWTpb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 12:21:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75E454A34E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 12:21:33 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190328103731.27264-9-andrew.murray@arm.com>
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

On Thu, Mar 28, 2019 at 10:37:31AM +0000, Andrew Murray wrote:
> The interaction between the exclude_{host,guest} flags,
> exclude_{user,kernel,hv} flags and presence of VHE can result in
> different exception levels being filtered by the ARMv8 PMU. As this
> can be confusing let's document how they work on arm64.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  Documentation/arm64/perf.txt | 74 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 Documentation/arm64/perf.txt
> 
> diff --git a/Documentation/arm64/perf.txt b/Documentation/arm64/perf.txt
> new file mode 100644
> index 000000000000..604446c1f720
> --- /dev/null
> +++ b/Documentation/arm64/perf.txt
> @@ -0,0 +1,74 @@
> +Perf Event Attributes
> +=====================
> +
> +Author: Andrew Murray <andrew.murray@arm.com>
> +Date: 2019-03-06
> +
> +exclude_user
> +------------
> +
> +This attribute excludes userspace.
> +
> +Userspace always runs at EL0 and thus this attribute will exclude EL0.
> +
> +
> +exclude_kernel
> +--------------
> +
> +This attribute excludes the kernel.
> +
> +The kernel runs at EL2 with VHE and EL1 without. Guest kernels always run
> +at EL1.
> +
> +This attribute will exclude EL1 and additionally EL2 on a VHE system.

I find this last sentence a bit confusing, because it can be read to imply
that if you don't set exclude_kernel and you're in a guest on a VHE system,
then you can profile EL2.

> +exclude_hv
> +----------
> +
> +This attribute excludes the hypervisor, we ignore this flag on a VHE system
> +as we consider the host kernel to be the hypervisor.

Similar comment as the above: I don't think this makes sense when you look
at things from the guest perspective.

> +On a non-VHE system we consider the hypervisor to be any code that runs at
> +EL2 which is predominantly used for guest/host transitions.
> +
> +This attribute will exclude EL2 on a non-VHE system.
> +
> +
> +exclude_host / exclude_guest
> +----------------------------
> +
> +This attribute excludes the KVM host.

But there are two attributes...

Will
