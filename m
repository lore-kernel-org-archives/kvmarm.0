Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDD01DDE0
	for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 14:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KHAqLBeV"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5afacc566f3so49349337b3.3
        for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 07:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698761410; x=1699366210; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qnQOjymnTrZBwkJL50GP/1+n+ilT5bo3LZ+viwIL69A=;
        b=KHAqLBeVAASN8oL2ZWoSCs/Bu1P2JCtoGB3aXkT+eSrZPVgShMjIfyX0ce7OjlFDbx
         9fEgZEdHs2hmp7xrdftDY0bPqfQrEd10Y2GVCP+VVivBw0KU2NKssUhzZzHIh6/ElKJi
         B1NvYsHgy9YrUQt3SzB7MPTVs++Qhkbp/uIaqBIvTlBhRT3ff64JHWez4NvNeLwPvjLk
         jCI5ODS2iZYONtxP03M1iQL1Fd6I/vgsjqTAiDNPHInWKelwI+vMBfbdXxTtas0JTgot
         25r2MWN/Ol80SLgD6/FbBxJT+4z1Isw+G1/eJTM6BVJbk89EUGdgrVQ+zjy3tDksiHZ2
         2CqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761410; x=1699366210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qnQOjymnTrZBwkJL50GP/1+n+ilT5bo3LZ+viwIL69A=;
        b=WcqiyVYkqpo32aLhkcjB3y5GP8uIiy9RjHBd+l+R18PTfhvaWZbJBUW6ynsn+fZypn
         LZXO5RXpIbnqtYaOduD8vSZiD1TUe6LIypiNNdtNr00fN1QWMeKG7F4ZGes6nI0AMn7+
         qRxQQbVLzh/4qA2gWzvI+WLjUdidc+2/U5NR9hMxNm2+LnWC8+zXAyywoUcU6ZXxj/MZ
         4HH1KkwxH+TOKBNuyK40qLrGT0n3x4Bk1ri4fAb2U/pKvZklzsx88sD5JcBrrd+o55fN
         pz5Rfw8OfemHCSjZOd6fpU8C1EjWRGzXPEchzfVUfbb4sYreWe0J6vZF6yDZKIScIYrf
         V1BQ==
X-Gm-Message-State: AOJu0YzsOBR3bmZkb+pQ5udad0yGF/SUsiPAEgt0YLDddT1Rj7x9TSZ7
	u5tnBHmGLHCSZ8UdZ9U68tD58deb66I=
X-Google-Smtp-Source: AGHT+IHZDXQi7UJsz3IrNX3ZHQxUCVwQKR+0lKBMLeJ46WZVaPkGJ08yzTLT3JODvkoGCJ0IGZA0c9r9iJw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a14c:0:b0:59b:eea4:a5a6 with SMTP id
 y73-20020a81a14c000000b0059beea4a5a6mr274540ywg.0.1698761410163; Tue, 31 Oct
 2023 07:10:10 -0700 (PDT)
Date: Tue, 31 Oct 2023 07:10:08 -0700
In-Reply-To: <ZUCe/PGL2Q4OzDOX@chao-email>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <ZUCe/PGL2Q4OzDOX@chao-email>
Message-ID: <ZUEKwOQoibAEWAzU@google.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Chao Gao wrote:
> >+int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >+{
> >+	loff_t size = args->size;
> >+	u64 flags = args->flags;
> >+	u64 valid_flags = 0;
> >+
> >+	if (flags & ~valid_flags)
> >+		return -EINVAL;
> >+
> >+	if (size < 0 || !PAGE_ALIGNED(size))
> >+		return -EINVAL;
> 
> is size == 0 a valid case?

Nope, this is a bug.

> >+	if (!xa_empty(&gmem->bindings) &&
> >+	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
> >+		filemap_invalidate_unlock(inode->i_mapping);
> >+		goto err;
> >+	}
> >+
> >+	/*
> >+	 * No synchronize_rcu() needed, any in-flight readers are guaranteed to
> >+	 * be see either a NULL file or this new file, no need for them to go
> >+	 * away.
> >+	 */
> >+	rcu_assign_pointer(slot->gmem.file, file);
> >+	slot->gmem.pgoff = start;
> >+
> >+	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
> >+	filemap_invalidate_unlock(inode->i_mapping);
> >+
> >+	/*
> >+	 * Drop the reference to the file, even on success.  The file pins KVM,
> >+	 * not the other way 'round.  Active bindings are invalidated if the
> >+	 * file is closed before memslots are destroyed.
> >+	 */
> >+	fput(file);
> >+	return 0;
> >+
> >+err:
> >+	fput(file);
> >+	return -EINVAL;
> 
> The cleanup, i.e., filemap_invalidate_unlock() and fput(), is common. So, I think it
> may be slightly better to consolidate the common part e.g.,

I would prefer to keep this as-is.  Only goto needs the unlock, and I find it easier
to understand the success vs. error paths with explicit returns.  But it's not a
super strong preference.
