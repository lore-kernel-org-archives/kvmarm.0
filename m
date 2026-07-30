Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4A24499BB
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 18:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785435183; cv=pass; b=BKOGPeD076R3vy+h+v6ybn3LMUBSRrXuOzT5rLxHBLvcsbp2MEAOyS/ihKGtHqKo23gtL9Y9myJf/X3y5SUmoR1PCIWe7T+elhroM/64YL6ECnB9s5jH9vukN44Qu9uHRRH1C3V6F7AShtY78r8rKwSHLaZDu9QtSrJy3EDNuFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785435183; c=relaxed/simple;
	bh=vP4SBAjY5cYxaFndxMG2sjpjVkz2m/5BGIn+iBJhang=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MBabL2d2NqVcz38xdqsolj7iqA2fiF6XKFt+VTg8OJWkTzvQ0WWwKhXUb0npVJPUjbu3ZOq5WaFqZ19MJwBIemnQmATl6hLGVajHwBATLTF+Y5Fc1VqwcBBkqoqBRXK7Ifh1+C0h+pqbL3HrB0nmAJAZKpNNfJ9UPbgPER6+Jqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UOq+OoHJ; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UOq+OoHJ"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso239822a91.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 11:12:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435176; cv=none;
        d=google.com; s=arc-20260327;
        b=WYmli3ozgspjhusMP2uOZCYSjhJxo1DjcJlI4XqSKiZSjr4X0z73vnma5l5p0b3klP
         25IUlO5GxltAiI+/MKU8Ogbe3Hai+XrH3fULg9hEUXIp185u576MUIodLhLJcsd642SJ
         pLHDK9uN9dZZ6vPkjOY/3OB/MtVQ1VeAnuIzaNP32J6EKZ88Z+AW9IykObMzKDTSSVNX
         Mwp9Q6gwNRRUcOxTn5wDHWr8mSrKhf5f4GKDq26hId59+nVe920XejEzLw8uXr2t6B+S
         VaYc3h7p5/KfPT0n6/7O3u9fEdw0ay/qNlyooBRrYLK17qRxZj2r4Tt8pekQrzQwGcGN
         HtsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=YghvBOxKZj6r8MAI+WUSEYlYQEu1XclpHCz2MD6Rx8I=;
        fh=HLUuuZv0ZKazypDgCtXsA0lPXAXIonFIA35ca9kHZLw=;
        b=XxW+ffkkeAaT8dAWUa2Hp73/8Y0HG1Mk2Dgwiasw9hsXCpi45FTHBC+oU6w23hMHWV
         ITodkrZ+AY/+jkey6DCSv0KfkXASl3S4hB2UCPxG3xKVdDdO0Bku3tALeBIQNyJZpn2e
         axO0EMuqaOr4/Lm4PWbzuIcVU7VScjCDY0byQKXx5R8y1aoHk6T8m0BQGOfT01WskOVe
         VNjJw0bCm+RSc+h/vnRkaHum7IVxD5HnCl0V1bFiuNAv1Y985LoKCK3UhVzNrQcV1YTw
         IEpCE60GqYcaVTiOaa/8FlbKv5FNGAhC6t8p6jllI38KLmkwd9DFbwtSEmWu661ctdBc
         B6zw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785435176; x=1786039976; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YghvBOxKZj6r8MAI+WUSEYlYQEu1XclpHCz2MD6Rx8I=;
        b=UOq+OoHJMhvJTMJZElJIoH15IseHSUjk2SSdQBK2QDtmSMiMR2lVqB2sBwAIBF8JEQ
         ccbnBVMDvI9Xnat7fnyNuxkAFq/QUGiv9Ro8LRj50d/e21+JyXUjEHQey3FMYmaekeyy
         2sx1CuDVsnE8dlsuwkkk2S8rpVN3mEaRNjyRats+py1SgMcAIwNRmLgiyJpL+D/o23Q8
         1F+KpKiiek5tNxr7x2/8d/+GPXEBBA6QL7t3UDhGBhNCDYzZluF8LZaouJ0dt2csP2Pd
         ahX95MUSHtzqQRHsnQFho0z26BEZ8hkTqLPQw95osjxWN3B+W4j9mc9gVEhVUn2t6tP4
         5jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435176; x=1786039976;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YghvBOxKZj6r8MAI+WUSEYlYQEu1XclpHCz2MD6Rx8I=;
        b=WkcKrs1gsD42e21wbRCk+XxzrSRC69abPm3Fhnh3CWSN2b1UIFCBUBwXFmSypDosQF
         eK/dTB5WHSlQjGKM3NQl7rKTunxFlibcZCOh81tgjQ2RRScrwBGAGgDxJRHXLiaAld7b
         Z4prHRoMvqde4DhIAXhrOJ9eobyE19AKbx8fhQpoTpHZPMz7Viv8HEEWe+rva//XrH4Z
         9NPww/FXNzJyMd0LXyq6VOzKwYsyOIzW57Es6WeLAO+kuJ6z9S9kFm9N22SO7BPOeuJn
         oMHoSoelyvo+xjqFk++zq6lrkEqx3RBtQB4e2mYnLOVAaw5vJ/qa6JR8w4eZl6KSqW/E
         SFeQ==
