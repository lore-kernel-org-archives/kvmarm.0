Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795455141;
	b=VNsraPbNWByKWD98OQ5P+OD/FsUP2I2vn2F4VVjAn97UosFuxEIka2U65gIu9UawOwH9
	 dQxvhK02qQRZ7WpjIR2GV/qwQQ7mL8/C5uu7eSRDcni/CRD1cvrtd9v+dvjcBD3Yc2PQ4
	 w+n/7rqWy2BTiPkTe9P8jCon6txDA8EhWCECUWQXqQI6Fd7tOsmijkaUXaQdykIr3PWEw
	 4JAqi29xU9o5eQvE4cNfXaTp/d/tmd+RMl/mGsYXDwG8fR89RJ3DKH9hHaFyx63vbmL9U
	 NfD2AjFcMBZLxITMUl20/HF00Tu6ig30nKIvY+MWyD0qyRJgH8JmyUkojutW3JQN90A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795455141;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 From:To:Cc:Subject:X-Mailer:References:In-Reply-To;
	bh=P+l/VRR07HqPbgm9tEPK7SVr6Tlf5vY5XKwCiYVXpnE=;
	b=JDulUeBa3iX1yGqlI4Vlu19ddUGuOm1LyylZQqqgjoDBswJFIakg5HMwXOcJwZz32xer
	 y40GF8G8xu4/+ElFvb8lFmGjeyhL6fmzGfDXZbiEJM+wVzaoUqMWwGqrtzokAd12NQEMJ
	 ZK9Lr13W5/xpMHCd3pobM2suaDyxysXeipfZdj+poqLKphB7yf9aQNzrN+KhoCzMKlTu3
	 wgiVqC9+6f0Uzl6SUSk7zHUtsqnpXrr7VFXb9QbtZJ6tkbyXV1CmtuCbzsR70Q8CQoFH0
	 kdmdpWYRwaauWJFx6SddL2piYgZ0SnagqxF96RHlKKZQvO1vCMpePmZN167RTbkUN7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aIaDX2Za;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAB9606A31E
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 17:32:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DAB9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aIaDX2Za
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2f03920c477so30915645ad.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 09:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795455140; x=1796059940; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P+l/VRR07HqPbgm9tEPK7SVr6Tlf5vY5XKwCiYVXpnE=;
        b=aIaDX2Za1UAxDZvHikVowcIZLEDfyZNK/wJ7n0zdBFr1kO5d7UmwabvcI5D71wVcCW
         sWvZMULyDzVN8TdIgZomhhSKXJx++KqyH6Jj/1JtZkLAgrkoJCaFYMZDSISektkDUW6w
         3gefAGclXbeK6SbKVxBZFwNJsb0G7wO8bUW21km4irmig1tZdMtcjE8ar59tb8V/3kvv
         08lEYiD092ntiE7JRaPnc7FGugYqVobsK0EF8snw/jlM8q65+lRJxNOqLCdRyC2LhpfK
         8yblElZVDkQo1+OLk2EqSPKtFapxpJpOSZbisPjGf2aY8kZRMZJ11SONR7TB//xgp1Jv
         2sJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455140; x=1796059940;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P+l/VRR07HqPbgm9tEPK7SVr6Tlf5vY5XKwCiYVXpnE=;
        b=pStgANBAJfjfLLpHCBTDcjbXj8nTYUC+HydIfdUaKK+i/auIY6nTbCAHP94TrEhH/S
         TuvFPqXsoIodTgnDAUk0EUd5lLZwFC4yBjCk+1dDX+DqV5GYmTxQ/wyiGzQsIEPXo13M
         ljw4DxMIugGBj7NTtISBeM+y6FWSw+9DOWyPn/D7QeeiFCfdP+eNFVlHWr+wc8DnnmGl
         lhwsDBIcyMTKir6mHHrIwvN6xiSl5QqB/ZcfX4IIEpnwdvzKjp1DCwmPbLqd71xorr6q
         W0KnebmHjyl41R/Rq1Bs+UKH777F40Fu7Gm7y8WKBkDU8Txnjpc8LIGtZC5sS73y4JvN
         YcXw==
X-Forwarded-Encrypted: i=1; AL+hErGz6CXyJ/4iGrrHyKvEXve8EE4wsSMZlIeHTnqZVJ2cBqASHs4mEcwMj1RI+ah+nDH1lXAEVbk=@lists.linux.dev
X-Gm-Message-State: APuU4Z+WKJwSdneu5UaPfgDdbRGZRGbKvX8sdEZ1rSuSM5EIbB+s19IR
	CmsLbHi5RN+qd13Tmd1Frz7Oqy/0dXhQGl007AGFQiXDys12CPABmZ1RoPwSrNIItQ==
