From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 3/4] arm64: Use __tlbi() macros in KVM code
Date: Wed, 25 Jan 2017 20:39:43 +0100
Message-ID: <20170125193943.GW15850@cbox>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-3-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125155232.10277-3-cov@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org, Mark Langsdorf <mlangsdo@redhat.com>, Mark Salter <msalter@redhat.com>, Jon Masters <jcm@redhat.com>, Neil Leeder <nleeder@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 25, 2017 at 10:52:31AM -0500, Christopher Covington wrote:
> Refactor the KVM code to use the __tlbi macros, which will allow an errata
> workaround that repeats tlbi dsb sequences to only change one location.
> This is not intended to change the generated assembly and comparing before
> and after vmlinux objdump shows no functional changes.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
