Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C009379EEC
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781874993; cv=none; b=pEyb5CsfJw9BLpguK+V6xklRrozedFV259pJx+QxCE+1V+xoqILYIGkeN3w/EO+X4b5gOi0JimaIWMqCMdOvCnYLkqkaarXli7IdpdCQ7zWbEdfs0Fsuohy50U3sTX+2+18Jj/uG1bVqrYgj8VsAFgfG3xxRzByFuVr/raOA7Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781874993; c=relaxed/simple;
	bh=cSMiacCR/NhFzUMt8a+DdUg28wHFgcF9afPQjBPkbEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dazgKFfeY6L4DNL5DgXSinBbIebzaelWwwpXsrFXhi07dycjWXXRJC9vU9lknV/EIp42THNqgO/gPHOfe81gcZKpaIhJ/4yf1zgdsiw5CpOLZM5KOrSu2g/fhZwDVrFccGbqrRcw5fo6J+i6apl92Pv50YWSYbtPTLALU7y7W5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=shiJIqmd; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="shiJIqmd"
X-Forwarded-Encrypted: i=1; AFNElJ9fLlk7jrtdSaN44JWFRTiqg//CVcDqZPZc+XgiruQCsLbjxgWovD9F6PPMzqWl6TVC1EtwGkE=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781874990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JaqxoP8Y/RWga5oiHZKiDlOlv+f25+H1YxznesJ/Rxo=;
	b=shiJIqmdUR0X6w0nIz0pkTDQKoHVRrs2UaVTOilQA+sDIuVni0pCiBQJtPcRMaSr2pvaFL
	a3wtHsUYEm3x8scOV/jIilEpZWaV35QV8nGDPy3230Db6co6aA848Bw/CZoU9sGrQEJCNX
	M+c5qi9aZd/Oh7hf+9fGUPeW7aJzfN4=
X-Gm-Message-State: AOJu0YzGPYxVzqwT+6s5NwcUObmHlICQUbpo2Uq0bNjTB8xVgRtUIbzC
	Gw1GUr0jQG0adng167Yft8V+4CPkvtDzotxYd78uMMprzHkS8A70AIUOTnu40DPjx33Tou7GJDi
	Us5ieqDHE/WmpZ3I7z4IvMnDsfPhUP87ihXStt3Kv
X-Received: by 2002:a05:622a:1906:b0:516:4f62:85ea with SMTP id
 d75a77b69052e-519e8d3111amr6097501cf.21.1781874982465; Fri, 19 Jun 2026
 06:16:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619115415.5475-1-will@kernel.org> <20260619115415.5475-3-will@kernel.org>
In-Reply-To: <20260619115415.5475-3-will@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 19 Jun 2026 14:15:44 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzAX3ytCEgva5f-aAKMUDuxaz1osKK1wssKB8V6tw7a8g@mail.gmail.com>
X-Gm-Features: AVVi8CeVsNKOUeBxheL4B4SdGYXKyaTc-W3sqpBfaOc-V3opD4Rfr4v22_RNdFs
Message-ID: <CA+EHjTzAX3ytCEgva5f-aAKMUDuxaz1osKK1wssKB8V6tw7a8g@mail.gmail.com>
Subject: Re: [PATCH kvmtool 2/4] virtio: Factor out base features for modern
 virtio transports
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Fri, 19 Jun 2026 at 12:54, Will Deacon <will@kernel.org> wrote:
>
> In preparation for optionally enabling VIRTIO_F_ACCESS_PLATFORM,
> factor out the base features for modern virtio transports.
>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  include/kvm/virtio.h | 1 +
>  virtio/core.c        | 7 +++++++
>  virtio/mmio-modern.c | 2 +-
>  virtio/pci-modern.c  | 2 +-
>  4 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> index 8b7ec1b..c95183b 100644
> --- a/include/kvm/virtio.h
> +++ b/include/kvm/virtio.h
> @@ -277,5 +277,6 @@ void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
>  int virtio_vhost_set_features(int vhost_fd, u64 features);
>
>  int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
> +u64 virtio_get_modern_transport_features(void);
>
>  #endif /* KVM__VIRTIO_H */
> diff --git a/virtio/core.c b/virtio/core.c
> index 50c9ddd..8c5086d 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -353,6 +353,13 @@ bool virtio_access_config(struct kvm *kvm, struct virtio_device *vdev,
>         return true;
>  }
>
> +static u64 virtio_modern_transport_features = 1ULL << VIRTIO_F_VERSION_1;
> +
> +u64 virtio_get_modern_transport_features(void)
> +{
> +       return virtio_modern_transport_features;
> +}
> +
>  int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>                 struct virtio_ops *ops, enum virtio_trans trans,
>                 int device_id, int subsys_id, int class)
> diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
> index 6c0bb38..7787508 100644
> --- a/virtio/mmio-modern.c
> +++ b/virtio/mmio-modern.c
> @@ -11,7 +11,7 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
>                                   struct virtio_device *vdev)
>  {
>         struct virtio_mmio *vmmio = vdev->virtio;
> -       u64 features = 1ULL << VIRTIO_F_VERSION_1;
> +       u64 features = virtio_get_modern_transport_features();
>         u32 val = 0;
>
>         switch (addr) {
> diff --git a/virtio/pci-modern.c b/virtio/pci-modern.c
> index ef2f3e2..888afa5 100644
> --- a/virtio/pci-modern.c
> +++ b/virtio/pci-modern.c
> @@ -148,7 +148,7 @@ static bool virtio_pci__common_read(struct virtio_device *vdev,
>  {
>         u32 val;
>         struct virtio_pci *vpci = vdev->virtio;
> -       u64 features = 1ULL << VIRTIO_F_VERSION_1;
> +       u64 features = virtio_get_modern_transport_features();
>
>         switch (offset - VPCI_CFG_COMMON_START) {
>         case VIRTIO_PCI_COMMON_DFSELECT:
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>
