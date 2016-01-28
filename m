From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v10 10/21] KVM: ARM64: Add access handler for PMCNTENSET
 and PMCNTENCLR register
Date: Thu, 28 Jan 2016 19:12:25 +0100
Message-ID: <20160128181225.GB16453@hawk.localdomain>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-11-git-send-email-zhaoshenglong@huawei.com>
 <20160128180856.GA16453@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160128180856.GA16453@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 28, 2016 at 07:08:56PM +0100, Andrew Jones wrote:
> On Wed, Jan 27, 2016 at 11:51:38AM +0800, Shannon Zhao wrote:
> > @@ -804,10 +831,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  	  access_pmcr, reset_pmcr, },
> >  	/* PMCNTENSET_EL0 */
> >  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
> > -	  trap_raz_wi },
> > +	  access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
> >  	/* PMCNTENCLR_EL0 */
> >  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b010),
> > -	  trap_raz_wi },
> > +	  access_pmcnten, NULL, PMCNTENSET_EL0 },
> 
> I don't think the reg field is needed, as the reset handler isn't
> defined and the access handler doesn't use it. Oh, and shouldn't it be
> PMCNTENCLR_EL0 anyway?

eh.. nevermind. Of course we just have the one sys_reg for both set/clr...
