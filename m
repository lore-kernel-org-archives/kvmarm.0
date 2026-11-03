Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715801;
	b=aaH1ctAw80TbYI0S1RN+zeHJxij7JQgOBG8HzGIw0hMvffhku+R0cXFydutsUPYQW0VO
	 Ynz76KiMq0y10oGIi54ygz8JMm4A/izWlhWysDPp4HUsMbxHU2ogj/MZ0uellhZ7oNC39
	 5UKOpZaZNQ+Szc/mWv4aOK5l3cwdx70E66jmToTgqfWBcL7KYcXocsgHMgvB+jIhKyFUA
	 7Y0RdXumPMbPsFN+VrWh+BVrLMpI8qrnuPacvXUs+Q1EWJKatogXpnTyyBVPW6DxbZg/3
	 4LqEz7gbzU7Vc4+ulyO0ONTR9qk4PrrOH1/3zh8Jimy2MehXkGj60361sMArOQD93gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715801;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=FH5m2ZfhAKsc7ESTr6aXIlmL3H0K88jNbIy7JznNN8U=;
	b=vOK6707cqSCUN3/Pbi/PAG0LA9lINy7IFMvlC1pBnMFJQTI5asA/J0ZfQEQlP79nWv6b
	 cgLyLCnDmdHyPrrydh86XFilpk6oMvGXiFPIkxMD/a92AaSxK4GxtVFDkb/cjJxb/5A0d
	 N7cmlsu5HnAIFWPqJSp082sJhYXquTWC5k0/bFiYb2CVrw9zArQPkFM+aw4XqNq4bLZm1
	 CTlxadHStdb3SnPqadvey5q9yFx5ikx2albkdQfSnIuVdum7vaF9hkwmq81ISi8uAJTda
	 HjobdzlEMHrFj+ZFI/tKtlHPekEOzH0zBxhH3Sq29oQ8TOmu5YOB96Bw5mEDs+wfELg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pOWH6afI;
	arc=none smtp.remote-ip=95.215.58.210
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF13606A33A
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 14:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DF13606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pOWH6afI
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=j/giMBDl/7wt+voQgZBnLNS9pFqFZnvjPU0eYzrRGeU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793715797; v=1; x=1794320597;
 b=pOWH6afITbWa4NhVIEs4UnB0YAxeliLNSzFJuGuLcw9ePzQabrddRTqi72sbNQAE188g4ac4
 v22u4Ia7MUNLpSpptjypNYKHi5IXRq2+SoGf4aoZcw0U9jHF15q6THvBCsYDJ4xgf9gO09+vGUo
 +c5/DC1X+IhFkf82htCA3UUk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5abca0999f9be0a3;
	Tue, 03 Nov 2026 14:23:17 +0000
X-Mizu-Trace-ID: 5abca0999f9be0a3
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so6178e87.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 06:23:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzIheWYBIJEmz6zme9NFQJGd+WyBa9Zq/ta7FmJR+LAoC6e+TZUZPykIMLk+b7KNmgwxsalX0E=@lists.linux.dev
X-Gm-Message-State: APuU4Z9UkLpDNn8A2VCuICkIRLnTjhzGDVz0SHngzz3AivfEssemPTNZ
	SJSb+lxYk03xQLiE0nqBQTPv54Sc6mRf52TZkzEdAy76wXxzMoi1y4eZumW/OBqojKkJaqWzL7+
	7MKsFjCIgsPicFnvh1jcZP2CW/5L+rRA+zaG5XgAG
X-Received: by 2002:a05:6512:3c8e:b0:5bf:c17c:93a0 with SMTP id
 2adb3069b0e04-5bff0579302mr159986e87.14.1793715792546; Tue, 03 Nov 2026
 06:23:12 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-11-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-11-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 14:22:36 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyX4RO2zDEhuJAu_iu8BsXkNvFBAh2i01fy0Mf=QQ+Tjw@mail.gmail.com>
X-Gm-Features: AclHuK_IkcYbSwt6PamGBhm58rJBGW9RD9jT6VqmMt5IUNnlWXOrPHQFDe_cukI
Message-ID: <CA+EHjTyX4RO2zDEhuJAu_iu8BsXkNvFBAh2i01fy0Mf=QQ+Tjw@mail.gmail.com>
Subject: Re: [PATCH v2 10/16] KVM: arm64: gic-v5: Add ITS userspace register access
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:48 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
[...]
> +static int vgic_v5_its_attr_regs_access(struct kvm_device *dev,
> +                                        struct kvm_device_attr *attr,
> +                                        u64 *reg, bool is_write)
> +{
[...]
> +        if (IS_VGIC_ADDR_UNDEF(its->vgic_v5_its_base)) {
> +                ret = -ENXIO;
> +                goto out;
> +        }

This lets userspace set CR0.ITSEN before the vgic is initialised,
while the VM ID is still VGIC_V5_VM_ID_INVAL. An MSI (KVM_SIGNAL_MSI
or an irqfd) then reaches EL2 with VM ID 0xffff, and forwarding writes
the same into the ITTE. With 16 VM ID bits and every lower ID in use,
that lands in another VM. Could enabling the ITS be rejected until the
vgic is initialised? The existing its->enabled checks then cover
injection and forwarding. (Sashiko raised this on patch 7 [1])

Thanks!
/fuad

[1] https://lore.kernel.org/all/sashiko-outbox-194102@kernel.org/
