Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C87C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 10:04:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0914B815;
	Sat, 12 Nov 2022 05:04:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7gMyV0qyotDP; Sat, 12 Nov 2022 05:04:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 325DE4B6DF;
	Sat, 12 Nov 2022 05:04:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A61104B6DF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 05:04:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lNwNRyyes1UI for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 05:04:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 685DB4B6B7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 05:04:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1668247482;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YNPWveXNga0scY6/51aebupOAjiaIyJv8HXR04747GY=;
 b=Sz9OM92T0p5NMjzz5llRz0IGTk0fPozFFYTT06RKVRXzkWIb0u5LDAlsXtg8/6UnkEvCjL
 w/IybcIo4m86pf6rcamfWeWc5CUjQ9/gCYog8K6K3+bNyLhgB4jC6+wHSy5X/97uNCkW5D
 wPld/j+dwz+sC3q9hbx6WvwtsVl/93E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-23T7CmQMMxq2btIs--dQOw-1; Sat, 12 Nov 2022 05:04:37 -0500
X-MC-Unique: 23T7CmQMMxq2btIs--dQOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03D85101A528;
 Sat, 12 Nov 2022 10:04:37 +0000 (UTC)
Received: from [10.67.24.81] (unknown [10.67.24.81])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A8B8202322E;
 Sat, 12 Nov 2022 10:04:31 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: selftests: Build access_tracking_perf_test for
 arm64
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
References: <20221111231946.944807-1-oliver.upton@linux.dev>
 <20221111231946.944807-3-oliver.upton@linux.dev>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <8a578b9d-b2a8-a1f9-2a8c-c0109c863723@redhat.com>
Date: Sat, 12 Nov 2022 18:04:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20221111231946.944807-3-oliver.upton@linux.dev>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
> Does exactly what it says on the tin.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   tools/testing/selftests/kvm/Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 0172eb6cb6ee..4c0ff91a8964 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -156,6 +156,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/psci_test
>   TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
>   TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>   TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
> +TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
>   TEST_GEN_PROGS_aarch64 += demand_paging_test
>   TEST_GEN_PROGS_aarch64 += dirty_log_test
>   TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
