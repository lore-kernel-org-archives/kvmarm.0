From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 02/28] ARM: KVM: Remove
 __kvm_hyp_code_start/__kvm_hyp_code_end
Date: Tue, 9 Feb 2016 19:39:59 +0100
Message-ID: <20160209183959.GG5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-3-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:19AM +0000, Marc Zyngier wrote:
> Now that we've unified the way we refer to the HYP text between
> arm and arm64, drop __kvm_hyp_code_start/end, and just use the
> __hyp_text_start/end symbols.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
