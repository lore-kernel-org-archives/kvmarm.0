Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D0FC38A2D
	for <kvmarm@archiver.kernel.org>; Mon, 24 Oct 2022 23:18:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F5254B693;
	Mon, 24 Oct 2022 19:18:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 67ODlLqpxHJQ; Mon, 24 Oct 2022 19:18:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E624B640;
	Mon, 24 Oct 2022 19:18:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38D754B256
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 19:18:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LRAzh5j02FI5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Oct 2022 19:18:37 -0400 (EDT)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 495704B125
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2022 19:18:37 -0400 (EDT)
Received: from MUA by vps-vb.mhejs.net with esmtps (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <mail@maciej.szmigiero.name>)
 id 1on6iG-000850-Py; Tue, 25 Oct 2022 01:18:32 +0200
Message-ID: <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
Date: Tue, 25 Oct 2022 01:18:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 0/6] KVM: selftests: memslot_perf_test: aarch64
 cleanup/fixes
Content-Language: en-US, pl-PL
To: Gavin Shan <gshan@redhat.com>
References: <20221020071209.559062-1-gshan@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20221020071209.559062-1-gshan@redhat.com>
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

On 20.10.2022 09:12, Gavin Shan wrote:
> kvm/selftests/memslots_perf_test doesn't work with 64KB-page-size-host
> and 4KB-page-size-guest on aarch64. In the implementation, the host and
> guest page size have been hardcoded to 4KB. It's ovbiously not working
> on aarch64 which supports 4KB, 16KB, 64KB individually on host and guest.
> 
> This series tries to fix it. After the series is applied, the test runs
> successfully with 64KB-page-size-host and 4KB-page-size-guest.
> 
>     # ./memslots_perf_tests -v -s 512
> 
> Since we're here, the code is cleaned up a bit as PATCH[1-3] do. The
> other patches are fixes to handle the mismatched host/guest page
> sized.
> 
> v1: https://lore.kernel.org/kvmarm/20221014071914.227134-1-gshan@redhat.com/T/#t
> v2: https://lore.kernel.org/kvmarm/20221018040454.405719-1-gshan@redhat.com/T/#t
> 
> Changelog
> =========
> v3:
>    * Improved comments about MEM_TEST_MOVE_SIZE, which is set
>      to 64KB in PATCH[v3 4/6] and finally fixed to 192KB in
>      PATCH[v3 5/6].                                              (Maciej)
>    * Use size instead of pages to do the comparison in
>      test_memslot_move_prepare()                                 (Maciej)
>    * Use tools/include/linux/sizes.h instead of inventing
>      our own macros.                                             (Oliver)
> v2:
>    * Pick the smaller value between the ones specified by
>      user or probed from KVM_CAP_NR_MEMSLOTS in PATCH[v2 3/6]    (Maciej)
>    * Improved comments about MEM_TEST_MOVE_SIZE in
>      PATCH[v2 4/6]                                               (Maciej)
>    * Avoid mismatched guest page size after VM is started in
>      prepare_vm() in PATCH[v2 4/6]                               (Maciej)
>    * Fix condition to check MEM_TEST_{UNMAP, UNMAP_CHUNK}_SIZE
>      in check_memory_size() in PATCH[v2 4/6]                     (Maciej)
>    * Define base and huge page size in kvm_util_base.h in
>      PATCH[v2 5/6]                                               (Sean)
>    * Add checks on host/guest page size in check_memory_size()
>      and fail early if any of them exceeds 64KB in PATCH[v2 5/6] (Maciej)
> 
> 
> Gavin Shan (6):
>    KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
>    KVM: selftests: memslot_perf_test: Consolidate loop conditions in
>      prepare_vm()
>    KVM: selftests: memslot_perf_test: Probe memory slots for once
>    KVM: selftests: memslot_perf_test: Support variable guest page size
>    KVM: selftests: memslot_perf_test: Consolidate memory
>    KVM: selftests: memslot_perf_test: Report optimal memory slots
> 

This patch set now looks good to me, so for the whole series:
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
