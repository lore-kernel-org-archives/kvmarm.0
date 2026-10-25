Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792960742;
	b=ifhvWXYS1uBdeb0qj2VIg3vtIDqEbRKHASgrOoXjlP1lFUpMrtcJrHRl7RRLiBZcY2p6
	 1iH6imZXlTjOftwnKLGbhrA3TKwUby7abbYkrzf01eOiW6zSNc+E2yUi0+b49HaP+1/cP
	 sej/+MLj+6CPMLKiZcQzSjQw4jscpjng134sb2m+r8JeEQKlNqZ/9BTcZxJ7W5lfzXFJF
	 Mu0tLbVzHROv3r9SaxSjTr8DzClE/etFDbGS7ynzwkHdBhblsRM685LAjVBni7ZZm0sgD
	 1S44MsMKyZC6O9MyUW4ex3D/ZsH9IB93caIYwU97A0POxxDTeRg2kW+g+rO4KjyOKIg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792960742;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=rp5Fden8a6neVzulsysbnvEXD4vRCF1NzLSbVrqKH4E=;
	b=vW1ylDVWmBhm0oIjPC7X5sx13g2a5t8QCz8AHMA/ypPOjQ1mz7tQFhu70r3VmidXR+qA
	 PU6uF4RgOO7iUhJAaU1S3cbbYFwqzuCqTFguirDshV3BVT3TqjYxAo68POH6b8jUf7Ip5
	 oiAyLGD4/lNAVH3YeY/PfKGoJN8efFZ+IorK/YXxNbkjSYkbA0E1fZ/QS4uIkaRzLPD94
	 5oMZfTUhTpsr4UkeSwEHMIE7Wx/PbJSRxvUipnHFla2/SJf1tuXLmlTZmeV4dhEwE4+Cj
	 rioaZkmGMTAaIc0NDRGOhMneOvAMkIuqSKfe/cwXv4i//8ayhTVAEIf4psSdNF78kXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CB2606A31B
	for <kvmarm@lists.linux.dev>; Sun, 25 Oct 2026 20:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41CB2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so3340106a12.1
        for <kvmarm@lists.linux.dev>; Sun, 25 Oct 2026 13:39:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792960741; cv=none;
        d=google.com; s=arc-20260327;
        b=JSolnzO4pQh5Y66bwE/0CEuSld301uTl/Vc3IzM171BDZL0WJUUJtUDX7gxbg7cTPC
         16biXNoIdXx7YLrsmKkzzse59KkyPwtcUNv8GeB6QTWtBTsSESooAkzffqBROn1et0Ga
         VWTIbBr3Q7F3jdayiMOnRBd0P27js8BzLwik3zcTjyQHyIUuIZ8cJ9PFleQzZ/tp6Xby
         IAwe6VQfg5iQRyvHryN5GAeXK/wUIYxKEvw7hYLsyTkDDuTNiqvNWZpKpPC6ql6jHJNI
         FwqNOnhg3k5QSCZy4Cd8smHXNEiXTDcS5dQZSqNIiuc6FvC8hquKTts82QSbtShUv+8q
         EQTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rp5Fden8a6neVzulsysbnvEXD4vRCF1NzLSbVrqKH4E=;
        fh=s66DyZziqUEnwfOcQBk4TJQaK4hZw1uYoDa6acwUoEk=;
        b=mXj56Ai1t8PIaIqY6uxESmV+95s2zvf9l8BAz0LFD/8vK53hxIWHY7sBrgdcNlmWTS
         2q4esAuBjO+Goh5jx8SK2xSLlYk9AzVy73hGe1MagEQ2xBhj3OyY1rlM/qAF7TBN2An7
         r81oQnmxutg9tWH6+aVNkXsDlme4OSeoJNvQdK6LLujSpDWYNRgAXX5Ai5Tz3lNIHnE5
         udN8JHtKG7YnvBDSYOfc27sXRqESjqc3WWvKhoYzQckIZgZ7G4L/JZ4CoKkm1oqfEgJ3
         VeiUnjyqq/ll5uZR5hHV90gBJSVJTwoTbzF3P1zczuBXUuXkXQ4HRkU5dsbJarm/4wp0
         NCmA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792960740; x=1793565540; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rp5Fden8a6neVzulsysbnvEXD4vRCF1NzLSbVrqKH4E=;
        b=YN17xC1FkD++R9UZhWocX20ZNF4zb9jZ1kF873M8nJJSSbgiT+/tq8JR3HAGMxs+XL
         hr1FuIJpiTL8UfybrZM05B+bAsZpmrel0pQ3dLPwmigbY1I4ChrDps/jqG780DCat1s3
         BHK+5jm4+mI5Tsb3uq1ZS5T0RddeUUxmQBXOBpARi40WrTLprFyIy01nj7vX8VVEUX7C
         q+nDrY3u6CKSTnfV+4DKSkWuFJRye68GBvVInQFeHMX8GKuDq+orGhC6F4Y4GjKVeIl7
         8e9mPow4Pkj5IcNIRRbuxZpjohGoc0vuMweoUZsTfmJgk+oWxg+qxBMwE9Q/MEseqMlz
         BiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792960740; x=1793565540;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rp5Fden8a6neVzulsysbnvEXD4vRCF1NzLSbVrqKH4E=;
        b=Qlsd2xBRIQBIqYfDI7Bx8O0a6RH7bym3KX66QnJvfbJZdQxK2iGGN0RKH2BCKkCJbK
         wWH3o6LBvpMVLTmSrADki9jYT/F7eZLYjyiv82x6/bwIFbnyv9SDqy69uT0Yt+eNnark
         eGksyfzlJppGcM05AP+lCEuBk7+JJy95ccX4cUP7DQPAn/5eq8aKz2lKOzOmcbbNs/lC
         PlfR/qcC+CXeYmuyGTolLxhV7bwZP/LEgMvLMeubhwAjgGW0ApsekeiQGAxVOfFlr1n0
         ZuWfF6a9VuAw+zGwRvGRLRFxrlsKrXzb+YESv/j4UcnvekTK28PRqTco6Upp7gTuswc/
         Uifg==
