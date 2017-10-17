From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 06/11] KVM: arm/arm64: vgic-its: Check GITS_CBASER
 validity before processing commands
Date: Wed, 18 Oct 2017 00:10:16 +0200
Message-ID: <20171017221016.GF8326@lvm>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
 <1508224209-15366-7-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B91394078A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 18:09:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FnNcOCkmPfWo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 18:09:20 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FAB4406D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 18:09:20 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id i124so6471613wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 15:10:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1508224209-15366-7-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 09:10:04AM +0200, Eric Auger wrote:
> At the moment vgic_its_process_commands() does not
> check the CBASER is valid before processing any command.
> Let's fix that.
> 
> Also rename cbaser local variable into cbaser_pa to avoid
> any confusion with the full register.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 3b539d4..e18f1e4 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1301,17 +1301,20 @@ static void vgic_mmio_write_its_cbaser(struct kvm *kvm, struct vgic_its *its,
>  /* Must be called with the cmd_lock held. */
>  static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
>  {
> -	gpa_t cbaser;
> +	gpa_t cbaser_pa;
>  	u64 cmd_buf[4];
>  
> -	/* Commands are only processed when the ITS is enabled. */
> -	if (!its->enabled)
> +	/*
> +	 * Commands are only processed when the ITS is enabled and
> +	 * CBASER is valid
> +	 */
> +	if (!its->enabled || (!(its->cbaser & GITS_CBASER_VALID)))

Is it valid to clear the CBASER valid bit after having enabled the ITS?
If not, I think you should check changes to CBASER and then this
shouldn't be necessary.



>  		return;
>  
> -	cbaser = CBASER_ADDRESS(its->cbaser);
> +	cbaser_pa = CBASER_ADDRESS(its->cbaser);
>  
>  	while (its->cwriter != its->creadr) {
> -		int ret = kvm_read_guest(kvm, cbaser + its->creadr,
> +		int ret = kvm_read_guest(kvm, cbaser_pa + its->creadr,
>  					 cmd_buf, ITS_CMD_SIZE);
>  		/*
>  		 * If kvm_read_guest() fails, this could be due to the guest
> -- 
> 2.5.5
> 

Otherwise, this looks fine.

Thanks,
-Christoffer
