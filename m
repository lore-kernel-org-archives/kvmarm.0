From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [PATCH kvm-unit-tests v8 00/10] arm/arm64: add gic
 framework
Date: Wed, 14 Dec 2016 14:46:44 +0100
Message-ID: <20161214134644.4jm4sfv42jai732o@kamzik.brq.redhat.com>
References: <20161208175030.12269-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9028340421
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 08:45:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OaCplRlZrkbt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2016 08:45:41 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7289B4028D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 08:45:41 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161208175030.12269-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 08, 2016 at 06:50:20PM +0100, Andrew Jones wrote:
> 
> v8:
>  - Main change is rebasing to Wei's sysreg framework, which is part
>    of his PMU series, which I've applied to arm/next. That rebase
>    leads to dropping the first two patches of the v7 series, expecting
>    get_mpidr() to return u64 (with future patches), a rework of the
>    delay routines (now based on sysreg framework), and changes to all
>    sysreg asms
>  - The delay routines also got their own files: delay.[ch]
>  - Another bigger change was to now keep gic_common_ops local to
>    lib/arm/gic.c, export the functions from the gic-v[23] instead
>  - Yet another bigger change was dropping the sender and irq cmdline
>    inputs, hard coding to '1' is sufficient and much less code
>  - Other minor changes listed in individual patches   
>

OK, I'm going to go ahead and apply this to arm/next. Before making
the pull request I'll post another series that includes the 64-bit
MPIDR fix that Andre pointed out we need, and a couple other fixes,
though. Assuming nobody complains about that series, then I'll fold
those patches into arm/next too and make the pull request.

Thanks,
drew
