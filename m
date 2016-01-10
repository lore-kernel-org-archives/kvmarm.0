From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 3/6] arm/arm64: KVM: Enable armv7 fp/simd enhanced
 context switch
Date: Sun, 10 Jan 2016 17:32:09 +0100
Message-ID: <20160110163209.GE30867@cbox>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
 <1451166900-3711-4-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451166900-3711-4-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Dec 26, 2015 at 01:54:57PM -0800, Mario Smarduch wrote:
> Enable armv7 enhanced fp/simd context switch. Guest and host registers are only
> context switched on first access and vcpu put. 
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
