Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792608694;
	b=I6zBqYvXVyrWG9rVY/Tlr8BMsPC0YaJSJCaQ59HER3xVehFQfw0YJVEIskzlt/UiN+xZ
	 Qbqf08XkG/tTaIIDTydZ9eFexWvr+0cLG67zMcTAIjECZHKNpZX3UmVI1gYnn5NSLE370
	 LgJSd6Bh/x8fzqQYCruWKBNygfAjrIw6e1ecvujkAdH06lsX1LrN51GZFQz7CpviGYcDf
	 87fntg700U4rOxRwDUqNWCKKZ06Vzt5BUxO5aDbgOa69x4bcnyaw+r3a1hQW4L1qY6w8W
	 pQvP9CVvzb5mdb3tAuGDto3X9xnTD7VNqScNItCk4DAGF3g814nlIZ0+csAaDuL7u2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792608694;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=V2oW+YxRWdAsPD4uJs1XKcHYT7T/4QzyNKf44tXuYtg=;
	b=Qj3gFi32JbgJbAS8AQ6JODhSynZSwJZaHdUBDbnkzmtlUcGQ5ihAY/Wr4e6kw6WJ1P2m
	 irzMNu4CpmFCV4QWZrHTexM1H11eoLDeJn83Jqgva7JCd6ZQM7P75cDF3PmCLy1Bp5rST
	 cvlE1/2vLm5leoMH9ziPhOKjYDvHKPtPAmdeslJ0mRGwyO/PKJjMRlV9daEjLD6Jrqbgo
	 ctqjUQ0EjPZGuYp4jvnEYLoa6CUyyFfGj+hqGvtm0JGPvMq08AflQxh/kxXDP9GZLSYyQ
	 TYMjbFcFwBpfCCrClXg+MRTTGT9q6Q8n8f2BtH10tbd/qOhJ8U3PWnqD6mLzL0FbGMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=KEmGnaVP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1196606A31E
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 18:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1196606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=KEmGnaVP
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b3f7763d88so1427844a12.2
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:51:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792608692; cv=none;
        d=google.com; s=arc-20260327;
        b=o4tlrmVnZVyDjSeRJzHCTENLcgozSTgnyf4Ycd9vqnxCHBWTMwWHzdWTjDJeOYjwIl
         i+minspyFyKfwz4dKN4V3nfdnCXIcRezSvP9obS0RmVJ18rYc8z227NActTjDK+LC887
         HnwOeITX4IU/70x3zNnI3ecULeD50UxkPSTMd8vwFjMqSlOfiY/lxqwFRuUsw+WiDZHH
         qWbesjhRSyr1xCERtjAws+AXgt0VPM/N59vwRZ/2ac/LD4szH4NApqg+kryzYxEIs91X
         wDTvvsPUMkryEIBo+ObFnMTR9/ZcJX8doU9nCAZ6Z+vgjmx3oXoTASzfprOO+Z90VNoe
         BnmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V2oW+YxRWdAsPD4uJs1XKcHYT7T/4QzyNKf44tXuYtg=;
        fh=hjl6MS1iG0OgQ5EeeRXPEsSWuvkkhdwF2nxsTllHtag=;
        b=Un4IUcek/7Ir07jPek6lzlydwv+Sbj125pFfbkLYzKaJyB//+TrrRGLFm36BpBgW3Q
         aQid+v0qSoc8iQxSCXxYKM8EdWpFCfwCub9cxdd6sYBKPJUa91kNStOFP0s0JeeZOt+5
         xOGJEJcgSCZHEuvHr6ikq4sZxe7egtR9zu5IFwOC9tbUxRhIi8bbEWQsWMxS6MwRbx1L
         d9AZ8gCLBmTBWd0tPb7aHiVgUbGsR0MmWghJv1i21L4qLt4Xabh5RIwRcxoTAcRztjn0
         yj0fTryPVAPyfpW/P2jFoKL2qBvd2NRqL4m1x8nc8D3TitakW8vtXP5ZM413DAAThwu4
         IAZg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792608692; x=1793213492; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V2oW+YxRWdAsPD4uJs1XKcHYT7T/4QzyNKf44tXuYtg=;
        b=KEmGnaVPWuihSxSbiYPMiQd3ggd3b7Zr4Q7JXRQ36wUAVDwOaW3+J/J/96NGyv3T6z
         nBVeV4Qpx0Jk+gTtjLbVK+wSVko6eKMPQU+Pb1x9S8Ks9KL7/1al/+YN/b91c1LWietS
         iTt3z3KjNBzjr3TqylWVgax9H+4BcZ61OMGRVFVupYeliLUn0bsY+qeG7chYjGqLsIUb
         TwE2T1aHnqGYcglxeiJMExe1CQfFB4VzXrSdzglhCHjsk5Ui0uOGBrGnEkUJkO48oiso
         /RXVOcsoVGcF9ZmInLLtjDS8j/GOWVI9NXDdVU+45Iy2UPl+qAvw3WhMk69DBOVms5BX
         V9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792608692; x=1793213492;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V2oW+YxRWdAsPD4uJs1XKcHYT7T/4QzyNKf44tXuYtg=;
        b=cPVEnenQN6ltiQQWdf13hKlssrhSkrT1r8sLPxNhCAQqHLXjg8jHdNe0c8K06IcZ61
         pAumkF5WusT83XrLA4HgZwfT+iKI0vFsYvQnuf8/tavAbQZdeQk2BNe5dq2DGJNTOSXI
         C5SckN5hKFSJzUy0MZX3a15F8t6a7NaxCQjoO9VU7YaE0fw0gARmtLTIVCmoELEffmzK
         XFqkzvHX3s4Vtu3HV3YYq/RunwTgL/r9ItCv+SYQBXgU1/BQUn3eQqLMpX8lBMJWXwqv
         QrAl3hFsvmXGpWcCKZE3uHKLYu6xe6xlaoR6Kkxj2niM3n30y+JqTWLufVrkqj/xFvCr
         mArQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZly56mUlCPYg+zg402XD1QltME11LA1w2cX4Rsc6NKcoSNfaxH6CG37vDu747Opbpn4L+YHk=@lists.linux.dev
