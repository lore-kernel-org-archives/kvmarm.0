From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 06/28] ARM: KVM: Add a HYP-specific header file
Date: Tue, 9 Feb 2016 19:42:23 +0100
Message-ID: <20160209184223.GK5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-7-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-7-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:23AM +0000, Marc Zyngier wrote:
> In order to expose the various HYP services that are private to
> the hypervisor, add a new hyp.h file.
> 
> So far, it only contains mundane things such as section annotation
> and VA manipulation.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
