Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23D7C43217
	for <kvmarm@archiver.kernel.org>; Wed, 22 Dec 2021 14:46:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F58840B87;
	Wed, 22 Dec 2021 09:46:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gT0RCrm92nWE; Wed, 22 Dec 2021 09:46:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D835D40F30;
	Wed, 22 Dec 2021 09:46:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CF9040B87
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 09:46:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PL3RjKDf-L6h for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Dec 2021 09:46:27 -0500 (EST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FE4040B59
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 09:46:27 -0500 (EST)
Received: by mail-ed1-f54.google.com with SMTP id m21so10887681edc.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 06:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=5iP0cwT3bhm1wv/SCJZNX3eXAec5s+GXcjileA9F27Q=;
 b=j+iLD08U4k29OZOTR400HLmz2obEtO7D3ChDq2ufdQRwoSee564zTXYkax3kXedW5x
 iYSAkPWnWh0HmsGCYxgqB6v6rjq1J6RfbA6vdp4LqBhOQgTHCW8SJqXMQZoJdZnduOpd
 +biLV62u++nkpKm3GHt3Wazm+d406xWf+r6xfrPIs3XFT6PdOANhi9NTNXW2pBEPseDs
 O8fmCGSqVVXdUxHi/8Yd1osnSYTPPotOKVL37Mpw78cL+ilGurCLByJKVrMSZBrLHbP1
 yF62XgDREqMBjMkc8HOrWcV5QL4YTGRgWxUVtLVW7P80eWy5Am70dRmng4BwwqDAhZJW
 LUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=5iP0cwT3bhm1wv/SCJZNX3eXAec5s+GXcjileA9F27Q=;
 b=KZouFaEfPtNHfM9VOxfrMM586xegiCpLSOeZtpSmlh1uLlZzbRmBO08C7X0Mht3/pM
 rnvDR4iFp1iXpqpbbaUtrzEfvAnmCaLF54x6oC7z31RM/Y4RfTbmA07ZPuNs7pfCX1Ah
 sHfKhLkGD2TFkAq4XatVhXlZRfqOD2grBrO2lAjUD451+jSk161JJCJnSLcXao5fiqsq
 uPIa7e4xMpN+i129tgVulx9fAoERCJSgouDQ8fs8ruKqdya3VyCQleAdbq/wPj4DECPb
 L4WpVpVRdaQSyxdZboh1dnAjmdDgt6HJf2FufsPkdU4XbPna9G++WxKNi57B6CQEyp0V
 K+ZA==
X-Gm-Message-State: AOAM532QU2+P0c4g9wplAowMV2m3B6H7N1H4uMipmU57hhO1JLhMYY+5
 5qibKG17hMBa5qjCwCfgHIY=
X-Google-Smtp-Source: ABdhPJyI+1PK2apwf17miH9QRLuhsilpq9fl9aPP5UQVakVob9Glo6g/RHpSyvLUZIsAbgPzbGdAww==
X-Received: by 2002:a17:906:1d58:: with SMTP id
 o24mr2586115ejh.121.1640184386450; 
 Wed, 22 Dec 2021 06:46:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::4fa? ([2001:b07:6468:f312::4fa])
 by smtp.googlemail.com with ESMTPSA id l16sm864404edb.3.2021.12.22.06.46.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Dec 2021 06:46:26 -0800 (PST)
Message-ID: <b651b14f-9ad2-811d-0d16-21d23a65eba4@redhat.com>
Date: Wed, 22 Dec 2021 15:46:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 00/10] KVM: selftests: Add support for test-selectable
 ucall implementations
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, linux-kselftest@vger.kernel.org
References: <20211210164620.11636-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211210164620.11636-1-michael.roth@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Orr <marcorr@google.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Nathan Tempelman <natet@google.com>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 Ingo Molnar <mingo@redhat.com>, Mingwei Zhang <mizhang@google.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 12/10/21 17:46, Michael Roth wrote:
> These patches are based on kvm/next, and are also available at:
> 
>    https://github.com/mdroth/linux/commits/sev-selftests-ucall-rfc1

Thanks, this is a nice implementation of the concept.  I'll check s390 
before the next merge window, as I intend to merge this and the SEV 
tests (which I have already confirmed to work; I haven't yet checked 
SEV-ES because it's a bit harder for me to install new kernels on the 
SEV-ES machine I have access to).

Paolo

