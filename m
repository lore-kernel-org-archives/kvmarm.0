Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209635;
	b=AntYl3MP2AvdvTf+vPJQ29hqKrm+kUAYN90LNvmjgn4WFpBK522L0k1B4qYk4TgUWTBx
	 pD5tdXKwfDytyzoszH7hxFg7LkRdlHQQ+TJrdti0ciFXJdqfSkXU+uiwvEx1LgoR5iBDJ
	 eqSvf7gAKTLQLV6hROs8DyQQ6d7Ey4Y9He48hZezdGInezuEe+KjV3mamk2TiMHbWGyWX
	 lCqnZJSWyuhic/LV4QUK5ht0KNjvUMEWQ8fD8PwPXXp+UB1YKPkeKJTicPyk2D3WG2fGV
	 xnP6408zHLq2syaW//Tkr0KKL4gOsAs5HAq7qRIsgsDOsBAG8+FhIp6i/bGMHmcWY0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209635;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=tOxsbn2WzdX0v59D7Zs82WgtkG4cFGkj3ewz31Uolyw=;
	b=v776q/13GWHvO2hzUxKVxzE3NNJWZbIiM1U7ZS9q+C0i3QAmgxcRAXzxw3ohr3TWPbLz
	 Ajzom+hzlBbr5ODEMZQvky1Sw8khDSI2LoAgciBLZJ7WMGnmxbMSILMgCH0n2VdzIDhLQ
	 NmTevrgOQfEkEmik0aVmzyyd1iigLt2437RDq9FYCYeuQuvV3En8JaTYqI3aFpsXSY5gS
	 vHsT6zMcBXSKibLF77GkSrZsO3uWJtNwYMO4jI0F7MdXjwSQABwsP6q3nPze9kAMm4yaL
	 ldlkE7tvR8I0yFvDSndOQ52Owh1lOVNuyAFCmpMNDy5iXtoRAFsmiJLZP3aHH698ZYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=KKm6AlbJ;
	arc=none smtp.remote-ip=209.85.221.181
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAAD606A325
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 17:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BAAD606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=KKm6AlbJ
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5eac4855401so603039e0c.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 10:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793209634; x=1793814434; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tOxsbn2WzdX0v59D7Zs82WgtkG4cFGkj3ewz31Uolyw=;
        b=KKm6AlbJtQ4gXsfMPh40KGS1GVUvnA54CTOq35+e4vTPtWwpYaYrbk6NVmXmWn3aPK
         4WP6BxgcCzs9J08JdwC4PRuOqqE6SkouYcH6Ify5hHBSULSDw5ESt/3mmJIvccWY7Qhv
         Ql0/VymBauYua2y5pHdPZYHyAxXZKAAWv1dGkz1+iNE0y1YgyrZW9rExqp/EnHgpgcvF
         xcZXmA9DxNIHuR0Nd4R4U5DoYnc8DIK7lQ4oApi32/UGHunrTsw4w4LavtoMxGb5R4m3
         7Cls6mkDotzpRyaS2NpcjZQLsLTxXW+pk3YbpG36pf+q+wmn/3OaARTP+BeQ6FqEPmwm
         A7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793209634; x=1793814434;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tOxsbn2WzdX0v59D7Zs82WgtkG4cFGkj3ewz31Uolyw=;
        b=nn1YcIXpP0j6FFB7JX9cXDo5ILFD8IxG2lcDLOGZ4MQ3+khelVT0ZEk0aepsIIcMvi
         GNn49VQYjh9AoWGjf9KZCSueBksu5LAm6enyIPIZa3siMo7rRPVL5wR+EQHPxa4OCyMK
         4CCMxbN8s0JBxO6eZTPCEqGdnS9834E5JcHKScJCLzuqcyx/bqwbPBjs6CS8xuUBEW80
         nGwtBA8MBWahywm7Q3mNuEfh5JK8w83xX9H0eSWOzwsBtiyZn3isiOHuQ/gCelTpNjVl
         K5buEhczHj3B6uTnhqTzA5ZRFwvDc64Dcdto1gmbx5er0kVWWU+ROmJkSMm+8a2+06rL
         JGmQ==
X-Forwarded-Encrypted: i=1; AKwUvByQH1JqtEK4u01UR/0WxNXnD969R/vOKpK8uZhHqioRyhRJ9zrnHhT7KBVO6PR7yyvogubtZhE=@lists.linux.dev
X-Gm-Message-State: AFq9FYKiIgkV8UJvie+6Ql6s9TJhx2zZM1lM14VmKZkRwUdHsKp8wOsZ
	wNB+J7pS+eKS8BLcUnit8cPSUOldhVF/k43TD0DmcyYcZZ3UWMxM/JXwVbACZvDXzxs=
