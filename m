Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793122706;
	b=z9fjAvXvKMsTv/W5aa8EFTNMNJrh1+uwEcGec2R3TTxCPjRgCHI0OMZET8m+cKLKkyOZ
	 EpY25viu17OHZrE2e9O4bTN0bdBgenuLuCCPqiySVxBZhYUevj6XYONK31v/Ttlv1rCsx
	 ujASi7gVOS8nXlMPiF8HRGNaLaMIzWcaOqe3neDTYsJLmdf6opNOKhXY+zyPi5heYI197
	 QVaROngJ6vUir889+Rtw2s+0MMxN7W5ogsk0yThnpGA3WEws42MX1nLBVIpcwGxvgL3t7
	 LJEEHR3R5936TkFOeZuKQGWheZX3ym7jKDNm2CVqXUeLPUpFPRVHvM+6qvci2hAonaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793122706;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=75xnGPQfUpxl4aF5uqa7AQlJeR6+8S5bvRDT/N741Fo=;
	b=RHlGb932fPZRG2HSZbfAgoAwzE6ymhx9I3O8S2KdXQgnqx/zPR6KMm78VHppljQFXDwh
	 LnyvpJXhIpH3v5ltlFsgEa6N9W/mYyX9qioEIlOkKwZ1CbksdIQ+GQ44y2olaC6x1hOrp
	 EU1PoasP6RIK8JQydpj2M/xzBY0AGV1wCHeUY74j3vLZ5RDvm4K/V1T2k2DcfFND1Y0Oo
	 pHoVpdpOcL9bRBkbk5/rqrzxZeoTpfASFiiWkxSlqYiQCDG5HXztZ2kxIWdrcLqgjB4oT
	 h4AlZtNY6T/5vvAJrXYn+SsYv0pvqU3HkCL3cBtT+gqr6LxwChpxCTdveBfEXuqhKdQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AJ+10usr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A449A606A31F
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 17:38:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A449A606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AJ+10usr
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c34bff61551so10286066b.2
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 10:38:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793122704; cv=none;
        d=google.com; s=arc-20260327;
        b=OnLbSF1AvFPuJ4476ne7hKbQtmKMdSQN/v1m5oaNDPhR6BmJ153jQpEq2EH2n/6Ey9
         6fsRfQAE415umnYsloVzp9VC9YC1fpZfwE4nRG4UQGY1mbSzQCyzoi6PIUuEycacPdZw
         n2nXW7LmtvNirz05pSCDhEzu/fFZ7G3gOeNsqiSX4+B0Q9rQmqKuPqnCJSLUqlTgeT+p
         qsei0stZTreyHQ8yoD8B21RllGIDM4FMT1LMdJreh5hnA1/bW+BWIukH8qYW8lwCCNl+
         TIJ4JwOa1nckrIu0lMZ4bdXKovg2cccTM+/FNQZyNnIsE1EJEjwgjr42mEuOJJV21eKh
         xKTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=75xnGPQfUpxl4aF5uqa7AQlJeR6+8S5bvRDT/N741Fo=;
        fh=tu3mSAf5HKGsN6RJ6zPi0pKDT/2DCsjkmD/UykqtAL0=;
        b=psvoxCSLaDyORLVmloSZuECZbyY6exzbqoWTM57KFUB/d8iM/Ncsdm8GkovnYjZxcv
         ubinU6vCV00FrH6Vl20jUW15KlA8AIOe6qes6OwYKK1vR3eD7eMg4QBUNbCmFzQWpHHh
         XfZKaFQRKLbeec/VqjdNKZZalCVXtTNZM8Gw0dZAuZClAhSdcZbCkDFNdZzKoVJUYxlz
         CE5yiaMU/QXVwFTmtIogDsx3QwJu7f15SCUaeo+cjM4I6eJ/BRqESQx4Xipfgew8WL4+
         vK0feXn57X/cvLQeHnS33CL9rcAE/hRnOT1PGbUHIN3HuMJHzZc2k4B7zUSR2/kadm9Z
         5RJQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122704; x=1793727504; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=75xnGPQfUpxl4aF5uqa7AQlJeR6+8S5bvRDT/N741Fo=;
        b=AJ+10usrmZjWNCyDncW1l6JD47/wAFJwDFJkObiLpkhi33w/YnrbT1dfWkC1YHfINQ
         HlPyFw83ZMLLzCPZBd5ZVpEsJ2oCBEjny4eY3o/UG1y+wK+gEacmRKdHp2om1f5E0CGa
         h2nUvDw2mi0kPGyJ+a6hqGRw9BeRNV9FGfyeCftbGPhYSohyiXTd1nB9eWSEw7lAeiTE
         pHVKw1oRbzjlSqAyedWa+jl/Pj+psR1Ls7+Oj5BMO9N9X/NmN5Q+akwWK6FThBHAh8Mq
         wheJ5vpHYk1LXCUuyDVUnG6SYIlsCRZ2hQJmAJExd4EMmnTS1nKb67OgI03bLgBebUgK
         vKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122704; x=1793727504;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=75xnGPQfUpxl4aF5uqa7AQlJeR6+8S5bvRDT/N741Fo=;
        b=oC45DgoMv2CeVhOqUKF40qsrHikXHAsp7R3FjtAxxeRsVYemjSYOLA69nsmawuxchz
         YKs/9h4WZnV96FaYkSvGMeC2djyNcKfTQGe+OSysHxMxpdEOg3uaYGqcW6VU/x4vndpW
         cfZn+yBqvp7GlJS0xYbMAOaeNRiILLvQRDZ72zYi5QoNbf8BGtsQH/XSWb4WSRo7G6QP
         8iiUVQjTuN2fCfbOuGP/oQPCy1BlaO1FozVNq062moxMZe4MCfMnZ4J4b7reXtxnCdfj
         mDmT2O0QurDHaKO7Csj2hcG8+ZgP+grSyIeSSub+F7qR9N6RpF1rXDfMmv/r0r3/He1t
         s9FQ==
