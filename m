Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E27C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 10 Oct 2022 04:10:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF174B0C2;
	Mon, 10 Oct 2022 00:10:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pIyEYswOCnJB; Mon, 10 Oct 2022 00:10:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E06BE4120D;
	Mon, 10 Oct 2022 00:10:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 302EE4120D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 00:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yrOaQhXYo6oZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 00:10:29 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8C5340C23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 00:10:29 -0400 (EDT)
Date: Mon, 10 Oct 2022 04:10:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665375028;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Cmx7UC5ERbZvs6NltikBKO+6xKGttyQo1AEh/wBpODM=;
 b=mWnNl9esZ4y1R7iZLuV38Ia7gZTlaSRQxos7LCRu9JrUofDzcFj4pgoUkfZa9sSZtDlTEx
 u1tilWLnPq16Hnl1a0BT5mPphvQ9yAzQe3k7kzjl1eNBcFcSqnXYXeDgFNYSa0RM55JLGO
 RHyqL7uUKo6dN+egY/xOYyt/ETSk4GY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Fix multiple versions of GIC
 creation
Message-ID: <Y0ObL7C7/93Q8d5T@google.com>
References: <20221009033131.365-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221009033131.365-1-yuzenghui@huawei.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sun, Oct 09, 2022 at 11:31:31AM +0800, Zenghui Yu wrote:
> Commit 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to
> separate helper") wrongly converted a "real" GIC device creation to
> __kvm_test_create_device() and caused the test failure on my D05 (which
> supports v2 emulation). Fix it.
> 
> Fixes: 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separate helper")
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver

> ---
>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index e05ecb31823f..9c131d977a1b 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -662,8 +662,8 @@ int test_kvm_device(uint32_t gic_dev_type)
>  					     : KVM_DEV_TYPE_ARM_VGIC_V2;
>  
>  	if (!__kvm_test_create_device(v.vm, other)) {
> -		ret = __kvm_test_create_device(v.vm, other);
> -		TEST_ASSERT(ret && (errno == EINVAL || errno == EEXIST),
> +		ret = __kvm_create_device(v.vm, other);
> +		TEST_ASSERT(ret < 0 && (errno == EINVAL || errno == EEXIST),
>  				"create GIC device while other version exists");
>  	}
>  
> -- 
> 2.33.0
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
