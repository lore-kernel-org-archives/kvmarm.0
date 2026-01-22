Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAE3395718
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099668; cv=pass; b=mkOwgg3Z94rNgksfL4H6Kz1r3l+Dz3G0Z7A0Z4d3Cyh5+QOLg1+zfm+U/MADg5VifvnT2wH/o74HuncCxkVKDh/cmooy/PffJxBovtCdhwilUnobSYjxKEF+lQlUv573DmX20nNTjoPpFSecpYSkZFY0q5TxZy2lZhJcZKCu51c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099668; c=relaxed/simple;
	bh=ZYIqU7xPcH37zvSybjI3FPpHQTFAEV4LoCN7S8Ljj9w=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b3zFnIf6r+nnJYaQ4p8PcgcDVV2JRpzFmLsYlagT1MPvyvFLA9LmFPYPcpmSYylWG6O02+BrhZpfCWyAzzeIqX9ZAiWxbQG1NTpqwi77z1uSkflbTTvEtwpEcKwN6Kqv8qDowCwhzHR9ZW7tbDjAOdDin5pkJpqlyLnf6JiJolY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KecpCGKl; arc=pass smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KecpCGKl"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-5f52b3d98cfso427136137.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 08:34:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769099662; cv=none;
        d=google.com; s=arc-20240605;
        b=NEGCQbbc3/K7PhdEpXnNfjI/Ct4k8Y0NjLoFGcGgcbAerzPRbuD4JuwR+Rx/dlZXuC
         3w95kP32Buu0A572IRNn7gM/7/bxY+EEaVazqe0+pRFEbamBXOjUtTpo/xizJeA7zYLc
         8GJIt4sxTorpO4g7QP30xjP8Fs2kyVJY5RFpPfUPo6RHy94rTa0pgFZCjcgleZYiNFRn
         pVH7vPYI98YrjMcSNJHGZuxkKULQf419gRrr0mc+irSsS+LDIJ/PhCM/t+hRpvRr3We2
         VOyLyKFIkva+wF6TBql6KCEphJQuLX9ggC1YjsnTg6Lno3HeLNqVk4bb+jOe7F6CImFz
         ZwVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=L0r70yq+P7UB3qkVO5/x8sBghKy9pd209cUDvkPIBxI=;
        fh=dWBG3VPpTUyXQYpBgVrZq74F8MgTxqRfuTdRP1oD8mw=;
        b=BVTEmtssC1cuw1SNVshGHfty6aQjWRwqe4ecAnUafFJnQTXy7iT5b4GG7A5AM6JB4i
         kpS5fSmd+pm1sEGCuprsCpX53pFugWnBEf4vHW7gOIV4x/fBfPDDUPiq1fL0+Er8PkLC
         ISD+juDS1bAOJ5+NQczwIZ0giEMADGy/qSl1ClJA3hfNHOJ/hAL3gz1Hk4wJuxJLdD7a
         aztibY9pNf/MjDNfBKNhlGni5kA/8Klk8QJTM0Q5pJh9pFBrMDYPI88dsNLBpiI60dcn
         wzXsjiYlii3LTvJ/xWhzs8lAgEMcVQBDFOOKXInqIbQbzdf1152jhQwYRPI/wXsMnb/5
         U6YA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769099662; x=1769704462; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=L0r70yq+P7UB3qkVO5/x8sBghKy9pd209cUDvkPIBxI=;
        b=KecpCGKlaxnLRceW4uMmJQUJpQSMztwRJlMPKDEIC33FaRHRtSDnK5S8GfS0kg8v4Q
         rJEOF/gP+QDCLTtpX8jClddogYH8cURxX+Ee8CfzmR/Vl3SWkyT/uaw4d4yKyfmsuIc2
         xnqFjbKDeNULT+21HHbJuZI+H3MZt7DhJr/yEYQeHYjZ9mx1Wzair6Zz3Hjoa6nhybO5
         lEtKS6zaRQchl0j+dFnGpfrOijz6oryyus6vL/iebk53/IpNrPC1wd9cnRUIZX5BQXiZ
         934jEBq0XYRv+fqstL8hiAzX5jaO6gHEgEEoYDHsmR3jzR/DfiV3zwWI68WzbuTFC2K+
         MMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769099662; x=1769704462;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L0r70yq+P7UB3qkVO5/x8sBghKy9pd209cUDvkPIBxI=;
        b=Ez5u95eMq37dxwCJqlDW3sx7WR+gH/gXnZ5Nk1GZ1DxZvdRnmCVoWT+gVbVUzehjqL
         8aKJxYfhV7J5baamDIPDGVc5/Gt0mEB/FJqyATgZBI4vEhHnbS9UZ2Vh7JTUBjdO8oxX
         Uev3ax2m2lO96jczct5LJhcvTJhdFLCKhWpHu0y+3/pA2e+9ogMK5h/UN/Zwf7rV/1/O
         RR+j/BqSiIO3CUeOnYJZGEcu4IbsZsNDUw3uV4ZEku7I6c9Vq42rnd85W9awSa2nimvM
         OpvDF+wzwSLEc5ZKF79GHoHnwxk39/gL7VfCId8KsSdIwdoGHmClvcoW2ORy0p1zACjH
         tVzg==
X-Forwarded-Encrypted: i=1; AJvYcCUPxaIPBxbOVt1w/BoInXZx2CdCGqtvps/FzUglg07bwDGzJ9mp99F1N/MuPU5xoseh1MuC6Vg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgG5P8U1XTiWit0vsUBh5bAu+sT6rHGYbRRMdhnhiLnJscAayw
	iHT4Ke/itaOfsUUEoUQExITHpHRbCCraL8rzs5fQikFHZ3xf7s+pLQu9yFvxcSAtMzEZiPGObwO
	IwyWvzbyAt9oGOt/45Bevoa+MJ4W9nZu0SXhqx1Kn
