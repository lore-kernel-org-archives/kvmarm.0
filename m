From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 10/21] arm64: KVM: Add patchable function selector
Date: Wed, 2 Dec 2015 16:34:56 -0600
Message-ID: <20151202223456.GK3233@hawk.localdomain>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-11-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448650215-15218-11-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 27, 2015 at 06:50:04PM +0000, Marc Zyngier wrote:
> KVM so far relies on code patching, and is likely to use it more
> in the future. The main issue is that our alternative system works
> at the instruction level, while we'd like to have alternatives at
> the function level.

How about setting static-keys at hyp init time?

Thanks,
drew