X-Forwarded-Encrypted: i=1; AHgh+RpKzczOHOiwL4OODohh93CCMiKVxb6+1DB4yDZiFU08h2ZZ7BAozu3fBjetcYpl7zWP7ZFMU4M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVmuQa7WIJa1Aqa/CG+qV+tdC53UiIfBY8b/PYOKOvsdLZBf/C
	bilP2MTyKVM5yf+dhG62Wv4DGqdn9ZOgDgHUiytAB9huyje9si998x2VhUqGvLtOTt10yKgaagO
	+GnhvwglDjqzQPay2udFuH9GqF3oo/lqpZNuacRRx
X-Gm-Gg: AR+sD111cJwlypil6ddhIddE2xuPFKeWOrOZlFttcJ4eFJINFZZMIvMXaMCQ92e/Dit
	OrDEbZ6xz4mU9RR0UtjH0CxFHxO1iNvF6IFUMWQuaIcu2lvWT/jDf5EjAIQdVuX8LuzDmzOPbKa
	coKiKG5hTJcrV8Bip4BEpxihLUiGTRfW+/5EMC/RHQon0VZsnVhfxx+TVcXa7fLeKxeHWt/aLRy
	V9OOOTRMBgQzHUl2wnX74pHbPhP3tnhXj94yU/57uyd5E3XQkaf53VqSD9Cq9QXq/AqmeT5PsX+
	Iva1DfDS+OJXdMr62oKXmQsnZ+65EkEwiPj56D5/ZeiC00LjAcsb1cSHQk7+QnuLkiM7Hhrbjv6
	no8dc6guIxHmR33+0WRduw3uLVpnFIvb5dA==
X-Received: by 2002:a17:90b:582c:b0:380:fead:448d with SMTP id
 98e67ed59e1d1-38f9bdaf33amr3348945a91.13.1785435175540; Thu, 30 Jul 2026
 11:12:55 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:12:54 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:12:54 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-7-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-7-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:12:54 -0700
X-Gm-Features: AUfX_myTOZtTYgrc2JARzoakReAlBZfwUvudyD8fyzAtRRNHq5OayI8CE2nMNDE
Message-ID: <CAEvNRgEVxQS2r0_iPHciV=NEKFzwnrfitp-QdP1keAg5Ud7-TQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] KVM: guest_memfd: Move internal definitions to
 internal header
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Tarun Sahu <tarunsahu@google.com> writes:

> Extract 'struct gmem_file', 'struct gmem_inode', and GMEM_I() from
> virt/kvm/guest_memfd.c into a new internal header virt/kvm/guest_memfd.h.
> Also split __kvm_gmem_create() to expose a non-static
> __kvm_gmem_create_file() helper that returns a 'struct file *' instead of
> an fd.
>

This is done basically to support a new virt/kvm/guest_memfd_luo.c
file.

Would like to know what Sean thinks of this! I'd like to know for future
guest_memfd work too.

