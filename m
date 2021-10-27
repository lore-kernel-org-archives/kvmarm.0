Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC08C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 15:28:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 706A5610C8
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 15:28:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 706A5610C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F10284B0C0;
	Wed, 27 Oct 2021 11:28:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UleLDu7YPSbc; Wed, 27 Oct 2021 11:28:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 328D34B161;
	Wed, 27 Oct 2021 11:28:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B95874B136
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 11:28:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KGyodbZBfrcV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 11:28:36 -0400 (EDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33F424B0F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 11:28:36 -0400 (EDT)
Received: by mail-pg1-f172.google.com with SMTP id r2so3230333pgl.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 08:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=jluBW5yA9LvugmQi8oyfDy8/cabbakiUXPqo4utsaB8=;
 b=IXIkAF60iwH8Ca28unKtkkjCxMxH4jsRE7rdlyRpHRKxqRH5DKvzKzXeE1xZpeP67E
 xwOJxCxtNAW/vuRZ9/cA++xLC0bu82EJesdjjIouYVg3x2VESqFJeksK7bKKBVif038n
 GNlri9Hc+F1u7CW4lPLn9JPRn52da4aBC4xsr93HTbSLq1yGzKbznkaiM+WfpWPTb1nX
 8Hjyo7QQx66GQF0REMEMDncs7WF5cqEgNENljeKIdAyawTn2njGp/q6Q7uPOzyYDFpEX
 mqf5isD4pvLAp694w88H9zUwbgY74QXFwiejeE2dZlhZt757K0HlOnfUIVAivKet6eGr
 4Dpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jluBW5yA9LvugmQi8oyfDy8/cabbakiUXPqo4utsaB8=;
 b=pInBTfZnRMr8tAU5KUuQnihjJlLO6PXdZPQ+hzhZ74s2YnqvlsCJMLMaetPd4KYAfe
 WhP+VQEhyH5xWsDfoAUanEJomCRNnu3JHB3FSoha9hQmRMs6vdnjwgTJ8vQK8j6xG0N4
 uWpGw2u3bqWFQ0KHeXAYbLVlZDlWO68a8JLL3kN9+TQvxpUPDkzg+ffcdoZqyVB8XRzn
 CIWPlPU3QiotF/hSVKHwL5rB4ghn3vpCiftBD0bNVudS/CXzsID5Bc7wBFu7EoIRmb7D
 ebmdN+axnOqQwUHnL++zXr6VE1H7OZ4vU7DCQwOzfftKM7GDceO0LXbtIeSMhWyEHNAz
 PGZQ==
X-Gm-Message-State: AOAM533DYTXqFtBE5A4Oa2Z0F+0XBel2c/oI8TKTnzI9w9LMP6ZgojlE
 OcR7ixHp4TLV2/J6QK5A8SBmnQ==
X-Google-Smtp-Source: ABdhPJxibfpJFn220g32tVsxXXYwD2JThHpi8b5HJLrZMbbjn5Hu0UDQk4ZV4kEcRQbC7q9gao3DeQ==
X-Received: by 2002:a05:6a00:2405:b0:44c:1ec3:8dbe with SMTP id
 z5-20020a056a00240500b0044c1ec38dbemr33619608pfh.33.1635348515143; 
 Wed, 27 Oct 2021 08:28:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id y19sm340714pfn.23.2021.10.27.08.28.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Oct 2021 08:28:34 -0700 (PDT)
Date: Wed, 27 Oct 2021 15:28:31 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
Message-ID: <YXlwH2vWILFS9QOG@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
 <YXllGfrjPX1pVUx6@google.com>
 <ecec4d7d-13dd-c992-6648-3624d7c14c24@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ecec4d7d-13dd-c992-6648-3624d7c14c24@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Wed, Oct 27, 2021, Paolo Bonzini wrote:
> On 27/10/21 16:41, Sean Christopherson wrote:
> > The other thing I don't like about having the WARN in the loop is that it suggests
> > that something other than the vCPU can modify the NDST and SN fields, which is
> > wrong and confusing (for me).
> 
> Yeah, I can agree with that.  Can you add it in a comment above the cmpxchg
> loop, it can be as simple as
> 
> 	/* The processor can set ON concurrently.  */
> 
> when you respin patch 21 and the rest of the series?

I can definitely add a comment, but I think that comment is incorrect.  AIUI,
the CPU is the one thing in the system that _doesn't_ set ON, at least not without
IPI virtualization (haven't read that spec yet).  KVM (software) sets it when
emulating IPIs, and the IOMMU (hardware) sets it for "real" posted interrupts,
but the CPU (sans IPI virtualization) only clears ON when processing an IRQ on
the notification vector.

So something like this?

	/* ON can be set concurrently by a different vCPU or by hardware. */
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
