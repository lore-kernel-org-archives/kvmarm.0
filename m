From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v3 01/10] lib: xstr: allow
 multiple args
Date: Tue, 30 Aug 2016 16:28:16 +0200
Message-ID: <827721e5-8343-42f7-f737-ac315164ea67@redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
 <1468587641-7300-2-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C05C240FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 10:20:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WuziQ3+5Vwj9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 10:20:16 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA78440FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 10:20:16 -0400 (EDT)
In-Reply-To: <1468587641-7300-2-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu


Hi Drew,
On 15/07/2016 15:00, Andrew Jones wrote:
> Make implementation equivalent to Linux's include/linux/stringify.h
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/libcflat.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 72b1bf9668ef1..82005f5d014fb 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -27,8 +27,8 @@
>  
>  #define __unused __attribute__((__unused__))
>  
> -#define xstr(s) xxstr(s)
> -#define xxstr(s) #s
> +#define xstr(s...) xxstr(s)
> +#define xxstr(s...) #s
>  
>  #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
>  #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
