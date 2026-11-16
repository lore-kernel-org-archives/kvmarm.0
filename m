Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794803668;
	b=v4EvJevgJMwomq2G0ebiPbLeecv8/sb3IUjKoXEXPsesfTYO4E3IFNeVcgiKb9lzn9Pw
	 w9JJHCXDb9bCAJ18NLnd+gP8SoDyAq8C2teqQeAGy1BZjd6FOB7Nxe9HvoxQI+iy7ZUwy
	 hm1IGjpzhaFCYvDywf3vsh5GVCiQqT8+inNto8xgCjQCa5tS1Bv17NxbkNTRTU1tM7c5D
	 W5soXzaPD96TbpWahQ+8s8VbnEJNhbTWPnbGggqdDgaCHClZdKSDti0gd5QuRdX0UkzbM
	 RX/+WAij3eXK82CB3Vc16wyKPdzohGtXqwxNmJmBSiQpn2axZUVmJJcGq2vTJTC1xRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794803668;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=yb0ouDgf9S/OdWev3vcVfqdIAaKZrYAoDUUyKNG3AEU=;
	b=4XFrVMONR3bwRq8PbKLsdhlC4r3XMszMVFdiQJ02t7w5wHnBuL6Dq5671UspRNDEhfT2
	 4XhlTrXdMOIe1W4oFWV1mr0J2nIaol8P/XQK+aodcRrUqOlRFktNpmzhmr0iTqJ2IkhG1
	 j9qCDraHUW7NTfrjaic1gxdUrKUeLA2GEEP9vM2JiG61TeLTYqdEcpsdFub6vlI1gmhzI
	 qMgo4UPcxQdIXgfFTs+B83uiJcd6dHOuEr9DjECS20pmm5tl7LSyllZOReLdVhx9C0ZsQ
	 6ZLW7no65gQe3DuRqgBVAWW/fuwLa35wAZPOa8WO/x21qOsqwUPnsc5NbrgeCH7TMgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=cqzcMzVi;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19DF606A334
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 04:34:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E19DF606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=cqzcMzVi
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1438d9363fbso1418582c88.0
        for <kvmarm@lists.linux.dev>; Sun, 15 Nov 2026 20:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794803667; x=1795408467; darn=lists.linux.dev;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yb0ouDgf9S/OdWev3vcVfqdIAaKZrYAoDUUyKNG3AEU=;
        b=cqzcMzVi51jTgL2WyAIpZSPzXVevFHpbhWzwV700sK615AdMRuqZwL2dBbqfHSMXI4
         iC87LBWT7dZ91JqA6EPATaa/Wwr3Y0wDvJ4ZajTqVww/xjWAPQHDYh52fxoasl56Uznq
         rQGb0X2NmZ7yvdl/u021U5v8VhEJjBUYrentc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794803667; x=1795408467;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yb0ouDgf9S/OdWev3vcVfqdIAaKZrYAoDUUyKNG3AEU=;
        b=hyk0jnIQZt/IgutpRprx51zGnt/uJpce6MkjfwCJ7ZgSeM+7YWaI+99JNtp1eHholy
         08W5mH4DLY/uf40qshFPS+EUayvf8K3L0q8De8jBE610WPckm7955o21P5jUg5I/o5wD
         rhXaN/ti4dSJHfKM29IW6DH/eJ+EZOkhnWtdBmsbut8sf2n21pY7VfQpdVTCzUUjjXlR
         aCXadq/LuvHvAlvIDRz1iYFlsQ1CzCasqG+rT3KVwQCVLTr43C3Om4WCUBMQzAnMJQJD
         6qU3+iFY/UpX04o1/r62kUCzvmz7Kl0ebBxqTfm4CfiX9l8Mt7BakoZYOd4yGrCcHIhF
         bIMw==
