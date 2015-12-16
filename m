From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: debug: Remove spurious inline attributes
Date: Wed, 16 Dec 2015 21:45:51 +0100
Message-ID: <20151216204551.GG24889@cbox>
References: <1450280963-19985-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450280963-19985-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.bennee@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 16, 2015 at 03:49:23PM +0000, Marc Zyngier wrote:
> The debug trapping code is pretty heavy on the "inline" attribute,
> but most functions are actually referenced in the sysreg tables,
> making the inlining imposible.
> 
> Removing the useless inline qualifier seems the right thing to do,
> having verified that the output code is similar.

To quote Rusty when he reviewd some of my first KVM patches:
  "I consider inline the register keyword of the 90s"

You can take that as an:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
