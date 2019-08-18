Return-Path: <SRS0=LHWX=WO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871B7C3A59E
	for <kvmarm@archiver.kernel.org>; Sun, 18 Aug 2019 17:44:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 161282086C
	for <kvmarm@archiver.kernel.org>; Sun, 18 Aug 2019 17:44:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 161282086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1C104A58E;
	Sun, 18 Aug 2019 13:44:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V6aGZBIbRGzN; Sun, 18 Aug 2019 13:44:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 940A24A5B6;
	Sun, 18 Aug 2019 13:44:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C56F4A591
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Aug 2019 13:44:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lewdXQBIlw80 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Aug 2019 13:44:31 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51BB24A58E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Aug 2019 13:44:31 -0400 (EDT)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why)
 by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
 (Exim 4.80) (envelope-from <maz@kernel.org>)
 id 1hzPED-0007S9-Tg; Sun, 18 Aug 2019 19:44:30 +0200
Date: Sun, 18 Aug 2019 18:44:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Make function comments match
 function declarations
Message-ID: <20190818184427.0fc263ad@why>
In-Reply-To: <1565862982-9787-1-git-send-email-alexandru.elisei@arm.com>
References: <1565862982-9787-1-git-send-email-alexandru.elisei@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, julien.grall@arm.com, andre.przywara@arm.com,
 eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, julien.grall@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, 15 Aug 2019 10:56:22 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Since commit 503a62862e8f ("KVM: arm/arm64: vgic: Rely on the GIC driver to
> parse the firmware tables"), the vgic_v{2,3}_probe functions stopped using
> a DT node. Commit 909777324588 ("KVM: arm/arm64: vgic-new: vgic_init:
> implement kvm_vgic_hyp_init") changed the functions again, and now they
> require exactly one argument, a struct gic_kvm_info populated by the GIC
> driver. Unfortunately the comments regressed and state that a DT node is
> used instead. Change the function comments to reflect the current
> prototypes.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 7 ++++---
>  virt/kvm/arm/vgic/vgic-v3.c | 7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 96aab77d0471..27b1ddf71aa0 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -354,10 +354,11 @@ int vgic_v2_map_resources(struct kvm *kvm)
>  DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
>  
>  /**
> - * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
> - * @node:	pointer to the DT node
> + * vgic_v2_probe - probe for a VGICv2 compatible interrupt controller
> + * @info:	pointer to the GIC description
>   *
> - * Returns 0 if a GICv2 has been found, returns an error code otherwise
> + * Returns 0 if the VGICv2 has been probed successfully, returns an error code
> + * otherwise
>   */
>  int vgic_v2_probe(const struct gic_kvm_info *info)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 0c653a1e5215..4874f3266bea 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -570,10 +570,11 @@ static int __init early_gicv4_enable(char *buf)
>  early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
>  
>  /**
> - * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
> - * @node:	pointer to the DT node
> + * vgic_v3_probe - probe for a VGICv3 compatible interrupt controller
> + * @info:	pointer to the GIC description
>   *
> - * Returns 0 if a GICv3 has been found, returns an error code otherwise
> + * Returns 0 if the VGICv3 has been probed successfully, returns an error code
> + * otherwise
>   */
>  int vgic_v3_probe(const struct gic_kvm_info *info)
>  {


Queued, thanks.

	M.
-- 
Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