X-Forwarded-Encrypted: i=1; AL+hErERnBMy8L4W17yCPMMqP1282jC4hFQ7Z3MdUUYEWrUGkIK+Xg8+9bOqngWueUGuP6RmLut05jE=@lists.linux.dev
X-Gm-Message-State: APuU4Z/KCN8nNpgj6etUmrDEOb9Vd8MPb7j6uhiZXSgIRqPfW3oR+wi8
	jT37Bc6DdMO6n8e0OiES2vvRBz3wSjfsRn2xsgkS1bqeMqF9Xuty7rHqkt4LUqae9tc=
X-Gm-Gg: AYBFou18qxN0q6REh777dn7k183fcpqjQOWYrkw7nFdSYioo/0O8PCBWUFz6tNJyxjT
	lVAbFFRpDI2HoBOjEmJw2gDYnttEttcJNtRA+c0ON02wYnKxHYxYC6o0CssBEqgOVw907VDqKtm
	TPswuhZbigsg0OCbsFlOkFRDuXSirv/OAXFT5j0VB3SvPwHERupLEDrfO7wsW2azGWZq/6Yeuvl
	L2XyddpuUF8ULCieSQDd0uxsryrcj1WcySt8TStmDp1D7VKpIUUNUXl3IS/H68fFyZsemcz15Cf
	DhC9B+JoexH2CsJlxQRgrSIUmK7nijmHtdZBzLm+vaqQpJxGKSe1x+OhuS+r6PKM7OXlwEp9yuA
	mv3CUbVc2K/24WM2bFrqdsHPz51kp/exNdIHLJKDiBf53j9lGBa6ckcaYec83eYXaZMn1EWAkj8
	RTmSUVBUPITOa8strBYDKCeMurxDM17YV6F75d5ix45HKqQ/4T5aX+tX6r9WN8MWWYU6r5dNnqN
	x0FUigakTeJIvt64XuwvyJwx+TSh4qHAUKTTVS4y3bXluvJ5hKJBZEy5D3ORecKMuY52tUNdGjg
	Uhi9n7oofBRfThYJNBX5rGvkcxmcGnKZWn+q00A/1rgz2kwlsdestSN6l7uhJMN0A8lvtjxuVaZ
	eMjqDr1iJyTZUcaWQanEgDGXrRvK+c3ZdryML0IHAWgmW+THhbFHYcMkI1noX2yQBlNiOI3ZA++
	/nSC1dECXGEpWVzLfptUh9qxqY1u3HVj3qdxsLrTc9FXHBQKX7PO/W1d3vk7rjBhzd
X-Received: by 2002:a05:7022:b0c5:b0:181:6b8:31f1 with SMTP id a92af1059eb24-1b4f5f3475fmr11110443c88.10.1794803667022;
        Sun, 15 Nov 2026 20:34:27 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm38362148c88.9.2026.11.15.20.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 20:34:26 -0800 (PST)
Date: Sun, 15 Nov 2026 20:34:21 -0800
From: Chris Down <chris@chrisdown.name>
To: tarunsahu@google.com
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
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
	compatibility
In-Reply-To: <9huz5wy4tufo.fsf@tarunix.c.googlers.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-6-tarunsahu@google.com>
	<DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com>
	<9huz5wy4tufo.fsf@tarunix.c.googlers.com>
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
Message-ID: <20261115203421.38c206b35f5b12e6@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Tarun,

tarunsahu@google.com writes:
>Techinically this is just for readability.
>
>WDYT?

It doesn't help readability in the generated docs, though. kernel-doc
splits the parameter list on the comma inside the macro, so
kho_preserve_vmalloc() comes out as

     int kho_preserve_vmalloc (void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc# *fhdr))

and the struct memfd_luo_ser and struct luo_session_ser definitions in the
ABI docs end up with a member like

     DECLARE_KHO_SER_HDR(kho_vmalloc folios_fhdr;

I'd go with Pasha's suggestion and use struct kho_ser_hdr directly. The
pointer can then say which payload follows it with a comment.

Chris
