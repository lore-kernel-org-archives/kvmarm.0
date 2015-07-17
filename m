From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 07/12] util/util.c: avoid clang error on vsnprintf
Date: Fri, 17 Jul 2015 17:50:28 +0100
Message-ID: <20150717165028.GE8055@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
 <1437148938-5394-8-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437148938-5394-8-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 17, 2015 at 05:02:13PM +0100, Andre Przywara wrote:
> clang by default doesn't seem to like printf calls with non-literal
> format strings.
> Add the proper pragma to disable this warning in the report function
> to make kvmtool compile with clang. Despite its GCC name, clang also
> accepts this.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  util/util.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/util/util.c b/util/util.c
> index 1877105..825da3f 100644
> --- a/util/util.c
> +++ b/util/util.c
> @@ -10,6 +10,7 @@
>  #include <sys/stat.h>
>  #include <sys/statfs.h>
>  
> +#pragma GCC diagnostic ignored "-Wformat-nonliteral"

Urgh! I think we need to figure out a better way to keep clang happy in
this regard, if we decide that we care about building with it.

Will
