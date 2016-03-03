From: Julien Grall <julien.grall@arm.com>
Subject: Re: [RFC v5 03/17] iommu: introduce a reserved iova cookie
Date: Thu, 3 Mar 2016 16:26:31 +0000
Message-ID: <56D865B7.7000404@arm.com>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
 <1456856877-4817-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7701A41E71
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 11:19:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pu9GkV+T6yz6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Mar 2016 11:19:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D389D419D1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 11:19:21 -0500 (EST)
In-Reply-To: <1456856877-4817-4-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 01/03/16 18:27, Eric Auger wrote:
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 0e3b009..7b2bb94 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1072,6 +1072,7 @@ static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
>
>   	domain->ops  = bus->iommu_ops;
>   	domain->type = type;
> +	mutex_init(&domain->reserved_mutex);

For consistency, the RB-tree reserved_binding_list should be initialized 
too:

domain->reserved_binding_list = RB_ROOT;

Cheers,

-- 
Julien Grall
