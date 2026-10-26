Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793047748;
	b=SmnXn7yqRt8Ga3RGuCwpambyIRYf8k9jfkGjIY5QZyuUV7kb9EGu+qpa9ZDmtt6pV+gm
	 I4oPTiPWIw5tTusjVA/f78VelwomWbVZ+h7IwPG2tL0BsXVosbO0i+OmVc8i9CYieDXQz
	 VbvnfwUWEVilDyos9qm07XZg3zsh1y8TerTOOWsjWOwgdCXHUgfH0ZL7yMDgSohRAE/wg
	 wEXOVEgUvSvCSXpQM1OGXw2BwASXXFIi5/hxxAvIOGDMCKPRVZWg77eIOSKz9TjwKwO9a
	 GJ4AYf2hMM/cLxq22b4DwprD9HuzGya3n+5zqgLLUkOD81bSFMbuYdnXGI9tKGnAvrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793047748;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=PJBAWhG3vQY26e/Nvx85KnaVoYI7FZuNNNc/vdxGNMI=;
	b=qZVq79g/pR+vIPgK/5YNwoxBehoSGkAzafApWAov6tHLsFSEpeHUcrm3MTXa3n9Cum7I
	 fR/2p8RRvMNHiY2T4BFK7aR5lhVnaeoxabgGRF5OQehuqyRBfz4sfHLMf4qz0oq913zib
	 DiX4Gnzy2Se+r+Zm1ijxQV8cEGhKlPsqFkFpSvk8gUfZsnfiwlZ9D0qgYX/0D2XBmqAY8
	 QnTxjOYXF5Ms3yGMNYSkuYjoUWyfYf7N7CxGXEpuhJsYxLwAD1rW65rPn4ckbd234wTLN
	 McWsk4ZVEHaMkVCnrUhD+PB5AbukMJoVZIZ/u6eOB2s+8OoQSKCPeXIyXpGLtJAq71g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=I8ny2eYf;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F71606A31A
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 20:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7F71606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=I8ny2eYf
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc758830601so2128725a12.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 13:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793047747; x=1793652547; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PJBAWhG3vQY26e/Nvx85KnaVoYI7FZuNNNc/vdxGNMI=;
        b=I8ny2eYfD63YuoznNBRnaqrylgyuo6hQ0ejior0CkVNnOBtKspgH/HWTSch8ITj0aR
         k22HVJR/28xS1aRLIy6WmRYZb6+0+HiqBQMffwo8NZvKtuFD0TJMC8pVnNSkgaqGOyFU
         MskxXN/GAnyryur/vVOAsZNwpkDq0kKCWp6eWyrvS+8+mSPKkVcEaYRUXUOBVWTfB0EC
         cC9jPgBjPXkupOx5LlPVloHK7ST7D7WLOu5RXqeq3RiR939D7v//HcI7HVPbkVoVqqAt
         CpHdtoINveo37GeLvoU7P8W3Zg7OBE+6yw+8OQe7LXYnY7qeIR8XJ26uUPn/+r7XK6Wg
         7fzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793047747; x=1793652547;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PJBAWhG3vQY26e/Nvx85KnaVoYI7FZuNNNc/vdxGNMI=;
        b=Ld701QlCx4OSitfBaLNUQN8hFzJ68YbO9767cbRVoq57Fq5wBG9uu9ZUtiZLCYwL1y
         c7Sp8n17h5g1+1MMXsgar+VkHGfedZ/xc8uaHyO1DBNHxFZshmAcJnrJWPmsmE2gbDXR
         aDMldJ3a8+izL5wbmJOucpxvHWmCHMomG2ZQlFgBlPmuHsAHKeArHiC/JonZYmv6YUeY
         1iYn69zQl7upivm3JV4a4LZVT8fTL+puL5BxGon9sdaUjGB0R/aHYhtYX7PlR5TsdyP2
         sEKo6OcmvrHyRFsUH5aGAUIrTf3AgeVTDaem2Ev4OtA/AFdpTOsR5oQsZKBI/ziV7xuD
         dUFQ==
