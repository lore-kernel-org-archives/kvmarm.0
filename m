Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794328775;
	b=glGRIp62HHnIA2nINj/xLVwRkbmbH2Xq2HpJ4wU9x2cqhlKA9eY7ljVH5G58xNZn4YX5
	 L5ff1PRHs1QouALPBeRjJwePHvxVEfPlCJpv692wcaY0b4eGOgXCQ9c8hUsgRSpujh3v6
	 BY+m3jXH3E1qDKaxnO+do7UwNwA73jsNLhafwKRuZDGvC28w5Keqa42UGhmuEAvGoXQlG
	 2Mwzwg6e+EDQNBXzRTAPQ+6Yf9VK7pZdX2woCL61rVpQJx5nNx5nMmigIorR82Ed4ENKl
	 BFJvrUJIA2rf+5S/dJoCe9mi5NPzoFsk/NSOcgbkmCMllECE45APVN3HYxAQxo+movw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794328775;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Mime-Version:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Cc:Subject:
	 From:To:X-Mailer:References:In-Reply-To;
	bh=KprtAoIZUPQy03e7SCEXrO4BhVdW6Lml6VdK8wkVG2w=;
	b=FP9pgLqaS7pz6BRlnjUzDRaMKFFm3DDlz1pcdUvMzzEjtHVNYVDPS6fmbAzcw0xfTDcB
	 6yUoUZCAI1H4LLQm2lLO6EzuJ9XFBb8Ve/c9B5b8Nbmk+HxNNUWQN4p1PwIRl4e82IGOK
	 1cZx2PHxnxRrrR2/x3HLjHPbRhYAnd5RdpWzxdO7V9de+8kgshgZAPHd7+eXXrVhD/3ei
	 +ul+72BC1FIqiZiTnvocBJfxs2pcXs0cKHw9gm4gv9iVA1J+HVhdJjzZccvjZAZAdnyoR
	 VEJCzktB7R42JYxAF4ZN9GrrPqoYx8tOFiOJlg1kUBYkxoRZJKW6y7Hpbtol2nDxjsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="DwMnh/7f";
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F7F60A263F
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 16:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93F7F60A263F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DwMnh/7f
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3b0d0b80fb9so1364228a91.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 08:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794328774; x=1794933574; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KprtAoIZUPQy03e7SCEXrO4BhVdW6Lml6VdK8wkVG2w=;
        b=DwMnh/7fvo2aKeuK7+E7zP5py2qlGXJhBDucZGjSafiZq1HXurD3YzgE7kV7SZ3Ply
         3CwO/jPf8TXQz7UC/uDIjRBARW0nc4R90OqSDOM7mRl6lbdKH9HVfrTLqHGQ0869Xifn
         j2G5XcOHkqVBe4m4Z/6T/fIjRUvhSjVPX/btuz9jJA331broIJTaD2BgXz9n5QJN/5t2
         zZpGsiA5s3CpxmRwAj0MnwkckL1cZWko35wqzFpriAUbXFmnS7GjedGtvrRsAA+ALOij
         RaLhm3/rvMFha0U2gWhK+7c8oJHVuXtqbYZI/8ybiPEXEhhXYUihMcuj2oIBznsjwh2A
         Hd2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794328774; x=1794933574;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KprtAoIZUPQy03e7SCEXrO4BhVdW6Lml6VdK8wkVG2w=;
        b=yIftQvBXrcMGg6TvxR69Hy79Ua8XgaJBahg9UI6Y5A54DuNcgqN+oW1yRjWRV85o7j
         c4vDuVSgFy9wzwgONt/FsbiNaoye/WkIewZbNJaxns3bq4WTwcS2y8wCl7MhH2Zi0xEV
         v/R39+L0IjUKW/PiaH/7u4+TPTqqTCbc/RPt4Ak4ScbpAJ+oaYlWy6r2r+snJNRUZ+EU
         cBW7yDxAeOKkYmw4WwxgMxrjraMykWYnHwg9bDsDMaBAC3wIJu7PcqxQUSQS/Dqdm1/s
         b0gDjcyO40wXVC+BqwBYBKWQbTs30L1jtWJCj2f1RlX5eM/6U89AVzK9C3hVuUaWw/Lf
         BHHA==
X-Gm-Message-State: APuU4Z/x+Gb8z42erB4C0C7ZvmGIPSZAry/JpCMKN+Qx4BnfMKmhnY//
	EADMldpVO9HrAYvrqIvYSWtojPyiRoWq4kSkNOlYFdxichaU1t1uaIpee2iEyLEdYg==
