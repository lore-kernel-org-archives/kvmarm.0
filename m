Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=74.125.224.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793062547;
	b=hBq7n3kaRzKy02DY73759i5A7vBpThaxFLr9QxqR3wWUz4eQmebmYcg330+wKs/gpzr8
	 ShFzEv6AQHeWJhMg/b3ynnlYkNlR4EHjT0vKLQTzKVGb7YaL+rD5+XvCrKGWxD8xRKUkn
	 7z3uWWW3mMiBRoPrrZyy2F/r9xdkNMDO6JDXaYqNVlbAnLp1fUIiP6vztWbHgw20J++u6
	 lBKSM0TE55E1WMgJUWfmg8tG4fnhTny+ssdB4aeJCxWDZrtcFFuU0mxk2MWN8CUFJGaFo
	 jQuLLLo3Sro8TGCHXUn+1HyQhulIgO9K0PGXauwLRzZeVBPQrFCkmoKT9+khVkyQ3hQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793062547;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0rDUgYp8MSkkxbz0QJpm44/zZryJwi/MN1DJH+bVzxg=;
	b=CtAX29CYceVx+K0zUBGHfo521mG+5mpIk22MjNkelyB2IBZ32UwEWPV3/pbOD+QH1UzX
	 Ab5RbJKgIkBnT9/VcaIiLu2kC3MBKhLSG22EcAfDiEJdqYsZzTzX9Zzl7L2orR5Pc26WJ
	 t80mCICXkabb48zebuee0FdaFjgAmYQgGHkBoWQ/ERXVa6asYaSWnU1UEodR3Yd3KATLm
	 R/4MG3pXZgFc5EtlcDpYnXG4rlauZ2TJcXKvDt/CYHGwIFXa4OZAIo4BcUCz/3ODApeu9
	 f0sT/skRx0okPXdkg7qcKAxaA0ekMV1StbVeb4gvWHpp89GKA3AdhsilFxEIu5FRpXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mKtPv5pS;
	arc=fail smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C3A606A31B
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 00:55:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4C3A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mKtPv5pS
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6798eb0d13fso3816249d50.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 17:55:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793062546; cv=none;
        d=google.com; s=arc-20260327;
        b=f+3UkCb9acNCTYHenxZ9UrhEIQLEmHoX3yXw915xWtbRaz8hi3xRbF1LVxO5PWteJh
         BhcXeK8P/VQUUajF0tI4V7bCz1abHT52NfSxtaBDA4TuE1R19AmEkAzouWCj0+7cQ8iq
         6zdSPbSSPrB8SpRbZaoyadVRIcbjd2UM/P+fJ3HUDotXJiKi2vvaQ6++6ufeKxhPrm8u
         PLvhRBJ7ys98GqLGCi0pwnUKxAHgKutez9k5haaVDNwyYuMQcx37thJFSJmSpI00IPf7
         1fQeu9UceHxr0A4vydmxfuS3S2wEP9PDcFCY+pHy6/RtF+vjZR4qkgOsf891rmso/STX
         ljTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0rDUgYp8MSkkxbz0QJpm44/zZryJwi/MN1DJH+bVzxg=;
        fh=3PFJu1JiveXdklUJGyBTfdRrbdSHFd8yz5al6HROA94=;
        b=Na9bUiXmV2sGXpeZcAba5WezrxqQxVuYaWJFrIkouz3j9ZXjCmqUHHUejAbdVKLAZS
         /16ULv24bYkxCAFtZOchAVdiB7yXR5NqmHUW5/UFugcySJO1VKjjBh7NwbCXerFyhqbB
         Mm0TZedivz9pdgKc+fIBknzW4yxXfv9UoQsyCOpOYJ7kHVw1Y4v1LpGEG9GnfctdJ8Uy
         Jc/gDXabuhIaiZsqlo+u9X627CHo92uh489KUyDqkxQuXOu9K7WsT02DxrFymNayfTYC
         PUF2Mbgx/LmYywnIzSlvH1NkiQd9ly1KVs8+kIPc0ppwq/NgwdWtdF8+WahkVQueA30U
         gRvg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793062546; x=1793667346; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0rDUgYp8MSkkxbz0QJpm44/zZryJwi/MN1DJH+bVzxg=;
        b=mKtPv5pS935YKfi5HVr8I9CkhqTTGdwIIiKRKJ1Riis/ooqonadC4FFG5Q39LxSJ8y
         m2e8cb1hdjkKoBRrS0/j3Ed8it1KUp4/DRmsS4b1HOh2MfrlyybAV3Rg/y7Zen4bLd4H
         wo+iB47eNw7ZId57Ph31hT5oyOg6A/B5FzJ+WdtzwlLEpDoZt1UuYKsQNHdJbNCEvimi
         zguYIuBW7i/H0b0xxcqT2JJycD+WTtUZ6zYZGeQ9My5enKv6vaxodhyT0vVSNRLBtEF4
         YA2N4qvb9I4pwtaulXDuwtw5Tab+yNiQuO2+cn2h5peeVLRI0PruA9g7oUCWgn8ntGAl
         TbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793062546; x=1793667346;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0rDUgYp8MSkkxbz0QJpm44/zZryJwi/MN1DJH+bVzxg=;
        b=jXAVpV7pxLsCflR0WkOULTGsDzRxm8/H+PGN1u8cUwhhWdeT6mxLd8QUsyOsxNHGrq
         4jiz4YsZiC6YbuXVbycJmO9z0l8H/Gu96lj/tABt9/GMsX/C+ZyaTjucbh/KHLzwPU1U
         S2+d+6WZJAK9P7Z9GTlmxiORUB3kpNR5xjPyTb5a/Z2YwjyPuq79/Fmujm1Ac8+cDG5b
         MZnwNSAVc4GyftR0yAzgwlWjNILasB/eyv+wiO/mGEFR13fNn2lJLfhVE+qGk558nh5J
         V3At+gc+k2letI+b+pNl4ktSXHm9rOJxpc1+SBFyHVqnrfeMgYSDiI29GObAVFBOfptD
         djog==