X-Gm-Gg: AYBFou1oOUIi7EZACJAhq/DI5vnRHaiB6DWbF5q4Qpy7CKXyTcp0/V+4386XfS0TerA
	awsvQkea+6XNNJ1/UgSAfhO4o7pHQuHHlaqJxNdobXxRr3Y1NaET2UaO9UMbgDEMqHkO1UhUgmB
	6EUjyeT5x/7U8/jh1JSTCjNPkANNIP8erNJN34X3diEeNzrocKMUtsV1JeWF5rbJfM8WzDkDARY
	9XOwhwEqOmUYNV0w+mkLLkA/z1ao4vXH4Y89NuLFDPOBbh6/UHwFIiqnirqjrWZhfelVIENk6Ye
	m4nSseNSQbZ0tiJln8sHYebgFRAxrQWCe3QVUIZaYXn03XXJF+YNy8yIHD8GCYGjP1vVk0RA8s+
	AjYwV4ga+TIomgCsxTjpyuWKduGLdiI3d3Qb/sI1NplrqVmVW6z9MLhtuMjz57d3GIqwOYJjlbI
	ztrH6yitZ5ETyb8N1TaD8ITUszM1306tBIPtPboHTC7vDut4iPbOqOzKxVigmIIw1A93t6p6M+r
	ZcAiCxRf9O3PsJ/C2fxDbGAeraq8JprCH1+HKZHhYm9ty9rrnNj788muppTOrSs97xNg+v0J1k2
	GmK72//zLCAf90wFmPxtzVh6WRFwLy938ox4mouICu5ZAp9bXg2z49oTa6mkPHHhis08iXFTrIA
	KCeCWmfrW8hk36hV2Xf6R55ShlhyTsWRlpq7E+YNavP4M6qYv/MLBug==
X-Received: by 2002:a05:6122:2896:b0:5ea:fae8:e69e with SMTP id 71dfb90a1353d-5ec4cc4f065mr1774474e0c.11.1793209634129;
        Wed, 28 Oct 2026 10:47:14 -0700 (PDT)
Received: from google.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec57e4e556sm445088e0c.5.2026.10.28.10.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:47:13 -0700 (PDT)
Date: Wed, 28 Oct 2026 13:47:12 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, 
	seanjc@google.com, will@kernel.org, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auI02M-pZO_aQ4jn@google.com>
References: <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com>
 <2vxz8q3hoicx.fsf@kernel.org>
 <CALzav=eG5j2n5omO2Mxqw8xA4sZLduxdbBYFcnHpPn0PDpt9Hg@mail.gmail.com>
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
In-Reply-To: <CALzav=eG5j2n5omO2Mxqw8xA4sZLduxdbBYFcnHpPn0PDpt9Hg@mail.gmail.com>

On 10-28 10:24, David Matlack wrote:
> On Wed, Oct 28, 2026 at 10:17 AM Pratyush Yadav <pratyush@kernel.org> wrote:
> >
> > On Mon, Oct 26 2026, David Matlack wrote:
> >
> > > On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
> > >> On Fri, Oct 23, 2026 at 9:50 AM David Matlack <dmatlack@google.com> wrote:
> > >
> > [...]
> > >> The reason I care about keeping the header compact is that we are
> > >> defining a foundational kernel ABI and want to use this header across
> > >> almost every serialized data structure so we can evolve them later
> > >> without breaking compatibility. While some top-level structs are on
> > >> sparse folios today, other serialized structs are tightly packed, and
> > >> we are looking to add KHO slab support in the future where tightly
> > >> packed allocations will be common.
> > >
> > > My intuition is we will have a small number of headers per preserved
> > > file and per preserved FLB. One for the top-level struct and then
> > > optionally a few more for sub-structs like arch-specific data. That is
> > > why I am less worried 8 bytes per header, even if we fix the folio
> > > problem.
> > >
> > > Maybe where our visions differ is when there are collections of
> > > serialized structs, like KHO blocks. For collections I don't think the
> > > elements will each have their own headers. Otherwise the elements could
> > > be different sizes.
> >
> > kho_block today doesn't store entry_size in the serialized payload. It
> > relies on its caller to do so. With extensible structures, this can get
> > messy. Sure, the owner of the kho_block_set can track the size somewhere
> > in its payload, but perhaps we should store the size in
> > kho_block_header_ser to begin with?
> 
> +1000
> 
> KHO block should track the entry size automatically and not rely on
> the caller. Otherwise every caller is going to have to store the entry
> size in the struct that owns the KHO block, like I had to do in the
> PCI v10 series :(

I am fine with updating this as part of the versioning change so that we 
do not have to do it twice.

Tarun, could you pelase include entry size change into the next version as 
well?

Thanks,
Pasha

> 
> > Anyway, not a problem this series needs to solve, but something we
> > should eventually do.
