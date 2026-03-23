Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4140C31A805
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 18:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291566; cv=pass; b=H1D20PxNvhrxfgFGktPyq59f5pBiYv88Mxr+1r34yIRzHSPUrJ5rkNMwYj/qpjRjGtnnaBCUg157BxO4opT5xFx1bj2I+/W72mYZertOjYg8TICPpYeM3ZFkXZvPMMnQ6KWE5tzjtiKBu7vEBLR9xO5o/yzWflWOYlfIUF6wEZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291566; c=relaxed/simple;
	bh=s+RmDqI+TsxZ+2VgJOew5FS3wS8MDadFq7MLa6vXhF0=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pmUo06KNpRquADHFEwpzTRPXyBtuHVgcBpH11oMO+boFKZdVx9ulyy8gTZJkr/CZU5JS31/7y78F7qAnnakMZcpTlkhDo61nLzB0ica4NxIby1c6kYW8yYIAdCzxw9fpDlrEsrW2yIj3m50LncpeJbzmAKrchlHnYQKmLwfZBXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ueo/eeul; arc=pass smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ueo/eeul"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-6027ef7e068so332118137.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 11:46:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774291564; cv=none;
        d=google.com; s=arc-20240605;
        b=I2waAfUTFBH0OEMpEbm4xBVdlnE3DLDOzg0VJQPpKMuXs0cqizN7TW0FQgAUp2eG/A
         acWcaWhlxLDxq+BumtEyCD2VhO76hgkovmv/MVPXbkFP3lKSfm/WU87ohNyeojbaisOT
         9mU4m7DNjLB61DGP8xdMVnsi70vm7gMh7TFuDwBFuncQBBMpEbRIM/4caZdBcICb7hYj
         w0kiIcVU4zWvXCLqAJgH6C/4HCHAJpEzEpBEvSaIs5FpXAyjsu6v3QQlYytfEDBIZ8wr
         1EbVx8ByMP8erTRMoK542D1B2h6qxdLIhJINr9+UJAET789DWXCTJlONn9Z3q1vYDVKI
         jKoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xr0QXHWwKEApSlK6QljqZmiVGPlsHc0lfppFGa1RJnk=;
        fh=87oLRTUC1l2uWruJJHS3nMXLAs/Bdp5yXcj/PIzSpRQ=;
        b=c0ptyTi0I0xd5L22GD5kzLZlCXH8bq1h+dNDLfeMzGCg+K7jmkcvQJ0T3XCfCZyUYM
         3yDjIMT0E6Jc1+7GoGYnolk6MgLwIJ0/dO0pyGS79IA6F98xai4BAsRkpW1qZ+GJwp0P
         IuJYbVV4dy+eerhwEr8jo70/Zvrt4tyF+8pQ1M6xsa/7cwI9jVpGHN8/CY2hK097aJiP
         zbBO5DeWuvBrLG6keYyUOINlFhDnfyld/EbDy/BWGCP5SMyzK4VSmfUMn4bFdxx864vN
         AQrLT323xfqw4mt2LOqQ6FclbL/5nN/RjsTnKeZVKm4UZ8B+ylEavaNaU9UZvcRB+7la
         21dw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774291564; x=1774896364; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xr0QXHWwKEApSlK6QljqZmiVGPlsHc0lfppFGa1RJnk=;
        b=ueo/eeuluIt7MvnjyFe8Axm8vVU0FVtMaLiQyUo4SvUByB3uc3UNnNgDBTe4ZS//h4
         7HqyqULoI0zIoPOWa3Dqb1hpqxyev0xZrs8QqIxdV3rEa/3tN3dReuNUo01dX0FbjLik
         llKqvawd+wi6kkvwlB1eLWmhTtC2iFwdEIXX8Bt7rZK87Rh4bs31Jgp4fdbFNK0fOGcJ
         ntmr+7bg03+bZZkk8aRnlRKNABoKZ6bcn95P2M9OdS0AsiRmDOwMwJWXhBdLKKzq7QQh
         07P4BtC0wBl5yOm3ZsjnoPBzhPGdSklqIDHlX3bXOEPNjBtgdJNYLF6jsbe/5J9zK+iq
         AcIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291564; x=1774896364;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xr0QXHWwKEApSlK6QljqZmiVGPlsHc0lfppFGa1RJnk=;
        b=Dik+7vi8zSGY34Grod5778eRVLXBg1PnyPSZJyibctucssidHCuxFI6AdlsFye7Otf
         MBzaHx3ikg1JC/aiU1qmZLE/9SLLEWzmgwWD06VwWtE85EQK2IOS/PhXkWsYvwVaAU02
         kkszJjfYi59C853pIEuCbZ0IHiiJpCVOTnY4t5lDoINL+bpxxX0KYYM96J4OWs1QIuDk
         px9WNPfIMApFSfn5A9vFMk7rVNBRJi2GpXs5Ot1YgcFxmtmA4/1Mj8e04Bv5YucG/Kew
         0byqXYViF4nDa/BVAF/8ives8f6Kgg6Jm/v2jq6ZRmtqTeUu5klmZe1rGUExOvhzG7Gs
         a8QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVcBziwqlX11pK5BGxq4jfahkotKlHqJ+vufSV9DFF36nx/wM4mOlL/AvTrmVTvNdtpaeBzuw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKQ9mfVbkWZGwziQb6+Raz68ofS5vnBUqN23yAX/oStCadi/E7
	EhuMWyQ4hngcimgxavugOkzq8klFi5S88Y8RNA62IoqvnaW5oTkfO0fu3diT7+I9nimLvmzP9Vj
	38I4Ut1SswmJdDa25Kf9TCFYYFshVqsNmZS5cm0vN