X-Forwarded-Encrypted: i=1; AKwUvBxPWWy4rHbOVbOquDtus7ZenIip7EzN4xNc6WOz/zqke64YBykmqtgig1xySV0s7k/S9XcpNfA=@lists.linux.dev
X-Gm-Message-State: AFq9FYI6hz6tZ9oA/NHgsk2r2EegE5SApKsEuiFPkOoVzuYwckd8rEd+
	Mw1iuZyUcNH8CHplgMq5G3j1y/MHxwV5xgaW7T/gbgSI/1C40K7h3o4t9o32n88xOfnZcKIuGU9
	GjU37DwcUCI59qqmH5MdSItCNAo3YSyvSQ2+pvWrL
X-Gm-Gg: AYBFou0Af6Gny6hZl7+BrG7umDLObaMrEk5VB8tiUm6iehmD9gT9CJ3BwI1sGGGStBp
	aAg+5JN6XT8TxYm4tzLcLuJ6wTqrCS30+M4aXt3z7YjexVDQBUPUSU9ikizcLSIEffwYIbeF/za
	guU/ufQwuLw1ko0/b/uPmY5FlPOJpxzgMz2BDpf90v8kHSVJSf6gaqJi/6qUfpJZz8Cnjp2f+UM
	3nc93BTYqnvsY19ehZ8vrx983yOzH9jPbHvb4evrrU+fr93OyT98XMeJLrDs7XEm3QJYE0GBjIb
	4+9pqJjB5AHesNKs1Lay49vGW9duIJr5qaY60F64Gnlnrc0IbFJ05iOsolSyG0ivALi1nGtmmEg
	YPWsiuywmgzjvJpvYSWwQFhf5eUm8GIvjzN8crED1z1ZE9SpXKEDTQoCIN7yjWkjirwQggB2/kT
	hYUnnrtWBO8/y1f9osnr32GE7ODYAjCVUtH+kdzDQCijL3O7qJPIAQOYS+ww==
