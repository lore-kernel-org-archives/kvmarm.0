From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 2/5] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Mon, 07 Sep 2015 11:50:05 +0300
Message-ID: <017c01d0e94a$31ec3600$95c4a200$@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <fc3dabfbff09f5c70affdde2996f3658b2000825.1441370053.git.p.fedin@samsung.com>
 <55E9A267.4040404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55E9A267.4040404@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > +	mmio.is_write = is_write;
> > +
> > +	if (attr->attr & KVM_DEV_ARM_VGIC_64BIT) {
> > +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> > +		__le64 data;
> > +
> > +		if (is_write) {
> > +			u64 reg;
> > +
> > +			if (get_user(reg, uaddr))
> 
> Wouldn't the use of copy_from_user/copy_to_user here make this whole
> switch redundant? Even if not, you could think about moving this logic
> into into vgic_attr_regs_access() and just hardcode "len=4" into GICv2
> accesses.

 No, because endianess conversion is still strongly typed. And this ends up in:

if (is_write) {
	u64 reg;
	__le64 data;

	copy_from_user(&reg, uaddr, mmio.len);

	if (mmio.len == 8)
		data = cpu_to_le64(reg);
	else
		*((__le32 *)&data) = cpu_to_le32(*((__le32 *)&reg);

isn't this even more ugly? Regardless of where it is placed.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


