Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763419;
	b=mdE44CBvPTXXmPuAp85WHzafIcu6OLxZ9AC5J20/sBABaiDjYLAkuQ0moE+5HwgZEdfq
	 4wTVfCnf8Xo8oHrESstDXMp/7f0q/lpNwNt071B/O9iEv8tO+zAmy1aAQ4SVAMjj2wZ6a
	 NLw2zIkpnQMPJro4His+8KNxMh6BMm17O5sx9hl7c8Qpp9N8RDreeHICHGhZh1ywn2Zqh
	 Ri+HobcXvi7Zl5Udkt2DxNG85TZIiSe0PqQWC5STScXef23EMS7D0fFGiZSXs9hANtE9E
	 fihXzDgH95+Ngnh1TSm/pKPVYS68FlRQQ1cbPjO7cI0cFxCoG2Ic6m88KSwqVadYRhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763419;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=8FyuJnnll3uJwbR+wT99CVBO9fzREsmjzeqnUECMRTY=;
	b=ajn+PRFRRVrcBKTZQjwzlmshF1D14YyrNiH7+9g+oUNELKWIodtPGeotdGKBtg2c4UBt
	 PRt/RNbbHjjW1ITh/ywhKALHC6iGuY4EYcuo43ePJ696o7LtFB+Rf2R+6GZJedThVks9R
	 bSAlmCggM/hTeCQInBh8wKyhlHEOBQAYehD3PfmO4BAvb2ONvdxN6kNWC+An5pi5n9tTz
	 ixSpt0y7zEQ0OjYNT5M4Ls1tUvawPEAUIrhaPAL8gzvZr9DHrf0/yDOi2kDNtZr3s4rZv
	 Vs4Lj9TU/u/jS1o6Iv3XAZW7BTzEe48NHrTJnrXT6c9tZkXJkkaoq5I+YntdLxu3rpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="KPwT/HJ6";
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EBF606A321
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 13:50:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11EBF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=KPwT/HJ6
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cd633ef819bso405835a12.2
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 06:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792763418; x=1793368218; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8FyuJnnll3uJwbR+wT99CVBO9fzREsmjzeqnUECMRTY=;
        b=KPwT/HJ6horIKi23Rq8ERXOA7CxMMCLFhxpXAn0iJcR+i6JW2S/JPevtTssiy1/B/D
         QkDqb/Vo84n98i1mJwuyEIEck2vbUhTvdx477HUj6Kpr7ky+2/o/MmcHzySoFLUq8tQ/
         lJQ9dKL4RdkxIC9yBsZP9pRRXIoW7HguLJ2V9BqaTN0vDBeCXuCe2Bz9heiebY2k887m
         U1HN8G8/yNCH9Nf2xSe//99kC2jdcf+Shb3q+jBowGeQMuhF3C+G5l/l7690crC7yfvd
         ExJDD4WLTeuf9asQZ6uWobI3JRl2ujAw6wHpbcU1XV49lVYwEm7jOwFxxzXAvpF+zrPe
         IW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792763418; x=1793368218;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8FyuJnnll3uJwbR+wT99CVBO9fzREsmjzeqnUECMRTY=;
        b=exJJwzEdLosn8/FN6mhqrJqJIeDgiceMKtQvc9Yy7/4A/yCZBk4XSufxl68HyltTHQ
         4nGgxAY9OHKIpWlc92D9jMY7Qp+WccYi5+4R++bF2Jm7W2kAFOEZwBJkMpoNf3F6/mOY
         AsugKUmOrEcYk27qMVyPNjZC/7q4B6DInSVLtSmnJ7/89jXOJV4Iu6/fKDmEHu0Mu227
         PGoqARigTh7Xs2MheX4BgE4SMFGhK0IZGwNisl8cVlhSqO60/6AyKfObeiRHPTYFxXfB
         jSNHGN0QVxDA185qJeMPkbnHFbBNRuE+ypMW5gYgNtfPeXjtGq+ntwKsqxUEYfafleTC
         Utag==
