Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778644EA378
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452459; cv=none; b=UhbNq8WN3p9xv+Seylj55zZJV6lugcU6AKoXZmUaerYSLCpZupbxYkC4/ybCxZ7GQuU9VyQIlLPVxIVglFPH+YkdMYtRrc7e/gm7VLX7R4wEvWI1WT5Q9YHiznKeqEAAAhOFpjsYViTIfbVTSE/WS/pchEcXc9mOJUGfKY0xyV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452459; c=relaxed/simple;
	bh=AkJG1cubqnvO8sxUYeb9Y8S45m7KFZON1Zp+P7kN8ZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3DHRzpbYj/RgFM3QH1dZ3mXs65WO1TFJjG6iJFBB949RXntUTi1AXr3v1PlzRVHawwgtEG9EtYwXqNBIyzrClr1a6jipAWjFjLy+jUqbzXhTUnIj0ik0SizFgDmUdyiqK9HAdCT8+XlQ3tb3eHGo3WF5chKVsQakp0k631soUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FDhaXeRU; arc=none smtp.client-ip=95.215.58.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FDhaXeRU"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=AkJG1cubqnvO8sxUYeb9Y8S45m7KFZON1Zp+P7kN8ZI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788452455; v=1; x=1789057255;
 b=FDhaXeRU50pKuP8NliSPlwEraupAgYC0+JJmeaGQxvHWYTEt2BCXvrLy5cqrP3gJgQad2kO/
 /Vh7ur63AcockLbIOJUBee9H9di++RXR3drLekKj1gBSc5kQT8et5kp2b+b+ZhBf0MDSsGkXGay
 3ptPAzuCN7+G+HfClK0Z1+KA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6ded4fdd0c969b9a;
	Thu, 03 Sep 2026 16:20:45 +0000
X-Mizu-Trace-ID: 6ded4fdd0c969b9a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so7898e87.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 09:20:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzFDegLxGiISsDR1IaHehOcGZDKYwfhuVO8krXxrcs5asTuUpVdhD+LeWO+NTyiK5tvCBIxPUo=@lists.linux.dev
X-Gm-Message-State: AFuF++ntz9VSaLC2iSq0l3nijnfF+XAz9y5CmYuQVx602nf81qmaCtMS
	4RKIaQ04ntZYiOrNLYJdgwutJLbPbFo7KVH3rN6qFEcbyGtRDDcHj784S4PUptq6CmUhG2AXh91
	AzKOBl1w7MJpi7vt0dOHlZ9Np9OAg/4nUiXQIJtOb
X-Received: by 2002:a05:6512:3b8e:b0:5b1:4fd9:ac with SMTP id
 2adb3069b0e04-5b60f98abf0mr143016e87.3.1788452444151; Thu, 03 Sep 2026
 09:20:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-3-fuad.tabba@linux.dev>
 <apgjJVg0PmS3OudU@google.com>
In-Reply-To: <apgjJVg0PmS3OudU@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 3 Sep 2026 17:20:07 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzkUqmso49_XV2pPLBDbgqOe5Xnk=2+mWuX55NB2Nospw@mail.gmail.com>
X-Gm-Features: AcwNN1UhKtG9WhVNbYyetZAICUndgBZHs9WEb955L7xRcf_KFNgwRj6BJQ8GY38
Message-ID: <CA+EHjTzkUqmso49_XV2pPLBDbgqOe5Xnk=2+mWuX55NB2Nospw@mail.gmail.com>
Subject: Re: [PATCH 02/17] KVM: arm64: Advertise the capabilities that
 protected VMs support
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Sept 2026 at 14:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Mon, Aug 31, 2026 at 05:34:06PM +0100, Fuad Tabba wrote:
> > kvm_pkvm_ext_allowed() denies every capability it does not name, so a
> > protected VM reports 0 for interfaces it implements: KVM_CHECK_EXTENSION
> > denies KVM_CAP_ONE_REG while KVM_{GET,SET}_ONE_REG stage the guest's
> > boot state.
> >
> > Allow the capabilities that work for a protected guest, the vGIC and
> > the I/O bus being host-managed, subject to the restrictions the rest of
> > this series adds.
> >
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_pkvm.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index beea00e693a0a..c4c834d55e503 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -42,6 +42,15 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
> >       case KVM_CAP_ARM_VM_IPA_SIZE:
> >       case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> >       case KVM_CAP_ARM_PTRAUTH_GENERIC:
> > +     case KVM_CAP_ONE_REG:
>
> Shouldn't we bring the VCPU_PKVM_FINALIZED restriction in kvm_arch_vcpu_ioctl()
> first before we allow SET_ONE_REG/GET_ONE_REG?

KVM_{GET,SET}_ONE_REG don't go through kvm_pkvm_ext_allowed(), so
they're as reachable before this patch as after it.

The ordering is wrong though, and there are a few more capabilities
advertised here and restricted later. I'll fix it for all of them in
v2.

Thanks,
/fuad

>
> > +     case KVM_CAP_MP_STATE:
> > +     case KVM_CAP_VCPU_EVENTS:
> > +     case KVM_CAP_VCPU_ATTRIBUTES:
> > +     case KVM_CAP_IMMEDIATE_EXIT:
> > +     case KVM_CAP_IOEVENTFD:
> > +     case KVM_CAP_IRQFD_RESAMPLE:
> > +     case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
> > +     case KVM_CAP_ARM_INJECT_SERROR_ESR:
> >               return true;
> >       case KVM_CAP_ARM_MTE:
> >               return false;
> > --
> > 2.39.5
> >
