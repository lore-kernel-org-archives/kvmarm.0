Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A95232423
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 20:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737059539; cv=none; b=bo4DKuews+TSMVEXVR68CZltyRPUk06dPG3KtONPw/JiJWt7dgVcDOC5s6PrpToj+ETkegxlaU1g5gao8AxZRIKx4IBbByTmjWL9M9/5drJD64RVk0eLokubfBlIklA3wlqR+p/Tr4kDwosey02T3PtVf0H4O9AR09u60/vegIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737059539; c=relaxed/simple;
	bh=Gp2dMCkhOZWquwQcvnyVZRJDHqMIikWYXh/aHRG4fJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Ks6r9EW4cIM6VcJjPEcI659aaRh2Vz3wxxb3kD5NxDZgmA78adC27j3sS7sWM16onE1xvpXZ9plznFOcHKgLDC8uVd7AGO8dw2KgBlzRw35H0U/7DNV4kTUCxRtTs3z49P0JHB/8rOLVR8XlZjcW210UeQO8mVbvMKiwaLC5LtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FqCqi3TW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FqCqi3TW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737059535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cBjXp+Q0kBMQo93pn9/JG/mDdpOMWtXcKEJJB7g0DX0=;
	b=FqCqi3TWOb2BbweNIeGvtX21i/va1/7tyuDXVuTXQy6wqsb7dk+cpt+jSU3hJNIXripBJf
	CCNsU//XFkXZkAOLuAx/XRtC2A523VDAA5EVg12pWxTVxYjn7Rgh8SNnbmdhH+n8HVUR7H
	x5rcK0h7NRu3KnjGimrI4igaIBsODWM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-Hdc_6VPvO6KFvB8W0ry2bQ-1; Thu, 16 Jan 2025 15:32:14 -0500
X-MC-Unique: Hdc_6VPvO6KFvB8W0ry2bQ-1
X-Mimecast-MFC-AGG-ID: Hdc_6VPvO6KFvB8W0ry2bQ
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2163d9a730aso30667795ad.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 12:32:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737059532; x=1737664332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBjXp+Q0kBMQo93pn9/JG/mDdpOMWtXcKEJJB7g0DX0=;
        b=iaIJQDoEBZhjI/hgDMBDvpp9zzNCALzTndLOWTFmpwUV45DZEmRHMV8CvDIqWzn/n9
         iq99I0YSXJyQCd/iay6jeDXkn+UJVQcFdC4YmH2w1RfkuX2fpIIixGpPyxOsOQOpMWw0
         Bp9CEhTmFwnaDovmtVmgm6GKkVvEVLOCI4dQBpHVpC+0kPYrKNjHimL09sHZUM+kfa7p
         Ezg+ktDLwhCIUoIlm4MLvBObSM1qSH2XR7glCtJWKFjFjRimDIM9/RQBzsmSzmQ0lJ/4
         ZLQXZYBa3xREIUUNVSxXC0voUCMfkq3RvP2ZMG1xQKPUacjRTsdwjA4Ml5NOVcq5Asdz
         cHCw==
X-Forwarded-Encrypted: i=1; AJvYcCXytXYXOTu3thAVqB0Srd40ucrhtMK91vOlbSGHl4JNjndtyQuwLq68Tme2Lslh5lIMj4hdf1Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YzuXBGSBpcz0Z6KH+rlwXUgonduqgDESXKK7LP8BNNnTYHiSKsN
	JVf9mGSuPoveBLbSUNdv6zxvSZoQvFvTUavLg+bDYaDiekIPKv+bcRs6mlAcanVblJmDcLGvEqc
	27pAbBv+sfBQxjLByzan7kxGp3ByMXJduSll4mIIMuc9Hm62ZPfyakA==
