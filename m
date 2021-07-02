Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B80C11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 06:47:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA14361402
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 06:47:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA14361402
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35FC14B097;
	Fri,  2 Jul 2021 02:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KlhqZd1P67mi; Fri,  2 Jul 2021 02:47:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DFBC4B08F;
	Fri,  2 Jul 2021 02:47:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89BB340808
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 02:47:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dF-6xKx5dEhn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 02:47:04 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 525CF407F4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 02:47:04 -0400 (EDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GGQW75Sbkz74Bs;
 Fri,  2 Jul 2021 14:42:43 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 14:46:59 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 2 Jul 2021 14:46:58 +0800
Subject: Re: [PATCH v4 5/6] KVM: selftests: Add exception handling support for
 aarch64
To: Ricardo Koller <ricarkol@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-6-ricarkol@google.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b1f581ec-56f4-24a2-7850-182128cdc4ac@huawei.com>
Date: Fri, 2 Jul 2021 14:46:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210611011020.3420067-6-ricarkol@google.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org,
 Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

[+Sean]

On 2021/6/11 9:10, Ricardo Koller wrote:
> Add the infrastructure needed to enable exception handling in aarch64
> selftests. The exception handling defaults to an unhandled-exception
> handler which aborts the test, just like x86. These handlers can be
> overridden by calling vm_install_exception_handler(vector) or
> vm_install_sync_handler(vector, ec). The unhandled exception reporting
> from the guest is done using the ucall type introduced in a previous
> commit, UCALL_UNHANDLED.
> 
> The exception handling code is inspired on kvm-unit-tests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/include/aarch64/processor.h |  63 +++++++++
>  .../selftests/kvm/lib/aarch64/handlers.S      | 126 ++++++++++++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     |  97 ++++++++++++++
>  4 files changed, 287 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

[...]

> +void vm_init_descriptor_tables(struct kvm_vm *vm)
> +{
> +	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> +			vm->page_size, 0, 0);

This raced with commit a75a895e6457 ("KVM: selftests: Unconditionally
use memslot 0 for vaddr allocations") which dropped memslot parameters
from vm_vaddr_alloc().

We can remove the related comments on top of vm_vaddr_alloc() as well.

Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