> == BACKGROUND ==
> 
> These patches are a prerequisite for adding selftest support for SEV guests
> and possibly other confidential computing implementations in the future.
> They were motivated by a suggestion Paolo made in response to the initial
> SEV selftest RFC:
> 
>    https://lore.kernel.org/lkml/20211025035833.yqphcnf5u3lk4zgg@amd.com/T/#m959b56f9fb4ae6ab973f6ab50fe3ddfacd7c5617
> 
> Since the changes touch multiple archs and ended up creating a bit more churn
> than expected, I thought it would be a good idea to carve this out into a
> separate standalone series for reviewers who may be more interested in the
> ucall changes than anything SEV-related.
> 
> To summarize, x86 relies on a ucall based on using PIO intructions to generate
> an exit to userspace and provide the GVA of a dynamically-allocated ucall
> struct that resides in guest memory and contains information about how to
> handle/interpret the exit. This doesn't work for SEV guests for 3 main reasons:
> 
>    1) The guest memory is generally encrypted during run-time, so the guest
>       needs to ensure the ucall struct is allocated in shared memory.
>    2) The guest page table is also encrypted, so the address would need to be a
>       GPA instead of a GVA.
>    3) The guest vCPU register may also be encrypted in the case of
>       SEV-ES/SEV-SNP, so the approach of examining vCPU register state has
>       additional requirements such as requiring guest code to implement a #VC
>       handler that can provide the appropriate registers via a vmgexit.
> 
> To address these issues, the SEV selftest RFC1 patchset introduced a set of new
> SEV-specific interfaces that closely mirrored the functionality of
> ucall()/get_ucall(), but relied on a pre-allocated/static ucall buffer in
> shared guest memory so it that guest code could pass messages/state to the host
> by simply writing to this pre-arranged shared memory region and then generating
> an exit to userspace (via a halt instruction).
> 
> Paolo suggested instead implementing support for test/guest-specific ucall
> implementations that could be used as an alternative to the default PIO-based
> ucall implementations as-needed based on test/guest requirements, while still
> allowing for tests to use a common set interfaces like ucall()/get_ucall().
> 
> == OVERVIEW ==
> 
> This series implements the above functionality by introducing a new ucall_ops
> struct that can be used to register a particular ucall implementation as need,
> then re-implements x86/arm64/s390x in terms of the ucall_ops.
> 
> But for the purposes of introducing a new ucall_ops implementation appropriate
> for SEV, there are a couple issues that resulted in the need for some additional
> ucall interfaces as well:
> 
>    a) ucall() doesn't take a pointer to the ucall struct it modifies, so to make
>       it work in the case of an implementation that relies a pre-allocated ucall
>       struct in shared guest memory some sort of global lookup functionality
>       would be needed to locate the appropriate ucall struct for a particular
>       VM/vcpu combination, and this would need to be made accessible for use by
>       the guest as well. guests would then need some way of determining what
>       VM/vcpu identifiers they need to use to do the lookup, which to do reliably
>       would likely require seeding the guest with those identifiers in advance,
>       which is possible, but much more easily achievable by simply adding a
>       ucall() alternative that accepts a pointer to the ucall struct for that
>       particular VM/vcpu.
> 
>    b) get_ucall() *does* take a pointer to a ucall struct, but currently zeroes
>       it out and uses it to copy the guest's ucall struct into. It *could* be
>       re-purposed to handle the case where the pointer is an actual pointer to
>       the ucall struct in shared guest memory, but that could cause problems
>       since callers would need some idea of what the underlying ucall
>       implementation expects. Ideally the interfaces would be agnostic to the
>       ucall implementation.
> 
> So to address those issues, this series also allows ucall implementations to
> optionally be extended to support a set of 'shared' ops that are used in the
> following manner:
> 
>    host:
>      uc_gva = ucall_shared_alloc()
>      setup_vm_args(vm, uc_gva)
> 
>    guest:
>      ucall_shared(uc_gva, ...)
> 
>    host:
>      uget_ucall_shared(uc_gva, ...)
> 
> and then implements a new ucall implementation, ucall_ops_halt, based around
> these shared interfaces and halt instructions.
> 
> While this doesn't really meet the initial goal of re-using the existing
> ucall interfaces as-is, the hope is that these *_shared interfaces are
> general enough to be re-usable things other than SEV, or at least improve on
> code readability over the initial SEV-specific interfaces.
> 
> Any review/comments are greatly appreciated!
> 
> ----------------------------------------------------------------
> Michael Roth (10):
>        kvm: selftests: move base kvm_util.h declarations to kvm_util_base.h
>        kvm: selftests: move ucall declarations into ucall_common.h
>        kvm: selftests: introduce ucall_ops for test/arch-specific ucall implementations
>        kvm: arm64: selftests: use ucall_ops to define default ucall implementation
>        (COMPILE-TESTED ONLY) kvm: s390: selftests: use ucall_ops to define default ucall implementation
>        kvm: selftests: add ucall interfaces based around shared memory
>        kvm: selftests: add ucall_shared ops for PIO
>        kvm: selftests: introduce ucall implementation based on halt instructions
>        kvm: selftests: add GUEST_SHARED_* macros for shared ucall implementations
>        kvm: selftests: add ucall_test to test various ucall functionality
> 
>   tools/testing/selftests/kvm/.gitignore             |   1 +
>   tools/testing/selftests/kvm/Makefile               |   5 +-
>   .../testing/selftests/kvm/include/aarch64/ucall.h  |  18 +
>   tools/testing/selftests/kvm/include/kvm_util.h     | 408 +--------------------
>   .../testing/selftests/kvm/include/kvm_util_base.h  | 368 +++++++++++++++++++
>   tools/testing/selftests/kvm/include/s390x/ucall.h  |  18 +
>   tools/testing/selftests/kvm/include/ucall_common.h | 147 ++++++++
>   tools/testing/selftests/kvm/include/x86_64/ucall.h |  19 +
>   tools/testing/selftests/kvm/lib/aarch64/ucall.c    |  43 +--
>   tools/testing/selftests/kvm/lib/s390x/ucall.c      |  45 +--
>   tools/testing/selftests/kvm/lib/ucall_common.c     | 133 +++++++
>   tools/testing/selftests/kvm/lib/x86_64/ucall.c     |  82 +++--
>   tools/testing/selftests/kvm/ucall_test.c           | 182 +++++++++
>   13 files changed, 982 insertions(+), 487 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
>   create mode 100644 tools/testing/selftests/kvm/include/kvm_util_base.h
>   create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
>   create mode 100644 tools/testing/selftests/kvm/include/ucall_common.h
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h
>   create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c
>   create mode 100644 tools/testing/selftests/kvm/ucall_test.c
> 
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
