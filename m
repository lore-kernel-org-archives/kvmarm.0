From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 02/20] arm64: Implement arch_counter_get_cntpct to read the physical counter
Date: Wed, 25 Oct 2017 14:41:16 +0100
Message-ID: <86she7cpkz.fsf@arm.com>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
        <20171020114939.12554-3-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-3-christoffer.dall@linaro.org> (Christoffer
        Dall's message of "Fri, 20 Oct 2017 13:49:21 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20 2017 at  1:49:21 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> As we are about to use the physical counter on arm64 systems that have
> KVM support, implement arch_counter_get_cntpct() and the associated
> errata workaround functionality for stable timer reads.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
