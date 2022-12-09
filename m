Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2EC5C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 21:03:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 660214B97D;
	Fri,  9 Dec 2022 16:03:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n4l9JdZmKaJ9; Fri,  9 Dec 2022 16:03:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 356C94B93C;
	Fri,  9 Dec 2022 16:03:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF6A4B920
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 16:03:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ufryqcggF-zD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 16:03:49 -0500 (EST)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D53AE4B918
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 16:03:49 -0500 (EST)
Received: by mail-pl1-f169.google.com with SMTP id t2so3156036ply.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Dec 2022 13:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=HqhkVKX+RdgYCWZiIceLsOHMpWv/ROuczp7qb/H7X1w=;
 b=geRGPSQKUlIYqCU/v/MAful0c2VKh6VA6SBeijyPLtHNmaNPvdTAZRBm+8BK0vMyF7
 oJs/xaNz1FVL8jiMpUauu2wtzHgyNFuSzbsou1/FkQDUTY5R2F/BqoUtLcz7XXJd3ZAO
 Dmk3W82U//fL1/HxmzzBDyZ7VklM1UH74NpwkG3WyTvUXcSDELZRwL14XyE4yxNMMTiP
 7vxNfdzUPeKjtlkEpdgj2U13i8nATEgPias3k43ZtZwrU5RjHtwlN5SiT1tERKN6A3Rk
 WNJjSbXl0byXigqUqjfuCWVXto0wnqtwZ9BO4n+XScjq16D9RNXVrELTuGdILxKMMIaA
 6JaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=HqhkVKX+RdgYCWZiIceLsOHMpWv/ROuczp7qb/H7X1w=;
 b=JwaFng8YVuyFXUV5ZC0QpdlXKp9Y0JeN/fAgpAW8tKjdxzOm0yE0X9JrkOF8HEev6j
 lj28EoYw/ElWBv3Yvwl102KfXvyNEHfUiPHX9nR/1TisyAKO0sEj9ddC+WjbxOUizoyZ
 GWhd2OcikH89mNtM3RMq/JYE6lqb0agFrgpq7kbRTbf9E2tD87oLybm5qxgoEYhL0PsE
 WGFcBpa/MeCQqGU/aN1/SR/RQVok14mL3iAZO3npzPB2uYqUTEQrv4UUzzvijc8szb3a
 cSWVJ56t0nk8B8dO0w44uW7W991v4uAI4LR5LB7X7Kl3UdOELed46BDh4jQD+euitK9a
 WAFQ==
X-Gm-Message-State: ANoB5pl0DV/W8VstbtcThCxRU6kNpbAM2FL4c090NentdTpwqOgnuuZ4
 9FsACBdRABLbfnqV94AY8IxDoQ==
X-Google-Smtp-Source: AA0mqf76S2APEPIqvhNO2xeCJ5k7zOJZF0cOVyP09wKMa17nX0r0d7TDym1CMnQt7VgOPeLCqe8Uuw==
X-Received: by 2002:a05:6a20:7f5c:b0:9d:b8e6:d8e5 with SMTP id
 e28-20020a056a207f5c00b0009db8e6d8e5mr24495pzk.2.1670619828811; 
 Fri, 09 Dec 2022 13:03:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 c11-20020a170903234b00b001885041d7b8sm1722515plh.293.2022.12.09.13.03.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Dec 2022 13:03:48 -0800 (PST)
Date: Fri, 9 Dec 2022 21:03:45 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 7/7] KVM: selftests: Avoid infinite loop if
 ucall_alloc() fails
Message-ID: <Y5OisdH5ohtr6r3j@google.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209015307.1781352-8-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221209015307.1781352-8-oliver.upton@linux.dev>
Cc: linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>, Peter Gonda <pgonda@google.com>,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Dec 09, 2022, Oliver Upton wrote:
> Guest assertions depend on successfully allocating a ucall structure. As
> such, the use of guest assertions when ucall_alloc() fails simply leads
> to an infinite loop in guest code.
> 
> Use GUEST_UCALL_NONE() to indicate failure instead. Though not
> technically necessary, use a goto to have a single callsite and an
> associated comment about why assertions don't work here. It isn't
> perfect, at least the poor developer gets some signal out of the
> guest...
> 
> Fixes: 426729b2cf2e ("KVM: selftests: Add ucall pool based implementation")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/lib/ucall_common.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index 0cc0971ce60e..e8370da3de24 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -41,7 +41,8 @@ static struct ucall *ucall_alloc(void)
>  	struct ucall *uc;
>  	int i;
>  
> -	GUEST_ASSERT(ucall_pool);
> +	if (!ucall_pool)
> +		goto out;
>  
>  	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>  		if (!test_and_set_bit(i, ucall_pool->in_use)) {
> @@ -51,7 +52,14 @@ static struct ucall *ucall_alloc(void)
>  		}
>  	}
>  
> -	GUEST_ASSERT(0);
> +out:
> +	/*
> +	 * If the guest cannot grab a ucall structure from the pool then the
> +	 * only option to get out to userspace is a bare ucall. This is probably
> +	 * a good time to mention that guest assertions depend on ucalls with
> +	 * arguments too.
> +	 */
> +	GUEST_UCALL_NONE();

UCALL_NONE isn't much better than infinite stack recursion, e.g. a test might end
up passing by dumb luck, or go in the wrong direction because it sometimes handles
UCALL_NONE.

How about this?

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 9 Dec 2022 12:55:44 -0800
Subject: [PATCH] KVM: selftests: Use magic value to signal ucall_alloc()
 failure

Use a magic value to signal a ucall_alloc() failure instead of simply
doing GUEST_ASSERT().  GUEST_ASSERT() relies on ucall_alloc() and so a
failure puts the guest into an infinite loop.

Use -1 as the magic value, as a real ucall struct should never wrap.

Reported-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 0cc0971ce60e..2f0e2ea941cc 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -4,6 +4,8 @@
 #include "linux/bitmap.h"
 #include "linux/atomic.h"
 
+#define GUEST_UCALL_FAILED -1
+
 struct ucall_header {
 	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
 	struct ucall ucalls[KVM_MAX_VCPUS];
@@ -41,7 +43,8 @@ static struct ucall *ucall_alloc(void)
 	struct ucall *uc;
 	int i;
 
-	GUEST_ASSERT(ucall_pool);
+	if (!ucall_pool)
+		goto ucall_failed;
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (!test_and_set_bit(i, ucall_pool->in_use)) {
@@ -51,7 +54,13 @@ static struct ucall *ucall_alloc(void)
 		}
 	}
 
-	GUEST_ASSERT(0);
+ucall_failed:
+	/*
+	 * If the vCPU cannot grab a ucall structure, make a bare ucall with a
+	 * magic value to signal to get_ucall() that things went sideways.
+	 * GUEST_ASSERT() depends on ucall_alloc() and so cannot be used here.
+	 */
+	ucall_arch_do_ucall(GUEST_UCALL_FAILED);
 	return NULL;
 }
 
@@ -93,6 +102,9 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 
 	addr = ucall_arch_get_ucall(vcpu);
 	if (addr) {
+		TEST_ASSERT(addr != (void *)GUEST_UCALL_FAILED,
+			    "Guest failed to allocate ucall struct");
+
 		memcpy(uc, addr, sizeof(*uc));
 		vcpu_run_complete_io(vcpu);
 	} else {

base-commit: dc2efbe4813e0dc4368779bc36c5f0e636cb8eb2
-- 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
