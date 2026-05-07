Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5081F62809
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 09:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778146809; cv=none; b=eI9hd3nOjhX0uo1P8rcrflxk3PHSXkv0gJ8Mz6cM1IqeoQ+WCM65sig+7BjavkjPQ2A1s29Vv4H6Kqd/KIdnGKN3c9/Im9a+fyBpccj4/y0up7WaVJZcnBayDbjihCqgIFpdqFyiULWrltoRYKNUlpoV1YZbawwPb4/HFjeSImc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778146809; c=relaxed/simple;
	bh=//T+uUZKVsScMqNPuY2uDzqT14OVSZxoXfFh1I1LXYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aASgg5X9dNKCNknwAQiHbxEiUwv41sEq0oiSlQsJHQ4ymZgTHqsZtparO2mxh4FDEGHxP1d7jFqrMRME/vGWc7SolOokd/GctmnIcnjAegyd7CouKyP1xOX82hngiSqy87C0hiM5MD0WX/JkZuK6QXDrOlb7CvFzPed3lNI039Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X/w2pbVO; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X/w2pbVO"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48d1c670255so79285e9.0
        for <kvmarm@lists.linux.dev>; Thu, 07 May 2026 02:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778146807; x=1778751607; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iO2qxGV2Dz72sotDpa6WZEWx9OFKl0tlRmAkWtejDhY=;
        b=X/w2pbVOs6JJob2PkEG3V3W+kYJs+AROSXyZVPKAAby+0aL7vHvGBNRacRT5JuIWFT
         55h4mb/S1GIQ7Dz7Fml5DJybyHZ7Id4vx79xoCwsZsa7v9SRPi8ZQNShzkYlde0UB0OK
         lYv6bKuixu+EXAZTaqvp8n8nbVdMey/8HQcdjZ1sxLYFdx4/Mgv+o7N8semakPSFwU4T
         qVkzqYxlWaPFr3c2G2K7y/661F98EEKT5PwdDOlIyKdhP1GSCTeNWUAsx8KX0EiwzyYb
         TTJ0sVxxLKSjfpVnHxqsPoVINcrhOIpiTxNsTzgd1y6IwBQG1l2T+A7D8IcTDzPAZ/xR
         TwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778146807; x=1778751607;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iO2qxGV2Dz72sotDpa6WZEWx9OFKl0tlRmAkWtejDhY=;
        b=sS/W2GW3CBkTinDCogIXqfaRHp1wqIrLFUWYnWewz/aJHjENwA+EuyYk2iYLFQDc+K
         mtGF+PM1+izco8uQVECH9MfYvkVez9VjtgfBIhYTfs3O+PoJurN9bwM4gq0eVaFT1ddS
         stQ5wVxlfMOHF8YE/AtLxBhRvuXD8ffTOolVc5pC2LsMN7lpCAOAkIewuFxzUnf3s320
         6fRV7xyp4l4Boi6vPZZFd2BVUVvmE6SGr6SVnJnhrL3qVjSEW6E2j4pjHOOJePdxI9t8
         tQy7gs7gSHRQHgLU9jM7p2XtvCAOAxGtNXku3+MlnVJEf3W6QOMy1d92LN2+mKqwUXEu
         0Fkg==
X-Forwarded-Encrypted: i=1; AFNElJ9ZJl7e/4Z2e1HaD9TX4D7ZDH+ZyZvh5aSs01qJOuSnPfjGwNZo3XcWgGPRq3hbxkB7Z6xmqjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIXypYuUWeMnmVb0GlEhPgLUkGzmtWqfUgP8xpUifxU4T2MG6h
	f9Y+io7nZJHV9GdkKp44OfxxeGU+PVsgeki385GsJuH3ieeVF9ATTuBHOhdYdGc0ag==
X-Gm-Gg: AeBDievZDl3DUtHcHpqbKa/RRQv+BJkxJb4420l+NmbGrPEnemKTW22fwL4pOlVSCel
	pRD5A78VzotYyOo44bVVzIgvb6O7yEP1czDQw0dLChGo0ybr81N5tdmTk/hHn+S2MbbHT8QpdRH
	VnYjycJYM8/dRYtQmCn1H/3/1gGPKV2CCpCe7l+RzHUWze6RyrtBxh8TZP2gY69Vkk5TrfA1Q0u
	wfFXtc2Z8kYMDPaUqF3ojgvR5lHSwglxpElLKJ5/cjMQt+1I22XwuTO+XbgqX0Xb+XU50+3yRUm
	+nRbqcMKg03qQ8H4lnn8h0M7h/g2dvmDkFZt4rlMBdQ10pzhUXtuSOe0OHSvnArfkiiTkf8lxi9
	q8S5C1uP4VpxVsB9f4Qa5BOIN+8FLk/oCZ2tmB8RTmIUzA6kiUTs66ccSs6QIH6ezsknIz9vSA+
	lb7gtNLgezRdOokjRV0nCUtV5aRULykegY9Il68GWlwVmN3OY/Csm1CvL3JgacbB+4Bx7zk7WRm
	+rrGg==
X-Received: by 2002:a7b:c314:0:b0:48a:5f32:62d0 with SMTP id 5b1f17b1804b1-48e5d650751mr703025e9.12.1778146806189;
        Thu, 07 May 2026 02:40:06 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e531578c8sm38996315e9.34.2026.05.07.02.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 02:40:05 -0700 (PDT)
Date: Thu, 7 May 2026 09:40:00 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <afxd8Km40A5ulZvd@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
 <20260501124143.GB6912@ziepe.ca>
 <afiN1UwS9q6F6A_v@google.com>
 <afoYBYIJOTClsdLS@ziepe.ca>
 <afoeIVIGE-JjYy22@google.com>
 <afsPfEzgGtAFrN5P@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afsPfEzgGtAFrN5P@ziepe.ca>

On Wed, May 06, 2026 at 06:53:00AM -0300, Jason Gunthorpe wrote:
> On Tue, May 05, 2026 at 04:43:13PM +0000, Mostafa Saleh wrote:
> > On Tue, May 05, 2026 at 01:17:09PM -0300, Jason Gunthorpe wrote:
> > > On Mon, May 04, 2026 at 12:15:17PM +0000, Mostafa Saleh wrote:
> > > 
> > > > I am not sure if it’s worth it, the hypervisor is much simpler, there
> > > > is a single page table, it’s locked (also identity mapped), it’s
> > > > updated on VM boot/teardown only, we don’t even use iotlb_gather at
> > > > the moment, although possible but I wanted to keep this series as
> > > > simple as I can then we can add more features later.
> > > > So this patch is the least intrusive change, as whatever the main SMMUv3
> > > > driver does, the range tlb invalidation logic is the same.
> > > > But I am happy to experiment with that when posted.
> > > 
> > > Okay, then maybe just always push a full invalidation?
> > 
> > Like full address space invalidation? that will not be optimal and
> > will affect every device on the system, why would we do that if we
> > know the address?
> 
> Not every device, just wipe the VMID. If you say it is rare then keep
> it simple. If you need to be narrow then use the proper infastructure
> with a gather. No reason to make something boutique for pkvm here.

But all devices share the same VMID, which impacts all devices on the
system, and is not that rare to ignore.

I can add gather support, it’s not that complicated, it is currently
supported in Android.
But that doesn’t solve the problem, which is: At some point, whether
eagerly from the page table code, through gather sync or a fancy
invalidation array, the driver will need to populate a range
invalidation command (tg, ttl, scale...) and this logic is better
shared with the main driver which is this patch does.

Thanks,
Mostafa

> 
> Jason
