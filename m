Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1198839
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 16:16:36 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so18216722pjq.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 08:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OHafq/bnQqe8SrboMo9hHNpvzyiZJrZ0d/xhlpndPV0=;
        b=kUoFIx412QWnZID/hc50OfhcOoG1T6YgdOyyfP4tJlMecl1LkuOqAsHA+EWW1rAyje
         abZUSy8nk8oVy6oh+8ZkQGR/szqVZoWxWMJyQC6YktTHMf6b+6Kwqwp8rDXd6t4UtI73
         Yp8jCLSaI/OS1UCuMN5oi9p07L74QEtSrbkkYTAfN1twohmcWMWWVI8iXwOXeImnBbWC
         xJKGsO7NgNMNsGRqMQjEYtp4GiVl0L0h4IeSugzm1C7sH6dlnx7pNlT0f5d4ff9T1UCO
         YPPHQlefWgnxlwQTcLW4S/NRC4cnJ22LSwLuMIQ6U072sxgxEfiAjHfmFZDXfdHLarE9
         lqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHafq/bnQqe8SrboMo9hHNpvzyiZJrZ0d/xhlpndPV0=;
        b=UPhiSk7nlbpuHmFtrWB164KideiK5+zFXE1ZGN/xuUmA/cjyHsSfGmY4H/tQTUNqWW
         5xgg7Jk/vvD9GZIigcOmMd/2lhDp+dCA842krFJFn61CUy5y1uGm/Peag5N/6MMPI778
         9JPg5Az365pf2fsfvu5Hc6yAYHEpTM602UanosyHBI1Izyh+fszYl8wXZlODLV/w3MNQ
         FYgiKurkti91rLqmmGhY6N1+SH+3UGdBV9pcsQ+w8YJE1Pg8qOu5CahVhAJojFeJuWFu
         aAP7onFxurkkbON1QHr9ZDWZXOyF5+ZecE7B1l5TLTVlE/dbNUggPqloREZ+XRBHAX6+
         A0zw==
X-Gm-Message-State: AO0yUKViLwPKp/+BF8vn/ATPgu55NLQKVRmdDxUSQXVUZEKrw3RIMb4R
	gxL2Nty0K183MX8PNLZsEPde3w==
X-Google-Smtp-Source: AK7set9/iAkFLt0+U8DRsBB0q9v3QqYTp1hzk/gVBo4wD77XsBCDOT/mY5FIlZ3E8l1LkfuFd1afLw==
X-Received: by 2002:a05:6a21:329b:b0:b8:c3c0:e7f7 with SMTP id yt27-20020a056a21329b00b000b8c3c0e7f7mr293075pzb.1.1674576995440;
        Tue, 24 Jan 2023 08:16:35 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id b192-20020a621bc9000000b005817fa83bcesm1765014pfb.76.2023.01.24.08.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:16:34 -0800 (PST)
Date: Tue, 24 Jan 2023 08:16:31 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] KVM: selftests: aarch64: page_fault_test S1PTW
 related fixes
Message-ID: <Y9AEX1bOyJ2omlub@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <Y88bRSisoRAML0M6@google.com>
 <Y88bl/+lqrUCVKEf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y88bl/+lqrUCVKEf@google.com>

On Mon, Jan 23, 2023 at 11:43:19PM +0000, Oliver Upton wrote:
> On Mon, Jan 23, 2023 at 11:41:57PM +0000, Oliver Upton wrote:
> > On Tue, Jan 10, 2023 at 02:24:28AM +0000, Ricardo Koller wrote:
> > > Commit "KVM: arm64: Fix S1PTW handling on RO memslots" changed the way
> > > S1PTW faults were handled by KVM.
> > 
> > I understand that this commit wasn't in Linus' tree at the time you sent
> > these patches, could you please attribute it as:
> > 
> >   commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")
> > 
> > in v2?
> 
> Sorry, I was a bit terse. What I mean is to update all of the commit
> messages to reflect the suggestion.

Sounds good, will do. I was betting on having a v2 by then (should have
mentioned it in the cover letter).

> 
> --
> Thanks,
> Oliver
