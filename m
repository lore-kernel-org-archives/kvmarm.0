From: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: [PATCH 11/12] avoid using predefined PAGE_SIZE
Date: Fri, 17 Jul 2015 17:47:10 +0100
Message-ID: <55A9318E.1000700@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com> <1437148938-5394-12-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437148938-5394-12-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/07/15 17:02, Andre Przywara wrote:
> The musl-libc comes with a predefined PAGE_SIZE macro, which may be
> wrong on systems which support multiple smallest page sizes.
> Make sure we use our own (runtime evaluated) definition of PAGE_SIZE.
>

musl only provides PAGE_SIZE on archs where it is
constant, if not, that's a musl bug and should be
fixed there (this is a posix requirement).

the ifdef does not help around this: musl sysconf
will return the same value as you get from the
header (it would be a conformance bug otherwise).

use

#include <limits.h>
#ifndef PAGE_SIZE
#define PAGE_SIZE sysconf(_SC_PAGE_SIZE)
#endif

> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/kvm.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 9818046..8b12cd6 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -19,6 +19,10 @@
>  #define HOME_DIR             getenv("HOME")
>  #define KVM_BINARY_NAME              "lkvm"
>
> +/* Let's determine the actual page size at runtime. */
> +#ifdef PAGE_SIZE
> +#undef PAGE_SIZE
> +#endif
>  #define PAGE_SIZE (sysconf(_SC_PAGE_SIZE))
>
>  #define DEFINE_KVM_EXT(ext)          \
>


-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782

