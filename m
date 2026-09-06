Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D212833A9CF
	for <kvmarm@lists.linux.dev>; Sun,  6 Sep 2026 16:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788713184; cv=none; b=ayFuuwroOf0mSi2/LRr/rhJR342D1fHXCv+Mcs7OkKhfeuUCOWtbaxUSWC9yx3mgfS+BCnt4l5j60xEq9VosR3xFzpbAgbim7OVi13smvg+WhCdgId/M4VSkGEw33WgCgac7/3tQ0Hd77yfr1//BxVu5i64DTMAUdrAKzQqSYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788713184; c=relaxed/simple;
	bh=VjfV2POx+VicV5YfJjm4exSQwpAsSb4mPjx2PR7ZFvI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sGiqFcCxcfpMccZX9KxqWGM3NxkXEmvLWI1ZDg6gMC+j3CklZ3bwkKNoORV5cIjp2p50tOFWlTBRpRBb8ypZImDMRblhKmxl4XFJm3UgElaj7k93OO8B2xikv5jnCX5syDefOfGXXpGkPopOSgTmbMkKYclCKEOCGe7aMgaMIPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vkQKVic+; arc=none smtp.client-ip=91.218.175.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vkQKVic+"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=VjfV2POx+VicV5YfJjm4exSQwpAsSb4mPjx2PR7ZFvI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788713179; v=1; x=1789317979;
 b=vkQKVic+qgvtT9ZIc/Yib+9lUs7BuvmOU1JzhUGuMQz4OJRliVzjWxQejmfxDvgkW/PJBvrj
 Fab+2jHfBa/eIgt0lTnhsIvi71J8FKaeSgeuS6JC3CvaBxFYwbo6NTwA6MKgAX2vOxbKw5gxhM8
 BxlwHR5zHKF3ar/AoX0CI/Jk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id af0033f924939652;
	Sun, 06 Sep 2026 16:46:19 +0000
X-Mizu-Trace-ID: af0033f924939652
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so3740e87.0
        for <kvmarm@lists.linux.dev>; Sun, 06 Sep 2026 09:46:15 -0700 (PDT)
X-Gm-Message-State: AFuF++kSi3/Fj/GEuzrlt/qin5Z1+p0dUqZ9w0Vs9GtKjoGnIoD2TTy+
	Z1o5mVctobwKgrnMI6u5pIqwLTWkIq0phZfeb+WGxp9mfGYJzbQvSSfn8Bi3NgNhNxXp6uRp77V
	Fo5fd9WD6kF5If3KhOzpBvVBT4Eay1uAFdb+s6qMy
X-Received: by 2002:a05:6512:3ba7:b0:5b1:571f:715f with SMTP id
 2adb3069b0e04-5b74d427ec9mr96688e87.3.1788713174435; Sun, 06 Sep 2026
 09:46:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260904174419.76057-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904174419.76057-1-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 6 Sep 2026 17:45:37 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzfG+y=1N3Jn5Pc8PpH0qmnmwQe5d0Z943n+PdEmY3wXQ@mail.gmail.com>
X-Gm-Features: AcwNN1VwvQjebM9ocVZBouSeIGG6IYkrA31W30ISXubYppwaYJQVVM9dNYgL72I
Message-ID: <CA+EHjTzfG+y=1N3Jn5Pc8PpH0qmnmwQe5d0Z943n+PdEmY3wXQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Serialise CTRL_INIT against vCPU creation
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, 
	"seiden@linux.ibm.com" <seiden@linux.ibm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Sascha,

On Fri, 4 Sept 2026 at 18:45, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> vgic_init() compares created_vcpus with online_vcpus to detect a vCPU
> being created. However, CTRL_INIT only holds config_lock, while
> admission of new vCPUs and updates to created_vcpus are protected by
> kvm->lock.
>
> A concurrent KVM_CREATE_VCPU can therefore increment created_vcpus
> after vgic_init() checks the counters, then block on config_lock before
> publishing the new vCPU. For a GICv4 VM, vgic_v4_init() consequently
> sizes its vPE array using a stale online_vcpus value, leaving no vPE
> entry for the new vCPU once its creation completes. The upcoming GICv5
> IRS support would hit the same issue when sizing its doorbell domain.
>
> Hold kvm->lock around CTRL_INIT. The existing counter check detects a
> vCPU creation already in progress, while the lock prevents a new one
> from starting until initialisation has completed.

This also brings CTRL_INIT in line with the other vgic device flows
that serialise against vCPU creation: kvm_vgic_create(), the GICv2
register uaccess path, and SAVE_PENDING_TABLES just below it all hold
kvm->lock across the config_lock section.

> Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/r/20260807124506.ED85C1F000E9@smtp.kernel.org
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Given that f00327731131 carried a stable tag, worth a Cc: stable?

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad



> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 90be99443df3b..219881915bf41 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -255,9 +255,11 @@ static int vgic_set_common_attr(struct kvm_device *dev,
>         case KVM_DEV_ARM_VGIC_GRP_CTRL: {
>                 switch (attr->attr) {
>                 case KVM_DEV_ARM_VGIC_CTRL_INIT:
> +                       mutex_lock(&dev->kvm->lock);
>                         mutex_lock(&dev->kvm->arch.config_lock);
>                         r = vgic_init(dev->kvm);
>                         mutex_unlock(&dev->kvm->arch.config_lock);
> +                       mutex_unlock(&dev->kvm->lock);
>                         return r;
>                 case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
>                         /*
> --
> 2.34.1