> These internal definitions and helpers allow upcoming guest_memfd Live
> Update Orchestrator (LUO) preservation code to access guest_memfd
> internals and reconstruct guest_memfd file instances from preserved state
> without installing them into a file descriptor table up front.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  virt/kvm/guest_memfd.c | 68 +++++++++++++++++-------------------------
>  virt/kvm/guest_memfd.h | 39 ++++++++++++++++++++++++
>  2 files changed, 67 insertions(+), 40 deletions(-)
>  create mode 100644 virt/kvm/guest_memfd.h
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab6..dd84bba8974b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -7,38 +7,12 @@
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> +#include "guest_memfd.h"
>
>  #include "kvm_mm.h"
>
>  static struct vfsmount *kvm_gmem_mnt;
>
> -/*
> - * A guest_memfd instance can be associated multiple VMs, each with its own
> - * "view" of the underlying physical memory.
> - *
> - * The gmem's inode is effectively the raw underlying physical storage, and is
> - * used to track properties of the physical memory, while each gmem file is
> - * effectively a single VM's view of that storage, and is used to track assets
> - * specific to its associated VM, e.g. memslots=>gmem bindings.
> - */
> -struct gmem_file {
> -	struct kvm *kvm;
> -	struct xarray bindings;
> -	struct list_head entry;
> -};
> -
> -struct gmem_inode {
> -	struct shared_policy policy;
> -	struct inode vfs_inode;
> -	struct list_head gmem_file_list;
> -
> -	u64 flags;
> -};
> -
> -static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
> -{
> -	return container_of(inode, struct gmem_inode, vfs_inode);
> -}
>
>  #define kvm_gmem_for_each_file(f, inode) \
>  	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
> @@ -557,23 +531,17 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
>  	return true;
>  }
>
> -static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> +struct file *__kvm_gmem_create_file(struct kvm *kvm, loff_t size, u64 flags)
>  {
>  	static const char *name = "[kvm-gmem]";
>  	struct gmem_file *f;
>  	struct inode *inode;
>  	struct file *file;
> -	int fd, err;
> -
> -	fd = get_unused_fd_flags(0);
> -	if (fd < 0)
> -		return fd;
> +	int err;
>
>  	f = kzalloc_obj(*f);
> -	if (!f) {
> -		err = -ENOMEM;
> -		goto err_fd;
> -	}
> +	if (!f)
> +		return ERR_PTR(-ENOMEM);
>
>  	/* __fput() will take care of fops_put(). */
>  	if (!fops_get(&kvm_gmem_fops)) {
> @@ -612,8 +580,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	xa_init(&f->bindings);
>  	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
>
> -	fd_install(fd, file);
> -	return fd;
> +	return file;
>
>  err_inode:
>  	iput(inode);
> @@ -621,7 +588,28 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	fops_put(&kvm_gmem_fops);
>  err_gmem:
>  	kfree(f);
> -err_fd:
> +	return ERR_PTR(err);
> +}
> +
> +static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> +{
> +	struct file *file;
> +	int fd, err;
> +
> +	fd = get_unused_fd_flags(0);
> +	if (fd < 0)
> +		return fd;
> +
> +	file = __kvm_gmem_create_file(kvm, size, flags);
> +	if (IS_ERR(file)) {
> +		err = PTR_ERR(file);
> +		goto err_put_fd;
> +	}
> +
> +	fd_install(fd, file);
> +	return fd;
> +
> +err_put_fd:
>  	put_unused_fd(fd);
>  	return err;
>  }
> diff --git a/virt/kvm/guest_memfd.h b/virt/kvm/guest_memfd.h
> new file mode 100644
> index 000000000000..c528b046dd69
> --- /dev/null
> +++ b/virt/kvm/guest_memfd.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __KVM_GUEST_MEMFD_H__
> +#define __KVM_GUEST_MEMFD_H__ 1
> +
> +#include <linux/kvm_host.h>
> +#include <linux/fs.h>
> +#include <linux/mempolicy.h>
> +
> +/*
> + * A guest_memfd instance can be associated multiple VMs, each with its own
> + * "view" of the underlying physical memory.
> + *
> + * The gmem's inode is effectively the raw underlying physical storage, and is
> + * used to track properties of the physical memory, while each gmem file is
> + * effectively a single VM's view of that storage, and is used to track assets
> + * specific to its associated VM, e.g. memslots=>gmem bindings.
> + */
> +struct gmem_file {
> +	struct kvm *kvm;
> +	struct xarray bindings;
> +	struct list_head entry;
> +};
> +
> +struct gmem_inode {
> +	struct shared_policy policy;
> +	struct inode vfs_inode;
> +	struct list_head gmem_file_list;
> +
> +	u64 flags;
> +};
> +
> +static inline struct gmem_inode *GMEM_I(struct inode *inode)
> +{
> +	return container_of(inode, struct gmem_inode, vfs_inode);
> +}
> +
> +struct file *__kvm_gmem_create_file(struct kvm *kvm, loff_t size, u64 flags);
> +
> +#endif /* __KVM_GUEST_MEMFD_H__ */
> --
> 2.55.0.229.g6434b31f56-goog
