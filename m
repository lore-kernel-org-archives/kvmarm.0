Return-Path: <SRS0=XU7X=JY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCECC433B4
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 11:38:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D09B96100B
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 11:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D09B96100B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 485674B147;
	Tue, 27 Apr 2021 07:38:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@alien8.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1W3j56UxPD33; Tue, 27 Apr 2021 07:38:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17CFD4B135;
	Tue, 27 Apr 2021 07:38:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4206E4B12D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 07:38:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B94NXDLigDMr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Apr 2021 07:38:47 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 477E04B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 07:38:47 -0400 (EDT)
Received: from zn.tnic (p200300ec2f0c5e008a7c4c8941e22261.dip0.t-ipconnect.de
 [IPv6:2003:ec:2f0c:5e00:8a7c:4c89:41e2:2261])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5A0041EC047E;
 Tue, 27 Apr 2021 13:38:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
 t=1619523525;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
 bh=IAUQH8ckRL8RHgSocw7BeJrBQn+eUtnbT2dDn+igxMs=;
 b=JVTU+70sWvRTU+SopM0YlyyGOmgJ6g6s0pfWanKmCpWILaUWfjQC0nNpvbpkUqfQ2RRum2
 FEuSSKX1W3ssLIne23n7/XG++M6Vrmnc4wwpffOGYr4mLk1KAEn2IFh+WRvL4uHH763Ts1
 j21Ra3QsjV66hv690SzIZHGqkUij9BY=
Date: Tue, 27 Apr 2021 13:38:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 8/9] KVM: x86: add force_intercept_exceptions_mask
Message-ID: <YIf3wM1+enU1U/gn@zn.tnic>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
 <20210401135451.1004564-9-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210401135451.1004564-9-mlevitsk@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, "open list:S390" <linux-s390@vger.kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 "maintainer:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Jan Kiszka <jan.kiszka@siemens.com>, Stefano Garzarella <sgarzare@redhat.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Kieran Bingham <kbingham@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <linux-arm-kernel@lists.infradead.org>, Jim Mattson <jmattson@google.com>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
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

On Thu, Apr 01, 2021 at 04:54:50PM +0300, Maxim Levitsky wrote:
> This parameter will be used by VMX and SVM code to force
> interception of a set of exceptions, given by a bitmask
> for guest debug and/or kvm debug.
> 
> This option is not intended for production.
> 
> This is based on an idea first shown here:
> https://patchwork.kernel.org/project/kvm/patch/20160301192822.GD22677@pd.tnic/
> 
> CC: Borislav Petkov <bp@suse.de>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  arch/x86/kvm/x86.h | 2 ++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3627ce8fe5bb..1a51031d64d8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -176,6 +176,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
>  int __read_mostly pi_inject_timer = -1;
>  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  
> +uint force_intercept_exceptions_mask;
> +module_param(force_intercept_exceptions_mask, uint, S_IRUGO | S_IWUSR);
> +EXPORT_SYMBOL_GPL(force_intercept_exceptions_mask);

That's nice.

I could use some text explaning the usage though, i.e. that thing takes
a bitfield of exception vectors, so that I don't have to look at the
code each time. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
