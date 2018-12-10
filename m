From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v6 02/13] arm64: add pointer authentication register bits
Date: Mon, 10 Dec 2018 19:54:25 +0000
Message-ID: <1e72484b-f89f-eacd-1976-14fdf6f23e26@arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-3-kristina.martsenko@arm.com>
 <ef051a9b-d58f-07af-a446-4b7326ff9311@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA434A2B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 14:54:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ALeU1rHAkp5d for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 14:54:36 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E7E44A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 14:54:36 -0500 (EST)
In-Reply-To: <ef051a9b-d58f-07af-a446-4b7326ff9311@linaro.org>
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
To: Richard Henderson <richard.henderson@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/12/2018 14:24, Richard Henderson wrote:
> On 12/7/18 12:39 PM, Kristina Martsenko wrote:
>>  #define SCTLR_ELx_DSSBS	(1UL << 44)
>> +#define SCTLR_ELx_ENIA	(1 << 31)
> 
> 1U or 1UL lest you produce signed -0x80000000.

Thanks, this was setting all SCTLR bits above 31 as well... Now fixed.

> Otherwise,
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Thanks for all the review!

Kristina
