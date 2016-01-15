From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 08/11] arm/pci: PCI device read/write test
Date: Fri, 15 Jan 2016 16:34:36 +0100
Message-ID: <20160115153436.GN3915@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
 <9da79ee47b7ad328c9ba04af0a2ff4697555b007.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE89949A18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:30:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OHAXYpo8+7tY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:30:26 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C25949A11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:30:26 -0500 (EST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
 (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
 by mx1.redhat.com (Postfix) with ESMTPS id C9E571837
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 15:34:39 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <9da79ee47b7ad328c9ba04af0a2ff4697555b007.1452341807.git.agordeev@redhat.com>
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

On Sat, Jan 09, 2016 at 01:22:55PM +0100, Alexander Gordeev wrote:
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  lib/pci-testdev.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
> index de97f82..dd6a5ac 100644
> --- a/lib/pci-testdev.c
> +++ b/lib/pci-testdev.c
> @@ -113,6 +113,9 @@ static bool pci_testdev_one(struct pci_test_dev_hdr *test,
>  			    struct pci_testdev_ops *ops)
>  {
>  	u8 width;
> +	u32 sig, off;
> +	const int nr_writes = 16;
> +	int i;
>  
>  	ops->write8(test_nr, &test->test);
>  	assert(ops->read32(&test->count) == 0);
> @@ -121,6 +124,19 @@ static bool pci_testdev_one(struct pci_test_dev_hdr *test,
>  	if ((width != 1) && (width != 2) && (width != 4))
>  		return false;
>  
> +	sig = ops->read32(&test->data);
> +	off = ops->read32(&test->offset);
> +
> +	for (i = 0; i < nr_writes; i++) {
> +		switch (width) {
> +			case 1: ops->write8 (sig, (void*)test + off); break;
> +			case 2: ops->write16(sig, (void*)test + off); break;
> +			case 4: ops->write32(sig, (void*)test + off); break;
> +		}
> +	}
> +
> +	assert((int)ops->read32(&test->count) == nr_writes);
> +
>  	return true;
>  }

Forgot to mention that this could also be squashed into the last two
patches.

drew
