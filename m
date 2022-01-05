Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CB9C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 19:41:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C845840D02;
	Wed,  5 Jan 2022 14:41:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id flQIF0IyTsEd; Wed,  5 Jan 2022 14:41:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F91440D23;
	Wed,  5 Jan 2022 14:41:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC25540CF5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 14:41:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g2rEN6ryHMUs for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 14:41:02 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCB0740BE6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 14:41:02 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id x194so120259pgx.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 11:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=pZ7Du5aXJypbN5z9JdXaN/bv6j/5WCgbjcAZoOJVTUo=;
 b=fZrlfDN2fNtW20qRO8Z9+o9nA5CFDsiKwl72mrfDZ538L6+n+8tdbpiIIOCAAtuJ/U
 kR3kRLZLgvWRszCANN33MnEha5UmcBTrH9HOq653dfDwYe1JNqJKRrbdk9mmWBs3h86k
 qjo99ocaP1PvNTkh+DsMkxm0dEAh9KCtGCIglmzsyd6gTDNp8Hsp0fZi022Tu+XIZ8IC
 o79KS8q79BBdJpu2S8Rk7bRM4T+a2Csi/Ew7MqGaW/3MpIp+WIiFc0dwtT0Mw0762+jB
 J0aW7melAxcapbZXU1N44tXkKhjlm7jCSBWqDErSFgRrhQfQxFBXYId40kXyaBklusJQ
 xlCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pZ7Du5aXJypbN5z9JdXaN/bv6j/5WCgbjcAZoOJVTUo=;
 b=ld74j8HjscK7GznoRZ+zT3BVjGTF4CH3oF+l9zBN8UxRtD24I8dUrwxEV0zcHGGGqR
 5kcEpOJSMkeuCiK29/WwFDn58yNSoo1WB1VrMGHn+quBYzHn+Ckcqwy9vtKwWlKc8wzN
 rX051/nHhW1pcTi9g4KaKpC87qTK3LqeFU3EGrtcuoG5UZkPXGXokjjWYzdhTbOlbxUw
 bnFdPaM5uOKJHPuQE9k0lyvaBZwYyY8LaxbhTLibkgq6X9MErnz5B2aFWJZfk5RCfpOK
 00pCHwydF5LD1n/TODWhzBoJQ1rwyyJwMAVe49YrMcrXG8pqnD+q/f61eoKrJkXAr7G6
 VR3w==
X-Gm-Message-State: AOAM530LLirH16pB4Noqs6sIMBBtl+TdA9L5/sieJRBsrroyKhprZSR/
 DctmzYpnZXU8xyGsxZHA7r5LGA==
X-Google-Smtp-Source: ABdhPJxd23qEySJcCwtTGFUUCnhs0ACGzCCMlTQh0PUWwigVeZbm2WT+JjUT3hpQbEtMvfjsVpFKNw==
X-Received: by 2002:aa7:8e88:0:b0:4ba:8792:b with SMTP id
 a8-20020aa78e88000000b004ba8792000bmr56091893pfr.23.1641411661585; 
 Wed, 05 Jan 2022 11:41:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id n34sm43708606pfv.129.2022.01.05.11.41.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Jan 2022 11:41:01 -0800 (PST)
Date: Wed, 5 Jan 2022 19:40:57 +0000
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC PATCH 00/10] KVM: selftests: Add support for
 test-selectable ucall implementations
Message-ID: <YdX0SRoBXReggrVA@google.com>
References: <20211210164620.11636-1-michael.roth@amd.com>
 <Yc4gcJdhxthBKUUd@google.com>
 <20220104233517.kxjbdw4t7taymab5@amd.com>
 <YdTjnRZQID5IabK0@google.com>
 <20220105170244.jwr6i2erecbhx3fz@amd.com>
 <YdXYuaoXJux6lHrF@google.com>
 <20220105191107.qx67wf2coc3q6giu@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220105191107.qx67wf2coc3q6giu@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Orr <marcorr@google.com>,
 linux-kselftest@vger.kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Nathan Tempelman <natet@google.com>,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Mingwei Zhang <mizhang@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Varad Gautam <varad.gautam@suse.com>,
 Jim Mattson <jmattson@google.com>, Steve Rutherford <srutherford@google.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw@amazon.co.uk>
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

On Wed, Jan 05, 2022, Michael Roth wrote:
> On Wed, Jan 05, 2022 at 05:43:21PM +0000, Sean Christopherson wrote:
> > Because it uses multiple VMs, and my rough sketch only allows for a single VM to
> > use ucall.  Though I suppose we could simply keep appending to the ucall list for
> > every VM.  The requirement would then be that all VMs are of the same type, i.e.
> > utilize the same ucall_ops.
> 
> Hmm, maybe I misread your patch. Not supporting multiple VMs was the
> reason I gave up on having the ucall structs allocated on-demand and
> went with requiring them to be passed as arguments to ucall().
> 
> I thought with your patch you had solved that by having each vm have it's
> own pool, via vm->ucall_list, and then mapping each pool into each guest
> separately via:
> 
>   ucall_init(vm):
>     ucall_list = vm->ucall_list
>     sync_global_to_guest(ucall_list).
> 
> then as long as that ucall_init() is done *after* the guest calls
> kvm_vm_elf_load(), it will end up with a 'ucall_list' global that points
> to it's own specific vm->ucall_list. Then on the test side it doesn't
> matter what the 'ucall_list' global is currently set to since you have
> the GPA and know what vm exited.
> 
> Or am I missing something there?

Ha, that was not at all intented.  But yes, it should work.  I'd rather be lucky
than good?

> Although even if that is the case, now that we're proposing doing the
> ucall_init() inside vm_create(), then we run the risk of a test calling
> kvm_vm_elf_load() after, which might clobber the guest's copy of
> ucall_list global if ucall_init() had since been called for another VM.
> But that could maybe be worked around by having whatever vm_create()
> variant we use also do the kvm_vm_elf_load() unconditionally as part of
> creation.

Will sync_global_to_guest() even work as intended if kvm_vm_elf_load() hasn't
been called?  If not, then sync_global_{to,from}_guest() should really assert if
the test hasn't been loaded.

As for ucall_init(), I think the best approach would be to make kvm_vm_elf_load()
a static and replace all calls with:

	kvm_vm_load_guest(vm);

where its implementation is:

  void kvm_vm_load_guest(struct kvm_vm *vm)
  {
  	kvm_vm_elf_load(vm, program_invocation_name);

	ucall_init(vm);
  }

The logic being that if a test creates a VM but never loads any code into the guest,
e.g. kvm_create_max_vcpus, then it _can't_ make ucalls.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
