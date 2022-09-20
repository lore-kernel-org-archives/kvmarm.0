Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CA8C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 17:49:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48B774B640;
	Tue, 20 Sep 2022 13:49:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M1sE6FiwKwSn; Tue, 20 Sep 2022 13:49:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 286634B62A;
	Tue, 20 Sep 2022 13:49:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B36E64B25E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 13:49:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FGQho9Bn7Pk8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 13:49:44 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F19740DAE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 13:49:44 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id fv3so3923292pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 10:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=a2oYsLQ3PVWHBh7aJPcuMHK0Eov6Y7MY3uJqzL8zsI0=;
 b=DfDVeMnWujZV+9FFOGgmWOKii3IfaaLDv7GDK1T6JqVPGewlcolYuGYSA9r9P6FyYW
 DRN/YLG/z/OvwAwvtuS+5R4HufEmGGgIEy7tRyafgCZiRqGIuByRFRS7uvIi3v05BPSM
 YvR+y264eP+9AKSGOFnmCG4IYsMdEK/umaSMij4xuJKdqCL7VTEvdg5tnMMNEH/usxBF
 bUAtjGd+S2ujjr/NHPRKXQyhc+BSi/Ljb1+BhmVLAJnySXmRyq7+Se+DPepri72Hu53p
 9i84x2JY2Dvc+DJkiJuGzoNr+/PDGZwyX/shalJxVrep6XBp7j7fqFsI8vZWV9sCIrL+
 +b+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=a2oYsLQ3PVWHBh7aJPcuMHK0Eov6Y7MY3uJqzL8zsI0=;
 b=32GZwiQZrNm1Lc2pkoA0dNx6y5OFT8gvnpqPYS4qr8yIU1ASfdKkLfHPsytv3x14+6
 h1fF1EeoWBOMQkyWopEPZIxyofW0hmZx3qbZoSpuSMEs5UD9hOXPZGqVeN1RooIM+Bq6
 tZzXt9X+ys4OBkpkYyiYFH8fUpou+bhSmzV7fimW1pGa2LDWNauMq+BAVmO/pnUIqyZZ
 Ye19RLGkf/1Ncz/m8xED+IwvKBt/rJTRGA6RU4dlepFW8vRh6dzzql50haEPtLlVDyOk
 LtKG3trmMrrYL49pnsEfZ+YryStw3OsMa8o9fvToGKNECV+VNhkRz02IR2j3rxKWbGFj
 FXYg==
X-Gm-Message-State: ACrzQf2yJhrEcNyj2C+ib2yMpq8qE9B9AgTaM0ElVwSaaJTMm/WbUOEQ
 ToLdo6K4JB/TC76qQUsB3U5CHQ==
X-Google-Smtp-Source: AMsMyM4OMIqPdmgjX4n9vxLmpMRKJZmYnaVXN+rH/Ma3Oj4UcUc4AdAUZuNnrasjaczhxUEXXMVx3w==
X-Received: by 2002:a17:902:c189:b0:176:b871:8a1 with SMTP id
 d9-20020a170902c18900b00176b87108a1mr799560pld.30.1663696183470; 
 Tue, 20 Sep 2022 10:49:43 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 z16-20020aa79e50000000b00537d7cc774bsm164533pfq.139.2022.09.20.10.49.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Sep 2022 10:49:42 -0700 (PDT)
Date: Tue, 20 Sep 2022 10:49:38 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 07/13] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
Message-ID: <Yyn9Mny/EJS3ffQ8@google.com>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-8-ricarkol@google.com>
 <Yyn6x6Y8wlMgSrgZ@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yyn6x6Y8wlMgSrgZ@google.com>
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

On Tue, Sep 20, 2022 at 05:39:19PM +0000, Sean Christopherson wrote:
> On Tue, Sep 20, 2022, Ricardo Koller wrote:
> > The vm_create() helpers are hardcoded to place most page types (code,
> > page-tables, stacks, etc) in the same memslot #0, and always backed with
> > anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> 
> Preferred kernel style is to wrap changelogs at ~75 chars, e.g. so that `git show`
> stays under 80 chars.
> 
> And in general, please incorporate checkpatch into your workflow, e.g. there's
> also a spelling mistake below.
> 
>   WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
>   #9: 
>   anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> 
>   WARNING: 'spreaded' may be misspelled - perhaps 'spread'?
>   #12: 
>   the hardcoded assumption of memslot #0 holding most things is spreaded
>                                                               ^^^^^^^^
> 
>   total: 0 errors, 2 warnings, 94 lines checked
> 
> > differ a bit, like placing page-tables in a different backing source type must
> > replicate much of what's already done by the vm_create() functions.  Second,
> > the hardcoded assumption of memslot #0 holding most things is spreaded
> > everywhere; this makes it very hard to change.
> 
> ...
> 
> > @@ -105,6 +119,13 @@ struct kvm_vm {
> >  struct userspace_mem_region *
> >  memslot2region(struct kvm_vm *vm, uint32_t memslot);
> >  
> > +inline struct userspace_mem_region *
> 
> Should be static inline.
> 
> > +vm_get_mem_region
> 
> Please don't insert newlines before the function name, it makes searching painful.
> Ignore existing patterns in KVM selfetsts, they're wrong.  ;-)  Linus has a nice
> explanation/rant on this[*].
> 
> The resulting declaration will run long, but at least for me, I'll take that any
> day over putting the function name on a new line.
> 
> [*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com
> 
> 
> > (struct kvm_vm *vm, enum kvm_mem_region_type mrt)
> 
> One last nit, what about "region" or "type" instead of "mrt"?  The acronym made me
> briefly pause to figure out what "mrt" meant, which is silly because the name really
> doesn't have much meaning.
> 
> > +{
> > +	assert(mrt < NR_MEM_REGIONS);
> > +	return memslot2region(vm, vm->memslots[mrt]);
> > +}
> 
> ...
> 
> > @@ -293,8 +287,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
> >  	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
> >  						 nr_extra_pages);
> >  	struct kvm_vm *vm;
> > +	int i;
> > +
> > +	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
> > +		 vm_guest_mode_string(mode), nr_pages);
> > +
> > +	vm = ____vm_create(mode);
> > +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
> 
> The spacing is weird here.  Adding the region and stuffing vm->memslots are what
> should be bundled together, not creating the VM and adding the common region.  I.e.
> 
> 	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
> 		 vm_guest_mode_string(mode), nr_pages);
> 
> 	vm = ____vm_create(mode);
> 
> 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
> 	for (i = 0; i < NR_MEM_REGIONS; i++)
> 		vm->memslots[i] = 0;
> 
> >  
> > -	vm = ____vm_create(mode, nr_pages);
> > +	for (i = 0; i < NR_MEM_REGIONS; i++)
> > +		vm->memslots[i] = 0;
> >  
> >  	kvm_vm_elf_load(vm, program_invocation_name);
> >  
> > -- 
> > 2.37.3.968.ga6b4b080e4-goog
> > 

Ack on all the above. Will send a v8 later today.

Thanks!
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
