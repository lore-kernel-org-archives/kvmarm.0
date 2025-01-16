Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0A922FAFC
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 20:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737058801; cv=none; b=I3lXCJcC4ubCWCICEB6kPnISfHqx3560Ka56isxsGmmOBp4BCqjN0cSro42u/unq1jE0CM/JPxArWidH46mX8CCnmW0EHoSJ+ndn282cti6KvP+6Cr6QOOAcNqiF+8HNumzvh+ENXI65PXI2/PVYVq7bH5b0j7afgToa0umte0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737058801; c=relaxed/simple;
	bh=nNoBF4UfWoe23a1lrQ7UdZ6UWanGe/SAkh9O53HaEmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=iqx9Ey3dayunEFPqC4OW6wlz+gOTsXratogEHczCWHICM1Od/QUymYsv0GmWv7ju3Q2M0/efFQAhkqyZ7BYRfejkBkKQhpaMPUU/HzeDZrXyjAaAyIoDy9z+RXQQN07zoAmYEFnsBlKdqP7BEYaPdmA+gCWQRbH6ud7VB2xh7xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gj069CJa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gj069CJa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737058798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hxyx17H16LTaCMPogGfVhxD8KdAjR1MUqsEp+1MdmBk=;
	b=Gj069CJa4nUwP9pKLTx2K5xZxYQESBVIoikqa9aC/KEUu5iNOYUOCzLH/zic+lmPFyOIga
	G9zjhhgA69K46lgaCiVTQoh4F4qJ0+/ow4VSS3XpEB5sBDmXlFB8f3YoEKIAyKnTUoTcOJ
	7AkXARApq90qXGCo36r3AybiBSQqNPQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-ZI8lxK4tODa3JeVlpxr_Fg-1; Thu, 16 Jan 2025 15:19:56 -0500
X-MC-Unique: ZI8lxK4tODa3JeVlpxr_Fg-1
X-Mimecast-MFC-AGG-ID: ZI8lxK4tODa3JeVlpxr_Fg
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-21632eacb31so17559295ad.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 12:19:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737058795; x=1737663595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hxyx17H16LTaCMPogGfVhxD8KdAjR1MUqsEp+1MdmBk=;
        b=MSuocWipQD8zz1Ea1HxbqWProAmXgjZJ0SpAs+n5CWeH/SUQGYd1Z5myI9rR5Fb3EM
         jD+XzBbgTEJdcBXrO5xTgQXUs4Cg+BBK77RkTx6RugKqczDx8FWui+hZiQlX46Xdf2aj
         6TOS9xlHuo/hkb+Ej5/1ruJrFf0tBe5pBL0/5XgR4Nkbmdn1pf2ow/KDtTHOAZ+F8OEl
         JxoLHuI2vwxMERJE80dA/dsRFH4k/EjMBc+LqLp6rjthBq/pJzChnEwQfuCkTaIreP5v
         7QqnWIdjJCm5I98X8cW5lL6xLPTw6r1C2vrL6mPt6oVMbCqYDvB3AhsOoGkQL62QxBYL
         OFtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTpsFtc/Y1+tcq2kFLXwrnnktx79lPx7TUc0NXnO/PcZj3kng4V2z0VBo1TX3KZ5lsReuRC2E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgDwb0kpO8IJILgnTAbHwmRIbAeVzLGKoFcTd+jW7DCTOSGgNQ
	dYXfAODtTY6KKCh2ASWwlMf7EYG3Ou6JDUToXkNc6vx5B24gHBJZeDQOOuPDKC2tdOu83X3ZlGe
	PFapXPYHAcX4s/4DcsLASfI5mUdklqh2XiIiPCKu2bXuHrsRPoAyxqw==
X-Gm-Gg: ASbGncuk3r5t0GasCBpTQUVrBMsiSVqK6UcnPPjzfBl1YOvGp/CB83OOA+mrBi8a1K4
	mZAXS5Cly68dS53HWMoA3aGfM+qTITa8461RE8P1pHPrmaEG+uG/Q7Q2vz2jl8sac6p9K90Fmmn
	CBW/7TjscDM5jgwP/DlhCifFxE5Hs7LvTPMeIOJpOEIGOJ8st1yJmVycBXm1DsJSBVY+2Q/uKFc
	iiYc6WLgaYBnQwOnhNfWqUibBSEl99oH8Ta8oCG8VwIVJCWnCsMnwxsUrHYLp31MAfDXG2d7dem
	CsjOtFxA2Q0bVfTqrA==
X-Received: by 2002:a17:903:1105:b0:216:6f1a:1c81 with SMTP id d9443c01a7336-21c352c77eamr1589135ad.2.1737058795383;
        Thu, 16 Jan 2025 12:19:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCdUZtxdruuZ9dhKBDB1S+oAh8pcb12HPEW8IyTWaMSLHmWxJL1Esm0PAWT5jrhgt1RJfKYw==
X-Received: by 2002:a17:903:1105:b0:216:6f1a:1c81 with SMTP id d9443c01a7336-21c352c77eamr1588855ad.2.1737058795018;
        Thu, 16 Jan 2025 12:19:55 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d3ac3e2sm3791465ad.139.2025.01.16.12.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 12:19:54 -0800 (PST)
Date: Thu, 16 Jan 2025 15:19:49 -0500
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>,
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
Message-ID: <Z4lp5QzdOX0oYGOk@x1n>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n>
 <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oDRmK9ptKJwDu6Vi4fx8ja6hh37OKg5W6j5Ca0CUkgY_1737058795
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

James,

Sorry for a late reply.

I still do have one or two pure questions, but nothing directly relevant to
your series.

On Thu, Jan 02, 2025 at 12:53:11PM -0500, James Houghton wrote:
> So I'm not pushing for KVM Userfault to replace userfaultfd; it's not
> worth the extra/duplicated complexity. And at LPC, Paolo and Sean
> indicated that this direction was indeed wrong. I have another way to
> make this work in mind. :)

Do you still want to share it, more or less? :)

> 
> For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
> replacing it. And as of right now anyway, KVM Userfault *does* provide
> a complete post-copy system for gmem.
> 
> When gmem pages can be mapped into userspace, for post-copy to remain
> functional, userspace-mapped gmem will need userfaultfd integration.
> Keep in mind that even after this integration happens, userfaultfd
> alone will *not* be a complete post-copy solution, as vCPU faults
> won't be resolved via the userspace page tables.

Do you know in context of CoCo, whether a private page can be accessed at
all outside of KVM?

I think I'm pretty sure now a private page can never be mapped to
userspace.  However, can another module like vhost-kernel access it during
postcopy?  My impression of that is still a yes, but then how about
vhost-user?

Here, the "vhost-kernel" part represents a question on whether private
pages can be accessed at all outside KVM.  While "vhost-user" part
represents a question on whether, if the previous vhost-kernel question
answers as "yes it can", such access attempt can happen in another
process/task (hence, not only does it lack KVM context, but also not
sharing the same task context).

Thanks,

-- 
Peter Xu

