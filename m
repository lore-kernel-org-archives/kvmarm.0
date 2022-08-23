Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B952CC32796
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:38:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18DB24C5C5;
	Tue, 23 Aug 2022 19:38:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TaVsV1ZylOZ0; Tue, 23 Aug 2022 19:38:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D35444C5A9;
	Tue, 23 Aug 2022 19:38:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C43D4C5A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:38:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7sjb2LbzE+nx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:37:59 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3D804C5A8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:37:59 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id
 s3-20020a17090a2f0300b001facfc6fdbcso15556782pjd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=IaZ4H3tMkMrOvE5Cs902sGYZoIVCWhohAIktvLaNyXo=;
 b=iRiolzYbbyCama5Mgm7/cxmWWehq0CPsDYqHF+QXaUgJhsjIPZT7vp9PzHV1ivY/JC
 uP8VjwHsXwE+aYPYP91/h8/UwnVz28L3bWrC4F7PHQSlmkkQ5nlfsqkJhrGjPyNTLLkr
 V5Ir2PPSZ0jL6SBPHYAQyicQyKk05cuSoOvcrPNyvc8mM8xDwDLu9KFDj9r5sQ1h7pRI
 f0hXzf8qA0Jk4A+qrHl8LRKkBwWPce8Gge90xuTSY17965Xi31/m4pvCWy4Q0MY7zKZw
 BVLB4imHbmRcvB+AEP+QyIkqN0onjSPXiUzOR8gUWcAmj4DF5NvinzMwx1KADdyEYUkz
 H4MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=IaZ4H3tMkMrOvE5Cs902sGYZoIVCWhohAIktvLaNyXo=;
 b=LjqkPJOC1EsPWIa/KXGn+te4FiEcR+fykBYozGsALXaCRMsp4NjlEj/VDSmfH7L24n
 8q17ISCR7STzJXMDm8Iil80yjdmLxNwtGsSwcHQN+P4orHYSi83t9btj7MMhUF5tA+ko
 rdqU3jgC1DgnoaP6Knetu250gkE6vTEd3KBHi707HBf/PnBUC1kAHoPv80WLiajbFCIO
 nNqvqMJcfpHuR3vEdHkLAEclRlnkNPw8hMF0AUrEU0GijR3B5tI5UWuxVpSuf8FOd1ad
 +Tk+8ZHmvqoHRAw+c+DKzHJjVDsfRsD0ALpV5PiCKgLxVdCrfLv2j1jnIfQEbFAEktYm
 FSHw==
X-Gm-Message-State: ACgBeo0p+CbhVKOfWNika2r6P4vWAsTvt7RD/8ociEDvMsH1iqgEaJFo
 BGmo/Bov4ALj7K9HS0uZaB49tQ==
X-Google-Smtp-Source: AA6agR5dtwFt87kPaOsLnvwsR27B8RnElI2bmBpqeYbCUDJ5aoQeIUf33cxZIJ+bDePMRUT00Yfmew==
X-Received: by 2002:a17:903:120d:b0:171:4fa0:7b4a with SMTP id
 l13-20020a170903120d00b001714fa07b4amr26013097plh.45.1661297878488; 
 Tue, 23 Aug 2022 16:37:58 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 j7-20020a170903024700b00172ea8ff334sm5219402plh.7.2022.08.23.16.37.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Aug 2022 16:37:57 -0700 (PDT)
Date: Tue, 23 Aug 2022 16:37:53 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YwVk0a/FTfYS1nNf@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
 <Ytir/hbU9neBaYqb@google.com> <YtrcCeHqBcwy+Mf6@google.com>
 <YtrqVwSK42KbKckf@google.com>
 <20220723082201.ifme5dipygt5r2wx@kamzik>
 <YuAvQ0C8ZprtJ4US@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YuAvQ0C8ZprtJ4US@google.com>
Cc: drjones@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 Andrew Jones <andrew.jones@linux.dev>, axelrasmussen@google.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
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

