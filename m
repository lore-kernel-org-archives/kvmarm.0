From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 11/11] arm/pci: PCI testdev test flavour
 printing
Date: Fri, 15 Jan 2016 16:39:16 +0100
Message-ID: <20160115153916.GQ3915@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
 <32dba5372296fab32066bbbf23bc13ac75175ce2.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B9349A16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:35:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S7sLztuunrJm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:35:07 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80F6F49A12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:35:07 -0500 (EST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
 (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
 by mx1.redhat.com (Postfix) with ESMTPS id 32B98C09FABD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 15:39:21 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <32dba5372296fab32066bbbf23bc13ac75175ce2.1452341807.git.agordeev@redhat.com>
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

On Sat, Jan 09, 2016 at 01:22:58PM +0100, Alexander Gordeev wrote:
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  lib/pci-testdev.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
> index dd6a5ac..f7f291f 100644
> --- a/lib/pci-testdev.c
> +++ b/lib/pci-testdev.c
> @@ -140,6 +140,23 @@ static bool pci_testdev_one(struct pci_test_dev_hdr *test,
>  	return true;
>  }
>  
> +void pci_testdev_print(struct pci_test_dev_hdr *test,
> +		       struct pci_testdev_ops *ops)
> +{
> +	bool io = (ops == &pci_testdev_io_ops);
> +	int i;
> +
> +	printf("pci-testdev %3s: ", io ? "io" : "mem");
> +	for (i = 0;; ++i) {
> +		char c = ops->read8(&test->name[i]);
> +		if (!c)
> +			break;
> +		printf("%c", c);
> +	}
> +	printf("\n");
> +
> +}
> +
>  static int pci_testdev_all(struct pci_test_dev_hdr *test,
>  			   struct pci_testdev_ops *ops)
>  {
> @@ -148,6 +165,7 @@ static int pci_testdev_all(struct pci_test_dev_hdr *test,
>  	for (i = 0;; i++) {
>  		if (!pci_testdev_one(test, i, ops))
>  			break;
> +		pci_testdev_print(test, ops);
>  	}
>  
>  	return i;
> -- 
> 1.8.3.1
>

This can be squashed into 6/11-8/11

Thanks,
drew 
