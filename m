Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E35B8BE8
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 16:17:54 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso14499794pjf.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 08:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K4gUZ8QoPMsgmVIH22hnGP5ly+yceMbFGnzKyjd0wdY=;
        b=UPp4JufSwtRNp94ONl0EC5nVMDyjAWSpwPgAbGkByDhx7r76dLXrdK0dQ/NGJgTyYy
         4+gkDBE0A+5vVppVUkX2ll2vSZZ+zQQBhbnuQCeK5Zay5OWKvKIG80gKKrhlAextTHHX
         jHtyuiTOjVPNNdLn845YcIbkIPp/NZMqMEcflWogAU5rGTAcycx3ffDsEhBXf+6TPtYr
         mXi5MQotYa5/GTRAbX54CxxFuZzc6Zz4NqIo9ZVxaxmehr/Omwam2ZbRZU0f9X22rTle
         z1W3M8paOpBXYay59HMe3u0g0X94tWF3TmcYkUUt5fMt6Vg9opxWw3d+fg+6ZP/ELFRW
         9E8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4gUZ8QoPMsgmVIH22hnGP5ly+yceMbFGnzKyjd0wdY=;
        b=mGVKQREAxS2i4IJ0Ixhbj6ux45iRX0UOwzHCmWl9xVvmuHhsfKnR5jFvg1ZTGzoD7g
         IMQ6/behQDi0dJqlBgPUI/2s+FOv4bleRfjTBH23rVT9UALZ5q0wmOBSaf+UTR/QgFKC
         BzCdySKhMMDuibrTUVYY0sV5KEUnwvbL5QdOEgCj5PcUbkio+CSKmMvHYmlfWepIzmIT
         qNazPv6TMf0o3Qc08KP8jt4wFFUAOrXF98GBJdAYpmYU/s+eiTjnuZGp+oL1OxKrXUyg
         jPJcn/Bp4QFDUbGIEJSsfwBte3ws5pfDuVjjYZ/EDHhXu6YeYqRWKcIHng/OxeC4/IcS
         2Ppg==
X-Gm-Message-State: AO0yUKUhMkro8Uph9MBFLc0mv/FvnHi/G+Hq1e1rbhKDEz6s3sya7wm3
	sb5ZQD6GVC2AD+Sq6Pt3w+8+zg==
X-Google-Smtp-Source: AK7set8FFTNIfErrcpZvHzozOWX3Xx1vcflIUxA+YhAImZ7s/xPIH9xo1Ps0QCaPnRHW+42pHVm8IQ==
X-Received: by 2002:a05:6a20:9d90:b0:b8:e33c:f160 with SMTP id mu16-20020a056a209d9000b000b8e33cf160mr302472pzb.0.1674577073692;
        Tue, 24 Jan 2023 08:17:53 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id x15-20020a62860f000000b0056b4c5dde61sm1846386pfd.98.2023.01.24.08.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:17:53 -0800 (PST)
Date: Tue, 24 Jan 2023 08:17:49 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH 1/4] KVM: selftests: aarch64: Relax userfaultfd read vs.
 write checks
Message-ID: <Y9AErXchOZFuKL05@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <20230110022432.330151-2-ricarkol@google.com>
 <Y88TLcuetXMSYyfD@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y88TLcuetXMSYyfD@google.com>

On Mon, Jan 23, 2023 at 11:07:25PM +0000, Oliver Upton wrote:
> On Tue, Jan 10, 2023 at 02:24:29AM +0000, Ricardo Koller wrote:
> > Only Stage1 Page table walks (S1PTW) writing a PTE on an unmapped page
> > should result in a userfaultfd write. However, the userfaultfd tests in
> > page_fault_test wrongly assert that any S1PTW is a PTE write.
> > 
> > Fix this by relaxing the read vs. write checks in all userfaultfd handlers.
> > Note that this is also an attempt to focus less on KVM (and userfaultfd)
> > behavior, and more on architectural behavior. Also note that after commit
> > "KVM: arm64: Fix S1PTW handling on RO memslots" the userfaultfd fault
> > (S1PTW with AF on an unmaped PTE page) is actually a read: the translation
> > fault that comes before the permission fault.
> 
> I certainly agree that we cannot make assertions about read v. write
> when registering uffd in 'missing' mode. We probably need another test
> to assert that we get write faults for hardware AF updates when using
> uffd in write protect mode.

I can do that. Only question, do you prefer having them in this series
with fixes, or another one?

> 
> --
> Thanks,
> Oliver
