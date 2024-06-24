Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61AA19FA92
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719257351; cv=none; b=vDFYDkRzsWBZCoQ1rsVPNKkNnA2PtfRYk2axa+XvAC6m06+LNU7rv0zKbk1bGCNV7k4ceWlWXALKBlAs3vaUnEktfLu1kgfwJpIyvAU/swvYJcRsWVz9DHzXRFr+AYwIIXzxk5ntRlrvR/vNLEAGjPALjUx0xtfSYDbAQE9Mh1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719257351; c=relaxed/simple;
	bh=kou0KSviaUSwwEIGegfxNam8WKKJA68GYbWIqPfqplM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dXwH0vGhI5jkxTYDMqayQGRQTRqcWW4T6qpdBn49AqGPkzAk3Y+i4tsN5pQqNSbS1QZ5VgsHFjShWX0yeBJOcMV25tS9wNMujyZSnSccpVv5PVjA29V9XRRVvxcRP8aEZCLBQWC1Z7l+rwzailJ52uiz3B/597I61M1w0aNxHPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YDTCCvCT; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YDTCCvCT"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-70d8b7924e7so5206333a12.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 12:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719257349; x=1719862149; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TVuLYAHX8gXy6iGoDlxWfTLH0m/dbWsxwJkE9QnlL8o=;
        b=YDTCCvCTDbe1MCDRhsGSAa6zzXY/Y0PPyKQlq4TSYatSa12ONkVVhNyYmKUxHZ4Af0
         FeZUi3rzpUCwunAsop+QfDiOg0+/uPiwgBm5wqvrXPZUicJK3J8VGKAeEethxQNyiluc
         ZIMdeBgCoYBGqa0BWafKXBNbQPPLNFqS8G84L9f0jSLNGZhuSLXgCi+Ku9sjSpymXVWD
         IIqgCv5tPlvUlLE4INuG8aDvcpu35LzzjZFKlgVVUXffGYy1Q5aOCL3iwXYyWgKPSnGl
         YVcvSl+e7dWFY1SlKLNkyRwWchc0HPNQMNvefewIzVPnsY1y6VJhUdE9H/2yzUDb8sUK
         D7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719257349; x=1719862149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TVuLYAHX8gXy6iGoDlxWfTLH0m/dbWsxwJkE9QnlL8o=;
        b=iBk87OEHzT0Fzz+Q5vQudxFpJwM/i2x6eb5cUEcVV+bKDacC/HjYYraKXXhZ2N+l6G
         CxbNHCdfoT9ftSqY5XUuz58aDsqQpCcbDde1vGmHIGzELJqpQMettOOyNniyzH38TLWn
         8bi6TMuEmm8yAXIrrHyk6aavr05nx5fDBTLedKmEy5PWdkt1SPTtbI23O7nJf8ymOqWH
         NKEdLYmak4JKtX5HN7WvkTWvylzDsPI6/qtn8goYxhtOPsactcA8Zez1c2cZ/KSMeSz6
         yOBPnb6jsHjgBK786sMjjiUUaO3RSVeKyNzf6Q9nmu7EV0sXLGvr477R797OraADqeq0
         DO6A==
X-Forwarded-Encrypted: i=1; AJvYcCUNJQDXwc4B1RwNs2L62iPsWCAx/FtIO1019LUXzL+pHo1M0NXu+QsKKPBq+Mz+Nd1MHwy2M+4YOoWN+V+vgwY4iyML56ri
X-Gm-Message-State: AOJu0YzuwFw6wfYLBnIfNWlw8PYTEN7zYYeVTe7lTrXU5+XUeUxwkC+g
	oY2s3XBJ+42+49jYMobZjbI1UTDEpNmNdtIQy0nay3P72UqeIjZh0qhuVbxhZQdWpejzSqTSBmY
	Grw==
X-Google-Smtp-Source: AGHT+IEJKp/82XGN5zTzJceOYTl1iz+gFaSHnIG6fY86rBs+MqpT0OdjuXJwtSsYk3DKzCheG/u8hCds3Mk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:51f:b0:6ea:320b:a2af with SMTP id
 41be03b00d2f7-71a363d4e8dmr18982a12.5.1719257348896; Mon, 24 Jun 2024
 12:29:08 -0700 (PDT)