X-Gm-Gg: AYBFou0hqOkUDKmFDL8bw5IssLLfBmT5jhnJL178bwG4150B0UNsYE1ZFQajwov5+Q4
	1YOKAu4bxp/Qqt9neELfTPVsDCwbHtVo6XNPR3Sm3DT9AJTYwWP3elvexJy9Z2NCyi+vF0TaDeY
	qFejkAchaFhrEUuz0DWMi/yCl+8QRDcb2IlfiXkY/XpbdpakI/mkiPSyC/YtMRz5cJ6eSPSy97P
	1VbMlIfKmq3slo+0AY3JfKcOzzyNlAxEZDBPaJlYFZpFKvAWgGdckCm1SYoCf9kDcQYCHtuZvck
	rQ91izMTn3rJne45Om1xk92vMyTeFaq5fR22eLCwmcxXYL3DD6p+FvxUPj1654k2ClIcnCBqvmv
	h/HUxRH6A93XoJFj6O/MEdo40o3ybVtF8q0DlkODappmNjqmsR6Mm5sQ1uaWZ39Ugd1TUhcYBVt
	7PB1ScOLptt/SFteslY1Lxcs3sbCcg1WRZm4Mspr1dciMmfaji08Kn/wJDGi0e1/rY1Yrgpvn4d
	NCN5VaJpoPE18L6XkRpCksuIaBilCSGmwmFWDR60SzCkSBzyO1n9TC5daIyyJvRFf3472AfQME7
	6dY8AVjQlr4QiisS+aFfUIe3V/Qf0f3Z8I//BzTThlP5tvzkTW7icuW3Fc7XDold
X-Received: by 2002:a17:90a:d444:b0:3ac:9d83:8861 with SMTP id 98e67ed59e1d1-3b166e3c924mr3152630a91.67.1794328773194;
        Tue, 10 Nov 2026 08:39:33 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b168a8de09sm2418499a91.0.2026.11.10.08.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 08:39:31 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 16:39:31 +0000
Message-Id: <DMROGPTP93G4.13PA42UFKZJNJ@google.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 15/19] PCI: liveupdate: Add feature header to struct
 pci_ser
From: "David Matlack" <dmatlack@google.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-16-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-16-tarunsahu@google.com>

On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
> PCI_SER_REQUIRED_FLAGS_SUPPORTED. Remove dev_ser_size and
> PCI_DEV_SER_MIN_SIZE so restoration derives the struct pci_dev_ser stride
> from the KHO block header entry_size. Drop __packed from struct pci_ser

Taking the stride from the block header is good, but dropping
PCI_DEV_SER_MIN_SIZE removes the only check that incoming entries are
large enough to hold the fields this kernel reads.
kho_block_set_restore() only rejects an entry_size of 0, so
pci_flb_retrieve() will now read past the end of entries smaller than
offsetofend(struct pci_dev_ser, refcount) instead of panicking. Please
keep an equivalent check against the incoming entry size.

> from the KHO block header entry_size. Drop __packed from struct pci_ser
> and struct pci_dev_ser, adding an explicit u32 reserved field to struct
> pci_ser for 8-byte alignment, and bump PCI_LUO_FLB_COMPATIBLE from pci to

Please move this to patch 1, which drops __packed from the other ABI
structs.

> pci_ser for 8-byte alignment, and bump PCI_LUO_FLB_COMPATIBLE from pci to
> pci-v2.

The PCI Live Update ABI hasn't been in a release yet, so maybe we don't
need a version bump?

[...]

> - *  * The size of each struct pci_dev_ser is recorded in
> - *    ``pci_ser.dev_ser_size`` and is never smaller than
> - *    ``PCI_DEV_SER_MIN_SIZE``. The next kernel ignores any fields beyon=
d the
> - *    ones it knows about, and must handle entries that are smaller than=
 its
> - *    own struct pci_dev_ser.
> + * Preserved devices are serialized as struct pci_dev_ser entries stored=
 in
> + * a KHO block set. The block header records the entry size, allowing th=
e
> + * next kernel to step through entries using the source kernel's stride
> + * even if fields are added in later versions.

Please keep the rules for extending struct pci_dev_ser. I'd say
something like: fields appended to struct pci_dev_ser must be gated by
a feature in struct pci_ser's header, entries are never smaller than
PCI_DEV_SER_MIN_SIZE, and the next kernel must not read fields beyond
the incoming entry size.

[...]

>  struct pci_flb_outgoing {
> -	struct pci_ser *ser;
> +	DECLARE_KHO_SER_HDR(pci_ser, *fhdr);
>  	struct kho_block_set block_set;
>  };

I'd keep the ser pointer here (and in struct pci_flb_incoming) and add
the header pointer alongside it. The header is only needed to free the
allocation and for args->data, and keeping ser avoids sprinkling
kho_ser_payload(outgoing->fhdr, pci_ser)-> throughout the file.

Also, please call it header rather than fhdr, here and throughout the
series. fhdr isn't obvious to someone reading this code for the first
time, whereas header is very obvious and clear.

[...]

> + * @reserved: Reserved for alignment.

Please document that this must be zero, so it can be used by a future
feature.
