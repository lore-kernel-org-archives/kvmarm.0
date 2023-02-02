Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC287E5
	for <kvmarm@lists.linux.dev>; Thu,  2 Feb 2023 01:11:27 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: marcan@marcan.st)
	by mail.marcansoft.com (Postfix) with ESMTPSA id CEC3F42037;
	Thu,  2 Feb 2023 01:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
	t=1675299697; bh=xK/V1pigaOCJNsOoT4vSrn67GvSkebE6rsCDeQ5oCRY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dJ1uB9J0QubTv6xZs3Z6pE3W6n3xDtNd7A3e/jGzMMOKgqOvMFc0bJibyHOBdUICT
	 zmfrDbahgn5Jg0uBCzLjEdNBB8nDLYPc/UABFtg9XcT0pAfVbhd3W2REBQIZXmwsLz
	 qPApEl5RVKjqXOk53f8vqFxsqDDlBlTGJNxolw9DKyljSluLd7Zpv/+Ypj9w3pO//h
	 8ju18lUnlh/8UC+iPgUghh+T4UQjtpghO8BxAJce1JR9166ZdFgfdeeHDhr7mj2chE
	 77UeiNeYBmVUjpeKMcdMPHNgC710R4ygGC0ApKLVdaxBX/EUM11WL2r7AlM5tJb1Jr
	 lpL6TiMDytqGQ==
Message-ID: <9d40dbc2-0950-9f35-0be6-a67cd68d7817@marcan.st>
Date: Thu, 2 Feb 2023 10:01:33 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] irqchip/apple-aic: Correctly map the vgic maintenance
 interrupt
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>
References: <20230201164056.669509-1-maz@kernel.org>
From: Hector Martin <marcan@marcan.st>
In-Reply-To: <20230201164056.669509-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/02/2023 01.40, Marc Zyngier wrote:
> We currently allocate the vgic maintenance interrupt by calling into
> the low-level irqdomain code. Not only this is unnecessary, but this
> is also pretty wrong: we end-up skipping a bunch of irqdesc state
> setup
> 
> A simple "cat /proc/interrupt" shows how wrong we are, as the
> interrupt appears as "Edge" instead of "Level".
> 
> Instead, just call the standard irq_create_fwspec_mapping(), which
> is the right tool for the job. Duh.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> 
> Notes:
>     This applies to Oliver's kvm-arm64/apple-vgic-mi branch.
> 
>  drivers/irqchip/irq-apple-aic.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
> index 09fd52d91e45..76ee7c5e7b7e 100644
> --- a/drivers/irqchip/irq-apple-aic.c
> +++ b/drivers/irqchip/irq-apple-aic.c
> @@ -1201,9 +1201,7 @@ static int __init aic_of_ic_init(struct device_node *node, struct device_node *p
>  			},
>  		};
>  
> -		vgic_info.maint_irq = irq_domain_alloc_irqs(irqc->hw_domain,
> -							    1, NUMA_NO_NODE,
> -							    &mi);
> +		vgic_info.maint_irq = irq_create_fwspec_mapping(&mi);
>  		WARN_ON(!vgic_info.maint_irq);
>  	}
>  

Reviewed-by: Hector Martin <marcan@marcan.st>

- Hector
