Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AE43939A6
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787651303; cv=none; b=LRCReJ1PvsxZFcLEkD91UB3DnAHzXMWvgBWM7hAOfy7SXlUDvminf/8ZZHn4yiCKB2IrVG48jPkQaIPvPDiTXyd0b0Bh29I68QetMJ+B/q699YxLqErSZ/lsmDrJ+ruclNzU1p/6Ch1z+dx2kIbQtdbysBc8wqWMktr2KoCQRkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787651303; c=relaxed/simple;
	bh=WdTwdsXYegr+pt2vMyfS6s6LbEnxhORlW5D9ksXSlj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Inj9eohcArPlFxfDCYTejA3RumFs/CryOlRkyzirYM68sQpT8iXuUyXJ83wKGUwADx2kDY0TJYHTgEbKXuJnoSLFXdEaB79ZbtXKBaiHwlYwv+VcNRjV2ERIt+BMVKbBfPJLBZT5uUb8L7TO9isycvEyx+hvcv2LOUb1/EsB34Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rk+A6Ie2; arc=none smtp.client-ip=91.218.175.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rk+A6Ie2"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=WdTwdsXYegr+pt2vMyfS6s6LbEnxhORlW5D9ksXSlj4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787651299; v=1; x=1788256099;
 b=Rk+A6Ie2RCabAA5NDiB0YEV7HxORcAEweNOFhLO2+2g+YVC5qzurnWLjUVetaEferv41dG2h
 ycgB80FGg1kJZDQxTpVyh3/ogUnzkFP/AL2QgYQ7Pby9QIWdu3YXLxY7XYaGkC/VrL0D6lQnAs/
 cCJZYM4g6P0qey2jKrNX+/V4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f44.google.com (209.85.167.44)
	by smtp.migadu.com with ESMTPS id ac16b08109fee947;
	Tue, 25 Aug 2026 09:48:19 +0000
X-Mizu-Trace-ID: ac16b08109fee947
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b2a8173142so1343e87.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 02:48:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro87Yjo8QVROALpVnNBbsblA1gtMhrA16Yyda4pIBQ2ZSsLkvt9UhiZCOB/aqQT3jqOsKDjEAk=@lists.linux.dev
X-Gm-Message-State: AFuF++kd+0qgRN5a8b9KFEcXkek43LaUrAdv4KE67dpehes1CVNF1df+
	jOTsBuKUJ07XTL/wIqKeb6WVc712+kLXMLNkp4UCmT7Os0wZrOMRWZuDh/M3qmjaH8unSc9A21J
	oHDvNZT6vc/5ZkLoljaNMJMLQ3mzsFzXUY4YjPXmV
X-Received: by 2002:a05:6512:239c:b0:5b4:9dba:7402 with SMTP id
 2adb3069b0e04-5b49de72ba7mr66953e87.12.1787651297880; Tue, 25 Aug 2026
 02:48:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260824074245.710955-1-fuad.tabba@linux.dev> <20260824074245.710955-4-fuad.tabba@linux.dev>
 <te43gnvb2v2zlt3m5gwn2qvden5x3vp23o2qo27uif3ebdrodg@grrfqge2htia>
In-Reply-To: <te43gnvb2v2zlt3m5gwn2qvden5x3vp23o2qo27uif3ebdrodg@grrfqge2htia>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 25 Aug 2026 10:47:41 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyYkz5=BV7RfJK_uUuuRunsfSNWmNNrkJ8NdsR_i5NB2g@mail.gmail.com>
X-Gm-Features: AcwNN1XTSUsaQHSIZboYJ25QZYIL7wzGNkOJWlm0Rb0fGSGlQWens35qrUjEXIc
Message-ID: <CA+EHjTyYkz5=BV7RfJK_uUuuRunsfSNWmNNrkJ8NdsR_i5NB2g@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: vgic: Tear down what vgic_init()
 created when it fails
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Eric Auger <eauger@redhat.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Yuan,

On Tue, 25 Aug 2026 at 10:18, Yao Yuan <yaoyuan@linux.alibaba.com> wrote:
...
> > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > index 4012df6002ea6..7493fded53acc 100644
> > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > @@ -462,7 +462,7 @@ int vgic_init(struct kvm *kvm)
> >               if (vgic_supports_direct_irqs(kvm)) {
> >                       ret = vgic_v4_init(kvm);
> >                       if (ret)
>
> Hi Tabba,
>
> > -                             return ret;
> > +                             goto out_teardown;
>
> The vigc_v4_init already called vgic_v4_teardown() in error path,
> thus I think just free dist->spis is enough yet ?

vgic_v4_init() unwinds its own state on every error return, so
vgic_v4_teardown() is a no-op there and freeing the SPI array would be
enough. I'll fold the label split in if I respin.

Thanks for the reviews!
/fuad

>
> >               }
> >       } else {
> >               ret = vgic_v5_init(kvm);
> > @@ -475,12 +475,19 @@ int vgic_init(struct kvm *kvm)
> >
> >       ret = kvm_vgic_setup_default_irq_routing(kvm);
> >       if (ret)
> > -             return ret;
> > +             goto out_teardown;
> >
> >       vgic_debug_init(kvm);
> >       dist->initialized = true;
> >
> >       return 0;
> > +
> > +out_teardown:
> > +     vgic_v4_teardown(kvm);
> > +     kfree(dist->spis);
> > +     dist->spis = NULL;
> > +
> > +     return ret;
> >  }
> >
> >  static void kvm_vgic_dist_destroy(struct kvm *kvm)
> > --
> > 2.39.5
> >
