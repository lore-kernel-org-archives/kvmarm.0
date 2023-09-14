Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0AE241E7
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 14:19:59 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d8186d705a9so1257611276.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 07:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694701199; x=1695305999; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OinN3M2z4I/Qg8aCda0iI1MRdyz332KlEPPYu5muKwI=;
        b=zY1Nx8B+RKapMj7ED58YGOc3UfzWxOkB/0017tey5dBHw1Nkzt6ASOAfldOMB9DUCO
         RyCBYA3DJu66RlzZv/BEBewRohLkj32HEfbPjba67ciHvCvJBS9tVwaPs8z7idgbzV69
         /txB32YniboOpz6p4HuqxOFpayap6fEUx8GXvsOb2y2thKXxIiqhRxpFzALL48l7wtPv
         Vi2zJA24T19b7eX2DVNGEteoV3dQ5/JTLoiZRbhcOOnvwsJ8Qi7TXp6meoZmUenIJuMo
         OACWXBCTLLBUbD4PPozis5X1xVOqESQw7lGYPpsxXGLfuGSpNy2+5MrTjVTv/X5mO1Nr
         dJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694701199; x=1695305999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OinN3M2z4I/Qg8aCda0iI1MRdyz332KlEPPYu5muKwI=;
        b=dWqN167crGRiiRBn59N1zjC+Rj/V6huP4WWIcsSg6QbuZBI7I7GubpKkiczyPiWeai
         P7t8KBufEKXSOystWs37Zeaq5nYWY2eOJzBAJRN3Ohcy9W/9KxghPg3JYeinhgzbTxu+
         0HPgR8+wchx1kzNl108IjRYdckeurEZX1ltgUarIuuk57GAk8d9Gy4N8GUnH3+F7BAmr
         V3y679vJFxPuv3Tt71p+b0aZig0+D9n7lj65A81S6svxqoNjqMz/EzwABh0AA2sZHDrd
         a0jbI5ei4zglwhJvVg6WNFNDFWWGuKpIEZA+sBQ25oIqSFX1ujmy8KWpeKE2oiPPF1DR
         rPnw==
X-Gm-Message-State: AOJu0YxSLVpgr9LSuVksSDUUU88NiRUZqyy5PKOysv8A/GnNuxpyOaPA
	QoigY4jpNnmkCVS5QstuKeNbrkBQb5Y=
X-Google-Smtp-Source: AGHT+IEn69IOl2rxglDVCjXW4KTdScyqCw6tLi48MQpyb+nW1MjRKbjq1lfqPgEextp+IedkDxkiKrdOCXU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e6c4:0:b0:d78:f45:d7bd with SMTP id
 d187-20020a25e6c4000000b00d780f45d7bdmr129688ybh.4.1694701199053; Thu, 14 Sep
 2023 07:19:59 -0700 (PDT)
Date: Thu, 14 Sep 2023 07:19:57 -0700
In-Reply-To: <54d3e6bf-d374-caa5-0920-bb2fe3b7595c@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-3-seanjc@google.com>
 <54d3e6bf-d374-caa5-0920-bb2fe3b7595c@linux.intel.com>
Message-ID: <ZQMWjbt/SzKvag2K@google.com>
Subject: Re: [RFC PATCH v12 02/33] KVM: Use gfn instead of hva for mmu_notifier_retry
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 14, 2023, Binbin Wu wrote:
> 
> On 9/14/2023 9:55 AM, Sean Christopherson wrote:
> > +void kvm_mmu_invalidate_end(struct kvm *kvm)
> >   {
> >   	/*
> >   	 * This sequence increase will notify the kvm page fault that
> > @@ -833,6 +848,13 @@ void kvm_mmu_invalidate_end(struct kvm *kvm, unsigned long start,
> >   	 * in conjunction with the smp_rmb in mmu_invalidate_retry().
> >   	 */
> >   	kvm->mmu_invalidate_in_progress--;
> > +
> > +	/*
> > +	 * Assert that at least one range must be added between start() and
> > +	 * end().  Not adding a range isn't fatal, but it is a KVM bug.
> > +	 */
> > +	WARN_ON_ONCE(kvm->mmu_invalidate_in_progress &&
> > +		     kvm->mmu_invalidate_range_start == INVALID_GPA);
> Should the check happen before the decrease of kvm->mmu_invalidate_in_progress?
> Otherwise, KVM calls kvm_mmu_invalidate_begin(), then kvm_mmu_invalidate_end()
> the check will not take effect.

Indeed.  I'm pretty sure I added this code, not sure what I was thinking.  There's
no reason to check mmu_invalidate_in_progress, it's not like KVM allows
mmu_invalidate_in_progress to go negative.  The comment is also a bit funky.  I'll
post a fixup patch to make it look like this (assuming I'm not forgetting a subtle
reason for guarding the check with the in-progress flag):

	/*
	 * Assert that at least one range was added between start() and end().
	 * Not adding a range isn't fatal, but it is a KVM bug.
	 */
	WARN_ON_ONCE(kvm->mmu_invalidate_range_start == INVALID_GPA);

Regarding kvm->mmu_invalidate_in_progress, this would be a good opportunity to
move the BUG_ON() into the common end(), e.g. as is, an end() without a start()
from something other than the generic mmu_notifier would go unnoticed.  And I
_think_ we can replace the BUG_ON() with a KVM_BUG_ON() without putting the
kernel at risk.  E.g.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dd948276e5d6..54480655bcce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -870,6 +870,7 @@ void kvm_mmu_invalidate_end(struct kvm *kvm)
         * in conjunction with the smp_rmb in mmu_invalidate_retry().
         */
        kvm->mmu_invalidate_in_progress--;
+       KVM_BUG_ON(kvm->mmu_invalidate_in_progress < 0, kvm);
 
        /*
         * Assert that at least one range was added between start() and end().
@@ -905,8 +906,6 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
         */
        if (wake)
                rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
-
-       BUG_ON(kvm->mmu_invalidate_in_progress < 0);
 }
 
 static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,

