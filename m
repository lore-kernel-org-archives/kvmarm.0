Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037EFC3815B
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 16:21:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B051520737
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 16:21:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YqTW1P0I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B051520737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47CBE4B21D;
	Wed, 15 Apr 2020 12:21:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vu1tH+-kGk5n; Wed, 15 Apr 2020 12:21:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57DED4B1FB;
	Wed, 15 Apr 2020 12:21:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B564B1D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 12:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wWdugphjlKtn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 12:21:19 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EA564B19A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 12:21:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586967679;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Sd5eA/N/NI5n7N98BdtAvkb6ngdNDSTXR+h4Z3gbW68=;
 b=YqTW1P0IX0qpvyGRB3LfG9zr8LX3emUM/hRlcLqP2n0JiUGaoW4h1bXcV6QRXR8CYRs03z
 5rHVtr2SQEMcvo87AFLA8K7YnLMHQwoHD7X8ySRNIrOKaRuoEXl0XXFRJtuVk+5Emls5e8
 rKEWMMxoQbAeVsgwl5kOTG8NIibAxho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-wrQvUDtbM8mVEqqfRLVCsg-1; Wed, 15 Apr 2020 12:21:15 -0400
X-MC-Unique: wrQvUDtbM8mVEqqfRLVCsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90C09107B267;
 Wed, 15 Apr 2020 16:21:12 +0000 (UTC)
Received: from gondolin (ovpn-113-55.ams2.redhat.com [10.36.113.55])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 017ACA63D6;
 Wed, 15 Apr 2020 16:21:02 +0000 (UTC)
Date: Wed, 15 Apr 2020 18:20:37 +0200
From: Cornelia Huck <cohuck@redhat.com>
To: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: Re: [PATCH v2] kvm_host: unify VM_STAT and VCPU_STAT definitions in
 a single place
Message-ID: <20200415182037.521a92b2.cohuck@redhat.com>
In-Reply-To: <20200414155625.20559-1-eesposit@redhat.com>
References: <20200414155625.20559-1-eesposit@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>,
 Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, 14 Apr 2020 17:56:25 +0200
Emanuele Giuseppe Esposito <eesposit@redhat.com> wrote:

> The macros VM_STAT and VCPU_STAT are redundantly implemented in multiple
> files, each used by a different architecure to initialize the debugfs
> entries for statistics. Since they all have the same purpose, they can be
> unified in a single common definition in include/linux/kvm_host.h
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/arm64/kvm/guest.c    |  23 ++---
>  arch/mips/kvm/mips.c      |  61 ++++++------
>  arch/powerpc/kvm/book3s.c |  61 ++++++------
>  arch/powerpc/kvm/booke.c  |  41 ++++----
>  arch/s390/kvm/kvm-s390.c  | 203 +++++++++++++++++++-------------------
>  arch/x86/kvm/x86.c        |  80 +++++++--------
>  include/linux/kvm_host.h  |   5 +
>  7 files changed, 231 insertions(+), 243 deletions(-)

Adds a bit of churn, but the end result does look nicer. Looks sane,
but did not review in detail.

Acked-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