X-Forwarded-Encrypted: i=1; AKwUvBwb9u0BqSWO12ssGmtWfv6IEESRBSmLBcNQDKjsyzJh4Tuwl5YlfBL3cUjYurJLS9z7NzWeBOU=@lists.linux.dev
X-Gm-Message-State: AFq9FYKl89T4xlB3PRN1CRikEuyuTyTvIapo6mbU+yJ+t7ff3lhR34vQ
	0Y7/IMVv1aLgDkJ9CM33n5wgww73g7xdG893JIfIk3GGfzqXoCtuZv4iFJLkSV1zVg==
X-Gm-Gg: AYBFou2nQVmT7QblEZHY8tn/YTZsl1fp444nzkgks3evyhm+mGE6qyWl0N3fOBgVVPm
	SzM5Z1g+hTgQj4wWJKEf6cgOivrOax2+3dCPim0ssPvUnqrQV2BPujjBk04fZSb2ccBZekYA/4V
	BH8+cVwLMleNn8WvNtSvpputXCElROOTY0YzHZJ26ly+5+7rQipB1hvRWqMfpamvgc+JIdtF+3K
	0OZkmU2/jWGcTiu/VRrbZpcHFomWHEXCAmanXQeZWPzjHoW3p2puzCkMl2992wCvAbTImj4YAeC
	J7if+n4k4Or8k6jHVLoIAfIHhmJRWczV+Q/mqCR9oCpIfKAXXqERydaoEzYU/X6O0LTyYMN8AJf
	OMIg6Hb9noXIRlHCISMdF3t0Y1E6D0kZzLa4pV/48i+Iae3DxgOoxgrhb4KQamDOd7jC760c+cE
	Ic04xZLHNEube82QCEEzajsL32X2jbR+WXNgPuwCkKtMyRztMZYXqNLsJ67yza3hLI/PIJ1jRzD
	SfMIf4Nf38zl1j0KN7WQdZW6f/QMFODeKMsHVEqoVkJ4ovdudHDMZB4E8y4WGPJIgOOUOm+Miwl
	mfPvOFoGBh1Ua6UfdSarPNdtBsuMSm8AOhGTYg==
X-Received: by 2002:a17:90b:5906:b0:3ab:3437:554f with SMTP id 98e67ed59e1d1-3adce0073a2mr1983207a91.29.1792763417701;
        Fri, 23 Oct 2026 06:50:17 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea94677c91sm545015ad.4.2026.10.23.06.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 06:50:16 -0700 (PDT)
Date: Fri, 23 Oct 2026 13:50:13 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>,
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <attmFVIFU_mS0Y7p@google.com>
References: <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com>
 <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>

On 2026-10-22 04:53 PM, Pasha Tatashin wrote:
> On Thu, Oct 22, 2026 at 1:51 PM David Matlack <dmatlack@google.com> wrote:
> > On 2026-10-22 12:11 AM, Pasha Tatashin wrote:

