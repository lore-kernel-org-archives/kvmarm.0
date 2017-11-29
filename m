From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v1 0/2] Additional single-step-cases
Date: Wed, 29 Nov 2017 16:18:05 +0000
Message-ID: <25e0999c-df1a-b25c-6b56-6a63ebcb690d@arm.com>
References: <20171123121134.11050-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171123121134.11050-1-alex.bennee@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 23/11/17 12:11, Alex Bennée wrote:
> Hi,
> 
> This is now split into two patches as the first case of SError is
> separate from behaviour of stepping instructions.
> 
> Alex Bennée (2):
>   kvm: arm64: handle single-step during SError exceptions
>   kvm: arm64: handle single-step of hyp emulated mmio instructions
> 
>  arch/arm64/kvm/handle_exit.c |  8 +++++++-
>  arch/arm64/kvm/hyp/switch.c  | 37 ++++++++++++++++++++++++++++++-------
>  2 files changed, 37 insertions(+), 8 deletions(-)
> 

For both patches:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
