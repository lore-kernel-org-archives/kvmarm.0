Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EA537B71
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 13:59:10 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-56942442eb0so90498937b3.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 06:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686059949; x=1688651949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gn/dFH22odtX6QmxBFqPjy05b5sFU03Muxh5Wl7MUWY=;
        b=TWSahW0vclogrCSwDkxLN7KbfBui2xZPFmRmleHMQtHFfaCSNrPPzfDjDqHXfb6jlC
         fGl1bvZdtJcTcY6w1eZ64W2sAMLQ1lsW8DXHUQatb3MzPz3fsz06PWlOa6FQXJoGZOYA
         D9Y49O2nk9w4ZqIYXDWbCv8nCwuENtkoOLDtWGMJbWbkFCZv8h/rW+tgIiX6dk+ZzBr6
         TDSdTYmuEVMTm1g2U8mUkCG8KJkliOEIsTB2IULTwYnETUGgH8imNWo0bUMVY1FmRCKN
         2UhxoTpquppB32KtCK0gxsdMntNHVQL7Q/9wSyEeqDJ2Tv8JnPZ1a5E97/VEfkG+OZf0
         +JTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686059949; x=1688651949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gn/dFH22odtX6QmxBFqPjy05b5sFU03Muxh5Wl7MUWY=;
        b=GS5XSNb03Dk7nxo5X71XIjkEkvjyy7cp9SS7hZe8jmWvc8a3a9SlrWLM4asxrpipQJ
         i6Qc5aNTQbqRwqQptahiyB4GsSF+dJ0Dn+JigG7nZ01ize6Ia9Fl0R6PBewPKPSyi0ac
         3op+TJNdI6eqV0MncJobUDcUrf5TqqQf5x2g/hw1Pl8aIbUmD+Qjwo4c8iHqqitE7OmJ
         Khexri9uDNn1vZydwHrckmOk5nel6gY8E5AtCAS/bhdE7Xk6meHM/PXbFWMAzpD/acxu
         wBXB1onVowv5PPyw66/gy2Ehgvw5MEmIO6fOcrmsSMQ3QDq+ID3IXRGnEpNf1ae0uQR5
         +DEg==
X-Gm-Message-State: AC+VfDyfJ9EsXAVhiqY7ufuhM69RTP7cfNjK1SlI3efR28n8SHzgAiYR
	INNJXbNxbdiVIclmxkTqQmHprYuJBqY=
X-Google-Smtp-Source: ACHHUZ6/D/quV4fAtDjo6gBujt5UE2X+Hx20Ph0wcv5OeWnrjKAnqhhJ2HIJEjaFM6gSsFSJeQer8lrw+gI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b1c4:0:b0:565:a43e:23c7 with SMTP id
 p187-20020a81b1c4000000b00565a43e23c7mr1077489ywh.0.1686059949165; Tue, 06
 Jun 2023 06:59:09 -0700 (PDT)
Date: Tue, 6 Jun 2023 06:59:07 -0700
In-Reply-To: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
Message-ID: <ZH87qwYqtUM5eG2H@google.com>
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible context
From: Sean Christopherson <seanjc@google.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 06, 2023, Sebastian Ott wrote:
> Fixes: 1c913a1c35aa ("KVM: arm64: Iterate arm_pmus list to probe for default PMU")
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 491ca7eb2a4c..f9e4e4334875 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -700,6 +700,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
> 
>  	mutex_lock(&arm_pmus_lock);
> 
> +	preempt_disable();

get_cpu() + put_cpu() would be more succinct and self-documenting.

>  	cpu = smp_processor_id();
>  	list_for_each_entry(entry, &arm_pmus, entry) {
>  		tmp = entry->arm_pmu;
> @@ -709,7 +710,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
>  			break;
>  		}
>  	}
> -
> +	preempt_enable();
>  	mutex_unlock(&arm_pmus_lock);
> 
>  	return pmu;
> -- 
> 2.40.1
> 