X-Forwarded-Encrypted: i=1; AKwUvBxoBPDY+LgA1mwB4m0fH4M7sGQdeLntIVXHwpuQCeGMGTMHnkmUvl0p8IYJFVmzulA0+lBoXok=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ1BmTehQ2iTatRUbiwuJBBSa3p5k5zyPf6313HZFVvzmnUs++9
	yvFgv2Ji/fGYT/nqCa3oAgQkV3Sanwd5YwDnPcpsuBcsNw/4LIyiTPl8SFNnS2Bo3L4Vm1m3PW6
	tt9BoQA3kAA/4NPbln5ykIoMTuyZFsIDgUVSJFpqy
X-Gm-Gg: AYBFou2rqgK23Bip4Ngi9PCtybu6WUchKLzmFoaIyd46wLzo6JdlwyCXxIog0NxoSls
	RY6Scqfp6alZUrG/ZDg8cnyla2YYlbH9mrAUwMs3lOOiaYX98RnVcuBaXGPK3UxXL58SC6ditnY
	eCPZZnzAMk5j7Y29MuJv3PNLklFU4uyehWh/KwPnNiwmYllsRXIjtcz7qUBPnmhOyDkaUOBst4P
	lASB6ONrPALyCTXrTQw8x8FhGlNnZ/IovnuO8vZxCX3BswumUrd2CDN+VtVMXrOif7jeeRpl4xq
	eebf185MJK9lxEDoreLHbx4dCPFSn1g1fXHIDYqrgHRGfrsdpyrgCz7VZJrsbno7egvx0Ye13gi
	0eAvDmDvWlmQ90jh3mgnNrIzegBJNmLU9V9Rb1w==
X-Received: by 2002:a17:907:d308:b0:c2e:378c:8ce3 with SMTP id
 a640c23a62f3a-c46bde8c44fmr1091193766b.32.1793122703439; Tue, 27 Oct 2026
 10:38:23 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com> <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com> <at_CncIPYCxOVkLo@google.com> <auDT5MjXYq3lcQjE@google.com>
