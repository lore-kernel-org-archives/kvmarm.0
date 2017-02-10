From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/4] arm64: mmu: apply strict permissions to .init.text
 and .init.data
Date: Fri, 10 Feb 2017 10:43:53 -0800
Message-ID: <CAGXu5jJgzLZHAcDd4jn_h7+VFujyrQnDVdFc7f-rBotRtvht8A@mail.gmail.com>
References: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org> <1486747005-15973-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6483-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: keescook@google.com
In-Reply-To: <1486747005-15973-5-git-send-email-ard.biesheuvel@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laura Abbott <labbott@fedoraproject.org>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 10, 2017 at 9:16 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> To avoid having mappings that are writable and executable at the same
> time, split the init region into a .init.text region that is mapped
> read-only, and a .init.data region that is mapped non-executable.
>
> This is possible now that the alternative patching occurs via the linear
> mapping, and the linear alias of the init region is always mapped writable
> (but never executable).

Er, so, that means kernel text is still basically RWX... you just
write to the linear mapping and execute the kernel mapping. Can't we
make the linear mapping match the kernel mapping permissions?

-Kees

-- 
Kees Cook
Pixel Security
