Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE658C63705
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 00:24:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3499B4B899;
	Wed,  7 Dec 2022 19:24:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qZ-dJE-Ak9h5; Wed,  7 Dec 2022 19:24:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 177ED4B871;
	Wed,  7 Dec 2022 19:24:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C11514B871
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 19:24:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QRVC2hSZpwOG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 19:24:26 -0500 (EST)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9894D4B82A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 19:24:26 -0500 (EST)
Received: by mail-pg1-f175.google.com with SMTP id 62so17827325pgb.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Dec 2022 16:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=o1LoWn6zliZfcLJl1xuWVNoDZaXFFBpTOc3PLSqk9PKcpYBdz/9yS43pJHF+SKPQIB
 X5jKWKwlv2hPPkNzSnbACWHw3M0/NgKTzCac010Jx0aG1GDthbrtxNARGSo/+K/XBRIa
 FK6sAZZfHb63JgxjeFHjAwlxF7jZtiL1uhMN8LlhQ4clFCgwPPtct2cqh6CS+ZphME8Q
 PuYGd7xSTRuY7aQvhg4WbSGZ7iqhDEe5nsZ1kGB5j0o0prpZdcdd7kc7Nh1IH2GnGUyF
 DbnmS/QFtIzVVxd38/lt/NRR8/WWkZG818g/KZ7OEji+5i8fyZdcz5UWCRm0Q2+UxH+k
 Hkkg==
X-Gm-Message-State: ANoB5pmH1JdaZRttLHKgZy+7kxjf+QDT8htwrbQCbGJAn+LGUqzsqTJR
 RVOChFdqblMJNQugMXcO2ygO7A==
X-Google-Smtp-Source: AA0mqf5GIpkTgjhaAESUaXxx4LDksAwYJbd8iER/VptpemJ1xMaolNudI2qegnnhYn7rxj/a6LvllA==
X-Received: by 2002:a62:b60d:0:b0:574:8995:c0d0 with SMTP id
 j13-20020a62b60d000000b005748995c0d0mr1460040pff.1.1670459064104; 
 Wed, 07 Dec 2022 16:24:24 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 k85-20020a628458000000b0057725613627sm4955021pfd.142.2022.12.07.16.24.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Dec 2022 16:24:23 -0800 (PST)
Date: Thu, 8 Dec 2022 00:24:20 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5EutGSjkRmdItQb@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
 <Y5EoZ5uwrTF3eSKw@google.com> <Y5EtMWuTaJk9I3Bd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5EtMWuTaJk9I3Bd@google.com>
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
