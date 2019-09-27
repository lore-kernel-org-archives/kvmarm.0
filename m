Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98ABC4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:31:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BE56207FF
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:31:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BE56207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 950224A76A;
	Fri, 27 Sep 2019 08:31:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eYbJqR3Wtd-4; Fri, 27 Sep 2019 08:31:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7400F4A705;
	Fri, 27 Sep 2019 08:31:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C6684A6A4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:31:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZGpsW+saul4B for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 08:31:22 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C84A4A6A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:31:22 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 8A6E0191864C;
 Fri, 27 Sep 2019 12:31:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B1575D6A7;
 Fri, 27 Sep 2019 12:31:20 +0000 (UTC)
Date: Fri, 27 Sep 2019 14:31:18 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH 6/6] arm: Add missing test name prefix calls
Message-ID: <20190927123118.mbp3ybviz6xve7qr@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-7-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190927104227.253466-7-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2
 (mx1.redhat.com [10.5.110.70]); Fri, 27 Sep 2019 12:31:21 +0000 (UTC)
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Fri, Sep 27, 2019 at 11:42:27AM +0100, Andre Przywara wrote:
> When running the unit tests in TAP mode (./run_tests.sh -t), every single
> test result is printed. This works fine for most tests which use the
> reporting prefix feature to indicate the actual test name.
> However psci and pci were missing those names, so the reporting left
> people scratching their head what was actually tested:
> ...
> ok 74 - invalid-function
> ok 75 - affinity-info-on
> ok 76 - affinity-info-off
> ok 77 - cpu-on
> 
> Push a "psci" prefix before running those tests to make those report
> lines more descriptive.
> While at it, do the same for pci, even though it is less ambigious there.
> Also the GIC ITARGETSR test was missing a report_prefix_pop().
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c      | 2 ++
>  arm/pci-test.c | 2 ++
>  arm/psci.c     | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 66dcafe..ebb6ea2 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -480,6 +480,8 @@ static void test_targets(int nr_irqs)
>  	test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
>  
>  	writel(orig_targets, targetsptr + GIC_FIRST_SPI);
> +
> +	report_prefix_pop();
>  }
>  
>  static void gic_test_mmio(void)
> diff --git a/arm/pci-test.c b/arm/pci-test.c
> index cf128ac..7c3836e 100644
> --- a/arm/pci-test.c
> +++ b/arm/pci-test.c
> @@ -19,6 +19,8 @@ int main(void)
>  		return report_summary();
>  	}
>  
> +	report_prefix_push("pci");
> +
>  	pci_print();
>  
>  	ret = pci_testdev();
> diff --git a/arm/psci.c b/arm/psci.c
> index 5cb4d5c..536c9b7 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -126,6 +126,8 @@ int main(void)
>  {
>  	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
>  
> +	report_prefix_push("psci");
> +
>  	if (nr_cpus < 2) {
>  		report_skip("At least 2 cpus required");
>  		goto done;
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
