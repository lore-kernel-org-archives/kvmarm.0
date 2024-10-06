Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61B11714B3
	for <kvmarm@lists.linux.dev>; Sun,  6 Oct 2024 07:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728201598; cv=none; b=eugMHhNb8bq4W2uIcvUmdafJLrrqqOvMj2KU8+FofQa7BTe8TMcuDJykYmBk0B4i9Rn8YrlARPcfqWr6BW3V9BI2OemZBv90sw53VZ0AafLABcvENg/kOW0tCJJp9vZF4Tw3TKGyN7XXyJx6O3YfIs2ABkxz3x2hp6Tu6jNd9PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728201598; c=relaxed/simple;
	bh=VqlHx3gXbvON1CW3A1JRBpxXo8Luo3Qf9007uz5xumM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b/BIZGWm6MYhVwoD61LLayDp//U1TdqsTTOa4EWfNyMwmhEGtyp+FxauEoHll5ur1v4xQ7xxKphHN4YPD9zS2+OIyPBN4ykTT76aOdZYTQ3lHJmZ+MSoI+YrJC/qIk0OF529mA1+fK1iRm+V4zykW9ZeHYa2MTbBX7rDYq5qLuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XqsSvYq2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XqsSvYq2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728201595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/sKPRBl2RV4hr7+8R+wr2nRbBs8Om/Tz2zinJX3Ieis=;
	b=XqsSvYq2/aWbjTYRzgpoELgDMEx+aTKTFiCKDq5DIZAgp67SfONcb8NK7swEIg3qbCbm0O
	q+FQkha9e3liRdYsgvGmNL2ykLK7dCozMPGB23oIqvsCYALMYqR60wZvcv76O2yoqDijrL
	z5FhtVD6zewsE1QqxcDgxOi6kDch9zo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-LuSIp3M2M0Gi_0S3tvO6KQ-1; Sun, 06 Oct 2024 03:59:54 -0400
X-MC-Unique: LuSIp3M2M0Gi_0S3tvO6KQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37cd282fb39so2181302f8f.2
        for <kvmarm@lists.linux.dev>; Sun, 06 Oct 2024 00:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728201593; x=1728806393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/sKPRBl2RV4hr7+8R+wr2nRbBs8Om/Tz2zinJX3Ieis=;
        b=i6eNNdOsMFkJCXVW4jGJOre5OL7P5rsqdWDE52n8MtM00nAzw2eTv34qk8OCnRc/UW
         /SPfXDjdADKJdwcoJskwdyzdjkMuLMPurpdSmvdeAYNcIwiKYsEEGZ0okVk/VKQ/OXpW
         NwLKF4HGHTAnzn8rSsyiW3jgtaSeHSxlMjXzPuLezuZWavL3PkyA1jArltGaRm7OKLdw
         GdUEKvnVKZoPeGeYmuuuyUqYbKeyQjRD+twofSBCYx3O99ZSMAJ2SG1uAhew5k3FaCyt
         dttSvNG27itdL+dcllwiL8RbChiwGfrk4WEG8LVz5hJo5dq4L9HPieGoVgClm9tS7SyN
         2f6g==
X-Forwarded-Encrypted: i=1; AJvYcCU+3BvczN6dT/JQiD2lSYqpOWkrFwPFJgY0uHmAuVdg8E1vYbw0zkYXJ21BFMytw8U+q8dzv+M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/jYI9qcW/MTub8QFLDlXQ3rVm59ByOCQau/Si/X3iDdZ/4BZj
	ZCNFnD/TDsNIFy/Mz5fc9SR2DHJHf6n9VGU3wE9n2r30NKgSvebVagSVHbiR5f1b804DQlKR3bF
	nlEtxqrE26bO5sTMIAo5m+VyCKT441JBE1pezy+5Y3DON8i/k/5UUbTdTUBnC2JOT5s2QxFW9eK
	/araO1/pijcp9Ih+kymO1gTUGUVX5K
X-Received: by 2002:a05:6000:4590:b0:368:68d3:32b3 with SMTP id ffacd0b85a97d-37d0e778fd7mr4471283f8f.26.1728201592807;
        Sun, 06 Oct 2024 00:59:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0IitrfMDm0CuVeldEaxDs7MDfVljOsqopy8zQjl8XORThr1m0EK3xfHV86KNe6+eIaQLcapC0D/CpoDuFBNc=
X-Received: by 2002:a05:6000:4590:b0:368:68d3:32b3 with SMTP id
 ffacd0b85a97d-37d0e778fd7mr4471274f8f.26.1728201592462; Sun, 06 Oct 2024
 00:59:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241003203723.2062286-1-maz@kernel.org>
In-Reply-To: <20241003203723.2062286-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 6 Oct 2024 09:59:39 +0200
Message-ID: <CABgObfbP2mkkU+3kxDG_zHA2raSNG9XJhAqpfm8M59vveC9d9Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.12, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, James Morse <james.morse@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 3, 2024 at 10:37=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the first set of fixes for 6.12. We have fixes for a couple of
> pretty theoretical pKVM issues, plus a slightly more annoying fix for
> the feature detection infrastructure (details in the tag below). I
> expect to have a few more fixes in the coming weeks. Oh, and Joey is
> now an official reviewer, replacing James
>
> Please pull,
>
>         M.

Done, thanks!

Paolo

> The following changes since commit 9852d85ec9d492ebef56dc5f229416c925758e=
dc:
>
>   Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.12-1
>
> for you to fetch changes up to a1d402abf8e3ff1d821e88993fc5331784fac0da:
>
>   KVM: arm64: Fix kvm_has_feat*() handling of negative features (2024-10-=
03 19:35:27 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.12, take #1
>
> - Fix pKVM error path on init, making sure we do not change critical
>   system registers as we're about to fail
>
> - Make sure that the host's vector length is at capped by a value
>   common to all CPUs
>
> - Fix kvm_has_feat*() handling of "negative" features, as the current
>   code is pretty broken
>
> - Promote Joey to the status of official reviewer, while James steps
>   down -- hopefully only temporarly
>
> ----------------------------------------------------------------
> Marc Zyngier (2):
>       KVM: arm64: Another reviewer reshuffle
>       KVM: arm64: Fix kvm_has_feat*() handling of negative features
>
> Mark Brown (1):
>       KVM: arm64: Constrain the host to the maximum shared SVE VL with pK=
VM
>
> Vincent Donnefort (1):
>       KVM: arm64: Fix __pkvm_init_vcpu cptr_el2 error path
>
>  MAINTAINERS                             |  2 +-
>  arch/arm64/include/asm/kvm_host.h       | 25 +++++++++++++------------
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 12 +++++++-----
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          |  6 ++++--
>  5 files changed, 26 insertions(+), 21 deletions(-)
>

