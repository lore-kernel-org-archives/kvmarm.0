From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/7] lib: chr-testdev: Make
 chr_testdev_init() return status
Date: Thu, 24 Jan 2019 13:56:07 +0100
Message-ID: <20190124125607.l3q5dgtecgwmei3j@kamzik.brq.redhat.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-4-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FEBC4A3A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 07:56:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XzJxXlVERBAt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 07:56:12 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DAA14A39E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 07:56:12 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190124111634.4727-4-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 24, 2019 at 11:16:30AM +0000, Alexandru Elisei wrote:
> Make chr_testdev_init() return 0 (success) if the virtio console was
> initialized properly, otherwise return -1 (failure).
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/chr-testdev.h | 2 +-
>  lib/chr-testdev.c | 8 +++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)

This patch isn't necessary. I'll explain why in patch 5/7.

> 
> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
> index ffd9a851aa9b..fdd0582e2da1 100644
> --- a/lib/chr-testdev.h
> +++ b/lib/chr-testdev.h
> @@ -9,6 +9,6 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> -extern void chr_testdev_init(void);
> +extern int chr_testdev_init(void);
>  extern void chr_testdev_exit(int code);
>  #endif
> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> index 6890f63c8b29..26e14301e3db 100644
> --- a/lib/chr-testdev.c
> +++ b/lib/chr-testdev.c
> @@ -47,7 +47,7 @@ out:
>  	spin_unlock(&lock);
>  }
>  
> -void chr_testdev_init(void)
> +int chr_testdev_init(void)
>  {
>  	const char *io_names[] = { "input", "output" };
>  	struct virtqueue *vqs[2];
> @@ -57,7 +57,7 @@ void chr_testdev_init(void)
>  	if (vcon == NULL) {
>  		printf("%s: %s: can't find a virtio-console\n",
>  				__func__, TESTDEV_NAME);
> -		return;
> +		return -1;
>  	}
>  
>  	ret = vcon->config->find_vqs(vcon, 2, vqs, NULL, io_names);
> @@ -65,9 +65,11 @@ void chr_testdev_init(void)
>  		printf("%s: %s: can't init virtqueues\n",
>  				__func__, TESTDEV_NAME);
>  		vcon = NULL;
> -		return;
> +		return -1;
>  	}
>  
>  	in_vq = vqs[0];
>  	out_vq = vqs[1];
> +
> +	return 0;
>  }
> -- 
> 2.17.0
> 
