Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D68A4D9917
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 12:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779192840; cv=none; b=OFEfHbNpfZb0SADInseYMZaLtbygDeInRaBNpY4JZn2K4pQgu/77tOtXCdMUaEi4A1u3xQukWwmKjc7GfD3IaFrKg19lpCiB0R8maV5y+VB4k3UXooTOI6SJHWApXlOdaYnUFbOqaxUMJfjCGWSzzqgXJ1V1wMk7GrSbp/KzygA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779192840; c=relaxed/simple;
	bh=7VWO4tOJZLIbfUwVyMsF0ej608m9OlSJbClLH5Q+eyA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=km6hRl2rPqTMwd/dPXVisHxmxr9HXBtWnQUbw1nhItEGJqbQYpf6S6xGLXoX+BT1D4Lrh4Wc6LLngYpyv0Kr4IwjgJh5mjY/39sY5CB7VhbYrtPLeyLoLAwdLrVAGWLgf7P2oMH8tP6Wl1NSpo175AZEIkEz+mXC1Eh2HFGwZWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YcE/AYen; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YcE/AYen"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779192837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pXWENuANe/jSGrQq2ukgBgZ/4H6cQmEOV8lkEUWmoMA=;
	b=YcE/AYenOMoHo0zat1Y/tsAQqH1AIQM5u97GMf8E4zOqRdhYfl3iLHkFAi6cdVBAVNdCVd
	di85IsjhG5+CaAMNpXzj25Wi13S8HfMUio7jGXE8mdJA1+mVDo0MdKwsskv/OSg7/1UuUp
	+ZoCG5R/aiqwwB5U9I/q7W3Cl3HEqSc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-mbcD7dlHM_SUZa7BXYtUEA-1; Tue, 19 May 2026 08:13:56 -0400
X-MC-Unique: mbcD7dlHM_SUZa7BXYtUEA-1
X-Mimecast-MFC-AGG-ID: mbcD7dlHM_SUZa7BXYtUEA_1779192835
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44a71109b94so2667413f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 05:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779192835; x=1779797635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pXWENuANe/jSGrQq2ukgBgZ/4H6cQmEOV8lkEUWmoMA=;
        b=FfmdnVJ5mz2mmdfciz1FfCdMj7Fka2UPeKsJnz2gTcNPJ5DCrPdlLTWnTKj0Utjz3F
         W3Lj3olYCmViGZ1daJwkdMV1BrRcOfNsPQoNXSytth9qpmEzh7CiS82dvx7bxNs2P16f
         bPLgpWxmCtiI2XCzAcImp+xSwk4cooeFVhWc48RgQw2GOfwli7rgM0Qiic7uRAsZEAk1
         HSvkK6Ygwxx2OorXo5K1pFEKxlMIHU/KaffyrhcfgumoyO2NaAwl8B3SJfAp8KclQcLH
         S+0sSNvAfPtXD21zeQO3s7KgJWwphrMbPhsjycPxGRiFAHHKitiYMv6713R2x1+jlKPr
         8wZQ==
X-Forwarded-Encrypted: i=1; AFNElJ/S0Rk6XuMMt2a/j4oQCEeAD6flsBcbWMHyvD5u8/GQNyIE8VTbMAW/GWuAF7PPvlS2utC5yw4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOZ6YgYPpl8Rr4Lh7UWgZCxCQKZkgh5bkirLCn5NlIxwNh4mSM
	Z4S/Fuv1I9fZPMskqs87xyoewQH7Mrw/7wKZSVt0zQe3vEc4tZqLOMiBzGNrDfNURfkTpwMqu9y
	YScypaEIdGWPewDvq3f6a06PbECwh92SxYAPSGtTHG+TuEgjbXatgxq8fA29TkaODn+jaVx+zWf
	e4oupgSTJXvMGwXA+XRH+1Sj88n28rRMuh
X-Gm-Gg: Acq92OErET/bTsV9ZwxY1E1ALmhHIKkJuFvp2YD19dSopPAEtHwGtpg0PsiQrDVwR8B
	2ErEk+egtzPgXEFDIUWAjUC6RnyZ7Z403WSFHPsfpzo1QVBFmPeSwLGmDmNkHCSC4shD9tSg0Ok
	WkMg6kumhQQtgMwoXAvvdusiXG0QeC6RmFsWOz4sH/nbCSQGx50704ecr17pMRdJjp53M601/yK
	aeaGGZMZlNJ+pNcTZVzijbiBImY9A0m6ge5YCgjBmwxn9Bz+VXaN3YwlZszExEHzMg8RsN9WS/r
	u6LLdQ==
X-Received: by 2002:a05:6000:2207:b0:45e:73eb:2a75 with SMTP id ffacd0b85a97d-45e73eb2ab3mr19018211f8f.16.1779192834273;
        Tue, 19 May 2026 05:13:54 -0700 (PDT)
X-Received: by 2002:a05:6000:2207:b0:45e:73eb:2a75 with SMTP id
 ffacd0b85a97d-45e73eb2ab3mr19018142f8f.16.1779192833807; Tue, 19 May 2026
 05:13:53 -0700 (PDT)
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
In-Reply-To: <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 19 May 2026 14:13:41 +0200
X-Gm-Features: AVHnY4KnZP7vwbtgqcU4-2-Suro94ZjhbnxjZ4Hm6Me_3CnnH2LMZ4Ptbe46Vgg
Message-ID: <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility expectations
To: David Woodhouse <dwmw2@infradead.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
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
X-Mimecast-MFC-PROC-ID: HIpfhTp4g28wKbMccWzY40oZ5Kjdjtmr8GjDVUh1zCA_1779192835
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 1:44=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
> > > So... what next? Is one of the other KVM/arm64 maintainers going to
> > > speak up? Paolo would you consider taking the fixes through your tree
> > > directly?

I admit that my knowledge of Arm is really limited, and I do not
understand which IIDR values have architecturally allowed behaviors
and which (if any) were made up by KVM; but even if I cannot honestly
remark on the code or even the approach, a compatibility knob is the
right thing to have.  That's a userspace API design matter, not an Arm
or GIC matter.

I hope that Marc provides a better explanation of why he believes
https://lore.kernel.org/all/20260511113558.3325004-2-dwmw2@infradead.org/
shouldn't be accepted, because I am more than a bit puzzled about
*why* that patch is being rejected or (in v3) so far ignored. Marc in
this thread wrote: "If userspace is not a total joke, it will read all
the ID registers, and configure what it wants to see, assuming it is a
feature that can be configured (not everything can, because the
architecture itself is not fully backward compatible)". But in this
case there's an ID register that tells KVM if userspace wants the old
or the new behavior, independent of whether that old behavior is
architecturally valid or not.

I will certainly take this patch, but I won't override Marc. However
I'd like to better understand his point of view, because right now I
just don't get it.

> If KVM on arm64 doesn't aspire to maintain guest compatibility across
> host kernel changes =E2=80=94 regardless of whether the previous kernel's
> behaviour was "blessed" by the architecture specification or not =E2=80=
=94 then
> it does not meet the expectation that we have of KVM implementations in
> the Linux kernel.

I agree with the "aspire" wording. Even if it's not going to be 100%
achievable, KVM *needs* to aspire to maintain both guest compatibility
and architecture precision. Sometimes it's impossible, sometimes there
are constraints that require you to trade off one for another (e.g.
via quirks, or by breaking behavior that no sane guest would have
cared about). But in general as a maintainer you don't *get* to
choose.

Paolo

> Or indeed the standards that we've held for Linux kernel ABIs for the
> last 35 years.

