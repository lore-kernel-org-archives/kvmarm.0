From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 20/33] irqchip/gic-v3-its: Add VPE domain
 infrastructure
Date: Mon, 13 Feb 2017 11:40:56 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702131138480.3619@nanos>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com> <1484648454-21216-21-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484648454-21216-21-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 17 Jan 2017, Marc Zyngier wrote:
> @@ -2266,6 +2294,8 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>  		    struct irq_domain *parent_domain)
>  {
>  	struct device_node *of_node;
> +	struct its_node *its;
> +	bool has_v4 = false;
>  
>  	its_parent = parent_domain;
>  	of_node = to_of_node(handle);
> @@ -2283,5 +2313,11 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>  	its_alloc_lpi_tables();
>  	its_lpi_init(rdists->id_bits);
>  
> +	list_for_each_entry(its, &its_nodes, entry)
> +		has_v4 |= its->is_v4;

Hmm, can you have mixed version its nodes? If not, you probably should have
some sanity check (not necessarily here). If yes, then how does that work?

Thanks,

	tglx
