Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63208C43331
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 05:07:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DACB020787
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 05:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCZ9BIUj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DACB020787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28E844B162;
	Fri,  3 Apr 2020 01:07:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RbOTVLzXUgp0; Fri,  3 Apr 2020 01:07:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1297D4B155;
	Fri,  3 Apr 2020 01:07:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9988D4B153
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 01:07:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xFagTa83F3xU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 01:07:21 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D434B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 01:07:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585890441;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ar69q/Vn4EWZU6G/sHx/rFDNM5LxG2zfTZ7Eo/xK9Gs=;
 b=VCZ9BIUjZzJdXVSLGrHzFmVnSzZJ6c0E9J13ZrSfYsUD4ptp434XMU0NBu+d99YoyI5ufk
 V2pLG5sRDiwzofB/DwA9ii2wXSqH7cbe2imDIK3Zy9sjp0x+i7KHybxHMAo1BY1kAI9V50
 4KlsCjnwdhl3QhGTxpTC1hKwKU0MImY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-T9MNBPQxPVuifpDmWI4fEA-1; Fri, 03 Apr 2020 01:07:17 -0400
X-MC-Unique: T9MNBPQxPVuifpDmWI4fEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5209C8017F3;
 Fri,  3 Apr 2020 05:07:15 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 359F110016E8;
 Fri,  3 Apr 2020 05:07:11 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] fixup! arm/arm64: ITS: pending table
 migration test
To: Andrew Jones <drjones@redhat.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20200402145227.20109-1-eric.auger@redhat.com>
 <20200402180148.490026-1-drjones@redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a13e00e8-b699-103a-af6c-7807b67f8c70@redhat.com>
Date: Fri, 3 Apr 2020 07:07:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200402180148.490026-1-drjones@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: thuth@redhat.com, andre.przywara@arm.com
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

Hi Drew,

On 4/2/20 8:01 PM, Andrew Jones wrote:
> [ Without the fix this test would hang, as timeouts don't work with
>   the migration scripts (yet). Use errata to skip instead of hang. ]
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/gic.c  | 18 ++++++++++++++++--
>  errata.txt |  1 +
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index ddf0f9d09b14..c0781f8c2c80 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -12,6 +12,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <errata.h>
>  #include <asm/setup.h>
>  #include <asm/processor.h>
>  #include <asm/delay.h>
> @@ -812,13 +813,23 @@ static void test_its_migration(void)
>  	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
>  }
>  
> +#define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
> +
>  static void test_migrate_unmapped_collection(void)
>  {
> -	struct its_collection *col;
> -	struct its_device *dev2, *dev7;
> +	struct its_collection *col = NULL;
> +	struct its_device *dev2 = NULL, *dev7 = NULL;
> +	bool test_skipped = false;
>  	int pe0 = 0;
>  	u8 config;
>  
> +	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
> +		report_skip("Skipping test, as this test hangs without the fix. "
> +			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
> +		test_skipped = true;
> +		goto do_migrate;
out of curiosity why do you still do the migration and not directly return.

Besides, what caused the migration to fail without 8c58be34494b is
bypassed so:

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>

Thank you for the fixup

Eric

> +	}
> +
>  	if (its_setup1())
>  		return;
>  
> @@ -830,9 +841,12 @@ static void test_migrate_unmapped_collection(void)
>  	its_send_mapti(dev2, 8192, 0, col);
>  	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
>  
> +do_migrate:
>  	puts("Now migrate the VM, then press a key to continue...\n");
>  	(void)getchar();
>  	report_info("Migration complete");
> +	if (test_skipped)
> +		return;
>  
>  	/* on the destination, map the collection */
>  	its_send_mapc(col, true);
> diff --git a/errata.txt b/errata.txt
> index 7d6abc2a7bf6..b66afaa9c079 100644
> --- a/errata.txt
> +++ b/errata.txt
> @@ -5,4 +5,5 @@
>  9e3f7a296940    : 4.9                           : arm64: KVM: pmu: Fix AArch32 cycle counter access
>  7b6b46311a85    : 4.11                          : KVM: arm/arm64: Emulate the EL1 phys timer registers
>  6c7a5dce22b3    : 4.12                          : KVM: arm/arm64: fix races in kvm_psci_vcpu_on
> +8c58be34494b    : 5.6                           : KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
>  #---------------:-------------------------------:---------------------------------------------------
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
