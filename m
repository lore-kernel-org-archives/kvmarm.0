From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/3] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Mon, 31 Aug 2015 10:59:15 +0200
Message-ID: <20150831085915.GI24113@cbox>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <cb311e13e56311c535362f32177313850c51af66.1440766141.git.p.fedin@samsung.com>
 <20150830164237.GD24113@cbox>
 <013f01d0e3bf$8ed1fed0$ac75fc70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <013f01d0e3bf$8ed1fed0$ac75fc70$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 31, 2015 at 10:35:05AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > > +	len = vgic_v3_get_reg_size(attr);
> > > +	if (len < 0)
> > > +		return len;
> > >
> > > -	return -ENXIO;
> > > +	ret = vgic_v3_attr_regs_access(dev, attr, (len == 8) ? (void *)&reg64 :
> > > +					(void *)&reg, len, false);
> > 
> > this use of the ternary operator is terrible, but it should be solved if
> > you always use a u64 for the reg parameter.
> 
>  I also dislike this, but this is the best thing i could invent. This is dictated by put_user() and
> get_user(), which rely on typeof() of their arguments. Well, i could do some castings, but they are
> no less ugly, and would give more headache to bigendian systems.
> However, what about doing the same thing as GET/SET_ONE_REG does by just assuming that everything is
> 64-bit wide? This would automatically resolve two other issues you have commented on. By the way,
> handling it in userspace would also be simpler.
> 
Sounds fine to me, definitely if you must do a cast doing it in a
function between typed variables is strictly preferred to passing void *
values between functions.

-Christoffer
