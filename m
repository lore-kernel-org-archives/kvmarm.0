Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792565295;
	b=I5KlC8EpQxbXAuOcz4HTPtbelckjypC6Whsex2WEf0tIZVFdt8g2kvG6bV5SUP5BGEc0
	 KFxZr1y4wnKzj9AYdcTV3uGM2fBWLh+2djHJJWECG5rHcM7XJ0HTIek86F5Y6rDpDs71M
	 DdBgTcwmpNKP69RIqD1LM9Nn9pM1rOlY2uwPFjKGnu7q0t3n0LSFs1bI5U7nGvYXwRWWC
	 3Fo4zAs4fvSdEA6AI+RHBFF+SFlc7JV56r4dG8QTSyKBQ70Ek5EZ3X8kguGubeZ2PTL0C
	 /b806sqc4sFTBVMBlMW/lVpCj1woaJM4mQL4JSWO8H2U1oPMGlGkGJDfO4YrFwbKjNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792565295;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=9yp/fM0ro6tHmyo8E9yuKsYQD4EKEIrb4BvBf4JN4ow=;
	b=R3UiSV0GQ8QyKtwMyNDcZqy3ZW88loOSjbqqVb3TsX0vfsmKFOQHg4z4rFYh922mzovI
	 /JV9BDhktMeWXHAl7bKwik9AKVNoPa8HBAwHv/Wk+p+UHQXGSeZYKQ8lbSNrMkmKdmhY1
	 8NJ45h8zqD4hLbpTobeDL+2o0N2YgiDHrP7UUIip2jBUzNB+jbqDGkMQHK4VZ0NjJkZa6
	 Rhr9012hy7omIHBna7FJT3n4Xr/m09r/mhoLeavY3FY8JrlK2PwTVIuNXbAbdEVlwO+kX
	 Ny+KIrp2EB+N4h6JOMFof5na+bKyuundzHiTcplqL5ochG0ip+ip23aB0dO0nmsBcSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lSOKZhts;
	arc=none smtp.remote-ip=91.218.175.170
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E25606A320
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 06:48:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26E25606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lSOKZhts
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9yp/fM0ro6tHmyo8E9yuKsYQD4EKEIrb4BvBf4JN4ow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792565290; v=1; x=1793170090;
 b=lSOKZhts4xJq1NOpRgxxh9vuKSEoP8BR1CAjN2CwHg2O7Pv7W6QX0UixMGSQGqapevTejSpp
 JKgtLw8MPwdForygcZJ5OaMcFXLI4T1fgv7hDAB3+4L8Rq46yc+ekZaaea6YCeCSuozPDZRa+OY
 j1ywYvY9gifagRvgaW2bDMsk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d08bdd93c3320eb8;
	Wed, 21 Oct 2026 06:48:10 +0000
X-Mizu-Trace-ID: d08bdd93c3320eb8
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be58ad9600so5569e87.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 23:48:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByte9ROdiaJoKVJJWSMeVWpgR2zsvfKtOZ6pNmOVu1mJxZvA8rs78Mz5Lo/DzWaTNsaFQNisNc=@lists.linux.dev
X-Gm-Message-State: AFq9FYKa5vm4cV6AJ9hn4uRc1zp9sWfjEZ2SAIM/2MgbWgsLUNLJf20K
	c1Ln/uiv517sA4+MSQ7bzjjFTiFR4C2EY4iC+Mm8PXd6E8My8Yu+YVHaJH7pyvhCJOQRi6J2IZl
	D3gDJPBqekpZw6fgZzOjeEIAWMR5M/ALWEHlfPa5+
X-Received: by 2002:ac2:568d:0:b0:5bf:a37d:dd53 with SMTP id
 2adb3069b0e04-5bfa37dde95mr9658e87.10.1792565289649; Tue, 20 Oct 2026
 23:48:09 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261020163923.1407856-1-sascha.bischoff@arm.com> <20261020163923.1407856-2-sascha.bischoff@arm.com>
In-Reply-To: <20261020163923.1407856-2-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 21 Oct 2026 07:47:33 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw_k-v7jB0NA2knArR1wtefZWkhVRgm9T4E=Co6sytEiA@mail.gmail.com>
X-Gm-Features: AclHuK9qbfaij78T_z4eQI7pVHIrgMA1rYSiJ8XdhcOIOhDcFbexzAqkSNQZiz0
Message-ID: <CA+EHjTw_k-v7jB0NA2knArR1wtefZWkhVRgm9T4E=Co6sytEiA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: arm64: vgic: Require matching VGIC and ITS models
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 Oct 2026 at 17:39, Sascha Bischoff <sascha.bischoff@arm.com> wrote:
>
> On a GICv5 host with legacy support, KVM registers both VGICv3 and
> VGICv5 devices. Without a model check, a VM can create a GICv3 ITS
> alongside an incompatible VGIC, regardless of creation order.
>
> The same problem exists for GICv2 on hosts that support a GICv3 ITS.
> KVM used to allow userspace to create both devices in either order,
> then ignored the ITS.
>
> Record the VGIC model required by an ITS. Reject an ITS if the VM
> already has an incompatible VGIC, and reject a VGIC if an existing
> ITS requires a different model. These checks apply on every host:
> a GICv2 VGIC and a GICv3 ITS now fail with -ENODEV in either order.
> Allow either creation order when the models match.
>
> Have vgic_has_its() require matching VGIC and ITS models, and drop
> the separate has_its flag.
>
> As part of this change, swap the type of vgic_model from u32 to enum
> kvm_device_type. This requires updating the switch cases in
> kvm_vgic_vcpu_init() and kvm_vgic_dist_destroy() to include default
> cases, which we mark as unreachable().
>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
