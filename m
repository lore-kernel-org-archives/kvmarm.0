Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31D7C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 10:04:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B55E4B828;
	Sat, 12 Nov 2022 05:04:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ECYaGzgj-KXL; Sat, 12 Nov 2022 05:04:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F28404B812;
	Sat, 12 Nov 2022 05:04:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0856C4B80A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 05:04:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ooeSvxtXrWt for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 05:04:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7F24B6DF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 05:04:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668247443;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5W9bu2hFI7xLEfEbbLNcIU/JquM0rgAJhzv8BY8pipY=;
 b=f4K+rxY569Ri4dQptv2qXvmQcryIKKOQgdfvNVJRpvcBHH64Cw0/STAXRMdVY7uT2IcqFf
 40elGVM7lIkdevbrKnGgR4mq5p+dm6BMbCiPqBwAbEuzt0Tj8LDzEYsk9kb4M91x0nc9mN
 voF4riOQolHylsn2KL1Ltf0BRdPKyzA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-yuQJI4_1O2ebcW8-0pDPuw-1; Sat, 12 Nov 2022 05:03:57 -0500
X-MC-Unique: yuQJI4_1O2ebcW8-0pDPuw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4D3F3C02585;
 Sat, 12 Nov 2022 10:03:56 +0000 (UTC)
Received: from [10.67.24.81] (unknown [10.67.24.81])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 045DB1121330;
 Sat, 12 Nov 2022 10:03:50 +0000 (UTC)
Subject: Re: [PATCH 1/2] KVM: selftests: Allow >1 guest mode in
 access_tracking_perf_test
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
References: <20221111231946.944807-1-oliver.upton@linux.dev>
 <20221111231946.944807-2-oliver.upton@linux.dev>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <1024da03-46f6-b82f-0c17-ca1d95dd171b@redhat.com>
Date: Sat, 12 Nov 2022 18:03:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20221111231946.944807-2-oliver.upton@linux.dev>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-kselftest@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

On 11/12/22 7:19 AM, Oliver Upton wrote:
> As the name implies, for_each_guest_mode() will run the test case for
> all supported guest addressing modes. On x86 that doesn't amount to
> anything, but arm64 can handle 4K, 16K, and 64K page sizes on supporting
> hardware.
> 
> Blindly attempting to run access_tracking_perf_test on arm64 stalls on
> the second test case, as the 'done' global remains set between test
> iterations. Clear it after VM teardown in anticipation of a subsequent
> test case.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   tools/testing/selftests/kvm/access_tracking_perf_test.c | 3 +++
>   1 file changed, 3 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index 76c583a07ea2..4da066479e0a 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -326,6 +326,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   
>   	perf_test_join_vcpu_threads(nr_vcpus);
>   	perf_test_destroy_vm(vm);
> +
> +	/* Clear done in anticipation of testing another guest mode */
> +	done = false;
>   }
>   
>   static void help(char *name)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
