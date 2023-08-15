Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36FE1DA43
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 22:30:49 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57320c10635so79450507b3.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 15:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692138649; x=1692743449;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gNKxKU9a0k5QwlnHGJaZtqPp9x+MfH7uASd6ddnnEGk=;
        b=N1mh0iZlQU8pl32cDnHblEsftvP+4ptCDqmlHtK9LvQ8rp8vvY5xnNHansnMhCNlf4
         2wft/kVP+IOiuuGI7F76Dxp/VGngrE9p/gcHjSZuJhgCIlyLaQIMxtsoAeBO2HYg2muU
         QTg1bBY2JiuD+HBSAr8OeSuQmC2c2vIHrTZx4r0vBPvyvC711MPVCDG381fy/47Q69LF
         bpsdHZR0fotPIe6D7l2BU6/h4ntZ++swGu8PVbrqzP8YQMYl9lJ9l+3RZSo/GqSWGI2r
         g//wP+QbgTiNuhh+PZn4/YKmCFoJM0+p/xgaZOIW6JPH4jqBZ+tkpSYF/yvRoMaU1+B7
         hYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692138649; x=1692743449;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gNKxKU9a0k5QwlnHGJaZtqPp9x+MfH7uASd6ddnnEGk=;
        b=hpOQEW1Rat1Gb+mMAPFbvaMrt9RI6qOGJKbj7ZUHYH53aJefw9nfcrqH2Tomtd0d0G
         +2GKzJ+F54gbIlf27biKSyG/TTtQFlP27hNMpAUhiBWYkJ2QfFoi5KWHrU4x8FJySXNf
         My3YtPImgW/DmA7dWR/uMH0t6dsISdQnraBQoNRSYXxtpwdpcjVttgm/RFR76adhJMMV
         Fbh/VJNQu9+IqhXB5O2RjI3vID9zh4eumB3paceHJ125/XKRGhGm2HGiajFkTb3DaxpS
         WxvMnViwwjjocb2A+vpSBGynu1QouYEvEd/hymVWAKjJkfyviAp6DFkeT+Hmg0zFRpZ3
         s3PQ==
X-Gm-Message-State: AOJu0YxbUnji5/QCmiCfzehenEJwsd5lxXSdNSf2kxsK2rjgxwNXAuMp
	z+PBWucHnksLOe267MGKH5fAMr40kTY=
X-Google-Smtp-Source: AGHT+IHjqo/FB8qF6/mUmxkmvTmKIc5leYLXNSH3BL88+7yOIuIDWfQQa40QRwmSX5edxm8UNLTBq+krgbo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b60a:0:b0:586:a689:eb69 with SMTP id
 u10-20020a81b60a000000b00586a689eb69mr194454ywh.2.1692138648813; Tue, 15 Aug
 2023 15:30:48 -0700 (PDT)
Date: Tue, 15 Aug 2023 15:30:47 -0700
In-Reply-To: <20230811045127.3308641-2-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <20230811045127.3308641-2-rananta@google.com>
Message-ID: <ZNv8l3mmC/vtqf3j@google.com>
Subject: Re: [PATCH v9 01/14] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>, 
	"Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
>=20
> Rename kvm_arch_flush_remote_tlb() and the associated macro
> __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
> __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.
>=20
> Making the name plural matches kvm_flush_remote_tlbs() and makes it more
> clear that this function can affect more than one remote TLB.
>=20
> No functional change intended.
>=20
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>
