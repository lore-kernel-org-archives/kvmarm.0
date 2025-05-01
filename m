Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3294F22FDE2
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 02:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068260; cv=none; b=a7iN03Eb9vzSKC5/3lHjC4HaxUy4gkWGh1k+/w7woXpOGEUCtanE6EWYQ9w75RGevKdLXxPvCwgPU8QCMGxlhmTz7ZYWRC7HF2XoLP2ZH8K0are6l1nvh+RuBA4FVhPdQFVma9Yq71jzEpcbfWBykdR6KqfsXLIvU1kxVz5cNuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068260; c=relaxed/simple;
	bh=pxth/1xDNWc+yIhoqkRG3JLP0W+Nj7wVL5JFRfk8L2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GpU3Xw27mXMG18EumUrZUTOiXqRdtNlvXfyb0PafDvS/HHmUkKW/K0tsPb9I32kGOG3fX6S3+zw5dbim8J5Ja+U8Oj11ZZfNJJf8fzGsjLWwGKIv34TDlyCszCbSYPX+3r0mmjlCWG63gvEENSaONN6mBIyI48D1/MtXgselB9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fdum9Kz1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fdum9Kz1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=adT5sphxyEt5TU22Dqx/wn9ELnNmdh1UTMCrVtoQyks=;
	b=Fdum9Kz18wDWCdlodM7GCdFghapE657zwBQ6F7TaJ2KzrWfZXZUNJwMyp5u+ZYhao3w/ui
	92fwwR1p+LQYSJy7bYyJ+fY2AYQhPDwrbQY/8YdUO63z8RvwKz53/+/p2jT6XnMGqixTV8
	eOku28gUi7YUQyYk3fmNuBK5lxxMzwE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-WvnG7SL6PQCOWseXVeCQfQ-1; Wed, 30 Apr 2025 22:57:34 -0400
X-MC-Unique: WvnG7SL6PQCOWseXVeCQfQ-1
X-Mimecast-MFC-AGG-ID: WvnG7SL6PQCOWseXVeCQfQ_1746068253
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-afd3f1adff7so1193408a12.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 19:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068253; x=1746673053;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=adT5sphxyEt5TU22Dqx/wn9ELnNmdh1UTMCrVtoQyks=;
        b=g84bKtjqtpaJ66s3WqP1JAS5Dfa0WR3Gw/E9nBThLrc9iQZxv8pLo59iBZ9DYCUoXK
         nVrsWsFYS3Bv8AD+qhA4Qn5SexNRxDy4kn41IXtwhSVnkol8hSY/1BxrHbhYL0pc1TyW
         +yMAFQyYo/+T4rjdZ5iaZ7306/uguoky1eBK3/dbEdyEA9sqKyRglnwETBzcZ5YzGpvr
         LBgFJgu3+8BR0Pq++DiikFz3XLEKiGJs1H72Ey0CubHz2MTT4rvQZPrD3kNDV5aTgxDa
         4muA9VLYiXhBwPWIN0p+kP+sU0N0TcWpYoOqDuByJ281a9waz+P1h9iD/az+swSyHyJY
         JQzw==
X-Forwarded-Encrypted: i=1; AJvYcCXpC0IKd22B3Imo4Hut1Vof6T3BPKqLBAEc00aOZ3XaKfJDdANOoKMWTwJAn4stKiGekikqp4Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzyx7ynz4826WhGSvzpjYAGYRbtQepTJ6Tl0oze8wI1XlwY6EVa
	J30GP7KzaWQryK4+v/qpFkb0pTrccNdT75wfW5smr8bWz6yEvY6y8gADyvOhzQaDgc1XKppRn7t
	MC0XDRLpAFtFMa5e1ajGbXllhN26+fxT1256e8lUmcbSWbA7e1oCa4A==
X-Gm-Gg: ASbGncu4l74IEaJHCMYm4f+Zm5vrAvautvFDyl9JjLEecn6hFLQFY6sb5wtJeN+W5em
	g9+KIXeTFtWVgr92BQWX6RcaZcgs1BWIApuMdOilzcCqpjHu9tFpfBNdxZRCYYx6tc0R2S+EIN+
	0niq3ZYmtZ+UbakQPQZIeEM3SiyiDnLXORF+R0EYhUgADnIh5MU9OsJ35u8SQcP+VfaJLEfsKZr
	GKFmt9daYt5KOtUoiIzgqvnp8oR8F/1tlTqd+A2MoEgDAg5f6/fQQBKYb/+ydIBJVDRiHpwVrUF
	xs7zYCBwUKaP
X-Received: by 2002:a05:6a21:9982:b0:1fe:8f7c:c8e with SMTP id adf61e73a8af0-20bdcd9a950mr1117792637.15.1746068253310;
        Wed, 30 Apr 2025 19:57:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbH4/Gw3xjrMySuSbtOSRK/2O61f3IZwIB6ICzlmAJxo3vX/hkeDxt9OR3pskpgqpIhEiucg==
X-Received: by 2002:a05:6a21:9982:b0:1fe:8f7c:c8e with SMTP id adf61e73a8af0-20bdcd9a950mr1117766637.15.1746068253021;
        Wed, 30 Apr 2025 19:57:33 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740398f9786sm2578662b3a.15.2025.04.30.19.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 19:57:32 -0700 (PDT)
Message-ID: <afe9167c-8867-4e5f-8c0b-eb8d6b2813e1@redhat.com>
Date: Thu, 1 May 2025 12:57:24 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 27/43] arm64: RME: support RSI_HOST_CALL
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-28-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-28-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: baXPznm2CgbFF9psqfR85VyXtvSPZk5oTvj0vUviO9g_1746068253
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Forward RSI_HOST_CALLS to KVM's HVC handler.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Avoid turning a negative return from kvm_smccc_call_handler() into a
>     error response to the guest. Instead propogate the error back to user
>     space.
> Changes since v4:
>   * Setting GPRS is now done by kvm_rec_enter() rather than
>     rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
>     enter/exit). This fixes a bug where the registers set by user space
>     were being ignored.
> ---
>   arch/arm64/kvm/rme-exit.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