X-Forwarded-Encrypted: i=1; AKwUvBzPQf3QK8CaJRPdflPmxqz2FZWLU1HMVn5fkD2KG4MCgZm5oK5mK0yXp9G90L9O/7l6Qyp0be4=@lists.linux.dev
X-Gm-Message-State: AFq9FYKoL6LO97mpL8TCJc/kc9lq7VHq8NNUVTmMicR4fHtRcQkcA7Uh
	NNmaTJtT+bP0++uBJNJVUBu9S9GHKFuvGsbqeMaMfqiSu4xvzVRuUSjWD/SXpdcVuA==
X-Gm-Gg: AYBFou0AKTSVSpO1MkugTS2QlHcQHIspEzzAiryyTVfqoEJEzktDs2PXpmB9Y7qX7nA
	wPFfxeVGbIV5KgSb4bjF9pGbbUz8pz9K1xIfNbNUDPpqe3w2rPy5zbwVFzdAgFjfz9lSBdLmxlV
	YEztFW0yeFniZLlfE5yWQ87e6F+3tVXVkqakpnxACdDESTU5dn2SCUmUmoUrkSSrLoy0BlZH2lI
	X/AVD6s03UhrE5+X3uOsO02+q5fiNVH1hHXqxEmLYFlC2p329B2v2fnht59UeTV/VklIGZZQz6i
	zG70OmeLJE+2JCnMg7q6582q/iq7IAvl9LXU47baDcwqGIYYyVGzsnfcqscNAE2Z8DjmIlc1RlS
	RCaNr6m/9MFEh4uosU+iY0TKsPcA7yk+rMRJCeSV01OQNviC9nqQBQtqjx2WR0i1G0LvnSzdlj6
	VycEf0j3R+vsDzCy1t6hA/LxpSv1qrE1m57OJj17aPX9ZZraTAGJdH83iisETU7zOG9w8o2Lw/o
	UXfl3UbmtfRXHUMHvRdoqpZVxYZb6hLu7liCYm13iNSz2oQfQreE2Q72oOQ1JyKlaqYwnkh1l1n
	u+1TrqATM/eNUG5o
X-Received: by 2002:a17:90b:5105:b0:3ac:9176:e81c with SMTP id 98e67ed59e1d1-3adeae76765mr6903041a91.46.1793047746368;
        Mon, 26 Oct 2026 13:49:06 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4066aec8sm743744a91.15.2026.10.26.13.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:49:05 -0700 (PDT)
Date: Mon, 26 Oct 2026 20:49:02 +0000
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
Message-ID: <at-8vkVpN2SF3XgB@google.com>
References: <atlKsD-aJB3mJr2j@google.com>
 <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
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
In-Reply-To: <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>

On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
> On Fri, Oct 23, 2026 at 9:50 AM David Matlack <dmatlack@google.com> wrote:

> > Sure but why deal with all the complexity just to save 8 bytes? All of
> > these structs are allocated on folios and there are kilobytes of unused
> > space to fit this header. And even if we optimize that we are talking
> > about 8 bytes per FH/FLB... or 16 bytes for structs with arch-specific
> > sub-structs like the KVM ones.
> 
> The reason I care about keeping the header compact is that we are
> defining a foundational kernel ABI and want to use this header across
> almost every serialized data structure so we can evolve them later
> without breaking compatibility. While some top-level structs are on
> sparse folios today, other serialized structs are tightly packed, and
> we are looking to add KHO slab support in the future where tightly
> packed allocations will be common.

My intuition is we will have a small number of headers per preserved
file and per preserved FLB. One for the top-level struct and then
optionally a few more for sub-structs like arch-specific data. That is
why I am less worried 8 bytes per header, even if we fix the folio
problem.

Maybe where our visions differ is when there are collections of
serialized structs, like KHO blocks. For collections I don't think the
elements will each have their own headers. Otherwise the elements could
be different sizes.

