Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EDC3FD152
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778509468; cv=none; b=EfziKCE5VsquS3JuSdvCOesunYCFIEV6UE0q1yWWlB68UQyAPFoA4iGLziqR4+scEooPylZh/o6FvgNWHNTM0gznWXuGM2gZORE7C5outtmXHck3KHhgmzbMP/3qtu3A1U/1V4Dgfruod176TNx8pDlpVRMiB1kN5pqy7rJCu/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778509468; c=relaxed/simple;
	bh=7tNpnX1gFQ6tZ3oOp3leOMqhI0tgTzBeVDf3yJe9700=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s8g42z+k38PZ5RjmAJIy++OKC+2r0EY25APH+/N/7SpzMkEFYI6dW0/KivHfGzsZU91PUdrNf8+yoKZvtSIZUbbxck18zQoXeemcBrNjXHZfCFC83imkKWV3Zwfhsp7sIyHujNO98G842U+1vtSUjPnC/iee3FsXGUNRlkSytZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=i7CkzapJ; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="i7CkzapJ"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8e8c0c2d2bcso574803885a.1
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778509466; x=1779114266; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jkQyUrfkqfz8XQIv/dWok02t1PybehRH8tb5fDYY/+I=;
        b=i7CkzapJaM9p9UWFRM29AXu0kUBLSrmr1K84SDhJ9yRcdFjinJz0w7N8lufhqvDsmB
         mqJvgc+ObxmWOg0DyjBZ7FqqEDQvMXt+vMBBlQkMtpDvPY8keOfUyecYsVekGqql65p2
         yy+b8q3kRrHW/+CHwDvpUrtAus47rGh5GjZYrK4dgrCbUJKssQFXN4EGLNIRMhq/W913
         yYZ0B1YOauTnfBumYJm+MxrJtZmx7BDLmTSHSAm1jtIspICtOVd7M1breaQ0WSPlKMDS
         Hh6kMOA8YD5CMBhfhAOgMQRG9BeqUzsYKfuPn6ac1WBHAyjf5WQsgXF4+Tc/famXBGbp
         hd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778509466; x=1779114266;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkQyUrfkqfz8XQIv/dWok02t1PybehRH8tb5fDYY/+I=;
        b=W8B6RCtcrS1pboiDKMQS1NDjEMAh3KtsgLTEAaTfGHQkT6E3oaRD5wRKewbab8q8ZY
         tRMwJ2IYHIuPLYYAyxHdqWcWWx+kXLZdfWb/dlwZT9WDPL+VDNzAlOpI468EZCmv/wfV
         TJ0rdarfdJNCzy/fTEH6g2ti2r1kcTONwUR4bD83kHDt27F9Ciyn87kKm8DK4hzL+lcx
         jGTJNflCxqqpfhmerlP95O+jwbtEKzd716YNFH3Dpj6+qHkmFHyh/d1fm37DiQ/Ai/r5
         94gEIhLA89bKFBlAZnLFlWw0HgKk9wjwOl6NgYHW9Zagnag2twXcHyqTgvIZ2JliTSoX
         nirA==
X-Forwarded-Encrypted: i=1; AFNElJ80uP//rRiCEJ6BSAkNOL0Z2coBQ2fawG8grjTx1xB96/kOdPgLXcDyry38XN+5RVrVyrW2FQs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWEi5QxIlCDWf7M3YG6iFjK397atKJOFNVOzOPsU+avTXSZ29i
	F48sHQfVXkgvzSTH52GX5qafZdwDKSrwGn5Z+XmkVLPwvyR0cuWDoCw747xZFBCZFiA=
