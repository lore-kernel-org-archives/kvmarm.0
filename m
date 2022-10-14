Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245193C13
	for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665766540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=inMtT+hoYNUBiTHjQTMih3j26iePj23of4ePHLqNIX8=;
	b=IImivX0zdH+ls+KlQa5IKOvLvxPaPsP6RxpKFDqC9mBIT1toYqpxEkX6tbpk1jz0mRn4CJ
	IjvEXbIevMfUzWYh/+k7zoWJVQLNH2cgmw5ZZ9jZ8m29Fo8nC3RHOavdz3aqAg6+yUEPtG
	7mmp49K/2kELk1JgUZL1iFuclhwj/xs=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-146-WwniZfqcPP2Qz7iNANRXWQ-1; Fri, 14 Oct 2022 12:55:38 -0400
X-MC-Unique: WwniZfqcPP2Qz7iNANRXWQ-1
Received: by mail-qt1-f198.google.com with SMTP id s14-20020a05622a1a8e00b00397eacd9c1aso4089616qtc.21
        for <kvmarm@lists.linux.dev>; Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inMtT+hoYNUBiTHjQTMih3j26iePj23of4ePHLqNIX8=;
        b=eD18PTOBF35SN6qRbV9WIqAEcqQ6XioXatoZaN5t41MVW4rhP5XVkkjfCdcqFxIky4
         LSV2PhingBdyTmEg/q6nteTSr0L6TfPom8ED1jCiR6I0C4UpIms+YzrHCojsFtxLl7Qc
         avOejhncQ/q7a5E5pL1WgBPSBFMk1GXlxfPjUHou7hUodWPYLEBbD6I+7pSKVnCSSgcE
         zN4Pj26mTrzEAMkVMWmxbuMgoTbt5wvA6Dp5/ZP8gHoYItNj8cl10czGanhYC5oryfEq
         tl11bL9Vpyzs+pvyZ9CjK4Ih6IysoBKosbXQXIEzQLsrLITTH5pDGQpRYvYgniFv93N5
         ZgsQ==
X-Gm-Message-State: ACrzQf2b4zoPbU4aZr6HZ5HOZN9dwuQmmC1n1HRyhXN1AaYBRYkiBHKF
	apHpbtKb/qsWhao4jkmzvKeYYMOfWbg/4/1bzYIVU0DZcZq6COg5r6LWDWFORIPbLLiusLoN3E1
	h37HK+2ozJdGlgAnc
X-Received: by 2002:ac8:58c2:0:b0:398:f5c4:9bed with SMTP id u2-20020ac858c2000000b00398f5c49bedmr4982991qta.367.1665766538535;
        Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7RWlwjY7fwX0sXAm2JU/iQpzMQf5jfJhmR78proXq2TEBVxm0GapOTir5grGpSntiVMzL4Gw==
X-Received: by 2002:ac8:58c2:0:b0:398:f5c4:9bed with SMTP id u2-20020ac858c2000000b00398f5c49bedmr4982978qta.367.1665766538317;
        Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id d22-20020a376816000000b006ce0733caebsm2726739qkc.14.2022.10.14.09.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 09:55:37 -0700 (PDT)
Date: Fri, 14 Oct 2022 12:55:35 -0400
From: Peter Xu <peterx@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
	andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
	pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
	suzuki.poulose@arm.com, alexandru.elisei@arm.com, seanjc@google.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0mUh5dEErRVtfjl@x1n>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
 <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local>
 <Y0SxnoT5u7+1TCT+@google.com>
 <Y0S2zY4G7jBxVgpu@xz-m1.local>
 <Y0TDCxfVVme8uPGU@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y0TDCxfVVme8uPGU@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221014165535.N8b_lFQP6I60hgk3YsMbSgE2VfCjROOAXUHidl3tQxU@z>

On Tue, Oct 11, 2022 at 01:12:43AM +0000, Oliver Upton wrote:
> The VMM must know something about the architecture it is running on, as
> it calls KVM_DEV_ARM_ITS_SAVE_TABLES after all...

IIUC this is still a kernel impl detail to flush data into guest pages
within this ioctl, or am I wrong?

For example, I'm assuming it's safe to change KVM_DEV_ARM_ITS_SAVE_TABLES
impl one day to not flush data to guest memories, then the kernel should
also disable the ALLOW_BITMAP cap in the same patch, so that any old qemu
binary that supports arm64 dirty ring will naturally skip all the bitmap
ops and becoming the same as what it does with x86 when running on that new
kernel.  With implicit approach suggested, we need to modify QEMU.

Changing impl of KVM_DEV_ARM_ITS_SAVE_TABLES is probably not a good
example.. but just want to show what I meant.  Fundamentally it sounds
cleaner if it's the kernel that tells the user "okay you collected the
ring, but that's not enough; you need to collect the bitmap too", rather
than assuming the user app will always know what kvm did in details.  No
strong opinion though, as I could also have misunderstood how arm works.

-- 
Peter Xu

