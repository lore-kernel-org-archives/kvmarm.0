Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79A92F24
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719247984; cv=none; b=PG1xzSFfL4qNw14ZYEo/GuqrVU5CXFYZ9OlipUicjgr2N6IXBma9hoiHbrRsGQPK+FzYmAyeY66wMvKoGkRKVrZ6WRdmrfo+C6vLtyC1e/y8xmHST6YpEhdCwDg+8344lvJ49hEpROAB6N95sOc1SAC+JvondmKO+ckIjlDYtIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719247984; c=relaxed/simple;
	bh=CYijBCP3X3CrtBVUy6WjsmMBWxuht0AzG46f4ntl+vI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YQSx4m0hl69mWDk+DhE+M4qMGc/klzuCqNLWakNp0NOnESHM9GJW4zX03cVBFDXZj6mseYuTcytDtc6yKvROY/p/WbstV5W0+GlU6AR4/AYUNdD6rR2J8PgbcOxk0KXVAw3bs83MQXgsEXNTE3tpg5wjbNKAgGLgTsvpjxv9+Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CEGR/Whp; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CEGR/Whp"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfe44496da9so8745659276.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 09:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719247982; x=1719852782; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9iNykJAzove/zf+ZXfa+Ojht8siTvjot0NY03mffCkE=;
        b=CEGR/WhpsilKto1X4CJ/r83l4KstWqewpJqoQfTl7yKvECAk9V11B6WRxlLDLu1hzo
         MU+PiDB6cmxJra93JyZAV7qrus29QgTSXgIAgGcweEG7Zs0OvPN939K6zCK22eo74HKC
         B1oRiZihZ0yFHPi/DsDkpuvMDWNQhlhM64J8DVoilfUOg7Gw/+1ZOSHDzYtin04oYzdp
         Sd73wP+DqqNZW3MOwZKigOUDxYDkssSqGUgXFyNdlQF+G5BFXV9TpwXmDtjK4moU0R8t
         v5jBPFX272sGKLOuloq78YJhZyKq9PKgwTLoh/gsrv6PQ4H34U7ju4TUOfHDc2FOoP0e
         1Q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719247982; x=1719852782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9iNykJAzove/zf+ZXfa+Ojht8siTvjot0NY03mffCkE=;
        b=aClR7QVYX90g1g7Psp9ewlXJlXdhKygRnZmJ+xVrTuyiqKFeXycR4fkm5pLuR62FTq
         L6WKxfY3Rx1ZFgt6ubfcMTH+B+Uf6mqqS+u1B0MTVzZsD5z9LbslkWFSH2ZIIM9X6yHk
         9hyqiqvha4G2VNVCk5azp3sXHzQ98hkF6at38/IitPV10eJu4BDs6rT1vU8VHmeH/c5J
         xD5rtR9jNhZq4xVdXMArXSDvmxWfeLqHw1Q0RmwK2LJ6QQdus5IAMwMb9HiHOOhjXEXe
         u81kOsLBtFgC3PfiNOfZfkwxAwPM+TVztvWA9mjMJF8pL4Q7ovRiMhZQDeablf3gwHC2
         Pshw==
X-Forwarded-Encrypted: i=1; AJvYcCUTHmrTD9BL1HIBrVPb8ko7fajvPVka7Tg9YOowLYVoba3mlaoxkQ9Yzrp4o0POlBjcymImCJjwon/ywREG7iYsXfXbed2U
X-Gm-Message-State: AOJu0YwSs/LXJdodsaPIwhi/4pAMnFm5zBkcJxwYbxMf+d1jlCpvNjlB
	hKZeOq6R/SNtuoAjUIjJbqU48AL+TjEcCYnIgStqOeZzVcSk7ihxaxQet3xEGYDlGnDtNJ3lzM3
	wIg==
