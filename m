Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86303152788
	for <kvmarm@lists.linux.dev>; Fri,  3 May 2024 11:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714734100; cv=none; b=Gy+DIRIR3Z9CVsGwtw2Z4xHfcJdZYTplMTGlsvs5zKRsTZX8gu8yC/+ELjI+wthrwxJ64NfOltZjbnSfyoWC52cXj/0NfgXgcDBnIogCkaKqhv5F0vT+3ZpQ1SvzCAtQkQGumLjvDBtG6CWhU5yAJQXluH+zpUUL8R4Fmlx4NDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714734100; c=relaxed/simple;
	bh=UQCloiX3c/KJBlQsBJGrwnc3Ql1oJvoDpAJQP1qJtMc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lDP73fG1iAovhIXr3hma5dc6qnN7JD/DyPtYdkJsaR+CkX5/TzQxJAbwJ1NRhrz5e0G8rfEEJmXbiSO2WXqqj3EAfPnDQjux6TNztu4N/XY1hsWN75w5ZHNCjo/SM1lqDyK/2qilRSC9ocepqBqndgmKCDj70dZcmYuQFqO+Zoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EtC5xR75; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EtC5xR75"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714734097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UQCloiX3c/KJBlQsBJGrwnc3Ql1oJvoDpAJQP1qJtMc=;
	b=EtC5xR75m+SL09xondwotMqJpgKNEuBTUmX2VMAx0lerPhzaXWqT8t1D2gfeQ9TN729Q8P
	R3RFkBlpHNaN9JcsD+o7QkmUOOoL50EPBrxlpHtvYvCHfG39kZhkGa33sgPnQdwXSPITJT
	T9MaVCmlgfhB8TJITH7aScnjDLWZGac=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-o5zM16w1NWqt-p99q-rDew-1; Fri, 03 May 2024 07:01:34 -0400
X-MC-Unique: o5zM16w1NWqt-p99q-rDew-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-790c61cdb29so601208085a.3
        for <kvmarm@lists.linux.dev>; Fri, 03 May 2024 04:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714734093; x=1715338893;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQCloiX3c/KJBlQsBJGrwnc3Ql1oJvoDpAJQP1qJtMc=;
        b=ShVROq4MTCFMMxM3QYQ7M0CEB1rhx5UUmHSnVd1Yaj2jEmN7BcNcHLlyAcu4DYKK2L
         1FdqDNxgUawM2yimAyNfcF9LaXZAWkRk3Ph37IpDPQGN64ZEZPAwSkbfYleOwx8G+lKT
         pl10mdzmXP4JgfQY9955sddrdKwpc/XlrGbBPTLH+w/O2uiAKkFh2qrbbTQ5lz1nCTj6
         evcn179RI5zrDH55R0cciX3PNX3l9NjE66F+2IUaPM/WwJXWYH/cBOeq51PMRbt2zyVD
         vRplF9kCpbuNU/YA9nNNjUD9k0NsmFgCYZdtJzv3bh49gYFytSQXsqcbtrjLNU+TM8D7
         uQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUWI5D0nY1eBo/qbbhdYBdgBvrQ8nOzBSDZIQpSDvAExOwmekkUlTLKMwRJZyfv3na//tW8KD8mBFMee2B8B5W3VuvXEDHa
X-Gm-Message-State: AOJu0YyG1dqIn+za7GzJnW2NNWbSkM/DU2z32RPw2MLWOp7C4ssy3HNf
	j+jV+6togpkzzCBqdtJ5R6sSOkxQ71dT8OL/hBdj+R80GYexPpwQ8y7qiYDewGM9ZaRzt7pxLqk
	kelC9TkYsfS5EGD3cH4D3Tp8hOO+Sa1oiCGaHnQ3UdTNOE4LdoCUo7vWv3KO8ig==
X-Received: by 2002:a05:620a:4412:b0:78d:6377:33a6 with SMTP id v18-20020a05620a441200b0078d637733a6mr2934062qkp.66.1714734093390;
        Fri, 03 May 2024 04:01:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEO6LE/GI/eMlo7xlWJ52xIvHraHShveurskORqRDPjdGmEWvDY/jklm4FvgSaNXa9nLceCgg==
X-Received: by 2002:a05:620a:4412:b0:78d:6377:33a6 with SMTP id v18-20020a05620a441200b0078d637733a6mr2934028qkp.66.1714734092998;
        Fri, 03 May 2024 04:01:32 -0700 (PDT)
Received: from rh (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id a7-20020a05620a124700b0078d667d1085sm1128144qkl.84.2024.05.03.04.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 04:01:32 -0700 (PDT)
Date: Fri, 3 May 2024 13:01:27 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/6] KVM: arm64: emulation for CTR_EL0
In-Reply-To: <ZjH6mgJa-ilmPu95@linux.dev>
Message-ID: <c7dad35e-1a7f-74fc-95f9-ffd9cdd53f95@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com> <ZjH6mgJa-ilmPu95@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Oliver,

On Wed, 1 May 2024, Oliver Upton wrote:
> On Fri, Apr 26, 2024 at 12:49:44PM +0200, Sebastian Ott wrote:
>> Hej folks,
>>
>> I'm looking into supporting migration between 2 Ampere Altra (Max)
>> machines (using Neoverse-N1). They are almost identical regarding
>> their feature id register state except for CTR_EL0.DIC which is set
>> on one machine but not the other.
>>
>> CTR_EL0 is currently marked as invariant and migrating a VM between
>> those 2 machines using qemu fails.
>
> I left some feedback on the series, but in addition to that would it be
> possible to augment the set_id_regs selftest to exercise the CTR_EL0
> mutability?

Yes, sure!

Thanks,
Sebastian

