From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH v5 07/17] arm64: add basic pointer authentication support
Date: Fri, 19 Oct 2018 19:49:27 +0300
Message-ID: <20181019164927.GO2401@uranus.lan>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-8-kristina.martsenko@arm.com>
 <20181019111542.6wrvjguirglzg7vg@mbp>
 <20181019112404.GD14246@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181019112404.GD14246@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, linux-arch@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Jacob Bramley <jacob.bramley@arm.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Adam Wallis <awallis@codeaurora.org>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <Amit.Kachhap@arm.com>, Dave P Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andrey Vagin <avagin@gmail.>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 19, 2018 at 12:24:04PM +0100, Will Deacon wrote:
> 
> FWIW: I think we should be entertaining a prctl() interface to use a new
> key on a per-thread basis. Obviously, this would need to be used with care
> (e.g. you'd fork(); use the prctl() and then you'd better not return from
> the calling function!).
> 
> Assuming we want this (Kees -- I was under the impression that everything in
> Android would end up with the same key otherwise?), then the question is
> do we want:
> 
>   - prctl() get/set operations for the key, or
>   - prctl() set_random_key operation, or
>   - both of the above?
> 
> Part of the answer to that may lie in the requirements of CRIU, where I
> strongly suspect they need explicit get/set operations, although these
> could be gated on CONFIG_CHECKPOINT_RESTORE=y.

Indeed. Without get/set I think we won't be able to restore programs.
