Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792605391;
	b=O8iuc9G8f8PFJ0Vh77Aik56elwqVdJbHCVOxjrEZuLX7R4IInW1dmHPQjSRMooP4TsNd
	 dXk+lf0VeZZMjeCQunsv1NLe2expG92gUzuBRKraejTIVd9LtjRyAxr4rVDEEjow+ACGN
	 JlApFDhzm6hhm5CquDJGbBoiZjbx5iS6MeG90JxdzraV1ONbZK9HofWRhD32vLATTIPhc
	 ahHrGwD2GvJF+tzLDcXXXiPGNFalFUQOdVP76akx8gPN6J4+SOJ+Z4wsmePgcUJFn3qrj
	 JIee4v6ugp4HzwlcXzvo5AltrNqpoZxFrIx2CE0th+VQhGQ/SEnrzAitRZBMQAnJYLA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792605391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=l/9Q6vwSpHzLOuQcu+iZE9ek6ulZ0fAfcC9lHWm1vuA=;
	b=Gfv/olTN1BQjyQMHXXMLtvH2+LpbNq3XXJ2DMyG3lHeiAmpgU6xEQzllzzh9KuRskdyp
	 ZYi7SF8ulTp/Ch+RNKXSKmFrweoDu60suBRyR9BNh5oZK1bqqyrJrsxLFvKM5hz27bLMK
	 nDWB8XishstOl1P6KyfgKfQfH9SO+9CMYlK0dys9nC7WsHw88b6EsSGuz7PBmenHpjua9
	 QxR2h5V3eOtlPmfgXiyjggsuzWq0hWsHngcrn3nRdWFVRHSuhc8pVmteltekBI773kEWu
	 LYaXNGJMLWH+PZifeWn7F5xfDOg055kJVdscpaaPW4WLsyDINeEV2mM6foIOcRHjZ+A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=EoYq0cHw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E044606A326
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 17:56:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E044606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=EoYq0cHw
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so1702762a12.1
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 10:56:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792605389; cv=none;
        d=google.com; s=arc-20260327;
        b=GDNQs+amjusRjFgvkp9uUBZC+VIWDFOzHU3aSmGfwpP9wndnmaDExqAzkKOTzeNCuW
         PIWeg2TlodJCNaacTuXfsgSdy2+eiLq8WVibVneFAd6OLTEYekt2PuYTFRSyZFydihWq
         H15q7EQZVargOQy7JmDzFsks5BDPfaSnvjPiJtJOml7ypEdBWuYNIPu+TVgYxzyR8Hxu
         UP2TgTOSqk2Fexoa+x5GHkERaInOqYmBXpTx+a4Z+dTQG3C18zpYIS/GAuCaMjEVVWYg
         xSDfLC24wypGG/qmIstf2lajwEHVhUXC+GjFJ8jswB1DW0z1me0q5tr6cVx2YUoh9uOy
         Qc2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l/9Q6vwSpHzLOuQcu+iZE9ek6ulZ0fAfcC9lHWm1vuA=;
        fh=6MmyJx/Y6BKsjrMTOJcyCNscWkL7b5RRENX0612psbE=;
        b=ZV/1AHmULSxO0nTIzAwaKpg+5x8aYl/O/AtDO2hGhw2u+43ciTDJp7VPvTVqdWY8mC
         eUrtJbFdklCsm2XfyUV2yci2Okq5GPh9XZqmz0tHKZtAQ6YL7Nt2YesSQU66wshvyq8F
         GtSIo/rYj/yj0tG2XvKcUJTRrVi8GvBP26XJN51MpWO90ehuOtNPYD8RFh+M0aH5DNzy
         XAExLABLffqtnCqy9adqNC6/A9PkVNAYcW5MY3lcbSu8F1RoXJCP5bB29ba6VBI6IOrH
         L88rYAJ/pf4Qeovm0bfrEnT0uwFPJIwF9FSX66i3IIyG45snbvq4L2HWXUL9xGUFaywA
         S/oA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792605389; x=1793210189; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l/9Q6vwSpHzLOuQcu+iZE9ek6ulZ0fAfcC9lHWm1vuA=;
        b=EoYq0cHwrrywoSQhFH/3j1jMjJk7Uk14uTMReh+5LLX9X55/TA+FZctHD3EjrHFy4o
         +HS56mdn1VUiJIEEgNPIxpFYZpz3CZiPKlPyhe3/M2PE8SmhI65EMoee5nNXBme6Uc1H
         0skAmL1piBWcirj/MMj9TzVMSAf1BlH+GTfLg3qYAJh+MpQyvXtTUgH6E3wnk1tMode2
         BPcYUQsmsrFv8njxXSWJoyvfukZ69Xbw1262fBTnmfpy2+cWSMc8ekcE2X2Xb2k/Jzrm
         /CkwlIL30EAuZCNOXD8B41hialtGS1V5eoNZVjSuXDdSh4FrZYkYGWGR1314sLu0vV9K
         i5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792605389; x=1793210189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l/9Q6vwSpHzLOuQcu+iZE9ek6ulZ0fAfcC9lHWm1vuA=;
        b=cfq5S74VewlygIw6a9W3zCHyk9uB/vpJWYw0pppOtCN+KmPC7x91PvdE0EYwPpjQYZ
         5f/Xzc0qAlEJ8XkC1Vu7tPgDdX16Y1cry+HFSy2qDGOhElZskejyEp4QQ9C0VMQ1R61d
         xFwBiB5izMDAqP6cH9rmtvZBmkCA72BlvDi6/SpDA6EaWfhWgJMB9nNvvYeb18S9G20r
         WpWi8oaVWCW8U/Y1uhFByefMZHOMMTfKzPTIuI+s8KyAlaF4DvCShYZPAuGKcFAK5Be9
         WPghhKJPu0N9GeV/PPFOYZGOFhZZXodgVMFzZNJWYa8gLWYyeHaNUiVPsmLkqI8i7GdV
         SG6A==
