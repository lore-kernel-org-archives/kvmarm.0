Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03106C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jan 2022 22:03:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6535149E2C;
	Wed,  5 Jan 2022 17:03:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y5KwdXqh7C5Y; Wed,  5 Jan 2022 17:03:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CECF49E32;
	Wed,  5 Jan 2022 17:03:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11C4749E32
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 17:03:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1O6ER9ltMm4e for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 17:02:59 -0500 (EST)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E135D49E2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 17:02:58 -0500 (EST)
Received: by mail-pg1-f182.google.com with SMTP id f5so350288pgk.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 14:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=YKCFFRAciZpcdqJmTFTjz+wKvbhjzm225M4aIDaCuiU=;
 b=fW9ulu/h4JJhF3zfksJLWMb/bqR8giX/dFE0CouDR+T4lybi6lRauIYAouP9mYL2XX
 YguWms/IVaiZ3ZDCwIsKnjiIpWbcleacvZ/EO7P0mqySNH9ebGIcBvSMfi/iaLmwASwe
 2TlHkMJirJyvPG3B30LCRQ1HdqX38PzwsH4j8PyaMwKJiOg8OC8vWl1TGwkY5wOioE2K
 GqaN3SZNTMLLsyolLb/ExYbL9PgCKZxj1oaZkD2S2bVAWDfqROpz0mplyuwiV1bqPgo4
 xWF2cFWOwG70irBz41p2OphNPPmUXrSGaQUwvoSs6suQBfsw7AgL669rhPB5Uu7wAo7P
 nsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=YKCFFRAciZpcdqJmTFTjz+wKvbhjzm225M4aIDaCuiU=;
 b=T8uJkE+Pq+ZaxS2rqv27GM/hcKLAIoPalxTDuYrjOYrrybp1UxgD67pYIPUHy/VQlO
 XLWl8nQR//xwWStTDu+6bxSlySFsho2iI1P7HuFJEis+JxHAgRjzjUxCEHBTeCZ8e0p7
 E2XqoiujxWSgjxzhGZ8A34PjeOaa2jEGjjDtG1DZP221d9+qb2OgtkdFIKvyT3iOXsc2
 AleQNESOA+oWa7ZOrORh9dCBghXmOMZVN7zdLw8ZEbhM5UjpocVoudEpoSeBBH+FavZj
 weQOmedunyQSYgfB97Z2LOrGHQv37YyV//sCA+lv07pd3WXbwsDPWj1a2SW6ibFWyX7T
 frZA==
X-Gm-Message-State: AOAM532LOq3sa6rfFop5CRmAdHCmKjWfpqTVVq3RlfLAVBFcANBVNoth
 1q8YHd+5rcjPUk1gKjiFH0VRbQ==
X-Google-Smtp-Source: ABdhPJy1j3iKKZs35n/KzJTCkqL0HcCrjjmYG6bssNBIFzGISkV5H8QpwsTR9BEo9HcizmPRobCqBQ==
X-Received: by 2002:a62:7c58:0:b0:4bb:314b:86b9 with SMTP id
 x85-20020a627c58000000b004bb314b86b9mr57302956pfc.84.1641420177751; 
 Wed, 05 Jan 2022 14:02:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id 36sm20676pgq.94.2022.01.05.14.02.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Jan 2022 14:02:57 -0800 (PST)
Date: Wed, 5 Jan 2022 22:02:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC PATCH 00/10] KVM: selftests: Add support for
 test-selectable ucall implementations
Message-ID: <YdYVjfMqf+GjsU+p@google.com>
References: <20211210164620.11636-1-michael.roth@amd.com>
 <Yc4gcJdhxthBKUUd@google.com>
 <20220104233517.kxjbdw4t7taymab5@amd.com>
 <YdTjnRZQID5IabK0@google.com>
 <20220105170244.jwr6i2erecbhx3fz@amd.com>
 <YdXYuaoXJux6lHrF@google.com>
 <20220105191107.qx67wf2coc3q6giu@amd.com>
 <YdX0SRoBXReggrVA@google.com>
 <20220105213519.g746jzf756nax562@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220105213519.g746jzf756nax562@amd.com>
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
> On Wed, Jan 05, 2022 at 07:40:57PM +0000, Sean Christopherson wrote:
> > As for ucall_init(), I think the best approach would be to make kvm_vm_elf_load()
> > a static and replace all calls with:
> > 
> > 	kvm_vm_load_guest(vm);
> > 
> > where its implementation is:
> > 
> >   void kvm_vm_load_guest(struct kvm_vm *vm)
> >   {
> >   	kvm_vm_elf_load(vm, program_invocation_name);
> > 
> > 	ucall_init(vm);
> >   }
> > 
> > The logic being that if a test creates a VM but never loads any code into the guest,
> > e.g. kvm_create_max_vcpus, then it _can't_ make ucalls.
> 
> Makes sense. And if different ops are needed for vmgexit()/tdcall() it
> could be something like (if based on patches 1-5 of this series, and
> extending vm_guest_mode as you suggested earlier):
> 
>    void kvm_vm_load_guest(struct kvm_vm *vm)
>    {
> 
>      kvm_vm_elf_load(vm, program_invocation_name);
>   
>      if (vm->mode == VM_MODE_SEV)
>   	    ucall_init_ops(vm, ucall_ops_pio_vmgexit);
>      else (vm->vm_type == VM_MODE_TDX)

I don't think we want to do this here, but instead down in the arch-specific
ucall_init().  Also, not sure if I was clear before (can't tell what you interpreted
based on the above snippet), but I think we'll want VM_MODE_SEV etc... to be
modifiers on top of the VA/PA stuff.

>   	    ucall_init_ops(vm, ucall_ops_pio_tdcall);
>      else
>   	    ucall_init_ops(vm, ucall_ops_pio);
> 
> Shame we have to update all the kvm_vm_elf_load() call-sites, but
> they'd end up potentially breaking things if left as-is anyway.
> 
> Were you planning on sending patches for these changes, or should I incorporate
> your prototype and take a stab at the other changes as part of v2 of this
> series?

Nope, all yours.  Thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
