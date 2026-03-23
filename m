Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BFA379991
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 21:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774300529; cv=pass; b=VjYLmuBtUoc7Y70dmOoixuNZeLBdfqV4nbKOOf9+hDgpVrNqpVzTZ/0RWcsQws6svx4ZdL3zsxqLXN6YemtfcqSdQmiclWo5KXvcG/2a/NL2dRhp4bmL3ULUVGmkAmFiOdEAddL+udqwEWpZZS6vgmOG+b5TkSeWpreyRnKvXfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774300529; c=relaxed/simple;
	bh=SND86V77+KDMJcamkZKPvEg9WAFvOkbzniGBXqw9BCs=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LKGXdUw6JDj+V/AEWDqVz+20LulTb1KFTIWkYH7ydlKvz4LXhGoFmRb0GEv4wwI54iVMefUxh59dgMXNkLpOJv6R4nolUrTwExHQ/6xKHApnGVgz7cndDwUoY9jeffVByzXdxnMda7RYvI4jRsd3Xjlybc6nAbIUOLLqIRmYr+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hsi4UiRw; arc=pass smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hsi4UiRw"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-94a231b285dso289689241.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 14:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774300526; cv=none;
        d=google.com; s=arc-20240605;
        b=YtbdZQfHshL9jiy6uYyxNF2bdRKT86/ZCnGMTOeyywY+//mDeAf1pYfUfS9r7WzPfO
         Zh3sQ9hfYDxRHPX/Q/yQguzaSXncjYEV9xHcZySWWeeWqlp4T5zu4KXvgHIwqHZHMrWY
         kqgzQP4yMkuxC3EqR3fmlhb/zdedfG78Hpy491A7j3A+D1yZ2DCu/NxXIvDVpaUeFxAc
         Zxq4n9ArLvmvH0JVbuI6ODEgJmeQkL0wmkL+c733ZF6tCahjC5gW9UdgzZKnpTaXUO93
         K4Dc3TQUquyPaDQPo+YDWiW3Jm1fiyTBHmbs7t82GifTKetthedxCs2WYy5Wy0Eg53zk
         g34w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=eOYudi6RRVXGeHCIabojBlAXxTWtuPC09s4XfPfEePE=;
        fh=VKqmvopq6HRbLAL5gbrc3MpE2fUnxqdzdJEhPOIV4GA=;
        b=CRkAzXf/hf0U8P2/vQscrgmmxQdLMRqdUL6KGY/rfQQFkZXE0d3Lt5sgoQhmvnUHM4
         y+GeCBv27yPLSU3mAK4yldiUlEEGwvbPVpxM7UO4MnIeQzh7OjvpqyG8KNW01tbzw4VA
         5k8xudlcS3IbCDtElQmjEIipCrLFgjKIlO7bOdSE+2ADQnsYM6xoU4kKMLP7OYPHtUqX
         UnCO49FhPksB2TnKnxDpdIidJplpnGYFVf+u3XCiFqPqBo5Kux0taFM76Qy8DA+ALpBk
         sW5JKOm+hLeIsGreUFybLp2x9ypV3u8e2iGP/VfLn4LIZrrooFTSqBuOI8stG+eL0A4n
         0gCQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774300526; x=1774905326; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eOYudi6RRVXGeHCIabojBlAXxTWtuPC09s4XfPfEePE=;
        b=Hsi4UiRw3t0XSHPTZn3tr+Hyc0xhFUEsJLgPWjVv68eCVrCeKse9WU6RYCgpAe6bYW
         K3Fd96YQth8Iqvr9FuGYsrl966diDJpSOZ0mf2D3g3++scmAizA7bHFdZ7YEkXd/aeji
         skfxNhWvbQvNCQB4iZInxhm0K/2VwYLDDRJ4qU5mCp2I+29yUYOvaycxLdSIMRLtwQQv
         GtfpP+Qp6TQGNL6aclG7e5+VijcoelmuNe2iaQuGn7U5BKVlAOSBIp4QoMaqHqSx5heB
         Aw8JGvHx6UVsx7+ysSwl7fOTQF5CiL0Kzgo7SYZyhEHrisClwkEVMUiTW17/v56NV3J8
         YiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774300526; x=1774905326;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOYudi6RRVXGeHCIabojBlAXxTWtuPC09s4XfPfEePE=;
        b=L3NJVuZQ8xapsLDUi9OQLx8e6vd+IkPve8wjtNg5tyZ4aAZck5ZeaNHsSB1usFcw4G
         UnnZds6gaSKC0xXsHYuyIXAVUvGQHJbWoc0RR8W9wZmZZyVrTE9wpQNXQ5qzJaDS+27u
         KhsVc83wULoHG1xUd2jRHaY2H8Oq3Fo69R36T9sYsAM9in8S0WshSVleaNVyh+VKpkm+
         mVSfU+trJGroMwx2lgFAUVw/Aejqt2dBPW8pDRr9hJDcl5ikqShnRAWat0kIEecRoDqp
         RQGQckkzqxWCE7Uqfy4uEORPx0lriSSFDe1GqPIB6jH4aHxoXv1jzfyuIHpoqwbB9Id4
         +Rpw==