X-Gm-Gg: AZuq6aKtpgzW2qtdQ9WompOTWcS5N5ZYC+fs+3E0BUzoeLWFGM4tdfucqJgTsgSDn5M
	gl2F9eaMpTwG3Qe3LW/RwVU/R06/z8R2br6dPZUZkWlsPM41lZZbvTdWOCRamHKEhqNLAFpaBp7
	Q/1+ahqkV8SRj2FUnnAzeU/m/PlWl9dDcv7Q3Ne49YI6F7Ffig/BlBqyh7WM3lVB8gjztaYABoq
	nkxEUqMN5a0RlfVo7X1qEm1DqHO59s6t7KKyUws/3xP9t53JiI2KkJS86yauRe8/iSp+uzqw+XK
	5E7/
X-Received: by 2002:a05:6102:c52:b0:5ee:9e4b:a81c with SMTP id
 ada2fe7eead31-5f54bc6d8edmr83779137.22.1769099661387; Thu, 22 Jan 2026
 08:34:21 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:34:20 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:34:20 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <a2b79af7-e5d1-4668-bff3-606f57d32dfc@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <CAEvNRgEzVhEzr-3GWTsE7GSBsPdvVLq7WFEeLHzcmMe=R9S51w@mail.gmail.com> <a2b79af7-e5d1-4668-bff3-606f57d32dfc@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 08:34:20 -0800
X-Gm-Features: AZwV_QgNvHql-EMuz2B4VijAKAK9511fycMrz6pi1d87rdZBUNlP58MQhoc9tIU
Message-ID: <CAEvNRgF46M1jp0+eBu2wQMO7P1afyo00SOkENFwvB2KYX3dnFA@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: kalyazin@amazon.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
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
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Nikita Kalyazin <kalyazin@amazon.com> writes:

Was preparing the reply but couldn't get to it before the
meeting. Here's what was also discussed at the guest_memfd biweekly on
2026-01-22:

>
> [...snip...]
>
>>> @@ -423,6 +464,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>>                kvm_gmem_mark_prepared(folio);
>>>        }
>>>
>>> +     err = kvm_gmem_folio_zap_direct_map(folio);
>>
>> Perhaps the check for gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP should
>> be done here before making the call to kvm_gmem_folio_zap_direct_map()
>> to make it more obvious that zapping is conditional.
>
> Makes sense to me.
>
>>
>> Perhaps also add a check for kvm_arch_gmem_supports_no_direct_map() so
>> this call can be completely removed by the compiler if it wasn't
>> compiled in.
>
> But if it is compiled in, we will be paying the cost of the call on
> every page fault?  Eg on arm64, it will call the following:
>
> bool can_set_direct_map(void)
> {
>
> ...
>
> 	return rodata_full || debug_pagealloc_enabled() ||
> 		arm64_kfence_can_set_direct_map() || is_realm_world();
> }
>

You're right that this could end up paying the cost on every page
fault. Please ignore this request!

>>
>> The kvm_gmem_folio_no_direct_map() check should probably remain in
>> kvm_gmem_folio_zap_direct_map() since that's a "if already zapped, don't
>> zap again" check.
>>
>>> +     if (err) {
>>> +             ret = vmf_error(err);
>>> +             goto out_folio;
>>> +     }
>>> +
>>>        vmf->page = folio_file_page(folio, vmf->pgoff);
>>>
>>>   out_folio:
>>> @@ -533,6 +580,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>>>        kvm_pfn_t pfn = page_to_pfn(page);
>>>        int order = folio_order(folio);
>>>
>>> +     kvm_gmem_folio_restore_direct_map(folio);
>>> +
>>
>> I can't decide if the kvm_gmem_folio_no_direct_map(folio) should be in
>> the caller or within kvm_gmem_folio_restore_direct_map(), since this
>> time it's a folio-specific property being checked.
>
> I'm tempted to keep it similar to the kvm_gmem_folio_zap_direct_map()
> case.  How does the fact it's a folio-speicific property change your
> reasoning?
>

This is good too:

  if (kvm_gmem_folio_no_direct_map(folio))
          kvm_gmem_folio_restore_direct_map(folio)

>>
>> Perhaps also add a check for kvm_arch_gmem_supports_no_direct_map() so
>> this call can be completely removed by the compiler if it wasn't
>> compiled in. IIUC whether the check is added in the caller or within
>> kvm_gmem_folio_restore_direct_map() the call can still be elided.
>
> Same concern as the above about kvm_gmem_folio_zap_direct_map(), ie the
> performance of the case where kvm_arch_gmem_supports_no_direct_map() exists.
>

Please ignore this request!

>>
>>>        kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>>>   }
>>>
>>> @@ -596,6 +645,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>>        /* Unmovable mappings are supposed to be marked unevictable as well. */
>>>        WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>>>
>>> +     if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
>>> +             mapping_set_no_direct_map(inode->i_mapping);
>>> +
>>>        GMEM_I(inode)->flags = flags;
>>>
>>>        file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
>>> @@ -807,6 +859,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>        if (!is_prepared)
>>>                r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>>>
>>> +     kvm_gmem_folio_zap_direct_map(folio);
>>> +
>>
>> Is there a reason why errors are not handled when faulting private memory?
>
> No, I can't see a reason.  Will add a check, thanks.
>
>>
>>>        folio_unlock(folio);
>>>
>>>        if (!r)
>>> --
>>> 2.50.1
