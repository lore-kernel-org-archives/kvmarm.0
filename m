From: Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH v2 12/17] arm64: KVM: Add ARCH_WORKAROUND_2 support for
 guests
Date: Sat, 9 Jun 2018 09:09:35 -0400
Message-ID: <98318e6c-adcd-ddb8-ad92-e7c1fa771c84@jonmasters.org>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
 <20180529121121.24927-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529121121.24927-13-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>, Randy Dunlap <rdunlap@infradead.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/29/2018 08:11 AM, Marc Zyngier wrote:
> In order to offer ARCH_WORKAROUND_2 support to guests, we need
> a bit of infrastructure.
> 
> Let's add a flag indicating whether or not the guest uses
> SSBD mitigation. Depending on the state of this flag, allow
> KVM to disable ARCH_WORKAROUND_2 before entering the guest,
> and enable it when exiting it.

...Live migration?

Jon.
