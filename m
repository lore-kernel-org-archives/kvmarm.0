From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm/arm64: KVM: fix missing unlock on error in
 kvm_vgic_create()
Date: Mon, 2 Mar 2015 09:29:47 -0800
Message-ID: <20150302172947.GC10137@lvm>
References: <1425037305-23292-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425037305-23292-1-git-send-email-weiyj_lk@163.com>
Sender: kvm-owner@vger.kernel.org
To: weiyj_lk@163.com
Cc: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 27, 2015 at 07:41:45PM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function kvm_vgic_create()
> in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, applied.
-Christoffer
