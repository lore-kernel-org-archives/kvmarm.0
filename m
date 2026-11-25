Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795567195;
	b=d+yZwHHFTmg2EfgQ3nIxXPn4v3qypw1RofOFmokL8VK7jkBx03Pz/jBJUIlcVsZbU7r6
	 XTZ1lZYd7WJ7u2ttt3hzxYZnnGSOwK/o8s4mWLJ7NovPJxR/y0lrUSNc1YMA1QuaLg5S/
	 Nvz3GsDvO5AwvnDxPQVTOsK7maZCvnKLLNvG8Wma8v4zo0jym2QTKolBtYHgw5YYcOBFk
	 n5ZthbnFe92Z+JcoMry0HT4pmCo6UXXW9bpVjjwEER+LqBHzUieW7eGlXdxZjEZC0+0xC
	 c6MCrN0rjXe4WXc9ED0mLBt26IUqEThydm7Td/ko0nCX+zzXTLLKIdjT83pb2Le7dyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795567195;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Subject:From:To:Cc:X-Mailer:References:In-Reply-To;
	bh=YKxHcqUXjQp/1J5J8B8/Kkrmh8UptW8ucEK7buHNuos=;
	b=kB3x49zbd/AY6+jBvxaJgN/4kvNd8qNXDK2LebowiTTxoCgyVWjHTZQ1ILc+TIg34cuU
	 skOwxOMWHud9IW1c1wwRQfL6A12RhPj28Z/JY4Uy82I63ntEzHSj4DBbitZbwQCpKrnVF
	 Ngb/8YXeEA6/Tp+b509TBXL4bQIJ/JodDMoJoEBq6cZzaYhN3zPYRqZLBuw2Y5wwsVZd/
	 LUpCVu9oBSwhADumxSQzggc94OgzIbHz2usgRb1U55l2OCvcUG7an2uErXRO9a0GVvxBy
	 vvb67dDHBHKnOu3Pbwri2NxEyTJ3u3PNyI88TcNOdo4VOaKs4SV1sl5wOJwhUaotsBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nCzlJqch;
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA12606A332
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 00:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CA12606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nCzlJqch
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2f05bc71e01so21445325ad.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 16:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795567194; x=1796171994; darn=lists.linux.dev;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YKxHcqUXjQp/1J5J8B8/Kkrmh8UptW8ucEK7buHNuos=;
        b=nCzlJqchLm9wVfq1hfTMvrl4CGlTPvgGRlXCFvr67M9+kxomxzBfe6jf6It7yRuFjo
         Iu88IRlIfVu3mfnlUbhpXfvmbEM7Cfi1YZ+Iwvsiahf3GiPYFQYkhsXUa8ibrlDjodd3
         riMi5ZQPdNCiQ92rBvgXb+o2SCnWHCE1ypTYilpoRfgmNEJF5Iy89YWdMbsFcDMXltQ6
         ki38FIId3w9rZeY83JAEXF5pWqOf4PNm491qrzEzchzaOg0S/tePlieMC4xYwuDHXhvb
         +oLQoknGfG2FoM/vroKP+ep5rNgyko0PHDJblSI5dSIvJtXdr0A3lweNldmb4WVkeaDw
         v8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795567194; x=1796171994;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YKxHcqUXjQp/1J5J8B8/Kkrmh8UptW8ucEK7buHNuos=;
        b=Rz4QONfnCxE7mgIz53JqZnkg4kLL9/HLNr4cHaNAnNRR3GNHyOSZUkFnoTAX99sajX
         shwvR5ycOClzKB3Yh8r8Q2NR+ca1qwEzjcKB6LKvAp/D2XhrYSANFn9xdQaTOT01qiN/
         06faIcWEQ+Bld5z7pIS0YJ3QEW48gbZrOJx3jbFMoyL6FzKcTyw9HnSRuckUMt8CFI5v
         d//3UGzxBfloxLpIOObNulg7b4an1evbOF4IR695k/USlPtzElLJ1mmk1sWfFLk0Ox3c
         HDbohkrmsPHdR7/F9c7AiAwvFdCSDeEPfo+AFnReqCzosS6Sa6jEY3rKI5H7dXJJHiDK
         JD1A==
