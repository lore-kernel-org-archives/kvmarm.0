Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792641087;
	b=oLbPiEyFjcwObwWBT7zZ0WVs/ZbiM3sXOluMELz+gzE774xDyFVC9lm5PSOZ+xYwuLZI
	 RFjD+XQIoZ/7yrRTOUodnt8luX8cNzMcXatCPCqoZaCtpoxzgJetVNqgo80DyfktbYsBz
	 obl2CobcyomgvpTFxIO5NjSKd3iPqWzx7jE8coABXJ5SJ023tFC6PYvwI16xlaiQnAddS
	 aAZQ6jmrz8LgqyMgsRN2BCN3c5DDE9PrCExsUHJUWy0q3gWcWSyc9DTISoFu1HKdmE4zF
	 oKFx8Kk8sclz526D4oigVYBIYY2AbAQ362p2PWigYWvq51YBI5U9hdnMhsCKLTtXRSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792641087;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3R15WlwvcCDjwHgI3tMxUhnF1Vz0ctYaUW1v5Utzjsw=;
	b=wEsGkiogybDjn6ePo2WgTK/lCO7veJwaXHm5A/Cj6VyvU8CeASMpCDAGB3a5QUm+iQH6
	 g1ERi7+dpcUewZSwuAIhDak+kBsnSETxKjeOYnIbuWoZP6v+vnfCm9EDtxkX4ulS6hS3+
	 qIYxzLFaPNV/5SuCHTlR+O976bbtvEnx1XIOMViuCt8q+0Kzv42eMmNu8ZCIgmqpYGMzu
	 Pt4+k+Ug7AkjYJ/BSyJMoNEzpmqOLeBoRKzVo7So46ICi/rUzB/C5AHzPLOE0MQSaIrFf
	 Q89eM6VvyHL9agJEnk5+0BIh5t7Lm3+7tDPFCFVUdeDrZ9d3Mo/LyxsFnNKZKd4FnQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=a715fJQH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BEB606A320
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 03:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44BEB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=a715fJQH
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b21cf1a580so1405453a12.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 20:51:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792641086; cv=none;
        d=google.com; s=arc-20260327;
        b=sGzkYo592lQRKls9PwiSWBnEpAcNmUIyvgWVu2NAIGtJKv5P0bUdG+faFjb+0FhJgs
         ecnqAOm6HmB28/UlcIfb8cJCwTsLg5WLMX2Fm8DDjGCfGGvzpi2gnL0R5E2gIFWJMKup
         U0PflY+iQVmRyo6mPn3JSx7wUPc++iAGQ49NjTgfdJPHK7stxoJxwrNILk+3BPGzNLnj
         pneBvctvvhqwwzzVlwzNBhQ+/9wruehUogB6gWP/p83yWBJnJvw+qdqAvYRkMPRR9Vnh
         s/vIqrjyCoXt1vNAd+0rDU5bjMjr8GFXJgZg1DGAeXXuKF/fsljulJtYq5gxRIO5xSUo
         eTQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3R15WlwvcCDjwHgI3tMxUhnF1Vz0ctYaUW1v5Utzjsw=;
        fh=Vl0O20kNU2VsuC06kzdPYJr6tmlWqATq1mikp/b7M0U=;
        b=ewnMwaUcesmmYT8zDGssMG39BFwJg6Urh2iVhfvw3InRZtkX3BmoLBN6wYDBGdr7BW
         aaKubVJ+Q3cqq6CexVzQtEmN0A4NB9WEx3Ms68mBHAfK20yf7SIKvt1Zoh0qiPUc/klQ
         P84Je1ZsHNl7zhGENdc23ivWzP8m313J0kSnKQVDnd7TcDpNz796CBNEGc0kM2zD4Fq1
         XjaJDCR+UKM3SxuIQ38gtuXm6Ns7P+XQmytCmR5p23rlCTAuHD3jXxRIrORN0PvD3Nty
         Uw56BKpYfhFoODybjbN3mQ/a2z/v78MV88TQrQAJLA44JYLlmM5t16FVyO1pSy3YHxAR
         IJwg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792641086; x=1793245886; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3R15WlwvcCDjwHgI3tMxUhnF1Vz0ctYaUW1v5Utzjsw=;
        b=a715fJQHuh4CRLFlp8uwpIvOIkjgCzjuB1gki0xJj1eVRcxfbMTn6aMM7O0hNUTlYt
         K2TJarYvDWRzoy2ng6Tu3CucqYhCSX+2tpIyQAmaMjbYHwy1zMT5pimZcNpJ33VXyjOR
         uB9/VbXv5whlJVaz0CAr9SvDG4fIqkqkCLuhHObKnmoIvI16kElXxofcI8ZDnnOdkKhM
         b8ABupWP2zKJYo1CqnlkPIFl5rn6qBhG7ScV9k3FV26aytvLY2x1LCbX5BFtcz1knQoN
         Im6fidlGeV9XRDOGhYY+TbxhTk3OnpOSCpIc8LCWts3Xuekey1+xZSIlrSKDDQdkdyS3
         sk9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641086; x=1793245886;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3R15WlwvcCDjwHgI3tMxUhnF1Vz0ctYaUW1v5Utzjsw=;
        b=QYOKse3sPdrglkB0V0oEIQeZvA3B/uu1eWnZYyDCoxUl0fXa29TIcjgGPpuAKQBhTI
         zSdIkZiZkMd80vlD0R1n1BNtF6uzk5MMqjH+MJmairyKqFEMr0vxNF0SKZwHWOagkzDO
         WWZVIGXrtYPqQW4EGffqzPOoO7MgUCT4cJUjKZxZuD7xWAk7kR1LKPmMrNpgp1Lo1ox6
         RfJ6KJcA4KPPXPrfT1BQJz5dSkVlSJp1jgG8s6wEaI14HDftzKdjq57+juYQF1G1AYHp
         RskyseWYTTMk8F4CBrNXV9WVE1DY6F+lyuWK0FPwCWTXbC0fTK3ECsa1n8815I1BOLA1
         qBKQ==
