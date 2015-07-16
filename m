From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Introduce default dummy save/restore
 functions
Date: Thu, 16 Jul 2015 15:30:24 +0200
Message-ID: <20150716133024.GF7845@cbox>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <248fcfc798e243b618c5275eef8aa333253fd4da.1436874248.git.p.fedin@samsung.com>
 <55A5007A.4040802@arm.com>
 <020d01d0be35$5d3bab00$17b30100$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <020d01d0be35$5d3bab00$17b30100$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 14, 2015 at 04:02:39PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > You may want to check commit 8a14849, which makes this whole patch
> > irrelevant.
> 
>  Thank you very much for pointing out, i will recheck.
>  My patches are based on linux-stable.git, should i base them on something else?
> 

A recent mainline -rc or kvm/next or kvmarm/next is generally preferred.

Basing upstream patches on stable is a bit weird.

-Christoffer
