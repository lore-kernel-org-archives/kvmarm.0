Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFD6C433B4
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 11:05:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D75656146B
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 11:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D75656146B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3844C4B4F6;
	Fri, 23 Apr 2021 07:05:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P+Gi4vCFaNCY; Fri, 23 Apr 2021 07:05:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E65E4B380;
	Fri, 23 Apr 2021 07:05:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73E4E4B380
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 07:05:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mjvVxi7KT0Sc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Apr 2021 07:05:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 793104B30D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 07:05:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619175935;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6XHVicoTLSbHdWA8XFB+/kkN/O1wDN0Ij2er34FmuFw=;
 b=cuJdS2HvxhGX18baCGAOBtBUk5+UEt5wNpjaGe0GYGJi8ysPQSVbKJEb0pKMNHM3qEZTNH
 gIWBTBpE1Rg+ayaIJYBaiFsnyRH8MyedOCOR3B7xrQKeiLGYc+4Iisssxm00x/UMDIL0IN
 HDbsMXn+nyW+sk2lslsDRLyxI6x89G0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-FtAO3zCMPemDdl5ZwLRz_Q-1; Fri, 23 Apr 2021 07:05:33 -0400
X-MC-Unique: FtAO3zCMPemDdl5ZwLRz_Q-1
Received: by mail-wm1-f70.google.com with SMTP id
 y82-20020a1ce1550000b02901262158f1e9so521078wmg.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 04:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6XHVicoTLSbHdWA8XFB+/kkN/O1wDN0Ij2er34FmuFw=;
 b=f4hE2kL9ZC+VgzE8zj5OFWlFUKyphDeWgeld8UsDo3LyqGGL5HZ2fCAPM5ZC74CeRq
 0EOd4j2L7cRlPF8bo3qmWOtYnvLwVWF83dogCNc8rQmOpffsFHp2MChWqPy+HAl21Nmd
 R8KBKmgRNYbU+KSq5zwSAbef5HIb6na0y7icKl6dN54hzN+YEfLhq6EGuSXBQ5lOqo/m
 ZqQESm3fmpZv8cu4pVcFwnDmivcDGr39VRsHQhLYldpUWm/nF2yowArbdoN/S/rEKWy8
 K7Qa2dBxjvdPedHrfkpDHjcmtuhVL9vIJWmWbFK9IZxHh9C85TBBlmhyswv3FlBkaLT6
 02NQ==
X-Gm-Message-State: AOAM533WL9gIplmxlKy+H1Wg94i65udjdJhSfDph3Tjn1QHs6bA/AslS
 iTWPg/lOQgPvYPrExnkoJJX/MCMX7czGx83s/vLhXXnyrQRw+jtd9bIzj+Aibf7EDDLaw696yYR
 JnUCiAgn30sjHjyhmrVbqfq1L
X-Received: by 2002:adf:fbc8:: with SMTP id d8mr4047384wrs.94.1619175932455;
 Fri, 23 Apr 2021 04:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaM5Q2HLo8IcL7t4s/2HBHOYjkBuXbza4hD224Lf6gP3ljhm2fIkz6OihGk76gpoAQzPHP4Q==
X-Received: by 2002:adf:fbc8:: with SMTP id d8mr4047365wrs.94.1619175932257;
 Fri, 23 Apr 2021 04:05:32 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id y11sm8976445wro.37.2021.04.23.04.05.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Apr 2021 04:05:31 -0700 (PDT)
Date: Fri, 23 Apr 2021 13:05:29 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: selftests: Add exception handling support for
 aarch64
Message-ID: <20210423110529.vivemdwnznhblhyf@gator>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-2-ricarkol@google.com>
 <87sg3hnzrj.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87sg3hnzrj.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Apr 23, 2021 at 09:58:24AM +0100, Marc Zyngier wrote:
> Hi Ricardo,
> 
> Thanks for starting this.

Indeed! Thank you for contributing to AArch64 kvm selftests!

> > +void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
> > +			void (*handler)(struct ex_regs *));
> > +
> > +#define SPSR_D          (1 << 9)
> > +#define SPSR_SS         (1 << 21)
> > +
> > +#define write_sysreg(reg, val)						  \
> > +({									  \
> > +	asm volatile("msr "__stringify(reg)", %0" : : "r"(val));	  \
> > +})

Linux does fancy stuff with the Z constraint to allow xzr. We might as
well copy that.

> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > new file mode 100644
> > index 000000000000..c920679b87c0
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > @@ -0,0 +1,104 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +.macro save_registers, el
> > +	stp	x28, x29, [sp, #-16]!
> > +	stp	x26, x27, [sp, #-16]!
> > +	stp	x24, x25, [sp, #-16]!
> > +	stp	x22, x23, [sp, #-16]!
> > +	stp	x20, x21, [sp, #-16]!
> > +	stp	x18, x19, [sp, #-16]!
> > +	stp	x16, x17, [sp, #-16]!
> > +	stp	x14, x15, [sp, #-16]!
> > +	stp	x12, x13, [sp, #-16]!
> > +	stp	x10, x11, [sp, #-16]!
> > +	stp	x8, x9, [sp, #-16]!
> > +	stp	x6, x7, [sp, #-16]!
> > +	stp	x4, x5, [sp, #-16]!
> > +	stp	x2, x3, [sp, #-16]!
> > +	stp	x0, x1, [sp, #-16]!
> > +
> > +	.if \el == 0
> > +	mrs	x1, sp_el0
> > +	.else
> > +	mov	x1, sp
> > +	.endif
> 
> It there any point in saving SP_EL1, given that you already have
> altered it significantly and will not be restoring it? I don't care
> much, and maybe it is useful as debug information, but a comment would
> certainly make the intent clearer.

kvm-unit-tests takes some pains to save the original sp. We may be able to
take some inspiration from there for this save and restore.

> > +void kvm_exit_unexpected_vector(int vector, uint64_t ec)
> > +{
> > +	ucall(UCALL_UNHANDLED, 2, vector, ec);
> > +}
> > +
> > +#define HANDLERS_IDX(_vector, _ec)	((_vector * ESR_EC_NUM) + _ec)
> 
> This is definitely odd. Not all the ECs are valid for all vector entry
> points. Actually, ECs only make sense for synchronous exceptions, and
> asynchronous events (IRQ, FIQ, SError) cannot populate ESR_ELx.

For this, kvm-unit-tests provides a separate API for interrupt handler
installation, which ensures ec is not used. Also, kvm-unit-tests uses
a 2-D array [vector][ec] for the synchronous exceptions. I think we
should be able to use a 2-D array here too, instead of the IDX macro.

> > +void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
> > +			 void (*handler)(struct ex_regs *))
> 
> The name seems to be slightly ill defined. To me "handle exception" is
> the action of handling the exception. Here, you are merely installing
> an exception handler.
>

I agree. Please rename this for all of kvm selftests to something with
'install' in the name with the first patch of this series.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
