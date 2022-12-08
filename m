Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8DB7E
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 00:24:26 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id f9so17833995pgf.7
        for <kvmarm@lists.linux.dev>; Wed, 07 Dec 2022 16:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5SF1vNKH61lFm3hfk5Bb+AduHkT/A0rKp5e/levYr44=;
        b=TxrIijlKNemLsvVUWhbEvHLRzcC6kGYva9u4pTpNLVjZOSDgHPUtrPJcvdl7yu9EW3
         gH0qAWTdI3PrrFOB2fKIFdUG4mm4d6rkIq/vrYaNyzOXXDSEnxnvi/pJaMS8u1deGkJD
         WnRUdOlmYdyFTSL9vEtdQSxevxVF+84aksPKWAT5+6Qg8xEn1zXneEe4PIIvU+fSqBWp
         rY2tugHj6Ftr8kAdI8/DEtGI59QMeqVjXtRQiJ8Q6a0WmVT3LbrXE1J+FzmeHSUeLAaj
         U1cZMf+fl9S0zPGeUYpOWdGWOwfey9jODY5T0UklNZnZj7+8fqXXltoTbKVw3qPZaYLv
         KoTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5SF1vNKH61lFm3hfk5Bb+AduHkT/A0rKp5e/levYr44=;
        b=VGgRai/T82BenCmRQWjNgQem7pT4fcrajIBjFy6wV2dldhruegdKZ0mzgbzuOjRTQr
         KTn8rs+XHPCLJWMy7QPRWVMxYTZkeAnPys2Y1o6aeaDt4JCvR/hpoag0ncXYTHT10OUf
         NJHkg8GyRq9cibPd9xb8v3rHHMUJsb3evQdZU8IJf3V5kepDoMrHR0onPTrEdBXG2Otg
         jRiITTWU+k0GFJ4cqh9HPrnDGcsu61e7kJDpOW1AEtaYAsRDzGNLlNvUZOo4jOap6IBr
         C1dz3yn5ILcoLfX9hnSAeUrtJb6JiF2h34Pcc7doRJ3uxwXiXlwHENuT4Rt6PyuaeV7S
         IY/w==
X-Gm-Message-State: ANoB5pnmcSKnIg79xTm9YtU5qCT/LkNstErNMwx7wkF9bvxvqj90Ivw+
	Az1nVSU1XSZlkPviYwuQxzQ1NQ==
X-Google-Smtp-Source: AA0mqf5GIpkTgjhaAESUaXxx4LDksAwYJbd8iER/VptpemJ1xMaolNudI2qegnnhYn7rxj/a6LvllA==
X-Received: by 2002:a62:b60d:0:b0:574:8995:c0d0 with SMTP id j13-20020a62b60d000000b005748995c0d0mr1460040pff.1.1670459064104;
        Wed, 07 Dec 2022 16:24:24 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k85-20020a628458000000b0057725613627sm4955021pfd.142.2022.12.07.16.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 16:24:23 -0800 (PST)
Date: Thu, 8 Dec 2022 00:24:20 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5EutGSjkRmdItQb@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
 <Y5EoZ5uwrTF3eSKw@google.com>
 <Y5EtMWuTaJk9I3Bd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5EtMWuTaJk9I3Bd@google.com>
Message-ID: <20221208002420.Pt3PVRWULV_XiPrSQUpLBazmbeTQahNHMb5NZwBFhs0@z>

On Thu, Dec 08, 2022, Oliver Upton wrote:
> On Wed, Dec 07, 2022 at 11:57:27PM +0000, Sean Christopherson wrote:
> > > diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > > index 92d3a91153b6..95d22cfb7b41 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > > @@ -609,8 +609,13 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
> > >  				    data_size / guest_page_size,
> > >  				    p->test_desc->data_memslot_flags);
> > >  	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
> > > +}
> > > +
> > > +static void setup_ucall(struct kvm_vm *vm)
> > > +{
> > > +	struct userspace_mem_region *region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
> > >  
> > > -	ucall_init(vm, data_gpa + data_size);
> > > +	ucall_init(vm, region->region.guest_phys_addr + region->region.memory_size);
> > 
> > Isn't there a hole after CODE_AND_DATA_MEMSLOT?  I.e. after memslot 0?
> 
> Sure, but that's only guaranteed in the PA space.
> 
> > The reason
> > I ask is because if so, then we can do the temporarily heinous, but hopefully forward
> > looking thing of adding a helper to wrap kvm_vm_elf_load() + ucall_init().
> > 
> > E.g. I think we can do this immediately, and then at some point in the 6.2 cycle
> > add a dedicated region+memslot for the ucall MMIO page.
> 
> Even still, that's just a kludge to make ucalls work. We have other
> MMIO devices (GIC distributor, for example) that work by chance since
> nothing conflicts with the constant GPAs we've selected in the tests.
> 
> I'd rather we go down the route of having an address allocator for the
> for both the VA and PA spaces to provide carveouts at runtime.

Aren't those two separate issues?  The PA, a.k.a. memslots space, can be solved
by allocating a dedicated memslot, i.e. doesn't need a carve.  At worst, collisions
will yield very explicit asserts, which IMO is better than whatever might go wrong
with a carve out.

> There's another issue with the new ucall implementation where identity
> mapping could stomp on a program segment that I'm fighting with right now
> which only further highlights the problems with our (mis)management of
> address spaces in selftests.

Oooh, this crud:

 	virt_pg_map(vm, mmio_gpa, mmio_gpa);

Yeah, that needs to be fixed.  But again, that's a separate issue, e.g. selftests
can allocate a virtual address and map the read-only memslot.
