Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38621D3FE
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 08:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200261; cv=none; b=liX8bhN41eMGtFLeE19nADwTaVci6nN7F/TXwSjfvIUieV9dBFXgKbd51PHa+XOWL8dIqg3ucvwlu+MRLoVqc7cqagSigTyPxM4ZeiGQZM0c0FiqpuSXV3HEAXepXQdxaCOEcM6F35lquYJLcLG2dv7/SV6YRLZgLX9XRE7jOPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200261; c=relaxed/simple;
	bh=Xn19XTUr5ev5X1WgzYXlLi6OfNH9omI0wHFJgrgHR4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RdJsQfhJh2h9AMhrVREGDEBQt3Q+jSGdH9Sh+Vi7GIvDgfq1BtLg+lPTo09CLl3G5HuqrolKp56JuCum25nyouUI05gR6NAkBf6ptn5KBW7aZ5Vb0s3tDxAM03YCJWhpb+2YbVj+7YrdlHSrnp5JPC8S0FGc2q4K/1rhsr8ndSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gGnwQi4U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGnwQi4U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742200259;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1e1w7vkGVe2zlHjiuKVaRcK3voy6SpJyKXoctlZSYQI=;
	b=gGnwQi4Uld/CwUHGsjeFf+IqdbFLJ2VFQPGirBb3g3nG+2fiW7n1p73ucQl3TjusxLj0Cr
	wKfAhEDgkAyDB7w6Sh1wtg44yLuAPVYE+OihpKPyxHLB62ebH4mX/vuHDIbBKWK1cA+G24
	gRpVWrX53y6FtjGxIeboFcPhlJLF640=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-zW4cjWo9NnudpIizSdaLBw-1; Mon, 17 Mar 2025 04:30:57 -0400
X-MC-Unique: zW4cjWo9NnudpIizSdaLBw-1
X-Mimecast-MFC-AGG-ID: zW4cjWo9NnudpIizSdaLBw_1742200257
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-85b48bd978cso437113539f.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 01:30:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742200257; x=1742805057;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1e1w7vkGVe2zlHjiuKVaRcK3voy6SpJyKXoctlZSYQI=;
        b=aA/GYnLlzKJW/5B2L4q27VRjCF/yf4+SaKVH8HGXRtSWW0IROQJsAPV0F/zrEnNYt9
         ym3qc4w8K/RIxjRx/SheUA7uEyg1jF0WbT3YbhjAIE1o+GBWLzTMmkqNNdhe8bhPs7Ra
         8/6m2bHwtys+74RuGLph11E4hqZvx8GIiaRUeJMst+2LPzGoT2XoVLRlKyS9nmDnsR+T
         WO4dIMNXTOg6aNusWk0GjtBNHoYWcrmXvJ1xkvNLZKVap72pexsWQIITr8apPo/6prLb
         JGXdYkWHcRrf/3JgYOkFb5TrOzMiuHpy8LRjTbiRH0zm8CtdIGtX/BWNpD3rkPxx+iri
         ntzA==
X-Gm-Message-State: AOJu0Yyg6HM3aRbbXDJRFAi6qs71PNRbKKqqEDnggV5wj+fEn+xdFryK
	FxVNZIfoHPEehnAZovjgrrjxmrAAaGuN1enC/nBgSQDS1EW8YkhtSBao/CdYL07tKVoNl/sAtg0
	Ll3YDCilMtSnc9EWGYUPU77wSwHzj0nZR/fBTuaWmKbAhfsUhwyfBJg==
X-Gm-Gg: ASbGncu2pU8F7g1WRgHRoge5DfUyLa7zxgVN3L2PI9mAVvLJSTgZiqd5biLpIR+nJQ6
	mW2qs47No8BFomcXiQ/hvxdOyXuKwRNMGEr8kpfgRBqnxniB9AxX8UHzWOMGgj0SlhXB6FTKpEi
	VNg5amwwUSnRXtCb7Vg7RKFmyWmzoVUhPovEh/SqL3BmIwwzm+knJz9S+y3seV1kGkQQFLVQTO8
	n2zXNLo1mxJaaz/mr2s/s3h5qSXtnzhLC3is7shPcKaHMU/S+k+Ha+ELaPMZWPXZCn+t0Q//IBj
	RQtLWpKjTGhPD6c9q0ohiVchpqRPZkyWCzs6saHe2NT9QrzknVHYCcnxaIfMMxE=
X-Received: by 2002:a05:6e02:3285:b0:3d0:bd5:b863 with SMTP id e9e14a558f8ab-3d483a82c1amr138000905ab.20.1742200257033;
        Mon, 17 Mar 2025 01:30:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHWx2BOAFHAQf6kpPdPpo9RU9ar3l1mcm+p8VJlq5wP/AXtSk7y90EOST3/f9LTxyG//NWIw==
X-Received: by 2002:a05:6e02:3285:b0:3d0:bd5:b863 with SMTP id e9e14a558f8ab-3d483a82c1amr138000645ab.20.1742200256699;
        Mon, 17 Mar 2025 01:30:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fb2b2sm2162086173.94.2025.03.17.01.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:30:55 -0700 (PDT)
Message-ID: <312bfffa-8e91-4b64-b88e-c9868a59d7ec@redhat.com>
Date: Mon, 17 Mar 2025 09:30:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/5] configure: arm/arm64: Display the
 correct default processor
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-4-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-4-jean-philippe@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Fa06Ag5rmM9aXU3Dyw-EjnPSb_50Z4trzyyb5B7fpCU_1742200257
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> The help text for the --processor option displays the architecture name as
> the default processor type. But the default for arm is cortex-a15, and for
> arm64 is cortex-a57. Teach configure to display the correct default
> processor type for these two architectures.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
*
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

*
> ---
>  configure | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
>
> diff --git a/configure b/configure
> index dc3413fc..5306bad3 100755
> --- a/configure
> +++ b/configure
> @@ -5,6 +5,24 @@ if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
>      exit 1
>  fi
>  
> +function get_default_processor()
> +{
> +    local arch="$1"
> +
> +    case "$arch" in
> +    "arm")
> +        default_processor="cortex-a15"
> +        ;;
> +    "arm64")
> +        default_processor="cortex-a57"
> +        ;;
> +    *)
> +        default_processor=$arch
> +    esac
> +
> +    echo "$default_processor"
> +}
> +
>  srcdir=$(cd "$(dirname "$0")"; pwd)
>  prefix=/usr/local
>  cc=gcc
> @@ -43,13 +61,14 @@ else
>  fi
>  
>  usage() {
> +    [ -z "$processor" ] && processor=$(get_default_processor $arch)
>      cat <<-EOF
>  	Usage: $0 [options]
>  
>  	Options include:
>  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
>  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> -	    --processor=PROCESSOR  processor to compile for ($arch)
> +	    --processor=PROCESSOR  processor to compile for ($processor)
>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
> @@ -319,13 +338,8 @@ if [ "$earlycon" ]; then
>      fi
>  fi
>  
> -[ -z "$processor" ] && processor="$arch"
> -
> -if [ "$processor" = "arm64" ]; then
> -    processor="cortex-a57"
> -elif [ "$processor" = "arm" ]; then
> -    processor="cortex-a15"
> -fi
> +# $arch will have changed when cross-compiling.
> +[ -z "$processor" ] && processor=$(get_default_processor $arch)
>  
>  if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>      testdir=x86

