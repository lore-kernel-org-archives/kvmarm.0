Return-Path: <SRS0=eGRX=V6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDEEC32750
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 10:46:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DFE3D20B7C
	for <kvmarm@archiver.kernel.org>; Fri,  2 Aug 2019 10:46:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFE3D20B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F65A4A54E;
	Fri,  2 Aug 2019 06:46:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id znPXctwUfWqT; Fri,  2 Aug 2019 06:46:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F3874A52F;
	Fri,  2 Aug 2019 06:46:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB4774A52B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 06:46:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id za+y-O+i+ZbJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Aug 2019 06:46:34 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A541F4A4CD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Aug 2019 06:46:34 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id p17so76664537wrf.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Aug 2019 03:46:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=8nHVa+8uGKdtX3pSY7JjerDZijsdBHPkAyPWVC/nVmk=;
 b=ALl5DaHlTnBKPvXfedp3HOfwTRJnIQIDus9kjgvA8VUBTOv+Ba1oPR1/P+Fkm32mpv
 7yQKc+3UhH0yMksyBFelHcWtrHBDh1cRA93x4P01M427S4iwmsiLuvK0Wlj60eGy5ECO
 A3nkB1GTMXBWjhUVOIhpdhPs5hqBPRW23kGt8VRiubaXbLI54WS11JZMQVGg8e2IHUL1
 rkqvAHrCkQwDGFIMw0ThFPJLpwMgcn8KKXd9fZ4pCtqGN61ZihCk07A4UWr2LEMh24B4
 HguJcowtskfBtL4lDx5m0DxCKxqvlBzx4rO2pWqhGLrFYWO0WTPoXuhe7cTBZ3SvNI3X
 iDEA==
X-Gm-Message-State: APjAAAXNgbFHPuEiEagxV3kcw+cUX/inAlJDnQbtk862JFb8EhWtilTb
 eLIujnxNrQ+iaSU1W2RemQg/x1OSb3g=
X-Google-Smtp-Source: APXvYqweacgUco11b5+iiklsZr3HnubI3sddSf7PjrsWTggPB1b/KH1PZW2FxQ0WyAeTEVE3WuJUPQ==
X-Received: by 2002:a5d:4484:: with SMTP id j4mr3719539wrq.143.1564742793492; 
 Fri, 02 Aug 2019 03:46:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff?
 ([2001:b07:6468:f312:4013:e920:9388:c3ff])
 by smtp.gmail.com with ESMTPSA id l9sm58540760wmh.36.2019.08.02.03.46.32
 (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
 Fri, 02 Aug 2019 03:46:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: Call kvm_arch_vcpu_blocking early into the
 blocking sequence
To: Marc Zyngier <maz@kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>, Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
 Tangnianyao <tangnianyao@huawei.com>
References: <20190802103709.70148-1-maz@kernel.org>
 <20190802103709.70148-3-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a7250b9a-60e9-b04c-5515-e506aea46515@redhat.com>
Date: Fri, 2 Aug 2019 12:46:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802103709.70148-3-maz@kernel.org>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On 02/08/19 12:37, Marc Zyngier wrote:
> When a vpcu is about to block by calling kvm_vcpu_block, we call
> back into the arch code to allow any form of synchronization that
> may be required at this point (SVN stops the AVIC, ARM synchronises
> the VMCR and enables GICv4 doorbells). But this synchronization
> comes in quite late, as we've potentially waited for halt_poll_ns
> to expire.
> 
> Instead, let's move kvm_arch_vcpu_blocking() to the beginning of
> kvm_vcpu_block(), which on ARM has several benefits:
> 
> - VMCR gets synchronised early, meaning that any interrupt delivered
>   during the polling window will be evaluated with the correct guest
>   PMR
> - GICv4 doorbells are enabled, which means that any guest interrupt
>   directly injected during that window will be immediately recognised
> 
> Tang Nianyao ran some tests on a GICv4 machine to evaluate such
> change, and reported up to a 10% improvement for netperf:
> 
> <quote>
> 	netperf result:
> 	D06 as server, intel 8180 server as client
> 	with change:
> 	package 512 bytes - 5500 Mbits/s
> 	package 64 bytes - 760 Mbits/s
> 	without change:
> 	package 512 bytes - 5000 Mbits/s
> 	package 64 bytes - 710 Mbits/s
> </quote>
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/kvm_main.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 887f3b0c2b60..90d429c703cb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2322,6 +2322,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	bool waited = false;
>  	u64 block_ns;
>  
> +	kvm_arch_vcpu_blocking(vcpu);
> +
>  	start = cur = ktime_get();
>  	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
> @@ -2342,8 +2344,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  		} while (single_task_running() && ktime_before(cur, stop));
>  	}
>  
> -	kvm_arch_vcpu_blocking(vcpu);
> -
>  	for (;;) {
>  		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
>  
> @@ -2356,9 +2356,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  
>  	finish_swait(&vcpu->wq, &wait);
>  	cur = ktime_get();
> -
> -	kvm_arch_vcpu_unblocking(vcpu);
>  out:
> +	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
>  	if (!vcpu_valid_wakeup(vcpu))
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
