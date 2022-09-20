Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63BCC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 17:39:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C4E64B25E;
	Tue, 20 Sep 2022 13:39:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DomwL1jG8q0K; Tue, 20 Sep 2022 13:39:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D39384B600;
	Tue, 20 Sep 2022 13:39:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 310D14B278
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 13:39:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MHC8ChgxywGj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 13:39:24 -0400 (EDT)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8AF04B25E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 13:39:24 -0400 (EDT)
Received: by mail-pf1-f178.google.com with SMTP id d82so3401795pfd.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 10:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=rWpDMhOTDtTlNFqC0FU+bCgE4TlD7DZUXOVCdFqtqHk=;
 b=PRow5KNOVsY28eo7kfO2cOVUKtEv+lCi3ZX8z4TiJsOjv0FUD7vk+vFBT/KwldnYZy
 QmGUMLx7Xt3KMnzeVnUerCkCa95gY4yxR4LoFiIf59s12Ihj93YqO5G/CZOpYVyynfMP
 qXYS9+S/ZBUC1GOZuaKLSPqa4JBoihZzivyTOHcXWSv3+mLJSbUxFAgL7KrY5AbdXo6c
 EfibQ2SFVtyPHUpJMsRf0OciCrgJB8hQdHVzLm5Vzhq4Y3CzXVbNZi7CAiSpvmuKuZjg
 4CDECEq9ZZdgQ0MU2yXBcgT2hux5SfMddR0KpTmQQvJyKrLGVGVirjKII/EDtQp9MaHb
 8A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=rWpDMhOTDtTlNFqC0FU+bCgE4TlD7DZUXOVCdFqtqHk=;
 b=SX5xE3hPhn+qhlaeHhe+s2aBZLLQfGZ+KgSHc3JqhiClJialj7/QPzCXabrkVQVmZy
 blYefgPcncPn1YloIwsqP+aRbA+Qt5AdGrqEOjY9Z2niI67Gyip9aNHmIpvjhGu0XYAy
 OAaeXYqkhkvebtFiiWUqJVEwUV5su89S+6TrTfgBOTxzhmOWvmMo8fuksw2M1JIPr2ic
 dh804fSK5GQA+9DnthbQSgglxGZNhkJDxpsHzbn5QjM1Wh7RICR6mlDPxRoIzUB1rLFA
 PvDWbNBm8EFoqFgxcAa2AfA06ZFm9N/Hjap2bWCxoSS4+5KEb+63CETmcPY+mGTx5UjK
 UKIw==
X-Gm-Message-State: ACrzQf0lS9PG0X3FfW4eQr5dqZVFf8nUDjcR+xZrmQqjt75Mf8YqHuUN
 l1swsVm6NdHykRAJNGQSJ75J/w==
X-Google-Smtp-Source: AMsMyM7YVFBVZtE00/uCv5CjoaO8irYok0FfFUmpXpjxXcb/R8kRHl4P3avVo2jOETzZf3X8iEIb+Q==
X-Received: by 2002:a05:6a00:4c11:b0:53e:4f07:fce9 with SMTP id
 ea17-20020a056a004c1100b0053e4f07fce9mr25634942pfb.66.1663695563550; 
 Tue, 20 Sep 2022 10:39:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u5-20020a170902714500b00178957d17a4sm129916plm.286.2022.09.20.10.39.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Sep 2022 10:39:23 -0700 (PDT)
Date: Tue, 20 Sep 2022 17:39:19 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v7 07/13] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
Message-ID: <Yyn6x6Y8wlMgSrgZ@google.com>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220920042551.3154283-8-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 20, 2022, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests willing to

Preferred kernel style is to wrap changelogs at ~75 chars, e.g. so that `git show`
stays under 80 chars.

And in general, please incorporate checkpatch into your workflow, e.g. there's
also a spelling mistake below.

  WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
  #9: 
  anonymous 4K.  There are a couple of issues with that.  First, tests willing to

  WARNING: 'spreaded' may be misspelled - perhaps 'spread'?
  #12: 
  the hardcoded assumption of memslot #0 holding most things is spreaded
                                                              ^^^^^^^^

  total: 0 errors, 2 warnings, 94 lines checked

> differ a bit, like placing page-tables in a different backing source type must
> replicate much of what's already done by the vm_create() functions.  Second,
> the hardcoded assumption of memslot #0 holding most things is spreaded
> everywhere; this makes it very hard to change.

...

> @@ -105,6 +119,13 @@ struct kvm_vm {
>  struct userspace_mem_region *
>  memslot2region(struct kvm_vm *vm, uint32_t memslot);
>  
> +inline struct userspace_mem_region *

Should be static inline.

> +vm_get_mem_region

Please don't insert newlines before the function name, it makes searching painful.
Ignore existing patterns in KVM selfetsts, they're wrong.  ;-)  Linus has a nice
explanation/rant on this[*].

The resulting declaration will run long, but at least for me, I'll take that any
day over putting the function name on a new line.

[*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com


> (struct kvm_vm *vm, enum kvm_mem_region_type mrt)

One last nit, what about "region" or "type" instead of "mrt"?  The acronym made me
briefly pause to figure out what "mrt" meant, which is silly because the name really
doesn't have much meaning.

> +{
> +	assert(mrt < NR_MEM_REGIONS);
> +	return memslot2region(vm, vm->memslots[mrt]);
> +}

...

> @@ -293,8 +287,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
>  	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
>  						 nr_extra_pages);
>  	struct kvm_vm *vm;
> +	int i;
> +
> +	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
> +		 vm_guest_mode_string(mode), nr_pages);
> +
> +	vm = ____vm_create(mode);
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);

The spacing is weird here.  Adding the region and stuffing vm->memslots are what
should be bundled together, not creating the VM and adding the common region.  I.e.

	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
		 vm_guest_mode_string(mode), nr_pages);

	vm = ____vm_create(mode);

	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
	for (i = 0; i < NR_MEM_REGIONS; i++)
		vm->memslots[i] = 0;

>  
> -	vm = ____vm_create(mode, nr_pages);
> +	for (i = 0; i < NR_MEM_REGIONS; i++)
> +		vm->memslots[i] = 0;
>  
>  	kvm_vm_elf_load(vm, program_invocation_name);
>  
> -- 
> 2.37.3.968.ga6b4b080e4-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
