Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59339372
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 01:09:43 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id s196so17939223pgs.3
        for <kvmarm@lists.linux.dev>; Wed, 07 Dec 2022 17:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=AsSEH06HdemRSY1fB+U3YpU93mTIvIxg0QEs5XrfK8dqxKEQ9q1nE6UDnXvT+ghQVQ
         2LlOJ4Q8mA8F+CqRNT+HXlR/pDqqTGuHTbUze4UkJlB+PRXwmegWpm4g3SVztTr2q+Dn
         DCUGK8/ccOdHi/Eaqvv8ENXi5We92oV6o+wUyLGzqc6b1ECvxNMAHt/BjJOYp60Wy+UC
         P7xfC/ZUlRYwP45xIEv2ilchosxazX8EppBsSgeUDz9nVjzaR9yRIMWv3vE3jhv9C0v5
         gWpR0cjOOLCM7LG3QI8qUEA6Somz4yj2XXfVPKpUypsYiekbrVtAxtJHvaO11jXLS1Y7
         yh2A==
X-Gm-Message-State: ANoB5pk9f8cS6IfL9zlTrplwHkuhWUs8bH5gh5JBmF0DRxJS1ITG28Jr
	6xe/1Fppd/u6VJGDT3S6JKlPOg==
X-Google-Smtp-Source: AA0mqf4Ng4LFOxiTbN+0d0o0IEUnpmCXmBQG1PbgbdlbkeNM9WRrA3ezk3WauMc6Ej4KZu/Um/5gjA==
X-Received: by 2002:a62:b60d:0:b0:574:8995:c0d0 with SMTP id j13-20020a62b60d000000b005748995c0d0mr1470010pff.1.1670461782629;
        Wed, 07 Dec 2022 17:09:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i15-20020a63130f000000b00478eb777d18sm2083739pgl.72.2022.12.07.17.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 17:09:42 -0800 (PST)
Date: Thu, 8 Dec 2022 01:09:38 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: arm64: selftests: Align VA space allocator with
 TTBR0
Message-ID: <Y5E5UixcJQ4+tNYg@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-4-oliver.upton@linux.dev>
 <Y5EtP5z6rxSK1VUe@google.com>
 <Y5EvVtAoDSHvIKie@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5EvVtAoDSHvIKie@google.com>
Message-ID: <20221208010938.RccudYlEHVElw8sktBlyrSEcdulXZ9ZkhBY6_lKfqbM@z>

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
