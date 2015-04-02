From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [PATCH] KVM: arm64: add gic-400 compatible
Date: Thu, 02 Apr 2015 16:47:21 +0900
Message-ID: <551CF409.1090707@linaro.org>
References: <20140908222144.4967.80301.stgit@joelaarch64.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20140908222144.4967.80301.stgit@joelaarch64.amd.com>
Sender: kvm-owner@vger.kernel.org
To: Joel Schopp <joel.schopp@amd.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Ping.
This patch was acked but has never been merged?

-Takahiro AKASHI

On 09/09/2014 07:21 AM, Joel Schopp wrote:
> Add a one liner to identify the gic-400.  It's gicv2 with optional MSI extensions.
>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Joel Schopp <joel.schopp@amd.com>
> ---
>   virt/kvm/arm/vgic.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 73eba79..e81444e 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1550,6 +1550,7 @@ static struct notifier_block vgic_cpu_nb = {
>
>   static const struct of_device_id vgic_ids[] = {
>   	{ .compatible = "arm,cortex-a15-gic", .data = vgic_v2_probe, },
> +	{ .compatible = "arm,gic-400", .data = vgic_v2_probe, },
>   	{ .compatible = "arm,gic-v3", .data = vgic_v3_probe, },
>   	{},
>   };
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
