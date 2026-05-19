Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4D83ED3B5
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779198833; cv=none; b=CLLM9HDPJxeIOBqk2k4LV5ERrwQmrQW3JqTpfqx4j4cqtOo/7U+oogL5JPEFhGc900fTeplFeuNUoRBn5pg631rpxqfJyBGzhWmWZJ4+P9HsGU0vxvv6dUQI9TWxMJ4MZvxAYMMb4HX5jrJQa+LvGx2j8FiSc8mka06iqHIrc4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779198833; c=relaxed/simple;
	bh=YzdHAhYUrbTCX46WUv58l87g2Iwam1VpditQTACnMS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJuv/uLWRigfiw3Bi1WD+rTBJlgGN7wg0fIsLwjpvQ7ZLKZNzn6BWzPjjfIrDZLzR/8TBy4ovr42ysSTjtII/m+xQFSOUOpWiUcosHY9H6VW/GQ651s1Di85jJot2xhAgiJ03QmvauyW91qoELkAxOw/ksT7S2I31wpfS0enZj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rq/Ly5Gv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rq/Ly5Gv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779198828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gMJunAX4GgTUnfdlT58BrIL66UezK+YQZcmeEHYrE2w=;
	b=Rq/Ly5Gv0aXsTe0psfOEyFXWWGAa3D00EoyFizaVTZY87FfN8aaWwLyppYdJfdSEAC/HVT
	q1caiPzlnjJOA87Ue0fkTdcfOby+QHyqvCqx2FSHnST2+D3sVnw6WDX+GWo9hA4TAEmtfN
	Xgg1+mxv8wXv/ia49Zx7UL+yxCxZlqI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-8ZBhRhAmPia8yGokAH458g-1; Tue, 19 May 2026 09:53:47 -0400
X-MC-Unique: 8ZBhRhAmPia8yGokAH458g-1
X-Mimecast-MFC-AGG-ID: 8ZBhRhAmPia8yGokAH458g_1779198826
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490261c79fcso695955e9.0
        for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 06:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779198826; x=1779803626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gMJunAX4GgTUnfdlT58BrIL66UezK+YQZcmeEHYrE2w=;
        b=M9wh3h2yOXpzbkixFGhP42g69zQhVrtUe0AA+a7kCLWMaasev3ENci8ijMCcy0HLgv
         4yslqnnwpvGDdbnkpUyuhuFORu/W6E08Dneg4emH7aMqCCTqMhF+ovIduibqk7d/8fnP
         /y8JX9mecFIvN0sAK7fNKPgl/V1lj6Y0mzKgwZSYLmw15ZHB1UO/SGQovw2RZo3ipFC1
         4A/jTElt0yqAuHNyg12hstYzyLmfHmvKM3gL46btd2e7KiyLOYeuHUqw+yym+cB4OCmf
         UMyZodCXuqoam+R+TrI9dvuiOYD1YWF5Pe8ggdn7zYRKjrlptboR7aM3qdSdYnwJtcm2
         rGsw==
X-Forwarded-Encrypted: i=1; AFNElJ8ReUqk42bz+Cd41Du0dQL10ZwJktbOHLqUUy3T0lFcF45vl9KFBbQKZ7zmrOC5XRCsYTF0cqA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVx7cG8kHoFu+5y4KU4L18+EOIKkrRIy/cmTEungxmmrgBP/lR
	DtlP84LAg0NDkEWZSeBzz1jZjw4KqntVENLefKW26YmD9ZIoLdlp7wJ39xLVTmgK9VSLVelNaoS
	o6A5PPm53vt7jZgeaFxy6l69Hhk6704RNlZ97R8pgdsRCo4sSsICkah/M0TBNYG2RzlWFyyL5d1
	lIjxM86wTGSaSzka6v5UAyRmyy8T9KyyCd
X-Gm-Gg: Acq92OEp4PrxqQBICMUDYuac3g03Edt47ipILibaIV+jIfEn0PjGzeRJv9gZeTeT0VM
	Ls2LzJ0zrXawmRrVilDip5iH0iBEbV3uAQLAydNtONDiAvUsXbTto8Avroet1uoUgJifCRUp6ks
	eb/eou0YQjssKmy5LHxZwGsvBUdV4cDlQZt9xzDbrF5vChdaC5IPvINJFtlgoZS33+mUE0c+Z6c
	XpARimGn6oOZWNoK0Ls29KqdYHgxgYtNu2xb0wbOEqkiIz6TM1+OSWSwhK+2pbN362zqS3PCYil
	ycOH0Q==
X-Received: by 2002:a05:600c:4851:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-48feea99dc7mr159587325e9.7.1779198826451;
        Tue, 19 May 2026 06:53:46 -0700 (PDT)
X-Received: by 2002:a05:600c:4851:b0:48a:79d8:a8d6 with SMTP id
 5b1f17b1804b1-48feea99dc7mr159586875e9.7.1779198826081; Tue, 19 May 2026
 06:53:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com> <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com> <86h5obya2r.wl-maz@kernel.org>
 <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
 <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com> <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
 <CABgObfaM-JtNn2MuYXaiadQnLfAhTEaoHAcTG9=J6LkMcQCJ3A@mail.gmail.com>
 <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>
 <agxFbniU_6eQ98t2@willie-the-truck> <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
 <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
 <86qzn7wp3y.wl-maz@kernel.org> <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
In-Reply-To: <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 19 May 2026 15:53:19 +0200
X-Gm-Features: AVHnY4J8OrpUxEzodEMJc7lM9sDn1bgq4nXZ_hmQu7D8CU-GrOTBpsMt27h0TJk
Message-ID: <CABgObfbS-z3OphDna5W_JQPvw+OK=yXJurVMHp1ANZ5uGEgVhQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility expectations
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, kvm <kvm@vger.kernel.org>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Nathan Chancellor <nathan@kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	kvmarm@lists.linux.dev, linux-kselftest <linux-kselftest@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XFqEPNRGBWVib0dGpVLNdviJtYw2FiX05TbVkziJ4r8_1779198826
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 3:00=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
> Or some guest configurations which have only ever been tested under KVM
> could have a bug where they *rely* on the registers not being writable,
> and write values which are inconsistent with the rest of their
> configuration. Which breaks the moment those registers become writable.

Yeah, just having guests that worked by utter chance - but you still
don't want to break them - is the case that is most likely. Crappy
code that runs only under emulation/virtualization appears with
probability 1 over time.

Is this likely in this specific case---probably not, honestly.
Christoffer's patch dates back to 2018 (commit d53c2c29ae0d); *back
then* KVM/Arm was a lot less mature, and people developing for Arm on
vanilla upstream kernels have moved on from Linux 4.19.

I would still lean towards accepting the code considering the limited
complexity of the addition (in fact I like it more now that it uses
IIDR instead of v2_groups_user_writable, but that's taste).  However,
there's a huge difference between setting expectations based on 2018
vs 2026 maturity, and perhaps that's why Marc overall is inclined to
put this in the category of pointless bug for bug compatibility?

In any case, there's no arguing over this documentation patch, which
is already a good thing to know.

Thanks,

Paolo

> And those hypothetical cases *do* happen. All of the time. There's a
> massive zoo of guest operating systems; not just the major players like
> Linux, FreeBSD and Windows but a whole bunch of embedded home-grown and
> network appliance kernels.
>
> Nobody is claiming that we shouldn't fix any bug ever.

