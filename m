From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 08/13] arm64: expose user PAC bit positions via ptrace
Date: Sun, 9 Dec 2018 09:41:31 -0600
Message-ID: <a31ca10a-ee1a-71fb-2c3d-a6184e12b543@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-9-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B476B4A331
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Dec 2018 10:41:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eP2u0x4bdvGi for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Dec 2018 10:41:36 -0500 (EST)
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com
 [209.85.210.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C8A34A1FA
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Dec 2018 10:41:36 -0500 (EST)
Received: by mail-ot1-f68.google.com with SMTP id v23so8140857otk.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 Dec 2018 07:41:36 -0800 (PST)
In-Reply-To: <20181207183931.4285-9-kristina.martsenko@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 12/7/18 12:39 PM, Kristina Martsenko wrote:
> When pointer authentication is in use, data/instruction pointers have a
> number of PAC bits inserted into them. The number and position of these
> bits depends on the configured TCR_ELx.TxSZ and whether tagging is
> enabled. ARMv8.3 allows tagging to differ for instruction and data
> pointers.

At this point I think it's worth starting a discussion about pointer tagging,
and how we can make it controllable and not mandatory.

With this patch set, we are enabling 7 authentication bits: [54:48].

However, it won't be too long before someone implements support for
ARMv8.2-LVA, at which point, without changes to mandatory pointer tagging, we
will only have 3 authentication bits: [54:52].  This seems useless and easily
brute-force-able.

I assume that pointer tagging is primarily used by Android, since I'm not aware
of anything else that uses it at all.

Unfortunately, there is no obvious path to making this optional that does not
break compatibility with Documentation/arm64/tagged-pointers.txt.

I've been thinking that there ought to be some sort of global setting, akin to
/proc/sys/kernel/randomize_va_space, as well as a prctl which an application
could use to selectively enable TBI/TBID for an application that actually uses
tagging.

The global /proc setting allows the default to remain 1, which would let any
application using tagging to continue working.  If there are none, the sysadmin
can set the default to 0.  Going forward, applications could be updated to use
the prctl, allowing more systems to set the default to 0.

FWIW, pointer authentication continues to work when enabling TBI, but not the
other way around.  Thus the prctl could be used to enable TBI at any point, but
if libc is built with PAuth, there's no way to turn it back off again.



r~
