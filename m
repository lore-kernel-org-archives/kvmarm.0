Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FE2C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 15:30:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C78EE61288
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 15:30:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C78EE61288
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B22E4B116;
	Tue, 28 Sep 2021 11:30:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tDZOOG+wkjfD; Tue, 28 Sep 2021 11:30:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05B924B10A;
	Tue, 28 Sep 2021 11:30:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC8A54B0DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:30:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vS-3QOJi8m01 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 11:30:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0BAB4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:30:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632843031;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8nfUMXC+UekTv9Q+thQkucTYO8+JG8hE9EwxakRMNd0=;
 b=Psi50dYZ3clqCQ2EIaZZAa6fsif4E2oz+azvVq2Q/5plXIsXMoLVZ6cs+/J8yKZAEKtj0I
 m6C9+xRTxXSQSq37uKWhUpmROd+HMJYf1BwsFq5SfefIIH/J1LvRmw7qAv+hqWX2phcZF6
 cwcrEp/MS5Fe2ym2ra+DDO1/Z/AyTPU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-9_FXM52LMMKT_jDyOs-AYQ-1; Tue, 28 Sep 2021 11:30:30 -0400
X-MC-Unique: 9_FXM52LMMKT_jDyOs-AYQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 c7-20020a05640227c700b003d27f41f1d4so22189818ede.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 08:30:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=8nfUMXC+UekTv9Q+thQkucTYO8+JG8hE9EwxakRMNd0=;
 b=YWtMdo8YU9EHC1Utbtasm0XRzcTPyYddgDJaPfkopbF7QDRiURRytPuYx/5uiGcM6e
 YP2KLug/gntI/R77Csyu1f+4s8yj8+cQPQyesz/dr4YOBnUYPi4f0zgqaVYrovrqC+42
 0CEniEv8U4MVwfSCjORcpEWF+xm7M5v5Zr74WA7MR2wBXuM0n0K4ch3yT+55XgYrWg6h
 BDUCFA2+vThSeACmen5uOfTmu4mmXzmGQ2CUTelpwRKO2k9pFebVKuQRiKIspi2mHnKl
 gfTXBIlgewopbCXINFnZ/k3cZov+4lvCsLqMbQBaEIZU6Cyov7NNAxX938HtrzHdfikE
 q0ZA==
X-Gm-Message-State: AOAM5303h+xin/pef/SCdFJrOI90Hes1kdujNc5GT1dw5/HGl/lvs8B7
 hQCZBKxkppYTDQrmjlEuEVFKU+TNEyKRatt6rg6zZJvQcjf1b119YA97tvymBzx7x4bpgisiYf+
 3bAq5auaMph7yiKB2dqJ3vcB0
X-Received: by 2002:a50:d90b:: with SMTP id t11mr8138903edj.215.1632843028990; 
 Tue, 28 Sep 2021 08:30:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwx0Zed07mMfNcMPJp44ILJOmNEJ8xvPdh0FNEGA01duLwFDm+toq4CLSk2QmPp61IoqnU0Q==
X-Received: by 2002:a50:d90b:: with SMTP id t11mr8138886edj.215.1632843028825; 
 Tue, 28 Sep 2021 08:30:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id d22sm10729845ejk.5.2021.09.28.08.30.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Sep 2021 08:30:28 -0700 (PDT)
Message-ID: <5fedbea6-4485-5de7-1a46-3646390931c2@redhat.com>
Date: Tue, 28 Sep 2021 17:30:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210923220033.4172362-1-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210923220033.4172362-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Jim Mattson <jmattson@google.com>
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

On 24/09/21 00:00, Oliver Upton wrote:
> While x86 does not require any additional setup to use the ucall
> infrastructure, arm64 needs to set up the MMIO address used to signal a
> ucall to userspace. rseq_test does not initialize the MMIO address,
> resulting in the test spinning indefinitely.
> 
> Fix the issue by calling ucall_init() during setup.
> 
> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 060538bd405a..c5e0dd664a7b 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
>   	 * CPU affinity.
>   	 */
>   	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +	ucall_init(vm, NULL);
>   
>   	pthread_create(&migration_thread, NULL, migration_worker, 0);
>   
> 

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
