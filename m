Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388C5246ED7
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 23:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070284; cv=none; b=IelSxxfLD3/ZQsHTh/n4hbnJo87WgouXXSi4C9bKs5bL101aVXxK5k7fGJFX3mn6coGQADR5uf4nLkXlARV8ilvZqNgicacudhvymETHGatPT+Efvtn686UYiLtgYa6NRK2VLv5nuqrlb/8eqZObGhI1MWYuIpDH5WCmwwypR3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070284; c=relaxed/simple;
	bh=hEX2DsNI7E8IBqdPG0miIQfwwOlcMkiPPsnqKDxhtIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Q+dta59PLVbsl/iay5SftBzdbgSqM/TppQ3lMqZqFokqzo2UNbDBhW2wMeozC0Z7ysK1FiFPjdRUIiwb1YZlPHsCp9l33PVzjvhvuZ0sZgch27VgFeDVxMtEeUdSDjHe113vMggePCMh5ramTVhoPgyE5GRMlIjHdn51e3Pai74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ABLS+vWV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABLS+vWV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737070282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+aljsYXNR3zz+hPgKhn1NefTJFgn2NwxVBvLmGXKHY=;
	b=ABLS+vWVAe28f04gtWqkbT/LKoVihr01lXqjh4Nb4QcOagU9d6AM9+0XHopSCUIT7lglBt
	dKhdhomrVv1siGykQozZWCppfgX3wkO1zsG8tNg08S/A9UIrji52+nVPRDIU7qC6btsYQF
	7q4yp8iEISAHoBMUdoRwPM1W0XXByOY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-DsN-1VXePUu58aq0brYh3w-1; Thu, 16 Jan 2025 18:31:20 -0500
X-MC-Unique: DsN-1VXePUu58aq0brYh3w-1
X-Mimecast-MFC-AGG-ID: DsN-1VXePUu58aq0brYh3w
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-46909701869so35484931cf.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 15:31:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737070280; x=1737675080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+aljsYXNR3zz+hPgKhn1NefTJFgn2NwxVBvLmGXKHY=;
        b=Y6MUXjz0pEuFYEd5VT11zdu5FxqoswxIjXkMQ2FPnfmDcAkwOqmD8oh7RjtTVV8fsH
         AutdIZDnn3E209eIybZqyiN6nUp9rKbA4k0+z3wfgLJi7DIQHq5jTfgIiQsfjXBMix+Z
         pV+0DCfun8vATyJjmgSVwMJRCOtuskWikovvatHAQefCnCEF+w+Wglfg5TLZXWa0fVhJ
         7txBJ5NKp8WSEA2Vy3k+i41LjH65OYLDggwv7dZvkqrmSnkVYDx4ebHdnVYgxeQcdF8Y
         85ms5ZvITJwHH528VTZlH6s4dAHnL+YbyHECOL4eq4h2rODBTRTYzE2q0j9bij8KfWnj
         lX7g==
X-Forwarded-Encrypted: i=1; AJvYcCVoQ/A7sytm2r2/tedz7SskzU7ntwtOVaHYo/WekEb8UKvBaxbgJeHg1uNhqNm0ipaKFb3VNNY=@lists.linux.dev
X-Gm-Message-State: AOJu0YymcK7Ab8GPX9r1U8f+EJ08aD0SaQ71tXN+rxC/S1Y6xg641qar
	VYoz1FWTAd0aDlKmoO6hwWZcqF6RJOq6AgG/4Y/bJufhgQo4Y2zn8GnFvA1mCW5LcCOft8ZOTSK
	VxR3weW986Qcc7Z4FFZoUjZoDHZAXP2IL3q5BOGEhifW/zRrximGjqw==
X-Gm-Gg: ASbGncuHCuvXLe8JOMlvNyXkLTNHMVbz0pDUD7MtNzttONH2QJ/GKILiyPeI9ihRzVn
	twuT8y1Q0N8v7FT51QBlotzHRhZToCCkHbO6NtrBrhlbZ+7HKVqnlrmlS9XEL52fl3NUM0bHFIJ
	kzIVgt9zmcSZBVynWlE1WAGTEJMMM3QlYvqfaLhGya2jLbo2HwkACkrGiq801FTlGSAMP+wMXjH
	pbzdYSHhqV0chC0S8DY2PnvAMaA1RI2Tt1sZG5s2ILwVl25EsusdXBAZurdoY8Kwsgw+aFvSlIi
	iXFnBJr6AbxQJCZTXw==
X-Received: by 2002:ac8:5914:0:b0:467:7270:bc35 with SMTP id d75a77b69052e-46e12a3fadamr10765401cf.14.1737070280060;
        Thu, 16 Jan 2025 15:31:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDbPH5giaBGe/SQwST9bz+Qh0GVUALDsJUk5gRXMEShRz7wGoChR/Lc1daUotDAD4y7F9d0A==
X-Received: by 2002:ac8:5914:0:b0:467:7270:bc35 with SMTP id d75a77b69052e-46e12a3fadamr10765061cf.14.1737070279738;
        Thu, 16 Jan 2025 15:31:19 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e104027d5sm5078961cf.58.2025.01.16.15.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:31:19 -0800 (PST)
Date: Thu, 16 Jan 2025 18:31:15 -0500
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
Message-ID: <Z4mWw8NXCoV-pONI@x1n>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n>
 <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
 <Z4lp5QzdOX0oYGOk@x1n>
 <Z4lsxgFSdiqpNtdG@x1n>
 <CADrL8HWRavCoZ_NtXJvcLOvjOiGDCor6ucWeEqkecA3VDY-adg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CADrL8HWRavCoZ_NtXJvcLOvjOiGDCor6ucWeEqkecA3VDY-adg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dv2Z71riP_NNVH28GNs9tupXBEAvY4vOQynBy4AIVls_1737070280
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Jan 16, 2025 at 02:51:11PM -0800, James Houghton wrote:
> I guess this might not work if QEMU *needs* to use HugeTLB for
> whatever reason, but Google's hypervisor just needs 1G pages; it
> doesn't matter where they come from really.

I see now.  Yes I suppose it works for QEMU too.

[...]

> > In that case, looks like userfaultfd can support CoCo on device emulations
> > by sticking with virtual-address traps like before, at least from that
> > specific POV.
> 
> Yeah, I don't think the userfaultfd API needs to change to support
> gmem, because it's going to be using the VMAs / user mappings of gmem.

There's other things I am still thinking on how the notification could
happen when CoCo is enabled, that especially when there's no vcpu context.

The first thing is any PV interfaces, and what's currently in my mind is
kvmclock.  I suppose that could work like untrusted dmas, so that when the
hypervisor wants to read/update the clock struct, it'll access a shared
page and then the guest can move it from/to to a private page.  Or I'm not
sure whether such information is proven to be not sensitive data, so the
guest can directly use a permanent shared page for such purpose (in which
case should still be part of guest memory, hence access to it can be
trapped just like other shared pages via userfaultfd).

The other thing is after I read the SEV-TIO then I found it could be easy
to implement page faults for trusted devices now.  For example, the white
paper said the host IOMMU will be responsible to translating trusted
devices' DMA into GPA/GVA, I think it means KVM would somehow share the
secondary pgtable to the IOMMU, and probably when DMA sees a missing page
it can now easily generate a page fault to the secondary page table.
However the question is this is a DMA op and it definitely also doesn't
have a vcpu context.  So the question is how to trap it.

So.. maybe (fd, offset) support might still be needed at some point, which
can be more future proof.  But I don't think I have a solid mind yet.

-- 
Peter Xu