X-Forwarded-Encrypted: i=1; AJvYcCXu7O8jCWKeU3kn13MnUfqQouSB06Rz3AQRx1d4T1WpxF6q5CUfXWyIBpJBKf/AAA0q7q0QMRE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxgGCxaXcVxh7mDb5mdemZsjn6b5SArevK3C1AboUbnxvjUo/6K
	A/XISy614ADdEhOVJv2/MqlPzN1Cc7AeiEEpb1vg2zIBO6Agn9YL1LtwN6Lc7PDBdjZ3o8ghrsP
	W6TeJeobniK7SSOR3l4sGox3yzSMmtEP8KhqWGq9y
X-Gm-Gg: ATEYQzydoLsX+xLduVm4ST6wrUf4/Fad2G/Rg1Cep4iLwMzU6tFBTIpunr2NuOUeA08
	sbaW59vMe60uNNVBySHV43U4+tSATZ1kg8YwiVV2Xhrr2dHFtuRnqH2ydSTHfyf668Xx/GRxWzs
	DUC3X7sKoMWnY5XeV95Zp+4xFnaSEnNKkeI0xN1w1snmKUrXb9fS3Bvdi7AyH4nXm3l64ZvZ/Oo
	3OxfJQK9O9a92zifB1Z8/ARWRotkQUS/kJiWPdvDhJjQ+NPCm3NwYuix++purCQYNlXKA7JDCwr
	zI3OTloXVjH/9ROHSSgE/kVuzSKMX3UaPMUOaDrIiN2AXqenrJfGT0Wpv2A/7F7EkHVkng==
X-Received: by 2002:a05:6102:c86:b0:602:8894:b770 with SMTP id
 ada2fe7eead31-602aead01admr6510052137.4.1774300525553; Mon, 23 Mar 2026
 14:15:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 14:15:24 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 14:15:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260317141031.514-11-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-11-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 14:15:24 -0700
X-Gm-Features: AQROBzCF2PwLv08LGPIvZtVRv2cQA-zzDMITL8yo-SXZFcfoxiXCsTVqhJQCkhk
Message-ID: <CAEvNRgGb95C3uRxPy2_Uj7SmTW45hNNdJxi5RR209s5KYcHgBw@mail.gmail.com>
Subject: Re: [PATCH v11 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

>
> [...snip...]
>
>  static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  {
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct folio *folio;
>  	vm_fault_t ret = VM_FAULT_LOCKED;
> +	int err;
>
>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>  		return VM_FAULT_SIGBUS;
> @@ -418,6 +454,14 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  		folio_mark_uptodate(folio);
>  	}
>
> +	if (kvm_gmem_no_direct_map(folio_inode(folio))) {
> +		err = kvm_gmem_folio_zap_direct_map(folio);
> +		if (err) {
> +			ret = vmf_error(err);
> +			goto out_folio;
> +		}
> +	}
> +
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
>

Sashiko pointed out that kvm_gmem_populate() might try and write to
direct-map-removed folios, but I think that's handled because populate
will first try and GUP folios, which is already blocked for
direct-map-removed folios.

>  out_folio:
> @@ -528,6 +572,9 @@ static void kvm_gmem_free_folio(struct folio *folio)
>  	kvm_pfn_t pfn = page_to_pfn(page);
>  	int order = folio_order(folio);
>
> +	if (kvm_gmem_folio_no_direct_map(folio))
> +		kvm_gmem_folio_restore_direct_map(folio);
> +
>  	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>  }
>

Sashiko says to invalidate then restore direct map, I think in this case
it doesn't matter since if the folio needed invalidation, it must be
private, and the host shouldn't be writing to the private pages anyway.

One benefit of retaining this order (restore, invalidate) is that it
opens the invalidate hook to possibly do something regarding memory
contents?

Or perhaps we should just take the suggestion (invalidate, restore) and
align that invalidate should not touch memory contents.

> @@ -591,6 +638,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>
> +	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
> +		mapping_set_no_direct_map(inode->i_mapping);
> +
>  	GMEM_I(inode)->flags = flags;
>
>  	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
> @@ -803,13 +853,22 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	}
>
>  	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (r)
> +		goto out_unlock;
>
> +	if (kvm_gmem_no_direct_map(folio_inode(folio))) {
> +		r = kvm_gmem_folio_zap_direct_map(folio);
> +		if (r)
> +			goto out_unlock;
> +	}
> +
>
> [...snip...]
>

Preparing a folio used to involve zeroing, but that has since been
refactored out, so I believe zapping can come before preparing.

Similar to the above point on invalidation: perhaps we should take the
suggestion to zap then prepare

+ And align that preparation should not touch memory contents
+ Avoid needing to undo the preparation on zapping failure (.free_folio
  is not called on folio_put(), it is only called folio on removal from
  filemap).
