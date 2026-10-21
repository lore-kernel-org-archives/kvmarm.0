Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792608448;
	b=JShx+4xdwmj8EEwZdNU+irPZdAic5c94CGPeOpJ2rvU7SWhzi6afTe/ayT0w/A9w8hBC
	 q8jyh2VO9X8DfJv4RyLTnVpzIFW4x076MzyxODmHLLVS5XX7VWVdIhVfroJP/XanQPR9t
	 xXBd+bhIfKNJ69NmUcpFSDh2QOIN5xHnxCZMLXiSovHZ3D5WaN7WwkWWXMQVQdZRD+0eA
	 7rV300kAq2+fD/Hpp+j2nW+WBOJ6n+4Ehedbq+mKxgLP1G5jo9o8Y9CulXT8WfPKxzatc
	 49iDh4Hla6YDH/Xt8pTofmY8DUT5PFg80RlFgpUplsiWp5plTJ0UjExgAP+YMsICJ+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792608448;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=dSTZtcyPK3yzGl0K7b9zLKEzjIcPw2EBeTAvW8QX6I8=;
	b=MRfQiEbGkA29Bsjb7p3JgHE3NQPgYSy0mSPGIGAT25PIwubMOxm+POqmq5RX7SbFOF+q
	 NjvjdKBuQOYuQr7eFwyXkcAyomTG48oAQI9XbN+n/EIUwnWqCTB/wvq+DsF6NjduQcBB8
	 PvX/mcRxoqqxFgNEC0Sb7pd9pOKWBqikCd0VCnP0o+xO5SuitL3S4xTjNrY/Q/9CRxzPB
	 VM5hMYJ/UxfEUJ8z7VVplxcErOGSjDtaV4n1G38BPoEW4YZhgboRouDCrkPHED/PE2axF
	 4/BFiTwJ5L/NSZDJ/yigexmc0RsTqms3DbINlU43qG0Ja2RBNghSTHTJqiz+V/aWgCw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="D/qqbsnX";
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294EC606A31B
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 18:47:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 294EC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=D/qqbsnX
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-188406bb948so595766c88.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792608447; cv=none;
        d=google.com; s=arc-20260327;
        b=jn4/HvZF0/vs16FmLEdXgy4VN4b0BtGviswchWL5nOwEWe2pyPrK+ChQOAYRrSH+bn
         DDzSU8ZUb0XGBCzPk6CX5rx8aVowMOILpg2ixq7s/y1vvJEkZcn1gpoI18ivEBSMn8qk
         2cWTINNEa9HLRZhjins2ez2+/oG4ZB9sPqxEunpvTZ6rxNByf/SsDFB5mc52enNsYog3
         279jO8negW5pAMpGU8FiY/YNA6pNYzuEbOTV+7drRk5tfDPvS87lb8Qw4gA3U1Cine8g
         MHeLyxi6txEcmFzCCmeHOyFXg2kk6I0Tk7siFIFjaHCVSSi9klXnngpFd/QQO6w1nJXS
         5ZKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dSTZtcyPK3yzGl0K7b9zLKEzjIcPw2EBeTAvW8QX6I8=;
        fh=E1I73s9UcuejT396x7KZ2OVIU5B17toL3vM+aCz3758=;
        b=dtk75Qwu27ifbEufGS495cfUJ6YwLBkpo+7B+VHdlREPW279WFujkB7C/6H/+NB2G3
         /HARZuFQrg6cWF1z7OJihcTe6gM1R3Ioqu80i7v63ruMgp95eZ17ox7jjCfdua9Qelc1
         2B/cf2gX1YCN6dSuSkID++oPpvXZxXFtV8lw2lbGrHPh3WQgjeuQsQzgSeZhuPSTwMGt
         IVKmRhBuyc9MJpx5hfsJ+BX3xQXe7fk9qMKZxAYdor55qQZaQkopuTUubqM1FJBn169n
         wKSQb+o/cMhKfzh1fnJWzetpqt3tRdLwJj2URmgVAKZSFcgUXpYHuJWYqpgtoX6EEI8x
         WZWA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792608447; x=1793213247; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dSTZtcyPK3yzGl0K7b9zLKEzjIcPw2EBeTAvW8QX6I8=;
        b=D/qqbsnX5FCnopxWv8JRdV4QCO71RQSnClwYHATFx7CtvWwY2kI432jyIq4uVNjw0N
         EoRo6qCnE4mMLB/jDkIL8/2smzPXH9GMdEq1r4Gg855ARn6zusxchIV6fdy2k6QF+KBi
         /biRAG7q4V1Xg+pWDpxMF6i/rgWW3HsbRRoSGfPJFUwT6J86rS8fIG62wRhePF5XOc3X
         j4Swz/C1J6DW2sm/z7ft9pyCXPhRru4Im7KpqbsoSIAnTSZYdKVtp7Ljnt1zTm/jbBvu
         E2eSHwqV9RohP8q8IIvhjAoe64MIgkpL2Xok++B+fkTguQVDmTT1TTuhsbPSOtC63FEH
         Mk7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792608447; x=1793213247;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dSTZtcyPK3yzGl0K7b9zLKEzjIcPw2EBeTAvW8QX6I8=;
        b=BUIun4hfZUd+uMXxzmykHRVyK2rCMOvj7FVN7KG7X4cJ2FDTWzOraO40hD4hg31Ovi
         Mnv/NSuS2sloHcWxPQLkdYLvTLQ7geMX4mz2g3DVYiULdTqmHH7+Chs8iiwkvgDQNu7C
         X18dIduJL14XkbCyhD+OwkmEVacH6+I/3YmsZt8KKBqp8FISMDw9JbgoSGxnCWeyTOLl
         VDmvPcBAjUxMLLSzQ+7M+RR60MWVoJLX/k09yTqimDZkEumWco9K7taKeOlGSfAJDgTH
         9ntU1fY12xyErrRnLj8ZI92j/D6ZXjlgMrg+37SK4FdI2+x4AEjwdyIw2Wh4nQGRbfQa
         inpw==