X-Gm-Gg: ASbGncs5R14vkmPnfQNlvNowPezPsC1f3vTODwe6vgcN8jwNhLyYBLBh9RPIAWRzn8G
	31gZGQao7zzuGTHdxHC5wPbqgPGttm0wUcLW7AVAlnMAX0k56p6ntNV4UvcYwpbYwHFT9e3dsji
	tQJoUku2+unQSwcEwGi/Htl3lu1td/lzhwq5svlDNSlkrWXB0kIzHdx70Icr/kGMFSpJ12JfHyx
	ov1ck5v3iUr0synUbbbksEaBHB1y00gVjqkQ8ByaIpYBOWJ41fI6OOYDHbMphpekEhb0pmTYCK9
	pt4qj4lsPP2dJPuJvw==
X-Received: by 2002:a17:903:238e:b0:216:311e:b1c4 with SMTP id d9443c01a7336-21bf029e049mr110709325ad.4.1737059532479;
        Thu, 16 Jan 2025 12:32:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKxzy3YKG0/4peNFIGTyI8M6fxHbUDzV/T0Dy6Fv99Nr5xuebiMcqfPD2o4c5t4sCUc/gI8A==
X-Received: by 2002:a17:903:238e:b0:216:311e:b1c4 with SMTP id d9443c01a7336-21bf029e049mr110708925ad.4.1737059532113;
        Thu, 16 Jan 2025 12:32:12 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bdd30e9adsm444712a12.62.2025.01.16.12.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 12:32:11 -0800 (PST)
Date: Thu, 16 Jan 2025 15:32:06 -0500
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
Message-ID: <Z4lsxgFSdiqpNtdG@x1n>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n>
 <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Z4lp5QzdOX0oYGOk@x1n>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dZiRKUFy6vuaVU8MMEYaQeBwFZ6PEVvidoj_-3lPtiE_1737059532
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Jan 16, 2025 at 03:19:49PM -0500, Peter Xu wrote:
> James,
> 
> Sorry for a late reply.
> 
> I still do have one or two pure questions, but nothing directly relevant to
> your series.
> 
> On Thu, Jan 02, 2025 at 12:53:11PM -0500, James Houghton wrote:
> > So I'm not pushing for KVM Userfault to replace userfaultfd; it's not
> > worth the extra/duplicated complexity. And at LPC, Paolo and Sean
> > indicated that this direction was indeed wrong. I have another way to
> > make this work in mind. :)
> 
> Do you still want to share it, more or less? :)
> 
> > 
> > For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
> > replacing it. And as of right now anyway, KVM Userfault *does* provide
> > a complete post-copy system for gmem.
> > 
> > When gmem pages can be mapped into userspace, for post-copy to remain
> > functional, userspace-mapped gmem will need userfaultfd integration.
> > Keep in mind that even after this integration happens, userfaultfd
> > alone will *not* be a complete post-copy solution, as vCPU faults
> > won't be resolved via the userspace page tables.
> 
> Do you know in context of CoCo, whether a private page can be accessed at
> all outside of KVM?
> 
> I think I'm pretty sure now a private page can never be mapped to
> userspace.  However, can another module like vhost-kernel access it during
> postcopy?  My impression of that is still a yes, but then how about
> vhost-user?
> 
> Here, the "vhost-kernel" part represents a question on whether private
> pages can be accessed at all outside KVM.  While "vhost-user" part
> represents a question on whether, if the previous vhost-kernel question
> answers as "yes it can", such access attempt can happen in another
> process/task (hence, not only does it lack KVM context, but also not
> sharing the same task context).

Right after I sent it, I just recalled whenever a device needs to access
the page, it needs to be converted to shared pages first..

So I suppose the questions were not valid at all!  It is not about the
context but that the pages will be shared always whenever a device in
whatever form will access it..

Fundamentally I'm thinking about whether userfaultfd must support (fd,
offset) tuple.  Now I suppose it's not, because vCPUs accessing
private/shared will all exit to userspace, while all non-vCPU / devices can
access shared pages only.

In that case, looks like userfaultfd can support CoCo on device emulations
by sticking with virtual-address traps like before, at least from that
specific POV.

-- 
Peter Xu