X-Gm-Gg: Acq92OGWBbjfkXifV+BPVHo6xnHEJLwDGKdtOD/kdHSA/u/B2rFu7BPWyqfGyIx44Fb
	4PYefT7kegSOWduZ7rwpIKfd26r4LC41Q3Pujmwtm6OpWfEoTtFx6HZIJtjKkGU7zfbOH6nt7CY
	5Qw+6BNT5ev85dO9WuFlkZPeaF68xANJzq/ME1KHbvfou/ULXUiW5dVEZiSSpiND5XoUMdITZYC
	Y0EotahgI5wbDNTATNl+e7Dr4jvQb2EGQfXVMuSTJZATMZK76mioLqTQ2M1wwQMTDwuSewwZ58y
	BBwUJsLuy/MkdsztGHymeBU0xd3DZhH4M2eI5HZOdVTjYSFaisk5d1hv/VZT/PaEAMZEuAv1g9s
	WGKP+sGrGhoMwQ8FMw5VDJSOwwW2oyU8+ERwcmkYX+iOOnrp2psNcPOfIK8xlY4MbuTKkcpXF+d
	icjHUD/92BQBHHn/BaHL3y+FVzH8byv2ji87OR1sF5kcJd8kbJxtD9J5y2MNcJI8k3M1kTBgJop
	XvgsQ==
X-Received: by 2002:a05:620a:19a0:b0:8ef:6b87:5c5b with SMTP id af79cd13be357-904d3eafa08mr3652391585a.9.1778509466038;
        Mon, 11 May 2026 07:24:26 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91cd89sm3166863085a.35.2026.05.11.07.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 07:24:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wMRYX-00000004oFc-0DRM;
	Mon, 11 May 2026 11:24:25 -0300
Date: Mon, 11 May 2026 11:24:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <20260511142425.GQ9285@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
 <20260501124143.GB6912@ziepe.ca>
 <afiN1UwS9q6F6A_v@google.com>
 <afoYBYIJOTClsdLS@ziepe.ca>
 <afoeIVIGE-JjYy22@google.com>
 <afsPfEzgGtAFrN5P@ziepe.ca>
 <afxd8Km40A5ulZvd@google.com>
 <20260509232931.GJ9285@ziepe.ca>
 <agHBby1qBvR6cmJY@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agHBby1qBvR6cmJY@google.com>

On Mon, May 11, 2026 at 11:45:51AM +0000, Mostafa Saleh wrote:
> On Sat, May 09, 2026 at 08:29:31PM -0300, Jason Gunthorpe wrote:
> > On Thu, May 07, 2026 at 09:40:00AM +0000, Mostafa Saleh wrote:
> > > But that doesn’t solve the problem, which is: At some point, whether
> > > eagerly from the page table code, through gather sync or a fancy
> > > invalidation array, the driver will need to populate a range
> > > invalidation command (tg, ttl, scale...) and this logic is better
> > > shared with the main driver which is this patch does.
> > 
> > My point is this patch doesn't share enough. If you do need to issue
> > invalidations then share everything below the top level tlbi entry
> > point and don't try to make a pkvm version of the entire logic just by
> > ripping out the range logic.
> > 
> > There is no reason for pkvm to need a different algorithm
> > here. Especially when you get to supporting ATS and multiple devices
> > and smmus you may as well just use the whole thing.
> > 
> > Which is why I suggested to copy the entire call chain into a shared
> > file
> 
> Agh, actually this seires doesn't deal with ATS, which I think is
> wrong, propably we have to issue CMDQ_OP_ATC_INV for the whole
> space on every S2 invalidation which has to be done per-SID and
> as it can't be done by VMID :/ or just hide ATS support from host for
> now, I will look into more for v7.

Hiding from the host is a fine solution to start with.

> But anyway, we don’t have to share any logic, the kernel driver
> is quite complicated as it is designed for a different use-case.
> Doing that makes the hypervisor unnecessary complicated and
> oversharing this logic makes the kernel driver less maintainable IMO.

invalidation is complicated, you should not try to open code your own
version. You really cannot make it any simpler than what is in the
driver, just use the code it is already decently modular.

Jason
