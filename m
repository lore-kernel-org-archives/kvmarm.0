Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D3FC43334
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 23:48:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 553084A0FE;
	Thu, 23 Jun 2022 19:48:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6qyku3UDoARv; Thu, 23 Jun 2022 19:48:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D27349F0C;
	Thu, 23 Jun 2022 19:48:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D81349F0C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 19:48:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zilkPjjJ4QJS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 19:48:35 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 740E941175
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 19:48:35 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id r1so591594plo.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 16:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fGObMRo7QznnXN6ICERJu563JsZfkjkbLpt+eWT5kek=;
 b=sl7r7638n+lPbRqcjm6b0D2nvGRmDJLnoe/tyxInuCkYYB0llnm5XQK+oDMrE7GSti
 fdc8pH4GFx42uV34nhOXA75+neJm6xA4bMcYzEITOX4Bf4+N7f+Xrrkru9iTAVoAhPQx
 8yf30NekJrRoEdP704pe/7+P9n6DPT5ily3xXsIIJukIoroB8CHUSrAZ+zymddWX9Ao8
 qp9IJ3NGR3RtFXXkzT3AvbFvkmMQ9e+0jccx3R7bc3LOagceK7l7/7U3DUy3632P0fgO
 dtO/QMjvbifT6cmy2Cc7bOknZnui2JmXkij3+RAkWg37pTsxymsa+Oaf38CDILkkyV8l
 I5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fGObMRo7QznnXN6ICERJu563JsZfkjkbLpt+eWT5kek=;
 b=NsPbjOLuJEvFINSsdSrb3SvVm+5tzNZ04bQrXx+Rmc0olkp6w8lSlJXOJCSB23KgdX
 tQFYBiF1QIev9+Jyf694+vNMbZMjvkKMSu+uern7ughU5diXW5hVu06XInvDDQAXt1UW
 WttopQpXIVnp1AoIzrnH4uWQXBTtejXf0uq6I8wH2OywUXJXtuDWiguw128M8JUP8sb7
 EgnRV6mhY6A0i20tLA5rmEOQoGl3AVHjw4QcfVu2pTytFzl+RtgsFlloPrbP0mlGD4R1
 ZpbTWYVTyfVzxdgcuUBc6186JyLZMYy0Ocj0Y4Rkp1QBoro6HvMI6HRKydyMi6IlgW3Q
 6JAQ==
X-Gm-Message-State: AJIora/+OQLhxL96irFjBPqQm19Wy6mHbOyglRr5XLvzkxxDSd05zA7z
 3GJDC2smlwNTR05PhqTJMnc3uA==
X-Google-Smtp-Source: AGRyM1tDGHdNrq5TJiA3UqbZI0tYa6BmPHiRUtxeUsS1LBdDFpOgGJ/6dg9GmFfEhbf47J3gp5/afQ==
X-Received: by 2002:a17:903:32ce:b0:16a:607b:31df with SMTP id
 i14-20020a17090332ce00b0016a607b31dfmr3579522plr.117.1656028114294; 
 Thu, 23 Jun 2022 16:48:34 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 a8-20020a1709027e4800b0016a100c9a2esm355163pln.112.2022.06.23.16.48.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Jun 2022 16:48:33 -0700 (PDT)
Date: Thu, 23 Jun 2022 23:48:30 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 20/23] KVM: x86/mmu: pull call to drop_large_spte()
 into __link_shadow_page()
Message-ID: <YrT7ztvP6Y4vgj/m@google.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
 <20220622192710.2547152-21-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220622192710.2547152-21-pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, jiangshanlai@gmail.com,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, bgardon@google.com, dmatlack@google.com,
 maciej.szmigiero@oracle.com, kvmarm@lists.cs.columbia.edu, pfeiner@google.com
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

On Wed, Jun 22, 2022, Paolo Bonzini wrote:
> Before allocating a child shadow page table, all callers check
> whether the parent already points to a huge page and, if so, they
> drop that SPTE.  This is done by drop_large_spte().

Thanks for the (), much appreciated!

> However, the act that requires dropping the large SPTE is the
> installation of the sp that is returned by kvm_mmu_get_child_sp(),
> which happens in __link_shadow_page().  Move the call there
> instead of having it in each and every caller.
> 
> To ensure that the shadow page is not linked twice if it was
> present, do _not_ opportunistically make kvm_mmu_get_child_sp()
> idempotent: instead, return an error value if the shadow page
> already existed.  This is a bit more verbose, but clearer than
> NULL.

Agreed, and I think we can take advantage of that verbosity to do a tiny bit more
cleanup by moving the unsync logic into a wrapper that returns -EAGAIN.  Working
on a mini-series...

> Now that the drop_large_spte() name is not taken anymore,
> remove the two underscores in front of __drop_large_spte().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
