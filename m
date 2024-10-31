Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5C01BD9E4
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 12:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730379593; cv=none; b=k7Xv5g1w5Hy4/vN2RNj2NSVsZKbOCLsoub/u/v9DAevnzBZfh0gvhJ1EodcJE/y2Q8bY9BXIEdgPu4qfTbnYLttfUyyhb2tn0Z9mMGFXmNujFmOV8/pvXRdOSP0moBPFyNw96NfKv5LxqFLF3Po55POYQspbgg8CBn8VYSBEigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730379593; c=relaxed/simple;
	bh=43jUkYqDFKMbI4yK0l42jQl11d1Z0xbWWL04MIa8CoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dTjx1oxQBFxRLTPWdsDtJQ1+Y+1YUdljg8tCZ32/9VarUt0tuVvAZv3DdyRp4s+jzIFUMX/Cn6yC4Q7JX1b1kieXirN2f5iUgyje8EveMewDNJ+LIj9xwRaccpaUSfhWfe/NUqeFabqsf/R9DgYz0CuWWESixh2lvUX6liNkz4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iS50YQI0; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iS50YQI0"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c9428152c0so1238966a12.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 05:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730379590; x=1730984390; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+cjV12eTgGM/W6VxKSYtL5Nw4UUw/HSAOYX1se12Zig=;
        b=iS50YQI0MDNF7iE5oBeWihJrjVIknuN9FuWzvA2WZYFQwbtYsIf9bj49H/2cHn+JM/
         SZ0FZskjt+OY6MHUyMT96wzEEJhA2kJhPlo/nbGUt1aF4QdHSvAjcL+ASiFM7lXK/BfO
         zCFtkTndirXzz11ShEEF/qe524vNWFiOvX4jHBGqHVoMt88pfJ3jpZZ85RdxwFvEXJtc
         L8xOKYj4kHdhI2/IFVRGusCIYtheEmL5TncVs4sTM+FH6KWx9Fr+cDPg1Z2tjrUcdWvw
         /1ZCxmPBSbEm8xmg//jjQ8Mn5G1Kr6ZJFowcx2fhBW6Tt/IKCtks69QQyeqKnTok4TEs
         rW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730379590; x=1730984390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+cjV12eTgGM/W6VxKSYtL5Nw4UUw/HSAOYX1se12Zig=;
        b=wjLIJHHhD8bSFhPdgjj1wxnsPYzUcERoV8RBLNXW67LINq93sbRligv4gxFfptOc6q
         BLdKMEYcaxRIJ5KBMoMXt4HZSTi+sSV8DVpubOxmC1MmRx6xWyBlLjst6Y5Rlb3fvR9x
         vF8N51vd4lhRt2iHOByWJTgjIMl5tE6gS+VpGFRI8M8+BpHT4sPJuNWA2oJ+xciwxRi1
         nCzaxN4zthO/I216YJ+nraFgivz/6O5Fie4Fx4uX5ulKEokBSbtRP9hp3wnlyo+1thr3
         B1ecvo2ewKECUrVz3UoVg/4EoFZD/s4oI1twhJE2sR7kAt77GhWNoBxgig0bRUcu/AMV
         sWMA==
X-Forwarded-Encrypted: i=1; AJvYcCVmp5V8iDc/xo5BeWtewibZvp8HPH4ZJMzqhgQ8rk46+1f+5qPGx3hHUqQ4WqfhDpoG1gReEtw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgXVjAqUCtlWSw66t3OvlalJGR4tTm5f5OVCMDs4UDpyrl3oy4
	Sq0RLDPp7V1JxrRXJ09Slyz+ZRBBZbnI3DZ3wl85hzjNnpOdzcsfwO+G+ng2LWVnFzek7X81EiK
	XxrNZ6yZ91MgGWVdt9P+qxk+XLwNl4YC6LCikUA==
X-Google-Smtp-Source: AGHT+IERALXckroa9H9wtBfFLwXEcQL525RIETUMpbqoyMAnjF9yZNCHsaFTftdbxaN4KRPpPN9q1vw89+BTyseQZR0=
X-Received: by 2002:a05:6402:4022:b0:5c9:816e:45d with SMTP id
 4fb4d7f45d1cf-5cbbf8ca1aamr19516036a12.17.1730379589860; Thu, 31 Oct 2024
 05:59:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com> <ZxuZkUFz_bwAA1pf@redhat.com>
 <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com> <Zxudl5-fZV1vIaEL@redhat.com>
 <87y128nrfr.fsf@redhat.com> <Zx-3OUioG1l47hW3@redhat.com> <87plnknqco.fsf@redhat.com>
 <ZyN3A6dAEDkx51yb@pinwheel>
In-Reply-To: <ZyN3A6dAEDkx51yb@pinwheel>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 31 Oct 2024 12:59:38 +0000
Message-ID: <CAFEAcA_1R+xf-nBKCM7JDuNj7sLCA4KUjen6kPAng+1yjwHRrw@mail.gmail.com>
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
To: Kashyap Chamarthy <kchamart@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com, 
	mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Oct 2024 at 12:24, Kashyap Chamarthy <kchamart@redhat.com> wrote=
:
>
> On Mon, Oct 28, 2024 at 05:29:11PM +0100, Cornelia Huck wrote:
> > On Mon, Oct 28 2024, Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrot=
e:
>
> [...]
>
> > >> We could consolidate that to the current "host" model, once we figur=
e
> > >> out how to handle the currently already existing properties. Models
> > >> based on the different architecture extensions would probably be mor=
e
> > >> useable in the long run; maybe "custom" has a place for testing.
> > >
> > > If you can set the features against "host", then any testing could
> > > be done with "host" surely, making 'custom' pointless ?
> >
> > We might differentiate between "do some consistency checks" and "allow
> > a completely weird wolpertinger"; if we agree that we don't need it,
> > then we surely could drop it again.
>
> Yeah, FWIW, I agree that it's best to drop "custom" if all the
> meaningful tests can be handled by being able to add/remove CPU flags
> from `-cpu host`.
>
>
> Related: I don't see any mention of `-cpu max` here.  Is it not
> relevant?  It is currently defined as: "enables all features supported
> by the accelerator in the current host".  Does it make sense for `max`
> to allow disabling features?  Or is the idea that, why would you choose
> `-cpu max` if you want to disable features?

Ideally, disabling features would work with any '-cpu' option
(including our existing TCG CPUs). (The main reason for 'max'
is as an option that works whether you're using TCG or KVM.)

-- PMM
