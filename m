From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH kvmtool 3/6] Makefile: support -s switch
Date: Wed, 30 Jan 2019 18:20:28 +0000
Message-ID: <20190130182028.GG18558@fuggles.cambridge.arm.com>
References: <20190125180801.209910-1-andre.przywara@arm.com>
 <20190125180801.209910-4-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A51704A32D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 13:20:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JtK3ogMmtkrY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 13:20:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2D6D4A37D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 13:20:31 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190125180801.209910-4-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 25, 2019 at 06:07:58PM +0000, Andre Przywara wrote:
> "make -s" suppresses normal output, just shows warnings and errors.
> But since we explicitly override the make output with our fancy concise
> version, we miss out on this feature.
> 
> Do as the kernel does and explicitly suppress every normal output when -s
> is given. This helps to spot warnings that scroll out of the terminal
> window too quickly.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Makefile | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index c4faff66..a68cfcd5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -2,8 +2,22 @@
>  # Define WERROR=0 to disable -Werror.
>  #
>  
> +ifneq ($(filter 4.%,$(MAKE_VERSION)),)  # make-4
> +ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)
> +  silent=1
> +endif
> +else                                    # make-3.8x
> +ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
> +  silent=1
> +endif
> +endif

Why do we need to do this differently for different versions of Make?
afaict, the kernel manages this using findstring and filter-out.

Will
