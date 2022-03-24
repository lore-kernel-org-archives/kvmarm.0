Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F156C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 17:29:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9134B40815;
	Thu, 24 Mar 2022 13:29:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ivj5TQMkvCNQ; Thu, 24 Mar 2022 13:29:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DA534B108;
	Thu, 24 Mar 2022 13:29:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A9C040C31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:29:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1IUCx6JbWNqy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 13:29:40 -0400 (EDT)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D9B440815
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:29:40 -0400 (EDT)
Received: by mail-pj1-f42.google.com with SMTP id
 l4-20020a17090a49c400b001c6840df4a3so5794536pjm.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 10:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xkTTX4lGVmunWcx6XE9IvQD+TCrd2C88fOUNhq2ndSg=;
 b=THw1o7ZnSyk0YJ3+tdQ+3l7/v1PLdEKzmivbzPVqRxFfvHoKime1xOmdRwtdhv01Dd
 WFgcJs+3vN+f96VddAKhBPaZF97NhGO85qDYoJ/CzICeQHOsK+JxL/yw4kX/aKY/ykMT
 QLNAEM3+oyQVSAmV4EDEuK0XtEBx6DsEmy8GRK4klrt/ZoCprz58zg11LNuI5Z7ZQpIm
 9QfRJVUBEyIyvZ9ICII7bn6pMXSR20ECHCFOyY5bdNVi/tbAOGmupdjK3tM1VwX40Zge
 tQ8iBfJPq3qPSa3MRSw37P+BXFTt2E6ROMkTNaMS1ItW6FjdEp+/1i0JUWBRiQqb3qdL
 IpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xkTTX4lGVmunWcx6XE9IvQD+TCrd2C88fOUNhq2ndSg=;
 b=qnev7rDeuQdNvyjakjpamABCN34dNLBPRNSuLUZW8eVR8CUN0FvjPD3sQPqs/eE5gR
 hu+aakeSM+kh2x9BDRRNpBx8zT/PhBM12hGoFwJYl8pvJtldlPHeNEm+AFQU1vIdl5cc
 1iJ5IMrUIKdILklbvR8okUK7h9dTd/nYXSaVLjot3Bq79Gf+a6RxM2tbn+RvD/yAZINh
 TMpJ7krZJMTOzgNtgzsqO81Gj8rqvAkFBqKXcSoumw7Ej1cno34bDs99i+usM8voWThw
 AMiTXGM9Gpwauw7vIXtaa0ad/tS58iZNwuzfrZ/T3c+FsGh2VdU4zL4WVOGpaP4bJxsH
 JKIQ==
X-Gm-Message-State: AOAM532DYMyEqFyW2ZlHwAX3YN3hbslWAmG6F9pnwWTsd+5cCZbR3nKF
 FrqI2kOwZ4c42MYqJvOBGzh7kw==
X-Google-Smtp-Source: ABdhPJzOMu6mvyY1YouBquvjkuhDjA6k7BFTNwshrVqNe7o2tIILDiNi07FpzF3EpqnQGjzU1BXq9A==
X-Received: by 2002:a17:90b:4c8c:b0:1c6:f86d:a6f5 with SMTP id
 my12-20020a17090b4c8c00b001c6f86da6f5mr19717021pjb.15.1648142979296; 
 Thu, 24 Mar 2022 10:29:39 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 k3-20020a056a00168300b004f7e60da26csm4368286pfc.182.2022.03.24.10.29.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 10:29:38 -0700 (PDT)
Date: Thu, 24 Mar 2022 10:29:35 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 2/4] KVM: selftests: add is_cpu_online() utility
 function
Message-ID: <Yjyqf5oAxZzC7g7H@google.com>
References: <20220322172319.2943101-1-ricarkol@google.com>
 <20220322172319.2943101-3-ricarkol@google.com>
 <YjyoJu0/Saowtrbc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YjyoJu0/Saowtrbc@google.com>
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Mar 24, 2022 at 05:19:34PM +0000, Sean Christopherson wrote:
> On Tue, Mar 22, 2022, Ricardo Koller wrote:
> > Add is_cpu_online() utility function: a wrapper for
> > "/sys/devices/system/cpu/cpu%d/online".
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/test_util.h |  2 ++
> >  tools/testing/selftests/kvm/lib/test_util.c     | 16 ++++++++++++++++
> >  2 files changed, 18 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> > index 99e0dcdc923f..14084dc4e152 100644
> > --- a/tools/testing/selftests/kvm/include/test_util.h
> > +++ b/tools/testing/selftests/kvm/include/test_util.h
> > @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
> >  	return (void *)align_up((unsigned long)x, size);
> >  }
> >  
> > +bool is_cpu_online(int pcpu);
> > +
> >  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> > index 6d23878bbfe1..81950e6b6d10 100644
> > --- a/tools/testing/selftests/kvm/lib/test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/test_util.c
> > @@ -334,3 +334,19 @@ long get_run_delay(void)
> >  
> >  	return val[1];
> >  }
> > +
> > +bool is_cpu_online(int pcpu)
> > +{
> > +	char p[128];
> > +	FILE *fp;
> > +	int ret;
> > +
> > +	snprintf(p, sizeof(p), "/sys/devices/system/cpu/cpu%d/online", pcpu);
> 
> I don't think this is sufficient for the use in patch 03; the CPU could be online
> but disallowed for use by the current task.  I think what you want instead is a
> combination of get_nprocs_conf() + sched_getaffinity() + CPU_ISSET().

Good point. I was just thinking about the more common situation where a
user tries to use a CPU that doesn't even exist. Will fix in v4.

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
