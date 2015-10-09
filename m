From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 0/6] GICv3: add 32bit compatibility
Date: Fri, 9 Oct 2015 14:15:23 +0100
Message-ID: <20151009141523.1228b63e@arm.com>
References: <1443703639-3730-1-git-send-email-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84996412AF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Oct 2015 09:13:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KBd0U4LODXdO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Oct 2015 09:13:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6666F411BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Oct 2015 09:13:28 -0400 (EDT)
In-Reply-To: <1443703639-3730-1-git-send-email-jean-philippe.brucker@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu,  1 Oct 2015 13:47:13 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> Hi,
> 
> This series adds 32bit support to the GICv3 driver. Only SGIs, PPIs and
> SPIs support is present, no ITS.
> Currently, the main targets for those patches are 32bit guests running under
> KVM. They can now use affinity routing and theoretically have a lot more than
> 8 CPUs. During my tests, I was able to use 16 virtual CPUs on an AEM model.
> 
> We don't support 32bit hosts with GICv3 at the moment. I added a patch to allow
> building a host when CONFIG_ARM_GIC_V3 enabled, as pointed out by Vladimir in
> the last series. When attempting to run such host with a device-tree that
> declares GICv3, KVM will refuse to start, and throw a -ENODEV error.
> 
> Some time has passed since last series, but I am now available full-time to act
> on reviews and comments.
> 
> Changes since v2 [2]:
> - rebased on 4.3-rc3,
> - add a sixth patch to handle build with CONFIG_KVM + CONFIG_ARM_GIC_V3.
> 
> Changes since v1 [1]:
> - fix the mistakes pointed out on the list,
> - add a patch to select ARM_GIC_V3 under ARCH_VIRT.
> 
> Cheers,
> Jean

Hi Jean-Philippe,

Looks good to me: Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

There is some conflicts with stuff I have queued already (the 64bit
SRE stuff), but I can fix that up pretty easily, assuming Christoffer
doesn't have any objection to the last patch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