X-Forwarded-Encrypted: i=1; AKwUvBzmUv/IEkcK4LPlnhF0AYJSrQgWovLYUasM8rZQYoaIc7HAYL1h7Rf3kqeaq9As83FifrLs1hI=@lists.linux.dev
X-Gm-Message-State: AFq9FYKbmHhC4d02e1AAgurT0pLIQO5AN2sKD6stjIsUSF2hYAypIn++
	k7/acMwrJvIz/N/7YFiaArc/nWe8nVLYdScKYNc7v5MMU71++GgoQlG9URMKugzTUpeLPnIZthR
	iN1BHGz4797kYVvilDmdNITE2TJAg7KxM1VCMizbO
X-Gm-Gg: AYBFou05MZ4WkX8qnLxrdK0KuqDXS4KoWYJXc3rENkEGcLxNr3vwRKisZr/CZ1+mT0+
	H4SkgYG8N1wDT/z2BwHpS34j79gzrAPcZpRETjAT3NXyWvJ2j7npVVLM+hbMxfIk2t+xCsxSZ5H
	FvRurxUtakQ1xioIWphCKFSoECO2hwyi+yc/HwjaISYzArUflTI5avSnXvi9U5KLrSO6L6UmoAF
	zu6Uggjom1hUcqp88VW7J9JbdAuLzUg4SPb3R8vcfFEMHzF3G4P3eAJDU/wQzuZ2N5eAjQ8DD4h
	pcnWbhhr0UPhsYH0RAnY1AgwycYwkkA9lMxoOwL6IXXGxpyszsUo5iLItoWek5BGJFAAFTPS50i
	BTNq/zdQft34Inf/cDM8p8VmGdaDmn78tMl6kHET1uonXbg1GkMaI2TrUUak=
X-Received: by 2002:a05:7022:2507:b0:14c:efa5:ee7 with SMTP id
 a92af1059eb24-190a4d18cc9mr4696437c88.14.1792608446024; Wed, 21 Oct 2026
 11:47:26 -0700 (PDT)
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
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com> <9huzecdi6go0.fsf@tarunix.c.googlers.com>
In-Reply-To: <9huzecdi6go0.fsf@tarunix.c.googlers.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 21 Oct 2026 11:46:56 -0700
X-Gm-Features: AclHuK9GVWu4pH4tc-A36maNXu-EHT2uwChCmCT-hqS2EBFk28gxkLJBLwcVEzg
Message-ID: <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: tarunsahu@google.com
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Andrew Morton <akpm@linux-foundation.org>, 
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, 
	arnd@arndb.de, jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com> wrote:
>
> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>
> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.c=
om> wrote:
> >>
> >> LUO and its file handlers validate handed-over state with monolithic
> >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serializ=
ed
> >> structure, even an optional additive one, must bump the string, which
> >> breaks live update between adjacent kernels. Replace the string in
> >> struct luo_ser with a feature header, so that the target kernel can
> >> accept or reject the source kernel state per feature.
> >>
> >> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> >
> > This patch is all wrong; 128 bytes is far too large. For every _ser
> > struct, we only need 8 bytes instead.
>
> NOO, It is not. It is intended to avoid complex mess with unnecessary
> over-engineering.
>
> >
> > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > 30 feature flags + 2 reserved bits for flags extension). The last two
> > bits of the flags indicate whether an extended flags field is present.
> > Each extended flags field is 8 bytes, and its last two bits indicate
> > that yet another extended flags field follows.
>
> If we will have dynamic extension of flags, Think about this.

To support dynamic extensions in a backward compatible way you want
something like this:

struct luo_feature_hdr {
   size
   flags
   extensions  // offset of first luo_feature_extensions (or 0)
}

struct luo_feature_extentions {
    flags
    extensions // offset of next luo_feature_extensions (or 0)
}

And then an example serialization struct would be:

struct foo_ser {
    struct luo_feature_hdr header;
    ... fields ...
    struct luo_feature_extension extensions1;
    ... fields ...
    struct luo_feature_extension extensions2;
}