X-Gm-Message-State: AFq9FYKmV6bUdbDPazxOzfxvYnjbfwMmiNpZ9BZn6o2iHazcXF4LdC2w
	VrU/AL0eke+zTZaNovE6xXBaXGmEsRWrdQK2K9KtuDg8gTLsDAK/L1D1t8f9lUp0/nq/f6kU/Xb
	LpVuGxoDLZmGnqwdQ2KOF0ANer7OXB61oz9AvnNVIdg==
X-Gm-Gg: AYBFou3TaJW/s/e3bzW3Y2AGlG1HG7IS5VdUSyL5GRIUA71QKc979qBGeZthjYvLE7I
	6rtb9r5VXn7M/wxWdwxiOd3wRX1Ap2GeWDGVEr4rn61hkPw6GIoe2TmUaB0YTzyaFGqcyenBN9k
	w+bU6NjBo1HXlNjanykIpcD2pDtT9jd3+N72StnXVnDWtKEMWIgS3KsWuB9q1df4MGNdDRim9t+
	yNAD+ATO3yUpAMHOzyLd9El/eBL6MK0virdOPiXnEmRAKiVsJwuXoI3cMaFFjV5Z3+5Naq1ZCT8
	IJwfHV7ZVpOqkcwGWld0WblgiE57U0mqvLItyTgLuSbJeNMitTCoARxE0dTNZzY03Bowy1C4A3m
	UifyijAfojq1LeHH1O/o+uQnToryR0FpnfgPNMwlJOTASIG3t9947SYB8DVy/tmCbzOU=
X-Received: by 2002:a05:6402:241a:b0:6b4:1df2:244e with SMTP id
 4fb4d7f45d1cf-6b41df242e6mr53870a12.38.1792608691873; Wed, 21 Oct 2026
 11:51:31 -0700 (PDT)
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
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
In-Reply-To: <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 14:50:54 -0400
X-Gm-Features: AclHuK9td__2XcAMViewCe_NhDoA_TjTC8gr4y8u3SANqGewpEKZoTgIKv6iXME
Message-ID: <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
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

On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com> wrote:
> >
> > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> >
> > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google=
.com> wrote:
> > >>
> > >> LUO and its file handlers validate handed-over state with monolithic
> > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serial=
ized
> > >> structure, even an optional additive one, must bump the string, whic=
h
> > >> breaks live update between adjacent kernels. Replace the string in
> > >> struct luo_ser with a feature header, so that the target kernel can
> > >> accept or reject the source kernel state per feature.
> > >>
> > >> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> > >
> > > This patch is all wrong; 128 bytes is far too large. For every _ser
> > > struct, we only need 8 bytes instead.
> >
> > NOO, It is not. It is intended to avoid complex mess with unnecessary
> > over-engineering.

128-byte per serialized struct is not starter.

> >
> > >
> > > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > > 30 feature flags + 2 reserved bits for flags extension). The last two
> > > bits of the flags indicate whether an extended flags field is present=
.
> > > Each extended flags field is 8 bytes, and its last two bits indicate
> > > that yet another extended flags field follows.
> >
> > If we will have dynamic extension of flags, Think about this.
>
> To support dynamic extensions in a backward compatible way you want
> something like this:
>
> struct luo_feature_hdr {
>    size
>    flags

__u32 size
__u32 flags

>    extensions  // offset of first luo_feature_extensions (or 0)

__u64 extensions[0]  --> but the size should be specificed in
declaration macro that I showed in the next patch.

> }
>
> struct luo_feature_extentions {
>     flags
>     extensions // offset of next luo_feature_extensions (or 0)
> }
>
> And then an example serialization struct would be:
>
> struct foo_ser {
>     struct luo_feature_hdr header;
>     ... fields ...
>     struct luo_feature_extension extensions1;
>     ... fields ...
>     struct luo_feature_extension extensions2;
> }
