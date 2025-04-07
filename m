Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BD920F073
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744044233; cv=none; b=P0yT64CxIH4gOfHt4H79ZOowylv+BI0TalYCFzbm/qcY/hONwhAwWdwJEzeRNDrmxMD5vyFw57IU3mYLNzMSJYfTeiTE91aKO+UV/YJ50bKt8EHHp19llicvbskQIA1lKHs9QN82kml9gnszWjMrNaeqyUqxhk+qiJgBBY25Qvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744044233; c=relaxed/simple;
	bh=cvAoqYYxoVMrWTFQTgtR+e3WJRdshdcv4fcS4uv/p7U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YeHx1DsXft9bdos7d7UX50E/pbaExta2wRhMJjl3ImGV4dNYETfidar7OxNK/y8gWVwmjgDDZVSCyksEzEG9W9ywdXSW3y1IibV+VCJ0umXThUiEvHW/3tb7cVB96pMKu18sA4oybXYQaVgnzZDCqcqsROmbunVYdbVcAu4L7Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HLobqXjg; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HLobqXjg"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736bf7eb149so3352595b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 09:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744044231; x=1744649031; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yZnT3kn0lZwBedm0uGPv3h/z1Jk4dbKRxwN+6F5eRc0=;
        b=HLobqXjg727sH1rL385UHBnctjLKBQR9mXaNEbe6jdsHcHAERUtxaGcuxfnpSkZfzZ
         CyDEs82w6KaXI9sQ5ffjWTyEa1KHdgC1TCHPsazk+6aJwrVrE9Jiif8KMGShBWiUjrYU
         RlOJ6B6mFNMcxOfuNM1p+ON8RQ4Y+7b8SK4DTXfEa2HyGjZEUR3SU9GasIr2PHCpxNWT
         rX/c7BMg5JhBB3RjNKmaxqEJpBRSRGGz6Hyf6VstUaBueT4kijrsMMmqD0CGvAtLitBH
         VgXNQR/EjRL0RhrQ7K6RFQv1xLkGpWrlAHx099CqwgjgIdhsivzrK9UZo7GIGJSl8+/p
         g6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744044231; x=1744649031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yZnT3kn0lZwBedm0uGPv3h/z1Jk4dbKRxwN+6F5eRc0=;
        b=l+iM34Ieo5lr8K9k4Nb3a2geBgNs10P+OYy3m3KqLNU6EX8y+iRPAeOLMEmOyBvc3h
         TDYiGIr2C9JV9t4Tl28Wk8NkgYM7vNb3Bke9Yvso/guyrcKCn/M49mBvNP82+VlgRqLR
         T0cBGJO0MMosA7RComRa5v0PZSAbPb4oHoHSkqFdEDmfhbq4ZAcEtFQjL5JtuIZWxRjO
         +esZ31g1akVCoyjT2qcFtt7xtNKbJGJsXHC9eGKxatUUxMelesGYCKU1uq/RsjKPSrhc
         AtWprOlGNIO0k+9q1eT0GOINtpB92nUlYMnbDvWXfWB0hcfewMLfWTR6WDaiQhFmpuaY
         uJ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXVaMyZtokJVLB5LpMQGzWdLwcTbC2TC7QoZCLOgIjhkDw0SI9FbSstpygU0+lnPbwtBWZfm5U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzamwPvppejDb03hhXxlfODAxHX8rHcFolIpso+LY5K1WINa23H
	W6QSeIyfTPG3s8waywBsk4wYbnkBuBUuhfZ7CGeBDlOZlyAtHBEmj2qN1aEgib+9MqnrUwa3pyV
	/Mg==
X-Google-Smtp-Source: AGHT+IGF8eBnjAYFXIPI8U2dRPCijHocf42fEz6xwJrtVSsRVB6bz3zjqLRx5gwWh1OyqfcDjPG12qk0yPY=
X-Received: from pfbhu13.prod.google.com ([2002:a05:6a00:698d:b0:732:51fc:618f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2d04:b0:1f5:7b6f:f8e8
 with SMTP id adf61e73a8af0-20113c095fdmr14665309637.6.1744044231220; Mon, 07
 Apr 2025 09:43:51 -0700 (PDT)
Date: Mon, 7 Apr 2025 09:43:50 -0700
In-Reply-To: <20250407161540.GG1557073@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <Z9s7r2JocpoM_t-m@arm.com> <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Z-QU7qJOf8sEA5R8@google.com> <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com> <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com> <20250331145643.GF10839@nvidia.com>
 <Z_PtKWnMPzwPb4sp@google.com> <20250407161540.GG1557073@nvidia.com>
Message-ID: <Z_QAxiEWEyMpfLgL@google.com>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marc Zyngier <maz@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org" <will@kernel.org>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "shahuang@redhat.com" <shahuang@redhat.com>, 
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "david@redhat.com" <david@redhat.com>, 
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, 
	Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, 
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, 
	Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, 
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke <udhoke@nvidia.com>, 
	Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, 
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, 
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com" <coltonlewis@google.com>, 
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ddutile@redhat.com" <ddutile@redhat.com>, "tabba@google.com" <tabba@google.com>, 
	"qperret@google.com" <qperret@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 07, 2025, Jason Gunthorpe wrote:
> On Mon, Apr 07, 2025 at 08:20:09AM -0700, Sean Christopherson wrote:
> > On Mon, Mar 31, 2025, Jason Gunthorpe wrote:
> > > On Wed, Mar 26, 2025 at 11:24:32AM -0700, Sean Christopherson wrote:
> > > > > I don't know how you reconcile the lack of host mapping and cache
> > > > > maintenance. The latter cannot take place without the former.
> > > > 
> > > > I assume cache maintenance only requires _a_ mapping to the physical memory.
> > > > With guest_memfd, KVM has the pfn (which happens to always be struct page memory
> > > > today), and so can establish a VA=>PA mapping as needed.
> > > 
> > > This is why we are forcing FWB in this work, because we don't have a
> > > VA mapping and KVM doesn't have the code to create one on demand.
> > 
> > I don't follow.  As it exists today, guest_memfd doesn't touch the direct map,
> > i.e. there's already a kernel mapping, KVM doesn't need to create one.
> 
> This is not about guest_memfd..

Heh, my part of the thread was.  I was responding to Marc's comment:

 : Remind me how this work with stuff such as guestmemfd, which, by
 : definition, doesn't have a userspace mapping?

I'm pretty sure we're on the same page.
