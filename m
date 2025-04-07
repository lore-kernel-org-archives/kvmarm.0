Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17261FA177
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744039213; cv=none; b=j9ZPcrIZOEskYOaSwzhBSiNoYYDcnEJ8vmI5yj/TvYKk5DfUH2roHSQmUugPxfTdm4XH69sHoD1b10uaXMWYwUproisqSMwVEwcr4D9ZrvYpNxHzPbZXmiH4nH5seO1Ezqx0LYlxzcyme4esD0IcTr6pnSxNcqIfV6mS6/vK9KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744039213; c=relaxed/simple;
	bh=u/+KVCI1VmXvlYSWB0tmccv0ERLAgE83Zf8S0Xrnhz0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bGgPz4dJIRuCeWZTfI2mQgcewXO1ifeUwO4qBCmwIZgoNej1ryHVg280fukvZsoc+q/azFc5vUTBj1AJUeaHyChemSWmZN+hGiNNRw1IfYHAmVMqywlhkr5q2h6MPyUgcUiZZPGEI6Ui394W+uzNj+sCMGtIGGKyFWKgOxfYELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ju1R6sum; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ju1R6sum"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b00aa1f50d1so148409a12.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 08:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744039211; x=1744644011; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JTNpEax445O2ynSr3XUTtKC9NAWm3dqDTuE2ry3Vens=;
        b=Ju1R6sumKCOdkHCfxv4b6oew+FyJ1+i1ZV71nWqmJEGFjCOShiWVkZjwqa8G/nrOQk
         bf1vQPn5Jym6KhVvXGKUsb+JUP3FrHd2E4TBWZIotjAOV3U4MMIZ+EvON7NMjG3TNV2V
         MH34MEfLXwWE/pdtdClr7Y7LYO8D79DKWY0THqjFlwwW5N0sfmaygSx9KS4WBaXoH0YU
         HIZff3kXNCkSIriQwIKiEGNEygFq4sonKNtrYl9ai1rqKvTRhwKNy8uNTRCCNeB37EsI
         gTyR495xJIJ6CwByXeg8D5Hmp+lrzFDZDt4KpxbOojlFCRfNI9bhReG97Z76L6tpMMQX
         fdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744039211; x=1744644011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTNpEax445O2ynSr3XUTtKC9NAWm3dqDTuE2ry3Vens=;
        b=qIHslQsZEDEeRjG7lt+8kA+l50mXj+9HHj5hJthKy49IfvPRLyaoyl5hCfkWYDzYYh
         tPinxhabUN3KBjmvNs7rUPcmMurmY4fb0wwa9Bzs/o+8nt/53PL7L3KsHB7mkAOvMUWg
         LjFejYj7ib8Lq+di6VJSTXc52z2PfgtfNBN+HGOwIwl2Mg/3HtmxqABC2ydVD74kYw5R
         IAgFc6JuQwMUa0BYUiY8lT3BcdZMOpX01K07VWyVls4t3Wbtb+RUsuJRAZNrmkrhTRfv
         TXj4ATsvX/MOfIn8rBjop5AO5603xjqvZhltWendhyNpL7Hs5WmSZlRaPoJblV1WwHQw
         SXDw==
X-Forwarded-Encrypted: i=1; AJvYcCW0NwgBoIxdMTakFILypwxBEWblqW7VzoklS3MqjnQeAaNIZnSyUgkEn4odIbCJotdzini+RG0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcrLFIJuZowxxyQvL+0jGoIPHZxvS7/ziTE+dSyW5UjVFybBiL
	KPrhclJ08uaIKus3eXSBKlRRvFTVBm+/GFRABOEpBqdowezm/n334eSCABiD26+jJrocBMeWiJ/
	7VQ==
X-Google-Smtp-Source: AGHT+IHFT5IWpb0wEWYBsgf38l3iAGlVDr2qHVuyYE70TQA84d8Gl7Htq0vtNTpBGTTuOvXXCqA42VAV2Ds=
X-Received: from pfbhg1.prod.google.com ([2002:a05:6a00:8601:b0:736:3d80:706e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3bc8:b0:223:5124:a16e
 with SMTP id d9443c01a7336-22a8a048ffamr208407455ad.5.1744039210859; Mon, 07
 Apr 2025 08:20:10 -0700 (PDT)
Date: Mon, 7 Apr 2025 08:20:09 -0700
In-Reply-To: <20250331145643.GF10839@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <Z9sItt8BIgvbBY8M@arm.com> <20250319192246.GQ9311@nvidia.com>
 <Z9s7r2JocpoM_t-m@arm.com> <SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
 <Z-QU7qJOf8sEA5R8@google.com> <86y0wrlrxt.wl-maz@kernel.org>
 <Z-QnBcE1TKPChQay@google.com> <86wmcbllg2.wl-maz@kernel.org>
 <Z-RGYO3QVj5JNjRB@google.com> <20250331145643.GF10839@nvidia.com>
Message-ID: <Z_PtKWnMPzwPb4sp@google.com>
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

On Mon, Mar 31, 2025, Jason Gunthorpe wrote:
> On Wed, Mar 26, 2025 at 11:24:32AM -0700, Sean Christopherson wrote:
> > > I don't know how you reconcile the lack of host mapping and cache
> > > maintenance. The latter cannot take place without the former.
> > 
> > I assume cache maintenance only requires _a_ mapping to the physical memory.
> > With guest_memfd, KVM has the pfn (which happens to always be struct page memory
> > today), and so can establish a VA=>PA mapping as needed.
> 
> This is why we are forcing FWB in this work, because we don't have a
> VA mapping and KVM doesn't have the code to create one on demand.

I don't follow.  As it exists today, guest_memfd doesn't touch the direct map,
i.e. there's already a kernel mapping, KVM doesn't need to create one.
