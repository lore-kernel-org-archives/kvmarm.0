Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C66C4708E
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 01:09:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F19D4B8B6;
	Wed,  7 Dec 2022 20:09:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n5n60QyHzvhB; Wed,  7 Dec 2022 20:09:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 420954B8B8;
	Wed,  7 Dec 2022 20:09:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EE334B8B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 20:09:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TsVWkKk7BHd9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 20:09:43 -0500 (EST)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C918F4B8B3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 20:09:43 -0500 (EST)
Received: by mail-pg1-f178.google.com with SMTP id r18so17887534pgr.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Dec 2022 17:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=OuNLZ5V9mVpEP4E+7RLKuznixDeM0jnYmtWKCm4H7jE=;
 b=ZmwNr2VgagPTT3ZBYNoVwBjEZ+hTBu0Xs8NkTDlHattLl2ckoAg6Ql90z04zJdiWGP
 g06encHnVXKE8BNITHXGgX4UmZWeULb/apUn8PsNsE/8UEqKPkZc8YIqBsIxxmjDAPyM
 lCMYtJQCn1yJVcpgShmuOsshEEzsFKR7HhskAtauN0f0OMxPZ12fr8bKOnY/5fT9cN7/
 5huxN5ZwBtHQaKkTTJomSL0IlWjakFxGe7DERsnT679YuoRtXFPYzUgY2O/VxaFufI/w
 QoCrHZIZ/FzvCIGtblDpTMibXKQ3eIW9vpRRmf0pSCn5xugcWVBXk1lb7Opq/Q5dzDzK
 goxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=OuNLZ5V9mVpEP4E+7RLKuznixDeM0jnYmtWKCm4H7jE=;
 b=sNckC6aPuEmmBkHDMOHRVR+rC0wwfp8djePPm+4EnA7VB5prr55EGjDK7Ca8jjVppO
 esWzfoTw1fWOdNEcTXZZ+OMJLShCuhBNr7Zx8JqW2H9sBrl+yN/WUSvj5PtA9LH5PE5a
 BGqvZVUycblQInbYsC0fqlOWLLSURiJ66E2q/8bBA2FhgH3wcoY0Ifj8KMZ3cC1J8AF8
 HU8cFnziUT4XpkjYLe4LeMnvKBfvEWMjORjxPSYi2AQPRReBsQ5j7T9/S4oqY3q/r3Uc
 HJQi0L896PwV1i48zcVIM16PHIZ6SlViK3RlDJtAzVzuEEtR946bptSZ7ovF77FYJAHW
 KmnQ==
X-Gm-Message-State: ANoB5pk2GB5x5Z6ATmXbwhPLDHVJmesLQ/5ERqy2AR80uSl3LFoLtgog
 wvFenzcrND3uW+5PC+F7NAu+Ww==
X-Google-Smtp-Source: AA0mqf4Ng4LFOxiTbN+0d0o0IEUnpmCXmBQG1PbgbdlbkeNM9WRrA3ezk3WauMc6Ej4KZu/Um/5gjA==
X-Received: by 2002:a62:b60d:0:b0:574:8995:c0d0 with SMTP id
 j13-20020a62b60d000000b005748995c0d0mr1470010pff.1.1670461782629; 
 Wed, 07 Dec 2022 17:09:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 i15-20020a63130f000000b00478eb777d18sm2083739pgl.72.2022.12.07.17.09.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Dec 2022 17:09:42 -0800 (PST)
Date: Thu, 8 Dec 2022 01:09:38 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 3/4] KVM: arm64: selftests: Align VA space allocator with
 TTBR0
Message-ID: <Y5E5UixcJQ4+tNYg@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-4-oliver.upton@linux.dev>
 <Y5EtP5z6rxSK1VUe@google.com> <Y5EvVtAoDSHvIKie@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5EvVtAoDSHvIKie@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Dec 08, 2022, Oliver Upton wrote:
> On Thu, Dec 08, 2022 at 12:18:07AM +0000, Sean Christopherson wrote:
> 
> [...]
> 
> > Together, what about?  The #ifdef is a bit gross, especially around "hi_start",
> > but it's less duplicate code.  And IMO, having things bundled in the same place
> > makes it a lot easier for newbies (to arm64 or kernel coding in general) to
> > understand what's going on and why arm64 is different.
> 
> I'd rather we not go this route. We really shouldn't make any attempt to
> de-dupe something that is inherently architecture specific.
> 
> For example:
> 
> > +	/*
> > +	 * All architectures supports splitting the virtual address space into
> > +	 * a high and a low half.  Populate both halves, except for arm64 which
> > +	 * currently uses only TTBR0_EL1 (arbitrary selftests "logic"), i.e.
> > +	 * only has a valid low half.
> > +	 */
> > +	sparsebit_num_t nr_va_bits = (1ULL << (vm->va_bits - 1)) >> vm->page_shift;
> 
> This is still wrong for arm64. When we say the VA space is 48 bits, we
> really do mean that TTBR0 is able to address a full 48 bits. So this
> truncates the MSB for the addressing mode.

Ah, I missed the lack of a "-1" in the arm64 code.

> With the code living in the arm64 side of the shop, I can also tailor
> the comment to directly match the architecture to provide breadcrumbs
> tying it back to the Arm ARM.

The main reason why I don't like splitting the code this way is that it makes it
harder for non-arm64 folks to understand what makes arm64 different.  Case in
point, my overlooking of the "-1".  I read the changelog and the comment and
still missed that small-but-important detail, largely because I am completely
unfamiliar with how TTBR{0,1}_EL1 works.

Actually, before we do anything, we should get confirmation from the s390 and
RISC-V folks on whether they have a canonical hole like x86, i.e. maybe x86 is
the oddball.

Anyways, assuming one architecture is the oddball (I'm betting it's x86), I have
no objection to bleeding some of the details into the common code, including a
large comment to document the gory details.  If every architecture manges to be
different, then yeah, a hook is probably warranted.

That said, I also don't mind shoving a bit of abstraction into arch code if that
avoids some #ifdef ugliness or allows for better documentation, flexibility, etc.
What I don't like is duplicating the logic of turning "VA bits" into the bitmap.

E.g. something like this would also be an option.  Readers would obviously need
to track down has_split_va_space, but that should be fairly easy and can come
with a big arch-specific comment, and meanwhile the core logic of how selftests
populate the va bitmaps is common.

Or if arm64 is the only arch without a split, invert the flag and have arm64 set
the vm->has_combined_va_space or whatever.

static void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
{
	unsigned int eff_va_bits = vm->va_bits;
	sparsebit_num_t nr_bits;

	/* blah blah blah */
	if (vm->has_split_va_space)
		eff_va_bits--;

	nr_bits = (1ULL << eff_va_bits) >> vm->page_shift;

	sparsebit_set_num(vm->vpages_valid, 0, nr_va_bits);

	if (vm->has_split_va_space)
		sparsebit_set_num(vm->vpages_valid,
			  	  (~((1ULL << eff_va_bits) - 1)) >> vm->page_shift,
				  nr_bits);
}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
