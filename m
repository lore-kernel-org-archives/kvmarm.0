Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FAC1F9A9C
	for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729534394; cv=none; b=evM6zuqaXFKjWFz/IkrB2UfIGY1nYvypnjh9hPaTcnLpxbKPpJ6Bp7eOHC2n+wRAWQhiKHJsD+HQ9zYZ3Q3LFjJWHzdKp3enyz/8Apbd4QD043doWtKqG8DUOWliy4V7hYX9ST0JxqHTlam+V5nXt/VSUTDD2rVNxzNwEbLFVK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729534394; c=relaxed/simple;
	bh=YeXYNnt8ENmKuB15YwhakNFnDdgCdBZF4Bj1D5TS0z8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AUjlCxbXSEawf+JohCk0kveNH+4iAXhPdR1OLgPbGjXCgdmpBJL45FIjy6xW3bZNfiDP1nQMGu8EMPm/vxCXeyotYxXHbPyzRyVAr4EOAVmlcRfw5IUqJTrK+adD6brzlSpNOhNZVzNFmtWx+6ISoigMYG/kJogypuJdvbvjo8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=joBsGhEb; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="joBsGhEb"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e290947f6f8so8215924276.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 11:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729534390; x=1730139190; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/aTJKIPGdXYIQ4z1/mPhLVqGYb++KmSjcoFUbuTd6EE=;
        b=joBsGhEbso4disLN0jA9bcEDtjn0o39o8CEEVEPU7YP74AP3fzYWsnUytRX2CzOdgo
         /sfEjcSnbmIS5CgRS9bR0yBpYriNbysNp/z+GbtMfFHCT1pydmyL0CGljaSmPdy0tVR6
         eR/2pMYS+pZGiVB6npeLtAxr0MlqboQz7cCiTkuKER4dLLa4DOIy6g7o3KGPNdYmj/v9
         NKNOIQ5nN5nw6zu+wI5jPlUI1z7tw/1yMu7WVwMc/ooW8q5h/qRTxZmvdlvxTTUYPSD8
         ypMwyqg+BDbadvS8C/o10BQFT9L831CN8AvUiGCwDNgygKfPu/EAvCGUPD2VMpDNhvMX
         L86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729534390; x=1730139190;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/aTJKIPGdXYIQ4z1/mPhLVqGYb++KmSjcoFUbuTd6EE=;
        b=HYzvxpN6/ln9uDAr6vaAPgrPPIMQXfBadYTzYMT9qN/H/kPuNyxBwMwJAUtRUGN4Ik
         qQzbNm1PBukybsat8oz5l0C6tfWmTMqGLcvlghnvKBOhBlFkSReKlasaE/UcdZNt1ntr
         6PS34GlDmOydjexQLBipX4WDNCdTGeiL3gRI7v9pzelTSlKhT16WPzNb+YEBBH3aQQ1q
         kIQCLHJuYcj2rfXHSxiX2UJp7cEvoaLOv5kfI9/GrDHhdo6GSPyq/lC5AwKaiZTJik0T
         3DjWYc8RzfvxW7Brz04d3dU1r4EjiK+GnqTkQFb5MzVt+I2ME600RBEq8Eu8kL102YYw
         /1GA==
X-Forwarded-Encrypted: i=1; AJvYcCXCZVV2zxwmBK/YgwM/p3kl2DV8cdM1F6IKAAcSSYQ4Hr+5ah8qP1d++Z/wXPScA8vKR6iHy2I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTBiZIxTF5jBMmY/1Pv1OZklqCZTF8k9ld8mc7xOsseyMHjxk+
	bSVQnB+d2M3llg8YGhPStBZGXz1fA3bVISprS8p3y/6AkNP4TRCxGe3KmKeGf1nkuIeBdFt7lxt
	jOA==
X-Google-Smtp-Source: AGHT+IGB051RPG0qZ1hHpRMmy9gqDX/0GH7so+xa+rGGnhbzxuPrj+6CH4debSRqPENvRC2d7Upq2p/funE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8389:0:b0:e2b:e955:d58a with SMTP id
 3f1490d57ef6-e2be955d949mr2592276.7.1729534389536; Mon, 21 Oct 2024 11:13:09
 -0700 (PDT)
Date: Mon, 21 Oct 2024 11:13:08 -0700
In-Reply-To: <ZxYeFKl2KbZ3Ila1@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com> <20241010182427.1434605-35-seanjc@google.com>
 <ZxYeFKl2KbZ3Ila1@yzhao56-desk.sh.intel.com>
Message-ID: <ZxaZtJGfN2_5Db6h@google.com>
Subject: Re: [PATCH v13 34/85] KVM: Get writable mapping for __kvm_vcpu_map()
 only when necessary
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024, Yan Zhao wrote:
> On Thu, Oct 10, 2024 at 11:23:36AM -0700, Sean Christopherson wrote:
> > When creating a memory map for read, don't request a writable pfn from =
the
> > primary MMU.  While creating read-only mappings can be theoretically sl=
ower,
> > as they don't play nice with fast GUP due to the need to break CoW befo=
re
> > mapping the underlying PFN, practically speaking, creating a mapping is=
n't
> > a super hot path, and getting a writable mapping for reading is weird a=
nd
> > confusing.
> >=20
> > Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 080740f65061..b845e9252633 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3122,7 +3122,7 @@ int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t g=
fn, struct kvm_host_map *map,
> >  	struct kvm_follow_pfn kfp =3D {
> >  		.slot =3D gfn_to_memslot(vcpu->kvm, gfn),
> >  		.gfn =3D gfn,
> > -		.flags =3D FOLL_WRITE,
> > +		.flags =3D writable ? FOLL_WRITE : 0,
> >  		.refcounted_page =3D &map->pinned_page,
> >  		.pin =3D true,
> >  	};
> When writable is false, could we set ".pin =3D false," ?

Hmm, maybe?  I can't imagine anything would actually break, but unless FOLL=
_PIN
implies writing, my preference would still be to pin the page so that KVM a=
lways
pins when accessing the actual data of a page.

> Also not sure if ".map_writable =3D NULL" is missing.

Doh, my previous response was slightly wrong, it's implicitly initialized t=
o NULL,
not false.  I forgot map_writable is a pointer to a bool.