X-Forwarded-Encrypted: i=1; AKwUvBw+TpspPWBJHqIU+R59BXh0SK/q2hfkJ/eWKfuSPCdXcOToI/uyxDyJzj/T/vZIWLCmxNFkGjw=@lists.linux.dev
X-Gm-Message-State: AFq9FYIftX1KmEZ9/l1ofyfhx70P3TktmHPI+oJOpTtHyaSHaCqvRcHg
	RZDmrL1AxNfrLK1pLB3bzsLfAi6dnKxDeaGM+dDJPFDLIh8awTx9Zsw3kn2KANeb6lhyy9/vrGo
	2aRC6Xb9LN82a/GacDPYAoT9LFZC9SLXukNm8qM2K9Q==
X-Gm-Gg: AYBFou29wa+VmQOi2RrimKMmh0JmnmPNDN1ot9Ahf0dT++UDtG1RwcMLAc6g0Ax20EE
	Jk55qirvTOtk0WgOHPjQhizGQSAhCppNOsSyZ7KSmm6UmMtYqAudZQNU6etKjPIE58oObyYEFo6
	4cInvmVwP7IsxH7dcF79Jg8x/iWMHabrbQGfAhsKW9pOWlQ9d+RYW1klFgAI6uJMBrFru/4+QsA
	4Kp6hFjWTbC/M+hkgRPZqn5y+wAznfSKWOH5sSdtlKLXMSGKyLo5ei6ngKaTTUJoXlWQCLAqO05
	aD/BJzJz6cgfhYMWqjQeLNvAhIK3cooaCFxsikIZ8npNxCNBIw6VqcWVDnzghdm9YJ3230W31Mm
	pdycyiu3V6AV3cIZTfSs/BSg1KU4hICtzBTb5PhIR4MqHzcqxV+85/jKWtDLHEPT/7FU=
X-Received: by 2002:a05:6402:458e:b0:6ac:686f:91db with SMTP id
 4fb4d7f45d1cf-6b408e9f045mr1964734a12.11.1792605389455; Wed, 21 Oct 2026
 10:56:29 -0700 (PDT)
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
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com> <20261021174006.GU3008132@nvidia.com>
In-Reply-To: <20261021174006.GU3008132@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 13:55:52 -0400
X-Gm-Features: AclHuK-Q6MQhxMIMUURzzci_OOwzGik9EFivN3YqqlGA_5OHu0xT6GsF67-BzDw
Message-ID: <CA+CK2bDJzo44K0X-+5F77E9g2dmqKdwZvrUf-1SkC7ewrgEgzA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 1:40=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Oct 21, 2026 at 01:27:22PM -0400, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.c=
om> wrote:
> > >
> > > LUO and its file handlers validate handed-over state with monolithic
> > > compatibility strings ("luo-v5", "memfd-v2"). Any change to a seriali=
zed
> > > structure, even an optional additive one, must bump the string, which
> > > breaks live update between adjacent kernels. Replace the string in
> > > struct luo_ser with a feature header, so that the target kernel can
> > > accept or reject the source kernel state per feature.
> > >
> > > struct luo_feature_hdr is a fixed 128-byte header: the serialized
> >
> > This patch is all wrong; 128 bytes is far too large. For every _ser
> > struct, we only need 8 bytes instead.
> >
> > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > 30 feature flags + 2 reserved bits for flags extension). The last two
> > bits of the flags indicate whether an extended flags field is present.
> > Each extended flags field is 8 bytes, and its last two bits indicate
> > that yet another extended flags field follows.
>
> I thought we agreed not to loose the string too, it was a tree
>  string -> feature flags -> individual values
>
> The string is the emergency if we really badly mess it up.

Yes, we'll still have the file-handlers/flbs compatibility strings.

>
> Jason
