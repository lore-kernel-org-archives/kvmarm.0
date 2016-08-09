From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3] KVM: arm64: ITS: return 1 on successful MSI injection
Date: Tue, 9 Aug 2016 16:43:51 +0200
Message-ID: <20160809144351.GH9175@cbox>
References: <20160808162928.26441-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160808162928.26441-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 08, 2016 at 05:29:28PM +0100, Andre Przywara wrote:
> According to the KVM API documentation a successful MSI injection
> should return a value > 0 on success.
> Return possible errors in vgic_its_trigger_msi() and report a
> successful injection back to userland, while also reporting the
> case where the MSI could not be delivered due to the guest not
> having the LPI mapped, for instance.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Applied.  Thanks!

-Christoffer
