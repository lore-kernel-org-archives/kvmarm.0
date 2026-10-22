Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792691489;
	b=kzsuQ3oQRhf/E2pcCtQthdSfmTdH96bYCV66ZftxlEvPFdQkQwlp7LyovO8Y7zKlm+xf
	 mxlOV2+SjpZtkn9H69L7rhFYm75m4/FwU9v6wM3R2gNVqbkseF6Yfl/pfngWBU8sMki3U
	 Jn9ovcTW23NoxJxAJg3IB2aFATJtSvNj7XRWpCSJUC/zp7rrR4Moi+VMBQT6VWnrmNc16
	 TuToyKu1J8OTBI9tU3OnV8orYHLU6AKfpJ61lEy1zgAAgexPwPQVFPNitvv83vJx/QXhC
	 vl5qH2pZtv55MMHBviZe5FMDDBFl6+UyRPiqLbLb1g4iccIjLxUknzR68BsAZk2OcrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691489;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=VXuE27163XQs95Y17MHXQoRtZevE9c0I3KUjJaU7M5M=;
	b=2dpT8Cz/hygPGLHjJn9NGegJv+/9AfssfZzS6d9tUDgY4mpdwRg10LWVVf5//3tO423v
	 Ws5Eqy9oKaJPa2WtzIPQMoEy2Jp0DEKRabYTJHG5BSBUhuhRY/kk2d2x0Ht5b7/22AN4X
	 KHp/2C9AWTu2vP+huhxBWOBD8usLoUL4yEI+evTVbtCo1jOVx+dvrPeLybva5r/rLPyqL
	 eChShcOALGj+mvfab2ql/JJxL0OvrK6iO0AiVvVX2N7WIurUYtEp1x2HvyWmCSd2KWrHY
	 5OnyGud6Vv8givwz+Kk9JQCKwS4uxmD2xtTfewqUWwAvJy0DtWkMu6rKfdLuoS/NfMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TBgrbX1y;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD1A606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 17:51:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BD1A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TBgrbX1y
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e942864693so47385ad.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 10:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792691488; x=1793296288; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VXuE27163XQs95Y17MHXQoRtZevE9c0I3KUjJaU7M5M=;
        b=TBgrbX1yxNdsXs0ict+2hvHbftTXP6LRYcqzDPHNSKX3H98VcRFGL+MsKFZRrAAwGz
         20OFOzAgroaEqg3OJafvEOClqEBesOz4Gv/2btxg8I8V91rWOAwv5pwHIyTBXkhooz1x
         QbAakak/gyQ4Wy5OnxSEhR4vrGJPw/oGsY9KeVntB9H/YPB+Xj/pWV9JWaLm8BUuj/bD
         zQZ3+tkLpNesy7A7DkMey1Fo6wWLjVr4sBz1jxYLnjMy+F8vZUGHivisWwVQOJwM0FVz
         1x5wzvhxce3QGXQVf5WAeY/fd7rwr/jqrNrtz3Xt/v3PyrkycNERDJfN4xyOt5/R9Mka
         9PqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691488; x=1793296288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VXuE27163XQs95Y17MHXQoRtZevE9c0I3KUjJaU7M5M=;
        b=blwgDEQjAw63WSfiFp39+JxooYye4XBIi478HNbxyGDuVxoOe0mrsG4jCLg1oe3lXN
         Nx/dlk3AdsDEp2m7nJGy+tVAyA7e0mTlYyUe6rxiNTA+fl36GoAwXMT2kzSFoMKH0q4p
         lNbc5hhlV1KQB6eOE+Z/XxB+DOkHAEdO/x71vXm9UCHoMhijsPrK1z+06qHnfPLf2N+0
         49vrCIZrrkbmtXznewYFGokOneXDgMOKI/aMQkyckCjPcMGXCThaTnz/TGQCyhXy5Ovh
         lRpHCK9AnKc1Sm2Ssc90THC3O/hj2EGvAXOdIuNIFllc+wOROLDqFbtL32LgFPCZXaaT
         IjZA==
X-Forwarded-Encrypted: i=1; AKwUvBx+ufr7V5mKik/dCGnVbJ9OoLbrXT0VbSPbuCtw/zAX5nLOcK4sJe51Mvu6NfAfG8vt0tVXuT8=@lists.linux.dev
X-Gm-Message-State: AFq9FYKDsrmS8x7ugJZl8rGLVNBIKSbL5LsyUDL7lAYG43J0XoLQJ/PN
	0dDptMErFurYdCMOWe8eVpsjEKo47zwM8+u8vov4JTcU5FhvZKgMl+1Mvv5ZcQVz5w==
