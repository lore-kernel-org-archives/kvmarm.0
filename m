Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714093;
	b=UvTtcSgc7oggWZikRb88XQ6IzNw9bQAVy8hcXFOY5Ni+kbaQEfLnym/CgX06K9ju03B4
	 2yJdVwAYsO7XNWM0htUe+CVKCL31uQEZXVbwHPxvFPv/Z+vC1J3ZIE/ySNWkyeN0NKJQy
	 X6lPNNuIU5ZShkeBNivhONMvkxu/Tr3vGF0ikg5ItUsUI9TIEiItm1B8J98ZrWY4RIq8t
	 W1CCFE9ZPSgaK9uklOMYtshJimwMTcRZbDAtvi3YjSM1gf8sNHrU1bfh2aohuALfA7dvh
	 cdapZb4C7N2od0y1EBnHAqDLs40PyVfHlzWN5VqnzI1w74ddI67xBl05gK/1jS3Mw7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714093;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=txfyUbbk7S6wULCvktRyIt/cKzs3N8dY80CwO9mVhmQ=;
	b=g97L60gUOiJiBCTUpkg1hUQsryNxaeHisTvLzPSYBahCP5vld9sFYwe+Td4PSJqGyOow
	 f5w1TefXWEc5JGxDbJgmWgWUUPSKui0BCN2U8gCq0CTrC6BMZdt10ExSjuaAVEZ/RJTf3
	 7JdsClEiy8mXcJ+7L1hcxqzvEDwnelVLbZAO7aCTULrx3Nh8dU2RHz7SM55cXqrggBqp7
	 P4RJvYKpoBqi6uVlTw3YJaI7PD2eD6Pq5yP1C0kO6LePnaFEyAZyz1m7IU2QofSujqUmx
	 QczZMGmEr0LylB3vAYD/mTNuykUTDgy6E2P7+8KtShFqYo2y87TKc7QD3vzoScYsdXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NjBtaxAL;
	arc=none smtp.remote-ip=95.215.58.113
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060C1606A324
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:54:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 060C1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NjBtaxAL
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ujFyUsSp/zUZUClWo2l35wPvTBRekRlNepNILaDkzbA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793714089; v=1; x=1794318889;
 b=NjBtaxALuP3PMCk3CWim2PpEdG/3hKjL5udNlNwXkfiCNevOZ+UiDNyD0qkKV5m+tsrEKmPf
 I58Y1tFcbtbNNncHZ2xwY1Gn7+28w8MNfaqcWWAwwH3FjoQKMzHjRaSccBliCRt2s5sX8a7WIYh
 wi7XNJsKfgb6cg8Np+kQR4xk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0c53ef8c506daeb6;
	Tue, 03 Nov 2026 13:54:49 +0000
X-Mizu-Trace-ID: 0c53ef8c506daeb6
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so5060e87.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 05:54:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBy8jRoXvddAb6NYQcaNGa635pbutlvfBDKwimABd7MQlifU0Zrp9xRwarSHDn2LJ5PnLJ2wgkU=@lists.linux.dev
X-Gm-Message-State: APuU4Z8bjTp6J9Lam77MB/L17AsAvVbM6v5i55tzSq0eVDg+PVLs8rAh
	Tlnw4Oj0h0RkEeXD30gYcsbcar4TfXbgLbeaD81MDfCYXoC74smgGhWVZ08NAIg8rwA8z+1AGU3
	PgJo36xnvOLFXCu2TwKslpxZpQZatiMbwbTZbSZih
X-Received: by 2002:a05:6512:a91:b0:5bf:b7d1:6478 with SMTP id
 2adb3069b0e04-5bff0a6d4a4mr137754e87.1.1793714088498; Tue, 03 Nov 2026
 05:54:48 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-9-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-9-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 13:54:12 +0000
X-Gmail-Original-Message-ID: <CA+EHjTz8A5FQwwFdaf6+w=hs2pEEp+HkaGrLLJnjOzV+sq+Sjg@mail.gmail.com>
X-Gm-Features: AclHuK-wIMoHSmRAGSQfIwrf9SSkWPIjCKlZxQFL7L_HnSVtO2Gkt-bZrl0MzVc
Message-ID: <CA+EHjTz8A5FQwwFdaf6+w=hs2pEEp+HkaGrLLJnjOzV+sq+Sjg@mail.gmail.com>
Subject: Re: [PATCH v2 08/16] KVM: arm64: gic-v5: Add ITS translation cache maintenance
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 02 Nov 2026 19:44:46 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
[...]
> +static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its *its,
[...]
> +        old = xa_store(&its->translation_cache, key, entry,
> +                       GFP_KERNEL_ACCOUNT);

nit: fits on one line.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks!
/fuad