X-Forwarded-Encrypted: i=1; AKwUvBzRDL9mQw7fVyMo4oLXGkE4Mjv3hq0lPLjC3LjedlDmyMcPVAP5kvUqPH6s1pKiijrI0U3VWNk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLqRNHaQerciRUDWU1aIn8srAqRBTlITz85+fB1xyUC1JQVKS6d
	dB869Ba/u+J0RY6ysrl8oH4DdFn0LjDys6O5gTR6yuyJ5HhXgklranhU/H3eFUcS3K+J1hD+pkf
	5qN/2ayBGesDcyPUttr/Ore1UGs4bydipPE2x95r8Ig==
X-Gm-Gg: AYBFou29zSD0Fs9pH/gqnTW02I210obF8wuZBqhS20iZyDOpmwyet1Y7LRzhGdLN9JP
	3EZhfH022gCQsYvnOUl92gIArsJB42NANSAMkSx2iZ0bgE/ZSh0fpao7tuVfXTtra8q0g114DU+
	kotVed59htXLknlhF1Ui/cMjVW1jVDVflqEIKKnk7zcaKBrOTtNZDOgRe8v29umRjgTPa3JDJ8g
	gc3fP4T8ZxeuEzd2mk6XqWUeOJqsOErEA2xZphtpEP/s/M6gdEEWD7VVJDVvSqxz6vWZ5Ik1LUQ
	faBdJv1K5rm4z5R8HxZihgE9zNC722GW02LmDD2PGSngouU5uHmW2rOq4RjMMWP7kIBASe1j+m8
	JdW6BfigT0EceaPjJrTL4pCw+B+dkkbuort+Fnxg6Zk47muLe4vaGkQC9ezELul+6CL9+
X-Received: by 2002:aa7:dd0f:0:b0:6b2:2339:370d with SMTP id
 4fb4d7f45d1cf-6b443000b00mr4543991a12.39.1792960740017; Sun, 25 Oct 2026
 13:39:00 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com> <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
In-Reply-To: <attmFVIFU_mS0Y7p@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 25 Oct 2026 16:38:23 -0400
X-Gm-Features: AclHuK80OiwlBnY6tUr3jZ6atHcY2MdRSOFYk5-Bhewn5rIfzUZ_oGQw-LNyjus
Message-ID: <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
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

On Fri, Oct 23, 2026 at 9:50=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-22 04:53 PM, Pasha Tatashin wrote:
> > On Thu, Oct 22, 2026 at 1:51=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > > On 2026-10-22 12:11 AM, Pasha Tatashin wrote:
>
> > > > Lets drop the fourth macro argument and generate the combined struc=
t name:
> > > >
> > > > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count)      =
        \
> > > >     struct name##_hdr {                                            =
        \
> > > >         __u32 size;                                                =
        \
> > > >         __u32 flags;                                               =
        \
> > > >         __u64 ext_flags[ext_flags_count];                          =
        \
