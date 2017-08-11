From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 07/11] arm64: add basic pointer authentication support
Date: Fri, 11 Aug 2017 09:45:19 +0100
Message-ID: <20170811084516.GQ6321@e103592.cambridge.arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <1500480092-28480-8-git-send-email-mark.rutland@arm.com>
 <5a919df5-7f6d-2c6c-9c8e-e28fcebd4920@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3A9440FA7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Aug 2017 04:43:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TxlMvVOqr4oa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Aug 2017 04:43:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65AF240A86
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Aug 2017 04:43:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <5a919df5-7f6d-2c6c-9c8e-e28fcebd4920@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yao Qi <yao.qi@arm.com>
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 11, 2017 at 08:46:28AM +0100, Yao Qi wrote:
> Hi Mark,
> 
> On 19/07/17 17:01, Mark Rutland wrote:
> >+#define HWCAP_APIA           (1 << 16)
> 
> Can you rename it to HWCAP_ARM64_APIA or HWCAP_ARM_APIA?  When we
> use it in user space, at least in GDB, we usually do this,
> 
> #ifndef HWCAP_APIA
> #define HWCAP_APIA (1 << 16)
> #endif
> 
> However, the code use this macro can be compiled on !arm64 host.
> If HWCAP_APIA is defined on other !arm64 host and its value is not
> (1 << 16), the program "aarch64_hwcap & HWCAP_APIA ? XXX : XXX;" is
> wrong, and compiler doesn't complain.
> 
> I notice that mips, mn10300, sparc, and s390 define their HWCAP this
> way, like HWCAP_SPARC_FLUSH, HWCAP_MIPS_R6, HWCAP_S390_DFP, etc.

(Sticking my oar in because this would apply to HWCAP_SVE too.)

It would have been a good idea I guess, but historically arm, arm64, x86
(for the one HWCAP2_* flag I can find) and unicore32 don't do this.
That can't change now without an API break, and changing the naming
scheme just for new hwcaps just seems messy.

Including multiple arches' headers in the same compilation unit isn't
guaranteed to work sensibly at all AFAICT -- it seems best no to rely
on it.

In the above, you could be doing something like

#ifdef HWCAP_APIA
#if HWCAP_APIA != (1 << 16)
#error "HWCAP_APIA value mismatch"
#else
#undef HWCAP_APIA
#endif
#endif

#define HWCAP_APIA (1 << 16)

...or...

#define HWCAP_ARM64_APIA (1 << 16)

(i.e., unconditionally, and with a well-behaved compile-time error if
there is a definition already).

[...]

Cheers
---Dave