X-Received: by 2002:a05:690e:4193:b0:679:ab13:5517 with SMTP id
 956f58d0204a3-67a454185a9mr4463627d50.104.1793062545192; Mon, 26 Oct 2026
 17:55:45 -0700 (PDT)
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
 <9huzzew0el59.fsf@tarunix.c.googlers.com> <at_CncIPYCxOVkLo@google.com>
 <9huzecdcghxu.fsf@tarunix.c.googlers.com> <at_pxoULR1Tp5anN@google.com>
In-Reply-To: <at_pxoULR1Tp5anN@google.com>
From: Tarun Sahu <tarunsahu@google.com>
Date: Tue, 27 Oct 2026 01:55:34 +0100
X-Gm-Features: AclHuK8fanKHLtbPQb3b8Hh9aMr64vlKSACVWw1UZzkklpf-Ls0Hu1JyLQFmaw8
Message-ID: <CALe+6DxTR0BpvW7mXMjq_+dczT2jO=R_qLbHhSduhnuSPcXhzQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 1:01=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-26 11:28 PM, tarunsahu@google.com wrote:
> > David Matlack <dmatlack@google.com> writes:
>
> > > But looking at this again, I think the required bit is redundant. Whe=
ther
> > > a feature can be safely ignored is a property of the feature itself, =
not
> > > of any particular file. Every file that has a feature present will ha=
ve
> > > the same required bit for it. The only thing that actually varies per
> > > file is whether the feature is present.
> >
> > The required bit is subsystem property not the per-file. e.g. memfd_luo=
,
> > it is set at compile time for a kernel. So every file will get that req=
uired
> > bit set. It is not per file property.
> >
> > struct u8 memfd_luo_feature_state {
> >        [MEMFD_LUO_CORE_FEATURE] =3D LUO_FEATURE_REQUIRED
> > }
>
> Right, whether a feature is required is a static property of the
> feature.  That's exactly why it's redundant to send it in every header.

I meant the different thing.I was saying if a Feature in a kernel will have
constant value either required or optional which is fixed at compile time.
But the same feature can have different values in two different kernels.

I am not finding a good example, But I am skeptical about making the
assumption for all future kernels that the features will always be
required if they were required before.

Maybe a seal added in kernel version M. Later in kernel  version N this sea=
l is
deprecated and replaced by a new seal.

So transition from M->N
source kernel will preserve the seal values and flag the feature as require=
d.
target kernel will mark it supported and use its value to translate
into a new seal.

From N -> Z (latest)

Old seal is no longer required, But the new seal is required, so kernel N w=
ill
mark the new seal as required. and Z will support it.

This is hypothetical example. I'm not sure this is enough to convince the p=
oint.
So, I will rely on others to chime in with their thoughts.