On Tue, Jul 26, 2022 at 06:15:31PM +0000, Sean Christopherson wrote:
> On Sat, Jul 23, 2022, Andrew Jones wrote:
> > On Fri, Jul 22, 2022 at 06:20:07PM +0000, Sean Christopherson wrote:
> > > On Fri, Jul 22, 2022, Ricardo Koller wrote:
> > > > What about dividing the changes in two.
> > > > 
> > > > 	1. Will add the struct to "__vm_create()" as part of this
> > > > 	series, and then use it in this commit. There's only one user
> > > > 
> > > > 		dirty_log_test.c:   vm = __vm_create(mode, 1, extra_mem_pages);
> > > > 
> > > > 	so that would avoid having to touch every test as part of this patchset.
> > > > 
> > > > 	2. I can then send another series to add support for all the other
> > > > 	vm_create() functions.
> > > > 
> > > > Alternatively, I can send a new series that does 1 and 2 afterwards.
> > > > WDYT?
> > > 
> > > Don't do #2, ever. :-)  The intent of having vm_create() versus is __vm_create()
> > > is so that tests that don't care about things like backing pages don't have to
> > > pass in extra params.  I very much want to keep that behavior, i.e. I don't want
> > > to extend vm_create() at all.  IMO, adding _anything_ is a slippery slope, e.g.
> > > why are the backing types special enough to get a param, but thing XYZ isn't?
> > > 
> > > Thinking more, the struct idea probably isn't going to work all that well.  It
> > > again puts the selftests into a state where it becomes difficult to control one
> > > setting and ignore the rest, e.g. the dirty_log_test and anything else with extra
> > > pages suddenly has to care about the backing type for page tables and code.
> > > 
> > > Rather than adding a struct, what about extending the @mode param?  We already
> > > have vm_mem_backing_src_type, we just need a way to splice things together.  There
> > > are a total of four things we can control: primary mode, and then code, data, and
> > > page tables backing types.
> > > 
> > > So, turn @mode into a uint32_t and carve out 8 bits for each of those four "modes".
> > > The defaults Just Work because VM_MEM_SRC_ANONYMOUS==0.
> > 
> > Hi Sean,
> > 
> > How about merging both proposals and turn @mode into a struct and pass
> > around a pointer to it? Then, when calling something that requires @mode,
> > if @mode is NULL, the called function would use vm_arch_default_mode()
> > to get a pointer to the arch-specific default mode struct.
> 
> One tweak: rather that use @NULL as a magic param, #define VM_MODE_DEFAULT to
> point at a global struct, similar to what is already done for __aarch64__.
> 
> E.g.
> 
> 	__vm_create(VM_MODE_DEFAULT, nr_runnable_vcpus, 0);
> 
> does a much better job of self-documenting its behavior than this:
> 
> 	__vm_create(NULL, nr_runnable_vcpus, 0);
> 
> > If a test needs to modify the parameters then it can construct a mode struct
> > from scratch or start with a copy of the default. As long as all members of
> > the struct representing parameters, such as backing type, have defaults
> > mapped to zero for the struct members, then we shouldn't be adding any burden
> > to users that don't care about other parameters (other than ensuring their
> > @mode struct was zero initialized).
> 
> I was hoping to avoid forcing tests to build a struct, but looking at all the
> existing users, they either use for_each_guest_mode() or just pass VM_MODE_DEFAULT,
> so in practice it's a complete non-issue.
> 
> The page fault usage will likely be similar, e.g. programatically generate the set
> of combinations to test.
> 
> So yeah, let's try the struct approach.

Thank you both for the suggestions.

About to send v5 with the suggested changes, with a slight modification.
V5 adds "struct kvm_vm_mem_params" which includes a "guest mode" field.
The suggestion was to overload "guest mode". What I have doesn't change
the meaning of "guest mode", and just keeps everything dealing with
"guest mode" the same (like guest_mode.c).

The main changes are:

1. adding a struct kvm_vm_mem_params that defines the memory layout:

	-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
	+struct kvm_vm *____vm_create(struct kvm_vm_mem_params *mem_params);

2. adding memslot vm->memslot.[code|pt|data] and change all allocators
to use the right memslot, e.g.,: lib/elf should use the code memslot.

3. change the new page_fault_test.c setup_memslot() accordingly (much
nicer).

Let me know what you think.

Thanks!
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
