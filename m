From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 3/8] KVM: arm/arm64: Refactor vgic_register_redist_iodevs
Date: Mon, 8 May 2017 20:38:19 +0200
Message-ID: <20170508183819.GK28342@cbox>
References: <20170508115454.5075-1-cdall@linaro.org>
 <20170508115454.5075-4-cdall@linaro.org>
 <b969f6d6-3a4f-b021-3bf7-5035eb7568b0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b969f6d6-3a4f-b021-3bf7-5035eb7568b0@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 08, 2017 at 06:03:14PM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 08/05/2017 13:54, Christoffer Dall wrote:
> > Split out the function to register all the redistributor iodevs into a
> > function that handles a single redistributor at a time in preparation
> > for being able to call this per VCPU as these get created.
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic-mmio-v3.c | 108 ++++++++++++++++++++++++---------------
> >  virt/kvm/arm/vgic/vgic-v3.c      |   2 +-
> >  virt/kvm/arm/vgic/vgic.h         |   2 +-
> >  3 files changed, 68 insertions(+), 44 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > index 6afb3b4..1828ac7 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > @@ -556,61 +556,85 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
> >  	return SZ_64K;
> >  }
> >  
> > -int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
> > +/**
> > + * vgic_register_redist_iodev - register a single redist iodev
> > + * @vcpu:    The VCPU to which the redistributor belongs
> > + *
> > + * Register a KVM iodev for this VCPU's redistributor using the address
> > + * provided.
> > + *
> > + * Return 0 on success, -ERRNO otherwise.
> > + */
> > +static int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +	struct vgic_dist *vgic = &kvm->arch.vgic;
> > +	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
> > +	struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
> > +	gpa_t rd_base, sgi_base;
> > +	int ret;
> > +
> > +	rd_base = vgic->vgic_redist_base + vcpu->vcpu_id * SZ_64K * 2;
> Previously we had
> gpa_t rd_base = redist_base_address + c * SZ_64K * 2; where c is the
> index in the vcpu array. Now we use the vpcu_id instead of c. Aren't
> they potentially different?
> 

Nicely spotted!

They might be, theoretically.  I never realized this, but we have occurences
of this assumption already, see kvm_pmu_update_state(), for example.
Even worse, the ITS PE numbering is based on the vcpu_id, and not the
index of the vcpu id (see vgic_mmio_read_v3r_typer).

So there are two issues, one is that we should change most occurences of
kvm_get_vcpu() to kvm_get_vcpu_by_id() in our code (I'll write a patch
for this).

The second issue is that vcpu_id is not enforced to be contiguous so we
may end up with a sparse redist frame, which obviously doesn't work, so
I think I'll need to add the following:


diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c14ad9..12eb26d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -490,6 +490,17 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 	return NULL;
 }
 
+static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu *tmp;
+	int idx;
+
+	kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
+		if (tmp == vcpu)
+			return idx;
+	BUG();
+}
+
 #define kvm_for_each_memslot(memslot, slots)	\
 	for (memslot = &slots->memslots[0];	\
 	      memslot < slots->memslots + KVM_MEM_SLOTS_NUM && memslot->npages;\
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 297557b..99da1a2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -586,7 +586,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	if (!vgic_v3_check_base(kvm))
 		return -EINVAL;
 
-	rd_base = vgic->vgic_redist_base + vcpu->vcpu_id * SZ_64K * 2;
+	rd_base = vgic->vgic_redist_base + kvm_vcpu_get_idx(vcpu) * SZ_64K * 2;
 	sgi_base = rd_base + SZ_64K;
 
 	kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);

Thanks,
-Christoffer
