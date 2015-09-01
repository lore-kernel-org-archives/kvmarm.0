From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] KVM: arm64: Implement accessors for vGIC CPU
 interface registers
Date: Tue, 1 Sep 2015 16:06:55 +0200
Message-ID: <20150901140655.GF10991@cbox>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <2857f7cad7c17109dfa3028f79af28893c0171ce.1440766141.git.p.fedin@samsung.com>
 <20150830165015.GE24113@cbox>
 <010801d0e4b7$698757d0$3c960770$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <010801d0e4b7$698757d0$3c960770$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 01, 2015 at 04:09:18PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > Have you thought about proper locking/serializing of access to the GIC
> > state in these accessor functions?  
> 
>  I am in the process of rewriting the whole thing, and i came to this point.
>  What kind of locking  would you expect ? It's a CPU interface, it does not affect state of any
> other vCPUs. And, since i am getting/setting its registers, i assume that the vCPU is not running.
> Well, i added the check. What next?
> 
I think we make some assumptions throughout the vgic code that only the
vcpu itself touches the state of the registers.  Maybe there is no need
for additional locking, but I'd sleep better at night if I knew that
whoever implemented save/restore logic had thought about concurrency.

-Christoffer
