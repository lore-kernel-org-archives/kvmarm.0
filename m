Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E31ECAAA1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 19:57:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4AA4C458;
	Fri,  9 Sep 2022 15:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZBu+aYIYANtb; Fri,  9 Sep 2022 15:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D4454C035;
	Fri,  9 Sep 2022 15:57:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B8364BF8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 15:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UQugB+sev05c for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 15:57:19 -0400 (EDT)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BC3F4C035
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 15:57:19 -0400 (EDT)
Received: by mail-pl1-f171.google.com with SMTP id t3so2765791ply.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2022 12:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=Ix+zHu63uexJwygRlsHzmVxxGE2dqts71wJzPIEl4nM=;
 b=s3KGT+5stdiJg6ABS08VG/cuaUdFpcYRsjAtE0XUHTJ2k0VaiPA6MoGcOqQzAMBKQ5
 g76yDGGNwKZwynN1NZv3i4AiFb4LC4FBH+O88gO53Sw8OAobYXXdc1XWZcFuhHwXGHNT
 sPrdsFYYJSPQ7UOGjPhzy53NLHd9TAKri8US/CzLBtaqTMDr9/MPYcAkNWgSwmDZUQhA
 +qBDiBBDao6/P5LSqLNw/NEEJsb+6YZWBrBnPPSfVgNutZ7WZuz8iyuIepnoISqJ4lMC
 58DGydl2/5e/O/5o7/1Nho6fNza7IDKHbiob7N9vDffb3r3lHf/xHmM09asG4LVKlGv0
 MOPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Ix+zHu63uexJwygRlsHzmVxxGE2dqts71wJzPIEl4nM=;
 b=6gt/xVWXJeaeoifEHvs2EjQBtqaFe4mGwrtS4ps0ZOrSuLmjBDHIBdeWhFcqtPv5aU
 AVhlLwgsY23s75iHQRCMD2Klkz1QJxWk5T81kXrR2TpxJOruv4YhiqdnT28R5V3hPHl+
 pCyShrrA7WmQBRW3M8ApOHejPfNr4Q7OvdvSvqoGGXG+2T8IkLarxOhmRcZJjr8QuQeV
 G07/fEz3K35/bgeToNwc5DFT3gshsIIJAPv5/XUvCuXavefbDw3trev1d8qpPqbv90DJ
 2leVl4bISJDRlr2YBgJ87CvGzKVoTiPQpslOk7JCnhMigX/f1RWJ9To87FSuEowxOa64
 Aqdw==
X-Gm-Message-State: ACgBeo3RSy7i77nIq73a9p6L7s5f/a2EjY+SN4j2pGEM7mV8XxYT08ve
 CgT1UVU5wOhzVrDogyXQq3RPxQ==
X-Google-Smtp-Source: AA6agR5iABvqonzUsPwhF2ANtZ3gF54funoMeqvKsSUZtabxsI64h5+aJQDpiixm2ch7NwlmHH/+sA==
X-Received: by 2002:a17:90b:164f:b0:1f5:4ced:ed81 with SMTP id
 il15-20020a17090b164f00b001f54ceded81mr11101733pjb.122.1662753438095; 
 Fri, 09 Sep 2022 12:57:18 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 b9-20020a170902d40900b0016bedcced2fsm890830ple.35.2022.09.09.12.57.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Sep 2022 12:57:17 -0700 (PDT)
Date: Fri, 9 Sep 2022 12:57:13 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 4/9] KVM: arm64: selftests: Add helpers to enable debug
 exceptions
Message-ID: <YxuamUS4F1SLz7Md@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-5-reijiw@google.com>
 <YwevrW4YrHQQOyew@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YwevrW4YrHQQOyew@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Aug 25, 2022 at 10:21:49AM -0700, Oliver Upton wrote:
> On Wed, Aug 24, 2022 at 10:08:41PM -0700, Reiji Watanabe wrote:
> > Add helpers to enable breakpoint and watchpoint exceptions.
> > 
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 25 ++++++++++---------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 183ee16acb7d..713c7240b680 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -128,10 +128,20 @@ static void enable_os_lock(void)
> >  	GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
> >  }
> >  
> > +static void enable_debug_bwp_exception(void)
> 
> uber-nit: enable_monitor_debug_exceptions()
> 
> (more closely matches the definition of MDSCR_EL1.MDE)

oh, didn't know the MDE was for monitor debug exc. Anyway:

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> 
> With that:
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> --
> Thanks,
> Oliver
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
