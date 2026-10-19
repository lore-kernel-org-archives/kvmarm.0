Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792423996;
	b=LDeOcGSe/47Oz3yPCnMmrLrELD/uLAfv6mKB6ZmD3OZp7TB6Slmvu/GMIBMABzXLWmHy
	 r+uO8T2ayc+NlcOzqTPhtZEEeasFTfZsr8N2SktDm/mcqHCv6QiNyem7XDiWta1B4OA9q
	 lQy6aBTOy0op7AOj0SNFF5CimLhHxSsl0hK4kJKzJ1MKFNHiDKVcyaGfREURAdiM+GWgZ
	 VaHOkYEKrbmZr6TChRWCJuqmddcOA9r6o4QzmJ250Dg7MB07Sirz2lNw04ALLPdARwgjh
	 jwqV3XBMyT7eW8rVXnGRe+ZwlG5m74p1KCoycw84YQvh6ODzFClhp+yY39+4nUqJusQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792423996;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=chgIyerIQUJ4MpBdj3CzM7sYFHniQ/ji6TFUETNF7sE=;
	b=DPToNzoXfMzup0MkaPjAB5p7xPIr+XS3pl/Ec048pzF+Q1JWjKj5BL19hHPzaNQ+Ewqt
	 bp/FKGthn6mtTKsY1hS1YcL6KMmAAXcuHjSWEVzo+uc9OOTmfNIFOL+Qz8cfv2JiCnUWW
	 l6jM2RnXSndl7c0WrR3Y13encUG/T7vHAiEZBlLp6hLMRxSCq0rtdy0WTXHDZlOYosLYo
	 j/DcifZgzZC7IMGtwMXDl+ToTJO3Cury3VWJg55YPjzgF2K+gp1jI+guA30wlX4WkpRC5
	 gl39r9NYcpBHCr0atL3cA8a29ifG/nD3StX6grwqOzh2aeeKwf+aeozd2dyEca8r1Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.159
Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F4B606DA40
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 15:33:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96F4B606DA40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1U6BfBwCfq4V3+m41gJdoq8QfWpdRN+npCvu9W+LDfU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792423993; v=1; x=1793028793;
 b=svVTYL0pjKviouwiIIP+l7qHVYVj/FFogeH0yBEib8oL6abN8wMYAF1SRzKk8QVea0AxvYbE
 sNy/F5LUaVPajeN0S6fiWVKe+Zp31jZsl5leaBiAivR3j6qK6WkNOCytCrXqWKD53NwlFx+iK9C
 mvEM0SCUnfYN6vmu9qrgtm5Y=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9d9e8eefb7ec3d4b;
	Mon, 19 Oct 2026 15:33:13 +0000
X-Mizu-Trace-ID: 9d9e8eefb7ec3d4b
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5be58ad9600so7330e87.0
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 08:33:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwY6LDKJhG8DVVIuLpDoZGpNM9pG/ChU+0JqvTBQ8OEiYw/RbvMOsSHnyptk0X0VYqCDRGFLIU=@lists.linux.dev
X-Gm-Message-State: AFq9FYJwH04eY+TYyEQnRMZwKy0mPNRjIXBhY/KHWCcrgOb1pDNgItaW
	3SdJ7A6Fu35euGC87I6NTlNCcOexKXO2chEP4jv4yM9WC9SRe5oKulqDzwvvYUCKnwnAX+crMVb
	5tVKBkNjayhMZRWpGe2UIghVziSeel453CqGYNBsL
X-Received: by 2002:a05:6512:3096:b0:5b7:6707:e44c with SMTP id
 2adb3069b0e04-5be51d36f63mr209729e87.12.1792423991379; Mon, 19 Oct 2026
 08:33:11 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261019134242.1289002-1-sascha.bischoff@arm.com> <20261019134242.1289002-2-sascha.bischoff@arm.com>
In-Reply-To: <20261019134242.1289002-2-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 19 Oct 2026 16:32:34 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzqKiWr2tnV0rUiA4VVCs5a0E2XQQTdwvH0bTKZ5dxe5A@mail.gmail.com>
X-Gm-Features: AclHuK9YsVMfbpulg4gsG40qG2ygFeEoSjoGnDJEH8FVka3Piy823C8uPTVEmEs
Message-ID: <CA+EHjTzqKiWr2tnV0rUiA4VVCs5a0E2XQQTdwvH0bTKZ5dxe5A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: vgic: Require matching VGIC model for
 GICv3 ITS
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi Sascha,

On Mon, 19 Oct 2026 14:42:41 +0100, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
> On a GICv5 host with legacy support, KVM registers both VGICv3 and
> VGICv5 devices. Without a model check, a VM can create a GICv3 ITS
> alongside an incompatible VGIC, regardless of creation order.

Could you add to the commit message that the new checks apply on every
host? A GICv2 VGIC and an ITS, in either order, now fail with -ENODEV,
where before both were created and the ITS was ignored.

[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
[...]
> @@ -42,10 +42,7 @@ bool vgic_has_its(struct kvm *kvm)
>  {
>          struct vgic_dist *dist = &kvm->arch.vgic;
>
> -        if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> -                return false;
> -
> -        return dist->has_its;
> +        return !!dist->its_model;
>  }

I think this should check vgic_model as well, as Sashiko raised [1].
vgic_its_create() accepts an ITS when there's no in-kernel VGIC, and
the VM can then run with a userspace irqchip. On a GICv4.0 host,
kvm_vgic_flush_hwstate() then calls vgic_v4_commit() on every entry,
for a vPE that vgic_v4_init() never set up. irq_set_vcpu_affinity()
fails on irq 0 and the error is ignored, so nothing crashes, but this
patch makes that path reachable. The MSI paths Sashiko lists are fine,
since KVM_SIGNAL_MSI requires an in-kernel irqchip and irqfd an
initialised VGIC.

Something like this would keep the 0 == 0 case you pointed out for
Marc's version false:

        return dist->its_model && dist->its_model == dist->vgic_model;

Cheers,
/fuad

[1] https://lore.kernel.org/all/sashiko-outbox-177254@kernel.org/