X-Gm-Gg: AYBFou2NH5kvD9htpw7QohizUSWUMsEwJul8+VwpffZ8/N55i0fP8BXgbnPSJZU+BhS
	yX1L23tgQk+ff5bxs3EiWGgBa/PT06Yhe4q3h2S/UUCuiWjg1PxHxE1UDvQ4GvubBrtSx6dS2pC
	9WeVQdC6z07cheMDzzLl7Q4w6dH1T94m1CLSWc4KAIkWIO9dfaupCwvJp9hfbem7sPzVD1cnHVW
	XUOAZ8tmmzZyLruLSKNbWn48thiyoJN9sEWZzFWprEOKUBU3IaLfXoueWc1ry0h90VbxQFL9YZq
	Jp7W8f9KpVvqhGXcJIsI9QG6Yc9i5RLL42QtImljg8e+ZEcCKHzvD6FNqsRr2J70Jz63kX4SKVL
	dS3ZE0kY9Qp6eeO2ABrP51jET6Y6t61EH6sm+sWaiVeDkTuJ7RhpFdEUlVEPw77n/IqUAB6GlL+
	Yq3lynwtc9J09nEirjGqpAl6+62GKvqubBUw/gDWu7MTQ8P9kIYr3cHStZtxKqkXpNB0wywsZZn
	/O7HyUx3it/Qf/WJKRXs8OYDfzWvI/qnEOvNIFSZ0OHDcWztxYk729AM/I7a6Hzabxr0qU5+ChZ
	EKpnqGy4AHNTIg1N
X-Received: by 2002:a17:902:e547:b0:2e9:502a:ddbb with SMTP id d9443c01a7336-2ea43c9f6bcmr53298445ad.45.1792691480085;
        Thu, 22 Oct 2026 10:51:20 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b346c43sm1644745ad.13.2026.10.22.10.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 10:51:19 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:51:16 +0000
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
Message-ID: <atpNFEFIlqAoYIwH@google.com>
References: <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com>
 <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com>
 <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
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
In-Reply-To: <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>

On 2026-10-22 12:11 AM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 11:53 PM David Matlack <dmatlack@google.com> wrote:

> > > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count, payload_type) \
> > >     struct name {                                                           \
> > >         __u32 size;                                                         \
> > >         __u32 flags;                                                        \
> > >         __u64 ext_flags[ext_flags_count];                                   \
> > >         payload_type payload;                                               \
> > >     };                                                                      \
> > >     static_assert(sizeof(struct name) == (expected_size),                   \
> > >                   "LUO struct " #name " size mismatch!")
> > >
> > > For example:
> > >
> > > struct luo_memfd_payload {
> > >     __u64 pos;
> > >     __u64 size;
> > > };
> > >
> > > DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);
> >
> > This looks pretty reasonable but I would name the payload
> > luo_memfd_ser. The combined struct that DECLARE_LUO_SER() creates
> > should never be used directly since the offset of the payload in that
> > struct is only valid in the current kernel. So I would give that
> > struct a special name that makes it obvious you shouldn't be using it.
> 
> Lets drop the fourth macro argument and generate the combined struct name:
> 
> #define DECLARE_LUO_SER(name, expected_size, ext_flags_count)              \
>     struct name##_hdr {                                                    \
>         __u32 size;                                                        \
>         __u32 flags;                                                       \
>         __u64 ext_flags[ext_flags_count];                                  \
>         struct name payload;                                               \
>     };                                                                     \
>     static_assert(sizeof(struct name##_hdr) == (expected_size),            \
>                   "LUO struct " #name " size mismatch!")
> 
> For example:
> 
> struct luo_memfd_ser {
>     __u64 pos;
>     __u64 size;
> };
> 
> DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);

I think we are getting close, bu I have two remaining concerns:

 * Reserving bits in each flags word for continuation leaves gaps
   in the flag space that users have to know to skip.

 * struct name##_hdr only matches structs written by the current kernel
   (in terms of length of array and offset of payload).

How about this instead:

struct luo_ser_hdr {
    __u32 size;        /* Size of header + payload in bytes */
    __u32 nr_flags;    /* Number of features encoded in flags[] */
    __u64 flags[];
};

Each feature occupies 2 bits of flags[], so feature N is always bits
[2N+1:2N] of flags[N / 32], with no gaps:

  00: Feature not present
  01: Feature present, safe to ignore if not supported
  11: Feature present, must be supported by the next kernel
  10: Invalid

The length of flags[] and the header size are computed directly rather
than by walking continuation bits:

static inline u32 luo_ser_nr_flag_words(const struct luo_ser_hdr *hdr)
{
    return DIV_ROUND_UP(hdr->nr_flags, 32);
}

static inline size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr)
{
    return struct_size(hdr, flags, luo_ser_nr_flag_words(hdr));
}

static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
{
    return (void *)hdr + luo_ser_hdr_size(hdr);
}

and bounds checking is just luo_ser_hdr_size(hdr) <= hdr->size. The
payload is always 8-byte aligned.

Payload structs are then declared on their own, with no header:

struct luo_memfd_ser {
    __u64 pos;
    __u64 size;
};
LUO_SER_ASSERT_SIZE(luo_memfd_ser, 16);

The static_assert covers the payload to catch embedded structs changing
size.  Asserting the header doesn't add anything since its size varies
by kernel. And because flags[] is a flexible array, the header can't be
embedded in front of a payload in a combined struct; it can only be
reached through luo_ser_payload().

I think the only downside is that the header increases to 16-bytes when
there is at least 1 flag. But I don't think we need to be so concerned
about an 8 byte difference...