X-Forwarded-Encrypted: i=1; AKwUvByCN/ub1Ztw1mCehnZ9bP8tLypGCmbX9K1ppkbBe3mGPO2Z168dEYREkGIzL5jGl5+ZTG5qEWg=@lists.linux.dev
X-Gm-Message-State: AFq9FYJizIqEW7h3FOdSnwvtuMgfYnqABJdDKMI0oh+sdiqv/QUw/vwk
	rgfRwJrJpTCGjqvfazNP3UuYjfUqTkgimCWqtC1jDRdekQoNL9ocU1b8wZ7A8rbcU5oCGZyA0iM
	T2jLKSayeNpJul5RrZKYNDy/hAfAXM7u51jRtOv//UQ==
X-Gm-Gg: AYBFou1+G6pqzBTD4ezxw+zfUg4IHxRbStjqDm39o2XCkrDl389fm36hp0ko1RBAjkx
	15nM7j6yhYr9oM412ifZOLucFspeJFB4btJE0qy0xfipDLQwB+gbmGeC8GyY/nHj7gREQNfvBOe
	NTHbCWtXK+QnRWQ5PPVP1SndvUAx/KThh9ND2X3FaI/rL2e2CEDKyYANOQN3EYwsTtBi9HOaglA
	ICO4Mx735v6z4BwjNu/8dvR97ycAddJSIOL78J3mhSdJ9cMuEGBxnovk+zMibmEYXTzIfPsV/KM
	PNJ+tHE//knTMkwjciHt4Qm1PuOycmyeJ2cKf7B/MPxVaz5Bmp1DI04UtDS2TeNsKLg/Asp8dF3
	rbzjFakvz9LPwGj6idWn/J7XkGX7dqTMxsQahpDwBI1csBHAyEoexWeBBkZW7qvKJyW8=
X-Received: by 2002:a05:6402:400b:b0:6b4:2185:7147 with SMTP id
 4fb4d7f45d1cf-6b4218572dbmr568868a12.15.1792641085570; Wed, 21 Oct 2026
 20:51:25 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-5-tarunsahu@google.com>
 <CA+CK2bCWo7ixrNLKPvqETn3JSFwSNaB2UsPgy9RHVAhWroJURQ@mail.gmail.com>
 <atlINfvlXY4wMbpO@google.com> <CA+CK2bDf-pKbH2J13mRYRT7Ddj-Q+VXaGYePs+E-azSWXKzV5w@mail.gmail.com>
 <atl6K2Juy6Bh29lh@google.com>
In-Reply-To: <atl6K2Juy6Bh29lh@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 23:50:49 -0400
X-Gm-Features: AclHuK9es7KH6zjO9m5YDGIDDY6Onq6kZ5W4q1tuNZUyMat9PK3sQU18xuWoZac
Message-ID: <CA+CK2bB9xoAWP0kC+KtXeDTdwt0kWqb-PLHN=6DsA=mnRpMfxA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
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