X-Gm-Gg: AZFdTZd0AGatw7XkjJIlgQvUL9cWT32JfnOpp6xWMB3Bpa0+UBYs+7IZmR9n1EoMRCn
	YO4XCO68PYIFGRd6RKYK32fFKCH3n/3exsRZNP4Y7VwrF2fTREbre0tD2Fci0hI6IQPo9l4Dfz1
	4+mE5bOdP+x4h0YrdZnucGJVb7gaZRoiXZga206ioVciQvE8WrhnweKTPjwPlD3oXFt+Sro4ngA
	xVchW6oJqhQPdV3ke+UttvVkAiftIaSk6gA5pRzCn/zSowld0UP1K6SMgK+1+bsftgwME1A+hlC
	kOMr9vNECZpni8g5uxKPB816TnK9Jo5l/Cso1u66jPJOyOvG4hJVVe7I7dmbNNlbclIPZsRUT1P
	AI4RUCmNjDLziq9N0VmkYm2zRNgSvV7Ko1YZ5FlLWvdjEj/w/rhw7N4jUvTXLTX/IP89zSv/kPd
	HP3eSDolS/So/3i9Ry+IQHMTZJHGT9xmfR3SxKiRyCaersDrAxvQBG4yjuEbEmiU/50+3QS3xAl
	Xf9eyWJNTaQvQXBBZ4lbaoJEap/Fq4zGnOspL19xkr6goPsWHWFJ3LWvoBJgKrFb/jccufutflo
	v+dKAiIWK2pslFnGqxRaNLxFP5PW4piDvJMQ9ZPUTyJKCJH6TRJw1/adYsiJOq5Z
X-Received: by 2002:a17:902:e807:b0:2ee:1fab:158f with SMTP id d9443c01a7336-2f03f167d4emr115089865ad.43.1795455139780;
        Mon, 23 Nov 2026 09:32:19 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f051a566f7sm45650825ad.41.2026.11.23.09.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 09:32:18 -0800 (PST)
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
Date: Mon, 23 Nov 2026 09:32:17 -0800
Message-Id: <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com>
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "Tarun Sahu"
 <tarunsahu@google.com>
Cc: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike Rapoport"
 <rppt@kernel.org>, <robin.murphy@arm.com>, <maz@kernel.org>,
 <will@kernel.org>, "David Matlack" <dmatlack@google.com>, "Alexander Graf"
 <graf@amazon.com>, <seanjc@google.com>, <jgg@nvidia.com>,
 <loganodell@google.com>, <arnd@arndb.de>, <dwmw2@infradead.org>,
 <baolu.lu@linux.intel.com>, "Bjorn Helgaas" <bhelgaas@google.com>,
 <oupton@kernel.org>, <alex@shazbot.org>, <gle.com@google.com>,
 <pbonzini@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <kevin.tian@intel.com>, <joro@8bytes.org>, <kvmarm@lists.linux.dev>,
 <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
 <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <skhawaja@google.com>,
 <sagis@google.com>, <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
 <2vxzse0rzjdn.fsf@kernel.org>
In-Reply-To: <2vxzse0rzjdn.fsf@kernel.org>

On Mon Nov 23, 2026 at 6:56 AM PST, Pratyush Yadav wrote:
[...]

> When we have all this available, I don't see the point in
> differentiating between optional and required features at the ABI level.
> At the ABI level, all that matters is what the incoming kernel
> understands. If the incoming kernel does not understand a specific
> field, the outgoing kernel should just not use it. There's no point.
> Best case, it gets ignored.

I pretty strongly disagree.

An optional feature is one that the next kernel does not need to
understand to correctly restore the object. A required feature is one
that the next kernel must understand to correctly restore the object.
Optional features can be enabled without any compatibility concerns.
Required features must be enabled carefully (IMO via uAPI) to avoid
breaking Live Update.

I agree it's a good idea for the outgoing kernel to check that the next
kernel supports all of the required features it is using, so the Live
Update can be stopped before the kexec. But that doesn't remove the
need for the distinction. The next kernel still has to decide what to
do when it sees a feature bit it doesn't understand, e.g. because no
spec was provided, the spec was wrong, or we kexec'd into a different
kernel than planned. Without the distinction it can only:

 A. Treat all features as optional, which risks misinterpreting state
    and corrupting memory if the previous kernel did not properly
    validate the next kernel's capabilities.

 B. Treat all features as required, which means no new feature can be
    enabled until every kernel it might Live Update to (including
    rollback targets) understands it, even when those kernels could
    safely ignore it.

Neither of those is a good outcome.

> The semantics of required or optional then become "can I describe this
> object with the capabilities I can use?". If the answer is yes,
> serialization succeeds, if the answer is no, serialization fails. So
> with this, KHO_MAP_F_MULTI_INDEX or KHO_MAP_F_DYN_DEPTH are indeed
> optional. All memfds can be described without these, they just will be
> less efficient.

I think this is a different meaning of "optional". Whether the outgoing
kernel can choose not to use a feature is a decision for the serializer.
Whether the next kernel can safely ignore a feature's data is a property
of the ABI. KHO_MAP_F_MULTI_INDEX is optional in the first sense, but
required in the second: a kernel that doesn't understand it will
misinterpret the map. The header needs to convey the second.

So I see the spec and required bits as complementary: the spec lets the
outgoing kernel avoid features the next kernel doesn't support and fail
before kexec, and required bits let the next kernel fail safely if that
check was skipped or wrong.
