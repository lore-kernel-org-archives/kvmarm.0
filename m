Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09DCC07E95
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 18:57:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 267CC61416
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 18:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 267CC61416
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 960E5406D3;
	Fri,  2 Jul 2021 14:57:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eINVLSdAPBK1; Fri,  2 Jul 2021 14:56:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DAE04086C;
	Fri,  2 Jul 2021 14:56:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE56A40667
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 14:56:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n8TguKGp4jWe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 14:56:57 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B01B140629
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 14:56:57 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id l11so6920906pji.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Jul 2021 11:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Ycum9evCUFiduU+FXmIYFePuE2chcx7yYwOjeyhRcmY=;
 b=ho0D7I7qB20VRN3J6CXnbaLEYxEHCdEhVu40EI6ZPzzLcPs3bffu8rWBtcdZsoJgFO
 xNIJCsBkGe7H+XUlLF4eh+fpD6EV9y5Yp0q+a4755qD0CHKsbqCGc1mvHWjTJDRhs8zR
 zp+14ILcLWZcM0fpMylNDU8qtbK/+pGTH36f0kFuHjI5MZ4jV7T+885DDSZGWp/bnRdA
 1IycNnZ3X0DlSGIOJjyQ14oO42YRoImsBPMsHH0NPtHij010Tp0AY49LWyd8p9oWZgfX
 d4PqzWbZi/INO+FwT7gT9fcUeWlwdYvfihQZ7HB1jBOnaBBKyu3X7HNO2rq0oY4nmo0Y
 nEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Ycum9evCUFiduU+FXmIYFePuE2chcx7yYwOjeyhRcmY=;
 b=BGSC/eBGI0YeTeNRgIK6cixdNNPn+CthMTzsge5recRxraXTwzYnAIGCefL6hFTFDc
 SB6/qaDMxAeBBzCyj5AB2ixhJ/RdGxWvV3fiMiH8qoLux8bNaSsiYgmk+jfj/PF0OPaS
 lGK6ZS5/fqiDgotxlTwPpXYub+Ib5j+go/ydkuLzAWcSeiiddqzDC8H/2uf46RYcCFMc
 OW76PfqwKmiecgIIhTi4vXwZDNVLkXU2ivcQNcKbubzjtAUz9Z5q+BAbpQUHqJKrY5fP
 43rdVHl6/wi4BYV1eLlaeeCIBXgIci6lw4y6kQo/RgQ3xWSoGzsEqJPL8zJxCBDjnTfT
 /mSQ==
X-Gm-Message-State: AOAM5301XePaSNF0ZgTYWJcj2EOQwki29CXNns7CQ4ZtPAx8DWoq3Sz7
 cn+SFFvmbkGruAM1ICbIO4cnKQ==
X-Google-Smtp-Source: ABdhPJyLCScqgNzWVyO70OvO0qg6l9xuCtTQ0UMuGxyyNVkREi8sRKK50KY7HcDr5U0yDyK3iDOnLw==
X-Received: by 2002:a17:90a:558c:: with SMTP id
 c12mr1094718pji.166.1625252216557; 
 Fri, 02 Jul 2021 11:56:56 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id w14sm5030003pgo.75.2021.07.02.11.56.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Jul 2021 11:56:56 -0700 (PDT)
Date: Fri, 2 Jul 2021 11:56:52 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 5/6] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YN9hdFROSeMSTA2S@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-6-ricarkol@google.com>
 <b1f581ec-56f4-24a2-7850-182128cdc4ac@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b1f581ec-56f4-24a2-7850-182128cdc4ac@huawei.com>
Cc: kvm@vger.kernel.org, maz@kernel.org,
 Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Jul 02, 2021 at 02:46:57PM +0800, Zenghui Yu wrote:
> [+Sean]
> 
> On 2021/6/11 9:10, Ricardo Koller wrote:
> > Add the infrastructure needed to enable exception handling in aarch64
> > selftests. The exception handling defaults to an unhandled-exception
> > handler which aborts the test, just like x86. These handlers can be
> > overridden by calling vm_install_exception_handler(vector) or
> > vm_install_sync_handler(vector, ec). The unhandled exception reporting
> > from the guest is done using the ucall type introduced in a previous
> > commit, UCALL_UNHANDLED.
> > 
> > The exception handling code is inspired on kvm-unit-tests.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   2 +-
> >  .../selftests/kvm/include/aarch64/processor.h |  63 +++++++++
> >  .../selftests/kvm/lib/aarch64/handlers.S      | 126 ++++++++++++++++++
> >  .../selftests/kvm/lib/aarch64/processor.c     |  97 ++++++++++++++
> >  4 files changed, 287 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> 
> [...]
> 
> > +void vm_init_descriptor_tables(struct kvm_vm *vm)
> > +{
> > +	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> > +			vm->page_size, 0, 0);
> 
> This raced with commit a75a895e6457 ("KVM: selftests: Unconditionally
> use memslot 0 for vaddr allocations") which dropped memslot parameters
> from vm_vaddr_alloc().

Will send a fix to use vm_vaddr_alloc() without the memslot parameters.

> 
> We can remove the related comments on top of vm_vaddr_alloc() as well.

Can do this as well, will send a separate patch removing this. Unless
somebody was about to.

> 
> Zenghui

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