On Wed, Oct 21, 2026 at 10:51=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2026-10-21 08:41 PM, Pasha Tatashin wrote:
> > > > >  /**
> > > > >   * struct memfd_luo_ser - Main serialization structure for a mem=
fd.
> > > > > + * @features:  ABI feature and size header for memfd_luo_ser.
> > > > >   * @pos:       The file's current position (f_pos).
> > > > >   * @size:      The total size of the file in bytes (i_size).
> > > > >   * @seals:     The seals present on the memfd. The seals are uAB=
I so it is safe
> > > > > @@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
> > > > >   *             struct memfd_luo_folio_ser.
> > > > >   */
> > > > >  struct memfd_luo_ser {
> > > > > +       struct luo_feature_hdr features;
> > > >
> > > > I have not looked into this yet, but I would prefer to use some kin=
d
> > > > of macro constructor for serialized structs. That way, they will
> > > > automatically include the header, making it easier to search the co=
de
> > > > for what is actually preserved versus what exists only in this kern=
el.
> > >
> > > If you want to know what is preserved don't you just look at
> > > include/linux/kho/abi?
> >
> > Yes, and having it initialized and declared in the code correctly with
> > proper macros and verified just gives the right handling and avoids
> > making silly mistakes. The second reason is so we never forget to
> > include the header, and to make it expandable and easy for everyone to
> > use. I think this kind of constructor is just useful overall. Are
> > there any reasons why we wouldn't want to use it?
> >
> > > > So, I think something like this:
> > > > /* Base serialization header: 4 bytes total size, 4 bytes flags */
> > > > struct luo_ser_hdr {
> > > >     __u32 total_size;
> > >
> > > Why do we need the size? I'm not really opposed to it I just don't
> > > understand what problem it solves.
> > [...]
> > > The luo_ser_hdr is needed for top-level file handler and FLB ser
> > > structs. Those structs are always dynamically allocated and preserved
> > > with KHO.
> >
> > The top level is not enough. I think it is needed for every single
> > serialized struct in kho/abi - the blocks, the FLBs, etc. They all
> > must
> > be expandable in case we need to allow that. Let's have future
> > protection for everything that gets preserved.
> >
> > For example, take a look at vCPU preservation:
> > https://lore.kernel.org/all/20260920193650.3373435-9-pasha.tatashin@sol=
een.com
> > https://lore.kernel.org/all/20260920193650.3373435-11-pasha.tatashin@so=
leen.com
> >
> > +struct kvm_vcpu_ser {
> > +    u32 vcpu_id;
> > +    u32 flags;
> > +    u64 vm_token;
> > +    DECLARE_KHOSER_PTR(arch_state, struct kvm_vcpu_arch_ser *);
> > +};
> >
> > We might want to add fields to the arch-independent part, and we also
> > absolutely must keep the arch-dependent parts expandable. Therefore,
> > the header needs to stay small and flexible enough to grow as needed.
>
> Hm, anything that is dynamically allocated can have it, but anything
> that it is embedded directly or in an array cannot, because those
> structs cannot grow anyway. So I agree it's not exclusive to the
> top-level FLB and FH structs. But I would push back on any a mandate
> that _every_ struct in include/linux/kho/abi needs it.

OK, we should *aspire* to convert as many serialized structs as
possible to the versioned format by default, and require a very strong
justification for any exceptions (such as tightly packed arrays or
block set entries). Even in those cases, we should be certain that
omitting
the header saves meaningful memory and that we are not shooting
ourselves in the foot if we later decide to replace those container
primitives or need to evolve the entries independently.

Right now, shared serialized primitives like kho_vmalloc and
kho_block_header_ser do not have proper versioning at all, and because
they are used by many clients, updating them is already problematic.
We can't simply rely on top-level FH flags to version everything:
since these primitives are shared across handlers, any change to them
would otherwise require updating every FH that uses them.

BTW, since these primitives live in KHO and all the ABI headers are in
include/linux/kho/abi/, perhaps this header format, versioning, and
the declaration macros should be part of KHO rather than LUO (e.g.,
struct kho_ser_hdr and DECLARE_KHO_SER)? Then LUO would just focus
exporting FD preservation-capabilities to userspace, as it deals only
with FDs, not internal representation. There should also be a global
switch that shows the KHO version the kernel is using, perhaps via
sysfs.
