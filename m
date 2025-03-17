Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62B423718D
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 10:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206441; cv=none; b=uipjJ9TSDyN35vCrDZa8cJA056BhYCP0ZVlD9wdRHdv3ZbRXipjfATiba/7Q2OCbg67yhcqRRJ2Y0xiJpAlTFROB+mMKCf1OkzyILYWWHgdQMjzO9kclf0aP2CJdwMh1zdC/Ee+nPe3DTikjCPPQrw0q6pcWcopgPMLlnlkt/u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206441; c=relaxed/simple;
	bh=C8ZKDv6FkFMfofUcLGU0v3SKi0zrd0R8M/pLyeWdZUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S4qEiJrmSvg07wBpxarlEHI8XXYtrUSiBEVCj4xHoQHnquiWr84ExB/58YmMU2cnr7UYf2CogoiUjnbUjaz587289QPjlE18FKIslEMDstGUiH1Rf/QHs+0EPzvP6rlKTLJg6F9gKgioZ1m5nzV9mX0ymGcD2+1Ht7iz9NxCCW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XkLpEo+l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XkLpEo+l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742206438;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tRBnMFtFaoL3oPsaYEgEoYjcIycECPlznLIMwEBWC2U=;
	b=XkLpEo+lJDRfwFDDP8SBBxdQG6FuNZa4oB9HyDPsMWovR0MJfxBEmF/86hmVivRmg6UX+W
	89MwjVoWsnrXl34HD1BkuFNrmzCzVgjXBwNkFBAFCjkH2L/QMwhi5NoqLs2Mt8yAIdbGF2
	mxoyRjfOdhB4W+ZUTXI4fsoeCdu8Nh4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-0A2HR8hcOVmE-WKJiBWcyg-1; Mon, 17 Mar 2025 06:13:57 -0400
X-MC-Unique: 0A2HR8hcOVmE-WKJiBWcyg-1
X-Mimecast-MFC-AGG-ID: 0A2HR8hcOVmE-WKJiBWcyg_1742206436
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c0b7ee195bso794891285a.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 03:13:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206436; x=1742811236;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tRBnMFtFaoL3oPsaYEgEoYjcIycECPlznLIMwEBWC2U=;
        b=O8Iwzwp7attg7+G0J2RB5nPZaJ0Gh0pkYZdmjmiJbC3l4kRK9+OuXrdIVtJBFuxfvJ
         FkM5EGLcA3BeNqSzS6sJWdRfK5VBGnoC5qmjStRKY/wKy8TboTnZESuJUcM+aUgQ+HKQ
         /lv/suFaA4GKorqOprEX6msJcfjQkw4TdRCD8Sz/jBD4rwPuB/84QiBodIV31VlmC4ej
         yAPXDWEh5wtfn3TfuXBaxtUuRbjKvclmk1NQ6C7S7UabgQCo3thE1kEuAhF305AscULS
         /ImX9IpuJafdAeAxqziRP3k55aMo5m6A1YmNwaqbgZFDOFjvRlwQP4sM0wq+qBbfN+14
         I5tw==
X-Gm-Message-State: AOJu0YyGTOhXeDiw1r+mN2tgxjctU0vnVxTXWlCEwCmsYyZz2h7GINPj
	FLBst7Opkr3fm8WiO4YFSiECGU9dK7s1W9qkdVRxI3VFB90u7hViGkxGNR5pdW0EhXFKJtOavbo
	zA/X5CrLUM5vaOhu3CYFwWINX3wiWCmMSXGn1c4XU9fEI/tOjbc4/gw==
X-Gm-Gg: ASbGncvrJ92HYnzB7fzXU4wW1ZO9nk6w3WAMHqYaX/8iUY2IavAZOmC1/ukHVE7gXus
	uttxOzu+78jMitB7sIZIBMOvtYinWu7Z3Ao5j21xrdU4r0wq0eTb5v+hVHeqbuiaO3WIpvey3/t
	rQTLGkRu7oqmCwzL1/jQPChXXMAqa3kBavxSRQg/khbCX45iJxyvj50N82R9HNYLLgMTJevqeBr
	bakWan3cvIeMM+oHnULeW5nNBvDKo5aBEa/f59tKxdNK41J18xExtic6sUekOwmXg0Em8eyymbh
	ohI1Ia7DNQB0Xf/pdZHrTyWgqDcfKG/H4sUpY2xSLHP0A6AzDJTI5RSVwlNevHE=
X-Received: by 2002:a05:620a:2948:b0:7c5:5768:40ac with SMTP id af79cd13be357-7c57c7c20f3mr1847836985a.30.1742206436610;
        Mon, 17 Mar 2025 03:13:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIOCaxHvQVjTZIrGZZ+aLZbn1xQMAi5UZQbQFIiZdjRyvxK5f639qijZj7sKktMuvUlWabOQ==
X-Received: by 2002:a05:620a:2948:b0:7c5:5768:40ac with SMTP id af79cd13be357-7c57c7c20f3mr1847834685a.30.1742206436273;
        Mon, 17 Mar 2025 03:13:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573c7d869sm566706385a.39.2025.03.17.03.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 03:13:55 -0700 (PDT)
Message-ID: <1ad28176-d564-4d62-898d-d1d80a2609b0@redhat.com>
Date: Mon, 17 Mar 2025 11:13:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default
 for TCG
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-7-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-7-jean-philippe@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bt8qyJhvTlLpymsFCYa3Z4bvfCl_pgQJ7E9js5TmZWQ_1742206436
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jean-Philippe,


On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> In order to test all the latest features, default to "max" as the QEMU
> CPU type on arm64.
>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/run | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arm/run b/arm/run
> index 561bafab..84232e28 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
>  			qemu_cpu+=",aarch64=off"
>  		fi
>  	elif [ "$ARCH" = "arm64" ]; then
> -		qemu_cpu="cortex-a57"
> +		qemu_cpu="max"
>  	else
>  		qemu_cpu="cortex-a15"
>  	fi

