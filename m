Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9695A142E7C
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 09:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749202240; cv=none; b=ilQ+Wlzu4/IRCrgTnYaF/MoQ1nPnHIgilv/cDV3el/Bm79ABaDONFz4JiPuesdDTHx20/cPDQ1qXpjHZhiQDc6m1LXnY4xjL4yBexbRv5mHf0tCamocMmm8TPfDd99U6Dk+fR7kH9A3j/UYXlXzd0+eNAhvMNeLYfmE8+BpoQvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749202240; c=relaxed/simple;
	bh=v6mtyaeZM2QKhdUgEvpmUFi+oe/kFqqUWq+ydSdmob0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Op08SRMZUCZ0YI0a7Zc/3qY5Ja4ALmksg/8z+6FYQgyF+Bz86DGB1ltNQufaL/xmdHLFsecN7WA86ZTxChBSphukwDkrY2A4DaPw30ceC4etEMlrHZOdVw2M2KzaENKh2F8kZS0NJc1C7YLSuhyOjD9OAKSsqwiNbVIMox69h8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T5g2a98/; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T5g2a98/"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-47e9fea29easo292301cf.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 02:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749202237; x=1749807037; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AHMke6C+g7YRY9qvjK/py0IA+evmz7x9/AgLeMPLZq4=;
        b=T5g2a98/KqAvlnVYNh01sF0qV6DII1ep+co5cf/Ml5uQwnHW2qGcJ8onxKfrMKSyNi
         VF4F6pY98xXxtOsAZjbMFPbw7LInUeQFNerkmJWFwJxHI5HcuNExb7BE5g6m548RNQVZ
         GlMj92iGFgo5xAn8vrfJpZC6GJHNFrs7KVsELDCvkHXInUmzLLWGUe2dJ4M9AGSa/InX
         tuKCRXNyApb/L+IlcbpfhQp5UCpdTmUjuVyOT49IJm4DH3bW1QI/iTh7CzBVuT3Lr7bp
         syAp0h2QYJ1L/WX3K7ViSNnYulkSQwy7B4Ezq7qo+F708S5E6o2AjYsI8he1KUeBv+0b
         5L1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749202237; x=1749807037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AHMke6C+g7YRY9qvjK/py0IA+evmz7x9/AgLeMPLZq4=;
        b=JSacOeus/0WiovYCXQXQu007JEeWNogBSxcs7zT1G4JHOAKy72O7d4g1rQXrENpHiL
         oit+CyiAA3IhFa6WZQRwtAMbuQLEQYyFzkiKNpe3smUcnaVY43+VcKdPZ2qXy+SKgLWh
         h+ZLb0+ZLwrVwWTexofuMCyCCOHtqXwXgLzBV3BH42CEbhR0r0Z/fE8+K5AY2d+tj8mU
         x+sikJe6BIuRO4fOQqoCFLhaHSA2y7awuInOBPD2HU2jRsI3S3pFWll7oNPGmQa91GA/
         OqK6TKEOjJQxdBjTRAm2XTehIlyt57TsAGgxpLK4KOWjHbQkIjXm+fEAROp3mooqukPk
         ODfg==
X-Forwarded-Encrypted: i=1; AJvYcCUabyLSMJb2dNN6UWSQkJbYIZ1aNjkqVIPuLKDlPJ9liJHgjFQ7m4ES2kT4+Oe3X2dztw1gxDY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6hUhwIvMlzKPQwXmQirJ37NWvtcjvW8yve5EiWqaz6d9fShDL
	9rPqECyWRRDhqFxBgoLbLwH2ddHwmcNJCq3HGtkWL7sMHwuXoNg4vAN+bFjJbQNdFNkB4N31yIy
	IeweOb/znkXt9gO8qrqUVgWOhCYaxNoTxODCn9njp
X-Gm-Gg: ASbGncsnKM30V8ZRVNXVN1hBDN8zJqWEWgmfQys3vh50QG+976WXQoI12FlrNJ9VIkA
	1DkaCnuLVR/kynDb5L5wVzdaK9+smpSCX1dm0tzvAvnSrUYqq/mtp3W2HsC5uI/jqdVfIne2TWD
	D87zcXNAqa1jrvr0Hn457GcQkRZZz9XJcktqGOubyrGKk=
X-Google-Smtp-Source: AGHT+IH0ZdQDgWYn0D1IxBbNogXfkYZpSsJPMcWn3ZIbTJ/pAnpfxFEKuRL8D1abQDg1x7njp8cRUPduA0bIkHHCnys=
X-Received: by 2002:ac8:580b:0:b0:476:f1a6:d8e8 with SMTP id
 d75a77b69052e-4a643bafe10mr2073391cf.11.1749202237028; Fri, 06 Jun 2025
 02:30:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-9-tabba@google.com>
 <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com>
In-Reply-To: <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Jun 2025 10:30:00 +0100
X-Gm-Features: AX0GCFuvjlKB2JP904W-jAiPrFFo9C41E95GRy92kulxqRvrv_hy1VMtB0oS2WQ
Message-ID: <CA+EHjTziHb5kbY-aA1HPKYpg6iAPcQ19=51pLQ05JRJKeOZ8=A@mail.gmail.com>
Subject: Re: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Fri, 6 Jun 2025 at 10:12, David Hildenbrand <david@redhat.com> wrote:
>
> On 05.06.25 17:37, Fuad Tabba wrote:
> > This patch enables support for shared memory in guest_memfd, including
> > mapping that memory from host userspace.
> >
> > This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> > and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> > flag at creation time.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
>
> [...]
>
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +     u64 flags;
> > +
> > +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> > +             return false;
> > +
> > +     flags = (u64)inode->i_private;
>
> Can probably do above
>
> const u64 flags = (u64)inode->i_private;
>

Ack.

> > +
> > +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             int err = PTR_ERR(folio);
> > +
> > +             if (err == -EAGAIN)
> > +                     return VM_FAULT_RETRY;
> > +
> > +             return vmf_error(err);
> > +     }
> > +
> > +     if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     if (!folio_test_uptodate(folio)) {
> > +             clear_highpage(folio_page(folio, 0));
> > +             kvm_gmem_mark_prepared(folio);
> > +     }
> > +
> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> > +     .fault = kvm_gmem_fault_shared,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +     if (!kvm_gmem_supports_shared(file_inode(file)))
> > +             return -ENODEV;
> > +
> > +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> > +         (VM_SHARED | VM_MAYSHARE)) {
> > +             return -EINVAL;
> > +     }
> > +
> > +     vma->vm_ops = &kvm_gmem_vm_ops;
> > +
> > +     return 0;
> > +}
> > +
> >   static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,
> > @@ -428,6 +500,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> >       }
> >
> >       file->f_flags |= O_LARGEFILE;
> > +     allow_write_access(file);
>
> Why is that required?
>
> As the docs mention, it must be paired with a previous deny_write_access().
>
> ... and I don't find similar usage anywhere else.

This is to address Gavin's concern [*] regarding MADV_COLLAPSE, which
isn't an issue until hugepage support is enabled. Should we wait until
we have hugepage support?

[*] https://lore.kernel.org/all/a3d6ff25-236b-4dfd-8a04-6df437ecb4bb@redhat.com/


> Apart from that here
>
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>
