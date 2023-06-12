Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB751FA5
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 07:54:39 +0000 (UTC)
Date: Mon, 12 Jun 2023 09:54:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686556477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r4sIb7jmKOH0XhlhVEmgL4hOmArSKh30gUR9H6gYdnQ=;
	b=S41/vQO+VGiRrDhKjoBKNNViVb3Quhxe4HkEcJGVHie2ak/QJEywV9DoyGIdI7snNP3hcF
	za/tCKmphaL5MsmLSFqDoqPQ+xQMLUOGu0tN//H97XwEHpT5SymtdeQYGkStsOSpaTFCJu
	K5RlQ35ddAAmXekJeRAlCZGyyA10edE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com, 
	ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 23/32] arm64: Add a setup sequence for
 systems that boot through EFI
Message-ID: <20230612-b9eae74905d7460f9da57b75@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-24-nikos.nikoleris@arm.com>
 <A5775A3C-B8BF-44C0-931A-CA2C9A4A0A4D@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A5775A3C-B8BF-44C0-931A-CA2C9A4A0A4D@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 09, 2023 at 06:17:25PM -0700, Nadav Amit wrote:
> > 
> > 
> > On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
> > 
> > +static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> > +{
> > +   int i;
> > +   unsigned long free_mem_pages = 0;
> > +   unsigned long free_mem_start = 0;
> > +   struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
> > +   efi_memory_desc_t *buffer = *map->map;
> > +   efi_memory_desc_t *d = NULL;
> > +   phys_addr_t base, top;
> > +   struct mem_region r;
> > +   uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext, 4096);
> > +   uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata, 4096);
> 
> I am not a fan of the initialization of multiple variables in one line.
> 
> But that’s not the issue I am complaining about...
> 
> Shouldn't it be ALIGN() instead of __ALIGN() ?
>

Yup.

Thanks,
drew
