Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD31338937
	for <kvmarm@lists.linux.dev>; Wed,  5 Nov 2025 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762356397; cv=none; b=YT8vvL6CrAqsnERzWaqGf0TlG1Txqa6j8eCcyl2hT+I5deBo8SSS2WQBN0UzGUePP5OxQgMRjNgP3eyu4x2+jFuZuPbjJGdJlCbMnPKSWYEpNnt9CQOYAmQO5LnQOJ7BaR1YVKM/og5Rce9Jx4IHWgANKqku71dlDq1YXyUMCnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762356397; c=relaxed/simple;
	bh=d8JWxeRGmjq8jXPHzr0bSzSADeEyMQIUeCD2xQhaO6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0XSCCFgeiRDKFyA+7WCfYTUm/kMnBoaOdtG3Gs4LGHY5+nFihQxSnKHEFG1QqSPdP20gr/2kLmjteJXGVYE8zWJdE88JMBDkRyVfEpZK9zBv5ATSeUC5YFEJzFpvSnobSlc/0QZawdr4RSC+QDJag+P7eNLeDbcb5HPSR5+xoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vHLDgpud; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vHLDgpud"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3418ada9e6cso1978171a91.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Nov 2025 07:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762356395; x=1762961195; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dmjmfo22QwufKip+RFN2GwcKXDk7+fDMohFzNqFh1wo=;
        b=vHLDgpud1UqaRvz1DNy0hmhbLnUZUDv/QSD4xhUkQemkpsUlpvR6D3TsXorLbazEz/
         TaWYfbWJR3PrqtvZ2DvbXE5fEl+4rSsPVYAE46jbe52CzHaFPGis9wBUk+rrVqc8CTWW
         mA141lGYy8Kl1zhxJlrz+MDW6QgHl9f3rV9cpTyA/bT55d7IZXKnefmcyHBOZCmSbHpR
         wnWu79nUEN7vZw2rRQNqlr2e/vA7Lk9QZIUctlpS0yZekYwzGlj4lieONBvINwTXCwrF
         7wVfceD9j+ozbnsaZAkFx36MkEeQN5IGOwYVXFdOwjqNJ+MslhPrGEsvFY8OCEooxiQG
         hCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762356395; x=1762961195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmjmfo22QwufKip+RFN2GwcKXDk7+fDMohFzNqFh1wo=;
        b=dqj9LB0X2ddcMeq8NRkcxp5HjU88VdU8iIHImhjnnzg8SNz9MWB/H0aMNtZ2Am569N
         Byr6qXf4f8FvR+rXVzpGHLNDyNtr+aIqHdzXGUzizFIQRkxTeax7QEoZElsZYX1V26Is
         E27dhHTJSciFJ0giIoxcl/eFLdCCMcXK8WrtfmOtkp9TrIvtcdtOdRwJRTTsilrK/OlH
         S+O5VyqFnBTEhHT+d3kNys3tmRWfSXRI4clKWzpw4E1lgoPbh8owv7+W39L33IQ4c08f
         nRoh1z5WJl3SsY1zvLUtfxtTd74dEd42AOxzhCUd+FhTxbQf/xyJIFqRUZmiQVyDvwrU
         hFgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhDla0f3xfwZsPmBadtQiyfqD1QTI64I9WvIXGAp1+DFAHHyrElGJK75W5jAcWWziLE9E8aPc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2iN0lipWwETSiOsTjVQl9YQjXzUDVYPZoaEdWVqJpeN/I50xk
	F4+NG/zv5rh7aRRZYBGqiRN7thVvxAbm6Y2iApFgwT9sOqgPeKvi5mYGD1MZ/LYgoSmAZGmAuKm
	PCCo0lA==
X-Google-Smtp-Source: AGHT+IEksiko2nLkYHDcuQoizh41Xk4dhEPlLcSxUswEaWhydqjlp9gNPv6q5VYl/pXem0FsGEVxprPZGIk=
X-Received: from pjbtc7.prod.google.com ([2002:a17:90b:5407:b0:340:b503:505f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384d:b0:340:9cf1:54d0
 with SMTP id 98e67ed59e1d1-341a6c08e65mr4623520a91.1.1762356395074; Wed, 05
 Nov 2025 07:26:35 -0800 (PST)
Date: Wed, 5 Nov 2025 07:26:33 -0800
In-Reply-To: <aQsBI1/SIXGbf9nA@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-5-seanjc@google.com>
 <aPhjYcOFjL1Z8m2s@yzhao56-desk.sh.intel.com> <aQMi/n9DVyeaWsVH@yzhao56-desk.sh.intel.com>
 <aQo-hus99rE7WBgb@google.com> <aQr9jW/7zwWJaDFf@yzhao56-desk.sh.intel.com> <aQsBI1/SIXGbf9nA@yzhao56-desk.sh.intel.com>
Message-ID: <aQtsqXPaZo2SMdJU@google.com>
Subject: Re: [PATCH v3 04/25] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 05, 2025, Yan Zhao wrote:
> On Wed, Nov 05, 2025 at 03:32:29PM +0800, Yan Zhao wrote:
> > On Tue, Nov 04, 2025 at 09:57:26AM -0800, Sean Christopherson wrote:
> > > On Thu, Oct 30, 2025, Yan Zhao wrote:
> > > > On Wed, Oct 22, 2025 at 12:53:53PM +0800, Yan Zhao wrote:
> > > > > On Thu, Oct 16, 2025 at 05:32:22PM -0700, Sean Christopherson wrote:
> > > > > > Link: https://lore.kernel.org/all/20250709232103.zwmufocd3l7sqk7y@amd.com
> > > > > 
> > > > > Hi Sean,                                                                         
> > > > > 
> > > > > Will you post [1] to fix the AB-BA deadlock issue for huge page in-place
> > > > > conversion as well?
> > > 
> > > If you (or anyone) has the bandwidth, please pick it up.  I won't have cycles to
> > > look at that for many weeks (potentially not even this calendar year).
> > Got it!
> > On the other hand, do you think we can address the warning as below?
> > The code is based on [2].
> Hmm, updated the diff.
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7b4a4474d468..543e1eb9db65 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -853,6 +853,9 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
>         inode->i_size = size;
>         mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>         mapping_set_inaccessible(inode->i_mapping);
> +       if (flags &GUEST_MEMFD_FLAG_MMAP)
> +               lockdep_set_subclass(&inode->i_mapping->invalidate_lock, 1);
> +
>         /* Unmovable mappings are supposed to be marked unevictable as well. */
>         WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> 
>  
> > As noted in [3], the only scenario can trigger the warning after [2] is when a
> > process creates a TDX VM with non-in-place-conversion guest_memfd and a normal
> > VM with in-place-conversion guest_memfd. The two invalidate_lock's don't contend
> > with each other theoretically.

Hmm, no, I think we need to hoist gup() call outside of filemap_invalidate_lock(),
because I don't think this is strictly limited to TDX VMs without in-place
conversion.  Even with in-place conversion, I think KVM should allow the source
page to be shared memory, at which point I believe this becomes a legimate AB-BA
issue.

In general, playing lockdep games with so many subsystems involved terrifies me.

> > [2] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/
> > [3] https://lore.kernel.org/all/aQMi%2Fn9DVyeaWsVH@yzhao56-desk.sh.intel.com/
