From: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: [PATCH v2 26/28] arm64/sve: Add documentation
Date: Fri, 06 Oct 2017 16:43:43 +0100
Message-ID: <59D7A4AF.40408@arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com> <1504198860-12951-27-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1504198860-12951-27-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: nd@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/08/17 18:00, Dave Martin wrote:
> +9.  System runtime configuration
> +--------------------------------
> +
> +* To mitigate the ABI impact of expansion of the signal frame, a policy
> +  mechanism is provided for administrators, distro maintainers and developers
> +  to set the default vector length for userspace processes:
> +
> +/proc/cpu/sve_default_vector_length


elsewhere in the patch series i see

/proc/sys/abi/sve_default_vector_length

is this supposed to be the same?
