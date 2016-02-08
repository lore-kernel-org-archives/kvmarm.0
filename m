From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 19/23] arm64: KVM: Move most of the fault decoding to C
Date: Mon, 8 Feb 2016 14:44:31 +0000
Message-ID: <20160208144430.GO6076@e104818-lin.cambridge.arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-20-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454522416-6874-20-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 03, 2016 at 06:00:12PM +0000, Marc Zyngier wrote:
> The fault decoding process (including computing the IPA in the case
> of a permission fault) would be much better done in C code, as we
> have a reasonable infrastructure to deal with the VHE/non-VHE
> differences.
> 
> Let's move the whole thing to C, including the workaround for
> erratum 834220, and just patch the odd ESR_EL2 access remaining
> in hyp-entry.S.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
