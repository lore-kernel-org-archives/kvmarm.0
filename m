Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B561E45027
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 16:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604110; cv=none; b=dMCNYiOTjotZ7orJSP5qrjs8AZgMUIAXcPraZxn04634Q94urKgC6YPIdEk3kjiQXphjn83/1EhrjC/8n+kmgwGrX607iEYnmLefqF4HbxtLdWf0H5a8vshiBJwW6TmYn3RYLmC+8NjBpma4GqsVe7orxIgFg4JVFGjYmUCb0BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604110; c=relaxed/simple;
	bh=kZfh+kgSDDZM6Mxg95C682oyPEppPbrKKxzl3x92Kgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g096GlAACpzizQgpmCVuGyz4vKiswz4RVLE3KO/ILq9FN6rBxpKTfy+mDOxNpsDTemXmfDOFrdq3iDEeM1FotDXCSST+sc0Dz3jOwhYGMcsA8OCYWfitkm0+TQfKKuMfMJRv9R/GZ/9OkOWKl4NM6AcIptNOG0KjoFiylN22j6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sgIc+AKm; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sgIc+AKm"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-354be94c874so5992409f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 05 Jun 2024 09:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717604107; x=1718208907; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=35HWqccK3aCr+F1Al9YEF2Py//BGjgWqY6oYD1SGg1M=;
        b=sgIc+AKmt9smCtgy2PxYw1WxsXMWSbS7GyQBo9mliXELXgB9GhcZYm3LprK9j1oTlv
         EsZ72VibvSg9a+XOQAb/53DJR1pZ19RlJFsB3oGJOPP2MipXzt15RHAuaSBDROmWBWUW
         IeM2+Sv1DJcfiq1l3O71x9ksAwIGWNm2P4N96ccADCm3AfNJWZgq1wue1G9ZxeBP5fd7
         p1YlSEImf18/GySg7jqWPtyhMteGidi0GUeQDKuau8lYDZM0w8TBNx1rW7I6LgUQw6BP
         y4azrKVZ+gYXVWiMivR0DVdXGbSz0axCdmiDYUQ/Y7cgTx2ajbJaPdMaKo2w3sWged/u
         X4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717604107; x=1718208907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=35HWqccK3aCr+F1Al9YEF2Py//BGjgWqY6oYD1SGg1M=;
        b=gPS4Gn1aYzi74RSMxP3HLVt+jEsAdX4QcyBqjaknKQMclqjU84pHJ8ASjfD0uIsRhd
         Gs0O98ZT5TTed9OQaZmY5PpBbveVrAz8EOywEYU4qUh35v73Zvzrho2I5jtYSn/Be14R
         Yi3nbIFonKr/3SnRN/eGqzyngbnsGSBdZ/sbd9xwL7vzh8XhY6NMPxDNKoEotgHcRvjC
         kzYBQD6SuVhG+JSEHETehP+D3NM43QG7u80LX7YCBpT7O/wsu6ooH8UWx79HjwF331l0
         qmRnjpO5ODu/Ll8iadcwAbAtLtobbeo+pBdVsa6+jo+eipaBMMGIY4/ewIvNsmbEeQ+/
         hMgw==
X-Gm-Message-State: AOJu0YymDPY6gMU5ebiFZ8soA2Y9Cq/+lQgCdi2Gv9nKszisjNnMDQSV
	U9wYGygsUjriEA/1FzTndxyToCa8k2yhFNyJ0+7TJhrt7xxYfn7bQD5KT9nUMTsEEH4+QUVg4Ze
	OYdow696JW98v5QNWXFh78cmQ2MeTP6z9s0Ol
X-Google-Smtp-Source: AGHT+IFxlAFP+ZFgNHfIdPS/h4muvn3F3p2oNiAHNn+SSSbY7PbcYt/9uHqC/LheFB7SRyjfN2+48d8MVTsA45clV5M=
X-Received: by 2002:adf:e945:0:b0:35c:5202:facb with SMTP id
 ffacd0b85a97d-35e8406894dmr2375637f8f.10.1717604106660; Wed, 05 Jun 2024
 09:15:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605150312.3684150-1-tabba@google.com> <cff5b8a1-d837-474e-9b92-b538d7e6caae@sirena.org.uk>
In-Reply-To: <cff5b8a1-d837-474e-9b92-b538d7e6caae@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 5 Jun 2024 17:14:23 +0100
Message-ID: <CA+EHjTx1Z5FyKO-YMPS83whX39eDAE5G6BzPJtpa6Z1kVpXgMg@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Allocate for maximum vector length for
 pKVM host sve state
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, Jun 5, 2024 at 4:46=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Wed, Jun 05, 2024 at 04:03:12PM +0100, Fuad Tabba wrote:
>
> > +     /* The maximum vl encountered for any cpu in the system. */
> > +     int max_system_vl;
> > +
>
> As previously mentioned I'd really prefer not to call this _system_ due
> to the potential confusion with the maximum VL we're using.  Naming is
> hard.

I agree :) I have no strong preference really. It's just that for me
max_cpu_vl sounds like it's per cpu. But now I'm just bikeshedding...

> > @@ -1031,7 +1031,12 @@ static void vec_probe_vqs(struct vl_info *info,
> >
> >               vq =3D sve_vq_from_vl(vl); /* skip intervening lengths */
> >               set_bit(__vq_to_bit(vq), map);
> > +
> > +             if (!max_vl)
> > +                     max_vl =3D vl;
> >       }
> > +
> > +     info->max_system_vl =3D max((int) max_vl, info->max_system_vl);
>
> It's not clear to me why we stage this in a local variable prior to
> updating the global value, and like I say it does feel cleaner and safer
> to keep the current split between enumeration of the PE and integration
> of the results.  This should *work* but it doesn't feel consistent with
> the rest of the code.

To me it felt more clear like this, but I'm fine with not doing the
staging first.

>
> > -               kvm_host_sve_max_vl =3D sve_max_vl();
> > +               kvm_host_sve_max_vl =3D sve_max_system_vl();
>
> I appreciate that we're adding a host_ on the front of it but it would
> feel safer to keep the name of the hypervisor copy of the value
> consistent with where we copied it from, sve_max_vl is a different thing
> in the host kernel.

I agree, this should be renamed.

Thanks!
/fuad
