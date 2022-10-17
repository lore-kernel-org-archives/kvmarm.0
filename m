Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8EEC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 06:31:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CADCE4B88C;
	Wed, 19 Oct 2022 02:31:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RFugzycRzwmw; Wed, 19 Oct 2022 02:31:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF0724B919;
	Wed, 19 Oct 2022 02:31:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 675A44B796
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 17:36:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h+KHrhm+zPQ2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 17:36:13 -0400 (EDT)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9293D4B6B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 17:36:13 -0400 (EDT)
Received: from MUA by vps-vb.mhejs.net with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <mail@maciej.szmigiero.name>)
 id 1okXmL-0001p3-Ku; Mon, 17 Oct 2022 23:36:09 +0200
Message-ID: <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
Date: Mon, 17 Oct 2022 23:36:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US, pl-PL
To: Gavin Shan <gshan@redhat.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
In-Reply-To: <20221014071914.227134-6-gshan@redhat.com>
X-Mailman-Approved-At: Wed, 19 Oct 2022 02:31:08 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 14.10.2022 09:19, Gavin Shan wrote:
> The addresses and sizes passed to madvise() and vm_userspace_mem_region_add()
> should be aligned to host page size, which can be 64KB on aarch64. So it's
> wrong by passing additional fixed 4KB memory area to various tests.
> 
> Fix it by passing additional fixed 64KB memory area to various tests. After
> it's applied, the following command works fine on 64KB-page-size-host and
> 4KB-page-size-guest.
> 
>    # ./memslot_perf_test -v -s 512
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   .../testing/selftests/kvm/memslot_perf_test.c  | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
> index d587bd952ff9..e6d34744b45d 100644
> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
> @@ -25,12 +25,14 @@
>   #include <kvm_util.h>
>   #include <processor.h>
>   
> -#define MEM_SIZE		((512U << 20) + 4096)
> -#define MEM_GPA		0x10000000UL
> +#define MEM_EXTRA_SIZE		0x10000

So the biggest page size supported right now is 64 KiB - it would be
good to have an assert somewhere to explicitly check for this
(regardless of implicit checks present in other calculations).

Also, an expression like "(64 << 10)" is more readable than a "1"
with a tail of zeroes (it's easy to add one zero too many or be one
zero short).

Thanks,
Maciej

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
