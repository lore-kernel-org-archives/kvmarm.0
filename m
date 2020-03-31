Return-Path: <SRS0=dOSa=5Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E549FC43331
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 08:07:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61FBB214D8
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 08:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpShdRnj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61FBB214D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C52CB4A3B4;
	Tue, 31 Mar 2020 04:07:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x53rYzu7n4Qm; Tue, 31 Mar 2020 04:07:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2324A4FC;
	Tue, 31 Mar 2020 04:07:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F34D4A3B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 04:07:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zrTYVhrPukHq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2020 04:07:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC7804A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 04:07:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B7D09206F6;
 Tue, 31 Mar 2020 08:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585642033;
 bh=pR3KtS9JqxSwtoxlI+XX4Uem3z/HcC5CN+Wr9J/Rekc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=UpShdRnjDu/kmIuKs89/r7lQiwaTpOxhwEmaJs7lpMZHTQnNgqbdTu6hLdxMd5cSf
 rUrj1KwPVPB8loOZlZxt13HURDwSwcZL+jZ6qisDn4NvI4BpFecTIzKjtbRk+Fp4xi
 ojOj2Y/dah/9X7NNozyrA7rzRnLRfZzniOmHE+W8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jJBvT-00H774-TH; Tue, 31 Mar 2020 09:07:12 +0100
Date: Tue, 31 Mar 2020 09:07:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Clear pending bit in guest memory
 after synchronization
Message-ID: <20200331090709.17d2087d@why>
In-Reply-To: <20200331031245.1562-1-yuzenghui@huawei.com>
References: <20200331031245.1562-1-yuzenghui@huawei.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 eric.auger@redhat.com, andre.przywara@arm.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org,
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

Hi Zenghui,

On Tue, 31 Mar 2020 11:12:45 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> When LPI support is enabled at redistributor level, VGIC will potentially
> load the correspond LPI penging table and sync it into the pending_latch.
> To avoid keeping the 'consumed' pending bits lying around in guest memory
> (though they're not used), let's clear them after synchronization.
> 
> The similar work had been done in vgic_v3_lpi_sync_pending_status().
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index d53d34a33e35..905760bfa404 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -435,6 +435,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>  
>  	for (i = 0; i < nr_irqs; i++) {
>  		int byte_offset, bit_nr;
> +		bool status;
>  
>  		byte_offset = intids[i] / BITS_PER_BYTE;
>  		bit_nr = intids[i] % BITS_PER_BYTE;
> @@ -447,22 +448,32 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>  			ret = kvm_read_guest_lock(vcpu->kvm,
>  						  pendbase + byte_offset,
>  						  &pendmask, 1);
> -			if (ret) {
> -				kfree(intids);
> -				return ret;
> -			}
> +			if (ret)
> +				goto out;
>  			last_byte_offset = byte_offset;
>  		}
>  
> +		status = pendmask & (1 << bit_nr);
> +
>  		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> -		irq->pending_latch = pendmask & (1U << bit_nr);
> +		irq->pending_latch = status;
>  		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>  		vgic_put_irq(vcpu->kvm, irq);
> +
> +		if (status) {
> +			/* clear consumed data */
> +			pendmask &= ~(1 << bit_nr);
> +			ret = kvm_write_guest_lock(vcpu->kvm,
> +						   pendbase + byte_offset,
> +						   &pendmask, 1);
> +			if (ret)
> +				goto out;
> +		}
>  	}
>  
> +out:
>  	kfree(intids);
> -
>  	return ret;
>  }
>  

I've been thinking about this, and I wonder why we don't simply clear
the whole pending table instead of carefully wiping it one bit at a
time. My reasoning is that if a LPI isn't mapped, then it cannot be made
pending the first place.

And I think there is a similar issue in vgic_v3_lpi_sync_pending_status().
Why sync something back from the pending table when the LPI wasn't
mapped yet? This seems pretty bizarre, as the GITS_TRANSLATER spec says
that the write to this register is ignored when:

"- The EventID is mapped to an Interrupt Translation Table and the
EventID is within the range specified by MAPD on page 5-107, but the
EventID is unmapped."

(with the added bonus in the form of a type: the first instance of
"EventID" here should obviously be "DeviceID").

What do you think?

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
