Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.214
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719846;
	b=f17cL5aXRQqnmwjv2D2MIPVVwldshNTHqk3D4GpcWwZgNL5x0dqqfisWQ5ZAznMNdhn9
	 ZffuktdH3GC06MRwjPwraExt050hM1B0voCYmo6tfrBBMK6iauqcToL2k5r1k/7VMuMJC
	 NfdsoJWyVSmluotPhyjR9Lab1IQ31o2XAXhHP2eBlitklpqvzCRk03MaMxgVynm534RC7
	 l/Acm5UejTEiAv4gdjJ/AIzyQLX7ZxQHuiFehBCdk5+73R9VtDk31On01o/1DeN/0tJzI
	 1g+CfU9BDrZRA6T88lypOD094+6Z9EIhNbGyUhwPmkihEnNxgLFc9jKMUHk1OcpGEgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719846;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=mKi3O//OzPap2qJSKCtACJ6xNlL1ssTyPNh7bncYyUk=;
	b=Ia9efh+2mHWY58kspdNfM4oiT1RY7Fruqt+6pySbGgpIztGBxXorBm5dpPAFSx8+e/mV
	 6BgSTSrf+t15f3agN0fTyVdWVyLtqVHWcoIRMnZfXHykIDWqnYg1BaW3rKSD6RN7p+bYc
	 1uJlv7aVHKcpOlfs1zH6XUvsmCNYg3NyAhOYQdkj6x/HrZ0u/E2kiYNBnsT07P3/fxUtY
	 kk9p/9sWawtQJ3VC9yV4LelxsNTq//mSQ0MBkFe9ISbURqbDeOzzMH2W1s8B2quZiKruJ
	 IgQigYPq7/vIau6OAlEDz6kUYYakvDvi1RUSdlMlpLZiOcWnzr9DxsXBPFYrG3GFzDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r3iq+TXE;
	arc=none smtp.remote-ip=95.215.58.214
Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D64A606A329
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 15:30:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D64A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r3iq+TXE
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=2XHYumNn2qzjFjAML4bIuMLwua0bYDCp7CLVmp4P2a4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793719843; v=1; x=1794324643;
 b=r3iq+TXEdUlh+W3jGLVi9GIS0m6+cTGV+UPHeR4PKBm3WYQYL/8oP+FcNsZGMhGgUGSNhCff
 QsZjYsDuhJM2Igfl6kQ8ntuNKPRPBB7KKxvbxZAwEHczKOa72gP7kr+AOnB/LJ/Bo25ITO1guPN
 AY8hgulr09jRRtNi2tKgZtD4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1f2d55a513898dca;
	Tue, 03 Nov 2026 15:30:32 +0000
X-Mizu-Trace-ID: 1f2d55a513898dca
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so6274e87.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 07:30:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByUECYXCXuC+cWvu2OunnH99Sf7rVu1Jo6p/ZDjdX51I4whZ2jZmt6r6TjOpcqWx/LS3qnX4ZM=@lists.linux.dev
X-Gm-Message-State: APuU4Z/HY2vAwedetELL0S9b/P3z02W5cJLhI5Rtx82HKzEmP1bllK1x
	WtdTDl1VuS6lNlitQiFPLpNHYDeBxMiMLreRAz21eYKbkvPmAOmT+dRWaeJCgDbyZAsDslQsB2L
	xxZM3XnAUK5378XalvdFjS0GSMT0vFXy/egFtpWc7
X-Received: by 2002:a05:6512:104b:b0:5bf:c2cc:a8f4 with SMTP id
 2adb3069b0e04-5bff0b1468emr151055e87.6.1793719829566; Tue, 03 Nov 2026
 07:30:29 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-14-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-14-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 15:29:53 +0000
X-Gmail-Original-Message-ID: <CA+EHjTw9n9vny=xG3RU33_3XP-UisKHwgrHaz1SmCV_i=B=uuQ@mail.gmail.com>
X-Gm-Features: AclHuK_CbE3T3Cke74gwoLWvxyXr7v0yWEbhu6tfs8tvoXymXeXiqoWMI-TF6nY
Message-ID: <CA+EHjTw9n9vny=xG3RU33_3XP-UisKHwgrHaz1SmCV_i=B=uuQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/16] KVM: arm64: gic-v5: Implement irq forwarding
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:51 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
[...]
> @@ -1152,7 +1154,13 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
>          if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
>                  return false;
>
> -        return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> +        if (kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm))
> +                return true;
> +        if (kvm_vgic_global_state.type == VGIC_V5 && vgic_has_its(kvm) &&
> +            dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)
> +                return true;

No GICv5 VM gets here, since every caller diverts v5 first. Could this
hunk, and patch 12, go? (Sashiko [1])

[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
[...]
> +int kvm_vgic_v5_set_forwarding(struct kvm *kvm, int virq,
> +                               struct kvm_kernel_irq_routing_entry *irq_entry)
[...]
> +        ret = gicv5_its_enable_direct_injection(virq, vgic_v5_vm_id(kvm),
> +                                                vgic_v5_get_hwirq_id(irq->intid));

Before init this writes VM ID 0xffff into the ITTE. See my reply to patch 10.

[...]
> +                /* Keep the host IRQ association so a later unforward can retry. */
> +                ret = 0;

If the retry never succeeds, teardown still frees the VM ID while the
ITS may hold the cached ITTE. Could it keep the ID, as it does when
its own teardown fails? Only misbehaving hardware gets here (also
Sashiko).

[...]
> +                } else {
> +                        ret = -EBUSY;
> +                }

This is unreachable, as is the WARN_ON_ONCE() below (the only caller
holds irqbypass's mutex, and irq->hw was checked above). Could both
go?

Thanks!
/fuad

[1] https://lore.kernel.org/all/sashiko-outbox-194187@kernel.org/
