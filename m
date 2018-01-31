From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PULL 01/28] arm64: KVM: Hide PMU from guests when disabled
Date: Wed, 31 Jan 2018 11:54:31 +0100
Message-ID: <20180131105431.fsvyaeffujzwh2lu@kamzik.brq.redhat.com>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
 <20180131093507.22219-2-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180131093507.22219-2-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 31, 2018 at 10:34:40AM +0100, Christoffer Dall wrote:
> From: Andrew Jones <drjones@redhat.com>
> 
> Since commit 93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU
> features from guests") we can hide cpu features from guests. Apply
> this to a long standing issue where guests see a PMU available, but
> it's not, because it was not enabled by KVM's userspace.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
>

Hi Christoffer,

I think this patch got into the PULL by mistake, because you pointed out
to me a while back that it broke migration.

Thanks for the reminder to go and try to fix it though!

Thanks,
drew
