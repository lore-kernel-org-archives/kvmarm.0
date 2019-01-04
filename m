From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 07/13] arm64: add basic pointer authentication support
Date: Fri, 4 Jan 2019 09:21:30 +0000
Message-ID: <681a2835-1a70-f3c3-3534-7b4cf6139cac@arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-8-kristina.martsenko@arm.com>
 <20190103202901.GA21564@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9216A4A3AC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 04:21:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PxouxvAQeZXg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jan 2019 04:21:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 627E84A3A4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jan 2019 04:21:35 -0500 (EST)
In-Reply-To: <20190103202901.GA21564@amd>
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
To: Pavel Machek <pavel@ucw.cz>, Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-kernel@vger.kernel.org, Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Richard Henderson <richard.henderson@linaro.org>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/01/2019 20:29, Pavel Machek wrote:
> On Fri 2018-12-07 18:39:25, Kristina Martsenko wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>> 
>> This patch adds basic support for pointer authentication,
>> allowing userspace to make use of APIAKey, APIBKey, APDAKey,
>> APDBKey, and APGAKey. The kernel maintains key values for each
>> process (shared by all threads within), which are initialised to
>> random values at exec()
> time.
> 
> ...
> 
>> +/* + * We give each process its own keys, which are shared by
>> all threads. The keys + * are inherited upon fork(), and
>> reinitialised upon exec*(). + */ +struct ptrauth_keys { +	struct
>> ptrauth_key apia; +	struct ptrauth_key apib; +	struct ptrauth_key
>> apda; +	struct ptrauth_key apdb; +	struct ptrauth_key apga; +};
> 
> intstruction_a, data_a, generic_a? Should be easier to understand
> than "apdb" ...

... until you realize that these names do match the documentation,
which makes it even easier to understand how the code uses the
architecture.

	M.
-- 
Jazz is not dead. It just smells funny...
