Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AD51E9F9
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 16:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667407400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fTFZdSVqI0N+O3i56sH80q79jqwRkWzhFiqZV68haTk=;
	b=RvBWXnVQjs/BeBa3GnnpAK1GoR48nB1uLqZtxe1eRf0+Uo8c3I3K5A1As5oU5cGRKIMSFn
	ZlYWObRs/aQIbg/mivfHw36NYA//lJIYNdg5yon5GDaGazBn7usvtESH5fnn5JHZY1zErF
	Y+rUO0fbFMs5v8MqFdijL65TsWXz+Yc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-6poeZeQDPBKooIH-ettxEA-1; Wed, 02 Nov 2022 12:43:19 -0400
X-MC-Unique: 6poeZeQDPBKooIH-ettxEA-1
Received: by mail-qt1-f197.google.com with SMTP id fp9-20020a05622a508900b003a503ff1d4cso11201473qtb.22
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTFZdSVqI0N+O3i56sH80q79jqwRkWzhFiqZV68haTk=;
        b=vyHRmVMOA7pyhA1k34XcZr7eMXqKKzCbw24rCbAl97bvusFIopQRut+u535BX8ZqRd
         ArTa+BDj0Ly+HWIpavfJIMJCzrVdOyYd5so/22ROHT9GfYbuP1Q9mimwQ8OdwzSOAAh8
         5G8CY8FSTGPjFHfo570Yvf72uIqm1erEvhiGidejeGfBkF0rfDwWy4UGm5mz1wc1+36T
         tIgNfirSXn9pW7tnOoJDaxbt2glUBL5S3GlUW2WXTosudN4A3JQvyQKMZQ2NjduxLcbD
         6G3a0o3IKPVp243D1tzdWOXI8Y0abj4QMhpNmqmvOSP20BpV5lrPxOKev4FSa6ay09k6
         l4fg==
X-Gm-Message-State: ACrzQf3BAc9DEE0wjM2Vle/OUs1x3K7BhA997C6XvEQ/E0DrUUNcBTpw
	Uz6RUSfUBdDC59u84RzTWA64kL7LHqwCloVjZy575NTdHDp3L1IvXiqU9WXn1s64LWkSK5Yy0we
	hrlTXfTP2c+vj/Tjq
X-Received: by 2002:a37:5586:0:b0:6fa:39c4:2ca9 with SMTP id j128-20020a375586000000b006fa39c42ca9mr10011520qkb.247.1667407399320;
        Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4/rvQXdCAyIe0HFz95uUEGgTNvP6HVoipjnQ1WNKjj3y50tjMcIRaYfVVUhCu1DT+83sBt5A==
X-Received: by 2002:a37:5586:0:b0:6fa:39c4:2ca9 with SMTP id j128-20020a375586000000b006fa39c42ca9mr10011503qkb.247.1667407399083;
        Wed, 02 Nov 2022 09:43:19 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id f16-20020ac80690000000b0035ce8965045sm6757917qth.42.2022.11.02.09.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:43:18 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:43:16 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, oliver.upton@linux.dev, james.morse@arm.com,
	shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KeJGYUxnOOcXMj@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
 <Y2KZdDAQN4889W9V@x1n>
 <Y2Kby0yXu0/Zi2P1@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y2Kby0yXu0/Zi2P1@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221102164316.Zw7UQVRqBq6UFOQrsNxjxPsLj1Non7rlfCAvVYvXpH8@z>

On Wed, Nov 02, 2022 at 04:33:15PM +0000, Sean Christopherson wrote:
> On Wed, Nov 02, 2022, Peter Xu wrote:
> > Might be slightly off-topic: I didn't quickly spot how do we guarantee two
> > threads doing KVM_RUN ioctl on the same vcpu fd concurrently.  I know
> > that's insane and could have corrupted things, but I just want to make sure
> > e.g. even a malicious guest app won't be able to trigger host warnings.
> 
> kvm_vcpu_ioctl() takes the vCPU's mutex:
> 
> static long kvm_vcpu_ioctl(struct file *filp,
> 			   unsigned int ioctl, unsigned long arg)
> {
> 	...
> 
> 	/*
> 	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
> 	 * execution; mutex_lock() would break them.
> 	 */
> 	r = kvm_arch_vcpu_async_ioctl(filp, ioctl, arg);
> 	if (r != -ENOIOCTLCMD)
> 		return r;
> 
> 	if (mutex_lock_killable(&vcpu->mutex))
> 		return -EINTR;
> 	switch (ioctl) {
> 	case KVM_RUN: {

Ah, makes sense, thanks!

-- 
Peter Xu