Date: Mon, 24 Jun 2024 12:29:07 -0700
In-Reply-To: <ZnnFML-P1dzHdraI@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca> <ZnmkbOfWBJHrO2sx@google.com>
 <20240624170747.GA1515249@ziepe.ca> <Znmy3QPAUIX9SnGx@google.com>
 <20240624180148.GV791043@ziepe.ca> <ZnnFML-P1dzHdraI@linux.dev>
Message-ID: <ZnnJA3ueCXsDtyB7@google.com>
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com, 
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	jonathan.cameron@huawei.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 24, 2024, Oliver Upton wrote:
> On Mon, Jun 24, 2024 at 03:01:48PM -0300, Jason Gunthorpe wrote:
> > On Mon, Jun 24, 2024 at 10:54:37AM -0700, Sean Christopherson wrote:
> > > > > And assuming that pinnable VMIDs are a somewhat scarce resource, it wouldn't
> > > > > suprise me if someone wanted to add cgroup integration, e.g. similar to the
> > > > > misc cgroup that's used to manage SEV(-ES) ASIDs on KVM AMD (IIUC, an SEV ASID
> > > > > is analagous to an ARM VMID).
> > > > 
> > > > Yeah, but if someone is using such a cgroup then I expect they will
> > > > also have an up to date VMM that doesn't trigger this VMID allocation
> > > > in the first place...
> > > 
> > > I suspect we're talking about two different things.  Either that, or I am really
> > > lost.
> > 
> > I mean KVM will have already allocated and charged the cgroup for it's
> > use of the VMID. The IOMMU side just has to match it, no second
> > allocation of a VMID.
> > 
> > We wouldn't charge a cgroup for iommu and kvm sharing the same vmid.
> 
> I think the concern remains that an operator may want to limit the blast
> radius of some runaway VMID allocation in a system. But you're right, a
> well-intentioned VMM should wind up with a single charge for all the
> stage-2's that used the VMID allocation.
> 
> > > > When a KVM is present then the iommu needs to adopt the VMID of KVM,
> > > > and that should have a mechanism to ensure the VMID is valid so long
> > > > as the IOMMU is using it (eg because the KVM FD is open)
> > > 
> > > Right, and that's what I'm referring to as "on-demand pinning".  For the IOMMU
> > > to adopt a KVM VMID, the VMID needs to be pinned (or KVM would need to notify
> > > the IOMMU every time the VMID changed), i.e. every KVM+IOMMU pair pins a VMID
> > > that is managed by KVM.
> > 
> > Ok, right, yes, the expectation is that KVM allocates a VMID at some
> > point and it stays fixed for the life of that kvm.
> > 
> > If KVM can change VMID on the fly then that is a further complication
> > :\

Ya, as written today, KVM doesn't assign a VMID when the VM is created, and instead
allocates VMIDs on-demand when a vCPU is run.

The KVM changes in this series allow "pinning" the currently assigned VMID, i.e.
tries to address that further complication.  But because of the on-demand
allocation, there might not be a currently assigned VMID for VM, or the VMID might
be stale, i.e. re-assigned to a different VM.

Thus, kvm_arm_pinned_vmid_get() can effectively trigger VMID allocations, and
thus cgroup charging and failure.

If I'm reading the ARM code correctly, the intent is to cycle through VMIDs as  
necessary so that it's possible for every actively running VM to have a VMID.
And maybe also to also minimize the number of TLB + I$ invalidations?

> > 
> > > Hmm, kvm_arm_pinned_vmid_get() doesn't fail, it just falls back to VMID=0.  Which
> > > seems odd.
> 
> This is bleeding a bit of implementation detail where VMID=0 is known to
> be reserved (thus invalid), it'd probably be better if the
> implementation actually just returned an error.

Oof, I assumed using VMID=0 just caused a loss of performance, but this makes
it sound like the IOMMU mappings will fault?

> VMID=0 is associated with the host's MMU context, which is relevant when
> running {n,h}VHE mode, as the VMID tags TLB entries even if stage-2
> translation is disabled (HCR_EL2.VM = 0).

Heh, I assumed VMID=0 is the host MMU, Intel and AMD have the same effective
behavior :-)