In-Reply-To: <auDT5MjXYq3lcQjE@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 27 Oct 2026 10:37:56 -0700
X-Gm-Features: AclHuK9nhZy1yfbGSOSB3h6FsOr-7RUqfg5DsC4iepC4uLqRp9MK3EAsOEkjOYw
Message-ID: <CALzav=dYKAP7pKfoPtz32X1cT_tH4LN0X47_jTO8_HOCT4Pi=w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 9:40=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On 10-26 21:14, David Matlack wrote:
> > On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
> > > Right, Required bit should be source kernel payload property to tell
> > > target kernel that the payload must be handled to correctly deseriali=
ze
> > > the data. It should be source kernel (userspace) responsiblity to mak=
e
> > > sure it understand the target kernel before doing liveupdate.
> > >
> > > Saying this, During deserialization, target kernel's required bit is =
not
> > > necessary. So I propose the following truth table.
> > >
> > > Source hdr  Target supported[i]  Action
> > > ----------  -------------------  ----------------------------------
> > > 00          0 or 1               Accept: feature absent in payload
> > > 01          0                    Accept: ignore the feature data
> > > 01          1                    Accept: use the feature data
> > > 11          0                    Reject: -EOPNOTSUPP
> > > 11          1                    Accept: use the feature data
> > > 10          0 or 1               Reject: -EINVAL (invalid encoding)
> >
> > Yes, this matches what I had in mind for the semantics.
> >
> > To be explicit: the source kernel should set the bits for each Live
> > Update based on what is actually preserved, rather than generating the
> > header from a static per-kernel array. E.g. memfd would only mark a
> > feature present for memfds that actually use it. That's what allows
> > rollback to an older kernel as long as nothing being preserved depends
> > on the new feature.
> >
> > But looking at this again, I think the required bit is redundant. Wheth=
er
> > a feature can be safely ignored is a property of the feature itself, no=
t
> > of any particular file. Every file that has a feature present will have
> > the same required bit for it. The only thing that actually varies per
> > file is whether the feature is present.
> >
> > The required bit still has to be conveyed to the target somehow, since
> > the kernel that needs it is the one that doesn't know about the feature=
.
> > But it can be conveyed by the feature's number rather than an extra bit=
:
> > split the flag space into required features and optional features, and
> > assign each feature to one of them when it is defined. This is similar
> > to the required_flags and optional_flags approach in struct pci_ser [1]=
.
> >
> > Keeping the same header shape as discussed with Pasha:
> >
> > struct kho_ser_hdr {
> >     __u32 size;           /* Size of header + payload in bytes */
> >     __u16 nr_required;    /* Number of required feature bits */
> >     __u16 nr_optional;    /* Number of optional feature bits */
> >     __u64 flags[];        /* Required bits, followed by optional bits *=
/
> > };
> >
> > Required feature N is bit N of flags[], and optional feature N is bit
> > nr_required + N (using nr_required from the incoming header). The lengt=
h
> > of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
> > are numbered contiguously, so there are no gaps, and up to 64 features
> > still fit in a 16-byte header.
> >
> > Each bit just means the feature is present, so the truth table becomes:
> >
> > Source bit       Target supports  Action
> > ---------------  ---------------  ------------------------------
> > Not set          -                Accept: feature absent
> > Optional set     No               Accept: ignore the feature data
> > Optional set     Yes              Accept: use the feature data
> > Required set     No               Reject: -EOPNOTSUPP
> > Required set     Yes              Accept: use the feature data
> >
>
> I like this proposal. I bet most features are going to be either
> optional or required, and even if we ever have a magical
> sometimes-optional feature, it can have its own required flag. So, no
> need to pay double the cost on every flag.
>
> Just need to make sure that optional features always start from 0, in
> their own enum, so the offset can be computed correctly in the incoming
> kernel.

Right. Instead of having a single 32-bit feature space where every
feature can either be optional or required, we have 2 16-bit feature
spaces, one for required features and one for optional features. Both
feature spaces span from 0 to 2^16-1, and then are packed into
flags[].
