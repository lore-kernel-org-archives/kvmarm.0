Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65B317722
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 09:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711443845; cv=none; b=K0sfFEKXKmiPR1KleaP0BHQC204KFo84zn2OtLITlT7xxJEgv/UkJdiKDwi2NfCKoECYQN3SBtu0I+5zCA4Je9sZPAYgNAA/2mIQABAXRC9g0/prOkIkq93fflZTDMywL651LPYvCXyJXnJsunADPJUdQHW5/THmTYHFGb2O0mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711443845; c=relaxed/simple;
	bh=WDhqpZZUuOCf+DEl/5Ml8KZz4MeLvIRIvyK8MpTuPk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g3d5XXVZOSwOgzc+4GFE9MWcx+49ksJHSeOgF68+fHjhgNqjX1jVeXMp00Tv9r15sfLTfarNSKyWAYll8igYXicwgBx+ooGDDnYAtMpPxtZZXOCOlg4cr1QUHDxt5o29Tky0H3IDF44e0XxwBXS1nyt9I/ym+GR2JdcTk3kaShk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CzV3DHRd; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CzV3DHRd"
Date: Tue, 26 Mar 2024 10:03:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711443840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rvKYY4hi+dX1n49yNjLHIoqKBdexRZUwwqArPL2hdzc=;
	b=CzV3DHRdI6wlTBKLP6/nkPlspiLvYdEFPeKVcW41odRhnyrdOkmWpXMek87WyPz+WogIfx
	y5qpUxaRh2uTZ4vj2W7Y8rRZKEwRxoi75kqbn2odqSCPR84D3QOzcfofaaa7bkPBDt0QYS
	N0fK1OR76RO4gN5jSoheWg7JzEuVtRg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: "Paluri, PavanKumar" <papaluri@amd.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	shahuang@redhat.com, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 08/18] arm64: efi: Improve device tree
 discovery
Message-ID: <20240326-f023a9bdf7ccaeb8844c5197@orel>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-28-andrew.jones@linux.dev>
 <39d0ed49-a6a2-c812-c4e7-444a460cb18b@amd.com>
 <b7ca796b-8883-4048-b441-fd5c5bdc4d52@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7ca796b-8883-4048-b441-fd5c5bdc4d52@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 25, 2024 at 09:59:00PM +0000, Nikos Nikoleris wrote:
> On 25/03/2024 16:24, Paluri, PavanKumar wrote:
> > Hi,
> > 
> > On 3/5/2024 10:46 AM, Andrew Jones wrote:
> > > Check the device tree GUID when the environment variable is missing,
> > > which allows directly loading the unit test with QEMU's '-kernel'
> > > command line parameter, which is much faster than putting the test
> > > in the EFI file system and then running it from the UEFI shell.
> > > 
> > > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > > ---
> > >   lib/efi.c       | 19 ++++++++++++-------
> > >   lib/linux/efi.h |  2 ++
> > >   2 files changed, 14 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/lib/efi.c b/lib/efi.c
> > > index d94f0fa16fc0..4d1126b4a64e 100644
> > > --- a/lib/efi.c
> > > +++ b/lib/efi.c
> > > @@ -6,13 +6,13 @@
> > >    *
> > >    * SPDX-License-Identifier: LGPL-2.0-or-later
> > >    */
> > > -
> > > -#include "efi.h"
> > > +#include <libcflat.h>
> > >   #include <argv.h>
> > > -#include <stdlib.h>
> > >   #include <ctype.h>
> > > -#include <libcflat.h>
> > > +#include <stdlib.h>
> > >   #include <asm/setup.h>
> > > +#include "efi.h"
> > > +#include "libfdt/libfdt.h"
> > >   /* From lib/argv.c */
> > >   extern int __argc, __envc;
> > > @@ -288,13 +288,18 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
> > >   	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
> > >   	efi_char16_t *val;
> > >   	void *fdt = NULL;
> > > -	int fdtsize;
> > > +	int fdtsize = 0;
> > >   	val = efi_get_var(handle, image, var);
> > > -	if (val)
> > > +	if (val) {
> > >   		efi_load_image(handle, image, &fdt, &fdtsize, val);
> > > +		if (fdtsize == 0)
> > > +			return NULL;
> > > +	} else if (efi_get_system_config_table(DEVICE_TREE_GUID, &fdt) != EFI_SUCCESS) {
> > > +		return NULL;
> > > +	}
> > > -	return fdt;
> > > +	return fdt_check_header(fdt) == 0 ? fdt : NULL;
> > 
> > The call to fdt_check_header() seems to be breaking x86 based UEFI
> > tests. I have tested it with .x86/efi/run ./x86/smptest.efi
> 
> I am not familiar with the x86 boot process but I would have thought that
> the efi shell variable "fdtfile" is not set and as a result val would be
> NULL. Then efi_get_system_config_table(DEVICE_TREE_GUID, &fdt) would return
> EFI_NOT_FOUND and efi_get_fdt would return NULL without executing the line
> fdt_check_header(fdt).

I suppose there could be a table (maybe empty?) with the DEVICE_TREE_GUID
guid? Anyway, we should probably just #ifdef out the function since x86
kvm-unit-tests doesn't link with libfdt and the only reason it can compile
with an undefined reference to fdt_check_header() is because we create
.efi files through shared libraries.

Thanks,
drew

> 
> Thanks,
> 
> Nikos
> 
> > 
> > Thanks,
> > Pavan
> > >   }
> > >   efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> > > diff --git a/lib/linux/efi.h b/lib/linux/efi.h
> > > index 410f0b1a0da1..92d798f79767 100644
> > > --- a/lib/linux/efi.h
> > > +++ b/lib/linux/efi.h
> > > @@ -66,6 +66,8 @@ typedef guid_t efi_guid_t;
> > >   #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> > >   #define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
> > > +#define DEVICE_TREE_GUID EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
> > > +
> > >   #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
> > >   typedef struct {
