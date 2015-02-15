From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] ARM: KVM: Fix size check in __coherent_cache_guest_page
Date: Sun, 15 Feb 2015 21:22:24 +0100
Message-ID: <20150215202224.GD8034@cbox>
References: <54D670EA.2090504@web.de>
 <20150207202648.53857923@arm.com>
 <54D678EA.90803@web.de>
 <54D681D0.8040309@web.de>
 <20150213045735.GB47577@lvm>
 <54DE7595.7090504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54DE7595.7090504@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Marc Zyngier <marc.zyngier@arm.com>, kvm <kvm@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 13, 2015 at 11:07:17PM +0100, Paolo Bonzini wrote:
> 
> 
> On 13/02/2015 05:57, Christoffer Dall wrote:
> > On Sat, Feb 07, 2015 at 10:21:20PM +0100, Jan Kiszka wrote:
> >> From: Jan Kiszka <jan.kiszka@siemens.com>
> >> 
> >> The check is supposed to catch page-unaligned sizes, not the
> >> inverse.
> >> 
> >> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> > 
> > Thanks, applied.
> 
> Thanks, can you send a pull request as soon as possible with this and
> "arm/arm64: KVM: Add exit reaons to kvm_exit event tracing"?
> 
Yep, done.

Thanks,
-Christoffer
