Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BA74EA37F
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452520; cv=none; b=CKtlyuBgDt/ehZOy/wtvtw240p74foDuTkUp9rfinO/FVjpwBOONpLaiXsgjaj6wmiWoBi8lcFiFStpqUptRWGwHAofnsHyIQFDFSsC3csu46oX74EuMIztg42kkM46jvG5Ea0qX1VPYy5dK5ZvBSI6jqb8wOjCiERtBT0YF1ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452520; c=relaxed/simple;
	bh=xJr95iT1de4rp73BLPNEBJLdD6DzboQPWy71+XEZa3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i9OijBeRuBCX7kKpujKcGor17sQ6YXM8BrHxVjQLknrTw3AU+EHxQOjXcYHEw0Ua3pRJoU+fD+kaoTKoh0J/t5IKdvMH75GArkMC0GN/fi9yxUFU/OE972VGjoIRuIUhtzEmgD8f4CYoiCNDn0WRpCQceerM88ldp+kE/25EJrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BgRoh4Gm; arc=none smtp.client-ip=95.215.58.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BgRoh4Gm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xJr95iT1de4rp73BLPNEBJLdD6DzboQPWy71+XEZa3o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788452516; v=1; x=1789057316;
 b=BgRoh4GmSRezKQ4npepqnzX+EKxGk6+TKKpMCdqhX4mfY5/f7Q7q34RUD95qngS9t19Hs/vy
 TLQeJvA7t+4Tjmj1metEkMu7cbVsW+166aQqtw6LqHyJaKcin9RtWyLbi18gEGdk7+TJfeaxSFj
 z5X5kgxe7b0F3Doh29+/sG/k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ad6c74f44c1ed63f;
	Thu, 03 Sep 2026 16:21:56 +0000
X-Mizu-Trace-ID: ad6c74f44c1ed63f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so8397e87.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 09:21:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzttQx8wdwjfD9pBTtyaFWdJ5b86PrU27W0xMiRaH6codwDTTMI1vEaexCFE1P/Y9AMmBlkVbk=@lists.linux.dev
X-Gm-Message-State: AFuF++lnBojsxp9/KejpbJBVmL6MORw5DOAZCV0h2ezv+UAcSX/Gk6fC
	VTIxSGqS7afQ+4pjiJPqUr+0vi+6til0JDjoPcGD+LPMKyDkg5LU5xTzXMrycoNDankNcS/0RNp
	LEUtmpd3uo0PJaFdeQCCP7oGRfvJlX6Q7bO1umq8I
X-Received: by 2002:a05:6512:1287:b0:5b6:4ad:d6b9 with SMTP id
 2adb3069b0e04-5b60ed04150mr185236e87.14.1788452514996; Thu, 03 Sep 2026
 09:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-4-fuad.tabba@linux.dev>
 <apglCDec15q8D8u-@google.com>
In-Reply-To: <apglCDec15q8D8u-@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 3 Sep 2026 17:21:18 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx8bx5th_WNm6Fu6K0pdNauiapfgvg2piB6s9YcYxdAbg@mail.gmail.com>
X-Gm-Features: AcwNN1V7oaGB2cmAzKkX0DGvp9U5Agq1xhxNIKZMajkYcTem4jsOiKJGglGRhvw
Message-ID: <CA+EHjTx8bx5th_WNm6Fu6K0pdNauiapfgvg2piB6s9YcYxdAbg@mail.gmail.com>
Subject: Re: [PATCH 03/17] KVM: arm64: Reject the PVTIME vCPU attribute for
 protected VMs
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Sept 2026 at 14:30, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Mon, Aug 31, 2026 at 05:34:07PM +0100, Fuad Tabba wrote:
> > pKVM currently does not support steal time for protected guests:
> > KVM_CAP_STEAL_TIME reports 0 for them. The host still accepts the
> > KVM_ARM_VCPU_PVTIME_CTRL attribute, whose IPA would point
> > kvm_update_stolen_time() at the guest's private memory on every vCPU
> > load. Return -EPERM for the attribute group instead.
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arch/arm64/kvm/guest.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index b01d6622b8720..23f725e2cf745 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -916,6 +916,10 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> >               ret = kvm_arm_timer_set_attr(vcpu, attr);
> >               break;
> >       case KVM_ARM_VCPU_PVTIME_CTRL:
> > +             /* Steal time is not offered to protected guests. */
> > +             if (kvm_vm_is_protected(vcpu->kvm))
> > +                     return -EPERM;
> > +
>
> nit: We have vcpu_is_protected()

Will do, and I found others in this series to fix with it.

> Also, would that make more sense to put that check in kvm_arm_pvtime_supported()?

kvm_arm_pvtime_supported() takes no vcpu, and its other caller reports
KVM_CAP_STEAL_TIME, which is already 0 for a protected VM. More
important, moving them would turn these three into -ENXIO, where
-EPERM is the right errno: steal time is implemented, it's just not
permitted for a protected VM.

Cheers,
/fuad

>
> >               ret = kvm_arm_pvtime_set_attr(vcpu, attr);
> >               break;
> >       default:
> > @@ -939,6 +943,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> >               ret = kvm_arm_timer_get_attr(vcpu, attr);
> >               break;
> >       case KVM_ARM_VCPU_PVTIME_CTRL:
> > +             if (kvm_vm_is_protected(vcpu->kvm))
> > +                     return -EPERM;
> > +
> >               ret = kvm_arm_pvtime_get_attr(vcpu, attr);
> >               break;
> >       default:
> > @@ -962,6 +969,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> >               ret = kvm_arm_timer_has_attr(vcpu, attr);
> >               break;
> >       case KVM_ARM_VCPU_PVTIME_CTRL:
> > +             if (kvm_vm_is_protected(vcpu->kvm))
> > +                     return -EPERM;
> > +
> >               ret = kvm_arm_pvtime_has_attr(vcpu, attr);
> >               break;
> >       default:
> > --
> > 2.39.5
> >
>
> --
> Vincent
