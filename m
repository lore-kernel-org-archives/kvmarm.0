Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B17C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 17:38:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDDF649EB2;
	Thu,  6 Jan 2022 12:38:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NwnxT-R8uDFK; Thu,  6 Jan 2022 12:38:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C817049ED1;
	Thu,  6 Jan 2022 12:38:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A71949ED1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 12:38:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zr34xoDnMuUT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jan 2022 12:38:46 -0500 (EST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEF6049EC0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 12:38:46 -0500 (EST)
Received: by mail-pj1-f45.google.com with SMTP id iy13so3042594pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Jan 2022 09:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GYSLa7pA0gp7wUV13RWv0MqLP9/s7fLzmxP/zsHVRcY=;
 b=j41IMR6KZD4U5nPOCrxqCiJ3wofNvmQirr4AuGkd9syR7UwLMOkJGZE8Du7VF6G8CM
 oun7bZn44mafPumkXhw8PTvxpax0sh0VY1fW5SVDZPC0Bm4HeRPdVihDD7b+4Tjn5ZRs
 FAak69mzOIRufLQhcgc/XRF+u7Fmdo/1GoESmVcW7qq2ZL0grgEGzWcqLW6Qx5BDLsCv
 Uoal1Nh1zhGGNw8z9slwCJRoz+Cf+iuRjqBzcK3D+Z3Vlne8u6qwnyQmeUR2C69blu5R
 00hcEFLtFOFtpTR3FxUuDkOfxvbx4VLlRmYFvzbcq4ph7/i2sYx2rqq6XnUdC4voOKmx
 pcjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GYSLa7pA0gp7wUV13RWv0MqLP9/s7fLzmxP/zsHVRcY=;
 b=j6dkeTwh+JF9GKPUqrMr1oMk5Qfd/7FFz/GprgQHWlL//bB9aCXjODcNO2X6MMKfB0
 CLhA5qJrPtIoIL7sUcQbVODf8pCPJXxiu1Gfx/yD4HquTZtDYLgP1ywrxYMuCEPdksbS
 7mPz3+LMi1bEGWQ65rTXRd1ss1YL+mMo6SZIW84lVctdKuVpc62I9UMRVBEaNQMvrUzF
 6Tmprnrkc9KLQUVinEqsyXnuu1pWcDCTasKOjIj8qJgenpYXc47vydVXO5USq3wOXqh1
 YkLTLOAvOlLbKsRn4kqvG+AUcflEev1kcI7OsVLQYpdezkdYPufRTBWdIL+AmY+oPUKs
 X8eA==
X-Gm-Message-State: AOAM532HSYecgQhWl7olkOlUBRg6Z3XhH5Tap+N4jNuF+mLUsz1baci9
 tDWjPXakykOd5aPLcbirG12Lzg==
X-Google-Smtp-Source: ABdhPJzk/FdRU8abIcTFrHj96waF/NHjFtuzEZL1JeXq9Pfy+bowljtCmFDhyszaZc3ia0wyc8/eDQ==
X-Received: by 2002:a17:902:8a94:b0:149:218c:b10a with SMTP id
 p20-20020a1709028a9400b00149218cb10amr58950325plo.114.1641490725484; 
 Thu, 06 Jan 2022 09:38:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id p22sm3271867pfo.57.2022.01.06.09.38.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 06 Jan 2022 09:38:44 -0800 (PST)
Date: Thu, 6 Jan 2022 17:38:41 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <YdcpIQgMZJrqswKU@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com> <YdXvUaBUvaRPsv6m@google.com>
 <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
Cc: Chia-I Wu <olv@chromium.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Thu, Jan 06, 2022, David Stevens wrote:
> On Thu, Jan 6, 2022 at 4:19 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Jan 05, 2022, Sean Christopherson wrote:
> > > Ah, I got royally confused by ensure_pfn_ref()'s comment
> > >
> > >   * Certain IO or PFNMAP mappings can be backed with valid
> > >   * struct pages, but be allocated without refcounting e.g.,
> > >   * tail pages of non-compound higher order allocations, which
> > >   * would then underflow the refcount when the caller does the
> > >   * required put_page. Don't allow those pages here.
> > >                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > that doesn't apply here because kvm_faultin_pfn() uses the low level
> > > __gfn_to_pfn_page_memslot().
> >
> > On fifth thought, I think this is wrong and doomed to fail.  By mapping these pages
> > into the guest, KVM is effectively saying it supports these pages.  But if the guest
> > uses the corresponding gfns for an action that requires KVM to access the page,
> > e.g. via kvm_vcpu_map(), ensure_pfn_ref() will reject the access and all sorts of
> > bad things will happen to the guest.
> >
> > So, why not fully reject these types of pages?  If someone is relying on KVM to
> > support these types of pages, then we'll fail fast and get a bug report letting us
> > know we need to properly support these types of pages.  And if not, then we reduce
> > KVM's complexity and I get to keep my precious WARN :-)
> 
> Our current use case here is virtio-gpu blob resources [1]. Blob
> resources are useful because they avoid a guest shadow buffer and the
> associated memcpys, and as I understand it they are also required for
> virtualized vulkan.
> 
> One type of blob resources requires mapping dma-bufs allocated by the
> host directly into the guest. This works on Intel platforms and the
> ARM platforms I've tested. However, the amdgpu driver sometimes
> allocates higher order, non-compound pages via ttm_pool_alloc_page.

Ah.  In the future, please provide this type of information in the cover letter,
and in this case, a paragraph in patch 01 is also warranted.  The context of _why_
is critical information, e.g. having something in the changelog explaining the use
case is very helpful for future developers wondering why on earth KVM supports
this type of odd behavior.

> These are the type of pages which KVM is currently rejecting. Is this
> something that KVM can support?

I'm not opposed to it.  My complaint is that this series is incomplete in that it
allows mapping the memory into the guest, but doesn't support accessing the memory
from KVM itself.  That means for things to work properly, KVM is relying on the
guest to use the memory in a limited capacity, e.g. isn't using the memory as
general purpose RAM.  That's not problematic for your use case, because presumably
the memory is used only by the vGPU, but as is KVM can't enforce that behavior in
any way.

The really gross part is that failures are not strictly punted to userspace;
the resulting error varies significantly depending on how the guest "illegally"
uses the memory.

My first choice would be to get the amdgpu driver "fixed", but that's likely an
unreasonable request since it sounds like the non-KVM behavior is working as intended.

One thought would be to require userspace to opt-in to mapping this type of memory
by introducing a new memslot flag that explicitly states that the memslot cannot
be accessed directly by KVM, i.e. can only be mapped into the guest.  That way,
KVM has an explicit ABI with respect to how it handles this type of memory, even
though the semantics of exactly what will happen if userspace/guest violates the
ABI are not well-defined.  And internally, KVM would also have a clear touchpoint
where it deliberately allows mapping such memslots, as opposed to the more implicit
behavior of bypassing ensure_pfn_ref().

If we're clever, we might even be able to share the flag with the "guest private
memory"[*] concept being pursued for confidential VMs.

[*] https://lore.kernel.org/all/20211223123011.41044-1-chao.p.peng@linux.intel.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