X-Google-Smtp-Source: AGHT+IEPXu/gKdcESrzvh7SoSsa9p93Pm1qfCCz4PS8Ka0QVRbNxNeO8As2woYzjP4FbCutHvtfSiZgzhIQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b04:b0:df2:eaac:d811 with SMTP id
 3f1490d57ef6-e02fc598947mr18902276.10.1719247981721; Mon, 24 Jun 2024
 09:53:01 -0700 (PDT)
Date: Mon, 24 Jun 2024 09:53:00 -0700
In-Reply-To: <20240208154210.GP31743@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com> <20240208154210.GP31743@ziepe.ca>
Message-ID: <ZnmkbOfWBJHrO2sx@google.com>
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linuxarm@huawei.com, kevin.tian@intel.com, alex.williamson@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com, 
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 08, 2024, Jason Gunthorpe wrote:
> On Thu, Feb 08, 2024 at 03:18:34PM +0000, Shameer Kolothum wrote:
> 
> > diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> > index 991f864d1f9b..28ede82bb1a6 100644
> > --- a/drivers/iommu/iommufd/iommufd_private.h
> > +++ b/drivers/iommu/iommufd/iommufd_private.h
> > @@ -16,6 +16,7 @@ struct iommu_domain;
> >  struct iommu_group;
> >  struct iommu_option;
> >  struct iommufd_device;
> > +struct kvm;
> >  
> >  struct iommufd_ctx {
> >  	struct file *file;
> > @@ -27,6 +28,8 @@ struct iommufd_ctx {
> >  	/* Compatibility with VFIO no iommu */
> >  	u8 no_iommu_mode;
> >  	struct iommufd_ioas *vfio_ioas;
> > +	/* Associated KVM pointer */
> > +	struct kvm *kvm;
> >  };
> 
> Associating the KVM with the entire iommufd is a big hammer, is this
> what we want to do?
> 
> I know it has to be linked to domain allocation and the coming
> "viommu" object, and it is already linked to VFIO.
> 
> It means we support one KVM per iommufd (which doesn't seem
> unreasonable, but also the first time we've had such a limitation)

And if KVM+iommufd come as pairs, wouldn't iommufd_ctx_set_kvm() need to reject
attempts to bind devices associated with different KVMs, as opposed to silently
ignoring that case?  E.g. something like the below?  Or is there magic elsewhere
in the stack that prevents such a scenario?

void iommufd_ctx_set_kvm(struct iommufd_ctx *ictx, struct kvm *kvm)
{
	int r = 0;

	xa_lock(&ictx->objects);
	if (!ictx->kvm)
		ictx->kvm = kvm;
	else if (icxt->kvm != kvm)
		r = -EINVAL;
	xa_unlock(&ictx->objects);
}

> The other option would be to pass in the kvm to the individual sub
> objects.
> 
> Kevin?
> 
> Sean would you be OK with this approach considering your other series
> to try to make more of this private?

Sorry, I completely missed this.

If kvm_pinned_vmid_{get,put}() are implemented directly by KVM ARM, then I don't
have any immediate concerns, as KVM ARM is a long, long way from being able to
isolate KVM from the core kernel.  And if we ever want/need to provide generic
APIs for propagating state from KVM into iommufd, bundling the KVM file pointer[*]
with a set of function pointers wouldn't be terribly difficult.

That said, I find the on-demand pinning to be very odd.  IIUC, if KVM runs out
of pinnable VMIDs, attaching a device to the KVM+iommu will fail.  Failing an
iommufd operation because of a (potentially transient) KVM resource issue is
rather unpleasant.

And assuming that pinnable VMIDs are a somewhat scarce resource, it wouldn't
suprise me if someone wanted to add cgroup integration, e.g. similar to the
misc cgroup that's used to manage SEV(-ES) ASIDs on KVM AMD (IIUC, an SEV ASID
is analagous to an ARM VMID).

Rather than on-demand pinning, would it make sense to have KVM provide an ioctl()
(or capability, or VM type) to let userspace pin a VM's VMID?  That would allow
for a much saner failure mode, and I suspect would be cleaner in general for iommufd.

[*] https://lore.kernel.org/all/ZXkVSKULLivrMkBl@google.com
