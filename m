Return-Path: <SRS0=roT/=JX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD66C43470
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 18:58:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0542661158
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 18:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0542661158
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58BCD4B0A1;
	Mon, 26 Apr 2021 14:58:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ope1mHpTdzJa; Mon, 26 Apr 2021 14:58:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F2FE4B09F;
	Mon, 26 Apr 2021 14:58:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9B064B09C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 14:58:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1SOJhx0Z0+ak for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Apr 2021 14:58:18 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB0B14B09E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 14:58:18 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id t13so3475708pji.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 11:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uC+i8U1DYABk51F37rCJ7P5O8poPwp+NFIjw6zwOZ2c=;
 b=JuEq54M6xQSipjxCXHUzSdfRcWh9h82ZnxXPcs1RdmvsErPGrx/baNC5nRFhGtngOg
 FvsgO6fKXabxy+m8YcV/rs3+nZSQ20A8nGpz1LbV6yV1kd5Gp5zMBe0gSbG9MGcKGllD
 JfS9Iiq4qge9puIMFqQjPil0/tHPkO2Hmaa3ZiMIUbMtJVBQnVRkmzbgxt+CMQT7wJf4
 pVV+AZJisKhOSQO/c7ww0eW58tSbBefK5ZbwNFV5HhQeRt/TcqKhIxmEgULqk5pu+MR1
 t8mjCt5JTtETEAi+0P7/S6OkdnD68BiSLSqoE5TdK9JSvldCfEoyKakYOspAAL6MFXLc
 XwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uC+i8U1DYABk51F37rCJ7P5O8poPwp+NFIjw6zwOZ2c=;
 b=ShmCTns+dsmI6p3ETNQ6oFeeMU1MOkQRnkBeQnl7oITj9zE+YtBQXgzhl9K2A8sfZH
 X21sUZkYt5Hak5XPeoHiup7TE4q3nvtSdc3m47ik326e9pYbymacySC/0sIb2NLslgi9
 jfkl2ury9yZyTX+V1eKg3o4bjl7LSSYFCpwI4+QgZcIe0ucqCyQ8vA3SEiPVjSq8Al3L
 76b4hjp4co0AQD3dl7BDFy4HffNvVT0DTjPPreUuKKSqqghB0VZPWUcDWbr7onLOhceE
 hCcq4LY3zvALUJj5xQVCihvwT2W4vlOELlopznN2Ad/61eOcJeNJ9QbhNFdfsVzrf7Bd
 JJ9Q==
X-Gm-Message-State: AOAM531ZNxBEoZZiGBsQnZAI9Q4eZlnaU1DL0iR47wAnN9tOjNC6r88N
 mVNwvfXicn0Aq00VuDAqGnECfw==
X-Google-Smtp-Source: ABdhPJzkTREXtqHoctqGihHBPcFzt++MKZsCQrvBXi+RVM7t3GxfmtsMvVVOlyhAizvomEe1Q1jWcg==
X-Received: by 2002:a17:90a:df8d:: with SMTP id
 p13mr601788pjv.38.1619463497585; 
 Mon, 26 Apr 2021 11:58:17 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id b1sm13179440pgf.84.2021.04.26.11.58.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Apr 2021 11:58:16 -0700 (PDT)
Date: Mon, 26 Apr 2021 11:58:13 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/3] KVM: selftests: Add exception handling support for
 aarch64
Message-ID: <YIcNRVEF7RXjqHuY@google.com>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-2-ricarkol@google.com>
 <87sg3hnzrj.wl-maz@kernel.org>
 <20210423110529.vivemdwnznhblhyf@gator>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210423110529.vivemdwnznhblhyf@gator>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Apr 23, 2021 at 01:05:29PM +0200, Andrew Jones wrote:
> On Fri, Apr 23, 2021 at 09:58:24AM +0100, Marc Zyngier wrote:
> > Hi Ricardo,
> > 
> > Thanks for starting this.
> 
> Indeed! Thank you for contributing to AArch64 kvm selftests!
> 
> > > +void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
> > > +			void (*handler)(struct ex_regs *));
> > > +
> > > +#define SPSR_D          (1 << 9)
> > > +#define SPSR_SS         (1 << 21)
> > > +
> > > +#define write_sysreg(reg, val)						  \
> > > +({									  \
> > > +	asm volatile("msr "__stringify(reg)", %0" : : "r"(val));	  \
> > > +})
> 
> Linux does fancy stuff with the Z constraint to allow xzr. We might as
> well copy that.
> 
> > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > > new file mode 100644
> > > index 000000000000..c920679b87c0
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > > @@ -0,0 +1,104 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +.macro save_registers, el
> > > +	stp	x28, x29, [sp, #-16]!
> > > +	stp	x26, x27, [sp, #-16]!
> > > +	stp	x24, x25, [sp, #-16]!
> > > +	stp	x22, x23, [sp, #-16]!
> > > +	stp	x20, x21, [sp, #-16]!
> > > +	stp	x18, x19, [sp, #-16]!
> > > +	stp	x16, x17, [sp, #-16]!
> > > +	stp	x14, x15, [sp, #-16]!
> > > +	stp	x12, x13, [sp, #-16]!
> > > +	stp	x10, x11, [sp, #-16]!
> > > +	stp	x8, x9, [sp, #-16]!
> > > +	stp	x6, x7, [sp, #-16]!
> > > +	stp	x4, x5, [sp, #-16]!
> > > +	stp	x2, x3, [sp, #-16]!
> > > +	stp	x0, x1, [sp, #-16]!
> > > +
> > > +	.if \el == 0
> > > +	mrs	x1, sp_el0
> > > +	.else
> > > +	mov	x1, sp
> > > +	.endif
> > 
> > It there any point in saving SP_EL1, given that you already have
> > altered it significantly and will not be restoring it? I don't care
> > much, and maybe it is useful as debug information, but a comment would
> > certainly make the intent clearer.
> 
> kvm-unit-tests takes some pains to save the original sp. We may be able to
> take some inspiration from there for this save and restore.
> 
> > > +void kvm_exit_unexpected_vector(int vector, uint64_t ec)
> > > +{
> > > +	ucall(UCALL_UNHANDLED, 2, vector, ec);
> > > +}
> > > +
> > > +#define HANDLERS_IDX(_vector, _ec)	((_vector * ESR_EC_NUM) + _ec)
> > 
> > This is definitely odd. Not all the ECs are valid for all vector entry
> > points. Actually, ECs only make sense for synchronous exceptions, and
> > asynchronous events (IRQ, FIQ, SError) cannot populate ESR_ELx.
> 
> For this, kvm-unit-tests provides a separate API for interrupt handler
> installation, which ensures ec is not used. Also, kvm-unit-tests uses
> a 2-D array [vector][ec] for the synchronous exceptions. I think we
> should be able to use a 2-D array here too, instead of the IDX macro.
> 
> > > +void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
> > > +			 void (*handler)(struct ex_regs *))
> > 
> > The name seems to be slightly ill defined. To me "handle exception" is
> > the action of handling the exception. Here, you are merely installing
> > an exception handler.
> >
> 
> I agree. Please rename this for all of kvm selftests to something with
> 'install' in the name with the first patch of this series.
> 
> Thanks,
> drew
> 

Thank you Andrew and Marc for the reviews. Will send v2 with all the
feedback.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
