Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794803663;
	b=H/aQXmuwb9fqenJD8LyKW92DFoD9pTbklUchrOp63CAOlLMqE95yc3CjaVZCExtQWpQA
	 RwLlUzZ422rXF9pU7uhWpMOTYtHVx0cQAJxsU/gV47rfNZlz4fXJ+QSldAa/I1172nxBU
	 W2yvQ/HPIuVks38uSyzWcVuhBXdBDwjqdcygSP6AB4Lv2kurcj2ehtgQo3qUAZKreY1Sl
	 uH0tJJRKEqLHI+pXgCfgq6b67XDayeQ7N5jIA6goB7ya1UgSQOAKSlT4u8euOJO1gykr7
	 grc6zGMu3sfdwdlUJFWj24ZfvCMOEx9RCzh4qXnad90wDtylREqqRtS08/MKq3eeBdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794803663;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=0RTPkBSn8aHOwll0NIb+MH6Rxh2TXo2nlFC6RRntyeU=;
	b=rROF2oCgxF7bL3ytPuBL9G1YGTrwM2ex7f1jGLhs9q6juyBQCPaeCuCFISLTfYyi3bm6
	 YXE88OX8qn1EzAEw9w+33xC5BGTwJ4likFiQuhkBjdp32bXALzIx8F20fU4Tpp8c1Lytb
	 Ba2VU9G/baxOAM30H7m0azTzfYT+ACRjd5KbRRcamM6YuJWQeUfKrHqNlGZY9j3cGdJBC
	 whAkm9JJDEXuwgxXPfk29YqJbMCpJofJhRRqW3MtnauWVYiZnNPjtGn6rs7ruRFVepsU6
	 wL0RtyBa5Jfr7mIaBtOKt/OSBPncsFb4un+np/NR9xS3XJd5VNX2Vqm2cSSysGIwaVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b="or/AlSf9";
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16648606A321
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 04:34:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16648606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=or/AlSf9
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-170135e43c7so4781832c88.0
        for <kvmarm@lists.linux.dev>; Sun, 15 Nov 2026 20:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794803662; x=1795408462; darn=lists.linux.dev;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0RTPkBSn8aHOwll0NIb+MH6Rxh2TXo2nlFC6RRntyeU=;
        b=or/AlSf9ID4PF+8qGNAByt+9leWavjQqMUqA4Z9mYViTJaSQxSjQzezRt8M+zlIye5
         IPTUjLqWNBpwmPCBomO39L5vvj9o4sKC4CKSexCkB8IiLxc6ouLv6Xf/rg/EPWX5j3Zk
         HK06YBEOYxtjDirteBgNqXxCv4a/KxzBK8G/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794803662; x=1795408462;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0RTPkBSn8aHOwll0NIb+MH6Rxh2TXo2nlFC6RRntyeU=;
        b=cIhWfpHFMvwBN7SNy0PmKXn+Tz+CQjAqLdheGEH1yROiJ3JE1pDYezB6Gqz3VLmvch
         KNjPo3AkT17AWzYYMd8VH25bP4q6lj5KZq4Yz4sAcFIwUxoMXIch9rj52grP+LknaXPM
         PKE60eRd5EN5Q5DjrpikjVmxnVATx09wa4otHw3VZHUsjJcEND9npwNuFiWijvtKVAbn
         GSewXld8agebLM3Ywub+81HvealslVjm6s2pnBZquowMD5xB2MXV3U/XzfOa1TNHctbN
         uLPeuy0ZNm8kH/lETQ0mqTs6TSNT3yAcNH6DmHvvjif8CWxYqL1IpKG5gv7C6+nZkYTz
         j18A==
X-Forwarded-Encrypted: i=1; AL+hErHw++8qkx6mWARnYCY4Zz4sAQLpYCQw5cq7KB1jfiAyCi55FNsw+356rnCHOleAeXfVyTgE9o4=@lists.linux.dev
X-Gm-Message-State: APuU4Z9ZpZ8tZz2ryAskf49x9/kFPA4km5SJKZT1NF+ULXq5aJJKbN8V
	scarvt8KmPWVdymxD5nFMcRsF3TMVHRT4wJ3b67iQvXvZ8eafPa0QrXGdWXkPyP9/XU=
