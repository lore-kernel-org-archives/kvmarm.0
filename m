Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64257B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 18:06:07 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id u20so4810681vsp.5
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 10:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=14Wsnq1C5/e/lr4OHIbzbe/RW8U5P8QTch1ADuqyPNc=;
        b=hqydrB0uk3xrYuEWrr9bC2c28vBvdOrWuT4o2GQyjyKHHMRGVquMplEKn0VEa7IG3z
         zDPbKd6PNbA8+cMSjjZJ+XY/jm106WMeZVNzEP1rVcs4pGglU3JTT/NTzterzjXgwbZu
         e7pvbkYFHd0k6CT2PbycxRlNPY7/TcAODYosIg6cF3OaA/8PLnDtJDpAcnhD5aQTIzsg
         Qg3fsJ45d4GMQ1hKwksNnZ0KFwhmWHRQRRTuQn8W+RBtH6mHF9lgMKRiXGn2KEx/GMlQ
         QmiDcJyYqdxCQ4+RbsIxNsGKLpnkix1GXBZkVFemnFQD1RDwOo8POfG5Uq1MtnEB3X4K
         WNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=14Wsnq1C5/e/lr4OHIbzbe/RW8U5P8QTch1ADuqyPNc=;
        b=SvkCs6itRLXRW3rqmLbjziDgKiy5LdEiWVD9URJuqMfLuxZ6khnHztdSQ4L3F9+QBE
         Gen9tjTcmajip/kheNU09WCQkK2WpKifu/O91IK8p0OvLls6lHJL2fOCxa34CXiaqEri
         B3XhrxUy1kLm7JHQXFWZksqHDdf5DtttU2JokCByqI2oelnUxvd9yCV5g3KhLuy7nRyV
         WI6NoDzo7kvz9fDoQ7W/5aXIZQHYTpPP0iuqLgSw1Y7Y39YbJNiCAv5IEGJ7kbgdeOms
         5YLEjRQMBAGhGtYNfpfEMnS4AGL8y7Zk37oXzBSKEsKoYIw794sfq4DjRrncwzfTyZjS
         0gmw==
X-Gm-Message-State: AO0yUKW4SN5ZnFUa10HbeMJGbFktlY8mnsFEWmgq0u/STH1suhdywABt
	PjPOvESoSsyAfg2tY0oddd5lcsKSnFMZIkNAIjb8MA==
X-Google-Smtp-Source: AK7set/KlyJWZTFcc9c+ciNsp30/44ed0OYWwISa16TuXvviGl/4f1NDwiurFeZZA96nyqwnVTbAz2TX63KihceiHCU=
X-Received: by 2002:a05:6102:3b01:b0:412:6a3:2267 with SMTP id
 x1-20020a0561023b0100b0041206a32267mr719527vsu.5.1676484366683; Wed, 15 Feb
 2023 10:06:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-2-amoorthy@google.com>
 <Y+yJU2pE4IyuIwOQ@linux.dev> <Y+0L/x2YgiEgm9bt@google.com>
In-Reply-To: <Y+0L/x2YgiEgm9bt@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 15 Feb 2023 10:05:55 -0800
Message-ID: <CAF7b7mpSOqzrxqXgpSjD17SufaV-2ZnLL5+eR29jJL_j=1aFvA@mail.gmail.com>
Subject: Re: [PATCH 1/8] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, James Houghton <jthoughton@google.com>, Ben Gardon <bgardon@google.com>, 
	David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 15, 2023 at 8:44 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Feb 15, 2023, Oliver Upton wrote:
> > Hi Anish,
> >
> > On Wed, Feb 15, 2023 at 01:16:07AM +0000, Anish Moorthy wrote:
> > > Currently we're dividing tv_nsec by 1E8, not 1E9.
> > >
> > > Reported-by: James Houghton <jthoughton@google.com>
> > > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > > index b0e1fc4de9e29..6809184ce2390 100644
> > > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > > @@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >             ts_diff.tv_sec, ts_diff.tv_nsec);
> > >     pr_info("Overall demand paging rate: %f pgs/sec\n",
> > >             memstress_args.vcpu_args[0].pages * nr_vcpus /
> > > -           ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
> > > +           ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 1E9));
> >
> > Use NSEC_PER_SEC instead so the conversion taking place is immediately
> > obvious.
>
> And please post this separately, it's a fix that's independent of the rest of the
> series and can/should be applied sooner than later.

Will do, and thanks for the pointer to NSEC_PER_SEC Oliver.
