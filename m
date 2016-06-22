From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Increase GICV size to 64KB so !4KB page-size kernels are able to
 initialize KVM
Date: Wed, 22 Jun 2016 13:20:40 +0100
Message-ID: <576A8298.20704@arm.com>
References: <8b9c3e26-97b1-307f-8227-5ca3a4966c84@riken.jp>
 <576A630E.10800@arm.com> <57f56525-119a-8566-8d9b-43b7bcb23a49@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B3349B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 08:15:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zwgzyoVECVdu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 08:15:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD69F49B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 08:15:49 -0400 (EDT)
In-Reply-To: <57f56525-119a-8566-8d9b-43b7bcb23a49@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/06/16 12:02, Itaru Kitayama wrote:
> Hi Marc,
> 
> Thanks for your comments. I'm definitely interested in your patch set 
> that makes KVM to work with large page sizes. I'll ask the vendor to 
> update some ACPI tables. (I'm on Overdrive with recent F/W though I 
> think the GICV physical address is aligned at 4KB boundary still)

I'm only using DT, which works just fine on Overdrive, even with 64kB 
pages.

I think I understand the issue you're having, which is not what I 
was thinking of. The issue is that because ACPI doesn't tell us
anything about the size of the GICV region, we have to assume that
it is 8kB, and cannot distinguish a safe platform from an unsafe
one, failing the size test on 64kB.

Oh well.

How about this:

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index e31405e..8aac59b 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -315,12 +315,10 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 		return -ENXIO;
 	}
 
-	if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
-		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
+	if (!PAGE_ALIGNED(resource_size(&info->vcpu)))
+		kvm_warn("GICV size 0x%llx not a multiple of page size 0x%lx, system may be unsafe\n",
 			(unsigned long long)resource_size(&info->vcpu),
 			PAGE_SIZE);
-		return -ENXIO;
-	}
 
 	kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,
 						   resource_size(&info->vctrl));

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