> > > >         struct name payload;                                       =
        \
> > > >     };                                                             =
        \
> > > >     static_assert(sizeof(struct name##_hdr) =3D=3D (expected_size),=
            \
> > > >                   "LUO struct " #name " size mismatch!")
> > > >
> > > > For example:
> > > >
> > > > struct luo_memfd_ser {
> > > >     __u64 pos;
> > > >     __u64 size;
> > > > };
> > > >
> > > > DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);
> > >
> > > I think we are getting close, bu I have two remaining concerns:
> > >
> > >  * Reserving bits in each flags word for continuation leaves gaps
> > >    in the flag space that users have to know to skip.
> >
> > Yes, but callers should never manipulate the raw flag words directly,
> > and we can provide simple accessor macros or inlines that take a
> > contiguous feature ID (0, 1, 2, ...)
> >
> > enum luo_memfd_feats {
> >     LUO_MEMFD_FEAT_HUGETLB =3D 0,
> >     LUO_MEMFD_FEAT_SEALS   =3D 1,
> >     /* ... */
> >     LUO_MEMFD_FEAT_FOO     =3D 15, /* Automatically lands in
> > ext_flags[0] bits 0:1 */
> >     LUO_MEMFD_NR_FEATS
> > };
> >
> > if (luo_ser_get_feat(hdr, LUO_MEMFD_FEAT_HUGETLB)) {
> >     /* handle hugetlb */
> > }
>
> Sure but why deal with all the complexity just to save 8 bytes? All of
> these structs are allocated on folios and there are kilobytes of unused
> space to fit this header. And even if we optimize that we are talking
> about 8 bytes per FH/FLB... or 16 bytes for structs with arch-specific
> sub-structs like the KVM ones.

The reason I care about keeping the header compact is that we are
defining a foundational kernel ABI and want to use this header across
almost every serialized data structure so we can evolve them later
without breaking compatibility. While some top-level structs are on
sparse folios today, other serialized structs are tightly packed, and
we are looking to add KHO slab support in the future where tightly
packed allocations will be common.

That said, in your proposal, as long as nr_flags =3D=3D 0 is allowed when
a struct has no feature flags yet, luo_ser_hdr_size(hdr) is already 8
bytes and only grows to 16 bytes on the first feature flag. I am OK
with that.

> > >  * struct name##_hdr only matches structs written by the current kern=
el
> > >    (in terms of length of array and offset of payload).
> >
> > This is not an issue on the incoming path, we never cast incoming data
> > to struct name##_hdr or access ->payload directly. Instead, we parse
> > the incoming buffer, dynamically compute the header size from the
> > continuation bits, and cast the payload offset to "struct name *"
> > based on the negotiated feature flags.
>
> How?
>
> This is the only data structure that describes the header. Are you
> saying the incoming path will parse the header purely with a void *? Or
> use this header but just be careful not to access payload?
>
> We should have one header structure that can be used on the incoming and
> outgoing path. We should not have one header data structure that can be
> used on the outgoing path and one that can be used on the incoming
> path.
>
> Also we need a standard header that can be shared across all structs,
> not a per struct header. Otherwise you will need to do weird casting and
> overlays to implement the shared helper routines that parse it.

Having DECLARE_KHO_SER_WRAP() in include/linux/kho/abi/ makes it
immediately clear just by looking at kho/abi/ which serialized structs
have the versioned header and which do not, while also enforcing the
header when preserving and static-asserting the combined struct size a
compile time.

So with your header (and let's use KHO as we want to version KHO
structs as well):

struct kho_ser_hdr {
        __u32 size;        /* Size of header + payload in bytes */
        __u32 nr_flags;    /* Number of features encoded in flags[] */
        __u64 flags[];
};

The wrapped struct will look like:

#define DECLARE_KHO_SER_WRAP(name, expected_size, nr_feats)                =
\
        struct name##_wrap {                                               =
\
                __u32 size;                                                =
    \
                __u32 nr_flags;                                            =
    \
                __u64 flags[DIV_ROUND_UP(nr_feats, 32)];                   =
    \
                struct name payload;                                       =
    \
        };                                                                 =
\
        static_assert(sizeof(struct name##_wrap) =3D=3D (expected_size),   =
    \
                "struct " #name " size mismatch!")

On the incoming kernel we don't use struct name##_wrap, but we use
struct kho_ser_hdr for the wrapped data, validate the flags, and
unwrap it via kho_ser_payload(hdr) to get back the struct name *
payload type.

Pasha