X-Gm-Gg: ATEYQzzHvRPaKRVok3NgzA+ExeHBi7wH/UbYuLF2ufEia0rbRIzaMQMQBSMMkGTi+YF
	di448zPQAvl7T1GjJNk5DDFpA86Uhq7snFtfGQkpxv1zMnx4bX1XAqWfKfEO9OubFlymGDf+Ue3
	2LzHFKXFYFi0zZwFojMAY1inmlzqaXPxBRdRwWpZQ1RUW+l0Q0PymhvUHj97sowq/FhkaqRrFb6
	+uw9B2HVqhbem2LkQcbk401EiWKiMWbKb95VH+UnxhffvefiCoaqu7hXE5FBVumHXYYuBztd+4s
	E+Dy/D0DxoAMA0lMVNDtPDFsW/XLZVsHDP5JXDuoPM8NsJSRtXqCXP2M7hNAX47RcJB4Tw==
X-Received: by 2002:a05:6102:1610:b0:5ef:8ae:85a5 with SMTP id
 ada2fe7eead31-602aeb231f5mr7205779137.16.1774291563158; Mon, 23 Mar 2026
 11:46:03 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:46:02 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:46:02 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260317141031.514-4-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-4-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 11:46:02 -0700
X-Gm-Features: AQROBzCRQmL2CFh0hL8G9T_h4E5mqLNycY6Q5fv3k8u-7tLVQqZDWt6l_fOQ864
Message-ID: <CAEvNRgEBdi49ZkfGo0xmM+J1yzKOzfT2ThAXEN=S0j7vC7Fu3w@mail.gmail.com>
Subject: Re: [PATCH v11 03/16] mm/secretmem: make use of folio_{zap,restore}_direct_map
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

> From: Nikita Kalyazin <kalyazin@amazon.com>
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  mm/secretmem.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index fd29b33c6764..27b176af8fc4 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -53,7 +53,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	pgoff_t offset = vmf->pgoff;
>  	gfp_t gfp = vmf->gfp_mask;
> -	unsigned long addr;
>  	struct folio *folio;
>  	vm_fault_t ret;
>  	int err;
> @@ -72,7 +71,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  			goto out;
>  		}
>
> -		err = set_direct_map_invalid_noflush(folio_address(folio));
> +		err = folio_zap_direct_map(folio);
>  		if (err) {
>  			folio_put(folio);
>  			ret = vmf_error(err);
> @@ -87,7 +86,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  			 * already happened when we marked the page invalid
>  			 * which guarantees that this call won't fail
>  			 */
> -			set_direct_map_default_noflush(folio_address(folio));
> +			folio_restore_direct_map(folio);
>  			folio_put(folio);
>  			if (err == -EEXIST)
>  				goto retry;
> @@ -95,9 +94,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  			ret = vmf_error(err);
>  			goto out;
>  		}
> -
> -		addr = (unsigned long)folio_address(folio);
> -		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>  	}
>
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
> --
> 2.50.1

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
