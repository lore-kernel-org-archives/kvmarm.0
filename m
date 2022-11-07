Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936E2D516
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 14:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667831344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=humq6rQ40+uCr1dmaqj2I5gLtIPMUKzBIm5JAKLU5kM=;
	b=aKvlic6VPiEtzOueIUBnYGtYNqwy6tpAx8Gs0m6ApYap4v1phE/aFVNJ8cN7p7NlijzxFD
	W6RuzQKCS3JLnPnAALoSD13PU4w2SNmOLQh7pjnmbgEqapMdvJfZlS/560+GPQ+ZSOWjOm
	ywUmWxXNetn0InCLvHdzNVNb5pgvFmg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-416-BvkJAhZZNqOuxf3pKhRayw-1; Mon, 07 Nov 2022 09:29:03 -0500
X-MC-Unique: BvkJAhZZNqOuxf3pKhRayw-1
Received: by mail-qt1-f200.google.com with SMTP id y19-20020a05622a121300b003a526e0ff9bso8211419qtx.15
        for <kvmarm@lists.linux.dev>; Mon, 07 Nov 2022 06:29:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=humq6rQ40+uCr1dmaqj2I5gLtIPMUKzBIm5JAKLU5kM=;
        b=7Ex3ST5eoC4yHcuLTjQFey6+mkTcjy1yVGBGtvhvkAvNc7+jYUXD0nVXhzzh/qVH3O
         HC5KiGt0TYgAJyVDogSnO2922/66Cz6SIdYIUccfgxDxM1aYk++claoicoCdE+aH7tp9
         6cb8n//nqHwjoGclU7MbK7IZofgchnl+KLBiGiCClKOxBgY5rcPzTDFeIPM+4lSNKBE1
         P6tA9bj+kQYd+/x5Du81aEu5uDQkRoJiIB+jvWSBmmeibVMEYXTIDwjHRotpQYmaqOuv
         u0Gw4Sp31lxQ4oQOCQrmi4nsBJs+9IZaF1qz7RhIhAEpUOURN0wvmBPUGQV1j8z59p7k
         zItQ==
X-Gm-Message-State: ACrzQf3iu+3hjd8+dH2tytxSNTHryiOvkK3RNJhNeqjZLdLg60oDcREm
	CiTHXk1Ie0SiKOzRdDSObY6jsYdxSW5rbz923V+yiJNnSnDDnKguBBuSCdzOgLiu3UgQ51vtewE
	6okNeDAiOG1agpAoS
X-Received: by 2002:a05:620a:d55:b0:6f9:fadd:4762 with SMTP id o21-20020a05620a0d5500b006f9fadd4762mr35863872qkl.335.1667831342865;
        Mon, 07 Nov 2022 06:29:02 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6QWKXb1TWdkP9qu08deog1NKsig/FMQot7OkY7UfMNUpgr2zjUhL2SrUPx+ND9wgrgFSLMDw==
X-Received: by 2002:a05:620a:d55:b0:6f9:fadd:4762 with SMTP id o21-20020a05620a0d5500b006f9fadd4762mr35863853qkl.335.1667831342661;
        Mon, 07 Nov 2022 06:29:02 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id cg5-20020a05622a408500b0035cf31005e2sm6150909qtb.73.2022.11.07.06.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 06:29:02 -0800 (PST)
Date: Mon, 7 Nov 2022 09:29:00 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org,
	catalin.marinas@arm.com, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
	will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2kWLMMTho0+/BLR@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org>
 <Y2ffRYoqlQOxgVtk@x1n>
 <87iljrg7vd.wl-maz@kernel.org>
 <Y2gh4x4MD8BJvogH@x1n>
 <35d005f3-655a-88f5-2de3-848576a26e42@redhat.com>
 <865yfrqf3j.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <865yfrqf3j.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221107142900.QvnzA6s0c4RR9Hy3de2CqS_9JQ4-spXXLQbTi5Ldads@z>

On Mon, Nov 07, 2022 at 09:38:24AM +0000, Marc Zyngier wrote:
> Peter said there is an undefined behaviour. I want to understand
> whether this is the case or not. QEMU is only one of the users of this
> stuff, as all the vendors have their own custom VMM, and they do
> things in funny ways.

It's not, as we don't special case this case in KVM_CLEAR_DIRTY_LOG.  If
that's confusing, we can drop it in the document.  Thanks.

-- 
Peter Xu

