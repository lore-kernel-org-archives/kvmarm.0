From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: constify seq_operations and
 file_operations
Date: Thu, 24 Aug 2017 09:20:34 -0700
Message-ID: <20170824162034.GC2150@lvm>
References: <de67d01fab53d5b7874cda1ac2c269887c673450.1503471217.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87ECB49C2B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Aug 2017 12:18:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YQz0fu3Udeys for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Aug 2017 12:18:37 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41B4740D25
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Aug 2017 12:18:37 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id i33so4085920wri.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Aug 2017 09:20:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <de67d01fab53d5b7874cda1ac2c269887c673450.1503471217.git.arvind.yadav.cs@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 23, 2017 at 12:25:36PM +0530, Arvind Yadav wrote:
> vgic_debug_seq_ops and file_operations are not supposed to change
> at runtime and none of the structures is modified.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Applied, thanks.
-Christoffer

> ---
>  virt/kvm/arm/vgic/vgic-debug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
> index 7072ab7..10b3817 100644
> --- a/virt/kvm/arm/vgic/vgic-debug.c
> +++ b/virt/kvm/arm/vgic/vgic-debug.c
> @@ -234,7 +234,7 @@ static int vgic_debug_show(struct seq_file *s, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations vgic_debug_seq_ops = {
> +static const struct seq_operations vgic_debug_seq_ops = {
>  	.start = vgic_debug_start,
>  	.next  = vgic_debug_next,
>  	.stop  = vgic_debug_stop,
> @@ -255,7 +255,7 @@ static int debug_open(struct inode *inode, struct file *file)
>  	return ret;
>  };
>  
> -static struct file_operations vgic_debug_fops = {
> +static const struct file_operations vgic_debug_fops = {
>  	.owner   = THIS_MODULE,
>  	.open    = debug_open,
>  	.read    = seq_read,
> -- 
> 1.9.1
> 