> > > Lets drop the fourth macro argument and generate the combined struct name:
> > >
> > > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count)              \
> > >     struct name##_hdr {                                                    \
> > >         __u32 size;                                                        \
> > >         __u32 flags;                                                       \
> > >         __u64 ext_flags[ext_flags_count];                                  \
> > >         struct name payload;                                               \
> > >     };                                                                     \
> > >     static_assert(sizeof(struct name##_hdr) == (expected_size),            \
> > >                   "LUO struct " #name " size mismatch!")
> > >
> > > For example:
> > >
> > > struct luo_memfd_ser {
> > >     __u64 pos;
> > >     __u64 size;
> > > };
> > >
> > > DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);
> >
> > I think we are getting close, bu I have two remaining concerns:
> >
> >  * Reserving bits in each flags word for continuation leaves gaps
> >    in the flag space that users have to know to skip.
> 
> Yes, but callers should never manipulate the raw flag words directly,
> and we can provide simple accessor macros or inlines that take a
> contiguous feature ID (0, 1, 2, ...)
> 
> enum luo_memfd_feats {
>     LUO_MEMFD_FEAT_HUGETLB = 0,
>     LUO_MEMFD_FEAT_SEALS   = 1,
>     /* ... */
>     LUO_MEMFD_FEAT_FOO     = 15, /* Automatically lands in
> ext_flags[0] bits 0:1 */
>     LUO_MEMFD_NR_FEATS
> };
> 
> if (luo_ser_get_feat(hdr, LUO_MEMFD_FEAT_HUGETLB)) {
>     /* handle hugetlb */
> }

Sure but why deal with all the complexity just to save 8 bytes? All of
these structs are allocated on folios and there are kilobytes of unused
space to fit this header. And even if we optimize that we are talking
about 8 bytes per FH/FLB... or 16 bytes for structs with arch-specific
sub-structs like the KVM ones.

> >  * struct name##_hdr only matches structs written by the current kernel
> >    (in terms of length of array and offset of payload).
> 
> This is not an issue on the incoming path, we never cast incoming data
> to struct name##_hdr or access ->payload directly. Instead, we parse
> the incoming buffer, dynamically compute the header size from the
> continuation bits, and cast the payload offset to "struct name *"
> based on the negotiated feature flags.

How?

This is the only data structure that describes the header. Are you
saying the incoming path will parse the header purely with a void *? Or
use this header but just be careful not to access payload?

We should have one header structure that can be used on the incoming and
outgoing path. We should not have one header data structure that can be
used on the outgoing path and one that can be used on the incoming
path.

Also we need a standard header that can be shared across all structs,
not a per struct header. Otherwise you will need to do weird casting and
overlays to implement the shared helper routines that parse it.

> > How about this instead:
> >
> > struct luo_ser_hdr {
> >     __u32 size;        /* Size of header + payload in bytes */
> >     __u32 nr_flags;    /* Number of features encoded in flags[] */
> >     __u64 flags[];
> > };
> >
> > Each feature occupies 2 bits of flags[], so feature N is always bits
> > [2N+1:2N] of flags[N / 32], with no gaps:
> >
> >   00: Feature not present
> >   01: Feature present, safe to ignore if not supported
> >   11: Feature present, must be supported by the next kernel
> >   10: Invalid
> >
> > The length of flags[] and the header size are computed directly rather
> > than by walking continuation bits:
> >
> > static inline u32 luo_ser_nr_flag_words(const struct luo_ser_hdr *hdr)
> > {
> >     return DIV_ROUND_UP(hdr->nr_flags, 32);
> > }
> >
> > static inline size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr)
> > {
> >     return struct_size(hdr, flags, luo_ser_nr_flag_words(hdr));
> > }
> >
> > static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> > {
> >     return (void *)hdr + luo_ser_hdr_size(hdr);
> > }
> >
> > and bounds checking is just luo_ser_hdr_size(hdr) <= hdr->size. The
> > payload is always 8-byte aligned.
> >
> > Payload structs are then declared on their own, with no header:
> >
> > struct luo_memfd_ser {
> >     __u64 pos;
> >     __u64 size;
> > };
> > LUO_SER_ASSERT_SIZE(luo_memfd_ser, 16);
> >
> > The static_assert covers the payload to catch embedded structs changing
> > size.  Asserting the header doesn't add anything since its size varies
> > by kernel. And because flags[] is a flexible array, the header can't be
> > embedded in front of a payload in a combined struct; it can only be
> > reached through luo_ser_payload().
> >
> > I think the only downside is that the header increases to 16-bytes when
> > there is at least 1 flag. But I don't think we need to be so concerned
> > about an 8 byte difference...
> 
> I would prefer to keep the default header at 8 bytes. With 15 features
> fitting directly inside the base __u32 flags word, adding the first 15
> features to a struct keeps the header at 8 bytes and does not shift
> the payload.
> 
> Computation-wise it is also very similar: for the 99% of structs that
> have <= 15 features, LUO_FLAGS_CONT is 0, so computing the header size
> is just a single bit test with no loop. Even if a struct ever needs
> ext_flags, the loop will walk at most one or two extra words.

Please explain why it is so important to keep the header 8 bytes that we
have to jump through all these hoops to map a contiguous flag space
onto a u32 + u64[] array structure where certain bits are reserved and
have to be skipped.
