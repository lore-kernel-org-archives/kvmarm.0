Received: from out-19.mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BDC2F38
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 06:55:51 +0000 (UTC)
Date: Thu, 8 Jun 2023 08:55:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686207349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k3KMHnpd2ZzjfRif/hU+3cx4/hEhz5i2adNVw9xhrJ0=;
	b=Joun3AfbUWBU+5cBtTJl0MGsrjPlKS/Jzcbw+gM4QVfrZCF2D1UEeFAjDoXEFNTYiO4Sbb
	Ejq4IjJmY9rGni7aKiKEMSyZne7vZ+RYcXFT2PixjGbeDs4YN8+lBgogOxDSkHRdF+Y7TZ
	5dmRxUWrISJ7iz8AF1uqZ1ETCF/f+EI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 19/32] lib/efi: Add support for reading
 an FDT
Message-ID: <20230608-315a460eea93647e2514114c@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-20-nikos.nikoleris@arm.com>
 <20230607-3bd9b31f3687e53e944e69d3@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607-3bd9b31f3687e53e944e69d3@orel>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 07, 2023 at 06:58:22PM +0200, Andrew Jones wrote:
> On Tue, May 30, 2023 at 05:09:11PM +0100, Nikos Nikoleris wrote:
> ...
> > +static void* efi_get_var(efi_handle_t handle, struct efi_loaded_image_64 *image, efi_char16_t *var)
> > +{
> > +	efi_status_t status = EFI_SUCCESS;
> > +	void *val = NULL;
> > +	uint64_t val_size = 100;
> > +	efi_guid_t efi_var_guid = EFI_VAR_GUID;
> > +
> > +	while (efi_grow_buffer(&status, &val, val_size))
> > +		status = efi_rs_call(get_variable, var, &efi_var_guid, NULL, &val_size, val);
> > +
> > +	return val;
> > +}
> 
> I made the following changes to the above function
> 
>     @@ lib/efi.c: static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, i
>      +  uint64_t val_size = 100;
>      +  efi_guid_t efi_var_guid = EFI_VAR_GUID;
>      +
>     -+  while (efi_grow_buffer(&status, &val, val_size))
>     ++  while (efi_grow_buffer(&status, &val, val_size + 1))

I just fixed this fix by changing the '+ 1' to '+ sizeof(efi_char16_t)'
and then force pushed arm/queue.

Thanks,
drew

>      +          status = efi_rs_call(get_variable, var, &efi_var_guid, NULL, &val_size, val);
>      +
>     ++  if (val)
>     ++          ((efi_char16_t *)val)[val_size / sizeof(efi_char16_t)] = L'\0';
>     ++
>      +  return val;
>      +}
>      +
> 
> Before ensuring the dtb pathname was nul-terminated efi_load_image()
> was reading garbage and unable to find the dtb file.
> 
> Thanks,
> drew
> 
> 
> > +
> > +static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
> > +{
> > +	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
> > +	efi_char16_t *val;
> > +	void *fdt = NULL;
> > +	int fdtsize;
> > +
> > +	val = efi_get_var(handle, image, var);
> > +	if (val)
> > +		efi_load_image(handle, image, &fdt, &fdtsize, val);
> > +
> > +	return fdt;
> > +}
> > +
> >  efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> >  {
> >  	int ret;
> > @@ -211,6 +330,7 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> >  	}
> >  	setup_args(cmdline_ptr);
> >  
> > +	efi_bootinfo.fdt = efi_get_fdt(handle, image);
> >  	/* Set up efi_bootinfo */
> >  	efi_bootinfo.mem_map.map = &map;
> >  	efi_bootinfo.mem_map.map_size = &map_size;
> > -- 
> > 2.25.1
> > 