X-Forwarded-Encrypted: i=1; AL+hErEtspDwAK8oONPPagFuEXbbyJewqYSNqqt/yFoyTy4zFf2rM+pfTacV9TKte6U5EnRISPhvpbw=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ztY2ChaMqR0Q7yGpyt8OZF99c6RCa8h0eHY1ms7VswUmvPWnr
	yz5gK1sWnKZGMZ3KWWZiOeiQTXcIkY5+p7VRISur/Ns32YNbdWpAB0Zf25LJ+Krq5Q==
X-Gm-Gg: AZFdTZdTDJpKa5r0fT+Efv+aFKhz8GpZrCiGhtnB40NxyQxwb/lr6li+M66DtiZ+q0h
	BdAc8jfmX/YN3RGDvZ5KODQ+1xWD0VW4hW3dVsOsz6AdOvIQmF7pBinQrD814nGtPwn9wVGFThj
	xPyfZQrohfXfvDjMoCjg/xu5BSlo2ZzDojzU51y94ioT84Ta1GfF2qXXw5VXTOE9qXeRIO5Ym+J
	26R7ej+4dIbDAEhe3VtEOaWBRz6gvvKtVBZtuRW7Q5YxgX0MmwRjLMJ6LdugOWPIwVKGPZkjY8P
	F4hNouIb0pdGXxeGtioGKVbmZpemjTes1vC3NZsxjVnsPylUAK8eUfgiOszmXjmdOiW2IhnenLb
	M7bGzwYh71sXEsjxNTQGLqvBGt0ILIBTAQcW7buhh/QAtwEw6Xh/JhNMszMxzLWvXS/4ioI+OuO
	45fWCIGxpAE8n3gae+Xy1pKME7C6GQjEqdBuArhPZLOpxtm0Jv2Q7MKl66iApzpyU1zax+aSWFI
	aeJg25jasuRB+kPw3aZ284URx+yt7wGIkC0FyJZPIouxCahj38XipaEAs5OYiVHnvIeuMaYeE09
	pyYDkZMHqQQwt7BbUmagSF0IGQHvu98a/eqZECjHWHl9TP00UysBzDV6VwWHcv3C
X-Received: by 2002:a17:902:eccf:b0:2f0:25ea:8fa8 with SMTP id d9443c01a7336-2f03f176abamr169618335ad.19.1795567193320;
        Tue, 24 Nov 2026 16:39:53 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee848c1sm75603595ad.10.2026.11.24.16.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 16:39:52 -0800 (PST)
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
Date: Tue, 24 Nov 2026 16:39:52 -0800
Message-Id: <DN3VG4JCILOO.YN40XHHSWRPH@google.com>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
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
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-4-tarunsahu@google.com>
 <2vxz4idb1i2w.fsf@kernel.org>
In-Reply-To: <2vxz4idb1i2w.fsf@kernel.org>

On Fri Nov 20, 2026 at 10:19 AM PST, Pratyush Yadav wrote:
[...]

>> +static size_t memfd_luo_ser_size(void)
>> +{
>> +	return sizeof(struct memfd_luo_ser) + sizeof(struct kho_vmalloc);
>> +}
>> +
>> +static struct memfd_luo_ser *memfd_luo_ser_init(void *mem)
>> +{
>> +	struct kho_vmalloc *kho_vmalloc =3D mem + sizeof(struct memfd_luo_ser)=
;
>> +	struct memfd_luo_ser *ser =3D mem;
>> +
>> +	KHOSER_STORE_PTR(ser->folios, kho_vmalloc);
>> +	return ser;
>> +}
>> +
>
> Hmm, I am not a huge fan of this. This makes doing such allocations
> quite annoying, and I reckon we will be seeing a fair bit of them in
> many places.
>
> The key observation here is that most file handlers need to allocate a
> bunch of preserved memory, but they usually can free it all at once. So
> we can get away with a very simple allocator that hands out memory
> linearly.
>
> I have sketched out some code for this, take a look at the patch below.
> Note that it is only compile tested.
>
> Perhaps give it a try and see if it does the job better.

I agree the manual packing in memfd_luo_ser_init() isn't great, but I'm
not sure we need an arena. This seems like something KHO slab support
will solve properly, and since kho_alloc_preserve() already takes a
size, KHO slab can be dropped in underneath it later without changing
any callers.

Until then, maybe we should just allocate struct kho_vmalloc separately
with kho_alloc_preserve() and accept wasting a folio per object. For
memfd that's one extra page per preserved file.
