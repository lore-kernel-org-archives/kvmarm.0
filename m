Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795511114;
	b=Rg52p24q88EJxbeK2PNSvltro2cqqLOGLaSOqsk+K2AloYzwgBFHuLbHV0ZbcrdPzghX
	 Ldnh2Pl65/QJDm4T+C84qgWSHGMkzzq7tbHtZKnu0KVAg2C/Fv+NH/DCQuEjctlGEG5JE
	 Eld/ttWlni3l2tir4SEzF8mgZK4E9xli8NfwzsmYV2nnGOEnYlKSEgIO0OCMciwjLPB5B
	 26WW6IgiLceGBlbRJT8S/jMqI3yVmsfdxRRRaMvOgyJl3WupHJP8dmTRk5sAnAVORw572
	 hMQGr+u/lZwlXLWYAE7L2NQB0XvB2adNSXjtsAOu6fJuZ5yRgjNX7c1Iw+bU663Ku/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795511114;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=H5EGPVwUvBTVCjnjKNK0pwP1iE/nYLH8FPXSomLTbJo=;
	b=QF3vDcYu8/C0hVmW36I8dsg6m1c1aRH6smBXwFVdubOzJPDRR1l909wDAQvMM7h8jzbc
	 4x1AD737nrZVOjZ5wpz3cmMCpPn9/YNYPQ2XNDLEx0YiZC1Un3Ze6xCJQq5YNSpLpN0R5
	 4P5OSmUSciW4uKU8cPw2azmoLeDURRAwRpRcihZqm9czmgQ3MqI9h01ZwfdVCjTp5ykgw
	 b3IIk5zAlhrZKEQN8d43d+vugFBO6DGo2GSliyUYUS8gzhXjG+OBuhF7beRAE5JdqGh8B
	 r7I+x4YZWtUoBwxPzHue+5XUWjrluQPGPgu1ypruH/HhvKQuS8kFz1FIccI0gXHNXqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=apl75Etq;
	arc=none smtp.remote-ip=91.218.175.9
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C21606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 09:05:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95C21606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=apl75Etq
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xPij0k4CeHH9+SjKj41LaA/JfirxBcQilK4GNNYxiKg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795511110; v=1; x=1796115910;
 b=apl75Etqp10ydT/aa0sdMGI8lXExPLVyFcssp1zhEe4JnLwDGdyNaPiqGzlfjTSt9Mxa54S3
 r0gjm9OZEpCPnhdboiF9xzJqEmBcqS+6X8Ko37uZwfPqp89o518Ej+EaKyH/eI/oIqh5gn2DcqE
 LQYC7JUkDhksK82OaXFK+L20=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b11e06d9c6b28ddb;
	Tue, 24 Nov 2026 09:05:10 +0000
X-Mizu-Trace-ID: b11e06d9c6b28ddb
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be58ad9600so21649e87.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 01:05:08 -0800 (PST)
X-Gm-Message-State: APuU4Z8+opdszk2T6S1OXKM3QRgEs7kK/nhCzC/pQNFwRkhp9FAHOg8y
	9tLQItkEksgbvcmhYJE0ECSdRtGPo/hjZGU2po5vcynsW0CZnmbrzJoZLZtXsQuLNoRoaRvBFoe
	wW8qMP5PPwcXWflIxNk4SX8B8ExZnhdPBuBqamcVl
X-Received: by 2002:a05:6512:1282:b0:5c1:a880:e5b9 with SMTP id
 2adb3069b0e04-5c1fbb1e9acmr380099e87.7.1795511106116; Tue, 24 Nov 2026
 01:05:06 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261123192457.8700-1-maz@kernel.org> <20261123192457.8700-3-maz@kernel.org>
In-Reply-To: <20261123192457.8700-3-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 24 Nov 2026 09:05:00 +0000
X-Gmail-Original-Message-ID: <CA+EHjTyOc3K4vgMxONpCsQoE9sC7vGf2y1Fjjp0wCZuLUHx+RQ@mail.gmail.com>
X-Gm-Features: Aa3M54rju6I7eIYSuhEWlu6AZl7jQW3yTB9_OPRQWCxv1avPMlgvoBI00tGtVA0
Message-ID: <CA+EHjTyOc3K4vgMxONpCsQoE9sC7vGf2y1Fjjp0wCZuLUHx+RQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Add GIC idregs sanitisation to common framework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 23 Nov 2026 19:24:56 +0000, Marc Zyngier <maz@kernel.org> wrote:
> It takes no least than 3 ID registers to describe whether a GICv3 or
> GICv5 is supported. Define the sanitisation tables for the relevant
> fields and the set of relevant callbacks.

nit: s/no least than/no less than/

[...]
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
[...]
> +static bool feat_gicv3(struct kvm *kvm)
> +{
> +        return (irqchip_in_kernel(kvm) &&
> +                kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
> +}

nit: could this be irqchip_in_kernel(kvm) && vgic_is_v3(kvm), and
feat_gcie() use vgic_is_v5() the same way?

[...]
> +static const struct reg_bits_to_feat_map aa64pfr0_gicv3[] = {
> +        ENUM_FEAT(ID_AA64PFR0_EL1_GIC_IMP, feat_gicv3 ),
> +        ENUM_FEAT(ID_AA64PFR0_EL1_GIC_NI, NULL ),
> +};

nit: stray spaces before the closing parentheses.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
