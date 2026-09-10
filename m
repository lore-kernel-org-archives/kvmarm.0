Received: from mta1.migadu.com (out-108.mta1.migadu.com [95.215.58.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6F4489FC0
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 12:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044194; cv=none; b=GBNSCImvUKsBPcl42XxAkUYeNaGwWWZ9/8Bcji73ESTb2PonMa3POocbpSqRX7RX21rN2RGK8GaGCEvBwMxa8SGh6fPa3Ow4yAdgO1SSR+60ci1Pu/ZbFFLXPIyX5/iM1fFtXB/es9U+4ZF/3EbCLC/7xAmg+pTNmZM0rqpxvKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044194; c=relaxed/simple;
	bh=TLJMW+UBHyf2hULFG74qvyh3xriAmI6y3qUkZriPhlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nb5szym/rnsiRxKvMgL41hZrkSEV9PXEgt8NHHR1i7h6WxF+w8pvfp3f1UXQWlaJkH1OHya/E/XucZ3XUHt1Z/UVhSd81sz9VdD2y6eZ8NOvBfUFo87JfQfwT++QuL6Nld0OfZwQlZXm0Ba/NlyGsDNLecR7d5SXMoH6EgZEmIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mHQ0xPc1; arc=none smtp.client-ip=95.215.58.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mHQ0xPc1"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=TLJMW+UBHyf2hULFG74qvyh3xriAmI6y3qUkZriPhlo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789044187; v=1; x=1789648987;
 b=mHQ0xPc1NTl7CIjNYa5HlI/RIV7OuKliN/tOYeoPzEK3gIy/32CyWsQTmYZmDA5VFsf1Xtvv
 3tpXo2S5dSsz3Yx2TQIkR830tExig0flM5/JpAqWvPaqvZGJGuQwq7zCq25ZAY23XsdvFnsstOP
 pztJ3AjZOSDTAn5eH3Qu9exQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9380a4fca1f8ec49;
	Thu, 10 Sep 2026 12:43:07 +0000
X-Mizu-Trace-ID: 9380a4fca1f8ec49
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so5540e87.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 05:43:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwhdqdBQjvGia+JwADYcy7CRbyCPoh1WIQrH50AQWykZABHQgWuHGFT3+/Uv0NjFpHZ+Nc0HdI=@lists.linux.dev
X-Gm-Message-State: AFuF++kdKAtEa6ixUORkaLu+nfR1E3/tie3pIPdYCi+XK/p+L4NM6BRV
	qVcRdtVnXnLbpCEVj8po8r18ZO+bsInNOOgAa7BOQZutgQd7tA5mtpRzuo5OJXDvjJK+zLXvpph
	6PIti28FgXEwy/mh4Qm8aCbiUhkKbR6cOXQ5cjWMl
X-Received: by 2002:a05:6512:234c:b0:5b6:19c6:a91b with SMTP id
 2adb3069b0e04-5b89a6da833mr113965e87.14.1789044182010; Thu, 10 Sep 2026
 05:43:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-11-suzuki.poulose@arm.com> <CA+EHjTw9ReyvsNT=y+-P6ng7VQ6Pvz9PFK9bO71qvTR1pOxx5Q@mail.gmail.com>
 <6152fc41-65f0-460f-90b4-1454c11bcba6@arm.com> <CA+EHjTxjk1JLR7Tf5LEfB_xypbUWnw3G3H-FT7bTE=nWTTRgAA@mail.gmail.com>
 <d22c863b-ea81-472c-b2a9-28f99e5b6f92@arm.com>
In-Reply-To: <d22c863b-ea81-472c-b2a9-28f99e5b6f92@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 10 Sep 2026 13:42:25 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx744tg1c3vX0Ugo8YN7n-wtq9-rWdjjSP+UXi8_vvq7g@mail.gmail.com>
X-Gm-Features: AcwNN1WSfg4g-Ni2N5yRIGRNfczplTeSi9HsXmirIR-L_CctNHI6kvs4aUKgPSE
Message-ID: <CA+EHjTx744tg1c3vX0Ugo8YN7n-wtq9-rWdjjSP+UXi8_vvq7g@mail.gmail.com>
Subject: Re: [PATCH v17 10/20] KVM: arm64: coco: Disable Steal time accounting
 for coco guests
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Thu, 10 Sept 2026 at 11:28, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
...
> Just to make sure I understand the picture:
>
> For coco VMs:
>
>   - check extension on coco KVM, KVM_CAP_STEAL_TIME => 0
>
> And a follow up DEVICE_HAS_ATTR => -EPERM ?
>
> But we tell the VMM, look you don't have the capabilit on this VM.
> But if you try to set the attribute isn't it more appropriate to
> say:
>   -ENXIO - No you don't have that feature on this VM (-ENXIO)
> rather than
>   -EPERM - No, I won't let you do that.
>
> Remember we are doing only in the "VM" context. It is a minor nit
> but I wanted to make sure we understand what we are thinking.

-ENXIO it is. I went back to api.rst for KVM_SET_DEVICE_ATTR: ENXIO is
for a group or attribute that's "unknown/unsupported for this device",
and EPERM for one that "cannot (currently) be accessed this way", a
state or access-mode refusal, so a VM type that doesn't have the
feature is the former. KVM_HAS_DEVICE_ATTR only documents ENXIO at
all. Your patch is good as it is.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad



>
> Cheers
> Suzuki
>
> > it's just not permitted for a confidential VM, and -EPERM says exactly
> > that, whereas -ENXIO reads as "no such feature".
> >
> > Cheers,
> > /fuad
> >
> >>
> >>> steal-time exists but isn't permitted for a confidential VM, whereas
> >>> -ENXIO reads as "no such feature".
> >>
> >> Cheers
> >> Suzuki
> >>
> >>
> >>>
> >>> Cheers,
> >>> /fuad
> >>>
> >>>>
> >>>>    int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
> >>>> @@ -81,7 +81,7 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
> >>>>           int ret = 0;
> >>>>           int idx;
> >>>>
> >>>> -       if (!kvm_arm_pvtime_supported() ||
> >>>> +       if (!kvm_arm_pvtime_supported(kvm) ||
> >>>>               attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
> >>>>                   return -ENXIO;
> >>>>
> >>>> @@ -110,7 +110,7 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
> >>>>           u64 __user *user = (u64 __user *)attr->addr;
> >>>>           u64 ipa;
> >>>>
> >>>> -       if (!kvm_arm_pvtime_supported() ||
> >>>> +       if (!kvm_arm_pvtime_supported(vcpu->kvm) ||
> >>>>               attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
> >>>>                   return -ENXIO;
> >>>>
> >>>> @@ -126,7 +126,7 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
> >>>>    {
> >>>>           switch (attr->attr) {
> >>>>           case KVM_ARM_VCPU_PVTIME_IPA:
> >>>> -               if (kvm_arm_pvtime_supported())
> >>>> +               if (kvm_arm_pvtime_supported(vcpu->kvm))
> >>>>                           return 0;
> >>>>           }
> >>>>           return -ENXIO;
> >>>> --
> >>>> 2.43.0
> >>>>
> >>
>