X-Gm-Gg: AYBFou2oyPEbyBGznBGFlJVpUZTH0EYD0BCorsTwBGSxnuaf7PHMcBblRp6//Pw5PUU
	//JRf7hwXbS2x24ZkQEPVDQqsffOQWTPOJsa1U+k8jAGueHtXTWWIoAEsVM6K6/0KVsXVkEZ3Pn
	CckYvP47mgbhvacg29uEUB4/QrCdpemijLx+Vr3wE789cDT+TsQgWBiTqDqkb8hgucNesyTr3Bc
	qbz9peH/okOZZLySeIM8qd/6symgv4Bv+0nLDgxaPEvdthtkSdcykxXq/hpiioS4TyJNfCkTKuQ
	YR9RrywU6fHIPK7sT8TB+xJ1w3bH5GHOg/EYkzAOLlCuS8mifImBtk819POS8i+BbvBgt8GtBfP
	JYFqnB3ITToBGNrhKk7je+bPhduPvsWiIGkEEH5yE2BsTBOZ2lWyW3XUDe54+cJ7C8/7ikM0aly
	7J+r4h264pUx+4OoZCw+UdLVQfjzadxZRFAIrcVwWdsUL8s4PDKnIwY/VP0yXsfeLNyXLvpg0si
	33g8MXaKn/vF3yzZ9miz3xDu37RKbLTFpCc39dSRNrzECFkTZlsJqEeTm7TAF7LiG8xYZWLkvRs
	HVHJtA2E/RoRzdBLrkzdtzIcAGIGYzsC2ccZ0dMTm5J5uDNrFo5cZKXRgR+TPNQ857ZykJ/TcgQ
	ki7urJVyM0IthO+4u8GrxN02wcCyOwMEbKWV2y8Y32i8ldIjxt0fTSVuZ/tRgQtia5bbxKEF/Jq
	lzdx5feWLJIJVvs8/U9tFP2Przdvc42NUimiEbKCmOyQK6hWdgCIs78VZ4m8R33YQd
X-Received: by 2002:a05:701b:4508:20b0:194:9e7a:3ba2 with SMTP id a92af1059eb24-1b50306c4d3mr9813315c88.2.1794803662025;
        Sun, 15 Nov 2026 20:34:22 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5329ec87bsm2576204c88.0.2026.11.15.20.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 20:34:21 -0800 (PST)
Date: Sun, 15 Nov 2026 20:34:13 -0800
From: Chris Down <chris@chrisdown.name>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org,
	will@kernel.org, David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com,
	loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>,
	oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com,
	joro@8bytes.org, kvmarm@lists.linux.dev, linux-pci@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, skhawaja@google.com, sagis@google.com,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/19] liveupdate: Add feature header to struct
	luo_flb_ser
In-Reply-To: <20261110050202.529473-15-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-15-tarunsahu@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261115203413.eaa54fcba43adc22@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Tarun,

Tarun Sahu writes:
>+	for (u64 i = 0; i < fh->header_ser->count;
>+	     i++, fhdr = (void *)fhdr + fhdr->size) {
>+		struct luo_flb_ser *ser;
>+
>+		err = kho_ser_validate(fhdr, luo_flb_ser);
>+		if (err)
>+			return err;

I think there's a problem with returning this error as it is. For an
unknown required feature kho_ser_validate() returns -EOPNOTSUPP, but
callers of liveupdate_flb_get_incoming() already take -EOPNOTSUPP to mean
that live update is disabled. pci_liveupdate_flb_get_incoming() returns
NULL for it, so instead of panicking, PCI carries on as if nothing was
preserved, even though those devices may still be doing DMA.

 From a quick test with an outgoing kernel hacked to set an unknown
required bit on its luo_flb_ser entries, that is what happens after the
kexec, in that the PCI FLB is never retrieved and boot carries on.

Could you validate the entries once in luo_flb_setup_incoming() instead?
They are all written with the same header by luo_flb_serialize(), so
there's no need to check them on every lookup. Going by the code, a
failure there would panic through luo_restore_fail(), like a bad
luo_flb_header_ser already does. If the per-entry headers end up going
away as David suggested, then this check goes away with them, of course.

Thanks!

Chris
