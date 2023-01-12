Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC50BD18
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 09:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673516309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwHsnc1Ec0AxqpE9AphsrdbS365Zamo3ZBVtwHr8mbI=;
	b=AwPEpSURNQ/xtQCN6vIEaXs2UrwQULQND7v37I0WrnhUsIwYrACF7qM1bODqdO/Hdco66p
	dY1fEeK9RT8v7esqV7+7imBosXor2rHLS28wKxaKblYj+Dz8XBd1Tmr8vXQTQEXFWfzYie
	6xu1D18ArwIJli3xX9yiHqVrSvi3e84=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-68-v78Wibm8NqqzCr-m_u_qdQ-1; Thu, 12 Jan 2023 04:38:26 -0500
X-MC-Unique: v78Wibm8NqqzCr-m_u_qdQ-1
Received: by mail-wr1-f71.google.com with SMTP id t2-20020adfa2c2000000b002bbdae91832so2858374wra.21
        for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 01:38:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fwHsnc1Ec0AxqpE9AphsrdbS365Zamo3ZBVtwHr8mbI=;
        b=pRmzWoZCA+5OPqyMWWQTTgS3ijvVq69zKboaRB65AJ5+29s8icHgjxPOM7GCn7HQkx
         u778JQbbIKutludEM68FuqY051/8aah07mEs/TEUtUCBBTSqWET0l+Q3/NRnj8VwTFJT
         j6oHni2Rfu/oMOqEbA4cnBTlpPa/V1gxeo07hi0uBlbl9v1T9N5ncg0HWndBSFOncpoY
         A/B3xmBuy2IhMXI1/XGCoi7+iE28vasGxvpF7iSvSThF/PIpVaGh74cNbhPqUEpCvO8G
         roDMR2gTXMCHU0APNpyYIBBz2JqrAdRzu6H7drjHh101uoH4nVWSmn2TZVzBucJPOfLr
         fmEw==
X-Gm-Message-State: AFqh2kqtJwnL5b0fP6EXC/wC9mN+EVRiSPdiB0YxXAIw4PPtMyfDP7q7
	sFwpMiRoTr+Dl5DXOR5hsKqIr4s8bfsHHMmm+Vf++K6gNcx4l6Imv3jT9wAMW8568ICRpTB8BAS
	2wi9gD4py9U0XMcFU
X-Received: by 2002:a7b:c7d3:0:b0:3d9:f1b6:9110 with SMTP id z19-20020a7bc7d3000000b003d9f1b69110mr10670452wmk.13.1673516305089;
        Thu, 12 Jan 2023 01:38:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsVJnkbWi9Nw8LsYrb0JksFFQ3lmCwiT9IZb3GI3xbSZMjYaugnpPEdIEpVsJUSGemPgUKbPg==
X-Received: by 2002:a7b:c7d3:0:b0:3d9:f1b6:9110 with SMTP id z19-20020a7bc7d3000000b003d9f1b69110mr10670442wmk.13.1673516304870;
        Thu, 12 Jan 2023 01:38:24 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-128.web.vodafone.de. [109.43.177.128])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c510900b003c6f8d30e40sm29081731wms.31.2023.01.12.01.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 01:38:24 -0800 (PST)
Message-ID: <62580f66-1bbd-1a7f-c1fa-53dbf51577ec@redhat.com>
Date: Thu, 12 Jan 2023 10:38:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v2 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
To: Colton Lewis <coltonlewis@google.com>, pbonzini@redhat.com,
 nrb@linux.ibm.com, andrew.jones@linux.dev, imbrenda@linux.ibm.com,
 marcorr@google.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20230111215422.2153645-1-coltonlewis@google.com>
 <20230111215422.2153645-2-coltonlewis@google.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230111215422.2153645-2-coltonlewis@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/01/2023 22.54, Colton Lewis wrote:
> Replace the MAX_SMP probe loop in favor of reading a number directly
> from the QEMU error message. This is equally safe as the existing code
> because the error message has had the same format as long as it has
> existed, since QEMU v2.10. The final number before the end of the
> error message line indicates the max QEMU supports. A short awk
> program is used to extract the number, which becomes the new MAX_SMP
> value.
> 
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.
> 
> A previous comment explains the loop should only apply to kernels
> <=v4.3 on arm and suggests deletion when it becomes tiresome to
> maintian. However, it is always theoretically possible to test on a
> machine that has more CPUs than QEMU supports, so it makes sense to
> leave some check in place.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   scripts/runtime.bash | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f8794e9..4377e75 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -188,12 +188,10 @@ function run()
>   # Probe for MAX_SMP, in case it's less than the number of host cpus.
>   #
>   # This probing currently only works for ARM, as x86 bails on another
> -# error first. Also, this probing isn't necessary for any ARM hosts
> -# running kernels later than v4.3, i.e. those including ef748917b52
> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
> -# point when maintaining the while loop gets too tiresome, we can
> -# just remove it...
> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> -		|& grep -qi 'exceeds max CPUs'; do
> -	MAX_SMP=$((MAX_SMP >> 1))
> -done
> +# error first. The awk program takes the last number from the QEMU
> +# error message, which gives the allowable MAX_SMP.
> +if $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> +      |& grep -qi 'exceeds max CPUs'; then
> +	GET_LAST_NUM='/exceeds max CPUs/ {match($0, /[[:digit:]]+)$/); print substr($0, RSTART, RLENGTH-1)}'
> +	MAX_SMP=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& awk "$GET_LAST_NUM")
> +fi

Is that string with "exceeds" really still the recent error message of the 
latest QEMU versions? When I'm running

  qemu-system-aarch64 -machine virt -smp 1024

I'm getting:

  qemu-system-aarch64: Invalid SMP CPUs 1024. The max CPUs
  supported by machine 'virt-8.0' is 512

... thus no "exceeds" in here? What do I miss? Maybe it's better to just 
grep for "max CPUs" ?

  Thomas