>
> > > The required bit still has to be conveyed to the target somehow, sinc=
e
> > > the kernel that needs it is the one that doesn't know about the featu=
re.
> > > But it can be conveyed by the feature's number rather than an extra b=
it:
> > > split the flag space into required features and optional features, an=
d
> > > assign each feature to one of them when it is defined. This is simila=
r
> > > to the required_flags and optional_flags approach in struct pci_ser [=
1].
> > >
> > > Keeping the same header shape as discussed with Pasha:
> > >
> > > struct kho_ser_hdr {
> > >     __u32 size;           /* Size of header + payload in bytes */
> > >     __u16 nr_required;    /* Number of required feature bits */
> > >     __u16 nr_optional;    /* Number of optional feature bits */
> > >     __u64 flags[];        /* Required bits, followed by optional bits=
 */
> > > };
> > >
> > > Required feature N is bit N of flags[], and optional feature N is bit
> > > nr_required + N (using nr_required from the incoming header). The len=
gth
> > > of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both space=
s
> > > are numbered contiguously, so there are no gaps, and up to 64 feature=
s
> > > still fit in a 16-byte header.
> > >
> > > Each bit just means the feature is present, so the truth table become=
s:
> > >
> > > Source bit       Target supports  Action
> > > ---------------  ---------------  ------------------------------
> > > Not set          -                Accept: feature absent
> > > Optional set     No               Accept: ignore the feature data
> > > Optional set     Yes              Accept: use the feature data
> > > Required set     No               Reject: -EOPNOTSUPP
> > > Required set     Yes              Accept: use the feature data
> > >
> > > There is no invalid encoding left to check.
> >
> >
> > IIUC, I believe this will not work.
> >
> > To Communicate between source and target, We are defining a protocol, A
> > protocol which will be standard for all the kernel. And each bit locati=
on in
> > flags must have the same meaning in both the source and target kernel.
> >
> > Now in you approach, If Source kernel send feature N to target kernel,
> > target kernel must understand Nth bit as the same feature. Even though
> > the bit position in your approach is not fixed but they are fixed
> > relative to their starting point.
>
> I think you misunderstood the proposal. I'm not proposing to pack only
> the set bits, and I'm not proposing that each feature have a bit in both
> ranges.
>
> In my proposal, there is no such thing as "feature N", there is
> "required feature N" and "optional feature N".  Required feature N can
> be found at bit position flags[N]. Optional feature N can be found at
> flags[nr_required + N].
>
> In more detail:
>
>  - Each feature is defined as either required or optional, once, when
>    the feature is added. That choice is permanent.
>
>  - Each feature gets exactly one bit, in its range, and that bit is
>    always at the same position whether or not it is set. Required
>    feature N is bit N. Optional feature N is bit nr_required + N.
>
>  - nr_required and nr_optional are the number of features of each kind
>    the source kernel knows about, not the number of bits set. They tell
>    the target where the optional range starts and how long flags[] is.
>
>  - A set bit means the feature is present in this file's payload. A clear
>    bit means it is absent.

So For #NR number of features, We will end up using 2*NR bits which
is exactly same number of bits, V3 [2] uses. So this is just a different
way of encoding in implementation perspective.

>
>  - There is no invalid or reserved encoding to define. Each bit just
>    means "present".

What if a buggy source sets both required and optional for a feature?
That is an invalid case here. Same as 0b10 is an invalid value set by
buggy kernel.

>
>  - The target doesn't need a supported table. Required features are only
>    ever appended, so it rejects any required bit at or beyond its own
>    MEMFD_LUO_NR_REQUIRED. Optional bits need no validation; the target
>    just checks the ones it knows about.
>

As I explained above, incase a feature is replaced by another feature,
new kernel
can support it deserialization but it will not be required from there on. S=
o
The supported table will still be needed.

> > For the current appraoch and V3 [2]. Think the below one as msb is
> > required bit and lsb is feature present in payload bit.
> >
> > 00  FEATURE_ABSENT / DEPRECATED
> > 01  FEATURE_OPTIONAL
> > 11  FEATURE_REQUIRED
> > 10  IS INVALID (analogy: required set but feature is not present) which=
 can
> > have different meaning in future if in future, a need arises to reuse t=
his
> > field.
>
> In v3, 0b10 is reserved and not checked by the target. That means an
> older kernel will silently accept it, so the only meaning it could ever
> safely take on is "safe to ignore", which is what 0b01 already means.
> A reserved encoding is only useful if older kernels reject it, and at
> that point it's no different from adding a new required feature.

Yes, because I thought 0b10 could be used in the future. And Currently
If it is set by a source kernel, it is buggy source kernel. But I can chang=
e
back to INVALID, As you said, it overlaps with valid field 0b00.

~Tarun

>
> > Deserialization can happen per feature from right to left. without
> > jumping back and forth.
> >
> > Because of all these reasons, I believe current approach presented in
> > V3 [2] is the better. It is close to your PCI series with two flags
> > field for required and optional except I combined both field into one
> > flags. In your above approach you do have two counts but not having gap=
s
> > (which is wrong) and the way you proposed to parse with an offset is di=
fferent.
