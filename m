Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF44FC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Apr 2022 01:56:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FFCA4B1BF;
	Mon,  4 Apr 2022 21:56:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HrRRDnoNSrl5; Mon,  4 Apr 2022 21:56:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 159174B133;
	Mon,  4 Apr 2022 21:56:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE5414B0B6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 21:56:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0-hCREvbIvGr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 21:56:34 -0400 (EDT)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BAC5649F5B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 21:56:34 -0400 (EDT)
Received: by mail-pj1-f42.google.com with SMTP id
 g15-20020a17090adb0f00b001caa9a230c7so1064307pjv.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 18:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JSEiQNEgLzNehCj2N1qkt1yiYw63ndtI615+rA0Q68c=;
 b=doQ/goBnkxA1rXnSX2lWlFdMlYnisYl+4a64cEDjt4d8YzNnz8CAWfKyRO0k2UDWp3
 eimyFaHqy7RuD7uW+YKCg2D+tO9Urj2A1PqgtVbm+Nnd9lmCdJK2nHV3zC6g8wchg0po
 EaoEmtaomW1JjS8xcC5rJyu+4I136n2Px9Jom3i/eLDvWco4n6m5dAB5IAe22At3nmK1
 mt2rgfwkjjsgBGE1NmLrXLgwmlY28a6pBfzPkXCAMVa/Ox5RfM/bvd/fRmUBUzn9Rptt
 F5jB8iCuuCnuqn7Ks8MwKPmoJ4v0SfQSKO8NsSLDMrWn2qw3tn5CrrOlmB4WQ2BDH1Jy
 L+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JSEiQNEgLzNehCj2N1qkt1yiYw63ndtI615+rA0Q68c=;
 b=uJGTXsChJL0Pj1biWuXX7SI038m32kt9S9KkAJKylCgnx63ivfAvRsq/6TFN5lytMt
 3vb1dtx6B3AFAmy648/Eg77NV8+Nj4h+epf9xax0QHtR2LK1xGZ0oMo519Jdvp0GEb4q
 nOlCo0p8QPcBnDjTs72Kl/Q7lFrZ573l1XW1cOJ7ZpjxV4actVdcOgunUlBBF0lNdlpS
 NbLZLWEcr6y4b37T/2mfMotNnmeHuD2EBe5YoXleqVziOx8bqxf/DAGYJvLEdkuVA7AG
 rju40aRxcZkFXWscY6WiMi0SoeRTZa1EnS5AHsoVXaOjdUr6JmwFZ3K2aryb8v1pjZTj
 1PYA==
X-Gm-Message-State: AOAM533TgSqtStpiDF9DuXF8mxmErNtDjNjLM4sevTMOdPnL5zHKh+mQ
 YDs2p5bTS7odiyCl06apsMnbXg==
X-Google-Smtp-Source: ABdhPJyYa3VBrowXUAjAkU9zJ0ErXJB1Zdb8TUzr4UXplkvPF68iJEuVxlpzwhQwo7HJQlI/66koCQ==
X-Received: by 2002:a17:902:a9c7:b0:156:8951:651d with SMTP id
 b7-20020a170902a9c700b001568951651dmr1117931plr.79.1649123793565; 
 Mon, 04 Apr 2022 18:56:33 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 f21-20020a056a00239500b004fb02a7a45bsm13475625pfc.214.2022.04.04.18.56.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Apr 2022 18:56:32 -0700 (PDT)
Date: Mon, 4 Apr 2022 18:56:29 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 2/4] KVM: selftests: add is_cpu_eligible_to_run()
 utility function
Message-ID: <YkuhzRAiyt+M8RLi@google.com>
References: <20220404214642.3201659-1-ricarkol@google.com>
 <20220404214642.3201659-3-ricarkol@google.com>
 <YkuJrYL6wL5P5JY/@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YkuJrYL6wL5P5JY/@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Apr 05, 2022 at 12:13:33AM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Mon, Apr 04, 2022 at 02:46:40PM -0700, Ricardo Koller wrote:
> > Add is_cpu_eligible_to_run() utility function, which checks whether the current
> > process, or one of its threads, is eligible to run on a particular CPU.
> > This information is obtained using sched_getaffinity.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/include/test_util.h |  2 ++
> >  tools/testing/selftests/kvm/lib/test_util.c   | 20 ++++++++++++++++++-
> >  2 files changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> > index 99e0dcdc923f..a7653f369b6c 100644
> > --- a/tools/testing/selftests/kvm/include/test_util.h
> > +++ b/tools/testing/selftests/kvm/include/test_util.h
> > @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
> >  	return (void *)align_up((unsigned long)x, size);
> >  }
> >  
> > +bool is_cpu_eligible_to_run(int pcpu);
> > +
> >  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> > index 6d23878bbfe1..7813a68333c0 100644
> > --- a/tools/testing/selftests/kvm/lib/test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/test_util.c
> > @@ -4,6 +4,7 @@
> >   *
> >   * Copyright (C) 2020, Google LLC.
> >   */
> > +#define _GNU_SOURCE
> >  
> >  #include <assert.h>
> >  #include <ctype.h>
> > @@ -13,7 +14,9 @@
> >  #include <sys/stat.h>
> >  #include <sys/syscall.h>
> >  #include <linux/mman.h>
> > -#include "linux/kernel.h"
> > +#include <linux/kernel.h>
> > +#include <sched.h>
> > +#include <sys/sysinfo.h>
> >  
> >  #include "test_util.h"
> >  
> > @@ -334,3 +337,18 @@ long get_run_delay(void)
> >  
> >  	return val[1];
> >  }
> > +
> > +bool is_cpu_eligible_to_run(int pcpu)
> > +{
> > +	cpu_set_t cpuset;
> > +	long i, nprocs;
> > +
> > +	nprocs = get_nprocs_conf();
> > +	sched_getaffinity(0, sizeof(cpu_set_t), &cpuset);
> > +	for (i = 0; i < nprocs; i++) {
> > +		if (i == pcpu)
> > +			return CPU_ISSET(i, &cpuset);
> > +	}
> 
> I don't think you need the loop and can just do CPU_ISSET(pcpu, &cpuset),
> right?

Oops, definitely not. Thanks for catching this.

> 
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