Instead I think the struct that owns the collection will have a header
that includes features for fields in the elements. The header defines
which fields in all elements are valid. The field contents then convey
the per-element information (which might include 0 or -1 values to
convey this specific element doesn't have this data).

> That said, in your proposal, as long as nr_flags == 0 is allowed when
> a struct has no feature flags yet, luo_ser_hdr_size(hdr) is already 8
> bytes and only grows to 16 bytes on the first feature flag. I am OK
> with that.

Yeah the header will be 8 bytes until the first flag is defined, at
which point it will grow to 16 bytes.

Great, sounds like we are aligned on the header. s/luo/kho also sounds
good to me.

> > > This is not an issue on the incoming path, we never cast incoming data
> > > to struct name##_hdr or access ->payload directly. Instead, we parse
> > > the incoming buffer, dynamically compute the header size from the
> > > continuation bits, and cast the payload offset to "struct name *"
> > > based on the negotiated feature flags.
> >
> > How?
> >
> > This is the only data structure that describes the header. Are you
> > saying the incoming path will parse the header purely with a void *? Or
> > use this header but just be careful not to access payload?
> >
> > We should have one header structure that can be used on the incoming and
> > outgoing path. We should not have one header data structure that can be
> > used on the outgoing path and one that can be used on the incoming
> > path.
> >
> > Also we need a standard header that can be shared across all structs,
> > not a per struct header. Otherwise you will need to do weird casting and
> > overlays to implement the shared helper routines that parse it.
> 
> Having DECLARE_KHO_SER_WRAP() in include/linux/kho/abi/ makes it
> immediately clear just by looking at kho/abi/ which serialized structs
> have the versioned header and which do not, while also enforcing the
> header when preserving and static-asserting the combined struct size a
> compile time.
> 
> So with your header (and let's use KHO as we want to version KHO
> structs as well):
> 
> struct kho_ser_hdr {
>         __u32 size;        /* Size of header + payload in bytes */
>         __u32 nr_flags;    /* Number of features encoded in flags[] */
>         __u64 flags[];
> };
> 
> The wrapped struct will look like:
> 
> #define DECLARE_KHO_SER_WRAP(name, expected_size, nr_feats)                \
>         struct name##_wrap {                                               \
>                 __u32 size;                                                    \
>                 __u32 nr_flags;                                                \
>                 __u64 flags[DIV_ROUND_UP(nr_feats, 32)];                       \
>                 struct name payload;                                           \
>         };                                                                 \
>         static_assert(sizeof(struct name##_wrap) == (expected_size),       \
>                 "struct " #name " size mismatch!")
> 
> On the incoming kernel we don't use struct name##_wrap, but we use
> struct kho_ser_hdr for the wrapped data, validate the flags, and
> unwrap it via kho_ser_payload(hdr) to get back the struct name *
> payload type.

I still think it's not advisable to define name##_wrap since anyone
could accidentally start using it on the incoming path and we wouldn't
notice at first (especially since same kernel Live Update tests would
keep working totally fine). I also don't think asserting the combined
size buys us anything. The header size is just a function of the
number of features, and what we are trying to protect against is
structs embedded in the payload changing size.

So I would just do:

  /* Marks struct name as a KHO serialized payload with a kho_ser_hdr. */
  #define DECLARE_KHO_SER(name, payload_size) \
          static_assert(sizeof(struct name) == (payload_size))

  DECLARE_KHO_SER(luo_memfd_ser, 16);

Plus helpers that allocate and initialize the header and return the
payload as a typed pointer. Both the outgoing and incoming paths find
the payload the same way, by computing its offset from the header,
rather than through a struct with a fixed payload offset:

  /* outgoing */
  hdr = kho_ser_alloc(luo_memfd_ser, LUO_MEMFD_NR_FEATS);
  ser = kho_ser_payload(hdr, luo_memfd_ser);

  /* incoming */
  hdr = phys_to_virt(args->serialized_data);
  ser = kho_ser_payload(hdr, luo_memfd_ser);
