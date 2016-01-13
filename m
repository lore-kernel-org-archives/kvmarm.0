From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/11] arm/pci: Device tree PCI probing
Date: Wed, 13 Jan 2016 16:13:07 +0100
Message-ID: <20160113151307.GA10709@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
 <06ff365af0d7579d0e4e431fad2492379533c290.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FA749B05
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 10:09:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jn3uZ5qDh1ua for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2016 10:09:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C332499CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 10:09:05 -0500 (EST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
 (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
 by mx1.redhat.com (Postfix) with ESMTPS id 86A00C0BF2C8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 15:13:11 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <06ff365af0d7579d0e4e431fad2492379533c290.1452341807.git.agordeev@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Gordeev <agordeev@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jan 09, 2016 at 01:22:48PM +0100, Alexander Gordeev wrote:
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arm/pci-test.c               |  25 +++++++
>  config/config-arm-common.mak |   5 +-
>  lib/alloc.c                  |   3 -
>  lib/libcflat.h               |   3 +
>  lib/pci-host-generic.c       | 155 +++++++++++++++++++++++++++++++++++++++++++
>  lib/pci-host-generic.h       |  26 ++++++++
>  lib/pci.h                    |  13 ++++
>  7 files changed, 226 insertions(+), 4 deletions(-)
>  create mode 100644 arm/pci-test.c
>  create mode 100644 lib/pci-host-generic.c
>  create mode 100644 lib/pci-host-generic.h
>  create mode 100644 lib/pci.h
> 
> diff --git a/arm/pci-test.c b/arm/pci-test.c
> new file mode 100644
> index 0000000..8629c89
> --- /dev/null
> +++ b/arm/pci-test.c
> @@ -0,0 +1,25 @@
> +/*
> + * PCI bus operation test
> + *
> + * Copyright (C) 2015, Red Hat Inc, Andrew Jones <drjones@redhat.com>

This has changed enough from the starter code I sent you that I don't
need my name here.

> + * Copyright (C) 2015, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */

should explicitly include <libcflat.h> too

> +#include <pci.h>
> +
> +int main(void)
> +{
> +	struct pci *pci;
> +
> +	pci = pci_dt_probe();

It would be better to only expose a 'pci_probe' to the unit tests.
Internally pci_probe then determines it should use pci_dt_probe
(unconditionally atm...)

> +
> +	report("PCI device tree probing", pci);
> +	if (!pci)
> +		goto done;
> +
> +	pci_shutdown(pci);

>From this patch it looks like we could call this function pci_free,
and call it safely with a NULL pci parameter, but it appears some
later patch will change that.

> +
> +done:
> +	return report_summary();
> +}
> diff --git a/config/config-arm-common.mak b/config/config-arm-common.mak
> index 698555d..06ad346 100644
> --- a/config/config-arm-common.mak
> +++ b/config/config-arm-common.mak
> @@ -11,7 +11,8 @@ endif
>  
>  tests-common = \
>  	$(TEST_DIR)/selftest.flat \
> -	$(TEST_DIR)/spinlock-test.flat
> +	$(TEST_DIR)/spinlock-test.flat \
> +	$(TEST_DIR)/pci-test.flat
>  
>  all: test_cases
>  
> @@ -29,6 +30,7 @@ include config/asm-offsets.mak
>  
>  cflatobjs += lib/alloc.o
>  cflatobjs += lib/devicetree.o
> +cflatobjs += lib/pci-host-generic.o
>  cflatobjs += lib/virtio.o
>  cflatobjs += lib/virtio-mmio.o
>  cflatobjs += lib/chr-testdev.o
> @@ -70,3 +72,4 @@ test_cases: $(generated_files) $(tests-common) $(tests)
>  
>  $(TEST_DIR)/selftest.elf: $(cstart.o) $(TEST_DIR)/selftest.o
>  $(TEST_DIR)/spinlock-test.elf: $(cstart.o) $(TEST_DIR)/spinlock-test.o
> +$(TEST_DIR)/pci-test.elf: $(cstart.o) $(TEST_DIR)/pci-test.o
> diff --git a/lib/alloc.c b/lib/alloc.c
> index ad67614..2f60145 100644
> --- a/lib/alloc.c
> +++ b/lib/alloc.c
> @@ -7,9 +7,6 @@
>  #include "asm/spinlock.h"
>  #include "asm/io.h"
>  
> -#define MIN(a, b)		((a) < (b) ? (a) : (b))
> -#define MAX(a, b)		((a) > (b) ? (a) : (b))
> -
>  #define PHYS_ALLOC_NR_REGIONS	256
>  
>  struct phys_alloc_region {
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 9747ccd..2cb167c 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -76,4 +76,7 @@ do {									\
>  		abort();						\
>  } while (0)
>  
> +#define MIN(a, b)		((a) < (b) ? (a) : (b))
> +#define MAX(a, b)		((a) > (b) ? (a) : (b))
> +
>  #endif
> diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
> new file mode 100644
> index 0000000..62b5662
> --- /dev/null
> +++ b/lib/pci-host-generic.c
> @@ -0,0 +1,155 @@
> +/*
> + * Adapated from
> + *   drivers/pci/host/pci-host-generic.c
> + *
> + * Copyright (C) 2015, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> + * Copyright (C) 2016, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include "libcflat.h"
> +#include "devicetree.h"
> +#include "asm/io.h"
> +#include "pci.h"
> +#include "pci-host-generic.h"
> +#include <linux/pci_regs.h>
> +
> +static void pci_host_addr_space_init(struct pci_addr_space as[], int nr_as,
> +				     u32 cells[], int nr_range_cells)
                                         ^ range_cells might be better
> +{
> +	int i;
> +
> +	/*
> +	 * The PCI binding claims the numerical representation of a PCI
> +	 * address consists of three cells, encoded as follows:
> +	 *
> +	 * phys.hi  cell: npt000ss bbbbbbbb dddddfff rrrrrrrr
> +	 * phys.mid cell: hhhhhhhh hhhhhhhh hhhhhhhh hhhhhhhh
> +	 * phys.lo  cell: llllllll llllllll llllllll llllllll
> +	 *
> +	 * PCI device bus address and flags are encoded into phys.high
> +	 * PCI 64 bit address is encoded into phys.mid and phys.low
> +	 */
> +
> +	for (i = 0; i < nr_as; i++, as++) {
> +		as->of_flags = fdt32_to_cpu(cells[0]);
> +		as->pci_range.start = fdt64_to_cpu(*((fdt64_t*)&cells[1]));

This is kind of yucky. I'd rather see something like
  (fdt32_to_cpu(cells[1]) << 32) | fdt32_to_cpu(cells[2])

same comment for the next few assignments below

> +
> +		if (nr_range_cells == 6) {
> +			as->cpu_range.start = fdt32_to_cpu(cells[3]);
> +			as->cpu_range.size =
> +				fdt64_to_cpu(*((fdt64_t*)&cells[4]));
> +		} else {
> +			as->cpu_range.start =
> +				fdt64_to_cpu(*((fdt64_t*)&cells[3]));;
> +			as->cpu_range.size =
> +				fdt64_to_cpu(*((fdt64_t*)&cells[5]));
> +		}
> +
> +		as->pci_range.size = as->cpu_range.size;
> +
> +		cells += nr_range_cells;
> +	}
> +}
> +
> +/*
> + * Probe DT for a generic PCI host controller
> + * See kernel Documentation/devicetree/bindings/pci/host-generic-pci.txt
> + */
> +static struct pci_host_bridge *pci_host_bridge_probe(void)

This function probes DT, but there's no _dt_ in the name.

> +{
> +	struct pci_host_bridge *host;
> +	const void *fdt = dt_fdt();
> +	const struct fdt_property *prop;
> +	struct dt_pbus_reg base;
> +	struct dt_device dt_dev;
> +	struct dt_bus dt_bus;
> +	u32 bus, bus_max;
> +	u32 nac, nsc, nac_root, nsc_root;
> +	u32 nr_range_cells, nr_addr_spaces;
> +	int ret, node, len;
> +
> +	if (!dt_available())
> +		return NULL;
> +
> +	dt_bus_init_defaults(&dt_bus);
> +	dt_device_init(&dt_dev, &dt_bus, NULL);
> +
> +	node = fdt_path_offset(fdt, "/");
> +	assert(node >= 0);
> +
> +	assert(dt_get_nr_cells(node, &nac_root, &nsc_root) == 0);

Sorry the starter code I sent you had statements inside asserts().
We avoid those now, see commit 18ab6cadf

> +	assert(nac_root == 1 || nac_root == 2);
> +
> +	node = fdt_subnode_offset(fdt, node, "pcie");
> +	if (node == -FDT_ERR_NOTFOUND)

It would be good to print that the expected node is missing so
the user knows what's up.

> +		return NULL;
> +	assert(node >= 0);
> +
> +	prop = fdt_get_property(fdt, node, "device_type", &len);
> +	if (!prop || strcmp((char*)prop->data, "pci"))

You should check that len is big enough to do the strcmp without an
overflow. Also, again an error message to the user that the DT is
missing an expected property would be good.

> +		return NULL;
> +
> +	ret = fdt_node_check_compatible(fdt, node, "pci-host-ecam-generic");
> +	assert(ret >= 0);
> +	if (ret != 0)

need error message

> +		return NULL;
> +
> +	dt_device_bind_node(&dt_dev, node);
> +	assert(dt_pbus_get_base(&dt_dev, &base) == 0);
> +
> +	prop = fdt_get_property(fdt, node, "bus-range", &len);
> +	if (prop == NULL) {
> +		assert(len != 0);

Let's change this to assert(len == -FDT_ERR_NOTFOUND)

> +		bus		= 0x00;
> +		bus_max		= 0xff;

Should we just use 'base.size / PCI_ECAM_BUS_SIZE - 1' here for
bus_max, and then change the MIN() below to an assert, checking
that bus_max matches what's expected for the size on the other
path?

> +	} else {
> +		u32 *data	= (u32*)prop->data;
> +		bus		= fdt32_to_cpu(data[0]);
> +		bus_max		= fdt32_to_cpu(data[1]);
> +	}
> +	bus_max = MIN(bus_max, (base.size / PCI_ECAM_BUS_SIZE) - 1);
> +
> +	assert(dt_get_nr_cells(node, &nac, &nsc) == 0);
> +	assert(nac == 3 && nsc == 2);
> +
> +	assert(prop = fdt_get_property(fdt, node, "ranges", &len));
> +
> +	nr_range_cells = nac + nsc + nac_root;
> +	nr_addr_spaces = (len / 4) / nr_range_cells;
> +
> +	assert(host = malloc(sizeof(*host) +
> +			     sizeof(host->addr_space[0]) * nr_addr_spaces));
> +
> +	host->cpu_range.start	= base.addr;
> +	host->cpu_range.size	= base.size;
> +	host->bus		= bus;
> +	host->bus_max		= bus_max;
> +	host->nr_addr_spaces	= nr_addr_spaces;
> +
> +	pci_host_addr_space_init(&host->addr_space[0], nr_addr_spaces,
> +				 (u32*)prop->data, nr_range_cells);
> +
> +	return host;
> +}
> +
> +struct pci *pci_dt_probe(void)
> +{
> +	struct pci_host_bridge *host;
> +	struct pci *pci;
> +
> +	host = pci_host_bridge_probe();
> +	if (!host)
> +		return NULL;
> +
> +	assert(pci = calloc(1, sizeof(*pci)));
> +	pci->sysdata = host;
> +
> +	return pci;
> +}
> +
> +void pci_shutdown(struct pci *pci)
> +{
> +	free(pci->sysdata);
> +	free(pci);
> +}
> diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> new file mode 100644
> index 0000000..097ac2d
> --- /dev/null
> +++ b/lib/pci-host-generic.h
> @@ -0,0 +1,26 @@
> +#ifndef PCI_HOST_GENERIC_H
> +#define PCI_HOST_GENERIC_H
> +
> +struct pci_addr_range {
> +	phys_addr_t			start;
> +	phys_addr_t			size;
> +};
> +
> +struct pci_addr_space {
> +	struct pci_addr_range		cpu_range;
> +	struct pci_addr_range		pci_range;
> +	phys_addr_t			alloc;

alloc isn't used in this patch, but guess it will be later

> +	u32				of_flags;
> +};
> +
> +struct pci_host_bridge {
> +	struct pci_addr_range		cpu_range;
> +	int				bus;
> +	int				bus_max;
> +	int				nr_addr_spaces;
> +	struct pci_addr_space		addr_space[];
> +};
> +
> +#define PCI_ECAM_BUS_SIZE		(1 << 20)

Why not put this struct declaration (and supporting structs) in pci.h?
Linux has struct pci_host_bridge in include/linux/pci.h

> +
> +#endif
> diff --git a/lib/pci.h b/lib/pci.h
> new file mode 100644
> index 0000000..22b8e31
> --- /dev/null
> +++ b/lib/pci.h
> @@ -0,0 +1,13 @@
> +#ifndef PCI_H
> +#define PCI_H

This file needs its copyright/gpl header. I also like to document
the lib here in the header file, e.g. see lib/devicetree.h and
lib/alloc.h

> +
> +#include "alloc.h"
> +
> +struct pci {
> +	void *sysdata;

The choice of sysdata for the name appears to come from the Linux
kernel. Why not also call 'struct pci' 'struct pci_dev' for full
consistency?

> +};
> +
> +extern struct pci *pci_dt_probe(void);
> +extern void pci_shutdown(struct pci *pci);
> +
> +#endif
> -- 
> 1.8.3.1
> 
