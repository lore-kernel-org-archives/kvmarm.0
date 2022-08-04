Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94641C19F2A
	for <kvmarm@archiver.kernel.org>; Thu,  4 Aug 2022 18:22:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB5C4E781;
	Thu,  4 Aug 2022 14:22:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o07MTpiPwu+x; Thu,  4 Aug 2022 14:22:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0B54E7DC;
	Thu,  4 Aug 2022 14:22:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 836014E781
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 14:22:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H7fNjMCNDoMw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2022 14:22:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3191F4E7BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 14:22:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1659637323;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=v75w6GLObgAtRIZl7LRPPpod4VI56HpyexDqTUTHWM0=;
 b=D1ZDlJiE3O/JyssEfLX9hrbalPdu9rMWUacEgDOzfysAPrkp0sngWIZdCouFZ/2kcRf02S
 Cqm0fnHUwyNYmdaTzkPtiUdejWeWZzPzn5JfU25UYiOGpylxFGWA3Hg5zlwXm+pQ7dFnRH
 CdQlp36b2/zNWxeCa6hZDsZXL/3AADM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-9T-Ry7QLPlKceOfhx9idtA-1; Thu, 04 Aug 2022 14:22:01 -0400
X-MC-Unique: 9T-Ry7QLPlKceOfhx9idtA-1
Received: by mail-wm1-f69.google.com with SMTP id
 i9-20020a1c3b09000000b003a511239973so321152wma.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2022 11:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:reply-to:user-agent:mime-version:date
 :message-id:x-gm-message-state:from:to:cc;
 bh=v75w6GLObgAtRIZl7LRPPpod4VI56HpyexDqTUTHWM0=;
 b=QURyHXWmtus8Gzo+l2v0ruQ74irhmIuuiC496f/MXvCnMAZhOA2Hoa6jXoyYdrHw6t
 W3szdEuF9WYwTTCvJY1/9RzSNe3nHOr139I2qOrT/5ootzSD8tFs5GPA0Nj4JNcTJEk0
 clCkkotbuOI6lXNgUsakYmz8iQCNso8LGRWjWCsuuIYMb58Y0TeCbkbZFWowNOaAF+a8
 crtoelXLDgD7UC1he4IIv5DGNJn9eP5clude/1sCG10YrE3U5Q5iPa4i7lWw4LHAKTbq
 8tHCLCkvjZDEnv3YYCdoa6A7Zovbwp8gSv6ZQsupirMSszZXE/jhqTHbKBV9mpFySLq3
 yOIw==
X-Gm-Message-State: ACgBeo1hzMbNeouHOigHySXYCqDi0nB2whfx9I++uZPqY3zydwdFMxBj
 2OzwxbkUrIX52SBbRHXSjTgHtb6LRQPcLCSgEebxPRjsgfsLy1WZmLglB+DJJsmUkKK07B4Rwt1
 2XLGxyDfqdvLIUTTUPwujIyuk
X-Received: by 2002:a05:600c:1e8d:b0:3a5:74d:c61c with SMTP id
 be13-20020a05600c1e8d00b003a5074dc61cmr2313605wmb.70.1659637319691; 
 Thu, 04 Aug 2022 11:21:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5qa6u4rvLgdrkeGZQ58TN8wqu+0q3xLX/YnoDM93GtPS6AXXdj3d2Nxn1Y47VQUM/Q9USHMw==
X-Received: by 2002:a05:600c:1e8d:b0:3a5:74d:c61c with SMTP id
 be13-20020a05600c1e8d00b003a5074dc61cmr2313594wmb.70.1659637319521; 
 Thu, 04 Aug 2022 11:21:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 bi19-20020a05600c3d9300b003a342933727sm7203839wmb.3.2022.08.04.11.21.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 04 Aug 2022 11:21:58 -0700 (PDT)
Message-ID: <33adcdb9-9f29-a253-6491-314dcd08e0c8@redhat.com>
Date: Thu, 4 Aug 2022 20:21:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v2 2/3] arm: pmu: Reset the pmu registers
 before starting some tests
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-3-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220803182328.2438598-3-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

Hi Ricardo,

On 8/3/22 20:23, Ricardo Koller wrote:
> Some registers like the PMOVS reset to an architecturally UNKNOWN value.
> Most tests expect them to be reset (mostly zeroed) using pmu_reset().
> Add a pmu_reset() on all the tests that need one.
>
> As a bonus, fix a couple of comments related to the register state
> before a sub-test.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/pmu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 76156f78..7c5bc259 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
>  	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
>  	isb();
>  
> -	/* interrupts are disabled */
> +	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>  
>  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
>  	report(expect_interrupts(0), "no overflow interrupt after preset");
> @@ -841,7 +841,7 @@ static void test_overflow_interrupt(void)
>  	isb();
>  	report(expect_interrupts(0), "no overflow interrupt after counting");
>  
> -	/* enable interrupts */
> +	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
>  
>  	pmu_reset_stats();
>  
> @@ -889,6 +889,7 @@ static bool check_cycles_increase(void)
>  	bool success = true;
>  
>  	/* init before event access, this test only cares about cycle count */
> +	pmu_reset();
>  	set_pmcntenset(1 << PMU_CYCLE_IDX);
>  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>  
> @@ -943,6 +944,7 @@ static bool check_cpi(int cpi)
>  	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
>  
>  	/* init before event access, this test only cares about cycle count */
> +	pmu_reset();
>  	set_pmcntenset(1 << PMU_CYCLE_IDX);
>  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
