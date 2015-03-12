From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/3] arm/arm64: KVM: Allow handle_hva_to_gpa to return a
 value
Date: Thu, 12 Mar 2015 12:40:04 +0100
Message-ID: <20150312114004.GA28863@cbox>
References: <1421865733-20034-1-git-send-email-marc.zyngier@arm.com>
 <1421865733-20034-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1421865733-20034-2-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Steve Capper <steve.capper@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 21, 2015 at 06:42:11PM +0000, Marc Zyngier wrote:
> So far, handle_hva_to_gpa was never required to return a value.
> As we prepare to age pages at Stage-2, we need to be able to
> return a value from the iterator (kvm_test_age_hva).
> 
> Adapt the code to handle this situation. No semantic change.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
