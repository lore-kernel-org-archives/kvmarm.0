From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: its: Fix missing dynamic allocation check in
 scan_its_table
Date: Fri, 13 Oct 2017 13:57:42 +0200
Message-ID: <20171013115742.GA10539@cbox>
References: <20171013105259.9728-1-christoffer.dall@linaro.org>
 <0fbee4b3-c555-76d6-4a9e-8a869e87d8ee@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DF6349D2C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 07:56:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 43FbnyrMFGF5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Oct 2017 07:56:50 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3677E49D24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 07:56:49 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id q124so20877802wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Oct 2017 04:57:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <0fbee4b3-c555-76d6-4a9e-8a869e87d8ee@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 13, 2017 at 12:00:50PM +0100, Marc Zyngier wrote:
> On 13/10/17 11:52, Christoffer Dall wrote:
> > We currently allocate an entry dynamically, but we never check if the
> > allocation actually succeeded.  We actually don't need a dynamic
> > allocation, because we know the maximum size of an ITS table entry, so
> > we can simply use an allocation on the stack.
> > 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic-its.c | 19 ++++++++-----------
> >  1 file changed, 8 insertions(+), 11 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> > index f51c1e1..555f42f 100644
> > --- a/virt/kvm/arm/vgic/vgic-its.c
> > +++ b/virt/kvm/arm/vgic/vgic-its.c
> > @@ -176,6 +176,7 @@ static const struct vgic_its_abi its_table_abi_versions[] = {
> >  };
> >  
> >  #define NR_ITS_ABIS	ARRAY_SIZE(its_table_abi_versions)
> > +#define MAX_ENTRY_SIZE	8	/* Max Entry size across all ABI versions */
> >  
> >  inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
> >  {
> > @@ -1801,37 +1802,33 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
> >  static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
> >  			  int start_id, entry_fn_t fn, void *opaque)
> >  {
> > -	void *entry = kzalloc(esz, GFP_KERNEL);
> >  	struct kvm *kvm = its->dev->kvm;
> >  	unsigned long len = size;
> >  	int id = start_id;
> >  	gpa_t gpa = base;
> > +	char entry[MAX_ENTRY_SIZE];
> 
> Nit: you can drop the memset below if you initialize immediately, and
> GCC supporting dynamic arrays allows you to write this:
> 
> 	char entry[esz] = { 0, };
> 
> so that you don't have to add the MAX_ENTRY_SIZE.
> 

Using a dynamic sized array is a great idea, but trying to initalize it
at the same time gives me:

    error: variable-sized object may not be initialized

Is there a trick I'm unfamiliar with?

> >  	int ret;
> >  
> > +	memset(entry, 0, MAX_ENTRY_SIZE);
> > +
> >  	while (len > 0) {
> >  		int next_offset;
> >  		size_t byte_offset;
> >  
> >  		ret = kvm_read_guest(kvm, gpa, entry, esz);
> >  		if (ret)
> > -			goto out;
> > +			return ret;
> >  
> >  		next_offset = fn(its, id, entry, opaque);
> > -		if (next_offset <= 0) {
> > -			ret = next_offset;
> > -			goto out;
> > -		}
> > +		if (next_offset <= 0)
> > +			return next_offset;
> >  
> >  		byte_offset = next_offset * esz;
> >  		id += next_offset;
> >  		gpa += byte_offset;
> >  		len -= byte_offset;
> >  	}
> > -	ret =  1;
> > -
> > -out:
> > -	kfree(entry);
> > -	return ret;
> > +	return 1;
> >  }
> >  
> >  /**
> > 
> 
> Otherwise:
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
Thanks!
-Christoffer
