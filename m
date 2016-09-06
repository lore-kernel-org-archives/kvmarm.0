From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 3/7] arm: KVM: Use common AArch32 conditional
 execution code
Date: Tue, 6 Sep 2016 12:53:49 +0200
Message-ID: <20160906105349.GM30513@cbox>
References: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
 <1473150527-4729-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473150527-4729-4-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 06, 2016 at 09:28:43AM +0100, Marc Zyngier wrote:
> Add the bit of glue and const-ification that is required to use
> the code inherited from the arm64 port, and move over to it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
